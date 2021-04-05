FROM golang:alpine AS build-env
#RUN mkdir /go/src/app && apk update && apk add git
RUN mkdir /go/src/app && apk update
ADD main.go /go/src/app/
WORKDIR /go/src/app
RUN CGO_ENABLED=0 GOOS=linux GO111MODULE=auto go build -a -installsuffix cgo -ldflags '-extldflags "-static"' -o app .

FROM scratch
WORKDIR /app
COPY --from=build-env /go/src/app/app .
CMD [ "./app" ]
