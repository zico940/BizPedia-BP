---
type: decision
date: 2026-09-15
status: active
owner: shared
decided_by: user
---

# Data Isolation Policy

## Summary

개인정보 보호를 **RLS가 아니라 쿼리 코드로** 강제한다. 모든 조회에
`where user_id = $세션유저`를 예외 없이 넣고, 데이터 접근을 `lib/db/queries.ts` 한 곳으로 모은다.

자가학습 데이터(`user_knowledge`)는 작성한 본인에게만 보인다.

## Context

Supabase를 쓰지 않기로 하면서([[tech-stack-selection]]) RLS가 자동으로 걸리지 않게 됐다.
앱이 단일 owner 롤로 접속하기 때문에 RLS는 요청별 롤 설정 없이는 발동하지 않고,
그 설정은 10일 안에 할 작업이 아니다.

취급하는 개인정보: 이름, 전화번호, 이메일, 발주 이력, 거래처 목록, 개인 학습 데이터.

## Details

### 규칙 1 — 쿼리 함수는 반드시 user_id를 받는다

`user_id`를 받지 않는 조회 함수를 만들지 않는다. 컴포넌트에서 `pool.query`를 직접 부르지
않는다 — 그 순간 규칙이 무너진다.

```ts
export async function getRecentOrders(userId: number, rangeDays: number) {
  const { rows } = await pool.query(
    `select * from orders
      where user_id = $1
        and created_at >= now() - ($2 || ' days')::interval
      order by created_at desc`,
    [userId, rangeDays]
  )
  return rows
}
```

### 규칙 2 — 공용 지식과 개인 지식은 테이블을 분리한다

`law_chunks`(공용·검증)와 `user_knowledge`(개인·미검증)를 **테이블 자체로** 나눈다.
컬럼 플래그로 나누면 언젠가 `where` 하나를 빠뜨려 남의 데이터가 샌다.
테이블이 다르면 그 사고가 구조적으로 나지 않는다.

### 규칙 3 — 날짜 범위는 성능 설정이 아니라 보안 경계

`ai_range_days`를 **클라이언트에서 받지 않는다.** 세션 유저의 `app_users.ai_range_days`를
서버에서 읽어 넣는다. 아니면 요청 조작으로 범위를 무시할 수 있다.

사용자가 1일로 설정했는데 10일 전 데이터가 나오면 안 된다는 요구가 정확히 이 지점이다.

### 규칙 4 — 세션에서만 신원을 얻는다

```ts
const session = await auth()
const user = await getUserByKakaoId(session.user.kakaoId)
const orders = await getRecentOrders(user.id, user.ai_range_days)
```

### 검증 (생략 불가)

1. 계정 두 개를 만들어 A의 발주·거래처·`user_knowledge`가 B에게 보이지 않는지 확인
2. `ai_range_days=1`로 두고 10일 전 데이터를 물어 검색되지 않는지 확인
3. 요청 본문에 범위를 조작해 넣어도 무시되는지 확인

이 둘은 `assert` 기반 자체 점검을 반드시 남긴다. 조용히 깨지면 개인정보 사고다.

### 법적 의무

이름·전화번호를 받는 순간 **개인정보처리방침 페이지가 법적 의무**다. 정적 페이지 한 장이면
되므로 미루지 않는다. 가입 화면에 체크박스 + 링크.

## Links

- [[bizpedia-mvp]]
- [[tech-stack-selection]]
- [[database-design]]
- [[auth-design]]
- [[search-design]]
- [[order-design]]
- [[aura-export-design]]
- [[0917-auth]]
- [[0918-vendors]]
- [[0922-share-history]]
- [[0923-settings]]
- [[0928-order-reuse]]
- [[0929-aura-export]]
- [[0930-deploy]]
- [[oct-web-fallback]]
- [[index]]
