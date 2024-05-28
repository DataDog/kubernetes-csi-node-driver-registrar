ARG BASE_IMAGE

FROM registry.ddbuild.io/images/mirror/golang:1.22 as builder
WORKDIR /go/src/kubernetes-csi/node-driver-registrar
ADD . .
ENV GOTOOLCHAIN auto
ENV GOFLAGS="-buildvcs=false"
RUN make build

FROM $BASE_IMAGE
LABEL maintainers="Compute"
LABEL description="CSI Node driver registrar"
ARG binary=./bin/csi-node-driver-registrar

COPY --from=builder /go/src/kubernetes-csi/node-driver-registrar/${binary} csi-node-driver-registrar
ENTRYPOINT ["/csi-node-driver-registrar"]
