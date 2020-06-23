FROM golang:alpine as builder
RUN mkdir /build

RUN apk add --no-cache git

ADD *.go /build/
ADD go.mod /build/

WORKDIR /build
RUN go build -o main .

FROM alpine
RUN apk add --no-cache curl
RUN apk add --update tcpdump && rm -rf /var/cache/apk/*
COPY --from=builder /build/main /app/
WORKDIR /app
CMD ["./main"]