.PHONY: all
all: clean build

.PHONY: build
build:
	hugo --logLevel info

.PHONY: clean
clean:
	rm -Rf ../docs/*

.PHONY: server
server:
	hugo server --bind 0.0.0.0


