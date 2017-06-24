#include "serial.h"

int main()
{
    unsigned char c;

	mmu_enableIcache();
	mmu_enableDcache();
	
    uart0_init();   // 波特率115200，8N1(8个数据位，无校验位，1个停止位)
	
	putc('a');
	putc('b');
	putc('c');

    while(1)
    {
        // 从串口接收数据后，判断其是否数字或子母，若是则加1后输出
        c = getc();
        if (isDigit(c) || isLetter(c))
            putc(c+1);
    }

    return 0;
}
