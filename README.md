# php-fpm

Saleor 部署方案配套的 PHP 8.3 FPM 运行环境镜像。

- 不含任何业务代码,代码由宿主机目录挂载到 `/var/www/html`
- 由 GitHub Actions 构建并推送到 `ghcr.io/<owner>/php-fpm`
- 扩展清单见 Dockerfile;`opcache` 已启用,未安装 `redis` 扩展
