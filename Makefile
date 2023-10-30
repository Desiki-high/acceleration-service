VERSION_TAG=$(shell git describe --match 'v[0-9]*' --dirty='.m' --always --tags)
GIT_COMMIT := $(shell git rev-list -1 HEAD)
BUILD_TIME := $(shell date -u +%Y%m%d.%H%M)

default: build

# Build binary to ./
build:
	go build -ldflags '-X main.versionTag=${VERSION_TAG} -X main.versionGitCommit=${GIT_COMMIT} -X main.versionBuildTime=${BUILD_TIME}' -gcflags=all="-N -l" ./cmd/acceld
	go build -ldflags '-X main.versionTag=${VERSION_TAG} -X main.versionGitCommit=${GIT_COMMIT} -X main.versionBuildTime=${BUILD_TIME}' -gcflags=all="-N -l" ./cmd/accelctl

install-check-tools:
	go install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.55.1

check:
	@echo "$@"
	@$(shell go env GOPATH)/bin/golangci-lint run

# Run unit testing
# Run a particular test in this way:
# go test -v -count=1 -run TestFoo ./pkg/...
ut: default
	go test -count=1 -v ./pkg/...

# Run integration testing
smoke: default
	go test -count=1 -v ./test

# Run testing 
test: default ut smoke

release-image:
	docker build -t goharbor/harbor-acceld -f script/release/Dockerfile .
