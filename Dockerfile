FROM ghcr.io/steamdeckhomebrew/holo-base:latest as tools

WORKDIR /app
COPY . /app

RUN set -eux; \
    pacman -S --noconfirm npm jq; \
    npm install -g npm@9.2.0 pnpm;
