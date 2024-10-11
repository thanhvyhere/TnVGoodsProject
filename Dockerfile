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
    git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install zip \
    && docker-php-ext-install pdo pdo_mysql

# Cài đặt Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Chép mã nguồn vào thư mục /var/www/html (thư mục chính của Apache)
COPY . /var/www/html

# Chạy composer install từ thư mục chứa composer.json
RUN cd /var/www/html && composer install --no-interaction || { echo "Composer install failed"; exit 1; }

# Đảm bảo các quyền truy cập đúng cho Apache
RUN chown -R www-data:www-data /var/www/html

# Mở cổng 80 cho Apache
EXPOSE 80

# Chạy Apache khi container khởi động
CMD ["apache2-foreground"]
