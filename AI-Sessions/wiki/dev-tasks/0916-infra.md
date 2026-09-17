---
type: dev-task
date: 2026-09-16
status: draft
owner: shared
---

# 09-16 (수) — 인프라

## Summary

이름 충돌을 정리하고, DB를 띄우고, 마이그레이션을 실행한다.
완료 기준: `docker compose up -d` 후 `vector` 확장이 확인된다.

## Details

### 작업

1. ~~`users` → `app_users` 치환~~ **(완료)** — 마이그레이션 + 설계 문서 10곳
2. ~~`002_authjs.sql` 생성~~ **(완료)** — FK·unique 추가본
3. ~~`orders.status`·`sent_at` 추가~~ **(완료)** — AURA 3분류용
4. 카카오 비즈앱 전환 신청 — 승인이 늦어도 09-17을 막지 않는다([[auth-design]])
5. DB 기동 + 마이그레이션 001·002 실행
6. `lib/db/pool.ts` — pg Pool 싱글턴

### 현재 상태

- 패키지 설치 완료: `next-auth@beta`, `@auth/pg-adapter`, `pg`, `zod`, `@types/pg`
- 마이그레이션 001·002 **작성 완료, 실행 전**
- **Docker 데몬 미기동** — 사용자가 Docker Desktop을 직접 실행해야 한다
- 코드는 아직 없다. pm 체계로 착수한다([[dev-workflow]])

### DB 없이도 진행 가능

09-16의 코드 작업(`pool.ts`, `queries.ts`, `auth.ts`)은 **연결 없이 작성된다.**
실제 연결은 09-17 로그인 왕복 테스트에서 처음 필요하다.

법령 임베딩이 10월로 밀렸으므로 **9월 범위만 보면 pgvector가 실제로 쓰이지 않는다.**
다만 스키마에 `vector(1536)` 컬럼이 있어 확장 설치는 필요하다.

## 완료 확인

```bash
docker compose up -d
docker exec bizpedia-db psql -U $DB_USER -d $DB_NAME \
  -c "select * from pg_extension where extname='vector'"
```

## Links

- [[bizpedia-mvp]]
- [[database-design]]
- [[tech-stack-selection]]
- [[dev-workflow]]
- [[0917-auth]]
- [[index]]
