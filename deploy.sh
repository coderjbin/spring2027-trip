#!/usr/bin/env bash
# 一键把攻略发布到 GitHub Pages。可重复运行。
# 用法： ./deploy.sh          或使用自定义仓库名： REPO=my-trip ./deploy.sh
set -euo pipefail
cd "$(dirname "$0")"

REPO="${REPO:-spring2027-trip}"
BRANCH="main"

fail() { echo "ERROR: $*" >&2; exit 1; }
hint_permissions() {
  cat >&2 <<'EOF'

令牌权限不足。请到 https://github.com/settings/personal-access-tokens 编辑这个细粒度令牌：
  - Repository permissions → Contents: Read and write
  - Account permissions    → Repository creation: Read and write
  - Repository access      → All repositories，或把目标仓库加入授权列表
保存后重跑 ./deploy.sh。

也可以完全绕开令牌：浏览器打开 https://github.com/new 建一个公开空仓库
（不要勾选 README），在仓库页上传 index.html，再到 Settings → Pages 选择 main / root。
EOF
}

command -v gh >/dev/null 2>&1 || fail "缺少 GitHub CLI，请先安装：brew install gh"
OWNER="$(gh api user --jq .login 2>/dev/null)" || fail "GitHub 尚未授权。请运行 gh auth login，或设置 GH_TOKEN 环境变量。"
echo "GitHub 账号：$OWNER"

git branch -M "$BRANCH"

# gh 默认可能使用 SSH，而本机 ~/.ssh/config 含已废弃算法参数会让 SSH 直接失败。
# 这里强制 HTTPS，并只在本仓库配置 gh 的凭据助手（不改动全局 git 配置）。
git config --local credential.helper '!gh auth git-credential'
git config --local credential.useHttpPath true
REMOTE_URL="https://github.com/$OWNER/$REPO.git"

if ! git remote get-url origin >/dev/null 2>&1; then
  if gh repo view "$OWNER/$REPO" >/dev/null 2>&1; then
    echo "使用已存在的仓库 $OWNER/$REPO"
    git remote add origin "$REMOTE_URL"
  else
    echo "创建公开仓库 $OWNER/$REPO ..."
    if ! gh repo create "$REPO" --public \
        --description "2027 春节 新加坡·马六甲·吉隆坡·亚庇 9晚10天图文攻略" \
        --source . --remote origin >/dev/null 2>&1; then
      hint_permissions
      exit 1
    fi
  fi
fi
git remote set-url origin "$REMOTE_URL"

echo "推送 $BRANCH 分支..."
if ! GIT_TERMINAL_PROMPT=0 git push -u origin "$BRANCH"; then
  hint_permissions
  exit 1
fi

PAGES_API="repos/$OWNER/$REPO/pages"
PAGES_BODY=$(printf '{"source":{"branch":"%s","path":"/"}}' "$BRANCH")
if gh api "$PAGES_API" >/dev/null 2>&1; then
  printf '%s' "$PAGES_BODY" | gh api -X PUT "$PAGES_API" --input - >/dev/null \
    && echo "Pages 配置已更新" \
    || echo "提示：Pages 配置更新失败，请到仓库 Settings → Pages 手动选择 main / root。"
else
  if printf '%s' "$PAGES_BODY" | gh api -X POST "$PAGES_API" --input - >/dev/null 2>&1; then
    echo "Pages 已开启"
  else
    echo "提示：自动开启 Pages 失败（令牌缺 Pages / Administration 权限）。"
    echo "      请到 https://github.com/$OWNER/$REPO/settings/pages 手动选择 main / root。"
  fi
fi

echo ""
echo "手机打开： https://$OWNER.github.io/$REPO/"
echo "仓库地址： https://github.com/$OWNER/$REPO"
echo "首次构建大约需要 1 分钟；之后每次 git push 会自动更新。"
