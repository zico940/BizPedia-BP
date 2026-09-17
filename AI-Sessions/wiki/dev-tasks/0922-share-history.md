---
type: dev-task
date: 2026-09-22
status: draft
owner: shared
---

# 09-22 (화) — 공유 · 발주 이력

## Summary

승인된 발주를 저장하고 카카오톡으로 보낸다. 지난 발주를 목록으로 본다.
완료 기준: 공유 버튼으로 실제 카톡 전송이 된다.

## Details

설계는 [[order-design#4. 승인 플로우 (생략 불가)]].

### 작업

1. 확인 화면의 [보내기] — `status`를 `sent`로 바꾸고 `sent_at` 기록 후 공유 시트 열기
2. Web Share API (`navigator.share`) + 클립보드 복사 폴백
3. 발주 이력 목록 (상태 배지 표시)

### 주의

- **[보내기] 전에는 `draft`다.** 행은 확인 화면 진입 시 이미 저장돼 있다.
  승인은 "저장 시점"이 아니라 **"`sent` 전환 시점"**이다
- `raw_input`(원문)과 `result_text`(결과)를 **둘 다** 남긴다.
  원문이 있어야 변환 품질을 나중에 점검할 수 있다
- 이력 목록에서 `draft`는 "보내지 않음"으로 구분해 보여준다. 사장님이 중단한 발주를
  이어서 보낼 수 있다
- Web Share API는 **HTTPS에서만** 동작한다(`localhost`는 예외).
  데스크톱 브라우저 일부는 미지원 → 클립보드 폴백 필수
- 알림톡은 사업자 검수가 필요해 MVP에서 못 쓴다. OS 공유 시트로 우회한다

### 이력 목록

`ai_range_days`와 무관하게 **화면 목록은 전체를 본다.** 날짜 범위 제한은
AI 검색("어제처럼")에만 적용되는 보안 경계다([[data-isolation-policy]]).

## 완료 확인

1. [보내기] → 카카오톡 선택 → 문구가 그대로 전송됨
2. 전송 후 이력 목록에 나타남
3. 다른 계정에서 그 발주가 **보이지 않음**

## Links

- [[bizpedia-mvp]]
- [[order-design]]
- [[data-isolation-policy]]
- [[0921-vendor-match]]
- [[0923-settings]]
- [[index]]
