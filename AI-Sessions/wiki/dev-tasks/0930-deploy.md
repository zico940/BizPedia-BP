---
type: dev-task
date: 2026-09-30
status: draft
owner: shared
---

# 09-30 (수) — 배포

## Summary

리눅스 서버에 배포하고 실사용자 투입을 준비한다.
완료 기준: 외부 기기(휴대폰 LTE)에서 접속해 로그인까지 왕복된다.

**마감일이다.** 버퍼가 없다.

## Details

### 배포 절차

```bash
git clone <repo>
cp .env.example .env    # 값 채우기
docker compose up -d
# 마이그레이션 001·002 실행
npm ci && npm run build && npm start
```

### 체크리스트

- [ ] `.env`의 `AUTH_URL`을 실제 도메인으로
- [ ] 카카오 콘솔 Redirect URI에 **운영 URL 등록** (HTTPS 필수)
- [ ] `pg_dump` 크론 — `pgdata` 볼륨은 컨테이너 삭제엔 견디지만 디스크 사고엔 못 견딘다
- [ ] 방화벽 — DB 포트(5432)를 외부에 열지 않는다
- [ ] 개인정보처리방침 페이지 접근 확인

### 미확정 — 서버 정보

사양·접속 방법·도메인이 정해지지 않았다.
**HTTPS가 없으면 카카오 Redirect URI 등록이 막혀 로그인 자체가 안 된다.**
가장 먼저 확인해야 할 항목이다.

Web Share API도 HTTPS를 요구하므로 공유 기능이 함께 막힌다.

### 실사용자 투입

발주 변환 + "어제처럼 발주"를 사장님 10명에게 일주일 쓰게 한다.
**3명이 계속 쓰는지**가 판정 기준이다.

## 완료 확인

1. 휴대폰 LTE(와이파이 아님)로 접속 → 카카오 로그인 → 홈
2. 계정 두 개로 격리 최종 확인
3. `pg_dump` 크론이 실제로 파일을 남기는지

## Links

- [[bizpedia-mvp]]
- [[auth-design]]
- [[data-isolation-policy]]
- [[0929-aura-export]]
- [[index]]
