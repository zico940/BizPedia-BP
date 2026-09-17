---
type: decision
date: 2026-09-15
status: active
owner: shared
decided_by: user
---

# Dev Workflow

## Summary

BizPedia 개발은 **pm 에이전트 체계로 진행한다.** 메인 세션이 직접 코드를 쓰지 않는다.

기존 설계 문서 25개는 `owner: shared`를 유지하고, 에이전트들은 읽어서 참조한다.

## Context

세션 중간에 `.claude/` 폴더가 없던 시점이 있었고, 그때 "에이전트 체계를 거치지 않고
메인 세션이 직접 구현"하기로 정했다. 이후 `.claude/`가 복구됐는데도 그 예외가 계속
적용되어 메인 세션이 코드를 직접 작성했다.

`CLAUDE.md`는 개발 요청을 pm이 받는다고 명시한다. 규칙으로 되돌린다.

같은 기간에 승인 절차도 어긋났다. 계획 승인과 방향 결정(예: "9월 구현 먼저")을
구현 착수 승인으로 해석해 코드를 만들었고, 사용자 지시로 전부 삭제했다.

## Details

### 확정 사항

| 항목 | 결정 |
|---|---|
| 개발 요청 | pm이 받아 database → backend → frontend 순으로 분배 |
| 단계 분리 | 설계 호출과 구현 호출을 나눈다. 사이에 사용자 승인 |
| 커밋 | git-manager만 |
| 기존 문서 25개 | `owner: shared` 유지 |
| 메인 세션 직접 처리 | `save`, `ingest`, `query`, `lint` 네 명령만 |

### 착수 승인의 기준

**"개발 시작해줘" 같은 명시적 지시가 있을 때만 구현에 들어간다.**

다음은 착수 승인이 아니다:

- 계획서 승인 (ExitPlanMode)
- 방향·순서 결정 ("9월 구현 먼저", "이어서 진행")
- 설계 문서 작성 완료

### 기존 문서의 취급

메인 세션이 쓴 문서이므로 `shared`가 규칙상 맞다
(`.claude/rules/knowledge-ops.md`의 Document Format).

pm과 하위 에이전트는 이 문서들을 **읽어서 참조**하되 고치지 않는다.
수정이 필요하면 사용자에게 보고한다. 새로 만드는 설계·태스크 문서는
각 에이전트가 소유한다.

### 삭제된 코드

승인 없이 만들어졌던 파일은 전부 삭제했다.

- `lib/db/pool.ts`, `lib/db/queries.ts`, `auth.ts`
- `app/api/auth/[...nextauth]/route.ts`, `types/next-auth.d.ts`

남긴 것: `migrations/001_init.sql`(계획 승인 범위), `docker-compose.yml`,
`.env.example`, `PLAN.md`, Next.js 스캐폴드, 설치된 패키지 5종.

다음 구현은 pm이 [[0916-infra]]부터 설계 문서 기반으로 다시 시작한다.

## Links

- [[bizpedia-mvp]]
- [[agent-collaboration-model]]
- [[0916-infra]]
- [[CLAUDE]]
- [[index]]
