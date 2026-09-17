---
type: design
date: 2026-09-15
status: draft
owner: shared
---

# Database Design

## Summary

Postgres 16 + pgvector 단일 인스턴스에 정형 데이터와 벡터 데이터를 함께 둔다.
테이블 9개로 시작하며, 공용 지식과 개인 지식은 테이블 자체를 분리한다.

## Context

[[tech-stack-selection]]에서 직접 운영하는 Postgres를 확정했고,
[[data-isolation-policy]]에서 격리를 쿼리 코드로 강제하기로 했다. 이 문서는 그 구조를
스키마로 옮긴 것이다.

데이터 성격에 따라 저장 방식이 갈린다 — 비정형 문장은 벡터, 정형 행은 일반 테이블.
정형 데이터를 임베딩하면 집계·범위·좌표 계산이 구조적으로 불가능해진다.

## Details

### 마이그레이션 파일

| 파일 | 내용 |
|---|---|
| `migrations/001_init.sql` | 앱 테이블 9개 + `vector` 확장 |
| `migrations/002_authjs.sql` | Auth.js 어댑터 테이블 4개 |

GUI로 테이블을 만들지 않는다. 마이그레이션 파일이 아니면 리눅스 서버에서 재현할 수 없다.

### 001_init.sql

```sql
create extension if not exists vector;

create table if not exists app_users (       -- Auth.js의 users와 충돌을 피해 app_users
  id            bigserial primary key,
  kakao_id      bigint unique not null,        -- 식별 기준. 이메일이 아니다
  nickname      text,
  profile_image text,
  name          text not null,
  phone         text not null,                 -- 숫자만 정규화해 저장
  email         text,                          -- 선택 동의라 비어 올 수 있다
  store_name    text not null,
  business_type text not null,
  status        text not null default 'open'
                check (status in ('open', 'preparing')),
  ai_range_days int  not null default 7
                check (ai_range_days between 1 and 365),
  created_at    timestamptz not null default now()
);

create table if not exists vendors (
  id      bigserial primary key,
  user_id bigint not null references app_users(id) on delete cascade,
  name    text   not null,
  phone   text
);
create index if not exists vendors_user_idx on vendors (user_id);

create table if not exists orders (
  id          bigserial primary key,
  user_id     bigint not null references app_users(id) on delete cascade,
  vendor_id   bigint references vendors(id) on delete set null,
  raw_input   text   not null,                 -- 사장님 원문
  result_text text   not null,                 -- 변환된 발주 텍스트
  -- draft: 확인 화면에 올라간 상태 / sent: 보낸 상태 / issue: 매칭 실패로 보류
  status      text   not null default 'draft'
              check (status in ('draft', 'sent', 'issue')),
  sent_at     timestamptz,                     -- sent로 바뀐 시각
  created_at  timestamptz not null default now()
);
-- user_id가 선두여야 격리 조회가 인덱스를 탄다
create index if not exists orders_user_created_idx
  on orders (user_id, created_at desc);
-- AURA 내보내기가 status로 3분류를 뽑는다
create index if not exists orders_user_status_idx
  on orders (user_id, status);

create table if not exists duties (
  id       bigserial primary key,
  user_id  bigint not null references app_users(id) on delete cascade,
  title    text   not null,
  due_date date,                               -- null 허용: 개업 준비는 기한이 없다
  sort     int    not null default 0,
  done     boolean not null default false
);
create index if not exists duties_user_idx
  on duties (user_id, due_date nulls last, sort);

create table if not exists law_chunks (        -- 공용·검증된 지식
  id        bigserial primary key,
  law_name  text not null,
  article   text not null,                     -- 출처 배지에 표시된다
  content   text not null,
  embedding vector(1536)
);
-- 인덱스를 만들지 않는다: 조문 수백~수천 건에서는 순차 스캔이
-- 정확도 100%이면서 더 빠르다.
-- ponytail: 수만 건을 넘으면
--   create index on law_chunks using hnsw (embedding vector_cosine_ops);

create table if not exists user_knowledge (    -- 개인 지식 (본인 전용)
  id         bigserial primary key,
  user_id    bigint not null references app_users(id) on delete cascade,
  question   text   not null,
  answer     text   not null,
  source_url text,
  embedding  vector(1536),
  created_at timestamptz not null default now()
);
create index if not exists user_knowledge_user_idx on user_knowledge (user_id);

create table if not exists stores (            -- 상권 정보 (정형)
  id            bigserial primary key,
  business_name text,
  category      text,
  address       text,
  lat           double precision,
  lng           double precision
);
create index if not exists stores_category_address_idx on stores (category, address);

create table if not exists qa_cache (
  question_hash text primary key,              -- 질문 정규화 후 해시
  answer        text not null,
  badge         text not null,                 -- 원본 출처 배지를 유지
  created_at    timestamptz not null default now()
);
```

### 002_authjs.sql

Auth.js `@auth/pg-adapter`가 요구하는 테이블이다. **컬럼명의 큰따옴표를 지우면 안 된다** —
어댑터가 camelCase로 조회한다.

```sql
create table if not exists verification_token (
  identifier text not null,
  expires    timestamptz not null,
  token      text not null,
  primary key (identifier, token)
);

create table if not exists users (              -- Auth.js 소유. 우리 것은 app_users
  id              serial primary key,
  name            varchar(255),
  email           varchar(255),
  "emailVerified" timestamptz,
  image           text
);

create table if not exists accounts (
  id                  serial primary key,
  "userId"            integer not null references users(id) on delete cascade,
  type                varchar(255) not null,
  provider            varchar(255) not null,
  "providerAccountId" varchar(255) not null,
  refresh_token       text,
  access_token        text,
  expires_at          bigint,
  id_token            text,
  scope               text,
  session_state       text,
  token_type          text,
  unique (provider, "providerAccountId")
);
create index if not exists accounts_user_idx on accounts ("userId");

create table if not exists sessions (
  id             serial primary key,
  "userId"       integer not null references users(id) on delete cascade,
  expires        timestamptz not null,
  "sessionToken" varchar(255) not null unique
);
```

FK·unique는 Auth.js 공식 예시에 없지만 추가했다. 없으면 같은 카카오 계정이 두 번
연결되거나 고아 세션이 남는다.

**`accounts."providerAccountId"`가 두 테이블을 잇는 고리다.** `session` 콜백이 이 값을
읽어 `app_users.kakao_id`와 맞춘다 ([[auth-design]]).

### 해결됨 — 테이블 이름 충돌 (2026-09-15 확정)

Auth.js 어댑터가 `users` 테이블을 요구하는데 우리 테이블과 이름이 겹쳤다.

조사 결과, 다른 어댑터는 모두 이름 변경 수단이 있지만(Prisma `@map()`, DynamoDB
`tableName`, Xata `nextauth_` 접두사) **`@auth/pg-adapter`는 문서화된 시그니처가
`PostgresAdapter(pool)` 하나뿐이고 옵션 인자가 없다.** 어댑터 쪽을 바꿀 방법이 없다.

→ **우리 테이블을 `app_users`로 바꿨다.** Auth.js는 `users`를 그대로 쓴다.

기각한 대안(별도 스키마 `next_auth`): 동작은 하지만 모든 `pg` 연결에서 `search_path`를
맞춰야 하고, 한 번 빠뜨리면 조용히 엉뚱한 테이블을 읽는다.

### 미해결 — 임베딩 차원 (미확정)

`vector(1536)`은 가정값이다. LLM 제공자와 임베딩 모델이 정해지면 확정한다.
모델을 바꾸면 마이그레이션과 전체 재임베딩이 필요하므로 Day 4 전에 정한다.

### 테스트 방법

```bash
docker compose up -d
docker exec -i bizpedia-db psql -U $DB_USER -d $DB_NAME < migrations/001_init.sql
docker exec -i bizpedia-db psql -U $DB_USER -d $DB_NAME < migrations/002_authjs.sql
docker exec bizpedia-db psql -U $DB_USER -d $DB_NAME \
  -c "select * from pg_extension where extname='vector'"
```

## Links

- [[bizpedia-mvp]]
- [[tech-stack-selection]]
- [[data-isolation-policy]]
- [[auth-design]]
- [[search-design]]
- [[user-mode-design]]
- [[order-design]]
- [[0916-infra]]
- [[0918-vendors]]
- [[0923-settings]]
- [[oct-law-rag]]
- [[index]]
