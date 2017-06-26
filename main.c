#include "stdio.h"
#include "serial.h"

int main()
{
    char str[10];

	//mmu_enableIcache();
	//mmu_enableDcache();

    uart0_init();   // ������115200��8N1(8������λ����У��λ��1��ֹͣλ)
	

	printf("iBoot: A bootloader for JZ2440, version = %s.\r\n", "V0.00.01");

    while(1)
    {
        scanf("%s", str);
        printf("%s\r\n", str);
    }

    return 0;
}
