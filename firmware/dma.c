#include <dma.h>
#include <printf.h>
#include <uart.h>

bool dma_lock_request() {
    DMA_CTRL = DMA_REG_CPU_LOCK;
    return (DMA_CTRL & DMA_REG_CPU_LOCK);
}

void dma_send_finish() { DMA_CTRL = DMA_REG_WAIT_ROUTER; }

bool dma_read_need() { return (DMA_CTRL & DMA_REG_WAIT_CPU); }

void dma_read_finish() { DMA_CTRL = DMA_REG_WAIT_CPU; }

void dma_demo() {
    printf("DMA Demo\r\n");
    char ch = 0;
    int write_len = 0;
    while (1) {
        if (dma_read_need()) { // 优先判断是否需要读取
            printf("DMA Read: len = %d data = ", DMA_LEN);
            for (int i = 0; i < DMA_LEN; i++) {
                printf("%02x ", DMA_PTR[i]);
            }
            printf(".\r\n");
            dma_read_finish(); // 读完后, 告知读取完成
        }
        if (!ch && (UART_LSR & COM_LSR_DR)) {
            ch = UART_THR;
        }
        if (ch) {
            if (ch == 'q') {
                break;
            } else if (ch == 'w') {
                if (!dma_lock_request()) { // 先获得写入锁, 再写入数据
                    continue;
                }
                printf("DMA Write: len = ");
                write_len = 0;
                ch = _getchar_uart();
                while (ch != ' ' && ch != '\r') {
                    write_len = 10 * write_len + ch - '0';
                    ch = _getchar_uart();
                }
                printf("%d data = ", write_len);
                DMA_LEN = write_len;

                ch = _getchar_uart();
                uint32_t cnt = 0;
                while (ch != '\r') {
                    uint8_t data = 0;
                    while (ch != ' ' && ch != '\r') {
                        if (ch >= '0' && ch <= '9')
                            data = 16 * data + ch - '0';
                        else if (ch >= 'a' && ch <= 'f')
                            data = 16 * data + ch - 'a' + 10;
                        else if (ch >= 'A' && ch <= 'F')
                            data = 16 * data + ch - 'A' + 10;
                        else
                            break;
                        ch = _getchar_uart();
                    }
                    DMA_PTR[cnt++] = data;
                    printf("%02x ", data);
                    ch = _getchar_uart();
                }

                // 检验写入是否正确
                // printf(".\r\n");
                // printf("DMA Check: len = %d data = ", DMA_LEN);
                // for (int i = 0; i < DMA_LEN; i++) {
                //     printf("%02x ", DMA_PTR[i]);
                // }
                printf(".\r\n");
                dma_send_finish(); // 写完后, 告知发送完成
                ch = 0;
            } else {
                ch = 0;
            }
        }
    }
    printf("Exit Demo.\r\n");
}
