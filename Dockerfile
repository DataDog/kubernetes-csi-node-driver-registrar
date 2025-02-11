ARG BASE_IMAGE
ARG BUILDER_IMAGE

FROM $BUILDER_IMAGE AS builder
WORKDIR /go/src/kubernetes-csi/node-driver-registrar
ADD . .
ENV GOTOOLCHAIN auto
RUN make build

FROM $BASE_IMAGE
LABEL maintainers="Compute"
LABEL description="CSI Node driver registrar"
ARG binary=./bin/csi-node-driver-registrar

COPY --from=builder /go/src/kubernetes-csi/node-driver-registrar/${binary} csi-node-driver-registrar
ENTRYPOINT ["/csi-node-driver-registrar"]
