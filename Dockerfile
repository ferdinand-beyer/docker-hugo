FROM golang:latest AS build

ARG HUGO_VERSION
ARG HUGO_BUILD_TAGS=extended

ARG CGO=1
ENV CGO_ENABLED=${CGO}
ENV GOOS=linux
ENV GO111MODULE=on

WORKDIR /build

RUN git clone --depth 1 --branch v${HUGO_VERSION} https://github.com/gohugoio/hugo.git .

RUN go build -trimpath -o=hugo -ldflags="-s -w" -tags extended

FROM ubuntu:latest

COPY --from=build /build/hugo /usr/local/bin/

RUN set -eux; \
    apt-get update; \
    apt-get install -y \
        asciidoctor \
        plantuml \
        ; \
    rm -rf /var/lib/apt/lists/*;

RUN gem install --no-document \
        asciidoctor-diagram \
        asciidoctor-html5s \
        rouge

WORKDIR /src
EXPOSE 1313
CMD ["hugo"]
