SJASMPLUS=sjasmplus

build: clean
	mkdir -p build
	@${SJASMPLUS} ./src/main.asm --syntax=F --inc=./src
	tape2wav ./build/l48ramt.tap ./build/l48ramt.wav

	@${SJASMPLUS} ./src/rom.asm --syntax=F --inc=./src

run:
	sudo rm -f /usr/share/spectrum-roms/48.rom
	sudo ln -s $(CURDIR)/build/l48ramt.rom /usr/share/spectrum-roms/48.rom
	fuse --machine 48 -g 3x 

clean:
	@rm -f -r build
