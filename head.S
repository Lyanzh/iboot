@******************************************************************************
@ File��head.S
@ ����:����SDRAM���������Ƶ�SDRAM��Ȼ������SDRAM����ִ��
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
    ldr sp, =4096           @ ��ջָ�룬���¶���C����������ǰ��Ҫ���ջ
    bl  disable_watch_dog
    bl  disable_interrupt
    bl  clock_init
    bl  cpu_init				@ �ر�MMU
    bl  memsetup
    bl  copy_steppingstone_to_sdram     @ ���ƴ��뵽SDRAM��
    ldr pc, =on_sdram
on_sdram:
    ldr sp, =0x34000000
    ldr lr, =halt_loop
    ldr pc, =main
halt_loop:
    b   halt_loop

/* �쳣�������� */
__undef:
__swi:
__pabort:
__dabort:
__notused:
__irq:
__fiq:
