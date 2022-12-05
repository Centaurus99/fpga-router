.section .text
.globl _start
.globl WRITE_SERIAL
.globl READ_SERIAL

_start:
    jal READ_SERIAL
    jal WRITE_SERIAL

.POPCOUNT:
    li a0, 'P'
    jal WRITE_SERIAL

    li t0, 0xffffffff
    li t1, 32
    pcnt t2, t0
    bne t2, t1, error
    li a0, '1'
    jal WRITE_SERIAL

    li t0, 0x1234fedc
    li t1, 17
    pcnt t2, t0
    bne t2, t1, error
    li a0, '2'
    jal WRITE_SERIAL

    li t0, 0
    li t1, 0
    pcnt t2, t0
    bne t2, t1, error
    li a0, '3'
    jal WRITE_SERIAL

.CTZ:
    li a0, 'C'
    jal WRITE_SERIAL

    li t0, 0
    li t1, 32
    ctz t2, t0
    bne t2, t1, error
    li a0, '1'
    jal WRITE_SERIAL

    li t0, 0xf8e20000
    li t1, 17
    ctz t2, t0
    bne t2, t1, error
    li a0, '2'
    jal WRITE_SERIAL

    li t0, 0x00000008
    li t1, 3
    ctz t2, t0
    bne t2, t1, error
    li a0, '3'
    jal WRITE_SERIAL

    j end

error:
    li a0, 'E'
    jal WRITE_SERIAL

end:
    li a0, 'E'
    beq zero, zero, end 

WRITE_SERIAL:                       # 写串口：将a0的低八位写入串口
    li t0, 0x10000000
.TESTW:
    lb t1, 5(t0)                    # 查看串口状态
    andi t1, t1, 0x20               # 截取写状态位
    bne t1, zero, .WSERIAL          # 状态位非零可写进入写
    j .TESTW                        # 检测验证，忙等待
.WSERIAL:
    sb a0, 0(t0)                    # 写入寄存器a0中的值
    jr ra


READ_SERIAL:                        # 读串口：将读到的数据写入a0低八位
    li t0, 0x10000000
.TESTR:
    lb t1, 5(t0)
    andi t1, t1, 0x01               # 截取读状态位
    bne t1, zero, .RSERIAL          # 状态位非零可读进入读
    j .TESTR                        # 检测验证
.RSERIAL:
    lb a0, 0(t0)
    jr ra
