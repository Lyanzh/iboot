@******************************************************************************
@ File：head.S
@ 功能:设置SDRAM，将程序复制到SDRAM，然后跳到SDRAM继续执行
@******************************************************************************       
   
.extern     main
.text 
.global _start 
_start:
	b Reset
	ldr pc, HandlerUndef
	ldr pc, HandlerSWI
	ldr pc, HandlerPabort
	ldr pc, HandlerDabort
	ldr pc, HandlerNorUsed
	ldr pc, HandlerIRQ
	ldr pc, HandlerFIQ

HandlerUndef:	.word __undef
HandlerSWI: 	.word __swi
HandlerPabort:	.word __pabort
HandlerDabort:	.word __dabort
HandlerNorUsed: .word __notused
HandlerIRQ: 	.word __irq
HandlerFIQ: 	.word __fiq

Reset:                  
    ldr sp, =4096           @ 置栈指针，以下都是C函数，调用前需要设好栈
    bl  disable_watch_dog
    bl  disable_interrupt
    bl  clock_init
    bl  cpu_init				@ 关闭MMU
    bl  memsetup
    bl  copy_steppingstone_to_sdram     @ 复制代码到SDRAM中
    ldr pc, =on_sdram
on_sdram:
    ldr sp, =0x34000000
    ldr lr, =halt_loop
    ldr pc, =main
halt_loop:
    b   halt_loop

/* 异常处理向量 */
__undef:
__swi:
__pabort:
__dabort:
__notused:
__irq:
__fiq:

