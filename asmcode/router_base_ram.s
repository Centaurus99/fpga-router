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
