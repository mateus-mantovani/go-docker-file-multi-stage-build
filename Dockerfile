#build stage
FROM golang:alpine AS builder
RUN apk add --no-cache git
WORKDIR /go/src
COPY . .
RUN go get .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .

#final stage
FROM scratch
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
WORKDIR /bin/
COPY --from=builder /go/src/app .
CMD [ "./app" ]
EXPOSE 3000