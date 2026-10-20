# ติดตั้งชุด skills สำหรับ Claude Code — ดูรายละเอียดใน README.md
# ใช้: .\install.ps1 [-Global]
param([switch]$Global)
$ErrorActionPreference = 'Stop'

if (-not (Get-Command npx -ErrorAction SilentlyContinue)) { throw 'ไม่พบ npx — ติดตั้ง Node.js ก่อน' }

$scope = if ($Global) { @('-g') } else { @() }
$impeccableScope = if ($Global) { 'global' } else { 'project' }

function Add-Skills([string[]]$SkillArgs) {
  & npx -y skills add @SkillArgs -a claude-code -y @scope
  if ($LASTEXITCODE -ne 0) { throw "ติดตั้งไม่สำเร็จ: $($SkillArgs[0])" }
}

Write-Host '==> [1/5] claude-mem skills'
Add-Skills @('thedotmack/claude-mem', '--skill', 'Agent Cost Report', 'babysit', 'ccs-align', 'cloud-sync',
  'design-is', 'do', 'handoff', 'how-it-works', 'knowledge-agent', 'learn-codebase', 'make-plan',
  'mem-search', 'mem-setup', 'mode-creator', 'oh-my-issues', 'pathfinder', 'screenpipe',
  'smart-explore', 'standup', 'timeline-report', 'version-bump', 'weekly-digests', 'what-the', 'wowerpoint')

Write-Host '==> [2/5] anthropics/skills'
Add-Skills @('anthropics/skills', '--skill', 'frontend-design')

Write-Host '==> [3/5] vercel-labs'
Add-Skills @('vercel-labs/agent-skills', '--skill', 'web-design-guidelines')
Add-Skills @('vercel-labs/skills', '--skill', 'find-skills')

Write-Host '==> [4/5] task-observer'
Add-Skills @('rebelytics/one-skill-to-rule-them-all')

Write-Host '==> [5/5] impeccable'
& npx -y impeccable install --providers=claude "--scope=$impeccableScope"
if ($LASTEXITCODE -ne 0) { throw 'ติดตั้ง impeccable ไม่สำเร็จ' }

Write-Host @'

เสร็จแล้ว ขั้นที่เหลือต้องตอบคำถาม จึงต้องรันเอง:

  1) SDLC harness (รันที่ root ของโปรเจกต์ ครั้งเดียวต่อโปรเจกต์)
       npx @warnyin/sdlc init --tool claude

  2) claude-mem worker (จำเป็นสำหรับ mem-search และ skills กลุ่ม memory)
       npx claude-mem install

  3) เปิด Claude Code ใหม่ แล้วรัน /impeccable init และ /sdlc:next
'@
