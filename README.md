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

前提：已安装 GitHub CLI（`brew install gh`）。

```bash
gh auth login          # 或者设置 GH_TOKEN 环境变量
./deploy.sh            # 创建公开仓库、推送、开启 Pages，最后打印访问链接
```

想换仓库名：`REPO=my-trip ./deploy.sh`。

> GitHub 免费账户的 Pages 需要**公开仓库**；私有仓库开启 Pages 需要付费套餐。攻略里没有私人证件号、订单号等信息，但仍建议发布前通读一遍。

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
| `deploy.sh` | 幂等的一键发布脚本，可重复运行 |
| `.nojekyll` | 让 GitHub Pages 原样输出静态文件，跳过 Jekyll 处理 |
