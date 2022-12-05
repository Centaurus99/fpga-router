.global WRITE_SERIAL
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

.global READ_SERIAL
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
