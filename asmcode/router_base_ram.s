    j TEST_DMA

DIRECT_ROUTE:
    li s0, 0x40000000
    li t0, 0x00000004
    sw t0, 0(s0)
    li s0, 0x40000004
    li t0, 0x00000002
    sw t0, 0(s0)
    li s0, 0x40000008
    li t0, 0x00000003
    sw t0, 0(s0)
    li s0, 0x4000000C
    li t0, 0x00000005
    sw t0, 0(s0)
    li s0, 0x40000010
    li t0, 0x00004000
    sw t0, 0(s0)
    li s0, 0x40000018
    li t0, 0x00000004
    sw t0, 0(s0)
    li s0, 0x40000020
    li t0, 0x00000001
    sw t0, 0(s0)
    li s0, 0x40000028
    li t0, 0x00000001
    sw t0, 0(s0)
    li s0, 0x40000030
    li t0, 0x00000400
    sw t0, 0(s0)
    li s0, 0x40000038
    li t0, 0x00000002
    sw t0, 0(s0)
    li s0, 0x41000010
    li t0, 0x00000040
    sw t0, 0(s0)
    li s0, 0x41000018
    li t0, 0x00000004
    sw t0, 0(s0)
    li s0, 0x41000020
    li t0, 0x00000001
    sw t0, 0(s0)
    li s0, 0x41000028
    li t0, 0x00000001
    sw t0, 0(s0)
    li s0, 0x41000030
    li t0, 0x00000400
    sw t0, 0(s0)
    li s0, 0x41000038
    li t0, 0x00000002
    sw t0, 0(s0)
    li s0, 0x41000040
    li t0, 0x00000400
    sw t0, 0(s0)
    li s0, 0x41000048
    li t0, 0x00000003
    sw t0, 0(s0)
    li s0, 0x42000010
    li t0, 0x00000080
    sw t0, 0(s0)
    li s0, 0x42000018
    li t0, 0x00000004
    sw t0, 0(s0)
    li s0, 0x42000020
    li t0, 0x00000200
    sw t0, 0(s0)
    li s0, 0x42000028
    li t0, 0x00000001
    sw t0, 0(s0)
    li s0, 0x42000030
    li t0, 0x00000010
    sw t0, 0(s0)
    li s0, 0x42000038
    li t0, 0x00000002
    sw t0, 0(s0)
    li s0, 0x42000040
    li t0, 0x00000001
    sw t0, 0(s0)
    li s0, 0x42000048
    li t0, 0x00000003
    sw t0, 0(s0)
    li s0, 0x43000010
    li t0, 0x0000000F
    sw t0, 0(s0)
    li s0, 0x43000018
    li t0, 0x00000007
    sw t0, 0(s0)
    li s0, 0x43000020
    li t0, 0x00000001
    sw t0, 0(s0)
    li s0, 0x43000028
    li t0, 0x00000001
    sw t0, 0(s0)
    li s0, 0x43000030
    li t0, 0x00000400
    sw t0, 0(s0)
    li s0, 0x43000038
    li t0, 0x00000002
    sw t0, 0(s0)
    li s0, 0x43000040
    li t0, 0x00000001
    sw t0, 0(s0)
    li s0, 0x43000048
    li t0, 0x00000003
    sw t0, 0(s0)
    li s0, 0x44000074
    li t0, 0x00000002
    sw t0, 0(s0)
    li s0, 0x4400007C
    li t0, 0x00000001
    sw t0, 0(s0)
    li s0, 0x44000084
    li t0, 0x00000002
    sw t0, 0(s0)
    li s0, 0x4400008C
    li t0, 0x00000002
    sw t0, 0(s0)
    li s0, 0x44000094
    li t0, 0x00000002
    sw t0, 0(s0)
    li s0, 0x4400009C
    li t0, 0x00000003
    sw t0, 0(s0)
    li s0, 0x440000A4
    li t0, 0x00000002
    sw t0, 0(s0)
    li s0, 0x440000AC
    li t0, 0x00000004
    sw t0, 0(s0)
    li s0, 0x80400000
    li t0, 0x00000000
    sw t0, 0(s0)
    li s0, 0x80400004
    li t0, 0x00000000
    sw t0, 0(s0)
    li s0, 0x80400008
    li t0, 0x00000001
    sw t0, 0(s0)
    li s0, 0x8040000C
    li t0, 0x00000002
    sw t0, 0(s0)
    li s0, 0x80400010
    li t0, 0x00000003
    sw t0, 0(s0)
    li s0, 0x80400014
    li t0, 0x00000003
    sw t0, 0(s0)
    li s0, 0x80400018
    li t0, 0x00000000
    sw t0, 0(s0)
    li s0, 0x8040001C
    li t0, 0x00000000
    sw t0, 0(s0)
    li s0, 0x51000000
    li t0, 0x06AA0E2A
    sw t0, 0(s0)
    li s0, 0x51000004
    li t0, 0x000A9704
    sw t0, 0(s0)
    li s0, 0x5100000C
    li t0, 0x33230000
    sw t0, 0(s0)
    li s0, 0x51000020
    li t0, 0x06AA0E2A
    sw t0, 0(s0)
    li s0, 0x51000024
    li t0, 0x000A9704
    sw t0, 0(s0)
    li s0, 0x5100002C
    li t0, 0x44340000
    sw t0, 0(s0)
    li s0, 0x51000030
    li t0, 0x00000001
    sw t0, 0(s0)
    li s0, 0x51000040
    li t0, 0x06AA0E2A
    sw t0, 0(s0)
    li s0, 0x51000044
    li t0, 0x000A9704
    sw t0, 0(s0)
    li s0, 0x5100004C
    li t0, 0x55450000
    sw t0, 0(s0)
    li s0, 0x51000050
    li t0, 0x00000002
    sw t0, 0(s0)
    li s0, 0x51000060
    li t0, 0x06AA0E2A
    sw t0, 0(s0)
    li s0, 0x51000064
    li t0, 0x000A9704
    sw t0, 0(s0)
    li s0, 0x5100006C
    li t0, 0x66560000
    sw t0, 0(s0)
    li s0, 0x51000070
    li t0, 0x00000003
    sw t0, 0(s0)

TEST_GUA:
    li s0, 0x61000020

    li t0, 0x06aa0e2a
    sw t0, 0x0(s0)
    li t0, 0x000a9704
    sw t0, 0x4(s0)
    li t0, 0x00000000
    sw t0, 0x8(s0)
    li t0, 0x01000000
    sw t0, 0xc(s0)

    j .DONE

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
    lhu s1, 0(s0)
    li s2, 0
    addi s0, s0, 0x2
.loop:
    lbu s3, 0(s0)
    addi s0, s0, 1
    addi s2, s2, 1
    bne s2, s1, .loop

.TEST4:
    li t1, 0x1c
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
