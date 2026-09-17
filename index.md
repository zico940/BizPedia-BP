# AI Agent Wiki Index

이 문서는 vault 전체의 지도입니다.

에이전트는 중요한 wiki 문서를 만들거나 갱신한 뒤 이 문서에 링크를 추가해야 합니다.

## Start Here

- [[START_HERE]]
- [[CLAUDE]]
- [[AGENTS]]
- [[README]]
- [[TEMPLATE_MANIFEST]]
- [[log]]

## Vault Structure

- `AI-Sessions/raw/`: 수정하지 않는 1차 자료
- `AI-Sessions/conversations/`: 세션 인수인계
- `AI-Sessions/wiki/sources/`: raw 자료 요약
- `AI-Sessions/wiki/concepts/`: 반복 사용 개념
- `AI-Sessions/wiki/decisions/`: 의사결정
- `AI-Sessions/wiki/errors/`: 실패와 리스크
- `AI-Sessions/wiki/projects/`: 프로젝트 맥락
- `AI-Sessions/wiki/design/`: 디자인 가이드와 IA
- `AI-Sessions/wiki/dev-tasks/`: 개발 태스크
- `.claude/agents/`: 개발 서브에이전트 정의 (pm, backend, frontend, database, code-review, git-manager)
- `.claude/rules/knowledge-ops.md`: 지식 관리 규칙 (save/ingest/query/lint, 문서 형식)
- `.claude/rules/dev-common.md`: 개발 에이전트 공통 규칙
- `.claude/skills/`: 이 프로젝트에 설치한 스킬
- `.claude/skills/export-template/`: 작업 기록을 지운 깨끗한 배포 ZIP 생성 스킬
- `scripts/lint_wiki.py`: 문서 구조·링크 그래프 검사기 (`bash scripts/lint-wiki.sh`로 실행)
- `scripts/agent_guard.py`: 에이전트 규칙을 강제하는 훅 (호출 허용 목록, git 쓰기 제한, 종료 시 린트)
- `scripts/test_rules.py`: 한 번 고친 규칙이 다시 깨지지 않는지 보는 회귀 검사 (`python scripts/test_rules.py`)
- `.claude/settings.json`: 훅과 권한 설정 (push·init 등은 항상 사용자 확인)

## Projects

- [[bizpedia-mvp]] — 소상공인 컴플라이언스·발주 비서 10일 MVP 계획

## Concepts

- [[glossary]]

## Decisions

- [[agent-collaboration-model]]
- [[dev-workflow]] — 개발은 pm 체계로. 착수 승인의 기준
- [[tech-stack-selection]] — Next.js 단일 런타임, 직접 운영 Postgres, ORM 미사용
- [[data-isolation-policy]] — RLS 대신 쿼리 코드로 격리, 날짜 범위는 보안 경계

## Design

- [[architecture-overview]] — 팀 공유용 아키텍처 정의서(비개발 직군용 요약, 전원 합의 전 초안)
- [[database-design]] — 테이블 9개 + Auth.js 4개, 마이그레이션 2본
- [[auth-design]] — 카카오 로그인, 비즈앱 이중 대응, 가입 폼
- [[order-design]] — **발주 도메인 (9월의 핵심)**: 변환·매칭·재사용·승인
- [[aura-export-design]] — AURA 통합 JSON 어댑터
- [[search-design]] — 검색 계단 6단계, 출처 배지, 집계 불가 판정 *(10월 구현)*
- [[user-mode-design]] — 영업 중 / 예비창업자 분기 *(10월 구현)*

## Dev Tasks — 9월 (마감 09-30)

- [[0916-infra]] — 이름 정리, 카카오 신청, DB 기동, 마이그레이션
- [[0917-auth]] — 카카오 로그인, 가입 폼
- [[0918-vendors]] — 거래처 CRUD
- [[0919-order-ui]] — 발주 입력 화면
- [[0920-order-convert]] — 자연어 발주 변환 (**LLM 제공자 확정 임계점**)
- [[0921-vendor-match]] — 거래처명 매칭
- [[0922-share-history]] — 공유, 발주 이력
- [[0923-settings]] — AI 검색 범위, 개인정보처리방침
- [[0928-order-reuse]] — "어제처럼 발주"
- [[0929-aura-export]] — AURA JSON 내보내기
- [[0930-deploy]] — 리눅스 서버 배포, 실사용자 투입

## Dev Tasks — 10월 이월

- [[oct-law-rag]] — 법령 RAG, 상권 데이터
- [[oct-web-fallback]] — 웹 폴백, 출처 배지, 캐시
- [[oct-checklists]] — 체크리스트, 예비창업자 모드

## Sources

아직 등록된 source 문서가 없습니다.

## Errors / Lessons

아직 등록된 error 문서가 없습니다.

## Prompt Library

- [[prompts/first-setup]]
- [[prompts/save]]
- [[prompts/query]]
- [[prompts/ingest]]
- [[prompts/lint]]
- [[prompts/handoff]]
- [[prompts/bootstrap-dev-agents]]
