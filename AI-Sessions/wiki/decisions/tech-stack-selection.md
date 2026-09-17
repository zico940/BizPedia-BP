---
type: decision
date: 2026-09-15
status: active
owner: shared
decided_by: user
---

# Tech Stack Selection

## Summary

BizPedia MVP의 기술 스택을 **Next.js 단일 런타임 + 직접 운영하는 Postgres(pgvector) +
Python 배치 스크립트**로 확정한다. 기획 원안의 Python API 서버와 Supabase는 채택하지 않는다.

## Context

기획 원안(`설명.md`)은 프론트 Next.js, 백엔드 Python API, DB Supabase였다.
10일·80시간·1인이라는 제약에서 이 구성을 재검토했다.

## Details

### 확정 사항

| 항목 | 결정 | 근거 |
|---|---|---|
| 런타임 | Next.js 단독 | 런타임 둘은 배포·인증 연동·CORS 비용이 두 배 |
| DB | 직접 띄운 Postgres 16 + pgvector | 사용자 결정 |
| Python | 배치 스크립트만 (웹서버 아님) | 임베딩 생성·데이터 적재는 오프라인 작업 |
| ORM | 쓰지 않음 (`pg` + raw SQL) | 벡터·집계·interval이 전부 raw SQL이 자연스럽다 |
| 이미지 | `pgvector/pgvector:pg16` | 순정 이미지에 pgvector 컴파일은 리눅스에서 반나절 소모 |
| 인증 | Auth.js(next-auth v5) + `@auth/pg-adapter` | 카카오 provider 공식 지원 |
| 스타일 | Tailwind | 모바일 우선 |
| 검증 | zod | 신뢰 경계 입력 검증 |

### 기각한 대안

- **Python API 서버 분리** — 검색은 SQL 한 방이고 임베딩은 배치라 웹서버가 필요 없다.
  실시간 재색인이나 무거운 ML 추론이 필요해지면 FastAPI로 승격한다. MVP엔 둘 다 없다.
- **Supabase** — 사용자가 직접 운영하는 Postgres를 선택했다. 대가로 RLS가 자동으로 걸리지
  않으므로 [[data-isolation-policy]]의 쿼리 규칙으로 갚는다.
- **Prisma / Drizzle** — pgvector의 `<=>` 연산자 때문에 결국 raw SQL로 빠져나오게 된다.
  쿼리가 수십 개를 넘고 타입 관리가 아파지면 그때 도입한다.
- **HNSW 인덱스** — 조문 수백~수천 건에서는 인덱스 없는 순차 스캔이 정확도 100%이면서
  더 빠르다. 안 쓰는 벡터 인덱스는 순수 오버헤드다.

### 버전 고정 방침

문서에 패키지 버전 번호를 적지 않는다. `@latest`로 설치하고 lockfile에 맡긴다.
문서의 숫자는 금방 틀린 정보가 된다.

### 조사로 확인한 사실

- Auth.js 카카오 provider와 `@auth/pg-adapter`는 공식 지원 (공식 문서 확인)
- 국가법령정보 OPEN API 인증키(OC)는 무료·자체 발급
- 소상공인365 상권 API는 `bigdata.sbiz.or.kr`이 아니라 **공공데이터포털(data.go.kr)** 신청

## Links

- [[bizpedia-mvp]]
- [[data-isolation-policy]]
- [[database-design]]
- [[auth-design]]
- [[0916-infra]]
- [[index]]
