# Agent Work Log

이 파일은 에이전트 작업 로그입니다.

중요한 저장, ingest, query, lint 작업이 끝날 때 한 줄씩 추가합니다.

형식:

```text
YYYY-MM-DD HH:mm | command | summary | linked files
```

## Log

2026-09-15 22:11 | save | BizPedia MVP 10일 계획 맥락 저장 (기획 분석, 확정 제약, 미확정 5건) | AI-Sessions/wiki/projects/bizpedia-mvp.md, index.md
2026-09-15 22:14 | lint | 기존 FAIL 3건 수정 (agent-collaboration-model date TBD, index.md 깨진 링크 2건 제거), glossary 역링크 추가 | AI-Sessions/wiki/decisions/agent-collaboration-model.md, AI-Sessions/wiki/concepts/glossary.md, index.md
2026-09-15 22:31 | save | BizPedia 전체 설계 문서화 — decisions 2, design 4, dev-tasks 10 생성. 이전 프로젝트 문서(order-management-platform) 삭제 및 참조 정리, glossary에 BizPedia 용어 7개 추가 | AI-Sessions/wiki/decisions/*, AI-Sessions/wiki/design/*, AI-Sessions/wiki/dev-tasks/*, AI-Sessions/wiki/projects/bizpedia-mvp.md, AI-Sessions/wiki/concepts/glossary.md, index.md
2026-09-15 22:52 | save | users → app_users 이름 충돌 해소 (@auth/pg-adapter에 테이블명 옵션 없음). 마이그레이션·설계 문서 10곳 반영, 임베딩 차원 vector(1536) 확정 | app/migrations/001_init.sql, AI-Sessions/wiki/design/database-design.md, auth-design.md, user-mode-design.md, AI-Sessions/wiki/decisions/data-isolation-policy.md, AI-Sessions/wiki/dev-tasks/day01,02,05,09, AI-Sessions/wiki/projects/bizpedia-mvp.md
2026-09-15 23:20 | save | 설계 보완 — order-design·aura-export-design 신설, dev-tasks를 날짜 기준으로 재편(9월 11개 + 10월 3개), 옛 day01~day10 삭제, search/user-mode에 10월 구현 표시 | AI-Sessions/wiki/design/order-design.md, aura-export-design.md, AI-Sessions/wiki/dev-tasks/0916~0930,oct-*, AI-Sessions/wiki/projects/bizpedia-mvp.md, index.md
2026-09-15 23:45 | save | 개발 방식을 pm 체계로 환원. 승인 없이 작성된 코드 5개 파일 삭제, 착수 승인 기준 명문화 | AI-Sessions/wiki/decisions/dev-workflow.md, AI-Sessions/wiki/projects/bizpedia-mvp.md, AI-Sessions/wiki/decisions/agent-collaboration-model.md, index.md
2026-09-16 00:10 | save | 설계 26개 재검토 후 결함 수정 — orders.status 추가(AURA 3분류), session 콜백을 accounts 조회로 교체(어댑터는 jwt 콜백 미호출), 002_authjs.sql 생성, 허브 문서 기간·진행방식 갱신, 발주→의무 자동판정 복원 | app/migrations/001_init.sql, 002_authjs.sql, AI-Sessions/wiki/design/order-design.md, auth-design.md, database-design.md, aura-export-design.md, AI-Sessions/wiki/dev-tasks/0916-infra.md, 0922-share-history.md, oct-checklists.md, AI-Sessions/wiki/projects/bizpedia-mvp.md

