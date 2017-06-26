OUTPUT_FORMAT("elf32-littlearm", "elf32-littlearm", "elf32-littlearm")
/*OUTPUT_FORMAT("elf32-arm", "elf32-arm", "elf32-arm")*/
OUTPUT_ARCH(arm)
ENTRY(_start)
SECTIONS {
    . = 0x00000000;
    .init : { head.o init.o nand.o}
    .text : { *(.text) }
    .rodata ALIGN(4) : {*(.rodata)}
    .data ALIGN(4)   : { *(.data) }
    __bss_start = .;
    .bss ALIGN(4)  : { *(.bss)  *(COMMON) }
    __bss_end = .;
}

