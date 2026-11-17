#!/usr/bin/env bash
# 一键把攻略发布到 GitHub Pages。可重复运行。
# 用法： ./deploy.sh          或使用自定义仓库名： REPO=my-trip ./deploy.sh
set -euo pipefail
cd "$(dirname "$0")"

REPO="${REPO:-spring2027-trip}"
BRANCH="main"

if ! command -v gh >/dev/null 2>&1; then
  echo "缺少 GitHub CLI，请先安装：brew install gh" >&2
  exit 1
fi

if ! OWNER="$(gh api user --jq .login 2>/dev/null)"; then
  echo "GitHub 尚未授权。请运行 gh auth login，或设置 GH_TOKEN 环境变量后重试。" >&2
  exit 1
fi
echo "GitHub 账号：$OWNER"

git branch -M "$BRANCH"

if ! git remote get-url origin >/dev/null 2>&1; then
  if gh repo view "$OWNER/$REPO" >/dev/null 2>&1; then
    echo "已存在同名仓库，连接到它"
    git remote add origin "https://github.com/$OWNER/$REPO.git"
  else
    echo "创建公开仓库 $OWNER/$REPO"
    gh repo create "$REPO" --public \
      --description "2027 春节 新加坡·马六甲·吉隆坡·亚庇 9晚10天图文攻略" \
      --source . --remote origin
  fi
fi

echo "推送 $BRANCH 分支..."
git push -u origin "$BRANCH"

PAGES_API="repos/$OWNER/$REPO/pages"
if gh api "$PAGES_API" >/dev/null 2>&1; then
  printf '{"source":{"branch":"%s","path":"/"}}' "$BRANCH" | gh api -X PUT "$PAGES_API" --input - >/dev/null
  echo "Pages 配置已更新"
else
  printf '{"source":{"branch":"%s","path":"/"}}' "$BRANCH" | gh api -X POST "$PAGES_API" --input - >/dev/null
  echo "Pages 已开启"
fi

echo ""
echo "手机打开： https://$OWNER.github.io/$REPO/"
echo "仓库地址： https://github.com/$OWNER/$REPO"
echo "首次构建大约需要 1 分钟；之后每次 git push 会自动更新。"
