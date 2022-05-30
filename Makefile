.PHONY: all build clean

all: build

build:
	cd yue && yue -l -s -t ../lua .

clean:
	find . -type f -name '*.lua' -delete
