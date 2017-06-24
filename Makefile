objs := head.o init.o serial.o main.o

iBoot.bin: $(objs)
	arm-linux-ld -Tiboot.lds -o iBoot_elf $^
	arm-linux-objcopy -O binary -S iBoot_elf $@
	arm-linux-objdump -D -m arm iBoot_elf > iBoot.dis
	
%.o:%.c
	arm-linux-gcc -Wall -O2 -c -o $@ $<

%.o:%.S
	arm-linux-gcc -Wall -O2 -c -o $@ $<

clean:
	rm -f iBoot.bin iBoot_elf iBoot.dis *.o
	