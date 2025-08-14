FROM dunglas/frankenphp

# Argumentos para o usuário
ARG USER=code
ARG UID=1000

# Cria o usuário
RUN \
 useradd -m -u ${UID} ${USER}; \
 setcap CAP_NET_BIND_SERVICE=+eip /usr/local/bin/frankenphp; \
 chown -R ${USER}:${USER} /data/caddy && chown -R ${USER}:${USER} /config/caddy

# Variáveis de ambiente
#ENV SERVER_NAME=your-domain.example.com
ENV SERVER_NAME=:80
# número de processos (sugestão: 1 por CPU = 1)
ENV FRANKENPHP_WORKERS=1
# número de threads por processo (sugestão: 2x CPUs = 2)
ENV FRANKENPHP_THREADS=2
ARG APP_ENV=local
ENV APP_ENV=${APP_ENV}
RUN echo "APP_ENV: $APP_ENV"

# Configuração do PHP
RUN if [ "$APP_ENV" = "production" ]; then \
    cp $PHP_INI_DIR/php.ini-production $PHP_INI_DIR/php.ini; \
  else \
    cp $PHP_INI_DIR/php.ini-development $PHP_INI_DIR/php.ini; \
  fi

# Copia arquivos de configuração personalizados
COPY docker/franken/php-web.ini /usr/local/etc/php/conf.d/00-web.ini
COPY docker/franken/php-cli.ini /usr/local/etc/php/cli/conf.d/00-cli.ini

# Instala dependências e extensões PHP
RUN apt-get update && apt-get install -y \
    libpq-dev \
    libzip-dev \
    libicu-dev \
    libpng-dev \
    unzip \
    && docker-php-ext-install \
      pdo \
      pdo_pgsql \
      pgsql \
      pcntl \
      bcmath \
      gd \
      intl \
      zip \
      opcache \
      exif \
      sockets \
    && rm -rf /var/lib/apt/lists/* /tmp/pear

# Instalar Redis PHP extension
RUN pecl install -o -f redis && docker-php-ext-enable redis

# Instala o Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Instalar Node.js e NPM
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g npm@latest

# Copia o código da aplicação
COPY . /app

# Define o diretório de trabalho
WORKDIR /app

# Instala dependências do Composer conforme ambiente
RUN if [ "$APP_ENV" = "production" ]; then \
      composer install --no-dev --optimize-autoloader --prefer-dist --no-interaction --no-progress; \
    else \
      composer install --prefer-dist --no-interaction --no-progress; \
    fi

# Copia o arquivo de configuração do Caddy
COPY docker/franken/Caddyfile /etc/caddy/Caddyfile

# Ajustar permissões do Laravel (pasta storage e bootstrap/cache)
RUN chown -R $USER:www-data /app/storage /app/bootstrap/cache

# Expor portas HTTP e WebSocket
EXPOSE 80 6001

# Trocar para usuário não-root para segurança
USER $USER

# Define o ponto de entrada
CMD ["frankenphp", "run", "--config", "/etc/caddy/Caddyfile"]
