@******************************************************************************
@ File：head.S
@ 功能:设置SDRAM，将程序复制到SDRAM，然后跳到SDRAM继续执行
@******************************************************************************       

#include "config.h"

_TEXT_BASE:
	.word	TEXT_BASE

.globl _armboot_start
_armboot_start:
	.word _start

/*
 * These are defined in the board-specific linker script.
 */
 .globl _bss_start
_bss_start:
	.word __bss_start

.globl _bss_end
_bss_end:
	.word __bss_end

.extern	main
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
	
	/* set the cpu to SVC32 mode(2440上电即为此模式，故此段代码可以省略) */
	mrs r0, cpsr
	bic r0, r0, #0x1f
	orr r0, r0, #0xd3
	msr cpsr, r0

	ldr sp, =4096           /* 置栈指针，以下都是C函数，调用前需要设好栈 */
	bl  disable_watch_dog	/* 关闭看门狗								 */
	bl  disable_interrupt	/* 禁止中断									 */
	bl  clock_init			/* 初始化时钟								 */
	bl  cpu_init			/* 关闭MMU									 */
	bl  memsetup			/* 初始化SDRAM								 */
	bl  nand_init           /* 初始化NAND Flash							 */

	/* 将NAND Flash中代码复制到SDRAM中 */
relocate:				/* relocate U-Boot to RAM		*/
	adr r0, _TEXT_BASE	/* 目标地址						*/
	ldr r1, _start		/* 源地址						*/
#if 0
	cmp 	r0, r1		/* don't reloc during debug		*/
	beq 	clear_bss
#endif
	ldr r2, _armboot_start
	ldr r3, _bss_start
	sub r2, r3, r2		/* r2 <- size of armboot = _bss_start - _armboot_start */
	bl  nand_read		/* 调用C函数nand_read			*/

	/* bss段清零 */
clear_bss:
	ldr r0, _bss_start		/* find start of bss segment		*/
	ldr r1, _bss_end		/* stop here						*/
	mov r2, #0x00000000		/* clear							*/

clbss_l:					/* clear bss loop...				*/
	str r2, [r0]
	add r0, r0, #4
	cmp r0, r1
	ble clbss_l

	/* Set up the stack */
stack_setup:
	ldr r0, _TEXT_BASE				/* upper 128 KiB: relocated uboot	*/
	sub r0, r0, #CFG_MALLOC_LEN		/* malloc area						*/
	sub r0, r0, #CFG_GBL_DATA_SIZE	/* bdinfo						 	*/

#ifdef CONFIG_USE_IRQ
	sub r0, r0, #(CONFIG_STACKSIZE_IRQ+CONFIG_STACKSIZE_FIQ)
#endif
	sub sp, r0, #12 	/* leave 3 words for abort-stack	*/

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

