#!/usr/bin/env bash
# ติดตั้งชุด skills สำหรับ Claude Code — ดูรายละเอียดใน README.md
# ใช้: bash install.sh [--global]
set -euo pipefail

SCOPE_FLAG=()
IMPECCABLE_SCOPE=project
if [[ "${1:-}" == "--global" || "${1:-}" == "-g" ]]; then
  SCOPE_FLAG=(-g)
  IMPECCABLE_SCOPE=global
fi

command -v npx >/dev/null || { echo "ไม่พบ npx — ติดตั้ง Node.js ก่อน" >&2; exit 1; }

add() { npx -y skills add "$@" -a claude-code -y ${SCOPE_FLAG[@]+"${SCOPE_FLAG[@]}"}; }

echo "==> [1/5] claude-mem skills"
add thedotmack/claude-mem --skill "Agent Cost Report" babysit ccs-align cloud-sync \
  design-is do handoff how-it-works knowledge-agent learn-codebase make-plan \
  mem-search mem-setup mode-creator oh-my-issues pathfinder screenpipe \
  smart-explore standup timeline-report version-bump weekly-digests what-the wowerpoint

echo "==> [2/5] anthropics/skills"
add anthropics/skills --skill frontend-design

echo "==> [3/5] vercel-labs"
add vercel-labs/agent-skills --skill web-design-guidelines
add vercel-labs/skills --skill find-skills

echo "==> [4/5] task-observer"
add rebelytics/one-skill-to-rule-them-all

echo "==> [5/5] impeccable"
npx -y impeccable install --providers=claude --scope="$IMPECCABLE_SCOPE"

cat <<'EOF'

เสร็จแล้ว ขั้นที่เหลือต้องตอบคำถาม จึงต้องรันเอง:

  1) SDLC harness (รันที่ root ของโปรเจกต์ ครั้งเดียวต่อโปรเจกต์)
       npx @warnyin/sdlc init --tool claude

  2) claude-mem worker (จำเป็นสำหรับ mem-search และ skills กลุ่ม memory)
       npx claude-mem install

  3) เปิด Claude Code ใหม่ แล้วรัน /impeccable init และ /sdlc:next
EOF
