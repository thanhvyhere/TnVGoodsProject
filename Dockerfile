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

# Đặt thư mục làm việc là /var/www/html (thư mục gốc của Apache)
WORKDIR /var/www/html

# Copy toàn bộ mã nguồn vào Docker, bao gồm cả thư mục web và file composer.json
COPY . /var/www/html

# Chạy composer install từ thư mục chứa composer.json (thư mục gốc dự án mystore)
RUN composer install --working-dir=/var/www/html

# Đảm bảo các quyền truy cập đúng cho Apache
RUN chown -R www-data:www-data /var/www/html

# Mở cổng 80 cho Apache
EXPOSE 80

# Chạy Apache khi container khởi động
CMD ["apache2-foreground"]
