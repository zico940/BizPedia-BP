---
name: executing-plans
description: Use when you have a written implementation plan to execute in a separate session with review checkpoints
---

# Executing Plans

## Overview

Load plan, review critically, execute all tasks, report when complete.

**Announce at start:** "I'm using the executing-plans skill to implement this plan."

> **이 프로젝트에서의 적용** (`CLAUDE.md` / `.claude/rules/dev-common.md` 우선)
>
> - 서브에이전트 분배는 **pm이 한다.** `subagent-driven-development`와
>   `dispatching-parallel-agents`는 이 프로젝트에 설치하지 않았다.
> - worktree를 쓰지 않는다. 브랜치 전략은 git-manager가 관리한다.
> - 커밋·푸시는 **git-manager만** 실행한다.
> - 계획 실행 중 설계를 바꿔야 하면 "설계 변경 필요"로 보고하고 멈춘다.

## The Process

### Step 1: Load and Review Plan
1. Read plan file
3. Review critically - identify any questions or concerns about the plan
4. If concerns: Raise them with your human partner before starting
5. If no concerns: Create todos for the plan items and proceed

### Step 2: Execute Tasks

For each task:
1. Mark as in_progress
2. Follow each step exactly (plan has bite-sized steps)
3. Run verifications as specified
4. Mark as completed

### Step 3: Complete Development

After all tasks complete and verified:
- Run tests/build. Only what passes gets committed.
- Hand the changed-file list to **git-manager** for the commit
  (`.claude/rules/dev-common.md` 규칙 4).
- Report to pm with file paths and a summary.

## When to Stop and Ask for Help

**STOP executing immediately when:**
- Hit a blocker (missing dependency, test fails, instruction unclear)
- Plan has critical gaps preventing starting
- You don't understand an instruction
- Verification fails repeatedly

**Ask for clarification rather than guessing.**

## When to Revisit Earlier Steps

**Return to Review (Step 1) when:**
- Partner updates the plan based on your feedback
- Fundamental approach needs rethinking

**Don't force through blockers** - stop and ask.

## Remember
- Review plan critically first
- Follow plan steps exactly
- Don't skip verifications
- Reference skills when plan says to
- Stop when blocked, don't guess
- Never start implementation on main/master branch without explicit user consent
- 구현 착수는 사용자의 명시적 지시가 있을 때만 ([[dev-workflow]])
