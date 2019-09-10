ARG IMAGE
FROM $IMAGE

RUN pacman -Syy --noconfirm nodejs npm
