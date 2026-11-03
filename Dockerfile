# Shuffle's fork requires the patched toolchain; see SECURITY_FORK.md.
ARG GO_VERSION=1.27.3
FROM golang:${GO_VERSION} AS build

WORKDIR /app

# copy source
COPY go.mod go.sum main.go ./

# fetch deps separately (for layer caching)
RUN go mod download

# build the executable
COPY cmd ./cmd
ENV CGO_ENABLED=0
RUN go build -mod=readonly -trimpath

# create super thin container with the binary only
FROM scratch
COPY --from=build /app/terragrunt-atlantis-config /app/terragrunt-atlantis-config
ENTRYPOINT [ "/app/terragrunt-atlantis-config" ]
