TEST_M:
    li s0, 0x80100000   # 测试起始地址
    li s1, 0x80800000   # 测试结束地址(不可达)
    li a0, 0x11111111
    li a1, 0x22222222
    li a2, 0x44444444
    li a3, 0x88888888
    li a4, 0xffffffff
    li a5, 0x5a5a5a5a
    
store:
    mv s2, s0
store_loop:
    xor t0, s2, a0
    xor t1, s2, a1
    xor t2, s2, a2
    xor t3, s2, a3
    sw t0, 0(s2)
    sw t1, 0x4(s2)
    sw t2, 0x8(s2)
    sw t3, 0xc(s2)
    addi s2, s2, 0x10
    beq s2, s1, load
    j store_loop

load:
    mv s2, s0
load_loop:
    xor t0, s2, a0
    xor t1, s2, a1
    xor t2, s2, a2
    xor t3, s2, a3
    lw t4, 0(s2)
    lw t5, 0x4(s2)
    lw t6, 0x8(s2)
    lw s7, 0xc(s2)
    bne t0, t4, error
    bne t1, t5, error
    bne t2, t6, error
    bne t3, s7, error
    addi s2, s2, 0x10
    beq s2, s1, sw_lw
    j load_loop

sw_lw:
    mv s2, s0
sw_lw_loop:
    xor t0, s2, a4
    xor t1, s2, a5
    sw t0, 0(s2)
    lw t2, 0(s2)
    sw t1, 0x4(s2)
    lw t3, 0x4(s2)
    bne t0, t2, error
    bne t1, t3, error
    addi s2, s2, 0x8
    beq s2, s1, ok
    j sw_lw_loop

ok:
    li a0, 'A'
    j WRITE_SERIAL

error:
    li a0, 'E'
    j WRITE_SERIAL

WRITE_SERIAL:                       # 写串口：将a0的低八位写入串口
    li t0, 0x10000000
.TESTW:
    lb t1, 5(t0)                    # 查看串口状态
    andi t1, t1, 0x20               # 截取写状态位
    bne t1, zero, .WSERIAL          # 状态位非零可写进入写
    j .TESTW                        # 检测验证，忙等待
.WSERIAL:
    sb a0, 0(t0)                    # 写入寄存器a0中的值
    
end:
    nop
    beq zero, zero, end
