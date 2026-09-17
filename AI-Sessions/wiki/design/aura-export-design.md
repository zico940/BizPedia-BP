---
type: design
date: 2026-09-15
status: draft
owner: shared
---

# AURA Export Design

## Summary

AURA 통합 대시보드로 내보낼 공통 JSON 규격을 맞춘다.
**출력 시점 어댑터 한 파일**(`lib/export/aura.ts`)로만 처리하고, 내부 스키마는 바꾸지 않는다.

## Context

`AI-Sessions/raw/최종 통합 구조.md`가 A·B 두 팀의 결과물을 10월에 하나의 대시보드로
합치기 위한 공통 규격을 정한다. 문서는 **"두 팀의 MVP를 10월 이후 하나로 합치려면
9월부터 아래 기준을 맞춰야 합니다"**라고 명시한다. B팀의 의무다.

한 번 뺐다가 되돌린 항목이다. 이유는 두 가지다.

- 지금 안 맞추면 10월 통합 때 **B팀 산출물만 규격이 어긋난다**
- 어댑터 한 파일이라 비용이 작다 (내부 테이블을 건드리지 않는 설계이므로)

## Details

### 통합 문서가 요구하는 것

공통 파이프라인은 이미 BizPedia의 구조와 같다:

```
입력 → AI 분석 → JSON 구조화 → DB 저장 → 알림/리포트 출력
발주 원문 → LLM 변환 → result_text → orders → 공유
```

공통 JSON 필드:

```json
{ "module": "", "title": "", "summary": "", "category": "",
  "key_points": [], "next_action": [], "deadline": "",
  "priority": "", "status": "", "tags": [] }
```

Team B 추가 필드:

```json
{ "completed": [], "in_progress": [], "issue": [],
  "owner": "", "report_summary": "", "message_draft": "" }
```

### 필드 해석 — 통합 문서는 Work Agent를 상정해 쓰였다

통합 문서의 Team B 필드는 "업무보고·고객관리 자동화"를 전제로 이름이 붙었다.
BizPedia는 발주 비서이므로 **의미를 발주 맥락으로 옮긴다.**

| 공통 필드 | BizPedia에서의 의미 |
|---|---|
| `module` | `"bizpedia"` 고정 |
| `title` | 발주 요약 (예: "김사장 청과 발주 3건") |
| `summary` | 기간·건수 한 줄 요약 |
| `category` | `"order"` |
| `key_points` | 주요 품목 목록 |
| `next_action` | 확인 대기 중인 발주 |
| `deadline` | 가장 이른 납품일 |
| `status` | `"active"` |
| `tags` | 업종, 거래처명 |

| Team B 필드 | BizPedia에서의 의미 | 출처 |
|---|---|---|
| `message_draft` | 변환된 발주 문구 | `orders.result_text` |
| `completed` | 전송까지 끝난 발주 | `orders.status = 'sent'` |
| `in_progress` | 확인 대기 중인 발주 | `orders.status = 'draft'` |
| `issue` | 거래처 매칭 실패·모호 건 | `orders.status = 'issue'` |
| `owner` | 매장주 | `app_users.store_name` |
| `report_summary` | 기간별 발주 요약 | 집계 |

3분류는 **`orders.status` 한 컬럼**으로 나온다. 쿼리 한 번이면 된다.

```sql
select status, count(*), json_agg(result_text)
  from orders
 where user_id = $1
 group by status
```

### 구현 원칙

**내부 스키마를 통합 규격에 맞춰 바꾸지 않는다.** 그 순간 우리 도메인이 남의 필드명에
끌려가고, 통합 규격이 바뀔 때마다 테이블을 고치게 된다.

어댑터는 읽기 전용이다 — `orders`·`vendors`·`app_users`를 조회해 JSON을 조립할 뿐
아무것도 쓰지 않는다.

```
# ponytail: 출력 시점 어댑터 한 개. 내부 테이블은 그대로.
```

### 격리

내보내기도 **`user_id`를 받는다.** 전체 사용자 데이터를 한 번에 뽑는 함수를 만들지 않는다.
대시보드가 여러 매장을 모아야 한다면 그건 10월 통합 시점의 별도 결정이다
([[data-isolation-policy]]).

### 미확정 — 전달 방식

통합 문서에 **어떻게 전달하는지가 없다.** 파일로 넘기는지, API로 받아가는지,
DB를 공유하는지 정해지지 않았다.

9월에는 **JSON을 만들어 내려받을 수 있는 것까지**만 한다. 전달 경로는 A팀·대시보드
담당과 맞춘 뒤 10월에 붙인다.

## 테스트 방법

1. 발주 3건을 만든 뒤 내보내기 → 공통 필드가 모두 채워지는지
2. 확인 대기 발주가 `in_progress`에, 전송 완료가 `completed`에 들어가는지
3. 거래처 매칭 실패 건이 `issue`에 들어가는지
4. 다른 계정의 발주가 섞이지 않는지

## Links

- [[bizpedia-mvp]]
- [[order-design]]
- [[data-isolation-policy]]
- [[0929-aura-export]]
- [[index]]
