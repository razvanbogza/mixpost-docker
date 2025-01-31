# Folosim o imagine oficială PHP cu FPM
FROM php:8.1-fpm

# Instalează pachetele necesare (extensii PHP, etc.)
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    && docker-php-ext-install pdo pdo_mysql

# Setează directorul de lucru
WORKDIR /var/www

# Copiază fișierele aplicației MixPost în container
COPY . .

# Instalează Composer pentru a instala dependențele PHP
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install --no-interaction

# Setează permisiuni corecte pentru directoare
RUN chown -R www-data:www-data /var/www

# Expune portul 9000
EXPOSE 9000

# Comanda de rulare a aplicației MixPost
CMD ["php-fpm"]
