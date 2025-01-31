# Stage 1: PHP-FPM with required extensions
FROM php:8.1-fpm-alpine AS php_build

# Install required PHP extensions and dependencies
RUN apk add --no-cache \
    nginx \
    php-mysqli \
    php-session \
    php-json \
    php-curl \
    php-gd \
    && rm -rf /var/cache/apk/*

# Copy application files
WORKDIR /var/www/html
COPY . /var/www/html
RUN chown -R www-data:www-data /var/www/html

# Stage 2: Final image with Nginx + PHP-FPM
FROM nginx:alpine

# Copy PHP-FPM from the build stage
COPY --from=php_build /var/www/html /var/www/html

# Copy Nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80 for web access
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
