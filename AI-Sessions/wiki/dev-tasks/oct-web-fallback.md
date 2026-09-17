---
type: dev-task
date: 2026-09-15
status: draft
owner: shared
---

# 10월 — 웹 폴백 · 출처 배지 · 캐시

## Summary

DB에 근거가 없는 질문을 웹 검색으로 답하고, 결과를 본인 전용으로 저장한다.
출처 배지 3종과 질문 캐시를 붙인다.

**9월 범위가 아니다.** 검색 기능 자체가 10월로 이월됐다.

## Details

설계는 [[search-design#검색 계단과 출처 배지]].

### 선행 조건

[[oct-law-rag]]가 먼저다. 웹 폴백은 검색 계단의 **마지막 단계**라
앞 단계(법령 벡터 검색)가 없으면 의미가 없다.

### 작업

1. 웹 검색 + LLM 정리 → `user_knowledge`에 **본인 전용** 저장
2. 출처 배지 3종 — 🟢 검증됨 / 🔵 공공데이터 / 🔴 미확인
3. `qa_cache` — 질문 정규화 후 **문자열 해시**

### 주의

- `user_knowledge`는 개인정보다. 모든 조회에 `where user_id = $세션유저`
  ([[data-isolation-policy]])
- 캐시에 **원본 배지를 함께 저장**한다. 배지가 사라지면 미검증 답이 검증된 것처럼 보인다
- 시맨틱 캐시는 쓰지 않는다. 법률 도메인에서 유사도 캐시는 오답을 퍼뜨린다

## 완료 확인

1. 조문에 없는 질문 → 답변 + 🔴 배지
2. 같은 질문 재입력 → 캐시 적중, 배지 유지
3. 계정 A의 `user_knowledge`가 계정 B에게 보이지 않음

## Links

- [[bizpedia-mvp]]
- [[search-design]]
- [[data-isolation-policy]]
- [[oct-law-rag]]
- [[oct-checklists]]
- [[index]]
