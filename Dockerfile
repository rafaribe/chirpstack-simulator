FROM golang:1.13-alpine as builder

ENV PROJECT_PATH=/chirpstack-simulator
ENV PATH=$PATH:$PROJECT_PATH/build
ENV CGO_ENABLED=0
ENV GO_EXTRA_BUILD_ARGS="-a -installsuffix cgo"

RUN apk add --no-cache ca-certificates tzdata make git bash

RUN mkdir -p $PROJECT_PATH
COPY . $PROJECT_PATH
WORKDIR $PROJECT_PATH
RUN make

WORKDIR ${PROJECT_PATH}/build

FROM alpine:3.11.3
RUN apk --no-cache add ca-certificates
COPY --from=builder /chirpstack-simulator/build/chirpstack-simulator /usr/bin/chirpstack-simulator
USER nobody:nogroup
ENTRYPOINT ["/usr/bin/chirpstack-simulator"]