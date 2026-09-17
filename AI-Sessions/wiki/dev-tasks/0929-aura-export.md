---
type: dev-task
date: 2026-09-29
status: draft
owner: shared
---

# 09-29 (화) — AURA JSON 내보내기

## Summary

AURA 통합 대시보드용 공통 JSON을 만든다.
완료 기준: 발주 데이터가 통합 규격의 필드로 출력된다.

## Details

설계는 [[aura-export-design]].

### 작업

1. `lib/export/aura.ts` — 어댑터 한 파일
2. 내보내기 버튼 또는 라우트 (JSON 내려받기)

### 원칙

- **읽기 전용 어댑터다.** `orders`·`vendors`·`app_users`를 조회해 조립할 뿐
  아무것도 쓰지 않는다
- **내부 스키마를 통합 규격에 맞춰 바꾸지 않는다.** 그 순간 우리 도메인이
  남의 필드명에 끌려간다
- 내보내기도 `user_id`를 받는다. 전체 사용자를 한 번에 뽑는 함수를 만들지 않는다

### 이번에 하지 않는 것

전달 방식(파일/API/DB 공유)이 통합 문서에 없다. **JSON을 만들어 내려받는 것까지**만 하고,
전달 경로는 A팀과 맞춘 뒤 10월에 붙인다.

### 밀릴 때

이 작업이 **첫 번째 폐기 대상**이다. 10월 통합 전까지 시간이 있고,
내부 스키마를 건드리지 않는 설계라 나중에 붙여도 비용이 같다.

## 완료 확인

1. 발주 3건 → 내보내기 → 공통 필드가 채워짐
2. 확인 대기 건이 `in_progress`, 전송 완료가 `completed`에
3. 거래처 매칭 실패 건이 `issue`에
4. 다른 계정 발주가 섞이지 않음

## Links

- [[bizpedia-mvp]]
- [[aura-export-design]]
- [[data-isolation-policy]]
- [[0928-order-reuse]]
- [[0930-deploy]]
- [[index]]
