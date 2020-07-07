FROM golang:alpine AS build-env
RUN apk --update --no-cache add bash && rm -rf /var/cache/apk/*
RUN mkdir /go/src/app && apk update && apk add git
ADD main.go /go/src/app/
WORKDIR /go/src/app
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags '-extldflags "-static"' -o app .

FROM scratch
WORKDIR /app
COPY --from=build-env /go/src/app/app .
COPY --from=build-env /bin/bash .
CMD [ "./app" ]

