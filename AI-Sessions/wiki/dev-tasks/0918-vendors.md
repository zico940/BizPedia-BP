---
type: dev-task
date: 2026-09-18
status: draft
owner: shared
---

# 09-18 (금) — 거래처 CRUD

## Summary

거래처를 등록·수정·삭제·조회한다.
완료 기준: 거래처가 저장되고, 다른 계정에서 보이지 않는다.

## Details

설계는 [[order-design]], 격리 규칙은 [[data-isolation-policy]].

### 작업

1. `lib/db/queries.ts`에 거래처 함수 — 전부 `user_id`를 받는다
2. 거래처 목록·등록·수정 화면 (모바일 우선)

### 저장 항목

`vendors` 테이블: 상호(`name`), 연락처(`phone`).
품목 단가는 MVP에서 다루지 않는다 — 발주 문구에 금액이 안 들어간다.

### 주의

- 거래처명은 나중에 **매칭의 대상**이 된다([[order-design#2. 거래처명 매칭 — 실제 난관]]).
  등록 시 앞뒤 공백을 제거해 저장한다
- 연락처는 전화번호와 같은 정규화(숫자만)를 적용한다
- 거래처는 개인정보다(`user_id` 필수)

## 완료 확인

1. 거래처 등록 → 목록에 표시
2. 다른 계정으로 로그인 → 앞 계정의 거래처가 **보이지 않음**
3. 모바일 폭(약 400px)에서 화면이 깨지지 않음

## Links

- [[bizpedia-mvp]]
- [[order-design]]
- [[database-design]]
- [[data-isolation-policy]]
- [[0917-auth]]
- [[0919-order-ui]]
- [[index]]
