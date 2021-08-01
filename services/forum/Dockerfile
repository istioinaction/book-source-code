FROM golang:alpine as builder
RUN mkdir /build

RUN apk add --no-cache git

ADD *.go /build/
ADD go.mod /build/
ADD go.sum /build/

WORKDIR /build
RUN go build -o main .

FROM alpine
RUN apk add --no-cache curl
COPY --from=builder /build/main /app/
WORKDIR /app
CMD ["./main"]