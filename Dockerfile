FROM ubuntu:20.04

RUN set -eux; \
    apt-get update; \
    apt-get install -y \
        asciidoctor \
        curl \
        plantuml \
        ; \
    rm -rf /var/lib/apt/lists/*;

RUN gem install --no-document \
        asciidoctor-diagram \
        asciidoctor-html5s \
        rouge

ARG HUGO_VERSION
WORKDIR /tmp/install-hugo
COPY hugo_${HUGO_VERSION}_checksums.txt ./checksums.txt
RUN set -eux; \
    HUGO_DEB="hugo_extended_${HUGO_VERSION}_Linux-64bit.deb"; \
    curl -fsLOS "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/${HUGO_DEB}"; \
    grep "${HUGO_DEB}" checksums.txt | sha256sum -c -; \
    dpkg -i "${HUGO_DEB}"; \
    rm -rf "$(pwd)";

WORKDIR /src
EXPOSE 1313
CMD ["hugo"]
