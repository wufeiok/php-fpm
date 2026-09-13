# PHP 8.3 FPM 运行环境(不含业务代码,代码由宿主机目录挂载)
FROM php:8.3-fpm-alpine

# 用官方扩展安装器,自动处理各扩展的 apk 构建依赖并在装完后清理
# 手工写 apk add 很容易漏包名(gd 要 libpng/libjpeg/freetype,intl 要 icu-dev …)
COPY --from=mlocati/php-extension-installer:2 /usr/bin/install-php-extensions /usr/local/bin/

# 基础镜像已自带:ctype curl dom fileinfo filter iconv mbstring mysqlnd
#                 PDO pdo_sqlite Phar posix session SimpleXML tokenizer
#                 xml xmlreader xmlwriter 等
# 以下是需要额外编译的:
RUN install-php-extensions \
      bcmath \
      exif \
      ftp \
      gd \
      gettext \
      intl \
      mysqli \
      opcache \
      pcntl \
      pdo_mysql \
      shmop \
      soap \
      sockets \
      sodium \
      sysvsem \
      zip

# 使用生产版 php.ini
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# opcache 生产配置
RUN { \
      echo 'opcache.enable=1'; \
      echo 'opcache.memory_consumption=128'; \
      echo 'opcache.interned_strings_buffer=16'; \
      echo 'opcache.max_accelerated_files=20000'; \
      echo 'opcache.validate_timestamps=1'; \
      echo 'opcache.revalidate_freq=2'; \
    } > "$PHP_INI_DIR/conf.d/opcache.ini"

WORKDIR /var/www/html
