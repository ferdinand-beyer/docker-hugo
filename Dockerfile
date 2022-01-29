FROM golang:alpine AS build

ARG HUGO_VERSION
ARG HUGO_BUILD_TAGS=extended

ARG CGO=1
ENV CGO_ENABLED=${CGO}
ENV GOOS=linux
ENV GO111MODULE=on

WORKDIR /go/src/github.com/gohugoio/hugo

# gcc/g++ are required to build SASS libraries for extended version
RUN apk update && \
    apk add --no-cache gcc g++ musl-dev git && \
    go get github.com/magefile/mage

RUN git clone --depth 1 --branch v${HUGO_VERSION} https://github.com/gohugoio/hugo.git .

RUN mage hugo && mage install

FROM ubuntu:latest

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

COPY --from=build /go/bin/hugo /usr/local/bin/

WORKDIR /src
EXPOSE 1313
CMD ["hugo"]
