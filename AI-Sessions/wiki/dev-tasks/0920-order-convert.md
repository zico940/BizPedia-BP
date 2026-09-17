---
type: dev-task
date: 2026-09-20
status: draft
owner: shared
---

# 09-20 (일) — 발주 텍스트 변환

## Summary

자연어 발주를 정형 텍스트로 바꾼다.
완료 기준: "내일 대파 2단 김사장님께 주문해" → 거래처에 보낼 문구.

**이날이 임계점이다.** LLM 제공자를 이날 전까지 정해야 한다.

## Details

설계는 [[order-design#1. 발주 텍스트 변환]].

### 작업

1. `lib/llm.ts` — LLM 호출을 한 곳으로
2. 구조 추출 프롬프트 — 품목·수량·단위·거래처 힌트·납품일
3. zod 스키마로 응답 검증
4. 문구 조립 (템플릿, 코드가 한다)

### 핵심 원칙

**LLM에게 문장을 생성시키지 않는다.** 구조만 추출하고 문구 조립은 코드가 한다.
그래야 출력이 흔들리지 않고 검증할 수 있다.

```ts
{ vendor_hint: string,
  items: [{ name, qty, unit }],
  deliver_on: string | null }
```

### 주의

- zod 검증 실패 시 **재시도 1회**, 그래도 실패하면 직접 입력을 요청한다.
  깨진 응답을 그대로 쓰지 않는다
- 거래처 매칭은 09-21에 붙인다. 이날은 `vendor_hint`를 원문 그대로 둔다
- **LLM 제공자 미확정** — 이날 전 확정 필요([[bizpedia-mvp#확인이 필요한 항목]])

## 완료 확인

실제 발주 문장 10개를 넣어 결과를 육안 확인한다.
수량·단위 추출은 `assert` 기반 점검을 남긴다.

## Links

- [[bizpedia-mvp]]
- [[order-design]]
- [[0919-order-ui]]
- [[0921-vendor-match]]
- [[index]]
