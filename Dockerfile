FROM ubuntu:20.04

RUN apt-get update && apt-get install -y \
    asciidoctor \
    curl \
    plantuml \
    && rm -rf /var/lib/apt/lists/*

RUN gem install \
    asciidoctor-diagram \
    asciidoctor-html5s

ARG HUGO_VERSION=0.78.1

COPY hugo_${HUGO_VERSION}_checksums.txt /tmp/hugo/
RUN HUGO_DEB=hugo_${HUGO_VERSION}_Linux-64bit.deb \
    && cd /tmp/hugo \
    && curl -fLO https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/${HUGO_DEB} \
    && grep ${HUGO_DEB} hugo_${HUGO_VERSION}_checksums.txt | sha256sum -c \
    && dpkg -i ${HUGO_DEB} \
    && rm -rf /tmp/hugo

