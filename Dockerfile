# Sử dụng hình ảnh chính thức của PHP có cài sẵn Apache
FROM php:7.4-apache

# Cài đặt các extension PHP cần thiết cho Drupal
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libonig-dev \
    libzip-dev \
    zip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install zip \
    && docker-php-ext-install pdo pdo_mysql

# Tải Composer và cài đặt vào Docker
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Cài đặt Drupal vào thư mục /var/www/html (thư mục chính của Apache)
COPY . /var/www/html

# Chỉnh quyền truy cập cho thư mục để phù hợp với Apache
RUN chown -R www-data:www-data /var/www/html

# Mở cổng 80 cho Apache
EXPOSE 80
