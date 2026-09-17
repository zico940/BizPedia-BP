# Project Skills

이 프로젝트에서 쓰는 스킬을 두는 곳이다.

`CLAUDE.md`의 Project Scope Only 규칙에 따라 전역(`~/.claude/skills/`)에 설치된 스킬은
쓰지 않는다. 다른 환경에서 같은 폴더를 열어도 동작이 같아야 하기 때문이다.

## 설치 방법

아래 대장의 스킬은 대부분 전역 설치를 기본으로 하는 배포판이다. 이 프로젝트는 전역
스킬을 쓰지 않으므로, **레포에서 스킬 폴더를 이 프로젝트의 `.claude/skills/<이름>/`
아래로 직접 복사**하는 방식으로 설치한다.

- `npx skills add <owner/repo>` 또는 `npx skills add <owner/repo> --skill "<이름>"`
  실행 시 설치 위치를 묻는 선택지가 나오면 **프로젝트 범위(`.claude/skills/`)**를 고른다.
  선택지가 없으면 전역에 받은 뒤 해당 폴더를 프로젝트로 복사한다.
- `/plugin` 계열 명령은 전역 설치만 지원하므로, 설치 후 스킬 폴더를 프로젝트로 복사한다.
- 에이전트는 `npx` / `/plugin` 같은 명령을 직접 실행하지 못한다. 설치는 사용자가 한다.
- 설치·제거하면 아래 대장 표를 즉시 갱신한다(상태, 실제 설치 명령, 출처).

## 스킬·플러그인 대장

에이전트는 스킬이 필요할 때 이 표를 먼저 본다. 참조 절차는
`.claude/rules/dev-common.md`의 Skill Usage에 있다.

| 스킬 | 상태 | 용도 | 설치 명령 | 출처 | 주 사용 에이전트 |
|---|---|---|---|---|---|
| export-template | 설치됨 | 이 vault를 깨끗한 배포 ZIP으로 내보냄. 작업 기록(log.md 항목, 진행 중 프로젝트 문서, 개인 설정)을 초기 상태로 되돌린 복사본을 만들고 zip으로 묶음. 원본 불변. `python .claude/skills/export-template/export.py <경로>` | 자체 제작 (이 레포에 포함) | 자체 제작 | 메인 세션 |
| taste-skill | 미설치 | 화면·UI 품질 개선("anti-slop" 프론트엔드). 구현용 스킬 + 레퍼런스 이미지 생성 스킬 묶음. DESIGN_VARIANCE / MOTION_INTENSITY / VISUAL_DENSITY 조절 | `npx skills add https://github.com/Leonxlnx/taste-skill` (특정 변형은 `--skill "design-taste-frontend"` 식) | https://github.com/Leonxlnx/taste-skill | frontend |
| superpowers | 미설치 | 설계 → 계획 → 구현 → 테스트 → 리뷰 전 과정 방법론. TDD·체계적 디버깅·브레인스토밍·계획 작성 스킬 포함 | `/plugin marketplace add obra/superpowers-marketplace` → `/plugin install superpowers@superpowers-marketplace` (또는 공식: `/plugin install superpowers@claude-plugins-official`) | https://github.com/obra/superpowers | backend, frontend, database, code-review |
| ponytail | 미설치 | 과설계 방지, 최소 구현 강제. 코드 작성 전 "이게 필요한가 → 기존 코드 → stdlib → 네이티브 → 설치된 의존성 → 한 줄 → 최소 구현" 사다리를 태움. `/ponytail-review`, `/ponytail ultra` 등 명령 제공 | `/plugin marketplace add DietrichGebert/ponytail` → `/plugin install ponytail@ponytail` (두 명령을 각각 따로 실행해야 설치됨) | https://github.com/dietrichgebert/ponytail | 전원 |
| eli5 | 설치됨 | 복잡한 개념을 간단하게 설명 | `npx skills add dreambigou/eli5` | https://github.com/dreambigou/eli5 | 메인 세션 |
| archify | 설치됨 | 코드베이스·시스템 설명을 아키텍처/워크플로우/시퀀스/데이터흐름/라이프사이클 다이어그램(HTML, PNG/SVG/WebM 내보내기 가능)으로 자동 생성 | `npx skills add tt-a1i/archify` — 실제로는 `.claude/skills/archify`가 `.agents/skills/archify`(레포 내부, 프로젝트 폴더 안)로 가는 심볼릭 링크로 설치됨. 전역(`~/.claude/skills/`) 아님 | https://github.com/tt-a1i/archify | 메인 세션, database, backend |
| archify-review | 설치됨 (부수 설치) | archify 저장소 자체의 이슈·PR·코드를 가치·비용·영향 관점에서 리뷰. archify 설치 시 함께 딸려온 스킬로, BizPedia 개발 작업과는 무관 — archify 자체에 기여할 때만 쓴다 | archify와 함께 설치됨 (별도 명령 없음) | https://github.com/tt-a1i/archify | 해당 없음 |
| claude-skills | 미설치 (참조용) | 여러 스킬을 담은 패키지 레포. `skill-finder` 스킬 포함(claude-plugins.dev 레지스트리에서 스킬을 찾아 설치·생성). 이 프로젝트에 필요한 개별 스킬을 여기서 골라 설치하는 용도 | `npx skills add ckorhonen/claude-skills` (개별: `--skill <이름>`) | https://github.com/ckorhonen/claude-skills | (필요 시 지정) |

- **상태**: `설치됨` / `미설치` / `미설치 (참조용)` — 참조용은 자체를 스킬로 쓰기보다 여기서 개별 스킬을 골라 받는 소스
- **설치 명령**: 사용자가 그대로 복붙할 수 있는 명령. 모르면 `확인 필요`
- **출처**: 배포 레포 URL. 추측 금지 — 모르면 `확인 필요`

## 관련 메모

- 개발 도구(스킬 아님) 설치법은 `.claude/rules/dev-environment.md`에 있다 — GitHub CLI 등.

## 역할별 권장 스킬

스킬 사용 절차는 `.claude/rules/dev-common.md`의 Skill Usage에 있다. 여기에 다시 적지 않는다.

아래 스킬은 설치되어 있을 때 우선 검토한다. 없다고 해서 반드시 설치해야 하는 것은 아니다.

| 에이전트 | 권장 스킬 | 용도 |
|---|---|---|
| backend | `superpowers` | 설계·디버깅·검증 절차 |
| frontend | `taste-skill`, `superpowers` | 화면 품질, 설계 절차 |
| database | `superpowers` | 스키마 설계 검증 |
| code-review | `superpowers` | 검수 절차 |
| 전원 | `ponytail` | 과설계 방지, 최소 구현 |
