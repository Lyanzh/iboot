
CC      = arm-linux-gcc
LD      = arm-linux-ld
AR      = arm-linux-ar
OBJCOPY = arm-linux-objcopy
OBJDUMP = arm-linux-objdump
INCLUDEDIR 	:= $(shell pwd)/include
CFLAGS 		:= -Wall -O2
CPPFLAGS   	:= -nostdinc -I$(INCLUDEDIR)

export 	CC LD OBJCOPY OBJDUMP INCLUDEDIR CFLAGS CPPFLAGS

objs := head.o init.o nand.o serial.o main.o lib/libc.a

iBoot.bin: $(objs)
	${LD} -Tiboot.lds -Ttext 0x33F80000 -o iBoot_elf $^
	${OBJCOPY} -O binary -S iBoot_elf $@
	${OBJDUMP} -D -m arm iBoot_elf > iBoot.dis

.PHONY : lib/libc.a
lib/libc.a:
	cd lib; make; cd ..

%.o:%.c
	${CC} $(CPPFLAGS) $(CFLAGS) -c -o $@ $<

%.o:%.S
	${CC} $(CPPFLAGS) $(CFLAGS) -c -o $@ $<

clean:
	make  clean -C lib
	rm -f iBoot.bin iBoot_elf iBoot.dis *.o
	