SJASMPLUS=sjasmplus

build: clean
	mkdir -p build
	@${SJASMPLUS} ./src/main.asm --syntax=F --inc=./src
	tape2wav ./build/l48ramt.tap ./build/l48ramt.wav

clean:
	@rm -f -r build
