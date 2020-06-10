# Stage 1: Build executable
FROM golang:alpine as builder

ADD . /go/src/github.com/grewhit25/healthcheck-server
WORKDIR /go/src/github.com/grewhit25/healthcheck-server

RUN CGO_ENABLED=0 go build -a -installsuffix cgo -o server
RUN CGO_ENABLED=0 go build -a -installsuffix cgo -o health-check ./healthcheck

# Stage 2: Create release image
FROM scratch as releaseImage

COPY --from=builder /go/src/github.com/grewhit25/healthcheck-server/server /usr/loca/bin/server
COPY --from=builder /go/src/github.com/grewhit25/healthcheck-server/health-check /usr/loca/bin/healthcheck

ENV PORT=8080
EXPOSE $PORT

ENTRYPOINT [ "server" ]
