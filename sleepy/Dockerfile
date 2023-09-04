FROM golang:1.20.4 AS build

WORKDIR /go/src/github.com/github/sleepy

ADD . .

RUN go build ./...

FROM ubuntu:focal-20230801 AS run

COPY --from=build /go/src/github.com/github/sleepy/sleepy /go/bin/sleepy

RUN groupadd -g 604 sleepy && \
    useradd -r -u 604 -g sleepy sleepy

USER sleepy
