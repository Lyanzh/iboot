#ifndef __CONFIG_H
#define __CONFIG_H

#define CONFIG_USB_DEVICE   1

#ifdef CONFIG_USB_DEVICE
#define CONFIG_USE_IRQ		1
#endif


#define CFG_ENV_SIZE		0x20000	/* Total Size of Environment Sector */

#define	CFG_LOAD_ADDR		0x33000000	/* default load address	*/

/*
 * Size of malloc() pool
 */
#define CFG_MALLOC_LEN		(CFG_ENV_SIZE + 128*1024)
#define CFG_GBL_DATA_SIZE	128	/* size in bytes reserved for initial data */

/*-----------------------------------------------------------------------
 * Stack sizes
 *
 * The stack sizes are set up in start.S using the settings below
 */
#define CONFIG_STACKSIZE	(128*1024)	/* regular stack */
#ifdef CONFIG_USE_IRQ
#define CONFIG_STACKSIZE_IRQ	(4*1024)	/* IRQ stack */
#define CONFIG_STACKSIZE_FIQ	(4*1024)	/* FIQ stack */
#endif


TEXT_BASE = 0x33F80000

#endif

