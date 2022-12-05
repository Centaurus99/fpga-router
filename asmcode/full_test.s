.section .text
.globl _start
.globl WRITE_SERIAL
.globl READ_SERIAL

_start:
    jal READ_SERIAL
    jal WRITE_SERIAL

MAIN_TEST_U:
    # U 型指令测试
    li a0, 'U'
    jal WRITE_SERIAL
    auipc s1, 0x12345
    li s2, 0x92345010
    bne s1, s2, error

MAIN_TEST_J:
    # jal / jalr 指令测试
    li a0, 'J'
    jal WRITE_SERIAL
    j TEST_J_START
    beq zero, zero, error
    beq zero, zero, error
    jalr 8(ra)  # 跳转到 j TEST_J_END 处
    beq zero, zero, error
TEST_J_START:
    jal TEST_J  # 记录 ra
    beq zero, zero, error
    beq zero, zero, error
TEST_J_END:
    j MAIN_TEST_B
    beq zero, zero, error

MAIN_TEST_B:
    # Branch 指令测试
    li a0, 'B'
    jal WRITE_SERIAL

TEST_B_beq:
    li a0, '1'
    jal WRITE_SERIAL
    addi t0, zero, 0x1
    addi t1, zero, 0x1
    beq t0, t1, TEST_B_beq_1
    beq zero, zero, error
TEST_B_beq_2:
    addi t1, zero, 0x2
    beq t0, t1, TEST_B_beq_3
    j TEST_B_bne
TEST_B_beq_3:
    beq zero, zero, error
TEST_B_beq_1:
    beq t0, t1, TEST_B_beq_2
    beq zero, zero, error

TEST_B_bne:
    li a0, '2'
    jal WRITE_SERIAL
    addi t0, zero, 0x1
    addi t1, zero, 0x2
    bne t0, t1, TEST_B_bne_1
    bne zero, zero, error
TEST_B_bne_2:
    addi t1, zero, 0x1
    bne t0, t1, TEST_B_bne_3
    j TEST_B_blt
TEST_B_bne_3:
    bne zero, zero, error
TEST_B_bne_1:
    bne t0, t1, TEST_B_bne_2
    bne zero, zero, error

TEST_B_blt:
    li a0, '3'
    jal WRITE_SERIAL
    addi t0, zero, -0x1
    addi t1, zero, 0x2
    blt t0, t1, TEST_B_blt_1
    blt zero, zero, error
TEST_B_blt_2:
    addi t1, zero, -0x1
    blt t0, t1, TEST_B_blt_3
    j TEST_B_bge
TEST_B_blt_3:
    blt zero, zero, error
TEST_B_blt_1:
    blt t0, t1, TEST_B_blt_2
    blt zero, zero, error

TEST_B_bge:
    li a0, '4'
    jal WRITE_SERIAL
    addi t0, zero, 0x1
    addi t1, zero, -0x2
    bge t0, t1, TEST_B_bge_1
    bge zero, zero, error
TEST_B_bge_2:
    addi t0, zero, -0x1
    bge t0, t1, TEST_B_bge_3
    j TEST_B_bltu
TEST_B_bge_3:
    bge zero, zero, error
TEST_B_bge_1:
    addi t1, zero, 0x1
    bge t0, t1, TEST_B_bge_2
    bge zero, zero, error

TEST_B_bltu:
    li a0, '5'
    jal WRITE_SERIAL
    addi t0, zero, 0x1
    addi t1, zero, -0x1
    bltu t0, t1, TEST_B_bltu_1
    bltu zero, zero, error
TEST_B_bltu_2:
    addi t0, zero, -0x1
    bltu t0, t1, TEST_B_bltu_3
    j TEST_B_bgeu
TEST_B_bltu_3:
    bltu zero, zero, error
TEST_B_bltu_1:
    bltu t0, t1, TEST_B_bltu_2
    bltu zero, zero, error

TEST_B_bgeu:
    li a0, '6'
    jal WRITE_SERIAL
    addi t0, zero, -0x1
    addi t1, zero, 0x1
    bgeu t0, t1, TEST_B_bgeu_1
    bgeu zero, zero, error
TEST_B_bgeu_2:
    addi t0, zero, -0x2
    bgeu t0, t1, TEST_B_bgeu_3
    j MAIN_TEST_M
TEST_B_bgeu_3:
    bgeu zero, zero, error
TEST_B_bgeu_1:
    addi t1, zero, -0x1
    bgeu t0, t1, TEST_B_bgeu_2
    bgeu zero, zero, error

MAIN_TEST_M:
    # 访存测试
    li a0, 'M'
    jal WRITE_SERIAL
    
    # BaseRAM 测试
    li a0, 'b'
    jal WRITE_SERIAL
    li a0, 0x80300000   # BaseRAM 测试地址
    jal TEST_M
    
    # ExtRAM 测试
    li a0, 'e'
    jal WRITE_SERIAL
    li a0, 0x80700000   # ExtRAM 测试地址
    jal TEST_M

MAIN_TEST_I:
    # I 型指令测试
    li a0, 'I'
    jal WRITE_SERIAL

    # addi
    li t0, 1
    addi t0, t0, -2
    li t1, -1
    bne t0, t1, error
    # slti
    li t1, -2
    slti t0, t1, -1
    li a1, 1
    bne t0, a1, error
    li t1, -1
    slti t0, t1, -1
    bne t0, x0, error
    # sltiu
    li t1, 1
    sltiu t0, t1, -1
    li a1, 1
    bne t0, a1, error
    li t1, -1
    sltiu t0, t1, -1
    bne t0, x0, error
    # xori
    li t1, 1
    xori t0, t1, -1
    li a1, -2
    bne t0, a1, error
    # ori
    li t1, 1
    ori t0, t1, -2
    li a1, -1
    bne t0, a1, error
    # andi
    li t1, 0xf000000f
    andi t0, t1, -2
    li a1, 0xf000000e
    bne t0, a1, error
    # slli
    li t1, 1
    slli t0, t1, 0b11111
    li a1, 0x80000000
    bne t0, a1, error
    # srli
    li t1, -1
    srli t0, t1, 0b11111
    li a1, 0x1
    bne t0, a1, error
    # srai
    li t1, 0x80000000
    srai t0, t1, 0b11111
    li a1, -1
    bne t0, a1, error

MAIN_TEST_R:
    # R 型指令测试
    li a0, 'R'
    jal WRITE_SERIAL

    # add
    li t0, 0xffffffff
    li t1, 0x1
    add t0, t0, t1
    bne t0, zero, error
    # sub
    li t0, 0x1
    li t1, 0x2
    sub t0, t0, t1
    li a1, -1
    bne t0, a1, error
    # sll
    li t1, 1
    li t2, 0xffffffef
    sll t0, t1, t2
    li a1, 0x8000
    bne t0, a1, error
    # slt
    li t1, -2
    li t2, -1
    slt t0, t1, t2
    li a1, 1
    bne t0, a1, error
    li t1, -1
    slt t0, t1, t2
    bne t0, x0, error
    # sltu
    li t1, 1
    li t2, -1
    sltu t0, t1, t2
    li a1, 1
    bne t0, a1, error
    li t1, -1
    sltu t0, t1, t2
    bne t0, x0, error
    # xor
    li t1, 1
    li t2, -1
    xor t0, t1, t2
    li a1, -2
    bne t0, a1, error
    # srl
    li t1, -1
    li t2, 0xffffffef
    srl t0, t1, t2
    li a1, 0x1ffff
    bne t0, a1, error
    # sra
    li t1, 0x80000000
    li t2, 0xffffffef
    sra t0, t1, t2
    li a1, 0xffff0000
    bne t0, a1, error
    # or
    li t1, 1
    li t2, -2
    or t0, t1, t2
    li a1, -1
    bne t0, a1, error
    # and
    li t1, 0xf000000f
    li t2, -2
    and t0, t1, t2
    li a1, 0xf000000e
    bne t0, a1, error

MAIN_TEST_END:
    # 测试完成
    li a0, 'A'
    jal WRITE_SERIAL
    j end


error:
    li a0, 'E'
    jal WRITE_SERIAL
    # 自然进入 end

end:
    li a0, 'E'
    beq zero, zero, end     # 若死循环失败, 则会写串口


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


PAD_J:
    beq zero, zero, error
TEST_J_BACK:
    jalr -0xc(ra)     # 跳转到 jalr 8(ra) 处
    beq zero, zero, error
    beq zero, zero, error
    j TEST_J_END
    beq zero, zero, error
    beq zero, zero, error
    beq zero, zero, error
    beq zero, zero, error
TEST_J:
    j TEST_J_BACK


TEST_M:
    mv s0, a0
    add s1, s0, -0x10   # 测试地址下界

    # 整存散取
    li s3, 0x89ABCDEF   # 测试数据
    mv s2, ra
    li a0, '1'
    jal WRITE_SERIAL
    mv ra, s2
    sw s3, -0x4(s0)
    lhu t1, 0xc(s1)
    lbu t2, 0xe(s1)
    slli t2, t2, 0x10
    add t1, t1, t2
    lbu t2, 0xf(s1)
    slli t2, t2, 0x18
    add t1, t1, t2
    bne t1, s3, error

    mv s2, ra
    li a0, '2'
    jal WRITE_SERIAL
    mv ra, s2
    sw s3, 0x4(s1)
    lbu t1, -0xc(s0)
    lbu t2, -0xb(s0)
    slli t2, t2, 0x8
    add t1, t1, t2
    lhu t2, -0xa(s0)
    slli t2, t2, 0x10
    add t1, t1, t2
    bne t1, s3, error

    mv s2, ra
    li a0, '3'
    jal WRITE_SERIAL
    mv ra, s2
    lh t1, -0x2(s0)
    li t2, 0xFFFF89AB
    bne t1, t2, error
    lb t1, -0x3(s0)
    li t2, 0xFFFFFFCD
    bne t1, t2, error

    # 散存整取
    add s0, s0, 0x10
    add s1, s1, 0x10
    li s3, 0x89ABCDEF   # 测试数据
    li s4, 0x89AB
    li s5, 0xCD
    li s6, 0xEF
    
    mv s2, ra
    li a0, '4'
    jal WRITE_SERIAL
    mv ra, s2
    sh s4, -0x2(s0)
    sb s5, -0x3(s0)
    sb s6, -0x4(s0)
    lw t1, 0xc(s1)
    bne t1, s3, error
    
    mv s2, ra
    li a0, '5'
    jal WRITE_SERIAL
    mv ra, s2
    sh s4, 0x6(s1)
    sb s5, 0x5(s1)
    sb s6, 0x4(s1)
    lw t1, -0xc(s0)
    bne t1, s3, error

    jr ra
