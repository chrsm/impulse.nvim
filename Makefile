.PHONY: all build clean

all: build

build:
	cd lua && yue .

clean:
	cd lua && find . -type f -name '*.lua' -delete
