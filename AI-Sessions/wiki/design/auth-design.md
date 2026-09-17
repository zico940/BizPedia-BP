---
type: design
date: 2026-09-15
status: draft
owner: shared
---

# Auth Design

## Summary

카카오 소셜 로그인을 Auth.js(next-auth v5) + `@auth/pg-adapter`로 구현한다.
OAuth를 직접 구현하지 않는다.

카카오에서 받지 못하는 정보(이름·전화번호)는 가입 폼에서 직접 입력받되,
비즈앱 승인 여부와 무관하게 일정이 밀리지 않도록 **이중 대응**으로 설계한다.

## Context

사업자등록증이 없는 개인 개발자 앱이라 카카오가 주는 정보에 제약이 있다.
조사로 확인한 사실:

- 사업자등록증 없이도 **본인인증만으로 개인 개발자 비즈앱 전환이 가능**하고,
  이메일(`account_email`) 승인 사례가 다수 있다
- 다만 `name`·`phone_number`는 카카오싱크 영역이라 **승인 여부를 지금 확답할 수 없다**
- 비즈앱 전환 없이 확실히 얻는 것은 `profile_nickname`, `profile_image`뿐

## Details

### 이중 대응 (일정 방어)

Day 1에 비즈앱 전환 + 동의항목을 신청하되, 승인 여부와 무관하게 Day 2를 진행한다.

| 승인 결과 | 가입 폼 동작 |
|---|---|
| 승인됨 | 이름·전화·이메일 자동 채움 (사용자가 수정 가능) |
| 안 됨 | 이름·전화 직접 입력, 이메일은 비움 |

어느 쪽이든 스키마는 같다. 식별 기준은 항상 **`kakao_id`** 이고 이메일이 아니다.
이메일은 선택 동의라 비어 올 수 있다.

### 가입 흐름

```
카카오 로그인 → kakao_id로 app_users 조회
  ├ 있으면 → 홈
  └ 없으면 → 가입 폼 1화면 → app_users 생성 → 홈
```

가입 폼은 **한 화면, 5칸**이다. 사장님 대상 서비스에서 폼이 두 페이지로 넘어가면 이탈한다.

| 칸 | 값 |
|---|---|
| 이름 | 직접 입력 (또는 자동 채움) |
| 전화번호 | 직접 입력, 숫자만 정규화해 저장 |
| 매장명 | 직접 입력 |
| 업종 | 선택 + **"아직 준비 중(창업 예정)"** 항목 포함 |
| 개인정보 동의 | 체크박스 + 처리방침 링크 |

"아직 준비 중"을 고르면 `app_users.status = 'preparing'`이 된다.
자세한 분기는 [[user-mode-design]] 참조.

### 구현

#### 세션 전략 — 어댑터를 붙이면 database 전략이 강제된다

**소스로 확인한 사실** (`node_modules/@auth/core/lib/init.js:74`):

```js
strategy: config.adapter ? "database" : "jwt"
```

어댑터가 있으면 **자동으로 database 세션**이 되고 **`jwt` 콜백은 호출되지 않는다.**
`jwt` 콜백에서 `profile.id`를 실어 `kakaoId`를 전달하는 방식은 이 구성에서 동작하지 않는다.

→ **`session` 콜백에서 `accounts.providerAccountId`(= 카카오 id)를 조회해 싣는다.**

`auth.ts` (프로젝트 루트)

```ts
import NextAuth from "next-auth"
import Kakao from "next-auth/providers/kakao"
import PostgresAdapter from "@auth/pg-adapter"
import { pool } from "@/lib/db/pool"

export const { handlers, auth, signIn, signOut } = NextAuth({
  adapter: PostgresAdapter(pool),
  providers: [Kakao],
  callbacks: {
    async session({ session, user }) {
      // user는 Auth.js users 행. 우리 app_users와는 다른 테이블이다.
      const { rows } = await pool.query(
        `select "providerAccountId" from accounts
          where "userId" = $1 and provider = 'kakao' limit 1`,
        [user.id]
      )
      session.user.kakaoId = rows[0]?.providerAccountId
      return session
    },
  },
})
```

세션 조회마다 쿼리가 하나 는다. 이 비용이 문제가 되면 `app_users`에
`authjs_user_id` 컬럼을 두고 `user.id`로 직접 잇는 방법이 있다 —
그 경우 연결 고리가 `kakaoId`에서 그 컬럼으로 바뀌므로
[[data-isolation-policy]] 규칙 4도 함께 고쳐야 한다.

타입 확장이 필요하다 (`types/next-auth.d.ts`):

```ts
declare module "next-auth" {
  interface Session {
    user: { kakaoId?: string } & DefaultSession["user"]
  }
}
```

`app/api/auth/[...nextauth]/route.ts`

```ts
import { handlers } from "@/auth"
export const { GET, POST } = handlers
```

### 환경변수

```
AUTH_SECRET=          # npx auth secret
AUTH_URL=             # 운영 시 실제 도메인
AUTH_KAKAO_ID=        # 카카오 REST API 키
AUTH_KAKAO_SECRET=    # 보안 > Client Secret
```

### 카카오 콘솔 설정

Redirect URI에 **운영 URL과 로컬 URL을 둘 다** 등록한다. 로컬을 빠뜨리면 개발 내내 막힌다.

```
http://localhost:3000/api/auth/callback/kakao
https://<도메인>/api/auth/callback/kakao
```

HTTPS가 없으면 운영 URI 등록이 막히므로 도메인·인증서를 Day 10 전에 준비한다.

### 동의항목 최소화

지금 쓰지 않는 항목(성별·연령대·출생연도·생일)은 신청하지 않는다.
동의 화면이 길어지면 가입 이탈만 늘고, 개인정보 최소수집 원칙에도 어긋난다.
나중에 필요해지면 그때 추가한다.

### 테스트 방법

1. 카카오 로그인 → 가입 폼 → `app_users` 행 생성 확인
   (Auth.js의 `users`·`accounts` 행도 함께 생기는지 확인 — 별개 테이블이다)
2. **`session.user.kakaoId`가 실제로 채워지는지 확인.** 이게 비면 사용자 조회가
   전부 실패한다. 로그인 직후 세션을 찍어보는 것이 가장 빠르다
3. 로그아웃 후 재로그인 → **가입 폼이 다시 뜨지 않아야** 함
4. `preparing`으로 가입 → `app_users.status` 값 확인

## Links

- [[bizpedia-mvp]]
- [[tech-stack-selection]]
- [[data-isolation-policy]]
- [[database-design]]
- [[user-mode-design]]
- [[0916-infra]]
- [[0917-auth]]
- [[0930-deploy]]
- [[index]]
