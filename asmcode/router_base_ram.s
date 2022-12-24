TEST_DMA:
    li t0, 0x62000000

.TEST1:
    lb t1, 0(t0)
    andi t1, t1, 0x4    # Wait CPU ?
    beqz t1, .TEST1

.TEST2:
    li t1, 0x1
    sb t1, 0(t0)    # Request DMA
    lb t1, 0(t0)
    andi t1, t1, 0x1    # Check request
    beqz t1, .TEST2

.TEST3:
    li s0, 0x68000000
    lw s1, 0(s0)
    li s2, 0
    addi s0, s0, 0x4
.loop:
    lbu s3, 0(s0)
    addi s0, s0, 1
    addi s2, s2, 1
    bne s2, s1, .loop

.TEST4:
    li t1, 0xc
    sb t1, 0(t0)    # Read & Write

.DONE:
    j .DONE

TEST_MMIO:
    li t0, 0x61000000
    li t1, 0x78563412
    sw t1, 0(t0)
    li t1, 0xf0debc9a
    sw t1, 4(t0)
    li t1, 0x1
    sw t1, 0x008(t0)
    sw t1, 0x108(t0)
    sw t1, 0x208(t0)
    sw t1, 0x308(t0)

    li t0, 0x61000120
    li t1, 0x78563412
    sw t1, 0(t0)
    li t1, 0xf0debc9a
    sw t1, 4(t0)

TEST_BRAM:
    li t0, 0x60000000
    lw t1, 0(t0)
    addi t0, t0, 4
    lw t1, 0(t0)

    li t0, 0x60000100
    lw t1, 0(t0)
    addi t0, t0, 4
    lw t1, 0(t0)

    li t0, 0x60000200
    lw t1, 0(t0)
    addi t0, t0, 4
    lw t1, 0(t0)

    li t0, 0x60000300
    lw t1, 0(t0)
    addi t0, t0, 4
    lw t1, 0(t0)
