# 2027 春节 · 新加坡 → 马六甲 → 吉隆坡 → 亚庇

9 晚 10 天图文攻略，主页面是单文件 `index.html`：4 张插画已内嵌，断网也能打开，手机上可直接操作。

## 手机打开

部署后访问 `https://<你的 GitHub 用户名>.github.io/spring2027-trip/`，用手机浏览器或微信打开即可，也可以「添加到主屏幕」当成一个离线小应用。

手机端已适配的操作：

- 每天行程可折叠 / 展开，顶部导航可横向滑动，滚动时会自动定位到当前章节
- 行前清单可勾选，进度自动保存在**当前设备的浏览器里**（换设备不同步，清缓存会清空）
- 宽表格可左右滑动查看，表格上方有滑动提示
- 右下角圆形按钮一键回到顶部
- 「打印 / 存 PDF」可导出纸质版

## 本地使用

直接双击 `index.html`，不需要服务器、不需要联网。

## 首次发布到 GitHub Pages

前提：已安装 GitHub CLI（`brew install gh`）并完成 `gh auth login`。

```bash
./deploy.sh            # 创建公开仓库、推送、开启 Pages，最后打印访问链接
```

想换仓库名：`REPO=my-trip ./deploy.sh`。

脚本会强制走 HTTPS 并使用 gh 的凭据助手（写入本仓库的 `.git/config`，不改动全局配置），因此不受本机 SSH 配置影响。

### 令牌权限要求

细粒度令牌（`github_pat_` 开头）默认权限很窄，常见报错是
`GraphQL: Resource not accessible by personal access token (createRepository)`。
到 <https://github.com/settings/personal-access-tokens> 编辑令牌，确认：

| 位置 | 需要的权限 |
| --- | --- |
| Repository permissions → Contents | **Read and write** |
| Account permissions → Repository creation | **Read and write** |
| Repository access | All repositories，或把目标仓库加入授权列表 |
| Repository permissions → Pages / Administration | Read and write（用于自动开启 Pages） |

改用经典令牌（`ghp_` 开头）时，勾选 `repo` scope 即可。若不想给账户级「创建仓库」权限，也可以先在网页手动建好公开空仓库，再重跑脚本——它会检测到并直接推送。

> GitHub 免费账户的 Pages 需要**公开仓库**；私有仓库开启 Pages 需要付费套餐。攻略里没有私人证件号、订单号等信息，但仍建议发布前通读一遍。

### 完全不用命令行

1. 打开 <https://github.com/new>，建一个名为 `spring2027-trip` 的**公开空仓库**（不要勾选 README）。
2. 在仓库页点 `Add file → Upload files`，把 `index.html` 拖进去并提交。
3. 打开 `Settings → Pages`，Source 选 `main` / `root`，保存。
4. 约一分钟后访问 `https://<用户名>.github.io/spring2027-trip/`。

## 之后更新内容

```bash
# 改完 index.html 后
git add index.html && git commit -m "更新攻略" && git push
```

GitHub Pages 通常在一分钟内自动更新，无需重新运行部署脚本。

## 文件说明

| 文件 | 说明 |
| --- | --- |
| `index.html` | 攻略主页面，图文全部内嵌，可直接分享这一个文件 |
| `assets/` | 4 张原始插画（PNG），可单独取用 |
| `deploy.sh` | 幂等的一键发布脚本，含权限报错指引，可重复运行 |
| `.nojekyll` | 让 GitHub Pages 原样输出静态文件，跳过 Jekyll 处理 |
