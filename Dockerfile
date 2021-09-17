FROM alpine as alpine

RUN apk add -U --no-cache ca-certificates

FROM golang as golang

WORKDIR $GOPATH/src/github.com/ryane/kfilt

COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .

RUN go build -ldflags "-linkmode external -extldflags -static" -o /kfilt .

FROM scratch
COPY --from=alpine /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=golang /kfilt /
COPY LICENSE /
ENTRYPOINT ["/kfilt"]
