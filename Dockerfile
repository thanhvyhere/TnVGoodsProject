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

# Thiết lập DocumentRoot thành thư mục web của Drupal
RUN sed -i 's|/var/www/html|/var/www/html/web|g' /etc/apache2/sites-available/000-default.conf

# Bật các module Apache cần thiết
RUN a2enmod rewrite

# Cài đặt Drupal vào thư mục /var/www/html/web
COPY . /var/www/html

# Chỉnh quyền truy cập cho thư mục để phù hợp với Apache
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Tạo file .htaccess cho Apache nếu cần thiết (Drupal thường đi kèm với file này)
RUN cp /var/www/html/web/.htaccess /var/www/html/.htaccess || true

# Mở cổng 80 cho Apache
EXPOSE 80

# Khởi động Apache khi container chạy
CMD ["apache2-foreground"]
