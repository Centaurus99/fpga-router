
kernel.elf:     file format elf32-littleriscv


Disassembly of section .text:

80000000 <_reset_vector>:
80000000:	80400137          	lui	sp,0x80400
80000004:	ff010113          	addi	sp,sp,-16 # 803ffff0 <_bss_end+0x23da00>
80000008:	5bc0606f          	j	800065c4 <start>

8000000c <__bswap16>:
8000000c:	fe010113          	addi	sp,sp,-32
80000010:	00812e23          	sw	s0,28(sp)
80000014:	02010413          	addi	s0,sp,32
80000018:	00050793          	mv	a5,a0
8000001c:	fef41723          	sh	a5,-18(s0)
80000020:	fee45783          	lhu	a5,-18(s0)
80000024:	0087d793          	srli	a5,a5,0x8
80000028:	01079793          	slli	a5,a5,0x10
8000002c:	0107d793          	srli	a5,a5,0x10
80000030:	01079713          	slli	a4,a5,0x10
80000034:	41075713          	srai	a4,a4,0x10
80000038:	fee45783          	lhu	a5,-18(s0)
8000003c:	00879793          	slli	a5,a5,0x8
80000040:	01079793          	slli	a5,a5,0x10
80000044:	4107d793          	srai	a5,a5,0x10
80000048:	f007f793          	andi	a5,a5,-256
8000004c:	01079793          	slli	a5,a5,0x10
80000050:	4107d793          	srai	a5,a5,0x10
80000054:	00f767b3          	or	a5,a4,a5
80000058:	01079793          	slli	a5,a5,0x10
8000005c:	4107d793          	srai	a5,a5,0x10
80000060:	01079793          	slli	a5,a5,0x10
80000064:	0107d793          	srli	a5,a5,0x10
80000068:	00078513          	mv	a0,a5
8000006c:	01c12403          	lw	s0,28(sp)
80000070:	02010113          	addi	sp,sp,32
80000074:	00008067          	ret

80000078 <validateAndFillChecksum>:
80000078:	fb010113          	addi	sp,sp,-80
8000007c:	04112623          	sw	ra,76(sp)
80000080:	04812423          	sw	s0,72(sp)
80000084:	05010413          	addi	s0,sp,80
80000088:	faa42e23          	sw	a0,-68(s0)
8000008c:	fab42c23          	sw	a1,-72(s0)
80000090:	fbc42783          	lw	a5,-68(s0)
80000094:	fcf42a23          	sw	a5,-44(s0)
80000098:	fe042623          	sw	zero,-20(s0)
8000009c:	fe042423          	sw	zero,-24(s0)
800000a0:	0880006f          	j	80000128 <validateAndFillChecksum+0xb0>
800000a4:	fd442703          	lw	a4,-44(s0)
800000a8:	fe842783          	lw	a5,-24(s0)
800000ac:	00f707b3          	add	a5,a4,a5
800000b0:	0087c783          	lbu	a5,8(a5)
800000b4:	00879793          	slli	a5,a5,0x8
800000b8:	fe842703          	lw	a4,-24(s0)
800000bc:	00170713          	addi	a4,a4,1
800000c0:	fd442683          	lw	a3,-44(s0)
800000c4:	00e68733          	add	a4,a3,a4
800000c8:	00874703          	lbu	a4,8(a4)
800000cc:	00e787b3          	add	a5,a5,a4
800000d0:	00078713          	mv	a4,a5
800000d4:	fec42783          	lw	a5,-20(s0)
800000d8:	00e787b3          	add	a5,a5,a4
800000dc:	fef42623          	sw	a5,-20(s0)
800000e0:	fd442703          	lw	a4,-44(s0)
800000e4:	fe842783          	lw	a5,-24(s0)
800000e8:	00f707b3          	add	a5,a4,a5
800000ec:	0187c783          	lbu	a5,24(a5)
800000f0:	00879793          	slli	a5,a5,0x8
800000f4:	fe842703          	lw	a4,-24(s0)
800000f8:	00170713          	addi	a4,a4,1
800000fc:	fd442683          	lw	a3,-44(s0)
80000100:	00e68733          	add	a4,a3,a4
80000104:	01874703          	lbu	a4,24(a4)
80000108:	00e787b3          	add	a5,a5,a4
8000010c:	00078713          	mv	a4,a5
80000110:	fec42783          	lw	a5,-20(s0)
80000114:	00e787b3          	add	a5,a5,a4
80000118:	fef42623          	sw	a5,-20(s0)
8000011c:	fe842783          	lw	a5,-24(s0)
80000120:	00278793          	addi	a5,a5,2
80000124:	fef42423          	sw	a5,-24(s0)
80000128:	fe842703          	lw	a4,-24(s0)
8000012c:	00f00793          	li	a5,15
80000130:	f6e7dae3          	bge	a5,a4,800000a4 <validateAndFillChecksum+0x2c>
80000134:	fd442783          	lw	a5,-44(s0)
80000138:	0067c783          	lbu	a5,6(a5)
8000013c:	fcf409a3          	sb	a5,-45(s0)
80000140:	fd344703          	lbu	a4,-45(s0)
80000144:	01100793          	li	a5,17
80000148:	1ef71063          	bne	a4,a5,80000328 <validateAndFillChecksum+0x2b0>
8000014c:	fbc42783          	lw	a5,-68(s0)
80000150:	02878793          	addi	a5,a5,40
80000154:	fcf42223          	sw	a5,-60(s0)
80000158:	fc442783          	lw	a5,-60(s0)
8000015c:	0047d783          	lhu	a5,4(a5)
80000160:	00078513          	mv	a0,a5
80000164:	ea9ff0ef          	jal	ra,8000000c <__bswap16>
80000168:	00050793          	mv	a5,a0
8000016c:	fcf41123          	sh	a5,-62(s0)
80000170:	fc442783          	lw	a5,-60(s0)
80000174:	0067d783          	lhu	a5,6(a5)
80000178:	00078513          	mv	a0,a5
8000017c:	e91ff0ef          	jal	ra,8000000c <__bswap16>
80000180:	00050793          	mv	a5,a0
80000184:	fcf41023          	sh	a5,-64(s0)
80000188:	fc442783          	lw	a5,-60(s0)
8000018c:	00079323          	sh	zero,6(a5)
80000190:	fc245783          	lhu	a5,-62(s0)
80000194:	fec42703          	lw	a4,-20(s0)
80000198:	00f707b3          	add	a5,a4,a5
8000019c:	fef42623          	sw	a5,-20(s0)
800001a0:	fd344783          	lbu	a5,-45(s0)
800001a4:	fec42703          	lw	a4,-20(s0)
800001a8:	00f707b3          	add	a5,a4,a5
800001ac:	fef42623          	sw	a5,-20(s0)
800001b0:	fe042223          	sw	zero,-28(s0)
800001b4:	06c0006f          	j	80000220 <validateAndFillChecksum+0x1a8>
800001b8:	fe442783          	lw	a5,-28(s0)
800001bc:	02878793          	addi	a5,a5,40
800001c0:	fbc42703          	lw	a4,-68(s0)
800001c4:	00f707b3          	add	a5,a4,a5
800001c8:	0007c783          	lbu	a5,0(a5)
800001cc:	00879793          	slli	a5,a5,0x8
800001d0:	00078713          	mv	a4,a5
800001d4:	fec42783          	lw	a5,-20(s0)
800001d8:	00e787b3          	add	a5,a5,a4
800001dc:	fef42623          	sw	a5,-20(s0)
800001e0:	fe442783          	lw	a5,-28(s0)
800001e4:	00178713          	addi	a4,a5,1
800001e8:	fc245783          	lhu	a5,-62(s0)
800001ec:	02f75463          	bge	a4,a5,80000214 <validateAndFillChecksum+0x19c>
800001f0:	fe442783          	lw	a5,-28(s0)
800001f4:	02978793          	addi	a5,a5,41
800001f8:	fbc42703          	lw	a4,-68(s0)
800001fc:	00f707b3          	add	a5,a4,a5
80000200:	0007c783          	lbu	a5,0(a5)
80000204:	00078713          	mv	a4,a5
80000208:	fec42783          	lw	a5,-20(s0)
8000020c:	00e787b3          	add	a5,a5,a4
80000210:	fef42623          	sw	a5,-20(s0)
80000214:	fe442783          	lw	a5,-28(s0)
80000218:	00278793          	addi	a5,a5,2
8000021c:	fef42223          	sw	a5,-28(s0)
80000220:	fc245783          	lhu	a5,-62(s0)
80000224:	fe442703          	lw	a4,-28(s0)
80000228:	f8f748e3          	blt	a4,a5,800001b8 <validateAndFillChecksum+0x140>
8000022c:	fec42783          	lw	a5,-20(s0)
80000230:	fef42023          	sw	a5,-32(s0)
80000234:	0240006f          	j	80000258 <validateAndFillChecksum+0x1e0>
80000238:	fe042783          	lw	a5,-32(s0)
8000023c:	0107d713          	srli	a4,a5,0x10
80000240:	fe042683          	lw	a3,-32(s0)
80000244:	000107b7          	lui	a5,0x10
80000248:	fff78793          	addi	a5,a5,-1 # ffff <_reset_vector-0x7fff0001>
8000024c:	00f6f7b3          	and	a5,a3,a5
80000250:	00f707b3          	add	a5,a4,a5
80000254:	fef42023          	sw	a5,-32(s0)
80000258:	fe042783          	lw	a5,-32(s0)
8000025c:	0107d793          	srli	a5,a5,0x10
80000260:	fc079ce3          	bnez	a5,80000238 <validateAndFillChecksum+0x1c0>
80000264:	fe042783          	lw	a5,-32(s0)
80000268:	01079793          	slli	a5,a5,0x10
8000026c:	0107d793          	srli	a5,a5,0x10
80000270:	fff7c793          	not	a5,a5
80000274:	01079793          	slli	a5,a5,0x10
80000278:	0107d793          	srli	a5,a5,0x10
8000027c:	fef42023          	sw	a5,-32(s0)
80000280:	fe042783          	lw	a5,-32(s0)
80000284:	00079863          	bnez	a5,80000294 <validateAndFillChecksum+0x21c>
80000288:	000107b7          	lui	a5,0x10
8000028c:	fff78793          	addi	a5,a5,-1 # ffff <_reset_vector-0x7fff0001>
80000290:	fef42023          	sw	a5,-32(s0)
80000294:	fe042783          	lw	a5,-32(s0)
80000298:	01079793          	slli	a5,a5,0x10
8000029c:	0107d793          	srli	a5,a5,0x10
800002a0:	00078513          	mv	a0,a5
800002a4:	d69ff0ef          	jal	ra,8000000c <__bswap16>
800002a8:	00050793          	mv	a5,a0
800002ac:	00078713          	mv	a4,a5
800002b0:	fc442783          	lw	a5,-60(s0)
800002b4:	00e79323          	sh	a4,6(a5)
800002b8:	fc045783          	lhu	a5,-64(s0)
800002bc:	00079663          	bnez	a5,800002c8 <validateAndFillChecksum+0x250>
800002c0:	00000793          	li	a5,0
800002c4:	2240006f          	j	800004e8 <validateAndFillChecksum+0x470>
800002c8:	fc045783          	lhu	a5,-64(s0)
800002cc:	fec42703          	lw	a4,-20(s0)
800002d0:	00f707b3          	add	a5,a4,a5
800002d4:	fef42623          	sw	a5,-20(s0)
800002d8:	0240006f          	j	800002fc <validateAndFillChecksum+0x284>
800002dc:	fec42783          	lw	a5,-20(s0)
800002e0:	0107d713          	srli	a4,a5,0x10
800002e4:	fec42683          	lw	a3,-20(s0)
800002e8:	000107b7          	lui	a5,0x10
800002ec:	fff78793          	addi	a5,a5,-1 # ffff <_reset_vector-0x7fff0001>
800002f0:	00f6f7b3          	and	a5,a3,a5
800002f4:	00f707b3          	add	a5,a4,a5
800002f8:	fef42623          	sw	a5,-20(s0)
800002fc:	fec42783          	lw	a5,-20(s0)
80000300:	0107d793          	srli	a5,a5,0x10
80000304:	fc079ce3          	bnez	a5,800002dc <validateAndFillChecksum+0x264>
80000308:	fec42703          	lw	a4,-20(s0)
8000030c:	000107b7          	lui	a5,0x10
80000310:	fff78793          	addi	a5,a5,-1 # ffff <_reset_vector-0x7fff0001>
80000314:	00f71663          	bne	a4,a5,80000320 <validateAndFillChecksum+0x2a8>
80000318:	00100793          	li	a5,1
8000031c:	1cc0006f          	j	800004e8 <validateAndFillChecksum+0x470>
80000320:	00000793          	li	a5,0
80000324:	1c40006f          	j	800004e8 <validateAndFillChecksum+0x470>
80000328:	fd344703          	lbu	a4,-45(s0)
8000032c:	03a00793          	li	a5,58
80000330:	1af71463          	bne	a4,a5,800004d8 <validateAndFillChecksum+0x460>
80000334:	fbc42783          	lw	a5,-68(s0)
80000338:	02878793          	addi	a5,a5,40
8000033c:	fcf42623          	sw	a5,-52(s0)
80000340:	fb842783          	lw	a5,-72(s0)
80000344:	01079793          	slli	a5,a5,0x10
80000348:	0107d793          	srli	a5,a5,0x10
8000034c:	fd878793          	addi	a5,a5,-40
80000350:	fcf41523          	sh	a5,-54(s0)
80000354:	fcc42783          	lw	a5,-52(s0)
80000358:	0027d783          	lhu	a5,2(a5)
8000035c:	00078513          	mv	a0,a5
80000360:	cadff0ef          	jal	ra,8000000c <__bswap16>
80000364:	00050793          	mv	a5,a0
80000368:	fcf41423          	sh	a5,-56(s0)
8000036c:	fcc42783          	lw	a5,-52(s0)
80000370:	00079123          	sh	zero,2(a5)
80000374:	fca45783          	lhu	a5,-54(s0)
80000378:	fec42703          	lw	a4,-20(s0)
8000037c:	00f707b3          	add	a5,a4,a5
80000380:	fef42623          	sw	a5,-20(s0)
80000384:	fd344783          	lbu	a5,-45(s0)
80000388:	fec42703          	lw	a4,-20(s0)
8000038c:	00f707b3          	add	a5,a4,a5
80000390:	fef42623          	sw	a5,-20(s0)
80000394:	fc042e23          	sw	zero,-36(s0)
80000398:	06c0006f          	j	80000404 <validateAndFillChecksum+0x38c>
8000039c:	fdc42783          	lw	a5,-36(s0)
800003a0:	02878793          	addi	a5,a5,40
800003a4:	fbc42703          	lw	a4,-68(s0)
800003a8:	00f707b3          	add	a5,a4,a5
800003ac:	0007c783          	lbu	a5,0(a5)
800003b0:	00879793          	slli	a5,a5,0x8
800003b4:	00078713          	mv	a4,a5
800003b8:	fec42783          	lw	a5,-20(s0)
800003bc:	00e787b3          	add	a5,a5,a4
800003c0:	fef42623          	sw	a5,-20(s0)
800003c4:	fdc42783          	lw	a5,-36(s0)
800003c8:	00178713          	addi	a4,a5,1
800003cc:	fca45783          	lhu	a5,-54(s0)
800003d0:	02f75463          	bge	a4,a5,800003f8 <validateAndFillChecksum+0x380>
800003d4:	fdc42783          	lw	a5,-36(s0)
800003d8:	02978793          	addi	a5,a5,41
800003dc:	fbc42703          	lw	a4,-68(s0)
800003e0:	00f707b3          	add	a5,a4,a5
800003e4:	0007c783          	lbu	a5,0(a5)
800003e8:	00078713          	mv	a4,a5
800003ec:	fec42783          	lw	a5,-20(s0)
800003f0:	00e787b3          	add	a5,a5,a4
800003f4:	fef42623          	sw	a5,-20(s0)
800003f8:	fdc42783          	lw	a5,-36(s0)
800003fc:	00278793          	addi	a5,a5,2
80000400:	fcf42e23          	sw	a5,-36(s0)
80000404:	fca45783          	lhu	a5,-54(s0)
80000408:	fdc42703          	lw	a4,-36(s0)
8000040c:	f8f748e3          	blt	a4,a5,8000039c <validateAndFillChecksum+0x324>
80000410:	fec42783          	lw	a5,-20(s0)
80000414:	fcf42c23          	sw	a5,-40(s0)
80000418:	0240006f          	j	8000043c <validateAndFillChecksum+0x3c4>
8000041c:	fd842783          	lw	a5,-40(s0)
80000420:	0107d713          	srli	a4,a5,0x10
80000424:	fd842683          	lw	a3,-40(s0)
80000428:	000107b7          	lui	a5,0x10
8000042c:	fff78793          	addi	a5,a5,-1 # ffff <_reset_vector-0x7fff0001>
80000430:	00f6f7b3          	and	a5,a3,a5
80000434:	00f707b3          	add	a5,a4,a5
80000438:	fcf42c23          	sw	a5,-40(s0)
8000043c:	fd842783          	lw	a5,-40(s0)
80000440:	0107d793          	srli	a5,a5,0x10
80000444:	fc079ce3          	bnez	a5,8000041c <validateAndFillChecksum+0x3a4>
80000448:	fd842783          	lw	a5,-40(s0)
8000044c:	01079793          	slli	a5,a5,0x10
80000450:	0107d793          	srli	a5,a5,0x10
80000454:	fff7c793          	not	a5,a5
80000458:	01079793          	slli	a5,a5,0x10
8000045c:	0107d793          	srli	a5,a5,0x10
80000460:	00078513          	mv	a0,a5
80000464:	ba9ff0ef          	jal	ra,8000000c <__bswap16>
80000468:	00050793          	mv	a5,a0
8000046c:	00078713          	mv	a4,a5
80000470:	fcc42783          	lw	a5,-52(s0)
80000474:	00e79123          	sh	a4,2(a5)
80000478:	fc845783          	lhu	a5,-56(s0)
8000047c:	fec42703          	lw	a4,-20(s0)
80000480:	00f707b3          	add	a5,a4,a5
80000484:	fef42623          	sw	a5,-20(s0)
80000488:	0240006f          	j	800004ac <validateAndFillChecksum+0x434>
8000048c:	fec42783          	lw	a5,-20(s0)
80000490:	0107d713          	srli	a4,a5,0x10
80000494:	fec42683          	lw	a3,-20(s0)
80000498:	000107b7          	lui	a5,0x10
8000049c:	fff78793          	addi	a5,a5,-1 # ffff <_reset_vector-0x7fff0001>
800004a0:	00f6f7b3          	and	a5,a3,a5
800004a4:	00f707b3          	add	a5,a4,a5
800004a8:	fef42623          	sw	a5,-20(s0)
800004ac:	fec42783          	lw	a5,-20(s0)
800004b0:	0107d793          	srli	a5,a5,0x10
800004b4:	fc079ce3          	bnez	a5,8000048c <validateAndFillChecksum+0x414>
800004b8:	fec42703          	lw	a4,-20(s0)
800004bc:	000107b7          	lui	a5,0x10
800004c0:	fff78793          	addi	a5,a5,-1 # ffff <_reset_vector-0x7fff0001>
800004c4:	00f71663          	bne	a4,a5,800004d0 <validateAndFillChecksum+0x458>
800004c8:	00100793          	li	a5,1
800004cc:	01c0006f          	j	800004e8 <validateAndFillChecksum+0x470>
800004d0:	00000793          	li	a5,0
800004d4:	0140006f          	j	800004e8 <validateAndFillChecksum+0x470>
800004d8:	00200593          	li	a1,2
800004dc:	00000513          	li	a0,0
800004e0:	135000ef          	jal	ra,80000e14 <assert_id>
800004e4:	00100793          	li	a5,1
800004e8:	00078513          	mv	a0,a5
800004ec:	04c12083          	lw	ra,76(sp)
800004f0:	04812403          	lw	s0,72(sp)
800004f4:	05010113          	addi	sp,sp,80
800004f8:	00008067          	ret

800004fc <mac_addr_equal>:
800004fc:	fe010113          	addi	sp,sp,-32
80000500:	00812e23          	sw	s0,28(sp)
80000504:	02010413          	addi	s0,sp,32
80000508:	fea42423          	sw	a0,-24(s0)
8000050c:	feb42623          	sw	a1,-20(s0)
80000510:	fec42023          	sw	a2,-32(s0)
80000514:	fed42223          	sw	a3,-28(s0)
80000518:	fe845703          	lhu	a4,-24(s0)
8000051c:	fe045783          	lhu	a5,-32(s0)
80000520:	02f71263          	bne	a4,a5,80000544 <mac_addr_equal+0x48>
80000524:	fea45703          	lhu	a4,-22(s0)
80000528:	fe245783          	lhu	a5,-30(s0)
8000052c:	00f71c63          	bne	a4,a5,80000544 <mac_addr_equal+0x48>
80000530:	fec45703          	lhu	a4,-20(s0)
80000534:	fe445783          	lhu	a5,-28(s0)
80000538:	00f71663          	bne	a4,a5,80000544 <mac_addr_equal+0x48>
8000053c:	00100793          	li	a5,1
80000540:	0080006f          	j	80000548 <mac_addr_equal+0x4c>
80000544:	00000793          	li	a5,0
80000548:	0017f793          	andi	a5,a5,1
8000054c:	0ff7f793          	andi	a5,a5,255
80000550:	00078513          	mv	a0,a5
80000554:	01c12403          	lw	s0,28(sp)
80000558:	02010113          	addi	sp,sp,32
8000055c:	00008067          	ret

80000560 <in6_addr_equal>:
80000560:	ff010113          	addi	sp,sp,-16
80000564:	00812623          	sw	s0,12(sp)
80000568:	00912423          	sw	s1,8(sp)
8000056c:	01212223          	sw	s2,4(sp)
80000570:	01010413          	addi	s0,sp,16
80000574:	00050913          	mv	s2,a0
80000578:	00058493          	mv	s1,a1
8000057c:	00092703          	lw	a4,0(s2)
80000580:	0004a783          	lw	a5,0(s1)
80000584:	02f71863          	bne	a4,a5,800005b4 <in6_addr_equal+0x54>
80000588:	00492703          	lw	a4,4(s2)
8000058c:	0044a783          	lw	a5,4(s1)
80000590:	02f71263          	bne	a4,a5,800005b4 <in6_addr_equal+0x54>
80000594:	00892703          	lw	a4,8(s2)
80000598:	0084a783          	lw	a5,8(s1)
8000059c:	00f71c63          	bne	a4,a5,800005b4 <in6_addr_equal+0x54>
800005a0:	00c92703          	lw	a4,12(s2)
800005a4:	00c4a783          	lw	a5,12(s1)
800005a8:	00f71663          	bne	a4,a5,800005b4 <in6_addr_equal+0x54>
800005ac:	00100793          	li	a5,1
800005b0:	0080006f          	j	800005b8 <in6_addr_equal+0x58>
800005b4:	00000793          	li	a5,0
800005b8:	0017f793          	andi	a5,a5,1
800005bc:	0ff7f793          	andi	a5,a5,255
800005c0:	00078513          	mv	a0,a5
800005c4:	00c12403          	lw	s0,12(sp)
800005c8:	00812483          	lw	s1,8(sp)
800005cc:	00412903          	lw	s2,4(sp)
800005d0:	01010113          	addi	sp,sp,16
800005d4:	00008067          	ret

800005d8 <dma_lock_request>:
800005d8:	ff010113          	addi	sp,sp,-16
800005dc:	00812623          	sw	s0,12(sp)
800005e0:	01010413          	addi	s0,sp,16
800005e4:	0100006f          	j	800005f4 <dma_lock_request+0x1c>
800005e8:	620007b7          	lui	a5,0x62000
800005ec:	00100713          	li	a4,1
800005f0:	00e78023          	sb	a4,0(a5) # 62000000 <_reset_vector-0x1e000000>
800005f4:	620007b7          	lui	a5,0x62000
800005f8:	0007c783          	lbu	a5,0(a5) # 62000000 <_reset_vector-0x1e000000>
800005fc:	0ff7f793          	andi	a5,a5,255
80000600:	0017f793          	andi	a5,a5,1
80000604:	fe0782e3          	beqz	a5,800005e8 <dma_lock_request+0x10>
80000608:	00000013          	nop
8000060c:	00000013          	nop
80000610:	00c12403          	lw	s0,12(sp)
80000614:	01010113          	addi	sp,sp,16
80000618:	00008067          	ret

8000061c <dma_lock_release>:
8000061c:	ff010113          	addi	sp,sp,-16
80000620:	00812623          	sw	s0,12(sp)
80000624:	01010413          	addi	s0,sp,16
80000628:	620007b7          	lui	a5,0x62000
8000062c:	01000713          	li	a4,16
80000630:	00e78023          	sb	a4,0(a5) # 62000000 <_reset_vector-0x1e000000>
80000634:	00000013          	nop
80000638:	00c12403          	lw	s0,12(sp)
8000063c:	01010113          	addi	sp,sp,16
80000640:	00008067          	ret

80000644 <dma_send_request>:
80000644:	ff010113          	addi	sp,sp,-16
80000648:	00812623          	sw	s0,12(sp)
8000064c:	01010413          	addi	s0,sp,16
80000650:	0080006f          	j	80000658 <dma_send_request+0x14>
80000654:	00000013          	nop
80000658:	620007b7          	lui	a5,0x62000
8000065c:	0007c783          	lbu	a5,0(a5) # 62000000 <_reset_vector-0x1e000000>
80000660:	0ff7f793          	andi	a5,a5,255
80000664:	0087f793          	andi	a5,a5,8
80000668:	fe0796e3          	bnez	a5,80000654 <dma_send_request+0x10>
8000066c:	680007b7          	lui	a5,0x68000
80000670:	00478793          	addi	a5,a5,4 # 68000004 <_reset_vector-0x17fffffc>
80000674:	00079323          	sh	zero,6(a5)
80000678:	00079423          	sh	zero,8(a5)
8000067c:	00079523          	sh	zero,10(a5)
80000680:	00000013          	nop
80000684:	00c12403          	lw	s0,12(sp)
80000688:	01010113          	addi	sp,sp,16
8000068c:	00008067          	ret

80000690 <dma_send_finish>:
80000690:	ff010113          	addi	sp,sp,-16
80000694:	00812623          	sw	s0,12(sp)
80000698:	01010413          	addi	s0,sp,16
8000069c:	620007b7          	lui	a5,0x62000
800006a0:	00800713          	li	a4,8
800006a4:	00e78023          	sb	a4,0(a5) # 62000000 <_reset_vector-0x1e000000>
800006a8:	00000013          	nop
800006ac:	00c12403          	lw	s0,12(sp)
800006b0:	01010113          	addi	sp,sp,16
800006b4:	00008067          	ret

800006b8 <dma_read_need>:
800006b8:	ff010113          	addi	sp,sp,-16
800006bc:	00812623          	sw	s0,12(sp)
800006c0:	01010413          	addi	s0,sp,16
800006c4:	620007b7          	lui	a5,0x62000
800006c8:	0007c783          	lbu	a5,0(a5) # 62000000 <_reset_vector-0x1e000000>
800006cc:	0ff7f793          	andi	a5,a5,255
800006d0:	0047f793          	andi	a5,a5,4
800006d4:	00078663          	beqz	a5,800006e0 <dma_read_need+0x28>
800006d8:	00100793          	li	a5,1
800006dc:	0080006f          	j	800006e4 <dma_read_need+0x2c>
800006e0:	00000793          	li	a5,0
800006e4:	00078513          	mv	a0,a5
800006e8:	00c12403          	lw	s0,12(sp)
800006ec:	01010113          	addi	sp,sp,16
800006f0:	00008067          	ret

800006f4 <dma_read_finish>:
800006f4:	ff010113          	addi	sp,sp,-16
800006f8:	00812623          	sw	s0,12(sp)
800006fc:	01010413          	addi	s0,sp,16
80000700:	620007b7          	lui	a5,0x62000
80000704:	00400713          	li	a4,4
80000708:	00e78023          	sb	a4,0(a5) # 62000000 <_reset_vector-0x1e000000>
8000070c:	00000013          	nop
80000710:	00c12403          	lw	s0,12(sp)
80000714:	01010113          	addi	sp,sp,16
80000718:	00008067          	ret

8000071c <dma_get_receive_port>:
8000071c:	ff010113          	addi	sp,sp,-16
80000720:	00812623          	sw	s0,12(sp)
80000724:	01010413          	addi	s0,sp,16
80000728:	680007b7          	lui	a5,0x68000
8000072c:	00478793          	addi	a5,a5,4 # 68000004 <_reset_vector-0x17fffffc>
80000730:	0007c783          	lbu	a5,0(a5)
80000734:	0ff7f793          	andi	a5,a5,255
80000738:	00078513          	mv	a0,a5
8000073c:	00c12403          	lw	s0,12(sp)
80000740:	01010113          	addi	sp,sp,16
80000744:	00008067          	ret

80000748 <dma_set_out_port>:
80000748:	fe010113          	addi	sp,sp,-32
8000074c:	00112e23          	sw	ra,28(sp)
80000750:	00812c23          	sw	s0,24(sp)
80000754:	02010413          	addi	s0,sp,32
80000758:	00050793          	mv	a5,a0
8000075c:	fef407a3          	sb	a5,-17(s0)
80000760:	fef44703          	lbu	a4,-17(s0)
80000764:	00300793          	li	a5,3
80000768:	00e7fe63          	bgeu	a5,a4,80000784 <dma_set_out_port+0x3c>
8000076c:	fef44783          	lbu	a5,-17(s0)
80000770:	00078593          	mv	a1,a5
80000774:	8000b7b7          	lui	a5,0x8000b
80000778:	57478513          	addi	a0,a5,1396 # 8000b574 <_bss_end+0xffe48f84>
8000077c:	1a1010ef          	jal	ra,8000211c <printf_>
80000780:	0380006f          	j	800007b8 <dma_set_out_port+0x70>
80000784:	fef44703          	lbu	a4,-17(s0)
80000788:	006107b7          	lui	a5,0x610
8000078c:	00f707b3          	add	a5,a4,a5
80000790:	00879793          	slli	a5,a5,0x8
80000794:	00078713          	mv	a4,a5
80000798:	680007b7          	lui	a5,0x68000
8000079c:	00478793          	addi	a5,a5,4 # 68000004 <_reset_vector-0x17fffffc>
800007a0:	00075683          	lhu	a3,0(a4)
800007a4:	00d79323          	sh	a3,6(a5)
800007a8:	00275683          	lhu	a3,2(a4)
800007ac:	00d79423          	sh	a3,8(a5)
800007b0:	00475703          	lhu	a4,4(a4)
800007b4:	00e79523          	sh	a4,10(a5)
800007b8:	01c12083          	lw	ra,28(sp)
800007bc:	01812403          	lw	s0,24(sp)
800007c0:	02010113          	addi	sp,sp,32
800007c4:	00008067          	ret

800007c8 <dma_demo>:
800007c8:	fd010113          	addi	sp,sp,-48
800007cc:	02112623          	sw	ra,44(sp)
800007d0:	02812423          	sw	s0,40(sp)
800007d4:	03010413          	addi	s0,sp,48
800007d8:	8000b7b7          	lui	a5,0x8000b
800007dc:	59478513          	addi	a0,a5,1428 # 8000b594 <_bss_end+0xffe48fa4>
800007e0:	13d010ef          	jal	ra,8000211c <printf_>
800007e4:	fe0407a3          	sb	zero,-17(s0)
800007e8:	fe042423          	sw	zero,-24(s0)
800007ec:	ecdff0ef          	jal	ra,800006b8 <dma_read_need>
800007f0:	00050793          	mv	a5,a0
800007f4:	06078c63          	beqz	a5,8000086c <dma_demo+0xa4>
800007f8:	680007b7          	lui	a5,0x68000
800007fc:	0007a783          	lw	a5,0(a5) # 68000000 <_reset_vector-0x18000000>
80000800:	00078593          	mv	a1,a5
80000804:	8000b7b7          	lui	a5,0x8000b
80000808:	5a078513          	addi	a0,a5,1440 # 8000b5a0 <_bss_end+0xffe48fb0>
8000080c:	111010ef          	jal	ra,8000211c <printf_>
80000810:	fe042223          	sw	zero,-28(s0)
80000814:	0380006f          	j	8000084c <dma_demo+0x84>
80000818:	fe442703          	lw	a4,-28(s0)
8000081c:	680007b7          	lui	a5,0x68000
80000820:	00478793          	addi	a5,a5,4 # 68000004 <_reset_vector-0x17fffffc>
80000824:	00f707b3          	add	a5,a4,a5
80000828:	0007c783          	lbu	a5,0(a5)
8000082c:	0ff7f793          	andi	a5,a5,255
80000830:	00078593          	mv	a1,a5
80000834:	8000b7b7          	lui	a5,0x8000b
80000838:	5bc78513          	addi	a0,a5,1468 # 8000b5bc <_bss_end+0xffe48fcc>
8000083c:	0e1010ef          	jal	ra,8000211c <printf_>
80000840:	fe442783          	lw	a5,-28(s0)
80000844:	00178793          	addi	a5,a5,1
80000848:	fef42223          	sw	a5,-28(s0)
8000084c:	680007b7          	lui	a5,0x68000
80000850:	0007a703          	lw	a4,0(a5) # 68000000 <_reset_vector-0x18000000>
80000854:	fe442783          	lw	a5,-28(s0)
80000858:	fce7e0e3          	bltu	a5,a4,80000818 <dma_demo+0x50>
8000085c:	8000b7b7          	lui	a5,0x8000b
80000860:	5c478513          	addi	a0,a5,1476 # 8000b5c4 <_bss_end+0xffe48fd4>
80000864:	0b9010ef          	jal	ra,8000211c <printf_>
80000868:	e8dff0ef          	jal	ra,800006f4 <dma_read_finish>
8000086c:	fef44783          	lbu	a5,-17(s0)
80000870:	02079463          	bnez	a5,80000898 <dma_demo+0xd0>
80000874:	100007b7          	lui	a5,0x10000
80000878:	00578793          	addi	a5,a5,5 # 10000005 <_reset_vector-0x6ffffffb>
8000087c:	0007c783          	lbu	a5,0(a5)
80000880:	0ff7f793          	andi	a5,a5,255
80000884:	0017f793          	andi	a5,a5,1
80000888:	00078863          	beqz	a5,80000898 <dma_demo+0xd0>
8000088c:	100007b7          	lui	a5,0x10000
80000890:	0007c783          	lbu	a5,0(a5) # 10000000 <_reset_vector-0x70000000>
80000894:	fef407a3          	sb	a5,-17(s0)
80000898:	fef44783          	lbu	a5,-17(s0)
8000089c:	f40788e3          	beqz	a5,800007ec <dma_demo+0x24>
800008a0:	fef44703          	lbu	a4,-17(s0)
800008a4:	07100793          	li	a5,113
800008a8:	20f70063          	beq	a4,a5,80000aa8 <dma_demo+0x2e0>
800008ac:	fef44703          	lbu	a4,-17(s0)
800008b0:	07700793          	li	a5,119
800008b4:	1ef71663          	bne	a4,a5,80000aa0 <dma_demo+0x2d8>
800008b8:	d21ff0ef          	jal	ra,800005d8 <dma_lock_request>
800008bc:	d89ff0ef          	jal	ra,80000644 <dma_send_request>
800008c0:	8000b7b7          	lui	a5,0x8000b
800008c4:	5c878513          	addi	a0,a5,1480 # 8000b5c8 <_bss_end+0xffe48fd8>
800008c8:	055010ef          	jal	ra,8000211c <printf_>
800008cc:	fe042423          	sw	zero,-24(s0)
800008d0:	3bd010ef          	jal	ra,8000248c <_getchar_uart>
800008d4:	00050793          	mv	a5,a0
800008d8:	fef407a3          	sb	a5,-17(s0)
800008dc:	0380006f          	j	80000914 <dma_demo+0x14c>
800008e0:	fe842703          	lw	a4,-24(s0)
800008e4:	00070793          	mv	a5,a4
800008e8:	00279793          	slli	a5,a5,0x2
800008ec:	00e787b3          	add	a5,a5,a4
800008f0:	00179793          	slli	a5,a5,0x1
800008f4:	00078713          	mv	a4,a5
800008f8:	fef44783          	lbu	a5,-17(s0)
800008fc:	00f707b3          	add	a5,a4,a5
80000900:	fd078793          	addi	a5,a5,-48
80000904:	fef42423          	sw	a5,-24(s0)
80000908:	385010ef          	jal	ra,8000248c <_getchar_uart>
8000090c:	00050793          	mv	a5,a0
80000910:	fef407a3          	sb	a5,-17(s0)
80000914:	fef44703          	lbu	a4,-17(s0)
80000918:	02000793          	li	a5,32
8000091c:	00f70863          	beq	a4,a5,8000092c <dma_demo+0x164>
80000920:	fef44703          	lbu	a4,-17(s0)
80000924:	00d00793          	li	a5,13
80000928:	faf71ce3          	bne	a4,a5,800008e0 <dma_demo+0x118>
8000092c:	fe842583          	lw	a1,-24(s0)
80000930:	8000b7b7          	lui	a5,0x8000b
80000934:	5dc78513          	addi	a0,a5,1500 # 8000b5dc <_bss_end+0xffe48fec>
80000938:	7e4010ef          	jal	ra,8000211c <printf_>
8000093c:	680007b7          	lui	a5,0x68000
80000940:	fe842703          	lw	a4,-24(s0)
80000944:	00e7a023          	sw	a4,0(a5) # 68000000 <_reset_vector-0x18000000>
80000948:	345010ef          	jal	ra,8000248c <_getchar_uart>
8000094c:	00050793          	mv	a5,a0
80000950:	fef407a3          	sb	a5,-17(s0)
80000954:	fe042023          	sw	zero,-32(s0)
80000958:	1200006f          	j	80000a78 <dma_demo+0x2b0>
8000095c:	fc040fa3          	sb	zero,-33(s0)
80000960:	0c00006f          	j	80000a20 <dma_demo+0x258>
80000964:	fef44703          	lbu	a4,-17(s0)
80000968:	02f00793          	li	a5,47
8000096c:	02e7fa63          	bgeu	a5,a4,800009a0 <dma_demo+0x1d8>
80000970:	fef44703          	lbu	a4,-17(s0)
80000974:	03900793          	li	a5,57
80000978:	02e7e463          	bltu	a5,a4,800009a0 <dma_demo+0x1d8>
8000097c:	fdf44783          	lbu	a5,-33(s0)
80000980:	00479793          	slli	a5,a5,0x4
80000984:	0ff7f713          	andi	a4,a5,255
80000988:	fef44783          	lbu	a5,-17(s0)
8000098c:	00f707b3          	add	a5,a4,a5
80000990:	0ff7f793          	andi	a5,a5,255
80000994:	fd078793          	addi	a5,a5,-48
80000998:	fcf40fa3          	sb	a5,-33(s0)
8000099c:	0780006f          	j	80000a14 <dma_demo+0x24c>
800009a0:	fef44703          	lbu	a4,-17(s0)
800009a4:	06000793          	li	a5,96
800009a8:	02e7fa63          	bgeu	a5,a4,800009dc <dma_demo+0x214>
800009ac:	fef44703          	lbu	a4,-17(s0)
800009b0:	06600793          	li	a5,102
800009b4:	02e7e463          	bltu	a5,a4,800009dc <dma_demo+0x214>
800009b8:	fdf44783          	lbu	a5,-33(s0)
800009bc:	00479793          	slli	a5,a5,0x4
800009c0:	0ff7f713          	andi	a4,a5,255
800009c4:	fef44783          	lbu	a5,-17(s0)
800009c8:	00f707b3          	add	a5,a4,a5
800009cc:	0ff7f793          	andi	a5,a5,255
800009d0:	fa978793          	addi	a5,a5,-87
800009d4:	fcf40fa3          	sb	a5,-33(s0)
800009d8:	03c0006f          	j	80000a14 <dma_demo+0x24c>
800009dc:	fef44703          	lbu	a4,-17(s0)
800009e0:	04000793          	li	a5,64
800009e4:	04e7fa63          	bgeu	a5,a4,80000a38 <dma_demo+0x270>
800009e8:	fef44703          	lbu	a4,-17(s0)
800009ec:	04600793          	li	a5,70
800009f0:	04e7e463          	bltu	a5,a4,80000a38 <dma_demo+0x270>
800009f4:	fdf44783          	lbu	a5,-33(s0)
800009f8:	00479793          	slli	a5,a5,0x4
800009fc:	0ff7f713          	andi	a4,a5,255
80000a00:	fef44783          	lbu	a5,-17(s0)
80000a04:	00f707b3          	add	a5,a4,a5
80000a08:	0ff7f793          	andi	a5,a5,255
80000a0c:	fc978793          	addi	a5,a5,-55
80000a10:	fcf40fa3          	sb	a5,-33(s0)
80000a14:	279010ef          	jal	ra,8000248c <_getchar_uart>
80000a18:	00050793          	mv	a5,a0
80000a1c:	fef407a3          	sb	a5,-17(s0)
80000a20:	fef44703          	lbu	a4,-17(s0)
80000a24:	02000793          	li	a5,32
80000a28:	00f70863          	beq	a4,a5,80000a38 <dma_demo+0x270>
80000a2c:	fef44703          	lbu	a4,-17(s0)
80000a30:	00d00793          	li	a5,13
80000a34:	f2f718e3          	bne	a4,a5,80000964 <dma_demo+0x19c>
80000a38:	fe042783          	lw	a5,-32(s0)
80000a3c:	00178713          	addi	a4,a5,1
80000a40:	fee42023          	sw	a4,-32(s0)
80000a44:	68000737          	lui	a4,0x68000
80000a48:	00470713          	addi	a4,a4,4 # 68000004 <_reset_vector-0x17fffffc>
80000a4c:	00e787b3          	add	a5,a5,a4
80000a50:	fdf44703          	lbu	a4,-33(s0)
80000a54:	00e78023          	sb	a4,0(a5)
80000a58:	fdf44783          	lbu	a5,-33(s0)
80000a5c:	00078593          	mv	a1,a5
80000a60:	8000b7b7          	lui	a5,0x8000b
80000a64:	5bc78513          	addi	a0,a5,1468 # 8000b5bc <_bss_end+0xffe48fcc>
80000a68:	6b4010ef          	jal	ra,8000211c <printf_>
80000a6c:	221010ef          	jal	ra,8000248c <_getchar_uart>
80000a70:	00050793          	mv	a5,a0
80000a74:	fef407a3          	sb	a5,-17(s0)
80000a78:	fef44703          	lbu	a4,-17(s0)
80000a7c:	00d00793          	li	a5,13
80000a80:	ecf71ee3          	bne	a4,a5,8000095c <dma_demo+0x194>
80000a84:	8000b7b7          	lui	a5,0x8000b
80000a88:	5c478513          	addi	a0,a5,1476 # 8000b5c4 <_bss_end+0xffe48fd4>
80000a8c:	690010ef          	jal	ra,8000211c <printf_>
80000a90:	c01ff0ef          	jal	ra,80000690 <dma_send_finish>
80000a94:	b89ff0ef          	jal	ra,8000061c <dma_lock_release>
80000a98:	fe0407a3          	sb	zero,-17(s0)
80000a9c:	d51ff06f          	j	800007ec <dma_demo+0x24>
80000aa0:	fe0407a3          	sb	zero,-17(s0)
80000aa4:	d49ff06f          	j	800007ec <dma_demo+0x24>
80000aa8:	00000013          	nop
80000aac:	8000b7b7          	lui	a5,0x8000b
80000ab0:	5e878513          	addi	a0,a5,1512 # 8000b5e8 <_bss_end+0xffe48ff8>
80000ab4:	668010ef          	jal	ra,8000211c <printf_>
80000ab8:	00000013          	nop
80000abc:	02c12083          	lw	ra,44(sp)
80000ac0:	02812403          	lw	s0,40(sp)
80000ac4:	03010113          	addi	sp,sp,48
80000ac8:	00008067          	ret

80000acc <update_pos>:
80000acc:	fe010113          	addi	sp,sp,-32
80000ad0:	00812e23          	sw	s0,28(sp)
80000ad4:	02010413          	addi	s0,sp,32
80000ad8:	fea42623          	sw	a0,-20(s0)
80000adc:	feb42423          	sw	a1,-24(s0)
80000ae0:	00060793          	mv	a5,a2
80000ae4:	00068713          	mv	a4,a3
80000ae8:	fef403a3          	sb	a5,-25(s0)
80000aec:	00070793          	mv	a5,a4
80000af0:	fef40323          	sb	a5,-26(s0)
80000af4:	00100793          	li	a5,1
80000af8:	00078513          	mv	a0,a5
80000afc:	01c12403          	lw	s0,28(sp)
80000b00:	02010113          	addi	sp,sp,32
80000b04:	00008067          	ret

80000b08 <flush>:
80000b08:	ff010113          	addi	sp,sp,-16
80000b0c:	00812623          	sw	s0,12(sp)
80000b10:	01010413          	addi	s0,sp,16
80000b14:	00000013          	nop
80000b18:	00c12403          	lw	s0,12(sp)
80000b1c:	01010113          	addi	sp,sp,16
80000b20:	00008067          	ret

80000b24 <gpio_decode>:
80000b24:	fe010113          	addi	sp,sp,-32
80000b28:	00812e23          	sw	s0,28(sp)
80000b2c:	02010413          	addi	s0,sp,32
80000b30:	fea42623          	sw	a0,-20(s0)
80000b34:	fec42703          	lw	a4,-20(s0)
80000b38:	000807b7          	lui	a5,0x80
80000b3c:	20f70c63          	beq	a4,a5,80000d54 <gpio_decode+0x230>
80000b40:	fec42703          	lw	a4,-20(s0)
80000b44:	000807b7          	lui	a5,0x80
80000b48:	20e7ca63          	blt	a5,a4,80000d5c <gpio_decode+0x238>
80000b4c:	fec42703          	lw	a4,-20(s0)
80000b50:	000407b7          	lui	a5,0x40
80000b54:	1ef70c63          	beq	a4,a5,80000d4c <gpio_decode+0x228>
80000b58:	fec42703          	lw	a4,-20(s0)
80000b5c:	000407b7          	lui	a5,0x40
80000b60:	1ee7ce63          	blt	a5,a4,80000d5c <gpio_decode+0x238>
80000b64:	fec42703          	lw	a4,-20(s0)
80000b68:	000207b7          	lui	a5,0x20
80000b6c:	1cf70c63          	beq	a4,a5,80000d44 <gpio_decode+0x220>
80000b70:	fec42703          	lw	a4,-20(s0)
80000b74:	000207b7          	lui	a5,0x20
80000b78:	1ee7c263          	blt	a5,a4,80000d5c <gpio_decode+0x238>
80000b7c:	fec42703          	lw	a4,-20(s0)
80000b80:	000107b7          	lui	a5,0x10
80000b84:	1af70c63          	beq	a4,a5,80000d3c <gpio_decode+0x218>
80000b88:	fec42703          	lw	a4,-20(s0)
80000b8c:	000107b7          	lui	a5,0x10
80000b90:	1ce7c663          	blt	a5,a4,80000d5c <gpio_decode+0x238>
80000b94:	fec42703          	lw	a4,-20(s0)
80000b98:	000087b7          	lui	a5,0x8
80000b9c:	18f70c63          	beq	a4,a5,80000d34 <gpio_decode+0x210>
80000ba0:	fec42703          	lw	a4,-20(s0)
80000ba4:	000087b7          	lui	a5,0x8
80000ba8:	1ae7ca63          	blt	a5,a4,80000d5c <gpio_decode+0x238>
80000bac:	fec42703          	lw	a4,-20(s0)
80000bb0:	000047b7          	lui	a5,0x4
80000bb4:	16f70c63          	beq	a4,a5,80000d2c <gpio_decode+0x208>
80000bb8:	fec42703          	lw	a4,-20(s0)
80000bbc:	000047b7          	lui	a5,0x4
80000bc0:	18e7ce63          	blt	a5,a4,80000d5c <gpio_decode+0x238>
80000bc4:	fec42703          	lw	a4,-20(s0)
80000bc8:	000027b7          	lui	a5,0x2
80000bcc:	14f70c63          	beq	a4,a5,80000d24 <gpio_decode+0x200>
80000bd0:	fec42703          	lw	a4,-20(s0)
80000bd4:	000027b7          	lui	a5,0x2
80000bd8:	18e7c263          	blt	a5,a4,80000d5c <gpio_decode+0x238>
80000bdc:	fec42703          	lw	a4,-20(s0)
80000be0:	000017b7          	lui	a5,0x1
80000be4:	12f70c63          	beq	a4,a5,80000d1c <gpio_decode+0x1f8>
80000be8:	fec42703          	lw	a4,-20(s0)
80000bec:	000017b7          	lui	a5,0x1
80000bf0:	16e7c663          	blt	a5,a4,80000d5c <gpio_decode+0x238>
80000bf4:	fec42783          	lw	a5,-20(s0)
80000bf8:	80078793          	addi	a5,a5,-2048 # 800 <_reset_vector-0x7ffff800>
80000bfc:	10078c63          	beqz	a5,80000d14 <gpio_decode+0x1f0>
80000c00:	fec42703          	lw	a4,-20(s0)
80000c04:	000017b7          	lui	a5,0x1
80000c08:	80078793          	addi	a5,a5,-2048 # 800 <_reset_vector-0x7ffff800>
80000c0c:	14e7c863          	blt	a5,a4,80000d5c <gpio_decode+0x238>
80000c10:	fec42703          	lw	a4,-20(s0)
80000c14:	40000793          	li	a5,1024
80000c18:	0ef70a63          	beq	a4,a5,80000d0c <gpio_decode+0x1e8>
80000c1c:	fec42703          	lw	a4,-20(s0)
80000c20:	40000793          	li	a5,1024
80000c24:	12e7cc63          	blt	a5,a4,80000d5c <gpio_decode+0x238>
80000c28:	fec42703          	lw	a4,-20(s0)
80000c2c:	20000793          	li	a5,512
80000c30:	0cf70a63          	beq	a4,a5,80000d04 <gpio_decode+0x1e0>
80000c34:	fec42703          	lw	a4,-20(s0)
80000c38:	20000793          	li	a5,512
80000c3c:	12e7c063          	blt	a5,a4,80000d5c <gpio_decode+0x238>
80000c40:	fec42703          	lw	a4,-20(s0)
80000c44:	10000793          	li	a5,256
80000c48:	0af70a63          	beq	a4,a5,80000cfc <gpio_decode+0x1d8>
80000c4c:	fec42703          	lw	a4,-20(s0)
80000c50:	10000793          	li	a5,256
80000c54:	10e7c463          	blt	a5,a4,80000d5c <gpio_decode+0x238>
80000c58:	fec42703          	lw	a4,-20(s0)
80000c5c:	08000793          	li	a5,128
80000c60:	08f70a63          	beq	a4,a5,80000cf4 <gpio_decode+0x1d0>
80000c64:	fec42703          	lw	a4,-20(s0)
80000c68:	08000793          	li	a5,128
80000c6c:	0ee7c863          	blt	a5,a4,80000d5c <gpio_decode+0x238>
80000c70:	fec42703          	lw	a4,-20(s0)
80000c74:	02000793          	li	a5,32
80000c78:	02e7ca63          	blt	a5,a4,80000cac <gpio_decode+0x188>
80000c7c:	fec42783          	lw	a5,-20(s0)
80000c80:	0cf05e63          	blez	a5,80000d5c <gpio_decode+0x238>
80000c84:	fec42703          	lw	a4,-20(s0)
80000c88:	02000793          	li	a5,32
80000c8c:	0ce7e863          	bltu	a5,a4,80000d5c <gpio_decode+0x238>
80000c90:	fec42783          	lw	a5,-20(s0)
80000c94:	00279713          	slli	a4,a5,0x2
80000c98:	8000b7b7          	lui	a5,0x8000b
80000c9c:	5f878793          	addi	a5,a5,1528 # 8000b5f8 <_bss_end+0xffe49008>
80000ca0:	00f707b3          	add	a5,a4,a5
80000ca4:	0007a783          	lw	a5,0(a5)
80000ca8:	00078067          	jr	a5
80000cac:	fec42703          	lw	a4,-20(s0)
80000cb0:	04000793          	li	a5,64
80000cb4:	02f70c63          	beq	a4,a5,80000cec <gpio_decode+0x1c8>
80000cb8:	0a40006f          	j	80000d5c <gpio_decode+0x238>
80000cbc:	03000793          	li	a5,48
80000cc0:	0a00006f          	j	80000d60 <gpio_decode+0x23c>
80000cc4:	03100793          	li	a5,49
80000cc8:	0980006f          	j	80000d60 <gpio_decode+0x23c>
80000ccc:	03200793          	li	a5,50
80000cd0:	0900006f          	j	80000d60 <gpio_decode+0x23c>
80000cd4:	03300793          	li	a5,51
80000cd8:	0880006f          	j	80000d60 <gpio_decode+0x23c>
80000cdc:	03400793          	li	a5,52
80000ce0:	0800006f          	j	80000d60 <gpio_decode+0x23c>
80000ce4:	03500793          	li	a5,53
80000ce8:	0780006f          	j	80000d60 <gpio_decode+0x23c>
80000cec:	03600793          	li	a5,54
80000cf0:	0700006f          	j	80000d60 <gpio_decode+0x23c>
80000cf4:	03700793          	li	a5,55
80000cf8:	0680006f          	j	80000d60 <gpio_decode+0x23c>
80000cfc:	03800793          	li	a5,56
80000d00:	0600006f          	j	80000d60 <gpio_decode+0x23c>
80000d04:	03900793          	li	a5,57
80000d08:	0580006f          	j	80000d60 <gpio_decode+0x23c>
80000d0c:	06100793          	li	a5,97
80000d10:	0500006f          	j	80000d60 <gpio_decode+0x23c>
80000d14:	06200793          	li	a5,98
80000d18:	0480006f          	j	80000d60 <gpio_decode+0x23c>
80000d1c:	06300793          	li	a5,99
80000d20:	0400006f          	j	80000d60 <gpio_decode+0x23c>
80000d24:	06400793          	li	a5,100
80000d28:	0380006f          	j	80000d60 <gpio_decode+0x23c>
80000d2c:	06500793          	li	a5,101
80000d30:	0300006f          	j	80000d60 <gpio_decode+0x23c>
80000d34:	06600793          	li	a5,102
80000d38:	0280006f          	j	80000d60 <gpio_decode+0x23c>
80000d3c:	00a00793          	li	a5,10
80000d40:	0200006f          	j	80000d60 <gpio_decode+0x23c>
80000d44:	02000793          	li	a5,32
80000d48:	0180006f          	j	80000d60 <gpio_decode+0x23c>
80000d4c:	03a00793          	li	a5,58
80000d50:	0100006f          	j	80000d60 <gpio_decode+0x23c>
80000d54:	00800793          	li	a5,8
80000d58:	0080006f          	j	80000d60 <gpio_decode+0x23c>
80000d5c:	03f00793          	li	a5,63
80000d60:	00078513          	mv	a0,a5
80000d64:	01c12403          	lw	s0,28(sp)
80000d68:	02010113          	addi	sp,sp,32
80000d6c:	00008067          	ret

80000d70 <_getchar_gpio>:
80000d70:	fe010113          	addi	sp,sp,-32
80000d74:	00112e23          	sw	ra,28(sp)
80000d78:	00812c23          	sw	s0,24(sp)
80000d7c:	02010413          	addi	s0,sp,32
80000d80:	200007b7          	lui	a5,0x20000
80000d84:	0007a783          	lw	a5,0(a5) # 20000000 <_reset_vector-0x60000000>
80000d88:	fef42623          	sw	a5,-20(s0)
80000d8c:	0100006f          	j	80000d9c <_getchar_gpio+0x2c>
80000d90:	200007b7          	lui	a5,0x20000
80000d94:	0007a783          	lw	a5,0(a5) # 20000000 <_reset_vector-0x60000000>
80000d98:	fef42623          	sw	a5,-20(s0)
80000d9c:	fec42703          	lw	a4,-20(s0)
80000da0:	ff0007b7          	lui	a5,0xff000
80000da4:	00f777b3          	and	a5,a4,a5
80000da8:	fe0794e3          	bnez	a5,80000d90 <_getchar_gpio+0x20>
80000dac:	fec42503          	lw	a0,-20(s0)
80000db0:	d75ff0ef          	jal	ra,80000b24 <gpio_decode>
80000db4:	00050793          	mv	a5,a0
80000db8:	00078513          	mv	a0,a5
80000dbc:	01c12083          	lw	ra,28(sp)
80000dc0:	01812403          	lw	s0,24(sp)
80000dc4:	02010113          	addi	sp,sp,32
80000dc8:	00008067          	ret

80000dcc <assert>:
80000dcc:	fe010113          	addi	sp,sp,-32
80000dd0:	00112e23          	sw	ra,28(sp)
80000dd4:	00812c23          	sw	s0,24(sp)
80000dd8:	02010413          	addi	s0,sp,32
80000ddc:	00050793          	mv	a5,a0
80000de0:	fef407a3          	sb	a5,-17(s0)
80000de4:	fef44783          	lbu	a5,-17(s0)
80000de8:	0017c793          	xori	a5,a5,1
80000dec:	0ff7f793          	andi	a5,a5,255
80000df0:	00078863          	beqz	a5,80000e00 <assert+0x34>
80000df4:	8000b7b7          	lui	a5,0x8000b
80000df8:	67c78513          	addi	a0,a5,1660 # 8000b67c <_bss_end+0xffe4908c>
80000dfc:	320010ef          	jal	ra,8000211c <printf_>
80000e00:	00000013          	nop
80000e04:	01c12083          	lw	ra,28(sp)
80000e08:	01812403          	lw	s0,24(sp)
80000e0c:	02010113          	addi	sp,sp,32
80000e10:	00008067          	ret

80000e14 <assert_id>:
80000e14:	fe010113          	addi	sp,sp,-32
80000e18:	00112e23          	sw	ra,28(sp)
80000e1c:	00812c23          	sw	s0,24(sp)
80000e20:	02010413          	addi	s0,sp,32
80000e24:	00050793          	mv	a5,a0
80000e28:	00058713          	mv	a4,a1
80000e2c:	fef407a3          	sb	a5,-17(s0)
80000e30:	00070793          	mv	a5,a4
80000e34:	fef40723          	sb	a5,-18(s0)
80000e38:	fef44783          	lbu	a5,-17(s0)
80000e3c:	0017c793          	xori	a5,a5,1
80000e40:	0ff7f793          	andi	a5,a5,255
80000e44:	02078463          	beqz	a5,80000e6c <assert_id+0x58>
80000e48:	fee44783          	lbu	a5,-18(s0)
80000e4c:	00078593          	mv	a1,a5
80000e50:	8000b7b7          	lui	a5,0x8000b
80000e54:	69078513          	addi	a0,a5,1680 # 8000b690 <_bss_end+0xffe490a0>
80000e58:	2c4010ef          	jal	ra,8000211c <printf_>
80000e5c:	200007b7          	lui	a5,0x20000
80000e60:	00878793          	addi	a5,a5,8 # 20000008 <_reset_vector-0x5ffffff8>
80000e64:	fee44703          	lbu	a4,-18(s0)
80000e68:	00e7a023          	sw	a4,0(a5)
80000e6c:	00000013          	nop
80000e70:	01c12083          	lw	ra,28(sp)
80000e74:	01812403          	lw	s0,24(sp)
80000e78:	02010113          	addi	sp,sp,32
80000e7c:	00008067          	ret

80000e80 <_out_buffer>:
80000e80:	fe010113          	addi	sp,sp,-32
80000e84:	00812e23          	sw	s0,28(sp)
80000e88:	02010413          	addi	s0,sp,32
80000e8c:	00050793          	mv	a5,a0
80000e90:	feb42423          	sw	a1,-24(s0)
80000e94:	fec42223          	sw	a2,-28(s0)
80000e98:	fed42023          	sw	a3,-32(s0)
80000e9c:	fef407a3          	sb	a5,-17(s0)
80000ea0:	fe442703          	lw	a4,-28(s0)
80000ea4:	fe042783          	lw	a5,-32(s0)
80000ea8:	00f77c63          	bgeu	a4,a5,80000ec0 <_out_buffer+0x40>
80000eac:	fe842703          	lw	a4,-24(s0)
80000eb0:	fe442783          	lw	a5,-28(s0)
80000eb4:	00f707b3          	add	a5,a4,a5
80000eb8:	fef44703          	lbu	a4,-17(s0)
80000ebc:	00e78023          	sb	a4,0(a5)
80000ec0:	00000013          	nop
80000ec4:	01c12403          	lw	s0,28(sp)
80000ec8:	02010113          	addi	sp,sp,32
80000ecc:	00008067          	ret

80000ed0 <_out_null>:
80000ed0:	fe010113          	addi	sp,sp,-32
80000ed4:	00812e23          	sw	s0,28(sp)
80000ed8:	02010413          	addi	s0,sp,32
80000edc:	00050793          	mv	a5,a0
80000ee0:	feb42423          	sw	a1,-24(s0)
80000ee4:	fec42223          	sw	a2,-28(s0)
80000ee8:	fed42023          	sw	a3,-32(s0)
80000eec:	fef407a3          	sb	a5,-17(s0)
80000ef0:	00000013          	nop
80000ef4:	01c12403          	lw	s0,28(sp)
80000ef8:	02010113          	addi	sp,sp,32
80000efc:	00008067          	ret

80000f00 <_out_char>:
80000f00:	fe010113          	addi	sp,sp,-32
80000f04:	00112e23          	sw	ra,28(sp)
80000f08:	00812c23          	sw	s0,24(sp)
80000f0c:	02010413          	addi	s0,sp,32
80000f10:	00050793          	mv	a5,a0
80000f14:	feb42423          	sw	a1,-24(s0)
80000f18:	fec42223          	sw	a2,-28(s0)
80000f1c:	fed42023          	sw	a3,-32(s0)
80000f20:	fef407a3          	sb	a5,-17(s0)
80000f24:	fef44783          	lbu	a5,-17(s0)
80000f28:	00078863          	beqz	a5,80000f38 <_out_char+0x38>
80000f2c:	fef44783          	lbu	a5,-17(s0)
80000f30:	00078513          	mv	a0,a5
80000f34:	50c010ef          	jal	ra,80002440 <_putchar>
80000f38:	00000013          	nop
80000f3c:	01c12083          	lw	ra,28(sp)
80000f40:	01812403          	lw	s0,24(sp)
80000f44:	02010113          	addi	sp,sp,32
80000f48:	00008067          	ret

80000f4c <_out_fct>:
80000f4c:	fe010113          	addi	sp,sp,-32
80000f50:	00112e23          	sw	ra,28(sp)
80000f54:	00812c23          	sw	s0,24(sp)
80000f58:	02010413          	addi	s0,sp,32
80000f5c:	00050793          	mv	a5,a0
80000f60:	feb42423          	sw	a1,-24(s0)
80000f64:	fec42223          	sw	a2,-28(s0)
80000f68:	fed42023          	sw	a3,-32(s0)
80000f6c:	fef407a3          	sb	a5,-17(s0)
80000f70:	fef44783          	lbu	a5,-17(s0)
80000f74:	02078263          	beqz	a5,80000f98 <_out_fct+0x4c>
80000f78:	fe842783          	lw	a5,-24(s0)
80000f7c:	0007a683          	lw	a3,0(a5)
80000f80:	fe842783          	lw	a5,-24(s0)
80000f84:	0047a703          	lw	a4,4(a5)
80000f88:	fef44783          	lbu	a5,-17(s0)
80000f8c:	00070593          	mv	a1,a4
80000f90:	00078513          	mv	a0,a5
80000f94:	000680e7          	jalr	a3
80000f98:	00000013          	nop
80000f9c:	01c12083          	lw	ra,28(sp)
80000fa0:	01812403          	lw	s0,24(sp)
80000fa4:	02010113          	addi	sp,sp,32
80000fa8:	00008067          	ret

80000fac <_strnlen_s>:
80000fac:	fd010113          	addi	sp,sp,-48
80000fb0:	02812623          	sw	s0,44(sp)
80000fb4:	03010413          	addi	s0,sp,48
80000fb8:	fca42e23          	sw	a0,-36(s0)
80000fbc:	fcb42c23          	sw	a1,-40(s0)
80000fc0:	fdc42783          	lw	a5,-36(s0)
80000fc4:	fef42623          	sw	a5,-20(s0)
80000fc8:	0100006f          	j	80000fd8 <_strnlen_s+0x2c>
80000fcc:	fec42783          	lw	a5,-20(s0)
80000fd0:	00178793          	addi	a5,a5,1
80000fd4:	fef42623          	sw	a5,-20(s0)
80000fd8:	fec42783          	lw	a5,-20(s0)
80000fdc:	0007c783          	lbu	a5,0(a5)
80000fe0:	00078a63          	beqz	a5,80000ff4 <_strnlen_s+0x48>
80000fe4:	fd842783          	lw	a5,-40(s0)
80000fe8:	fff78713          	addi	a4,a5,-1
80000fec:	fce42c23          	sw	a4,-40(s0)
80000ff0:	fc079ee3          	bnez	a5,80000fcc <_strnlen_s+0x20>
80000ff4:	fec42703          	lw	a4,-20(s0)
80000ff8:	fdc42783          	lw	a5,-36(s0)
80000ffc:	40f707b3          	sub	a5,a4,a5
80001000:	00078513          	mv	a0,a5
80001004:	02c12403          	lw	s0,44(sp)
80001008:	03010113          	addi	sp,sp,48
8000100c:	00008067          	ret

80001010 <_is_digit>:
80001010:	fe010113          	addi	sp,sp,-32
80001014:	00812e23          	sw	s0,28(sp)
80001018:	02010413          	addi	s0,sp,32
8000101c:	00050793          	mv	a5,a0
80001020:	fef407a3          	sb	a5,-17(s0)
80001024:	fef44703          	lbu	a4,-17(s0)
80001028:	02f00793          	li	a5,47
8000102c:	00e7fc63          	bgeu	a5,a4,80001044 <_is_digit+0x34>
80001030:	fef44703          	lbu	a4,-17(s0)
80001034:	03900793          	li	a5,57
80001038:	00e7e663          	bltu	a5,a4,80001044 <_is_digit+0x34>
8000103c:	00100793          	li	a5,1
80001040:	0080006f          	j	80001048 <_is_digit+0x38>
80001044:	00000793          	li	a5,0
80001048:	0017f793          	andi	a5,a5,1
8000104c:	0ff7f793          	andi	a5,a5,255
80001050:	00078513          	mv	a0,a5
80001054:	01c12403          	lw	s0,28(sp)
80001058:	02010113          	addi	sp,sp,32
8000105c:	00008067          	ret

80001060 <_atoi>:
80001060:	fd010113          	addi	sp,sp,-48
80001064:	02112623          	sw	ra,44(sp)
80001068:	02812423          	sw	s0,40(sp)
8000106c:	03010413          	addi	s0,sp,48
80001070:	fca42e23          	sw	a0,-36(s0)
80001074:	fe042623          	sw	zero,-20(s0)
80001078:	0400006f          	j	800010b8 <_atoi+0x58>
8000107c:	fec42703          	lw	a4,-20(s0)
80001080:	00070793          	mv	a5,a4
80001084:	00279793          	slli	a5,a5,0x2
80001088:	00e787b3          	add	a5,a5,a4
8000108c:	00179793          	slli	a5,a5,0x1
80001090:	00078613          	mv	a2,a5
80001094:	fdc42783          	lw	a5,-36(s0)
80001098:	0007a783          	lw	a5,0(a5)
8000109c:	00178693          	addi	a3,a5,1
800010a0:	fdc42703          	lw	a4,-36(s0)
800010a4:	00d72023          	sw	a3,0(a4)
800010a8:	0007c783          	lbu	a5,0(a5)
800010ac:	00f607b3          	add	a5,a2,a5
800010b0:	fd078793          	addi	a5,a5,-48
800010b4:	fef42623          	sw	a5,-20(s0)
800010b8:	fdc42783          	lw	a5,-36(s0)
800010bc:	0007a783          	lw	a5,0(a5)
800010c0:	0007c783          	lbu	a5,0(a5)
800010c4:	00078513          	mv	a0,a5
800010c8:	f49ff0ef          	jal	ra,80001010 <_is_digit>
800010cc:	00050793          	mv	a5,a0
800010d0:	fa0796e3          	bnez	a5,8000107c <_atoi+0x1c>
800010d4:	fec42783          	lw	a5,-20(s0)
800010d8:	00078513          	mv	a0,a5
800010dc:	02c12083          	lw	ra,44(sp)
800010e0:	02812403          	lw	s0,40(sp)
800010e4:	03010113          	addi	sp,sp,48
800010e8:	00008067          	ret

800010ec <_out_rev>:
800010ec:	fc010113          	addi	sp,sp,-64
800010f0:	02112e23          	sw	ra,60(sp)
800010f4:	02812c23          	sw	s0,56(sp)
800010f8:	04010413          	addi	s0,sp,64
800010fc:	fca42e23          	sw	a0,-36(s0)
80001100:	fcb42c23          	sw	a1,-40(s0)
80001104:	fcc42a23          	sw	a2,-44(s0)
80001108:	fcd42823          	sw	a3,-48(s0)
8000110c:	fce42623          	sw	a4,-52(s0)
80001110:	fcf42423          	sw	a5,-56(s0)
80001114:	fd042223          	sw	a6,-60(s0)
80001118:	fd142023          	sw	a7,-64(s0)
8000111c:	fd442783          	lw	a5,-44(s0)
80001120:	fef42423          	sw	a5,-24(s0)
80001124:	fc042783          	lw	a5,-64(s0)
80001128:	0027f793          	andi	a5,a5,2
8000112c:	08079c63          	bnez	a5,800011c4 <_out_rev+0xd8>
80001130:	fc042783          	lw	a5,-64(s0)
80001134:	0017f793          	andi	a5,a5,1
80001138:	08079663          	bnez	a5,800011c4 <_out_rev+0xd8>
8000113c:	fc842783          	lw	a5,-56(s0)
80001140:	fef42623          	sw	a5,-20(s0)
80001144:	0340006f          	j	80001178 <_out_rev+0x8c>
80001148:	fd442783          	lw	a5,-44(s0)
8000114c:	00178713          	addi	a4,a5,1
80001150:	fce42a23          	sw	a4,-44(s0)
80001154:	fdc42703          	lw	a4,-36(s0)
80001158:	fd042683          	lw	a3,-48(s0)
8000115c:	00078613          	mv	a2,a5
80001160:	fd842583          	lw	a1,-40(s0)
80001164:	02000513          	li	a0,32
80001168:	000700e7          	jalr	a4
8000116c:	fec42783          	lw	a5,-20(s0)
80001170:	00178793          	addi	a5,a5,1
80001174:	fef42623          	sw	a5,-20(s0)
80001178:	fec42703          	lw	a4,-20(s0)
8000117c:	fc442783          	lw	a5,-60(s0)
80001180:	fcf764e3          	bltu	a4,a5,80001148 <_out_rev+0x5c>
80001184:	0400006f          	j	800011c4 <_out_rev+0xd8>
80001188:	fc842783          	lw	a5,-56(s0)
8000118c:	fff78793          	addi	a5,a5,-1
80001190:	fcf42423          	sw	a5,-56(s0)
80001194:	fcc42703          	lw	a4,-52(s0)
80001198:	fc842783          	lw	a5,-56(s0)
8000119c:	00f707b3          	add	a5,a4,a5
800011a0:	0007c503          	lbu	a0,0(a5)
800011a4:	fd442783          	lw	a5,-44(s0)
800011a8:	00178713          	addi	a4,a5,1
800011ac:	fce42a23          	sw	a4,-44(s0)
800011b0:	fdc42703          	lw	a4,-36(s0)
800011b4:	fd042683          	lw	a3,-48(s0)
800011b8:	00078613          	mv	a2,a5
800011bc:	fd842583          	lw	a1,-40(s0)
800011c0:	000700e7          	jalr	a4
800011c4:	fc842783          	lw	a5,-56(s0)
800011c8:	fc0790e3          	bnez	a5,80001188 <_out_rev+0x9c>
800011cc:	fc042783          	lw	a5,-64(s0)
800011d0:	0027f793          	andi	a5,a5,2
800011d4:	04078063          	beqz	a5,80001214 <_out_rev+0x128>
800011d8:	0280006f          	j	80001200 <_out_rev+0x114>
800011dc:	fd442783          	lw	a5,-44(s0)
800011e0:	00178713          	addi	a4,a5,1
800011e4:	fce42a23          	sw	a4,-44(s0)
800011e8:	fdc42703          	lw	a4,-36(s0)
800011ec:	fd042683          	lw	a3,-48(s0)
800011f0:	00078613          	mv	a2,a5
800011f4:	fd842583          	lw	a1,-40(s0)
800011f8:	02000513          	li	a0,32
800011fc:	000700e7          	jalr	a4
80001200:	fd442703          	lw	a4,-44(s0)
80001204:	fe842783          	lw	a5,-24(s0)
80001208:	40f707b3          	sub	a5,a4,a5
8000120c:	fc442703          	lw	a4,-60(s0)
80001210:	fce7e6e3          	bltu	a5,a4,800011dc <_out_rev+0xf0>
80001214:	fd442783          	lw	a5,-44(s0)
80001218:	00078513          	mv	a0,a5
8000121c:	03c12083          	lw	ra,60(sp)
80001220:	03812403          	lw	s0,56(sp)
80001224:	04010113          	addi	sp,sp,64
80001228:	00008067          	ret

8000122c <_ntoa_format>:
8000122c:	fd010113          	addi	sp,sp,-48
80001230:	02112623          	sw	ra,44(sp)
80001234:	02812423          	sw	s0,40(sp)
80001238:	03010413          	addi	s0,sp,48
8000123c:	fea42623          	sw	a0,-20(s0)
80001240:	feb42423          	sw	a1,-24(s0)
80001244:	fec42223          	sw	a2,-28(s0)
80001248:	fed42023          	sw	a3,-32(s0)
8000124c:	fce42e23          	sw	a4,-36(s0)
80001250:	fcf42c23          	sw	a5,-40(s0)
80001254:	00080793          	mv	a5,a6
80001258:	fd142823          	sw	a7,-48(s0)
8000125c:	fcf40ba3          	sb	a5,-41(s0)
80001260:	00842783          	lw	a5,8(s0)
80001264:	0027f793          	andi	a5,a5,2
80001268:	0a079a63          	bnez	a5,8000131c <_ntoa_format+0xf0>
8000126c:	00442783          	lw	a5,4(s0)
80001270:	04078863          	beqz	a5,800012c0 <_ntoa_format+0x94>
80001274:	00842783          	lw	a5,8(s0)
80001278:	0017f793          	andi	a5,a5,1
8000127c:	04078263          	beqz	a5,800012c0 <_ntoa_format+0x94>
80001280:	fd744783          	lbu	a5,-41(s0)
80001284:	00079863          	bnez	a5,80001294 <_ntoa_format+0x68>
80001288:	00842783          	lw	a5,8(s0)
8000128c:	00c7f793          	andi	a5,a5,12
80001290:	02078863          	beqz	a5,800012c0 <_ntoa_format+0x94>
80001294:	00442783          	lw	a5,4(s0)
80001298:	fff78793          	addi	a5,a5,-1
8000129c:	00f42223          	sw	a5,4(s0)
800012a0:	0200006f          	j	800012c0 <_ntoa_format+0x94>
800012a4:	fd842783          	lw	a5,-40(s0)
800012a8:	00178713          	addi	a4,a5,1
800012ac:	fce42c23          	sw	a4,-40(s0)
800012b0:	fdc42703          	lw	a4,-36(s0)
800012b4:	00f707b3          	add	a5,a4,a5
800012b8:	03000713          	li	a4,48
800012bc:	00e78023          	sb	a4,0(a5)
800012c0:	fd842703          	lw	a4,-40(s0)
800012c4:	00042783          	lw	a5,0(s0)
800012c8:	02f77863          	bgeu	a4,a5,800012f8 <_ntoa_format+0xcc>
800012cc:	fd842703          	lw	a4,-40(s0)
800012d0:	01f00793          	li	a5,31
800012d4:	fce7f8e3          	bgeu	a5,a4,800012a4 <_ntoa_format+0x78>
800012d8:	0200006f          	j	800012f8 <_ntoa_format+0xcc>
800012dc:	fd842783          	lw	a5,-40(s0)
800012e0:	00178713          	addi	a4,a5,1
800012e4:	fce42c23          	sw	a4,-40(s0)
800012e8:	fdc42703          	lw	a4,-36(s0)
800012ec:	00f707b3          	add	a5,a4,a5
800012f0:	03000713          	li	a4,48
800012f4:	00e78023          	sb	a4,0(a5)
800012f8:	00842783          	lw	a5,8(s0)
800012fc:	0017f793          	andi	a5,a5,1
80001300:	00078e63          	beqz	a5,8000131c <_ntoa_format+0xf0>
80001304:	fd842703          	lw	a4,-40(s0)
80001308:	00442783          	lw	a5,4(s0)
8000130c:	00f77863          	bgeu	a4,a5,8000131c <_ntoa_format+0xf0>
80001310:	fd842703          	lw	a4,-40(s0)
80001314:	01f00793          	li	a5,31
80001318:	fce7f2e3          	bgeu	a5,a4,800012dc <_ntoa_format+0xb0>
8000131c:	00842783          	lw	a5,8(s0)
80001320:	0107f793          	andi	a5,a5,16
80001324:	14078063          	beqz	a5,80001464 <_ntoa_format+0x238>
80001328:	00842783          	lw	a5,8(s0)
8000132c:	4007f793          	andi	a5,a5,1024
80001330:	04079863          	bnez	a5,80001380 <_ntoa_format+0x154>
80001334:	fd842783          	lw	a5,-40(s0)
80001338:	04078463          	beqz	a5,80001380 <_ntoa_format+0x154>
8000133c:	fd842703          	lw	a4,-40(s0)
80001340:	00042783          	lw	a5,0(s0)
80001344:	00f70863          	beq	a4,a5,80001354 <_ntoa_format+0x128>
80001348:	fd842703          	lw	a4,-40(s0)
8000134c:	00442783          	lw	a5,4(s0)
80001350:	02f71863          	bne	a4,a5,80001380 <_ntoa_format+0x154>
80001354:	fd842783          	lw	a5,-40(s0)
80001358:	fff78793          	addi	a5,a5,-1
8000135c:	fcf42c23          	sw	a5,-40(s0)
80001360:	fd842783          	lw	a5,-40(s0)
80001364:	00078e63          	beqz	a5,80001380 <_ntoa_format+0x154>
80001368:	fd042703          	lw	a4,-48(s0)
8000136c:	01000793          	li	a5,16
80001370:	00f71863          	bne	a4,a5,80001380 <_ntoa_format+0x154>
80001374:	fd842783          	lw	a5,-40(s0)
80001378:	fff78793          	addi	a5,a5,-1
8000137c:	fcf42c23          	sw	a5,-40(s0)
80001380:	fd042703          	lw	a4,-48(s0)
80001384:	01000793          	li	a5,16
80001388:	02f71e63          	bne	a4,a5,800013c4 <_ntoa_format+0x198>
8000138c:	00842783          	lw	a5,8(s0)
80001390:	0207f793          	andi	a5,a5,32
80001394:	02079863          	bnez	a5,800013c4 <_ntoa_format+0x198>
80001398:	fd842703          	lw	a4,-40(s0)
8000139c:	01f00793          	li	a5,31
800013a0:	02e7e263          	bltu	a5,a4,800013c4 <_ntoa_format+0x198>
800013a4:	fd842783          	lw	a5,-40(s0)
800013a8:	00178713          	addi	a4,a5,1
800013ac:	fce42c23          	sw	a4,-40(s0)
800013b0:	fdc42703          	lw	a4,-36(s0)
800013b4:	00f707b3          	add	a5,a4,a5
800013b8:	07800713          	li	a4,120
800013bc:	00e78023          	sb	a4,0(a5)
800013c0:	07c0006f          	j	8000143c <_ntoa_format+0x210>
800013c4:	fd042703          	lw	a4,-48(s0)
800013c8:	01000793          	li	a5,16
800013cc:	02f71e63          	bne	a4,a5,80001408 <_ntoa_format+0x1dc>
800013d0:	00842783          	lw	a5,8(s0)
800013d4:	0207f793          	andi	a5,a5,32
800013d8:	02078863          	beqz	a5,80001408 <_ntoa_format+0x1dc>
800013dc:	fd842703          	lw	a4,-40(s0)
800013e0:	01f00793          	li	a5,31
800013e4:	02e7e263          	bltu	a5,a4,80001408 <_ntoa_format+0x1dc>
800013e8:	fd842783          	lw	a5,-40(s0)
800013ec:	00178713          	addi	a4,a5,1
800013f0:	fce42c23          	sw	a4,-40(s0)
800013f4:	fdc42703          	lw	a4,-36(s0)
800013f8:	00f707b3          	add	a5,a4,a5
800013fc:	05800713          	li	a4,88
80001400:	00e78023          	sb	a4,0(a5)
80001404:	0380006f          	j	8000143c <_ntoa_format+0x210>
80001408:	fd042703          	lw	a4,-48(s0)
8000140c:	00200793          	li	a5,2
80001410:	02f71663          	bne	a4,a5,8000143c <_ntoa_format+0x210>
80001414:	fd842703          	lw	a4,-40(s0)
80001418:	01f00793          	li	a5,31
8000141c:	02e7e063          	bltu	a5,a4,8000143c <_ntoa_format+0x210>
80001420:	fd842783          	lw	a5,-40(s0)
80001424:	00178713          	addi	a4,a5,1
80001428:	fce42c23          	sw	a4,-40(s0)
8000142c:	fdc42703          	lw	a4,-36(s0)
80001430:	00f707b3          	add	a5,a4,a5
80001434:	06200713          	li	a4,98
80001438:	00e78023          	sb	a4,0(a5)
8000143c:	fd842703          	lw	a4,-40(s0)
80001440:	01f00793          	li	a5,31
80001444:	02e7e063          	bltu	a5,a4,80001464 <_ntoa_format+0x238>
80001448:	fd842783          	lw	a5,-40(s0)
8000144c:	00178713          	addi	a4,a5,1
80001450:	fce42c23          	sw	a4,-40(s0)
80001454:	fdc42703          	lw	a4,-36(s0)
80001458:	00f707b3          	add	a5,a4,a5
8000145c:	03000713          	li	a4,48
80001460:	00e78023          	sb	a4,0(a5)
80001464:	fd842703          	lw	a4,-40(s0)
80001468:	01f00793          	li	a5,31
8000146c:	08e7e063          	bltu	a5,a4,800014ec <_ntoa_format+0x2c0>
80001470:	fd744783          	lbu	a5,-41(s0)
80001474:	02078263          	beqz	a5,80001498 <_ntoa_format+0x26c>
80001478:	fd842783          	lw	a5,-40(s0)
8000147c:	00178713          	addi	a4,a5,1
80001480:	fce42c23          	sw	a4,-40(s0)
80001484:	fdc42703          	lw	a4,-36(s0)
80001488:	00f707b3          	add	a5,a4,a5
8000148c:	02d00713          	li	a4,45
80001490:	00e78023          	sb	a4,0(a5)
80001494:	0580006f          	j	800014ec <_ntoa_format+0x2c0>
80001498:	00842783          	lw	a5,8(s0)
8000149c:	0047f793          	andi	a5,a5,4
800014a0:	02078263          	beqz	a5,800014c4 <_ntoa_format+0x298>
800014a4:	fd842783          	lw	a5,-40(s0)
800014a8:	00178713          	addi	a4,a5,1
800014ac:	fce42c23          	sw	a4,-40(s0)
800014b0:	fdc42703          	lw	a4,-36(s0)
800014b4:	00f707b3          	add	a5,a4,a5
800014b8:	02b00713          	li	a4,43
800014bc:	00e78023          	sb	a4,0(a5)
800014c0:	02c0006f          	j	800014ec <_ntoa_format+0x2c0>
800014c4:	00842783          	lw	a5,8(s0)
800014c8:	0087f793          	andi	a5,a5,8
800014cc:	02078063          	beqz	a5,800014ec <_ntoa_format+0x2c0>
800014d0:	fd842783          	lw	a5,-40(s0)
800014d4:	00178713          	addi	a4,a5,1
800014d8:	fce42c23          	sw	a4,-40(s0)
800014dc:	fdc42703          	lw	a4,-36(s0)
800014e0:	00f707b3          	add	a5,a4,a5
800014e4:	02000713          	li	a4,32
800014e8:	00e78023          	sb	a4,0(a5)
800014ec:	00842883          	lw	a7,8(s0)
800014f0:	00442803          	lw	a6,4(s0)
800014f4:	fd842783          	lw	a5,-40(s0)
800014f8:	fdc42703          	lw	a4,-36(s0)
800014fc:	fe042683          	lw	a3,-32(s0)
80001500:	fe442603          	lw	a2,-28(s0)
80001504:	fe842583          	lw	a1,-24(s0)
80001508:	fec42503          	lw	a0,-20(s0)
8000150c:	be1ff0ef          	jal	ra,800010ec <_out_rev>
80001510:	00050793          	mv	a5,a0
80001514:	00078513          	mv	a0,a5
80001518:	02c12083          	lw	ra,44(sp)
8000151c:	02812403          	lw	s0,40(sp)
80001520:	03010113          	addi	sp,sp,48
80001524:	00008067          	ret

80001528 <_ntoa_long>:
80001528:	f9010113          	addi	sp,sp,-112
8000152c:	06112623          	sw	ra,108(sp)
80001530:	06812423          	sw	s0,104(sp)
80001534:	07010413          	addi	s0,sp,112
80001538:	faa42e23          	sw	a0,-68(s0)
8000153c:	fab42c23          	sw	a1,-72(s0)
80001540:	fac42a23          	sw	a2,-76(s0)
80001544:	fad42823          	sw	a3,-80(s0)
80001548:	fae42623          	sw	a4,-84(s0)
8000154c:	fb042223          	sw	a6,-92(s0)
80001550:	fb142023          	sw	a7,-96(s0)
80001554:	faf405a3          	sb	a5,-85(s0)
80001558:	fe042623          	sw	zero,-20(s0)
8000155c:	fac42783          	lw	a5,-84(s0)
80001560:	00079863          	bnez	a5,80001570 <_ntoa_long+0x48>
80001564:	00442783          	lw	a5,4(s0)
80001568:	fef7f793          	andi	a5,a5,-17
8000156c:	00f42223          	sw	a5,4(s0)
80001570:	00442783          	lw	a5,4(s0)
80001574:	4007f793          	andi	a5,a5,1024
80001578:	00078663          	beqz	a5,80001584 <_ntoa_long+0x5c>
8000157c:	fac42783          	lw	a5,-84(s0)
80001580:	0a078263          	beqz	a5,80001624 <_ntoa_long+0xfc>
80001584:	fac42783          	lw	a5,-84(s0)
80001588:	fa442583          	lw	a1,-92(s0)
8000158c:	00078513          	mv	a0,a5
80001590:	781090ef          	jal	ra,8000b510 <__umodsi3>
80001594:	00050793          	mv	a5,a0
80001598:	fef405a3          	sb	a5,-21(s0)
8000159c:	feb44703          	lbu	a4,-21(s0)
800015a0:	00900793          	li	a5,9
800015a4:	00e7ea63          	bltu	a5,a4,800015b8 <_ntoa_long+0x90>
800015a8:	feb44783          	lbu	a5,-21(s0)
800015ac:	03078793          	addi	a5,a5,48
800015b0:	0ff7f793          	andi	a5,a5,255
800015b4:	0300006f          	j	800015e4 <_ntoa_long+0xbc>
800015b8:	00442783          	lw	a5,4(s0)
800015bc:	0207f793          	andi	a5,a5,32
800015c0:	00078663          	beqz	a5,800015cc <_ntoa_long+0xa4>
800015c4:	04100793          	li	a5,65
800015c8:	0080006f          	j	800015d0 <_ntoa_long+0xa8>
800015cc:	06100793          	li	a5,97
800015d0:	feb44703          	lbu	a4,-21(s0)
800015d4:	00e787b3          	add	a5,a5,a4
800015d8:	0ff7f793          	andi	a5,a5,255
800015dc:	ff678793          	addi	a5,a5,-10
800015e0:	0ff7f793          	andi	a5,a5,255
800015e4:	fec42703          	lw	a4,-20(s0)
800015e8:	00170693          	addi	a3,a4,1
800015ec:	fed42623          	sw	a3,-20(s0)
800015f0:	ff040693          	addi	a3,s0,-16
800015f4:	00e68733          	add	a4,a3,a4
800015f8:	fcf70c23          	sb	a5,-40(a4)
800015fc:	fa442583          	lw	a1,-92(s0)
80001600:	fac42503          	lw	a0,-84(s0)
80001604:	6c5090ef          	jal	ra,8000b4c8 <__udivsi3>
80001608:	00050793          	mv	a5,a0
8000160c:	faf42623          	sw	a5,-84(s0)
80001610:	fac42783          	lw	a5,-84(s0)
80001614:	00078863          	beqz	a5,80001624 <_ntoa_long+0xfc>
80001618:	fec42703          	lw	a4,-20(s0)
8000161c:	01f00793          	li	a5,31
80001620:	f6e7f2e3          	bgeu	a5,a4,80001584 <_ntoa_long+0x5c>
80001624:	fab44683          	lbu	a3,-85(s0)
80001628:	fc840713          	addi	a4,s0,-56
8000162c:	00442783          	lw	a5,4(s0)
80001630:	00f12423          	sw	a5,8(sp)
80001634:	00042783          	lw	a5,0(s0)
80001638:	00f12223          	sw	a5,4(sp)
8000163c:	fa042783          	lw	a5,-96(s0)
80001640:	00f12023          	sw	a5,0(sp)
80001644:	fa442883          	lw	a7,-92(s0)
80001648:	00068813          	mv	a6,a3
8000164c:	fec42783          	lw	a5,-20(s0)
80001650:	fb042683          	lw	a3,-80(s0)
80001654:	fb442603          	lw	a2,-76(s0)
80001658:	fb842583          	lw	a1,-72(s0)
8000165c:	fbc42503          	lw	a0,-68(s0)
80001660:	bcdff0ef          	jal	ra,8000122c <_ntoa_format>
80001664:	00050793          	mv	a5,a0
80001668:	00078513          	mv	a0,a5
8000166c:	06c12083          	lw	ra,108(sp)
80001670:	06812403          	lw	s0,104(sp)
80001674:	07010113          	addi	sp,sp,112
80001678:	00008067          	ret

8000167c <_vsnprintf>:
8000167c:	f8010113          	addi	sp,sp,-128
80001680:	06112e23          	sw	ra,124(sp)
80001684:	06812c23          	sw	s0,120(sp)
80001688:	08010413          	addi	s0,sp,128
8000168c:	faa42623          	sw	a0,-84(s0)
80001690:	fab42423          	sw	a1,-88(s0)
80001694:	fac42223          	sw	a2,-92(s0)
80001698:	fad42023          	sw	a3,-96(s0)
8000169c:	f8e42e23          	sw	a4,-100(s0)
800016a0:	fc042e23          	sw	zero,-36(s0)
800016a4:	fa842783          	lw	a5,-88(s0)
800016a8:	20079ee3          	bnez	a5,800020c4 <_vsnprintf+0xa48>
800016ac:	800017b7          	lui	a5,0x80001
800016b0:	ed078793          	addi	a5,a5,-304 # 80000ed0 <_bss_end+0xffe3e8e0>
800016b4:	faf42623          	sw	a5,-84(s0)
800016b8:	20d0006f          	j	800020c4 <_vsnprintf+0xa48>
800016bc:	fa042783          	lw	a5,-96(s0)
800016c0:	0007c703          	lbu	a4,0(a5)
800016c4:	02500793          	li	a5,37
800016c8:	02f70e63          	beq	a4,a5,80001704 <_vsnprintf+0x88>
800016cc:	fa042783          	lw	a5,-96(s0)
800016d0:	0007c503          	lbu	a0,0(a5)
800016d4:	fdc42783          	lw	a5,-36(s0)
800016d8:	00178713          	addi	a4,a5,1
800016dc:	fce42e23          	sw	a4,-36(s0)
800016e0:	fac42703          	lw	a4,-84(s0)
800016e4:	fa442683          	lw	a3,-92(s0)
800016e8:	00078613          	mv	a2,a5
800016ec:	fa842583          	lw	a1,-88(s0)
800016f0:	000700e7          	jalr	a4
800016f4:	fa042783          	lw	a5,-96(s0)
800016f8:	00178793          	addi	a5,a5,1
800016fc:	faf42023          	sw	a5,-96(s0)
80001700:	1c50006f          	j	800020c4 <_vsnprintf+0xa48>
80001704:	fa042783          	lw	a5,-96(s0)
80001708:	00178793          	addi	a5,a5,1
8000170c:	faf42023          	sw	a5,-96(s0)
80001710:	fe042623          	sw	zero,-20(s0)
80001714:	fa042783          	lw	a5,-96(s0)
80001718:	0007c783          	lbu	a5,0(a5)
8000171c:	fe078793          	addi	a5,a5,-32
80001720:	01000713          	li	a4,16
80001724:	0cf76863          	bltu	a4,a5,800017f4 <_vsnprintf+0x178>
80001728:	00279713          	slli	a4,a5,0x2
8000172c:	8000b7b7          	lui	a5,0x8000b
80001730:	6ac78793          	addi	a5,a5,1708 # 8000b6ac <_bss_end+0xffe490bc>
80001734:	00f707b3          	add	a5,a4,a5
80001738:	0007a783          	lw	a5,0(a5)
8000173c:	00078067          	jr	a5
80001740:	fec42783          	lw	a5,-20(s0)
80001744:	0017e793          	ori	a5,a5,1
80001748:	fef42623          	sw	a5,-20(s0)
8000174c:	fa042783          	lw	a5,-96(s0)
80001750:	00178793          	addi	a5,a5,1
80001754:	faf42023          	sw	a5,-96(s0)
80001758:	00100793          	li	a5,1
8000175c:	fef42023          	sw	a5,-32(s0)
80001760:	09c0006f          	j	800017fc <_vsnprintf+0x180>
80001764:	fec42783          	lw	a5,-20(s0)
80001768:	0027e793          	ori	a5,a5,2
8000176c:	fef42623          	sw	a5,-20(s0)
80001770:	fa042783          	lw	a5,-96(s0)
80001774:	00178793          	addi	a5,a5,1
80001778:	faf42023          	sw	a5,-96(s0)
8000177c:	00100793          	li	a5,1
80001780:	fef42023          	sw	a5,-32(s0)
80001784:	0780006f          	j	800017fc <_vsnprintf+0x180>
80001788:	fec42783          	lw	a5,-20(s0)
8000178c:	0047e793          	ori	a5,a5,4
80001790:	fef42623          	sw	a5,-20(s0)
80001794:	fa042783          	lw	a5,-96(s0)
80001798:	00178793          	addi	a5,a5,1
8000179c:	faf42023          	sw	a5,-96(s0)
800017a0:	00100793          	li	a5,1
800017a4:	fef42023          	sw	a5,-32(s0)
800017a8:	0540006f          	j	800017fc <_vsnprintf+0x180>
800017ac:	fec42783          	lw	a5,-20(s0)
800017b0:	0087e793          	ori	a5,a5,8
800017b4:	fef42623          	sw	a5,-20(s0)
800017b8:	fa042783          	lw	a5,-96(s0)
800017bc:	00178793          	addi	a5,a5,1
800017c0:	faf42023          	sw	a5,-96(s0)
800017c4:	00100793          	li	a5,1
800017c8:	fef42023          	sw	a5,-32(s0)
800017cc:	0300006f          	j	800017fc <_vsnprintf+0x180>
800017d0:	fec42783          	lw	a5,-20(s0)
800017d4:	0107e793          	ori	a5,a5,16
800017d8:	fef42623          	sw	a5,-20(s0)
800017dc:	fa042783          	lw	a5,-96(s0)
800017e0:	00178793          	addi	a5,a5,1
800017e4:	faf42023          	sw	a5,-96(s0)
800017e8:	00100793          	li	a5,1
800017ec:	fef42023          	sw	a5,-32(s0)
800017f0:	00c0006f          	j	800017fc <_vsnprintf+0x180>
800017f4:	fe042023          	sw	zero,-32(s0)
800017f8:	00000013          	nop
800017fc:	fe042783          	lw	a5,-32(s0)
80001800:	f0079ae3          	bnez	a5,80001714 <_vsnprintf+0x98>
80001804:	fe042423          	sw	zero,-24(s0)
80001808:	fa042783          	lw	a5,-96(s0)
8000180c:	0007c783          	lbu	a5,0(a5)
80001810:	00078513          	mv	a0,a5
80001814:	ffcff0ef          	jal	ra,80001010 <_is_digit>
80001818:	00050793          	mv	a5,a0
8000181c:	00078c63          	beqz	a5,80001834 <_vsnprintf+0x1b8>
80001820:	fa040793          	addi	a5,s0,-96
80001824:	00078513          	mv	a0,a5
80001828:	839ff0ef          	jal	ra,80001060 <_atoi>
8000182c:	fea42423          	sw	a0,-24(s0)
80001830:	0600006f          	j	80001890 <_vsnprintf+0x214>
80001834:	fa042783          	lw	a5,-96(s0)
80001838:	0007c703          	lbu	a4,0(a5)
8000183c:	02a00793          	li	a5,42
80001840:	04f71863          	bne	a4,a5,80001890 <_vsnprintf+0x214>
80001844:	f9c42783          	lw	a5,-100(s0)
80001848:	00478713          	addi	a4,a5,4
8000184c:	f8e42e23          	sw	a4,-100(s0)
80001850:	0007a783          	lw	a5,0(a5)
80001854:	fcf42423          	sw	a5,-56(s0)
80001858:	fc842783          	lw	a5,-56(s0)
8000185c:	0207d063          	bgez	a5,8000187c <_vsnprintf+0x200>
80001860:	fec42783          	lw	a5,-20(s0)
80001864:	0027e793          	ori	a5,a5,2
80001868:	fef42623          	sw	a5,-20(s0)
8000186c:	fc842783          	lw	a5,-56(s0)
80001870:	40f007b3          	neg	a5,a5
80001874:	fef42423          	sw	a5,-24(s0)
80001878:	00c0006f          	j	80001884 <_vsnprintf+0x208>
8000187c:	fc842783          	lw	a5,-56(s0)
80001880:	fef42423          	sw	a5,-24(s0)
80001884:	fa042783          	lw	a5,-96(s0)
80001888:	00178793          	addi	a5,a5,1
8000188c:	faf42023          	sw	a5,-96(s0)
80001890:	fe042223          	sw	zero,-28(s0)
80001894:	fa042783          	lw	a5,-96(s0)
80001898:	0007c703          	lbu	a4,0(a5)
8000189c:	02e00793          	li	a5,46
800018a0:	08f71463          	bne	a4,a5,80001928 <_vsnprintf+0x2ac>
800018a4:	fec42783          	lw	a5,-20(s0)
800018a8:	4007e793          	ori	a5,a5,1024
800018ac:	fef42623          	sw	a5,-20(s0)
800018b0:	fa042783          	lw	a5,-96(s0)
800018b4:	00178793          	addi	a5,a5,1
800018b8:	faf42023          	sw	a5,-96(s0)
800018bc:	fa042783          	lw	a5,-96(s0)
800018c0:	0007c783          	lbu	a5,0(a5)
800018c4:	00078513          	mv	a0,a5
800018c8:	f48ff0ef          	jal	ra,80001010 <_is_digit>
800018cc:	00050793          	mv	a5,a0
800018d0:	00078c63          	beqz	a5,800018e8 <_vsnprintf+0x26c>
800018d4:	fa040793          	addi	a5,s0,-96
800018d8:	00078513          	mv	a0,a5
800018dc:	f84ff0ef          	jal	ra,80001060 <_atoi>
800018e0:	fea42223          	sw	a0,-28(s0)
800018e4:	0440006f          	j	80001928 <_vsnprintf+0x2ac>
800018e8:	fa042783          	lw	a5,-96(s0)
800018ec:	0007c703          	lbu	a4,0(a5)
800018f0:	02a00793          	li	a5,42
800018f4:	02f71a63          	bne	a4,a5,80001928 <_vsnprintf+0x2ac>
800018f8:	f9c42783          	lw	a5,-100(s0)
800018fc:	00478713          	addi	a4,a5,4
80001900:	f8e42e23          	sw	a4,-100(s0)
80001904:	0007a783          	lw	a5,0(a5)
80001908:	fcf42223          	sw	a5,-60(s0)
8000190c:	fc442783          	lw	a5,-60(s0)
80001910:	0007d463          	bgez	a5,80001918 <_vsnprintf+0x29c>
80001914:	00000793          	li	a5,0
80001918:	fef42223          	sw	a5,-28(s0)
8000191c:	fa042783          	lw	a5,-96(s0)
80001920:	00178793          	addi	a5,a5,1
80001924:	faf42023          	sw	a5,-96(s0)
80001928:	fa042783          	lw	a5,-96(s0)
8000192c:	0007c783          	lbu	a5,0(a5)
80001930:	f9878793          	addi	a5,a5,-104
80001934:	01200713          	li	a4,18
80001938:	0ef76c63          	bltu	a4,a5,80001a30 <_vsnprintf+0x3b4>
8000193c:	00279713          	slli	a4,a5,0x2
80001940:	8000b7b7          	lui	a5,0x8000b
80001944:	6f078793          	addi	a5,a5,1776 # 8000b6f0 <_bss_end+0xffe49100>
80001948:	00f707b3          	add	a5,a4,a5
8000194c:	0007a783          	lw	a5,0(a5)
80001950:	00078067          	jr	a5
80001954:	fec42783          	lw	a5,-20(s0)
80001958:	1007e793          	ori	a5,a5,256
8000195c:	fef42623          	sw	a5,-20(s0)
80001960:	fa042783          	lw	a5,-96(s0)
80001964:	00178793          	addi	a5,a5,1
80001968:	faf42023          	sw	a5,-96(s0)
8000196c:	fa042783          	lw	a5,-96(s0)
80001970:	0007c703          	lbu	a4,0(a5)
80001974:	06c00793          	li	a5,108
80001978:	0cf71063          	bne	a4,a5,80001a38 <_vsnprintf+0x3bc>
8000197c:	fec42783          	lw	a5,-20(s0)
80001980:	2007e793          	ori	a5,a5,512
80001984:	fef42623          	sw	a5,-20(s0)
80001988:	fa042783          	lw	a5,-96(s0)
8000198c:	00178793          	addi	a5,a5,1
80001990:	faf42023          	sw	a5,-96(s0)
80001994:	0a40006f          	j	80001a38 <_vsnprintf+0x3bc>
80001998:	fec42783          	lw	a5,-20(s0)
8000199c:	0807e793          	ori	a5,a5,128
800019a0:	fef42623          	sw	a5,-20(s0)
800019a4:	fa042783          	lw	a5,-96(s0)
800019a8:	00178793          	addi	a5,a5,1
800019ac:	faf42023          	sw	a5,-96(s0)
800019b0:	fa042783          	lw	a5,-96(s0)
800019b4:	0007c703          	lbu	a4,0(a5)
800019b8:	06800793          	li	a5,104
800019bc:	08f71263          	bne	a4,a5,80001a40 <_vsnprintf+0x3c4>
800019c0:	fec42783          	lw	a5,-20(s0)
800019c4:	0407e793          	ori	a5,a5,64
800019c8:	fef42623          	sw	a5,-20(s0)
800019cc:	fa042783          	lw	a5,-96(s0)
800019d0:	00178793          	addi	a5,a5,1
800019d4:	faf42023          	sw	a5,-96(s0)
800019d8:	0680006f          	j	80001a40 <_vsnprintf+0x3c4>
800019dc:	fec42783          	lw	a5,-20(s0)
800019e0:	1007e793          	ori	a5,a5,256
800019e4:	fef42623          	sw	a5,-20(s0)
800019e8:	fa042783          	lw	a5,-96(s0)
800019ec:	00178793          	addi	a5,a5,1
800019f0:	faf42023          	sw	a5,-96(s0)
800019f4:	0500006f          	j	80001a44 <_vsnprintf+0x3c8>
800019f8:	fec42783          	lw	a5,-20(s0)
800019fc:	1007e793          	ori	a5,a5,256
80001a00:	fef42623          	sw	a5,-20(s0)
80001a04:	fa042783          	lw	a5,-96(s0)
80001a08:	00178793          	addi	a5,a5,1
80001a0c:	faf42023          	sw	a5,-96(s0)
80001a10:	0340006f          	j	80001a44 <_vsnprintf+0x3c8>
80001a14:	fec42783          	lw	a5,-20(s0)
80001a18:	1007e793          	ori	a5,a5,256
80001a1c:	fef42623          	sw	a5,-20(s0)
80001a20:	fa042783          	lw	a5,-96(s0)
80001a24:	00178793          	addi	a5,a5,1
80001a28:	faf42023          	sw	a5,-96(s0)
80001a2c:	0180006f          	j	80001a44 <_vsnprintf+0x3c8>
80001a30:	00000013          	nop
80001a34:	0100006f          	j	80001a44 <_vsnprintf+0x3c8>
80001a38:	00000013          	nop
80001a3c:	0080006f          	j	80001a44 <_vsnprintf+0x3c8>
80001a40:	00000013          	nop
80001a44:	fa042783          	lw	a5,-96(s0)
80001a48:	0007c783          	lbu	a5,0(a5)
80001a4c:	fdb78793          	addi	a5,a5,-37
80001a50:	05300713          	li	a4,83
80001a54:	62f76c63          	bltu	a4,a5,8000208c <_vsnprintf+0xa10>
80001a58:	00279713          	slli	a4,a5,0x2
80001a5c:	8000b7b7          	lui	a5,0x8000b
80001a60:	73c78793          	addi	a5,a5,1852 # 8000b73c <_bss_end+0xffe4914c>
80001a64:	00f707b3          	add	a5,a4,a5
80001a68:	0007a783          	lw	a5,0(a5)
80001a6c:	00078067          	jr	a5
80001a70:	fa042783          	lw	a5,-96(s0)
80001a74:	0007c703          	lbu	a4,0(a5)
80001a78:	07800793          	li	a5,120
80001a7c:	00f70a63          	beq	a4,a5,80001a90 <_vsnprintf+0x414>
80001a80:	fa042783          	lw	a5,-96(s0)
80001a84:	0007c703          	lbu	a4,0(a5)
80001a88:	05800793          	li	a5,88
80001a8c:	00f71863          	bne	a4,a5,80001a9c <_vsnprintf+0x420>
80001a90:	01000793          	li	a5,16
80001a94:	fcf42c23          	sw	a5,-40(s0)
80001a98:	0500006f          	j	80001ae8 <_vsnprintf+0x46c>
80001a9c:	fa042783          	lw	a5,-96(s0)
80001aa0:	0007c703          	lbu	a4,0(a5)
80001aa4:	06f00793          	li	a5,111
80001aa8:	00f71863          	bne	a4,a5,80001ab8 <_vsnprintf+0x43c>
80001aac:	00800793          	li	a5,8
80001ab0:	fcf42c23          	sw	a5,-40(s0)
80001ab4:	0340006f          	j	80001ae8 <_vsnprintf+0x46c>
80001ab8:	fa042783          	lw	a5,-96(s0)
80001abc:	0007c703          	lbu	a4,0(a5)
80001ac0:	06200793          	li	a5,98
80001ac4:	00f71863          	bne	a4,a5,80001ad4 <_vsnprintf+0x458>
80001ac8:	00200793          	li	a5,2
80001acc:	fcf42c23          	sw	a5,-40(s0)
80001ad0:	0180006f          	j	80001ae8 <_vsnprintf+0x46c>
80001ad4:	00a00793          	li	a5,10
80001ad8:	fcf42c23          	sw	a5,-40(s0)
80001adc:	fec42783          	lw	a5,-20(s0)
80001ae0:	fef7f793          	andi	a5,a5,-17
80001ae4:	fef42623          	sw	a5,-20(s0)
80001ae8:	fa042783          	lw	a5,-96(s0)
80001aec:	0007c703          	lbu	a4,0(a5)
80001af0:	05800793          	li	a5,88
80001af4:	00f71863          	bne	a4,a5,80001b04 <_vsnprintf+0x488>
80001af8:	fec42783          	lw	a5,-20(s0)
80001afc:	0207e793          	ori	a5,a5,32
80001b00:	fef42623          	sw	a5,-20(s0)
80001b04:	fa042783          	lw	a5,-96(s0)
80001b08:	0007c703          	lbu	a4,0(a5)
80001b0c:	06900793          	li	a5,105
80001b10:	02f70063          	beq	a4,a5,80001b30 <_vsnprintf+0x4b4>
80001b14:	fa042783          	lw	a5,-96(s0)
80001b18:	0007c703          	lbu	a4,0(a5)
80001b1c:	06400793          	li	a5,100
80001b20:	00f70863          	beq	a4,a5,80001b30 <_vsnprintf+0x4b4>
80001b24:	fec42783          	lw	a5,-20(s0)
80001b28:	ff37f793          	andi	a5,a5,-13
80001b2c:	fef42623          	sw	a5,-20(s0)
80001b30:	fec42783          	lw	a5,-20(s0)
80001b34:	4007f793          	andi	a5,a5,1024
80001b38:	00078863          	beqz	a5,80001b48 <_vsnprintf+0x4cc>
80001b3c:	fec42783          	lw	a5,-20(s0)
80001b40:	ffe7f793          	andi	a5,a5,-2
80001b44:	fef42623          	sw	a5,-20(s0)
80001b48:	fa042783          	lw	a5,-96(s0)
80001b4c:	0007c703          	lbu	a4,0(a5)
80001b50:	06900793          	li	a5,105
80001b54:	00f70a63          	beq	a4,a5,80001b68 <_vsnprintf+0x4ec>
80001b58:	fa042783          	lw	a5,-96(s0)
80001b5c:	0007c703          	lbu	a4,0(a5)
80001b60:	06400793          	li	a5,100
80001b64:	14f71863          	bne	a4,a5,80001cb4 <_vsnprintf+0x638>
80001b68:	fec42783          	lw	a5,-20(s0)
80001b6c:	2007f793          	andi	a5,a5,512
80001b70:	22079e63          	bnez	a5,80001dac <_vsnprintf+0x730>
80001b74:	fec42783          	lw	a5,-20(s0)
80001b78:	1007f793          	andi	a5,a5,256
80001b7c:	06078c63          	beqz	a5,80001bf4 <_vsnprintf+0x578>
80001b80:	f9c42783          	lw	a5,-100(s0)
80001b84:	00478713          	addi	a4,a5,4
80001b88:	f8e42e23          	sw	a4,-100(s0)
80001b8c:	0007a783          	lw	a5,0(a5)
80001b90:	faf42c23          	sw	a5,-72(s0)
80001b94:	fb842783          	lw	a5,-72(s0)
80001b98:	41f7d713          	srai	a4,a5,0x1f
80001b9c:	fb842783          	lw	a5,-72(s0)
80001ba0:	00f747b3          	xor	a5,a4,a5
80001ba4:	40e787b3          	sub	a5,a5,a4
80001ba8:	00078693          	mv	a3,a5
80001bac:	fb842783          	lw	a5,-72(s0)
80001bb0:	01f7d793          	srli	a5,a5,0x1f
80001bb4:	0ff7f713          	andi	a4,a5,255
80001bb8:	fec42783          	lw	a5,-20(s0)
80001bbc:	00f12223          	sw	a5,4(sp)
80001bc0:	fe842783          	lw	a5,-24(s0)
80001bc4:	00f12023          	sw	a5,0(sp)
80001bc8:	fe442883          	lw	a7,-28(s0)
80001bcc:	fd842803          	lw	a6,-40(s0)
80001bd0:	00070793          	mv	a5,a4
80001bd4:	00068713          	mv	a4,a3
80001bd8:	fa442683          	lw	a3,-92(s0)
80001bdc:	fdc42603          	lw	a2,-36(s0)
80001be0:	fa842583          	lw	a1,-88(s0)
80001be4:	fac42503          	lw	a0,-84(s0)
80001be8:	941ff0ef          	jal	ra,80001528 <_ntoa_long>
80001bec:	fca42e23          	sw	a0,-36(s0)
80001bf0:	1bc0006f          	j	80001dac <_vsnprintf+0x730>
80001bf4:	fec42783          	lw	a5,-20(s0)
80001bf8:	0407f793          	andi	a5,a5,64
80001bfc:	00078e63          	beqz	a5,80001c18 <_vsnprintf+0x59c>
80001c00:	f9c42783          	lw	a5,-100(s0)
80001c04:	00478713          	addi	a4,a5,4
80001c08:	f8e42e23          	sw	a4,-100(s0)
80001c0c:	0007a783          	lw	a5,0(a5)
80001c10:	0ff7f793          	andi	a5,a5,255
80001c14:	03c0006f          	j	80001c50 <_vsnprintf+0x5d4>
80001c18:	fec42783          	lw	a5,-20(s0)
80001c1c:	0807f793          	andi	a5,a5,128
80001c20:	02078063          	beqz	a5,80001c40 <_vsnprintf+0x5c4>
80001c24:	f9c42783          	lw	a5,-100(s0)
80001c28:	00478713          	addi	a4,a5,4
80001c2c:	f8e42e23          	sw	a4,-100(s0)
80001c30:	0007a783          	lw	a5,0(a5)
80001c34:	01079793          	slli	a5,a5,0x10
80001c38:	4107d793          	srai	a5,a5,0x10
80001c3c:	0140006f          	j	80001c50 <_vsnprintf+0x5d4>
80001c40:	f9c42783          	lw	a5,-100(s0)
80001c44:	00478713          	addi	a4,a5,4
80001c48:	f8e42e23          	sw	a4,-100(s0)
80001c4c:	0007a783          	lw	a5,0(a5)
80001c50:	faf42e23          	sw	a5,-68(s0)
80001c54:	fbc42783          	lw	a5,-68(s0)
80001c58:	41f7d713          	srai	a4,a5,0x1f
80001c5c:	fbc42783          	lw	a5,-68(s0)
80001c60:	00f747b3          	xor	a5,a4,a5
80001c64:	40e787b3          	sub	a5,a5,a4
80001c68:	00078693          	mv	a3,a5
80001c6c:	fbc42783          	lw	a5,-68(s0)
80001c70:	01f7d793          	srli	a5,a5,0x1f
80001c74:	0ff7f713          	andi	a4,a5,255
80001c78:	fec42783          	lw	a5,-20(s0)
80001c7c:	00f12223          	sw	a5,4(sp)
80001c80:	fe842783          	lw	a5,-24(s0)
80001c84:	00f12023          	sw	a5,0(sp)
80001c88:	fe442883          	lw	a7,-28(s0)
80001c8c:	fd842803          	lw	a6,-40(s0)
80001c90:	00070793          	mv	a5,a4
80001c94:	00068713          	mv	a4,a3
80001c98:	fa442683          	lw	a3,-92(s0)
80001c9c:	fdc42603          	lw	a2,-36(s0)
80001ca0:	fa842583          	lw	a1,-88(s0)
80001ca4:	fac42503          	lw	a0,-84(s0)
80001ca8:	881ff0ef          	jal	ra,80001528 <_ntoa_long>
80001cac:	fca42e23          	sw	a0,-36(s0)
80001cb0:	0fc0006f          	j	80001dac <_vsnprintf+0x730>
80001cb4:	fec42783          	lw	a5,-20(s0)
80001cb8:	2007f793          	andi	a5,a5,512
80001cbc:	0e079863          	bnez	a5,80001dac <_vsnprintf+0x730>
80001cc0:	fec42783          	lw	a5,-20(s0)
80001cc4:	1007f793          	andi	a5,a5,256
80001cc8:	04078663          	beqz	a5,80001d14 <_vsnprintf+0x698>
80001ccc:	f9c42783          	lw	a5,-100(s0)
80001cd0:	00478713          	addi	a4,a5,4
80001cd4:	f8e42e23          	sw	a4,-100(s0)
80001cd8:	0007a703          	lw	a4,0(a5)
80001cdc:	fec42783          	lw	a5,-20(s0)
80001ce0:	00f12223          	sw	a5,4(sp)
80001ce4:	fe842783          	lw	a5,-24(s0)
80001ce8:	00f12023          	sw	a5,0(sp)
80001cec:	fe442883          	lw	a7,-28(s0)
80001cf0:	fd842803          	lw	a6,-40(s0)
80001cf4:	00000793          	li	a5,0
80001cf8:	fa442683          	lw	a3,-92(s0)
80001cfc:	fdc42603          	lw	a2,-36(s0)
80001d00:	fa842583          	lw	a1,-88(s0)
80001d04:	fac42503          	lw	a0,-84(s0)
80001d08:	821ff0ef          	jal	ra,80001528 <_ntoa_long>
80001d0c:	fca42e23          	sw	a0,-36(s0)
80001d10:	09c0006f          	j	80001dac <_vsnprintf+0x730>
80001d14:	fec42783          	lw	a5,-20(s0)
80001d18:	0407f793          	andi	a5,a5,64
80001d1c:	00078e63          	beqz	a5,80001d38 <_vsnprintf+0x6bc>
80001d20:	f9c42783          	lw	a5,-100(s0)
80001d24:	00478713          	addi	a4,a5,4
80001d28:	f8e42e23          	sw	a4,-100(s0)
80001d2c:	0007a783          	lw	a5,0(a5)
80001d30:	0ff7f793          	andi	a5,a5,255
80001d34:	03c0006f          	j	80001d70 <_vsnprintf+0x6f4>
80001d38:	fec42783          	lw	a5,-20(s0)
80001d3c:	0807f793          	andi	a5,a5,128
80001d40:	02078063          	beqz	a5,80001d60 <_vsnprintf+0x6e4>
80001d44:	f9c42783          	lw	a5,-100(s0)
80001d48:	00478713          	addi	a4,a5,4
80001d4c:	f8e42e23          	sw	a4,-100(s0)
80001d50:	0007a783          	lw	a5,0(a5)
80001d54:	01079793          	slli	a5,a5,0x10
80001d58:	0107d793          	srli	a5,a5,0x10
80001d5c:	0140006f          	j	80001d70 <_vsnprintf+0x6f4>
80001d60:	f9c42783          	lw	a5,-100(s0)
80001d64:	00478713          	addi	a4,a5,4
80001d68:	f8e42e23          	sw	a4,-100(s0)
80001d6c:	0007a783          	lw	a5,0(a5)
80001d70:	fcf42023          	sw	a5,-64(s0)
80001d74:	fec42783          	lw	a5,-20(s0)
80001d78:	00f12223          	sw	a5,4(sp)
80001d7c:	fe842783          	lw	a5,-24(s0)
80001d80:	00f12023          	sw	a5,0(sp)
80001d84:	fe442883          	lw	a7,-28(s0)
80001d88:	fd842803          	lw	a6,-40(s0)
80001d8c:	00000793          	li	a5,0
80001d90:	fc042703          	lw	a4,-64(s0)
80001d94:	fa442683          	lw	a3,-92(s0)
80001d98:	fdc42603          	lw	a2,-36(s0)
80001d9c:	fa842583          	lw	a1,-88(s0)
80001da0:	fac42503          	lw	a0,-84(s0)
80001da4:	f84ff0ef          	jal	ra,80001528 <_ntoa_long>
80001da8:	fca42e23          	sw	a0,-36(s0)
80001dac:	fa042783          	lw	a5,-96(s0)
80001db0:	00178793          	addi	a5,a5,1
80001db4:	faf42023          	sw	a5,-96(s0)
80001db8:	30c0006f          	j	800020c4 <_vsnprintf+0xa48>
80001dbc:	00100793          	li	a5,1
80001dc0:	fcf42a23          	sw	a5,-44(s0)
80001dc4:	fec42783          	lw	a5,-20(s0)
80001dc8:	0027f793          	andi	a5,a5,2
80001dcc:	04079063          	bnez	a5,80001e0c <_vsnprintf+0x790>
80001dd0:	0280006f          	j	80001df8 <_vsnprintf+0x77c>
80001dd4:	fdc42783          	lw	a5,-36(s0)
80001dd8:	00178713          	addi	a4,a5,1
80001ddc:	fce42e23          	sw	a4,-36(s0)
80001de0:	fac42703          	lw	a4,-84(s0)
80001de4:	fa442683          	lw	a3,-92(s0)
80001de8:	00078613          	mv	a2,a5
80001dec:	fa842583          	lw	a1,-88(s0)
80001df0:	02000513          	li	a0,32
80001df4:	000700e7          	jalr	a4
80001df8:	fd442783          	lw	a5,-44(s0)
80001dfc:	00178713          	addi	a4,a5,1
80001e00:	fce42a23          	sw	a4,-44(s0)
80001e04:	fe842703          	lw	a4,-24(s0)
80001e08:	fce7e6e3          	bltu	a5,a4,80001dd4 <_vsnprintf+0x758>
80001e0c:	f9c42783          	lw	a5,-100(s0)
80001e10:	00478713          	addi	a4,a5,4
80001e14:	f8e42e23          	sw	a4,-100(s0)
80001e18:	0007a783          	lw	a5,0(a5)
80001e1c:	0ff7f513          	andi	a0,a5,255
80001e20:	fdc42783          	lw	a5,-36(s0)
80001e24:	00178713          	addi	a4,a5,1
80001e28:	fce42e23          	sw	a4,-36(s0)
80001e2c:	fac42703          	lw	a4,-84(s0)
80001e30:	fa442683          	lw	a3,-92(s0)
80001e34:	00078613          	mv	a2,a5
80001e38:	fa842583          	lw	a1,-88(s0)
80001e3c:	000700e7          	jalr	a4
80001e40:	fec42783          	lw	a5,-20(s0)
80001e44:	0027f793          	andi	a5,a5,2
80001e48:	04078063          	beqz	a5,80001e88 <_vsnprintf+0x80c>
80001e4c:	0280006f          	j	80001e74 <_vsnprintf+0x7f8>
80001e50:	fdc42783          	lw	a5,-36(s0)
80001e54:	00178713          	addi	a4,a5,1
80001e58:	fce42e23          	sw	a4,-36(s0)
80001e5c:	fac42703          	lw	a4,-84(s0)
80001e60:	fa442683          	lw	a3,-92(s0)
80001e64:	00078613          	mv	a2,a5
80001e68:	fa842583          	lw	a1,-88(s0)
80001e6c:	02000513          	li	a0,32
80001e70:	000700e7          	jalr	a4
80001e74:	fd442783          	lw	a5,-44(s0)
80001e78:	00178713          	addi	a4,a5,1
80001e7c:	fce42a23          	sw	a4,-44(s0)
80001e80:	fe842703          	lw	a4,-24(s0)
80001e84:	fce7e6e3          	bltu	a5,a4,80001e50 <_vsnprintf+0x7d4>
80001e88:	fa042783          	lw	a5,-96(s0)
80001e8c:	00178793          	addi	a5,a5,1
80001e90:	faf42023          	sw	a5,-96(s0)
80001e94:	2300006f          	j	800020c4 <_vsnprintf+0xa48>
80001e98:	f9c42783          	lw	a5,-100(s0)
80001e9c:	00478713          	addi	a4,a5,4
80001ea0:	f8e42e23          	sw	a4,-100(s0)
80001ea4:	0007a783          	lw	a5,0(a5)
80001ea8:	fcf42823          	sw	a5,-48(s0)
80001eac:	fe442783          	lw	a5,-28(s0)
80001eb0:	00078663          	beqz	a5,80001ebc <_vsnprintf+0x840>
80001eb4:	fe442783          	lw	a5,-28(s0)
80001eb8:	0080006f          	j	80001ec0 <_vsnprintf+0x844>
80001ebc:	fff00793          	li	a5,-1
80001ec0:	00078593          	mv	a1,a5
80001ec4:	fd042503          	lw	a0,-48(s0)
80001ec8:	8e4ff0ef          	jal	ra,80000fac <_strnlen_s>
80001ecc:	fca42623          	sw	a0,-52(s0)
80001ed0:	fec42783          	lw	a5,-20(s0)
80001ed4:	4007f793          	andi	a5,a5,1024
80001ed8:	00078c63          	beqz	a5,80001ef0 <_vsnprintf+0x874>
80001edc:	fcc42703          	lw	a4,-52(s0)
80001ee0:	fe442783          	lw	a5,-28(s0)
80001ee4:	00f77463          	bgeu	a4,a5,80001eec <_vsnprintf+0x870>
80001ee8:	00070793          	mv	a5,a4
80001eec:	fcf42623          	sw	a5,-52(s0)
80001ef0:	fec42783          	lw	a5,-20(s0)
80001ef4:	0027f793          	andi	a5,a5,2
80001ef8:	06079a63          	bnez	a5,80001f6c <_vsnprintf+0x8f0>
80001efc:	0280006f          	j	80001f24 <_vsnprintf+0x8a8>
80001f00:	fdc42783          	lw	a5,-36(s0)
80001f04:	00178713          	addi	a4,a5,1
80001f08:	fce42e23          	sw	a4,-36(s0)
80001f0c:	fac42703          	lw	a4,-84(s0)
80001f10:	fa442683          	lw	a3,-92(s0)
80001f14:	00078613          	mv	a2,a5
80001f18:	fa842583          	lw	a1,-88(s0)
80001f1c:	02000513          	li	a0,32
80001f20:	000700e7          	jalr	a4
80001f24:	fcc42783          	lw	a5,-52(s0)
80001f28:	00178713          	addi	a4,a5,1
80001f2c:	fce42623          	sw	a4,-52(s0)
80001f30:	fe842703          	lw	a4,-24(s0)
80001f34:	fce7e6e3          	bltu	a5,a4,80001f00 <_vsnprintf+0x884>
80001f38:	0340006f          	j	80001f6c <_vsnprintf+0x8f0>
80001f3c:	fd042783          	lw	a5,-48(s0)
80001f40:	00178713          	addi	a4,a5,1
80001f44:	fce42823          	sw	a4,-48(s0)
80001f48:	0007c503          	lbu	a0,0(a5)
80001f4c:	fdc42783          	lw	a5,-36(s0)
80001f50:	00178713          	addi	a4,a5,1
80001f54:	fce42e23          	sw	a4,-36(s0)
80001f58:	fac42703          	lw	a4,-84(s0)
80001f5c:	fa442683          	lw	a3,-92(s0)
80001f60:	00078613          	mv	a2,a5
80001f64:	fa842583          	lw	a1,-88(s0)
80001f68:	000700e7          	jalr	a4
80001f6c:	fd042783          	lw	a5,-48(s0)
80001f70:	0007c783          	lbu	a5,0(a5)
80001f74:	02078063          	beqz	a5,80001f94 <_vsnprintf+0x918>
80001f78:	fec42783          	lw	a5,-20(s0)
80001f7c:	4007f793          	andi	a5,a5,1024
80001f80:	fa078ee3          	beqz	a5,80001f3c <_vsnprintf+0x8c0>
80001f84:	fe442783          	lw	a5,-28(s0)
80001f88:	fff78713          	addi	a4,a5,-1
80001f8c:	fee42223          	sw	a4,-28(s0)
80001f90:	fa0796e3          	bnez	a5,80001f3c <_vsnprintf+0x8c0>
80001f94:	fec42783          	lw	a5,-20(s0)
80001f98:	0027f793          	andi	a5,a5,2
80001f9c:	04078063          	beqz	a5,80001fdc <_vsnprintf+0x960>
80001fa0:	0280006f          	j	80001fc8 <_vsnprintf+0x94c>
80001fa4:	fdc42783          	lw	a5,-36(s0)
80001fa8:	00178713          	addi	a4,a5,1
80001fac:	fce42e23          	sw	a4,-36(s0)
80001fb0:	fac42703          	lw	a4,-84(s0)
80001fb4:	fa442683          	lw	a3,-92(s0)
80001fb8:	00078613          	mv	a2,a5
80001fbc:	fa842583          	lw	a1,-88(s0)
80001fc0:	02000513          	li	a0,32
80001fc4:	000700e7          	jalr	a4
80001fc8:	fcc42783          	lw	a5,-52(s0)
80001fcc:	00178713          	addi	a4,a5,1
80001fd0:	fce42623          	sw	a4,-52(s0)
80001fd4:	fe842703          	lw	a4,-24(s0)
80001fd8:	fce7e6e3          	bltu	a5,a4,80001fa4 <_vsnprintf+0x928>
80001fdc:	fa042783          	lw	a5,-96(s0)
80001fe0:	00178793          	addi	a5,a5,1
80001fe4:	faf42023          	sw	a5,-96(s0)
80001fe8:	0dc0006f          	j	800020c4 <_vsnprintf+0xa48>
80001fec:	00800793          	li	a5,8
80001ff0:	fef42423          	sw	a5,-24(s0)
80001ff4:	fec42783          	lw	a5,-20(s0)
80001ff8:	0217e793          	ori	a5,a5,33
80001ffc:	fef42623          	sw	a5,-20(s0)
80002000:	f9c42783          	lw	a5,-100(s0)
80002004:	00478713          	addi	a4,a5,4
80002008:	f8e42e23          	sw	a4,-100(s0)
8000200c:	0007a783          	lw	a5,0(a5)
80002010:	00078713          	mv	a4,a5
80002014:	fec42783          	lw	a5,-20(s0)
80002018:	00f12223          	sw	a5,4(sp)
8000201c:	fe842783          	lw	a5,-24(s0)
80002020:	00f12023          	sw	a5,0(sp)
80002024:	fe442883          	lw	a7,-28(s0)
80002028:	01000813          	li	a6,16
8000202c:	00000793          	li	a5,0
80002030:	fa442683          	lw	a3,-92(s0)
80002034:	fdc42603          	lw	a2,-36(s0)
80002038:	fa842583          	lw	a1,-88(s0)
8000203c:	fac42503          	lw	a0,-84(s0)
80002040:	ce8ff0ef          	jal	ra,80001528 <_ntoa_long>
80002044:	fca42e23          	sw	a0,-36(s0)
80002048:	fa042783          	lw	a5,-96(s0)
8000204c:	00178793          	addi	a5,a5,1
80002050:	faf42023          	sw	a5,-96(s0)
80002054:	0700006f          	j	800020c4 <_vsnprintf+0xa48>
80002058:	fdc42783          	lw	a5,-36(s0)
8000205c:	00178713          	addi	a4,a5,1
80002060:	fce42e23          	sw	a4,-36(s0)
80002064:	fac42703          	lw	a4,-84(s0)
80002068:	fa442683          	lw	a3,-92(s0)
8000206c:	00078613          	mv	a2,a5
80002070:	fa842583          	lw	a1,-88(s0)
80002074:	02500513          	li	a0,37
80002078:	000700e7          	jalr	a4
8000207c:	fa042783          	lw	a5,-96(s0)
80002080:	00178793          	addi	a5,a5,1
80002084:	faf42023          	sw	a5,-96(s0)
80002088:	03c0006f          	j	800020c4 <_vsnprintf+0xa48>
8000208c:	fa042783          	lw	a5,-96(s0)
80002090:	0007c503          	lbu	a0,0(a5)
80002094:	fdc42783          	lw	a5,-36(s0)
80002098:	00178713          	addi	a4,a5,1
8000209c:	fce42e23          	sw	a4,-36(s0)
800020a0:	fac42703          	lw	a4,-84(s0)
800020a4:	fa442683          	lw	a3,-92(s0)
800020a8:	00078613          	mv	a2,a5
800020ac:	fa842583          	lw	a1,-88(s0)
800020b0:	000700e7          	jalr	a4
800020b4:	fa042783          	lw	a5,-96(s0)
800020b8:	00178793          	addi	a5,a5,1
800020bc:	faf42023          	sw	a5,-96(s0)
800020c0:	00000013          	nop
800020c4:	fa042783          	lw	a5,-96(s0)
800020c8:	0007c783          	lbu	a5,0(a5)
800020cc:	de079863          	bnez	a5,800016bc <_vsnprintf+0x40>
800020d0:	fdc42703          	lw	a4,-36(s0)
800020d4:	fa442783          	lw	a5,-92(s0)
800020d8:	00f76863          	bltu	a4,a5,800020e8 <_vsnprintf+0xa6c>
800020dc:	fa442783          	lw	a5,-92(s0)
800020e0:	fff78793          	addi	a5,a5,-1
800020e4:	0080006f          	j	800020ec <_vsnprintf+0xa70>
800020e8:	fdc42783          	lw	a5,-36(s0)
800020ec:	fac42703          	lw	a4,-84(s0)
800020f0:	fa442683          	lw	a3,-92(s0)
800020f4:	00078613          	mv	a2,a5
800020f8:	fa842583          	lw	a1,-88(s0)
800020fc:	00000513          	li	a0,0
80002100:	000700e7          	jalr	a4
80002104:	fdc42783          	lw	a5,-36(s0)
80002108:	00078513          	mv	a0,a5
8000210c:	07c12083          	lw	ra,124(sp)
80002110:	07812403          	lw	s0,120(sp)
80002114:	08010113          	addi	sp,sp,128
80002118:	00008067          	ret

8000211c <printf_>:
8000211c:	fb010113          	addi	sp,sp,-80
80002120:	02112623          	sw	ra,44(sp)
80002124:	02812423          	sw	s0,40(sp)
80002128:	03010413          	addi	s0,sp,48
8000212c:	fca42e23          	sw	a0,-36(s0)
80002130:	00b42223          	sw	a1,4(s0)
80002134:	00c42423          	sw	a2,8(s0)
80002138:	00d42623          	sw	a3,12(s0)
8000213c:	00e42823          	sw	a4,16(s0)
80002140:	00f42a23          	sw	a5,20(s0)
80002144:	01042c23          	sw	a6,24(s0)
80002148:	01142e23          	sw	a7,28(s0)
8000214c:	02040793          	addi	a5,s0,32
80002150:	fcf42c23          	sw	a5,-40(s0)
80002154:	fd842783          	lw	a5,-40(s0)
80002158:	fe478793          	addi	a5,a5,-28
8000215c:	fef42423          	sw	a5,-24(s0)
80002160:	fe842703          	lw	a4,-24(s0)
80002164:	fe440793          	addi	a5,s0,-28
80002168:	fdc42683          	lw	a3,-36(s0)
8000216c:	fff00613          	li	a2,-1
80002170:	00078593          	mv	a1,a5
80002174:	800017b7          	lui	a5,0x80001
80002178:	f0078513          	addi	a0,a5,-256 # 80000f00 <_bss_end+0xffe3e910>
8000217c:	d00ff0ef          	jal	ra,8000167c <_vsnprintf>
80002180:	fea42623          	sw	a0,-20(s0)
80002184:	fec42783          	lw	a5,-20(s0)
80002188:	00078513          	mv	a0,a5
8000218c:	02c12083          	lw	ra,44(sp)
80002190:	02812403          	lw	s0,40(sp)
80002194:	05010113          	addi	sp,sp,80
80002198:	00008067          	ret

8000219c <sprintf_>:
8000219c:	fb010113          	addi	sp,sp,-80
800021a0:	02112623          	sw	ra,44(sp)
800021a4:	02812423          	sw	s0,40(sp)
800021a8:	03010413          	addi	s0,sp,48
800021ac:	fca42e23          	sw	a0,-36(s0)
800021b0:	fcb42c23          	sw	a1,-40(s0)
800021b4:	00c42423          	sw	a2,8(s0)
800021b8:	00d42623          	sw	a3,12(s0)
800021bc:	00e42823          	sw	a4,16(s0)
800021c0:	00f42a23          	sw	a5,20(s0)
800021c4:	01042c23          	sw	a6,24(s0)
800021c8:	01142e23          	sw	a7,28(s0)
800021cc:	02040793          	addi	a5,s0,32
800021d0:	fcf42a23          	sw	a5,-44(s0)
800021d4:	fd442783          	lw	a5,-44(s0)
800021d8:	fe878793          	addi	a5,a5,-24
800021dc:	fef42423          	sw	a5,-24(s0)
800021e0:	fe842783          	lw	a5,-24(s0)
800021e4:	00078713          	mv	a4,a5
800021e8:	fd842683          	lw	a3,-40(s0)
800021ec:	fff00613          	li	a2,-1
800021f0:	fdc42583          	lw	a1,-36(s0)
800021f4:	800017b7          	lui	a5,0x80001
800021f8:	e8078513          	addi	a0,a5,-384 # 80000e80 <_bss_end+0xffe3e890>
800021fc:	c80ff0ef          	jal	ra,8000167c <_vsnprintf>
80002200:	fea42623          	sw	a0,-20(s0)
80002204:	fec42783          	lw	a5,-20(s0)
80002208:	00078513          	mv	a0,a5
8000220c:	02c12083          	lw	ra,44(sp)
80002210:	02812403          	lw	s0,40(sp)
80002214:	05010113          	addi	sp,sp,80
80002218:	00008067          	ret

8000221c <snprintf_>:
8000221c:	fb010113          	addi	sp,sp,-80
80002220:	02112623          	sw	ra,44(sp)
80002224:	02812423          	sw	s0,40(sp)
80002228:	03010413          	addi	s0,sp,48
8000222c:	fca42e23          	sw	a0,-36(s0)
80002230:	fcb42c23          	sw	a1,-40(s0)
80002234:	fcc42a23          	sw	a2,-44(s0)
80002238:	00d42623          	sw	a3,12(s0)
8000223c:	00e42823          	sw	a4,16(s0)
80002240:	00f42a23          	sw	a5,20(s0)
80002244:	01042c23          	sw	a6,24(s0)
80002248:	01142e23          	sw	a7,28(s0)
8000224c:	02040793          	addi	a5,s0,32
80002250:	fcf42823          	sw	a5,-48(s0)
80002254:	fd042783          	lw	a5,-48(s0)
80002258:	fec78793          	addi	a5,a5,-20
8000225c:	fef42423          	sw	a5,-24(s0)
80002260:	fe842783          	lw	a5,-24(s0)
80002264:	00078713          	mv	a4,a5
80002268:	fd442683          	lw	a3,-44(s0)
8000226c:	fd842603          	lw	a2,-40(s0)
80002270:	fdc42583          	lw	a1,-36(s0)
80002274:	800017b7          	lui	a5,0x80001
80002278:	e8078513          	addi	a0,a5,-384 # 80000e80 <_bss_end+0xffe3e890>
8000227c:	c00ff0ef          	jal	ra,8000167c <_vsnprintf>
80002280:	fea42623          	sw	a0,-20(s0)
80002284:	fec42783          	lw	a5,-20(s0)
80002288:	00078513          	mv	a0,a5
8000228c:	02c12083          	lw	ra,44(sp)
80002290:	02812403          	lw	s0,40(sp)
80002294:	05010113          	addi	sp,sp,80
80002298:	00008067          	ret

8000229c <vprintf_>:
8000229c:	fd010113          	addi	sp,sp,-48
800022a0:	02112623          	sw	ra,44(sp)
800022a4:	02812423          	sw	s0,40(sp)
800022a8:	03010413          	addi	s0,sp,48
800022ac:	fca42e23          	sw	a0,-36(s0)
800022b0:	fcb42c23          	sw	a1,-40(s0)
800022b4:	fec40793          	addi	a5,s0,-20
800022b8:	fd842703          	lw	a4,-40(s0)
800022bc:	fdc42683          	lw	a3,-36(s0)
800022c0:	fff00613          	li	a2,-1
800022c4:	00078593          	mv	a1,a5
800022c8:	800017b7          	lui	a5,0x80001
800022cc:	f0078513          	addi	a0,a5,-256 # 80000f00 <_bss_end+0xffe3e910>
800022d0:	bacff0ef          	jal	ra,8000167c <_vsnprintf>
800022d4:	00050793          	mv	a5,a0
800022d8:	00078513          	mv	a0,a5
800022dc:	02c12083          	lw	ra,44(sp)
800022e0:	02812403          	lw	s0,40(sp)
800022e4:	03010113          	addi	sp,sp,48
800022e8:	00008067          	ret

800022ec <vsnprintf_>:
800022ec:	fe010113          	addi	sp,sp,-32
800022f0:	00112e23          	sw	ra,28(sp)
800022f4:	00812c23          	sw	s0,24(sp)
800022f8:	02010413          	addi	s0,sp,32
800022fc:	fea42623          	sw	a0,-20(s0)
80002300:	feb42423          	sw	a1,-24(s0)
80002304:	fec42223          	sw	a2,-28(s0)
80002308:	fed42023          	sw	a3,-32(s0)
8000230c:	fe042703          	lw	a4,-32(s0)
80002310:	fe442683          	lw	a3,-28(s0)
80002314:	fe842603          	lw	a2,-24(s0)
80002318:	fec42583          	lw	a1,-20(s0)
8000231c:	800017b7          	lui	a5,0x80001
80002320:	e8078513          	addi	a0,a5,-384 # 80000e80 <_bss_end+0xffe3e890>
80002324:	b58ff0ef          	jal	ra,8000167c <_vsnprintf>
80002328:	00050793          	mv	a5,a0
8000232c:	00078513          	mv	a0,a5
80002330:	01c12083          	lw	ra,28(sp)
80002334:	01812403          	lw	s0,24(sp)
80002338:	02010113          	addi	sp,sp,32
8000233c:	00008067          	ret

80002340 <fctprintf>:
80002340:	fb010113          	addi	sp,sp,-80
80002344:	02112623          	sw	ra,44(sp)
80002348:	02812423          	sw	s0,40(sp)
8000234c:	03010413          	addi	s0,sp,48
80002350:	fca42e23          	sw	a0,-36(s0)
80002354:	fcb42c23          	sw	a1,-40(s0)
80002358:	fcc42a23          	sw	a2,-44(s0)
8000235c:	00d42623          	sw	a3,12(s0)
80002360:	00e42823          	sw	a4,16(s0)
80002364:	00f42a23          	sw	a5,20(s0)
80002368:	01042c23          	sw	a6,24(s0)
8000236c:	01142e23          	sw	a7,28(s0)
80002370:	02040793          	addi	a5,s0,32
80002374:	fcf42823          	sw	a5,-48(s0)
80002378:	fd042783          	lw	a5,-48(s0)
8000237c:	fec78793          	addi	a5,a5,-20
80002380:	fef42423          	sw	a5,-24(s0)
80002384:	fdc42783          	lw	a5,-36(s0)
80002388:	fef42023          	sw	a5,-32(s0)
8000238c:	fd842783          	lw	a5,-40(s0)
80002390:	fef42223          	sw	a5,-28(s0)
80002394:	fe842703          	lw	a4,-24(s0)
80002398:	fe040793          	addi	a5,s0,-32
8000239c:	fd442683          	lw	a3,-44(s0)
800023a0:	fff00613          	li	a2,-1
800023a4:	00078593          	mv	a1,a5
800023a8:	800017b7          	lui	a5,0x80001
800023ac:	f4c78513          	addi	a0,a5,-180 # 80000f4c <_bss_end+0xffe3e95c>
800023b0:	accff0ef          	jal	ra,8000167c <_vsnprintf>
800023b4:	fea42623          	sw	a0,-20(s0)
800023b8:	fec42783          	lw	a5,-20(s0)
800023bc:	00078513          	mv	a0,a5
800023c0:	02c12083          	lw	ra,44(sp)
800023c4:	02812403          	lw	s0,40(sp)
800023c8:	05010113          	addi	sp,sp,80
800023cc:	00008067          	ret

800023d0 <init_uart>:
800023d0:	ff010113          	addi	sp,sp,-16
800023d4:	00812623          	sw	s0,12(sp)
800023d8:	01010413          	addi	s0,sp,16
800023dc:	100007b7          	lui	a5,0x10000
800023e0:	00278793          	addi	a5,a5,2 # 10000002 <_reset_vector-0x6ffffffe>
800023e4:	00700713          	li	a4,7
800023e8:	00e78023          	sb	a4,0(a5)
800023ec:	100007b7          	lui	a5,0x10000
800023f0:	00378793          	addi	a5,a5,3 # 10000003 <_reset_vector-0x6ffffffd>
800023f4:	f8000713          	li	a4,-128
800023f8:	00e78023          	sb	a4,0(a5)
800023fc:	100007b7          	lui	a5,0x10000
80002400:	00c00713          	li	a4,12
80002404:	00e78023          	sb	a4,0(a5) # 10000000 <_reset_vector-0x70000000>
80002408:	100007b7          	lui	a5,0x10000
8000240c:	00178793          	addi	a5,a5,1 # 10000001 <_reset_vector-0x6fffffff>
80002410:	00078023          	sb	zero,0(a5)
80002414:	100007b7          	lui	a5,0x10000
80002418:	00378793          	addi	a5,a5,3 # 10000003 <_reset_vector-0x6ffffffd>
8000241c:	00300713          	li	a4,3
80002420:	00e78023          	sb	a4,0(a5)
80002424:	100007b7          	lui	a5,0x10000
80002428:	00478793          	addi	a5,a5,4 # 10000004 <_reset_vector-0x6ffffffc>
8000242c:	00078023          	sb	zero,0(a5)
80002430:	00000013          	nop
80002434:	00c12403          	lw	s0,12(sp)
80002438:	01010113          	addi	sp,sp,16
8000243c:	00008067          	ret

80002440 <_putchar>:
80002440:	fe010113          	addi	sp,sp,-32
80002444:	00812e23          	sw	s0,28(sp)
80002448:	02010413          	addi	s0,sp,32
8000244c:	00050793          	mv	a5,a0
80002450:	fef407a3          	sb	a5,-17(s0)
80002454:	00000013          	nop
80002458:	100007b7          	lui	a5,0x10000
8000245c:	00578793          	addi	a5,a5,5 # 10000005 <_reset_vector-0x6ffffffb>
80002460:	0007c783          	lbu	a5,0(a5)
80002464:	0ff7f793          	andi	a5,a5,255
80002468:	0207f793          	andi	a5,a5,32
8000246c:	fe0786e3          	beqz	a5,80002458 <_putchar+0x18>
80002470:	100007b7          	lui	a5,0x10000
80002474:	fef44703          	lbu	a4,-17(s0)
80002478:	00e78023          	sb	a4,0(a5) # 10000000 <_reset_vector-0x70000000>
8000247c:	00000013          	nop
80002480:	01c12403          	lw	s0,28(sp)
80002484:	02010113          	addi	sp,sp,32
80002488:	00008067          	ret

8000248c <_getchar_uart>:
8000248c:	ff010113          	addi	sp,sp,-16
80002490:	00812623          	sw	s0,12(sp)
80002494:	01010413          	addi	s0,sp,16
80002498:	00000013          	nop
8000249c:	100007b7          	lui	a5,0x10000
800024a0:	00578793          	addi	a5,a5,5 # 10000005 <_reset_vector-0x6ffffffb>
800024a4:	0007c783          	lbu	a5,0(a5)
800024a8:	0ff7f793          	andi	a5,a5,255
800024ac:	0017f793          	andi	a5,a5,1
800024b0:	fe0786e3          	beqz	a5,8000249c <_getchar_uart+0x10>
800024b4:	100007b7          	lui	a5,0x10000
800024b8:	0007c783          	lbu	a5,0(a5) # 10000000 <_reset_vector-0x70000000>
800024bc:	0ff7f793          	andi	a5,a5,255
800024c0:	00078513          	mv	a0,a5
800024c4:	00c12403          	lw	s0,12(sp)
800024c8:	01010113          	addi	sp,sp,16
800024cc:	00008067          	ret

800024d0 <__bswap16>:
800024d0:	fe010113          	addi	sp,sp,-32
800024d4:	00812e23          	sw	s0,28(sp)
800024d8:	02010413          	addi	s0,sp,32
800024dc:	00050793          	mv	a5,a0
800024e0:	fef41723          	sh	a5,-18(s0)
800024e4:	fee45783          	lhu	a5,-18(s0)
800024e8:	0087d793          	srli	a5,a5,0x8
800024ec:	01079793          	slli	a5,a5,0x10
800024f0:	0107d793          	srli	a5,a5,0x10
800024f4:	01079713          	slli	a4,a5,0x10
800024f8:	41075713          	srai	a4,a4,0x10
800024fc:	fee45783          	lhu	a5,-18(s0)
80002500:	00879793          	slli	a5,a5,0x8
80002504:	01079793          	slli	a5,a5,0x10
80002508:	4107d793          	srai	a5,a5,0x10
8000250c:	f007f793          	andi	a5,a5,-256
80002510:	01079793          	slli	a5,a5,0x10
80002514:	4107d793          	srai	a5,a5,0x10
80002518:	00f767b3          	or	a5,a4,a5
8000251c:	01079793          	slli	a5,a5,0x10
80002520:	4107d793          	srai	a5,a5,0x10
80002524:	01079793          	slli	a5,a5,0x10
80002528:	0107d793          	srli	a5,a5,0x10
8000252c:	00078513          	mv	a0,a5
80002530:	01c12403          	lw	s0,28(sp)
80002534:	02010113          	addi	sp,sp,32
80002538:	00008067          	ret

8000253c <receive_ripng>:
8000253c:	eb010113          	addi	sp,sp,-336
80002540:	14112623          	sw	ra,332(sp)
80002544:	14812423          	sw	s0,328(sp)
80002548:	14912223          	sw	s1,324(sp)
8000254c:	15010413          	addi	s0,sp,336
80002550:	f0a42623          	sw	a0,-244(s0)
80002554:	f0b42423          	sw	a1,-248(s0)
80002558:	f0c42783          	lw	a5,-244(s0)
8000255c:	00e78793          	addi	a5,a5,14
80002560:	fef42023          	sw	a5,-32(s0)
80002564:	f0c42783          	lw	a5,-244(s0)
80002568:	03678793          	addi	a5,a5,54
8000256c:	fcf42e23          	sw	a5,-36(s0)
80002570:	f0c42783          	lw	a5,-244(s0)
80002574:	03e78793          	addi	a5,a5,62
80002578:	fcf42c23          	sw	a5,-40(s0)
8000257c:	f0c42783          	lw	a5,-244(s0)
80002580:	04278793          	addi	a5,a5,66
80002584:	fcf42a23          	sw	a5,-44(s0)
80002588:	f0842783          	lw	a5,-248(s0)
8000258c:	fbe78793          	addi	a5,a5,-66
80002590:	01400593          	li	a1,20
80002594:	00078513          	mv	a0,a5
80002598:	731080ef          	jal	ra,8000b4c8 <__udivsi3>
8000259c:	00050793          	mv	a5,a0
800025a0:	fcf42823          	sw	a5,-48(s0)
800025a4:	978fe0ef          	jal	ra,8000071c <dma_get_receive_port>
800025a8:	00050793          	mv	a5,a0
800025ac:	fcf407a3          	sb	a5,-49(s0)
800025b0:	fd042783          	lw	a5,-48(s0)
800025b4:	01079793          	slli	a5,a5,0x10
800025b8:	0107d793          	srli	a5,a5,0x10
800025bc:	00078713          	mv	a4,a5
800025c0:	00070793          	mv	a5,a4
800025c4:	00279793          	slli	a5,a5,0x2
800025c8:	00e787b3          	add	a5,a5,a4
800025cc:	00279793          	slli	a5,a5,0x2
800025d0:	01079793          	slli	a5,a5,0x10
800025d4:	0107d793          	srli	a5,a5,0x10
800025d8:	04278793          	addi	a5,a5,66
800025dc:	01079793          	slli	a5,a5,0x10
800025e0:	0107d793          	srli	a5,a5,0x10
800025e4:	00078613          	mv	a2,a5
800025e8:	f0842583          	lw	a1,-248(s0)
800025ec:	8000c7b7          	lui	a5,0x8000c
800025f0:	8b078513          	addi	a0,a5,-1872 # 8000b8b0 <_bss_end+0xffe492c0>
800025f4:	b29ff0ef          	jal	ra,8000211c <printf_>
800025f8:	fd042783          	lw	a5,-48(s0)
800025fc:	01079793          	slli	a5,a5,0x10
80002600:	0107d793          	srli	a5,a5,0x10
80002604:	00078713          	mv	a4,a5
80002608:	00070793          	mv	a5,a4
8000260c:	00279793          	slli	a5,a5,0x2
80002610:	00e787b3          	add	a5,a5,a4
80002614:	00279793          	slli	a5,a5,0x2
80002618:	01079793          	slli	a5,a5,0x10
8000261c:	0107d793          	srli	a5,a5,0x10
80002620:	04278793          	addi	a5,a5,66
80002624:	01079793          	slli	a5,a5,0x10
80002628:	0107d793          	srli	a5,a5,0x10
8000262c:	00078713          	mv	a4,a5
80002630:	f0842783          	lw	a5,-248(s0)
80002634:	00e78463          	beq	a5,a4,8000263c <receive_ripng+0x100>
80002638:	52c0106f          	j	80003b64 <receive_ripng+0x1628>
8000263c:	fd842783          	lw	a5,-40(s0)
80002640:	0017c703          	lbu	a4,1(a5)
80002644:	00100793          	li	a5,1
80002648:	00f70463          	beq	a4,a5,80002650 <receive_ripng+0x114>
8000264c:	5180106f          	j	80003b64 <receive_ripng+0x1628>
80002650:	fd842783          	lw	a5,-40(s0)
80002654:	0007c703          	lbu	a4,0(a5)
80002658:	00100793          	li	a5,1
8000265c:	32f71863          	bne	a4,a5,8000298c <receive_ripng+0x450>
80002660:	8000c7b7          	lui	a5,0x8000c
80002664:	8dc78513          	addi	a0,a5,-1828 # 8000b8dc <_bss_end+0xffe492ec>
80002668:	ab5ff0ef          	jal	ra,8000211c <printf_>
8000266c:	f6dfd0ef          	jal	ra,800005d8 <dma_lock_request>
80002670:	fd5fd0ef          	jal	ra,80000644 <dma_send_request>
80002674:	fd042703          	lw	a4,-48(s0)
80002678:	00100793          	li	a5,1
8000267c:	12f71463          	bne	a4,a5,800027a4 <receive_ripng+0x268>
80002680:	fd442783          	lw	a5,-44(s0)
80002684:	0007a603          	lw	a2,0(a5)
80002688:	0047a683          	lw	a3,4(a5)
8000268c:	0087a703          	lw	a4,8(a5)
80002690:	00c7a783          	lw	a5,12(a5)
80002694:	eec42823          	sw	a2,-272(s0)
80002698:	eed42a23          	sw	a3,-268(s0)
8000269c:	eee42c23          	sw	a4,-264(s0)
800026a0:	eef42e23          	sw	a5,-260(s0)
800026a4:	8000c7b7          	lui	a5,0x8000c
800026a8:	88c78793          	addi	a5,a5,-1908 # 8000b88c <_bss_end+0xffe4929c>
800026ac:	0007a603          	lw	a2,0(a5)
800026b0:	0047a683          	lw	a3,4(a5)
800026b4:	0087a703          	lw	a4,8(a5)
800026b8:	00c7a783          	lw	a5,12(a5)
800026bc:	eec42023          	sw	a2,-288(s0)
800026c0:	eed42223          	sw	a3,-284(s0)
800026c4:	eee42423          	sw	a4,-280(s0)
800026c8:	eef42623          	sw	a5,-276(s0)
800026cc:	ee040713          	addi	a4,s0,-288
800026d0:	ef040793          	addi	a5,s0,-272
800026d4:	00070593          	mv	a1,a4
800026d8:	00078513          	mv	a0,a5
800026dc:	e85fd0ef          	jal	ra,80000560 <in6_addr_equal>
800026e0:	00050793          	mv	a5,a0
800026e4:	0c078063          	beqz	a5,800027a4 <receive_ripng+0x268>
800026e8:	fd442783          	lw	a5,-44(s0)
800026ec:	0137c703          	lbu	a4,19(a5)
800026f0:	00f00793          	li	a5,15
800026f4:	0af71863          	bne	a4,a5,800027a4 <receive_ripng+0x268>
800026f8:	fd442783          	lw	a5,-44(s0)
800026fc:	0127c783          	lbu	a5,18(a5)
80002700:	00000713          	li	a4,0
80002704:	0ae79063          	bne	a5,a4,800027a4 <receive_ripng+0x268>
80002708:	fdc42783          	lw	a5,-36(s0)
8000270c:	0007d483          	lhu	s1,0(a5)
80002710:	fe042783          	lw	a5,-32(s0)
80002714:	0187a603          	lw	a2,24(a5)
80002718:	01c7a683          	lw	a3,28(a5)
8000271c:	0207a703          	lw	a4,32(a5)
80002720:	0247a783          	lw	a5,36(a5)
80002724:	eec42023          	sw	a2,-288(s0)
80002728:	eed42223          	sw	a3,-284(s0)
8000272c:	eee42423          	sw	a4,-280(s0)
80002730:	eef42623          	sw	a5,-276(s0)
80002734:	ee040793          	addi	a5,s0,-288
80002738:	00078513          	mv	a0,a5
8000273c:	558020ef          	jal	ra,80004c94 <check_multicast_address>
80002740:	00050793          	mv	a5,a0
80002744:	00f037b3          	snez	a5,a5
80002748:	0ff7f793          	andi	a5,a5,255
8000274c:	0017c793          	xori	a5,a5,1
80002750:	0ff7f793          	andi	a5,a5,255
80002754:	0017f793          	andi	a5,a5,1
80002758:	0ff7f593          	andi	a1,a5,255
8000275c:	fe042783          	lw	a5,-32(s0)
80002760:	0087a603          	lw	a2,8(a5)
80002764:	00c7a683          	lw	a3,12(a5)
80002768:	0107a703          	lw	a4,16(a5)
8000276c:	0147a783          	lw	a5,20(a5)
80002770:	eec42023          	sw	a2,-288(s0)
80002774:	eed42223          	sw	a3,-284(s0)
80002778:	eee42423          	sw	a4,-280(s0)
8000277c:	eef42623          	sw	a5,-276(s0)
80002780:	ee040613          	addi	a2,s0,-288
80002784:	fcf44783          	lbu	a5,-49(s0)
80002788:	00058713          	mv	a4,a1
8000278c:	00048693          	mv	a3,s1
80002790:	00078593          	mv	a1,a5
80002794:	f0c42503          	lw	a0,-244(s0)
80002798:	68c010ef          	jal	ra,80003e24 <send_all_ripngentries>
8000279c:	e81fd0ef          	jal	ra,8000061c <dma_lock_release>
800027a0:	3d00106f          	j	80003b70 <receive_ripng+0x1634>
800027a4:	fe042623          	sw	zero,-20(s0)
800027a8:	1140006f          	j	800028bc <receive_ripng+0x380>
800027ac:	fec42703          	lw	a4,-20(s0)
800027b0:	00070793          	mv	a5,a4
800027b4:	00279793          	slli	a5,a5,0x2
800027b8:	00e787b3          	add	a5,a5,a4
800027bc:	00279793          	slli	a5,a5,0x2
800027c0:	00078713          	mv	a4,a5
800027c4:	fd442783          	lw	a5,-44(s0)
800027c8:	00e78733          	add	a4,a5,a4
800027cc:	fec42683          	lw	a3,-20(s0)
800027d0:	00068793          	mv	a5,a3
800027d4:	00279793          	slli	a5,a5,0x2
800027d8:	00d787b3          	add	a5,a5,a3
800027dc:	00279793          	slli	a5,a5,0x2
800027e0:	00078693          	mv	a3,a5
800027e4:	fd442783          	lw	a5,-44(s0)
800027e8:	00d787b3          	add	a5,a5,a3
800027ec:	0127c503          	lbu	a0,18(a5)
800027f0:	00072583          	lw	a1,0(a4)
800027f4:	00472603          	lw	a2,4(a4)
800027f8:	00872683          	lw	a3,8(a4)
800027fc:	00c72783          	lw	a5,12(a4)
80002800:	eeb42023          	sw	a1,-288(s0)
80002804:	eec42223          	sw	a2,-284(s0)
80002808:	eed42423          	sw	a3,-280(s0)
8000280c:	eef42623          	sw	a5,-276(s0)
80002810:	ee040793          	addi	a5,s0,-288
80002814:	00000713          	li	a4,0
80002818:	00000693          	li	a3,0
8000281c:	00000613          	li	a2,0
80002820:	00050593          	mv	a1,a0
80002824:	00078513          	mv	a0,a5
80002828:	525060ef          	jal	ra,8000954c <prefix_query>
8000282c:	00050793          	mv	a5,a0
80002830:	faf42c23          	sw	a5,-72(s0)
80002834:	fb842783          	lw	a5,-72(s0)
80002838:	02079863          	bnez	a5,80002868 <receive_ripng+0x32c>
8000283c:	fec42703          	lw	a4,-20(s0)
80002840:	00070793          	mv	a5,a4
80002844:	00279793          	slli	a5,a5,0x2
80002848:	00e787b3          	add	a5,a5,a4
8000284c:	00279793          	slli	a5,a5,0x2
80002850:	00078713          	mv	a4,a5
80002854:	fd442783          	lw	a5,-44(s0)
80002858:	00e787b3          	add	a5,a5,a4
8000285c:	01000713          	li	a4,16
80002860:	00e789a3          	sb	a4,19(a5)
80002864:	04c0006f          	j	800028b0 <receive_ripng+0x374>
80002868:	fb842703          	lw	a4,-72(s0)
8000286c:	00070793          	mv	a5,a4
80002870:	00279793          	slli	a5,a5,0x2
80002874:	00e787b3          	add	a5,a5,a4
80002878:	00279793          	slli	a5,a5,0x2
8000287c:	00078713          	mv	a4,a5
80002880:	805007b7          	lui	a5,0x80500
80002884:	00f706b3          	add	a3,a4,a5
80002888:	fec42703          	lw	a4,-20(s0)
8000288c:	00070793          	mv	a5,a4
80002890:	00279793          	slli	a5,a5,0x2
80002894:	00e787b3          	add	a5,a5,a4
80002898:	00279793          	slli	a5,a5,0x2
8000289c:	00078713          	mv	a4,a5
800028a0:	fd442783          	lw	a5,-44(s0)
800028a4:	00e787b3          	add	a5,a5,a4
800028a8:	0016c703          	lbu	a4,1(a3)
800028ac:	00e789a3          	sb	a4,19(a5) # 80500013 <_bss_end+0x33da23>
800028b0:	fec42783          	lw	a5,-20(s0)
800028b4:	00178793          	addi	a5,a5,1
800028b8:	fef42623          	sw	a5,-20(s0)
800028bc:	fec42703          	lw	a4,-20(s0)
800028c0:	fd042783          	lw	a5,-48(s0)
800028c4:	eef764e3          	bltu	a4,a5,800027ac <receive_ripng+0x270>
800028c8:	fd842783          	lw	a5,-40(s0)
800028cc:	00200713          	li	a4,2
800028d0:	00e78023          	sb	a4,0(a5)
800028d4:	fcf44783          	lbu	a5,-49(s0)
800028d8:	00078513          	mv	a0,a5
800028dc:	e6dfd0ef          	jal	ra,80000748 <dma_set_out_port>
800028e0:	fe042783          	lw	a5,-32(s0)
800028e4:	fe042703          	lw	a4,-32(s0)
800028e8:	00872583          	lw	a1,8(a4)
800028ec:	00c72603          	lw	a2,12(a4)
800028f0:	01072683          	lw	a3,16(a4)
800028f4:	01472703          	lw	a4,20(a4)
800028f8:	00b7ac23          	sw	a1,24(a5)
800028fc:	00c7ae23          	sw	a2,28(a5)
80002900:	02d7a023          	sw	a3,32(a5)
80002904:	02e7a223          	sw	a4,36(a5)
80002908:	fcf44703          	lbu	a4,-49(s0)
8000290c:	006107b7          	lui	a5,0x610
80002910:	00f707b3          	add	a5,a4,a5
80002914:	00879793          	slli	a5,a5,0x8
80002918:	00078713          	mv	a4,a5
8000291c:	fe042783          	lw	a5,-32(s0)
80002920:	02072583          	lw	a1,32(a4)
80002924:	02472603          	lw	a2,36(a4)
80002928:	02872683          	lw	a3,40(a4)
8000292c:	02c72703          	lw	a4,44(a4)
80002930:	00b7a423          	sw	a1,8(a5) # 610008 <_reset_vector-0x7f9efff8>
80002934:	00c7a623          	sw	a2,12(a5)
80002938:	00d7a823          	sw	a3,16(a5)
8000293c:	00e7aa23          	sw	a4,20(a5)
80002940:	fe042783          	lw	a5,-32(s0)
80002944:	fff00713          	li	a4,-1
80002948:	00e783a3          	sb	a4,7(a5)
8000294c:	fdc42783          	lw	a5,-36(s0)
80002950:	0007d703          	lhu	a4,0(a5)
80002954:	fdc42783          	lw	a5,-36(s0)
80002958:	00e79123          	sh	a4,2(a5)
8000295c:	20900513          	li	a0,521
80002960:	b71ff0ef          	jal	ra,800024d0 <__bswap16>
80002964:	00050793          	mv	a5,a0
80002968:	00078713          	mv	a4,a5
8000296c:	fdc42783          	lw	a5,-36(s0)
80002970:	00e79023          	sh	a4,0(a5)
80002974:	f0842583          	lw	a1,-248(s0)
80002978:	f0c42503          	lw	a0,-244(s0)
8000297c:	efcfd0ef          	jal	ra,80000078 <validateAndFillChecksum>
80002980:	d11fd0ef          	jal	ra,80000690 <dma_send_finish>
80002984:	c99fd0ef          	jal	ra,8000061c <dma_lock_release>
80002988:	1e80106f          	j	80003b70 <receive_ripng+0x1634>
8000298c:	fd842783          	lw	a5,-40(s0)
80002990:	0007c703          	lbu	a4,0(a5)
80002994:	00200793          	li	a5,2
80002998:	00f70463          	beq	a4,a5,800029a0 <receive_ripng+0x464>
8000299c:	1a80106f          	j	80003b44 <receive_ripng+0x1608>
800029a0:	8000c7b7          	lui	a5,0x8000c
800029a4:	8f478513          	addi	a0,a5,-1804 # 8000b8f4 <_bss_end+0xffe49304>
800029a8:	f74ff0ef          	jal	ra,8000211c <printf_>
800029ac:	fe042783          	lw	a5,-32(s0)
800029b0:	0087a603          	lw	a2,8(a5)
800029b4:	00c7a683          	lw	a3,12(a5)
800029b8:	0107a703          	lw	a4,16(a5)
800029bc:	0147a783          	lw	a5,20(a5)
800029c0:	eec42023          	sw	a2,-288(s0)
800029c4:	eed42223          	sw	a3,-284(s0)
800029c8:	eee42423          	sw	a4,-280(s0)
800029cc:	eef42623          	sw	a5,-276(s0)
800029d0:	ee040793          	addi	a5,s0,-288
800029d4:	00078513          	mv	a0,a5
800029d8:	26c020ef          	jal	ra,80004c44 <check_linklocal_address>
800029dc:	00050793          	mv	a5,a0
800029e0:	00079463          	bnez	a5,800029e8 <receive_ripng+0x4ac>
800029e4:	1300106f          	j	80003b14 <receive_ripng+0x15d8>
800029e8:	fe042783          	lw	a5,-32(s0)
800029ec:	0087a603          	lw	a2,8(a5)
800029f0:	00c7a683          	lw	a3,12(a5)
800029f4:	0107a703          	lw	a4,16(a5)
800029f8:	0147a783          	lw	a5,20(a5)
800029fc:	eec42023          	sw	a2,-288(s0)
80002a00:	eed42223          	sw	a3,-284(s0)
80002a04:	eee42423          	sw	a4,-280(s0)
80002a08:	eef42623          	sw	a5,-276(s0)
80002a0c:	ee040793          	addi	a5,s0,-288
80002a10:	00078513          	mv	a0,a5
80002a14:	2b8020ef          	jal	ra,80004ccc <check_own_address>
80002a18:	00050793          	mv	a5,a0
80002a1c:	0017c793          	xori	a5,a5,1
80002a20:	0ff7f793          	andi	a5,a5,255
80002a24:	00079463          	bnez	a5,80002a2c <receive_ripng+0x4f0>
80002a28:	0ec0106f          	j	80003b14 <receive_ripng+0x15d8>
80002a2c:	fe042783          	lw	a5,-32(s0)
80002a30:	0187c703          	lbu	a4,24(a5)
80002a34:	0ff00793          	li	a5,255
80002a38:	08f712e3          	bne	a4,a5,800032bc <receive_ripng+0xd80>
80002a3c:	fe042783          	lw	a5,-32(s0)
80002a40:	0077c703          	lbu	a4,7(a5)
80002a44:	0ff00793          	li	a5,255
80002a48:	04f71ce3          	bne	a4,a5,800032a0 <receive_ripng+0xd64>
80002a4c:	fdc42783          	lw	a5,-36(s0)
80002a50:	0007d483          	lhu	s1,0(a5)
80002a54:	20900513          	li	a0,521
80002a58:	a79ff0ef          	jal	ra,800024d0 <__bswap16>
80002a5c:	00050793          	mv	a5,a0
80002a60:	04f490e3          	bne	s1,a5,800032a0 <receive_ripng+0xd64>
80002a64:	fe042783          	lw	a5,-32(s0)
80002a68:	0087a603          	lw	a2,8(a5)
80002a6c:	00c7a683          	lw	a3,12(a5)
80002a70:	0107a703          	lw	a4,16(a5)
80002a74:	0147a783          	lw	a5,20(a5)
80002a78:	fac42423          	sw	a2,-88(s0)
80002a7c:	fad42623          	sw	a3,-84(s0)
80002a80:	fae42823          	sw	a4,-80(s0)
80002a84:	faf42a23          	sw	a5,-76(s0)
80002a88:	fe042423          	sw	zero,-24(s0)
80002a8c:	0050006f          	j	80003290 <receive_ripng+0xd54>
80002a90:	fe842703          	lw	a4,-24(s0)
80002a94:	00070793          	mv	a5,a4
80002a98:	00279793          	slli	a5,a5,0x2
80002a9c:	00e787b3          	add	a5,a5,a4
80002aa0:	00279793          	slli	a5,a5,0x2
80002aa4:	00078713          	mv	a4,a5
80002aa8:	fd442783          	lw	a5,-44(s0)
80002aac:	00e787b3          	add	a5,a5,a4
80002ab0:	0137c703          	lbu	a4,19(a5)
80002ab4:	01000793          	li	a5,16
80002ab8:	06e7f463          	bgeu	a5,a4,80002b20 <receive_ripng+0x5e4>
80002abc:	fe842703          	lw	a4,-24(s0)
80002ac0:	00070793          	mv	a5,a4
80002ac4:	00279793          	slli	a5,a5,0x2
80002ac8:	00e787b3          	add	a5,a5,a4
80002acc:	00279793          	slli	a5,a5,0x2
80002ad0:	00078713          	mv	a4,a5
80002ad4:	fd442783          	lw	a5,-44(s0)
80002ad8:	00e787b3          	add	a5,a5,a4
80002adc:	0137c703          	lbu	a4,19(a5)
80002ae0:	0ff00793          	li	a5,255
80002ae4:	02f70e63          	beq	a4,a5,80002b20 <receive_ripng+0x5e4>
80002ae8:	fe842703          	lw	a4,-24(s0)
80002aec:	00070793          	mv	a5,a4
80002af0:	00279793          	slli	a5,a5,0x2
80002af4:	00e787b3          	add	a5,a5,a4
80002af8:	00279793          	slli	a5,a5,0x2
80002afc:	00078713          	mv	a4,a5
80002b00:	fd442783          	lw	a5,-44(s0)
80002b04:	00e787b3          	add	a5,a5,a4
80002b08:	0137c783          	lbu	a5,19(a5)
80002b0c:	00078593          	mv	a1,a5
80002b10:	8000c7b7          	lui	a5,0x8000c
80002b14:	91078513          	addi	a0,a5,-1776 # 8000b910 <_bss_end+0xffe49320>
80002b18:	e04ff0ef          	jal	ra,8000211c <printf_>
80002b1c:	7680006f          	j	80003284 <receive_ripng+0xd48>
80002b20:	fe842703          	lw	a4,-24(s0)
80002b24:	00070793          	mv	a5,a4
80002b28:	00279793          	slli	a5,a5,0x2
80002b2c:	00e787b3          	add	a5,a5,a4
80002b30:	00279793          	slli	a5,a5,0x2
80002b34:	00078713          	mv	a4,a5
80002b38:	fd442783          	lw	a5,-44(s0)
80002b3c:	00e787b3          	add	a5,a5,a4
80002b40:	0127c703          	lbu	a4,18(a5)
80002b44:	08000793          	li	a5,128
80002b48:	02e7fe63          	bgeu	a5,a4,80002b84 <receive_ripng+0x648>
80002b4c:	fe842703          	lw	a4,-24(s0)
80002b50:	00070793          	mv	a5,a4
80002b54:	00279793          	slli	a5,a5,0x2
80002b58:	00e787b3          	add	a5,a5,a4
80002b5c:	00279793          	slli	a5,a5,0x2
80002b60:	00078713          	mv	a4,a5
80002b64:	fd442783          	lw	a5,-44(s0)
80002b68:	00e787b3          	add	a5,a5,a4
80002b6c:	0127c783          	lbu	a5,18(a5)
80002b70:	00078593          	mv	a1,a5
80002b74:	8000c7b7          	lui	a5,0x8000c
80002b78:	92478513          	addi	a0,a5,-1756 # 8000b924 <_bss_end+0xffe49334>
80002b7c:	da0ff0ef          	jal	ra,8000211c <printf_>
80002b80:	7040006f          	j	80003284 <receive_ripng+0xd48>
80002b84:	fe842703          	lw	a4,-24(s0)
80002b88:	00070793          	mv	a5,a4
80002b8c:	00279793          	slli	a5,a5,0x2
80002b90:	00e787b3          	add	a5,a5,a4
80002b94:	00279793          	slli	a5,a5,0x2
80002b98:	00078713          	mv	a4,a5
80002b9c:	fd442783          	lw	a5,-44(s0)
80002ba0:	00e787b3          	add	a5,a5,a4
80002ba4:	0007a603          	lw	a2,0(a5)
80002ba8:	0047a683          	lw	a3,4(a5)
80002bac:	0087a703          	lw	a4,8(a5)
80002bb0:	00c7a783          	lw	a5,12(a5)
80002bb4:	eec42023          	sw	a2,-288(s0)
80002bb8:	eed42223          	sw	a3,-284(s0)
80002bbc:	eee42423          	sw	a4,-280(s0)
80002bc0:	eef42623          	sw	a5,-276(s0)
80002bc4:	ee040793          	addi	a5,s0,-288
80002bc8:	00078513          	mv	a0,a5
80002bcc:	078020ef          	jal	ra,80004c44 <check_linklocal_address>
80002bd0:	00050793          	mv	a5,a0
80002bd4:	0017c793          	xori	a5,a5,1
80002bd8:	0ff7f793          	andi	a5,a5,255
80002bdc:	02079863          	bnez	a5,80002c0c <receive_ripng+0x6d0>
80002be0:	fe842703          	lw	a4,-24(s0)
80002be4:	00070793          	mv	a5,a4
80002be8:	00279793          	slli	a5,a5,0x2
80002bec:	00e787b3          	add	a5,a5,a4
80002bf0:	00279793          	slli	a5,a5,0x2
80002bf4:	00078713          	mv	a4,a5
80002bf8:	fd442783          	lw	a5,-44(s0)
80002bfc:	00e787b3          	add	a5,a5,a4
80002c00:	0007c703          	lbu	a4,0(a5)
80002c04:	0ff00793          	li	a5,255
80002c08:	02f71a63          	bne	a4,a5,80002c3c <receive_ripng+0x700>
80002c0c:	fe042783          	lw	a5,-32(s0)
80002c10:	00878793          	addi	a5,a5,8
80002c14:	f1440713          	addi	a4,s0,-236
80002c18:	00070593          	mv	a1,a4
80002c1c:	00078513          	mv	a0,a5
80002c20:	3b1040ef          	jal	ra,800077d0 <printip>
80002c24:	f1440793          	addi	a5,s0,-236
80002c28:	00078593          	mv	a1,a5
80002c2c:	8000c7b7          	lui	a5,0x8000c
80002c30:	93c78513          	addi	a0,a5,-1732 # 8000b93c <_bss_end+0xffe4934c>
80002c34:	ce8ff0ef          	jal	ra,8000211c <printf_>
80002c38:	64c0006f          	j	80003284 <receive_ripng+0xd48>
80002c3c:	fe842703          	lw	a4,-24(s0)
80002c40:	00070793          	mv	a5,a4
80002c44:	00279793          	slli	a5,a5,0x2
80002c48:	00e787b3          	add	a5,a5,a4
80002c4c:	00279793          	slli	a5,a5,0x2
80002c50:	00078713          	mv	a4,a5
80002c54:	fd442783          	lw	a5,-44(s0)
80002c58:	00e787b3          	add	a5,a5,a4
80002c5c:	0137c703          	lbu	a4,19(a5)
80002c60:	0ff00793          	li	a5,255
80002c64:	0ef71e63          	bne	a4,a5,80002d60 <receive_ripng+0x824>
80002c68:	fe842703          	lw	a4,-24(s0)
80002c6c:	00070793          	mv	a5,a4
80002c70:	00279793          	slli	a5,a5,0x2
80002c74:	00e787b3          	add	a5,a5,a4
80002c78:	00279793          	slli	a5,a5,0x2
80002c7c:	00078713          	mv	a4,a5
80002c80:	fd442783          	lw	a5,-44(s0)
80002c84:	00e787b3          	add	a5,a5,a4
80002c88:	0127c783          	lbu	a5,18(a5)
80002c8c:	06079863          	bnez	a5,80002cfc <receive_ripng+0x7c0>
80002c90:	fe842703          	lw	a4,-24(s0)
80002c94:	00070793          	mv	a5,a4
80002c98:	00279793          	slli	a5,a5,0x2
80002c9c:	00e787b3          	add	a5,a5,a4
80002ca0:	00279793          	slli	a5,a5,0x2
80002ca4:	00078713          	mv	a4,a5
80002ca8:	fd442783          	lw	a5,-44(s0)
80002cac:	00e787b3          	add	a5,a5,a4
80002cb0:	0107d783          	lhu	a5,16(a5)
80002cb4:	04079463          	bnez	a5,80002cfc <receive_ripng+0x7c0>
80002cb8:	fe842703          	lw	a4,-24(s0)
80002cbc:	00070793          	mv	a5,a4
80002cc0:	00279793          	slli	a5,a5,0x2
80002cc4:	00e787b3          	add	a5,a5,a4
80002cc8:	00279793          	slli	a5,a5,0x2
80002ccc:	00078713          	mv	a4,a5
80002cd0:	fd442783          	lw	a5,-44(s0)
80002cd4:	00e787b3          	add	a5,a5,a4
80002cd8:	0007a603          	lw	a2,0(a5)
80002cdc:	0047a683          	lw	a3,4(a5)
80002ce0:	0087a703          	lw	a4,8(a5)
80002ce4:	00c7a783          	lw	a5,12(a5)
80002ce8:	fac42423          	sw	a2,-88(s0)
80002cec:	fad42623          	sw	a3,-84(s0)
80002cf0:	fae42823          	sw	a4,-80(s0)
80002cf4:	faf42a23          	sw	a5,-76(s0)
80002cf8:	58c0006f          	j	80003284 <receive_ripng+0xd48>
80002cfc:	fe842703          	lw	a4,-24(s0)
80002d00:	00070793          	mv	a5,a4
80002d04:	00279793          	slli	a5,a5,0x2
80002d08:	00e787b3          	add	a5,a5,a4
80002d0c:	00279793          	slli	a5,a5,0x2
80002d10:	00078713          	mv	a4,a5
80002d14:	fd442783          	lw	a5,-44(s0)
80002d18:	00e787b3          	add	a5,a5,a4
80002d1c:	0107d783          	lhu	a5,16(a5)
80002d20:	00078693          	mv	a3,a5
80002d24:	fe842703          	lw	a4,-24(s0)
80002d28:	00070793          	mv	a5,a4
80002d2c:	00279793          	slli	a5,a5,0x2
80002d30:	00e787b3          	add	a5,a5,a4
80002d34:	00279793          	slli	a5,a5,0x2
80002d38:	00078713          	mv	a4,a5
80002d3c:	fd442783          	lw	a5,-44(s0)
80002d40:	00e787b3          	add	a5,a5,a4
80002d44:	0137c783          	lbu	a5,19(a5)
80002d48:	00078613          	mv	a2,a5
80002d4c:	00068593          	mv	a1,a3
80002d50:	8000c7b7          	lui	a5,0x8000c
80002d54:	95078513          	addi	a0,a5,-1712 # 8000b950 <_bss_end+0xffe49360>
80002d58:	bc4ff0ef          	jal	ra,8000211c <printf_>
80002d5c:	5280006f          	j	80003284 <receive_ripng+0xd48>
80002d60:	fe842703          	lw	a4,-24(s0)
80002d64:	00070793          	mv	a5,a4
80002d68:	00279793          	slli	a5,a5,0x2
80002d6c:	00e787b3          	add	a5,a5,a4
80002d70:	00279793          	slli	a5,a5,0x2
80002d74:	00078713          	mv	a4,a5
80002d78:	fd442783          	lw	a5,-44(s0)
80002d7c:	00e78733          	add	a4,a5,a4
80002d80:	fe842683          	lw	a3,-24(s0)
80002d84:	00068793          	mv	a5,a3
80002d88:	00279793          	slli	a5,a5,0x2
80002d8c:	00d787b3          	add	a5,a5,a3
80002d90:	00279793          	slli	a5,a5,0x2
80002d94:	00078693          	mv	a3,a5
80002d98:	fd442783          	lw	a5,-44(s0)
80002d9c:	00d787b3          	add	a5,a5,a3
80002da0:	0127c503          	lbu	a0,18(a5)
80002da4:	00072583          	lw	a1,0(a4)
80002da8:	00472603          	lw	a2,4(a4)
80002dac:	00872683          	lw	a3,8(a4)
80002db0:	00c72783          	lw	a5,12(a4)
80002db4:	eeb42023          	sw	a1,-288(s0)
80002db8:	eec42223          	sw	a2,-284(s0)
80002dbc:	eed42423          	sw	a3,-280(s0)
80002dc0:	eef42623          	sw	a5,-276(s0)
80002dc4:	ee040793          	addi	a5,s0,-288
80002dc8:	00000713          	li	a4,0
80002dcc:	00000693          	li	a3,0
80002dd0:	00000613          	li	a2,0
80002dd4:	00050593          	mv	a1,a0
80002dd8:	00078513          	mv	a0,a5
80002ddc:	770060ef          	jal	ra,8000954c <prefix_query>
80002de0:	00050793          	mv	a5,a0
80002de4:	fcf42023          	sw	a5,-64(s0)
80002de8:	fc042703          	lw	a4,-64(s0)
80002dec:	00070793          	mv	a5,a4
80002df0:	00279793          	slli	a5,a5,0x2
80002df4:	00e787b3          	add	a5,a5,a4
80002df8:	00279793          	slli	a5,a5,0x2
80002dfc:	00078713          	mv	a4,a5
80002e00:	805007b7          	lui	a5,0x80500
80002e04:	00f707b3          	add	a5,a4,a5
80002e08:	faf42e23          	sw	a5,-68(s0)
80002e0c:	fc042783          	lw	a5,-64(s0)
80002e10:	32078e63          	beqz	a5,8000314c <receive_ripng+0xc10>
80002e14:	fbc42783          	lw	a5,-68(s0)
80002e18:	0037c783          	lbu	a5,3(a5) # 80500003 <_bss_end+0x33da13>
80002e1c:	00579713          	slli	a4,a5,0x5
80002e20:	510007b7          	lui	a5,0x51000
80002e24:	00f707b3          	add	a5,a4,a5
80002e28:	0107a703          	lw	a4,16(a5) # 51000010 <_reset_vector-0x2efffff0>
80002e2c:	fcf44783          	lbu	a5,-49(s0)
80002e30:	24f71a63          	bne	a4,a5,80003084 <receive_ripng+0xb48>
80002e34:	fe842703          	lw	a4,-24(s0)
80002e38:	00070793          	mv	a5,a4
80002e3c:	00279793          	slli	a5,a5,0x2
80002e40:	00e787b3          	add	a5,a5,a4
80002e44:	00279793          	slli	a5,a5,0x2
80002e48:	00078713          	mv	a4,a5
80002e4c:	fd442783          	lw	a5,-44(s0)
80002e50:	00e78733          	add	a4,a5,a4
80002e54:	fbc42783          	lw	a5,-68(s0)
80002e58:	0037c783          	lbu	a5,3(a5)
80002e5c:	00579693          	slli	a3,a5,0x5
80002e60:	510007b7          	lui	a5,0x51000
80002e64:	00f687b3          	add	a5,a3,a5
80002e68:	00072583          	lw	a1,0(a4)
80002e6c:	00472603          	lw	a2,4(a4)
80002e70:	00872683          	lw	a3,8(a4)
80002e74:	00c72703          	lw	a4,12(a4)
80002e78:	eeb42023          	sw	a1,-288(s0)
80002e7c:	eec42223          	sw	a2,-284(s0)
80002e80:	eed42423          	sw	a3,-280(s0)
80002e84:	eee42623          	sw	a4,-276(s0)
80002e88:	0007a603          	lw	a2,0(a5) # 51000000 <_reset_vector-0x2f000000>
80002e8c:	0047a683          	lw	a3,4(a5)
80002e90:	0087a703          	lw	a4,8(a5)
80002e94:	00c7a783          	lw	a5,12(a5)
80002e98:	eec42823          	sw	a2,-272(s0)
80002e9c:	eed42a23          	sw	a3,-268(s0)
80002ea0:	eee42c23          	sw	a4,-264(s0)
80002ea4:	eef42e23          	sw	a5,-260(s0)
80002ea8:	ef040713          	addi	a4,s0,-272
80002eac:	ee040793          	addi	a5,s0,-288
80002eb0:	00070593          	mv	a1,a4
80002eb4:	00078513          	mv	a0,a5
80002eb8:	ea8fd0ef          	jal	ra,80000560 <in6_addr_equal>
80002ebc:	00050793          	mv	a5,a0
80002ec0:	1c078263          	beqz	a5,80003084 <receive_ripng+0xb48>
80002ec4:	fbc42783          	lw	a5,-68(s0)
80002ec8:	0017c703          	lbu	a4,1(a5)
80002ecc:	00e00793          	li	a5,14
80002ed0:	14e7f063          	bgeu	a5,a4,80003010 <receive_ripng+0xad4>
80002ed4:	f0042a23          	sw	zero,-236(s0)
80002ed8:	f0042c23          	sw	zero,-232(s0)
80002edc:	f0042e23          	sw	zero,-228(s0)
80002ee0:	f2042023          	sw	zero,-224(s0)
80002ee4:	f2042223          	sw	zero,-220(s0)
80002ee8:	f2042423          	sw	zero,-216(s0)
80002eec:	f2042623          	sw	zero,-212(s0)
80002ef0:	f2042823          	sw	zero,-208(s0)
80002ef4:	f2042a23          	sw	zero,-204(s0)
80002ef8:	f2042c23          	sw	zero,-200(s0)
80002efc:	f2042e23          	sw	zero,-196(s0)
80002f00:	f4042023          	sw	zero,-192(s0)
80002f04:	fe842703          	lw	a4,-24(s0)
80002f08:	00070793          	mv	a5,a4
80002f0c:	00279793          	slli	a5,a5,0x2
80002f10:	00e787b3          	add	a5,a5,a4
80002f14:	00279793          	slli	a5,a5,0x2
80002f18:	00078713          	mv	a4,a5
80002f1c:	fd442783          	lw	a5,-44(s0)
80002f20:	00e787b3          	add	a5,a5,a4
80002f24:	0007a603          	lw	a2,0(a5)
80002f28:	0047a683          	lw	a3,4(a5)
80002f2c:	0087a703          	lw	a4,8(a5)
80002f30:	00c7a783          	lw	a5,12(a5)
80002f34:	f0c42a23          	sw	a2,-236(s0)
80002f38:	f0d42c23          	sw	a3,-232(s0)
80002f3c:	f0e42e23          	sw	a4,-228(s0)
80002f40:	f2f42023          	sw	a5,-224(s0)
80002f44:	fe842703          	lw	a4,-24(s0)
80002f48:	00070793          	mv	a5,a4
80002f4c:	00279793          	slli	a5,a5,0x2
80002f50:	00e787b3          	add	a5,a5,a4
80002f54:	00279793          	slli	a5,a5,0x2
80002f58:	00078713          	mv	a4,a5
80002f5c:	fd442783          	lw	a5,-44(s0)
80002f60:	00e787b3          	add	a5,a5,a4
80002f64:	0127c783          	lbu	a5,18(a5)
80002f68:	f2f42223          	sw	a5,-220(s0)
80002f6c:	fcf44783          	lbu	a5,-49(s0)
80002f70:	f2f42423          	sw	a5,-216(s0)
80002f74:	fa842603          	lw	a2,-88(s0)
80002f78:	fac42683          	lw	a3,-84(s0)
80002f7c:	fb042703          	lw	a4,-80(s0)
80002f80:	fb442783          	lw	a5,-76(s0)
80002f84:	f2c42623          	sw	a2,-212(s0)
80002f88:	f2d42823          	sw	a3,-208(s0)
80002f8c:	f2e42a23          	sw	a4,-204(s0)
80002f90:	f2f42c23          	sw	a5,-200(s0)
80002f94:	00100793          	li	a5,1
80002f98:	f2f42e23          	sw	a5,-196(s0)
80002f9c:	f1442f03          	lw	t5,-236(s0)
80002fa0:	f1842e83          	lw	t4,-232(s0)
80002fa4:	f1c42e03          	lw	t3,-228(s0)
80002fa8:	f2042303          	lw	t1,-224(s0)
80002fac:	f2442883          	lw	a7,-220(s0)
80002fb0:	f2842803          	lw	a6,-216(s0)
80002fb4:	f2c42503          	lw	a0,-212(s0)
80002fb8:	f3042583          	lw	a1,-208(s0)
80002fbc:	f3442603          	lw	a2,-204(s0)
80002fc0:	f3842683          	lw	a3,-200(s0)
80002fc4:	f3c42703          	lw	a4,-196(s0)
80002fc8:	f4042783          	lw	a5,-192(s0)
80002fcc:	ebe42823          	sw	t5,-336(s0)
80002fd0:	ebd42a23          	sw	t4,-332(s0)
80002fd4:	ebc42c23          	sw	t3,-328(s0)
80002fd8:	ea642e23          	sw	t1,-324(s0)
80002fdc:	ed142023          	sw	a7,-320(s0)
80002fe0:	ed042223          	sw	a6,-316(s0)
80002fe4:	eca42423          	sw	a0,-312(s0)
80002fe8:	ecb42623          	sw	a1,-308(s0)
80002fec:	ecc42823          	sw	a2,-304(s0)
80002ff0:	ecd42a23          	sw	a3,-300(s0)
80002ff4:	ece42c23          	sw	a4,-296(s0)
80002ff8:	ecf42e23          	sw	a5,-292(s0)
80002ffc:	eb040793          	addi	a5,s0,-336
80003000:	00078593          	mv	a1,a5
80003004:	00000513          	li	a0,0
80003008:	1d0060ef          	jal	ra,800091d8 <update>
8000300c:	2780006f          	j	80003284 <receive_ripng+0xd48>
80003010:	fe842703          	lw	a4,-24(s0)
80003014:	00070793          	mv	a5,a4
80003018:	00279793          	slli	a5,a5,0x2
8000301c:	00e787b3          	add	a5,a5,a4
80003020:	00279793          	slli	a5,a5,0x2
80003024:	00078713          	mv	a4,a5
80003028:	fd442783          	lw	a5,-44(s0)
8000302c:	00e787b3          	add	a5,a5,a4
80003030:	0137c783          	lbu	a5,19(a5)
80003034:	00178793          	addi	a5,a5,1
80003038:	0ff7f593          	andi	a1,a5,255
8000303c:	f8042c23          	sw	zero,-104(s0)
80003040:	f8042e23          	sw	zero,-100(s0)
80003044:	fa042023          	sw	zero,-96(s0)
80003048:	fa042223          	sw	zero,-92(s0)
8000304c:	f9842603          	lw	a2,-104(s0)
80003050:	f9c42683          	lw	a3,-100(s0)
80003054:	fa042703          	lw	a4,-96(s0)
80003058:	fa442783          	lw	a5,-92(s0)
8000305c:	eac42823          	sw	a2,-336(s0)
80003060:	ead42a23          	sw	a3,-332(s0)
80003064:	eae42c23          	sw	a4,-328(s0)
80003068:	eaf42e23          	sw	a5,-324(s0)
8000306c:	eb040793          	addi	a5,s0,-336
80003070:	00078693          	mv	a3,a5
80003074:	0ff00613          	li	a2,255
80003078:	fc042503          	lw	a0,-64(s0)
8000307c:	3c0060ef          	jal	ra,8000943c <update_leaf_info>
80003080:	2040006f          	j	80003284 <receive_ripng+0xd48>
80003084:	fe842703          	lw	a4,-24(s0)
80003088:	00070793          	mv	a5,a4
8000308c:	00279793          	slli	a5,a5,0x2
80003090:	00e787b3          	add	a5,a5,a4
80003094:	00279793          	slli	a5,a5,0x2
80003098:	00078713          	mv	a4,a5
8000309c:	fd442783          	lw	a5,-44(s0)
800030a0:	00e787b3          	add	a5,a5,a4
800030a4:	0137c783          	lbu	a5,19(a5)
800030a8:	00178793          	addi	a5,a5,1
800030ac:	fbc42703          	lw	a4,-68(s0)
800030b0:	00174703          	lbu	a4,1(a4)
800030b4:	1ce7d863          	bge	a5,a4,80003284 <receive_ripng+0xd48>
800030b8:	fe842703          	lw	a4,-24(s0)
800030bc:	00070793          	mv	a5,a4
800030c0:	00279793          	slli	a5,a5,0x2
800030c4:	00e787b3          	add	a5,a5,a4
800030c8:	00279793          	slli	a5,a5,0x2
800030cc:	00078713          	mv	a4,a5
800030d0:	fd442783          	lw	a5,-44(s0)
800030d4:	00e787b3          	add	a5,a5,a4
800030d8:	0137c703          	lbu	a4,19(a5)
800030dc:	00e00793          	li	a5,14
800030e0:	1ae7e263          	bltu	a5,a4,80003284 <receive_ripng+0xd48>
800030e4:	fe842703          	lw	a4,-24(s0)
800030e8:	00070793          	mv	a5,a4
800030ec:	00279793          	slli	a5,a5,0x2
800030f0:	00e787b3          	add	a5,a5,a4
800030f4:	00279793          	slli	a5,a5,0x2
800030f8:	00078713          	mv	a4,a5
800030fc:	fd442783          	lw	a5,-44(s0)
80003100:	00e787b3          	add	a5,a5,a4
80003104:	0137c783          	lbu	a5,19(a5)
80003108:	00178793          	addi	a5,a5,1
8000310c:	0ff7f593          	andi	a1,a5,255
80003110:	fa842603          	lw	a2,-88(s0)
80003114:	fac42683          	lw	a3,-84(s0)
80003118:	fb042703          	lw	a4,-80(s0)
8000311c:	fb442783          	lw	a5,-76(s0)
80003120:	eac42823          	sw	a2,-336(s0)
80003124:	ead42a23          	sw	a3,-332(s0)
80003128:	eae42c23          	sw	a4,-328(s0)
8000312c:	eaf42e23          	sw	a5,-324(s0)
80003130:	eb040713          	addi	a4,s0,-336
80003134:	fcf44783          	lbu	a5,-49(s0)
80003138:	00070693          	mv	a3,a4
8000313c:	00078613          	mv	a2,a5
80003140:	fc042503          	lw	a0,-64(s0)
80003144:	2f8060ef          	jal	ra,8000943c <update_leaf_info>
80003148:	13c0006f          	j	80003284 <receive_ripng+0xd48>
8000314c:	f0042a23          	sw	zero,-236(s0)
80003150:	f0042c23          	sw	zero,-232(s0)
80003154:	f0042e23          	sw	zero,-228(s0)
80003158:	f2042023          	sw	zero,-224(s0)
8000315c:	f2042223          	sw	zero,-220(s0)
80003160:	f2042423          	sw	zero,-216(s0)
80003164:	f2042623          	sw	zero,-212(s0)
80003168:	f2042823          	sw	zero,-208(s0)
8000316c:	f2042a23          	sw	zero,-204(s0)
80003170:	f2042c23          	sw	zero,-200(s0)
80003174:	f2042e23          	sw	zero,-196(s0)
80003178:	f4042023          	sw	zero,-192(s0)
8000317c:	fe842703          	lw	a4,-24(s0)
80003180:	00070793          	mv	a5,a4
80003184:	00279793          	slli	a5,a5,0x2
80003188:	00e787b3          	add	a5,a5,a4
8000318c:	00279793          	slli	a5,a5,0x2
80003190:	00078713          	mv	a4,a5
80003194:	fd442783          	lw	a5,-44(s0)
80003198:	00e787b3          	add	a5,a5,a4
8000319c:	0007a603          	lw	a2,0(a5)
800031a0:	0047a683          	lw	a3,4(a5)
800031a4:	0087a703          	lw	a4,8(a5)
800031a8:	00c7a783          	lw	a5,12(a5)
800031ac:	f0c42a23          	sw	a2,-236(s0)
800031b0:	f0d42c23          	sw	a3,-232(s0)
800031b4:	f0e42e23          	sw	a4,-228(s0)
800031b8:	f2f42023          	sw	a5,-224(s0)
800031bc:	fe842703          	lw	a4,-24(s0)
800031c0:	00070793          	mv	a5,a4
800031c4:	00279793          	slli	a5,a5,0x2
800031c8:	00e787b3          	add	a5,a5,a4
800031cc:	00279793          	slli	a5,a5,0x2
800031d0:	00078713          	mv	a4,a5
800031d4:	fd442783          	lw	a5,-44(s0)
800031d8:	00e787b3          	add	a5,a5,a4
800031dc:	0127c783          	lbu	a5,18(a5)
800031e0:	f2f42223          	sw	a5,-220(s0)
800031e4:	fcf44783          	lbu	a5,-49(s0)
800031e8:	f2f42423          	sw	a5,-216(s0)
800031ec:	fa842603          	lw	a2,-88(s0)
800031f0:	fac42683          	lw	a3,-84(s0)
800031f4:	fb042703          	lw	a4,-80(s0)
800031f8:	fb442783          	lw	a5,-76(s0)
800031fc:	f2c42623          	sw	a2,-212(s0)
80003200:	f2d42823          	sw	a3,-208(s0)
80003204:	f2e42a23          	sw	a4,-204(s0)
80003208:	f2f42c23          	sw	a5,-200(s0)
8000320c:	00100793          	li	a5,1
80003210:	f2f42e23          	sw	a5,-196(s0)
80003214:	f1442f03          	lw	t5,-236(s0)
80003218:	f1842e83          	lw	t4,-232(s0)
8000321c:	f1c42e03          	lw	t3,-228(s0)
80003220:	f2042303          	lw	t1,-224(s0)
80003224:	f2442883          	lw	a7,-220(s0)
80003228:	f2842803          	lw	a6,-216(s0)
8000322c:	f2c42503          	lw	a0,-212(s0)
80003230:	f3042583          	lw	a1,-208(s0)
80003234:	f3442603          	lw	a2,-204(s0)
80003238:	f3842683          	lw	a3,-200(s0)
8000323c:	f3c42703          	lw	a4,-196(s0)
80003240:	f4042783          	lw	a5,-192(s0)
80003244:	ebe42823          	sw	t5,-336(s0)
80003248:	ebd42a23          	sw	t4,-332(s0)
8000324c:	ebc42c23          	sw	t3,-328(s0)
80003250:	ea642e23          	sw	t1,-324(s0)
80003254:	ed142023          	sw	a7,-320(s0)
80003258:	ed042223          	sw	a6,-316(s0)
8000325c:	eca42423          	sw	a0,-312(s0)
80003260:	ecb42623          	sw	a1,-308(s0)
80003264:	ecc42823          	sw	a2,-304(s0)
80003268:	ecd42a23          	sw	a3,-300(s0)
8000326c:	ece42c23          	sw	a4,-296(s0)
80003270:	ecf42e23          	sw	a5,-292(s0)
80003274:	eb040793          	addi	a5,s0,-336
80003278:	00078593          	mv	a1,a5
8000327c:	00100513          	li	a0,1
80003280:	759050ef          	jal	ra,800091d8 <update>
80003284:	fe842783          	lw	a5,-24(s0)
80003288:	00178793          	addi	a5,a5,1
8000328c:	fef42423          	sw	a5,-24(s0)
80003290:	fe842703          	lw	a4,-24(s0)
80003294:	fd042783          	lw	a5,-48(s0)
80003298:	fef76c63          	bltu	a4,a5,80002a90 <receive_ripng+0x554>
8000329c:	0750006f          	j	80003b10 <receive_ripng+0x15d4>
800032a0:	fd842783          	lw	a5,-40(s0)
800032a4:	0007c783          	lbu	a5,0(a5)
800032a8:	00078593          	mv	a1,a5
800032ac:	8000c7b7          	lui	a5,0x8000c
800032b0:	98478513          	addi	a0,a5,-1660 # 8000b984 <_bss_end+0xffe49394>
800032b4:	e69fe0ef          	jal	ra,8000211c <printf_>
800032b8:	0a90006f          	j	80003b60 <receive_ripng+0x1624>
800032bc:	fe042783          	lw	a5,-32(s0)
800032c0:	0077c703          	lbu	a4,7(a5)
800032c4:	0ff00793          	li	a5,255
800032c8:	04f710e3          	bne	a4,a5,80003b08 <receive_ripng+0x15cc>
800032cc:	fe042783          	lw	a5,-32(s0)
800032d0:	0087a603          	lw	a2,8(a5)
800032d4:	00c7a683          	lw	a3,12(a5)
800032d8:	0107a703          	lw	a4,16(a5)
800032dc:	0147a783          	lw	a5,20(a5)
800032e0:	f8c42423          	sw	a2,-120(s0)
800032e4:	f8d42623          	sw	a3,-116(s0)
800032e8:	f8e42823          	sw	a4,-112(s0)
800032ec:	f8f42a23          	sw	a5,-108(s0)
800032f0:	fe042223          	sw	zero,-28(s0)
800032f4:	0050006f          	j	80003af8 <receive_ripng+0x15bc>
800032f8:	fe442703          	lw	a4,-28(s0)
800032fc:	00070793          	mv	a5,a4
80003300:	00279793          	slli	a5,a5,0x2
80003304:	00e787b3          	add	a5,a5,a4
80003308:	00279793          	slli	a5,a5,0x2
8000330c:	00078713          	mv	a4,a5
80003310:	fd442783          	lw	a5,-44(s0)
80003314:	00e787b3          	add	a5,a5,a4
80003318:	0137c703          	lbu	a4,19(a5)
8000331c:	01000793          	li	a5,16
80003320:	06e7f463          	bgeu	a5,a4,80003388 <receive_ripng+0xe4c>
80003324:	fe442703          	lw	a4,-28(s0)
80003328:	00070793          	mv	a5,a4
8000332c:	00279793          	slli	a5,a5,0x2
80003330:	00e787b3          	add	a5,a5,a4
80003334:	00279793          	slli	a5,a5,0x2
80003338:	00078713          	mv	a4,a5
8000333c:	fd442783          	lw	a5,-44(s0)
80003340:	00e787b3          	add	a5,a5,a4
80003344:	0137c703          	lbu	a4,19(a5)
80003348:	0ff00793          	li	a5,255
8000334c:	02f70e63          	beq	a4,a5,80003388 <receive_ripng+0xe4c>
80003350:	fe442703          	lw	a4,-28(s0)
80003354:	00070793          	mv	a5,a4
80003358:	00279793          	slli	a5,a5,0x2
8000335c:	00e787b3          	add	a5,a5,a4
80003360:	00279793          	slli	a5,a5,0x2
80003364:	00078713          	mv	a4,a5
80003368:	fd442783          	lw	a5,-44(s0)
8000336c:	00e787b3          	add	a5,a5,a4
80003370:	0137c783          	lbu	a5,19(a5)
80003374:	00078593          	mv	a1,a5
80003378:	8000c7b7          	lui	a5,0x8000c
8000337c:	91078513          	addi	a0,a5,-1776 # 8000b910 <_bss_end+0xffe49320>
80003380:	d9dfe0ef          	jal	ra,8000211c <printf_>
80003384:	7680006f          	j	80003aec <receive_ripng+0x15b0>
80003388:	fe442703          	lw	a4,-28(s0)
8000338c:	00070793          	mv	a5,a4
80003390:	00279793          	slli	a5,a5,0x2
80003394:	00e787b3          	add	a5,a5,a4
80003398:	00279793          	slli	a5,a5,0x2
8000339c:	00078713          	mv	a4,a5
800033a0:	fd442783          	lw	a5,-44(s0)
800033a4:	00e787b3          	add	a5,a5,a4
800033a8:	0127c703          	lbu	a4,18(a5)
800033ac:	08000793          	li	a5,128
800033b0:	02e7fe63          	bgeu	a5,a4,800033ec <receive_ripng+0xeb0>
800033b4:	fe442703          	lw	a4,-28(s0)
800033b8:	00070793          	mv	a5,a4
800033bc:	00279793          	slli	a5,a5,0x2
800033c0:	00e787b3          	add	a5,a5,a4
800033c4:	00279793          	slli	a5,a5,0x2
800033c8:	00078713          	mv	a4,a5
800033cc:	fd442783          	lw	a5,-44(s0)
800033d0:	00e787b3          	add	a5,a5,a4
800033d4:	0127c783          	lbu	a5,18(a5)
800033d8:	00078593          	mv	a1,a5
800033dc:	8000c7b7          	lui	a5,0x8000c
800033e0:	92478513          	addi	a0,a5,-1756 # 8000b924 <_bss_end+0xffe49334>
800033e4:	d39fe0ef          	jal	ra,8000211c <printf_>
800033e8:	7040006f          	j	80003aec <receive_ripng+0x15b0>
800033ec:	fe442703          	lw	a4,-28(s0)
800033f0:	00070793          	mv	a5,a4
800033f4:	00279793          	slli	a5,a5,0x2
800033f8:	00e787b3          	add	a5,a5,a4
800033fc:	00279793          	slli	a5,a5,0x2
80003400:	00078713          	mv	a4,a5
80003404:	fd442783          	lw	a5,-44(s0)
80003408:	00e787b3          	add	a5,a5,a4
8000340c:	0007a603          	lw	a2,0(a5)
80003410:	0047a683          	lw	a3,4(a5)
80003414:	0087a703          	lw	a4,8(a5)
80003418:	00c7a783          	lw	a5,12(a5)
8000341c:	eac42823          	sw	a2,-336(s0)
80003420:	ead42a23          	sw	a3,-332(s0)
80003424:	eae42c23          	sw	a4,-328(s0)
80003428:	eaf42e23          	sw	a5,-324(s0)
8000342c:	eb040793          	addi	a5,s0,-336
80003430:	00078513          	mv	a0,a5
80003434:	011010ef          	jal	ra,80004c44 <check_linklocal_address>
80003438:	00050793          	mv	a5,a0
8000343c:	0017c793          	xori	a5,a5,1
80003440:	0ff7f793          	andi	a5,a5,255
80003444:	02079863          	bnez	a5,80003474 <receive_ripng+0xf38>
80003448:	fe442703          	lw	a4,-28(s0)
8000344c:	00070793          	mv	a5,a4
80003450:	00279793          	slli	a5,a5,0x2
80003454:	00e787b3          	add	a5,a5,a4
80003458:	00279793          	slli	a5,a5,0x2
8000345c:	00078713          	mv	a4,a5
80003460:	fd442783          	lw	a5,-44(s0)
80003464:	00e787b3          	add	a5,a5,a4
80003468:	0007c703          	lbu	a4,0(a5)
8000346c:	0ff00793          	li	a5,255
80003470:	02f71a63          	bne	a4,a5,800034a4 <receive_ripng+0xf68>
80003474:	fe042783          	lw	a5,-32(s0)
80003478:	00878793          	addi	a5,a5,8
8000347c:	f1440713          	addi	a4,s0,-236
80003480:	00070593          	mv	a1,a4
80003484:	00078513          	mv	a0,a5
80003488:	348040ef          	jal	ra,800077d0 <printip>
8000348c:	f1440793          	addi	a5,s0,-236
80003490:	00078593          	mv	a1,a5
80003494:	8000c7b7          	lui	a5,0x8000c
80003498:	93c78513          	addi	a0,a5,-1732 # 8000b93c <_bss_end+0xffe4934c>
8000349c:	c81fe0ef          	jal	ra,8000211c <printf_>
800034a0:	64c0006f          	j	80003aec <receive_ripng+0x15b0>
800034a4:	fe442703          	lw	a4,-28(s0)
800034a8:	00070793          	mv	a5,a4
800034ac:	00279793          	slli	a5,a5,0x2
800034b0:	00e787b3          	add	a5,a5,a4
800034b4:	00279793          	slli	a5,a5,0x2
800034b8:	00078713          	mv	a4,a5
800034bc:	fd442783          	lw	a5,-44(s0)
800034c0:	00e787b3          	add	a5,a5,a4
800034c4:	0137c703          	lbu	a4,19(a5)
800034c8:	0ff00793          	li	a5,255
800034cc:	0ef71e63          	bne	a4,a5,800035c8 <receive_ripng+0x108c>
800034d0:	fe442703          	lw	a4,-28(s0)
800034d4:	00070793          	mv	a5,a4
800034d8:	00279793          	slli	a5,a5,0x2
800034dc:	00e787b3          	add	a5,a5,a4
800034e0:	00279793          	slli	a5,a5,0x2
800034e4:	00078713          	mv	a4,a5
800034e8:	fd442783          	lw	a5,-44(s0)
800034ec:	00e787b3          	add	a5,a5,a4
800034f0:	0127c783          	lbu	a5,18(a5)
800034f4:	06079863          	bnez	a5,80003564 <receive_ripng+0x1028>
800034f8:	fe442703          	lw	a4,-28(s0)
800034fc:	00070793          	mv	a5,a4
80003500:	00279793          	slli	a5,a5,0x2
80003504:	00e787b3          	add	a5,a5,a4
80003508:	00279793          	slli	a5,a5,0x2
8000350c:	00078713          	mv	a4,a5
80003510:	fd442783          	lw	a5,-44(s0)
80003514:	00e787b3          	add	a5,a5,a4
80003518:	0107d783          	lhu	a5,16(a5)
8000351c:	04079463          	bnez	a5,80003564 <receive_ripng+0x1028>
80003520:	fe442703          	lw	a4,-28(s0)
80003524:	00070793          	mv	a5,a4
80003528:	00279793          	slli	a5,a5,0x2
8000352c:	00e787b3          	add	a5,a5,a4
80003530:	00279793          	slli	a5,a5,0x2
80003534:	00078713          	mv	a4,a5
80003538:	fd442783          	lw	a5,-44(s0)
8000353c:	00e787b3          	add	a5,a5,a4
80003540:	0007a603          	lw	a2,0(a5)
80003544:	0047a683          	lw	a3,4(a5)
80003548:	0087a703          	lw	a4,8(a5)
8000354c:	00c7a783          	lw	a5,12(a5)
80003550:	f8c42423          	sw	a2,-120(s0)
80003554:	f8d42623          	sw	a3,-116(s0)
80003558:	f8e42823          	sw	a4,-112(s0)
8000355c:	f8f42a23          	sw	a5,-108(s0)
80003560:	58c0006f          	j	80003aec <receive_ripng+0x15b0>
80003564:	fe442703          	lw	a4,-28(s0)
80003568:	00070793          	mv	a5,a4
8000356c:	00279793          	slli	a5,a5,0x2
80003570:	00e787b3          	add	a5,a5,a4
80003574:	00279793          	slli	a5,a5,0x2
80003578:	00078713          	mv	a4,a5
8000357c:	fd442783          	lw	a5,-44(s0)
80003580:	00e787b3          	add	a5,a5,a4
80003584:	0107d783          	lhu	a5,16(a5)
80003588:	00078693          	mv	a3,a5
8000358c:	fe442703          	lw	a4,-28(s0)
80003590:	00070793          	mv	a5,a4
80003594:	00279793          	slli	a5,a5,0x2
80003598:	00e787b3          	add	a5,a5,a4
8000359c:	00279793          	slli	a5,a5,0x2
800035a0:	00078713          	mv	a4,a5
800035a4:	fd442783          	lw	a5,-44(s0)
800035a8:	00e787b3          	add	a5,a5,a4
800035ac:	0137c783          	lbu	a5,19(a5)
800035b0:	00078613          	mv	a2,a5
800035b4:	00068593          	mv	a1,a3
800035b8:	8000c7b7          	lui	a5,0x8000c
800035bc:	95078513          	addi	a0,a5,-1712 # 8000b950 <_bss_end+0xffe49360>
800035c0:	b5dfe0ef          	jal	ra,8000211c <printf_>
800035c4:	5280006f          	j	80003aec <receive_ripng+0x15b0>
800035c8:	fe442703          	lw	a4,-28(s0)
800035cc:	00070793          	mv	a5,a4
800035d0:	00279793          	slli	a5,a5,0x2
800035d4:	00e787b3          	add	a5,a5,a4
800035d8:	00279793          	slli	a5,a5,0x2
800035dc:	00078713          	mv	a4,a5
800035e0:	fd442783          	lw	a5,-44(s0)
800035e4:	00e78733          	add	a4,a5,a4
800035e8:	fe442683          	lw	a3,-28(s0)
800035ec:	00068793          	mv	a5,a3
800035f0:	00279793          	slli	a5,a5,0x2
800035f4:	00d787b3          	add	a5,a5,a3
800035f8:	00279793          	slli	a5,a5,0x2
800035fc:	00078693          	mv	a3,a5
80003600:	fd442783          	lw	a5,-44(s0)
80003604:	00d787b3          	add	a5,a5,a3
80003608:	0127c503          	lbu	a0,18(a5)
8000360c:	00072583          	lw	a1,0(a4)
80003610:	00472603          	lw	a2,4(a4)
80003614:	00872683          	lw	a3,8(a4)
80003618:	00c72783          	lw	a5,12(a4)
8000361c:	eab42823          	sw	a1,-336(s0)
80003620:	eac42a23          	sw	a2,-332(s0)
80003624:	ead42c23          	sw	a3,-328(s0)
80003628:	eaf42e23          	sw	a5,-324(s0)
8000362c:	eb040793          	addi	a5,s0,-336
80003630:	00000713          	li	a4,0
80003634:	00000693          	li	a3,0
80003638:	00000613          	li	a2,0
8000363c:	00050593          	mv	a1,a0
80003640:	00078513          	mv	a0,a5
80003644:	709050ef          	jal	ra,8000954c <prefix_query>
80003648:	00050793          	mv	a5,a0
8000364c:	fcf42423          	sw	a5,-56(s0)
80003650:	fc842703          	lw	a4,-56(s0)
80003654:	00070793          	mv	a5,a4
80003658:	00279793          	slli	a5,a5,0x2
8000365c:	00e787b3          	add	a5,a5,a4
80003660:	00279793          	slli	a5,a5,0x2
80003664:	00078713          	mv	a4,a5
80003668:	805007b7          	lui	a5,0x80500
8000366c:	00f707b3          	add	a5,a4,a5
80003670:	fcf42223          	sw	a5,-60(s0)
80003674:	fc842783          	lw	a5,-56(s0)
80003678:	32078e63          	beqz	a5,800039b4 <receive_ripng+0x1478>
8000367c:	fc442783          	lw	a5,-60(s0)
80003680:	0037c783          	lbu	a5,3(a5) # 80500003 <_bss_end+0x33da13>
80003684:	00579713          	slli	a4,a5,0x5
80003688:	510007b7          	lui	a5,0x51000
8000368c:	00f707b3          	add	a5,a4,a5
80003690:	0107a703          	lw	a4,16(a5) # 51000010 <_reset_vector-0x2efffff0>
80003694:	fcf44783          	lbu	a5,-49(s0)
80003698:	24f71a63          	bne	a4,a5,800038ec <receive_ripng+0x13b0>
8000369c:	fe442703          	lw	a4,-28(s0)
800036a0:	00070793          	mv	a5,a4
800036a4:	00279793          	slli	a5,a5,0x2
800036a8:	00e787b3          	add	a5,a5,a4
800036ac:	00279793          	slli	a5,a5,0x2
800036b0:	00078713          	mv	a4,a5
800036b4:	fd442783          	lw	a5,-44(s0)
800036b8:	00e78733          	add	a4,a5,a4
800036bc:	fc442783          	lw	a5,-60(s0)
800036c0:	0037c783          	lbu	a5,3(a5)
800036c4:	00579693          	slli	a3,a5,0x5
800036c8:	510007b7          	lui	a5,0x51000
800036cc:	00f687b3          	add	a5,a3,a5
800036d0:	00072583          	lw	a1,0(a4)
800036d4:	00472603          	lw	a2,4(a4)
800036d8:	00872683          	lw	a3,8(a4)
800036dc:	00c72703          	lw	a4,12(a4)
800036e0:	eab42823          	sw	a1,-336(s0)
800036e4:	eac42a23          	sw	a2,-332(s0)
800036e8:	ead42c23          	sw	a3,-328(s0)
800036ec:	eae42e23          	sw	a4,-324(s0)
800036f0:	0007a603          	lw	a2,0(a5) # 51000000 <_reset_vector-0x2f000000>
800036f4:	0047a683          	lw	a3,4(a5)
800036f8:	0087a703          	lw	a4,8(a5)
800036fc:	00c7a783          	lw	a5,12(a5)
80003700:	ecc42023          	sw	a2,-320(s0)
80003704:	ecd42223          	sw	a3,-316(s0)
80003708:	ece42423          	sw	a4,-312(s0)
8000370c:	ecf42623          	sw	a5,-308(s0)
80003710:	ec040713          	addi	a4,s0,-320
80003714:	eb040793          	addi	a5,s0,-336
80003718:	00070593          	mv	a1,a4
8000371c:	00078513          	mv	a0,a5
80003720:	e41fc0ef          	jal	ra,80000560 <in6_addr_equal>
80003724:	00050793          	mv	a5,a0
80003728:	1c078263          	beqz	a5,800038ec <receive_ripng+0x13b0>
8000372c:	fc442783          	lw	a5,-60(s0)
80003730:	0017c703          	lbu	a4,1(a5)
80003734:	00e00793          	li	a5,14
80003738:	14e7f063          	bgeu	a5,a4,80003878 <receive_ripng+0x133c>
8000373c:	f0042a23          	sw	zero,-236(s0)
80003740:	f0042c23          	sw	zero,-232(s0)
80003744:	f0042e23          	sw	zero,-228(s0)
80003748:	f2042023          	sw	zero,-224(s0)
8000374c:	f2042223          	sw	zero,-220(s0)
80003750:	f2042423          	sw	zero,-216(s0)
80003754:	f2042623          	sw	zero,-212(s0)
80003758:	f2042823          	sw	zero,-208(s0)
8000375c:	f2042a23          	sw	zero,-204(s0)
80003760:	f2042c23          	sw	zero,-200(s0)
80003764:	f2042e23          	sw	zero,-196(s0)
80003768:	f4042023          	sw	zero,-192(s0)
8000376c:	fe442703          	lw	a4,-28(s0)
80003770:	00070793          	mv	a5,a4
80003774:	00279793          	slli	a5,a5,0x2
80003778:	00e787b3          	add	a5,a5,a4
8000377c:	00279793          	slli	a5,a5,0x2
80003780:	00078713          	mv	a4,a5
80003784:	fd442783          	lw	a5,-44(s0)
80003788:	00e787b3          	add	a5,a5,a4
8000378c:	0007a603          	lw	a2,0(a5)
80003790:	0047a683          	lw	a3,4(a5)
80003794:	0087a703          	lw	a4,8(a5)
80003798:	00c7a783          	lw	a5,12(a5)
8000379c:	f0c42a23          	sw	a2,-236(s0)
800037a0:	f0d42c23          	sw	a3,-232(s0)
800037a4:	f0e42e23          	sw	a4,-228(s0)
800037a8:	f2f42023          	sw	a5,-224(s0)
800037ac:	fe442703          	lw	a4,-28(s0)
800037b0:	00070793          	mv	a5,a4
800037b4:	00279793          	slli	a5,a5,0x2
800037b8:	00e787b3          	add	a5,a5,a4
800037bc:	00279793          	slli	a5,a5,0x2
800037c0:	00078713          	mv	a4,a5
800037c4:	fd442783          	lw	a5,-44(s0)
800037c8:	00e787b3          	add	a5,a5,a4
800037cc:	0127c783          	lbu	a5,18(a5)
800037d0:	f2f42223          	sw	a5,-220(s0)
800037d4:	fcf44783          	lbu	a5,-49(s0)
800037d8:	f2f42423          	sw	a5,-216(s0)
800037dc:	f8842603          	lw	a2,-120(s0)
800037e0:	f8c42683          	lw	a3,-116(s0)
800037e4:	f9042703          	lw	a4,-112(s0)
800037e8:	f9442783          	lw	a5,-108(s0)
800037ec:	f2c42623          	sw	a2,-212(s0)
800037f0:	f2d42823          	sw	a3,-208(s0)
800037f4:	f2e42a23          	sw	a4,-204(s0)
800037f8:	f2f42c23          	sw	a5,-200(s0)
800037fc:	00100793          	li	a5,1
80003800:	f2f42e23          	sw	a5,-196(s0)
80003804:	f1442f03          	lw	t5,-236(s0)
80003808:	f1842e83          	lw	t4,-232(s0)
8000380c:	f1c42e03          	lw	t3,-228(s0)
80003810:	f2042303          	lw	t1,-224(s0)
80003814:	f2442883          	lw	a7,-220(s0)
80003818:	f2842803          	lw	a6,-216(s0)
8000381c:	f2c42503          	lw	a0,-212(s0)
80003820:	f3042583          	lw	a1,-208(s0)
80003824:	f3442603          	lw	a2,-204(s0)
80003828:	f3842683          	lw	a3,-200(s0)
8000382c:	f3c42703          	lw	a4,-196(s0)
80003830:	f4042783          	lw	a5,-192(s0)
80003834:	ebe42823          	sw	t5,-336(s0)
80003838:	ebd42a23          	sw	t4,-332(s0)
8000383c:	ebc42c23          	sw	t3,-328(s0)
80003840:	ea642e23          	sw	t1,-324(s0)
80003844:	ed142023          	sw	a7,-320(s0)
80003848:	ed042223          	sw	a6,-316(s0)
8000384c:	eca42423          	sw	a0,-312(s0)
80003850:	ecb42623          	sw	a1,-308(s0)
80003854:	ecc42823          	sw	a2,-304(s0)
80003858:	ecd42a23          	sw	a3,-300(s0)
8000385c:	ece42c23          	sw	a4,-296(s0)
80003860:	ecf42e23          	sw	a5,-292(s0)
80003864:	eb040793          	addi	a5,s0,-336
80003868:	00078593          	mv	a1,a5
8000386c:	00000513          	li	a0,0
80003870:	169050ef          	jal	ra,800091d8 <update>
80003874:	2780006f          	j	80003aec <receive_ripng+0x15b0>
80003878:	fe442703          	lw	a4,-28(s0)
8000387c:	00070793          	mv	a5,a4
80003880:	00279793          	slli	a5,a5,0x2
80003884:	00e787b3          	add	a5,a5,a4
80003888:	00279793          	slli	a5,a5,0x2
8000388c:	00078713          	mv	a4,a5
80003890:	fd442783          	lw	a5,-44(s0)
80003894:	00e787b3          	add	a5,a5,a4
80003898:	0137c783          	lbu	a5,19(a5)
8000389c:	00178793          	addi	a5,a5,1
800038a0:	0ff7f593          	andi	a1,a5,255
800038a4:	f6042c23          	sw	zero,-136(s0)
800038a8:	f6042e23          	sw	zero,-132(s0)
800038ac:	f8042023          	sw	zero,-128(s0)
800038b0:	f8042223          	sw	zero,-124(s0)
800038b4:	f7842603          	lw	a2,-136(s0)
800038b8:	f7c42683          	lw	a3,-132(s0)
800038bc:	f8042703          	lw	a4,-128(s0)
800038c0:	f8442783          	lw	a5,-124(s0)
800038c4:	eac42823          	sw	a2,-336(s0)
800038c8:	ead42a23          	sw	a3,-332(s0)
800038cc:	eae42c23          	sw	a4,-328(s0)
800038d0:	eaf42e23          	sw	a5,-324(s0)
800038d4:	eb040793          	addi	a5,s0,-336
800038d8:	00078693          	mv	a3,a5
800038dc:	0ff00613          	li	a2,255
800038e0:	fc842503          	lw	a0,-56(s0)
800038e4:	359050ef          	jal	ra,8000943c <update_leaf_info>
800038e8:	2040006f          	j	80003aec <receive_ripng+0x15b0>
800038ec:	fe442703          	lw	a4,-28(s0)
800038f0:	00070793          	mv	a5,a4
800038f4:	00279793          	slli	a5,a5,0x2
800038f8:	00e787b3          	add	a5,a5,a4
800038fc:	00279793          	slli	a5,a5,0x2
80003900:	00078713          	mv	a4,a5
80003904:	fd442783          	lw	a5,-44(s0)
80003908:	00e787b3          	add	a5,a5,a4
8000390c:	0137c783          	lbu	a5,19(a5)
80003910:	00178793          	addi	a5,a5,1
80003914:	fc442703          	lw	a4,-60(s0)
80003918:	00174703          	lbu	a4,1(a4)
8000391c:	1ce7d863          	bge	a5,a4,80003aec <receive_ripng+0x15b0>
80003920:	fe442703          	lw	a4,-28(s0)
80003924:	00070793          	mv	a5,a4
80003928:	00279793          	slli	a5,a5,0x2
8000392c:	00e787b3          	add	a5,a5,a4
80003930:	00279793          	slli	a5,a5,0x2
80003934:	00078713          	mv	a4,a5
80003938:	fd442783          	lw	a5,-44(s0)
8000393c:	00e787b3          	add	a5,a5,a4
80003940:	0137c703          	lbu	a4,19(a5)
80003944:	00e00793          	li	a5,14
80003948:	1ae7e263          	bltu	a5,a4,80003aec <receive_ripng+0x15b0>
8000394c:	fe442703          	lw	a4,-28(s0)
80003950:	00070793          	mv	a5,a4
80003954:	00279793          	slli	a5,a5,0x2
80003958:	00e787b3          	add	a5,a5,a4
8000395c:	00279793          	slli	a5,a5,0x2
80003960:	00078713          	mv	a4,a5
80003964:	fd442783          	lw	a5,-44(s0)
80003968:	00e787b3          	add	a5,a5,a4
8000396c:	0137c783          	lbu	a5,19(a5)
80003970:	00178793          	addi	a5,a5,1
80003974:	0ff7f593          	andi	a1,a5,255
80003978:	f8842603          	lw	a2,-120(s0)
8000397c:	f8c42683          	lw	a3,-116(s0)
80003980:	f9042703          	lw	a4,-112(s0)
80003984:	f9442783          	lw	a5,-108(s0)
80003988:	eac42823          	sw	a2,-336(s0)
8000398c:	ead42a23          	sw	a3,-332(s0)
80003990:	eae42c23          	sw	a4,-328(s0)
80003994:	eaf42e23          	sw	a5,-324(s0)
80003998:	eb040713          	addi	a4,s0,-336
8000399c:	fcf44783          	lbu	a5,-49(s0)
800039a0:	00070693          	mv	a3,a4
800039a4:	00078613          	mv	a2,a5
800039a8:	fc842503          	lw	a0,-56(s0)
800039ac:	291050ef          	jal	ra,8000943c <update_leaf_info>
800039b0:	13c0006f          	j	80003aec <receive_ripng+0x15b0>
800039b4:	f0042a23          	sw	zero,-236(s0)
800039b8:	f0042c23          	sw	zero,-232(s0)
800039bc:	f0042e23          	sw	zero,-228(s0)
800039c0:	f2042023          	sw	zero,-224(s0)
800039c4:	f2042223          	sw	zero,-220(s0)
800039c8:	f2042423          	sw	zero,-216(s0)
800039cc:	f2042623          	sw	zero,-212(s0)
800039d0:	f2042823          	sw	zero,-208(s0)
800039d4:	f2042a23          	sw	zero,-204(s0)
800039d8:	f2042c23          	sw	zero,-200(s0)
800039dc:	f2042e23          	sw	zero,-196(s0)
800039e0:	f4042023          	sw	zero,-192(s0)
800039e4:	fe442703          	lw	a4,-28(s0)
800039e8:	00070793          	mv	a5,a4
800039ec:	00279793          	slli	a5,a5,0x2
800039f0:	00e787b3          	add	a5,a5,a4
800039f4:	00279793          	slli	a5,a5,0x2
800039f8:	00078713          	mv	a4,a5
800039fc:	fd442783          	lw	a5,-44(s0)
80003a00:	00e787b3          	add	a5,a5,a4
80003a04:	0007a603          	lw	a2,0(a5)
80003a08:	0047a683          	lw	a3,4(a5)
80003a0c:	0087a703          	lw	a4,8(a5)
80003a10:	00c7a783          	lw	a5,12(a5)
80003a14:	f0c42a23          	sw	a2,-236(s0)
80003a18:	f0d42c23          	sw	a3,-232(s0)
80003a1c:	f0e42e23          	sw	a4,-228(s0)
80003a20:	f2f42023          	sw	a5,-224(s0)
80003a24:	fe442703          	lw	a4,-28(s0)
80003a28:	00070793          	mv	a5,a4
80003a2c:	00279793          	slli	a5,a5,0x2
80003a30:	00e787b3          	add	a5,a5,a4
80003a34:	00279793          	slli	a5,a5,0x2
80003a38:	00078713          	mv	a4,a5
80003a3c:	fd442783          	lw	a5,-44(s0)
80003a40:	00e787b3          	add	a5,a5,a4
80003a44:	0127c783          	lbu	a5,18(a5)
80003a48:	f2f42223          	sw	a5,-220(s0)
80003a4c:	fcf44783          	lbu	a5,-49(s0)
80003a50:	f2f42423          	sw	a5,-216(s0)
80003a54:	f8842603          	lw	a2,-120(s0)
80003a58:	f8c42683          	lw	a3,-116(s0)
80003a5c:	f9042703          	lw	a4,-112(s0)
80003a60:	f9442783          	lw	a5,-108(s0)
80003a64:	f2c42623          	sw	a2,-212(s0)
80003a68:	f2d42823          	sw	a3,-208(s0)
80003a6c:	f2e42a23          	sw	a4,-204(s0)
80003a70:	f2f42c23          	sw	a5,-200(s0)
80003a74:	00100793          	li	a5,1
80003a78:	f2f42e23          	sw	a5,-196(s0)
80003a7c:	f1442f03          	lw	t5,-236(s0)
80003a80:	f1842e83          	lw	t4,-232(s0)
80003a84:	f1c42e03          	lw	t3,-228(s0)
80003a88:	f2042303          	lw	t1,-224(s0)
80003a8c:	f2442883          	lw	a7,-220(s0)
80003a90:	f2842803          	lw	a6,-216(s0)
80003a94:	f2c42503          	lw	a0,-212(s0)
80003a98:	f3042583          	lw	a1,-208(s0)
80003a9c:	f3442603          	lw	a2,-204(s0)
80003aa0:	f3842683          	lw	a3,-200(s0)
80003aa4:	f3c42703          	lw	a4,-196(s0)
80003aa8:	f4042783          	lw	a5,-192(s0)
80003aac:	ebe42823          	sw	t5,-336(s0)
80003ab0:	ebd42a23          	sw	t4,-332(s0)
80003ab4:	ebc42c23          	sw	t3,-328(s0)
80003ab8:	ea642e23          	sw	t1,-324(s0)
80003abc:	ed142023          	sw	a7,-320(s0)
80003ac0:	ed042223          	sw	a6,-316(s0)
80003ac4:	eca42423          	sw	a0,-312(s0)
80003ac8:	ecb42623          	sw	a1,-308(s0)
80003acc:	ecc42823          	sw	a2,-304(s0)
80003ad0:	ecd42a23          	sw	a3,-300(s0)
80003ad4:	ece42c23          	sw	a4,-296(s0)
80003ad8:	ecf42e23          	sw	a5,-292(s0)
80003adc:	eb040793          	addi	a5,s0,-336
80003ae0:	00078593          	mv	a1,a5
80003ae4:	00100513          	li	a0,1
80003ae8:	6f0050ef          	jal	ra,800091d8 <update>
80003aec:	fe442783          	lw	a5,-28(s0)
80003af0:	00178793          	addi	a5,a5,1
80003af4:	fef42223          	sw	a5,-28(s0)
80003af8:	fe442703          	lw	a4,-28(s0)
80003afc:	fd042783          	lw	a5,-48(s0)
80003b00:	fef76c63          	bltu	a4,a5,800032f8 <receive_ripng+0xdbc>
80003b04:	05c0006f          	j	80003b60 <receive_ripng+0x1624>
80003b08:	710000ef          	jal	ra,80004218 <debug_ripng>
80003b0c:	0540006f          	j	80003b60 <receive_ripng+0x1624>
80003b10:	0500006f          	j	80003b60 <receive_ripng+0x1624>
80003b14:	fe042783          	lw	a5,-32(s0)
80003b18:	00878793          	addi	a5,a5,8
80003b1c:	f1440713          	addi	a4,s0,-236
80003b20:	00070593          	mv	a1,a4
80003b24:	00078513          	mv	a0,a5
80003b28:	4a9030ef          	jal	ra,800077d0 <printip>
80003b2c:	f1440793          	addi	a5,s0,-236
80003b30:	00078593          	mv	a1,a5
80003b34:	8000c7b7          	lui	a5,0x8000c
80003b38:	9c878513          	addi	a0,a5,-1592 # 8000b9c8 <_bss_end+0xffe493d8>
80003b3c:	de0fe0ef          	jal	ra,8000211c <printf_>
80003b40:	0300006f          	j	80003b70 <receive_ripng+0x1634>
80003b44:	fd842783          	lw	a5,-40(s0)
80003b48:	0007c783          	lbu	a5,0(a5)
80003b4c:	00078593          	mv	a1,a5
80003b50:	8000c7b7          	lui	a5,0x8000c
80003b54:	9f078513          	addi	a0,a5,-1552 # 8000b9f0 <_bss_end+0xffe49400>
80003b58:	dc4fe0ef          	jal	ra,8000211c <printf_>
80003b5c:	0140006f          	j	80003b70 <receive_ripng+0x1634>
80003b60:	0100006f          	j	80003b70 <receive_ripng+0x1634>
80003b64:	8000c7b7          	lui	a5,0x8000c
80003b68:	a1c78513          	addi	a0,a5,-1508 # 8000ba1c <_bss_end+0xffe4942c>
80003b6c:	db0fe0ef          	jal	ra,8000211c <printf_>
80003b70:	14c12083          	lw	ra,332(sp)
80003b74:	14812403          	lw	s0,328(sp)
80003b78:	14412483          	lw	s1,324(sp)
80003b7c:	15010113          	addi	sp,sp,336
80003b80:	00008067          	ret

80003b84 <_send_all_fill_dma>:
80003b84:	fd010113          	addi	sp,sp,-48
80003b88:	02112623          	sw	ra,44(sp)
80003b8c:	02812423          	sw	s0,40(sp)
80003b90:	02912223          	sw	s1,36(sp)
80003b94:	03010413          	addi	s0,sp,48
80003b98:	fca42e23          	sw	a0,-36(s0)
80003b9c:	00060493          	mv	s1,a2
80003ba0:	00068613          	mv	a2,a3
80003ba4:	00070693          	mv	a3,a4
80003ba8:	00078713          	mv	a4,a5
80003bac:	00058793          	mv	a5,a1
80003bb0:	fcf40da3          	sb	a5,-37(s0)
80003bb4:	00060793          	mv	a5,a2
80003bb8:	fcf41c23          	sh	a5,-40(s0)
80003bbc:	00068793          	mv	a5,a3
80003bc0:	fcf40d23          	sb	a5,-38(s0)
80003bc4:	00070793          	mv	a5,a4
80003bc8:	fcf40ba3          	sb	a5,-41(s0)
80003bcc:	fdc42783          	lw	a5,-36(s0)
80003bd0:	00e78793          	addi	a5,a5,14
80003bd4:	fef42623          	sw	a5,-20(s0)
80003bd8:	fdc42783          	lw	a5,-36(s0)
80003bdc:	03678793          	addi	a5,a5,54
80003be0:	fef42423          	sw	a5,-24(s0)
80003be4:	fdc42783          	lw	a5,-36(s0)
80003be8:	03e78793          	addi	a5,a5,62
80003bec:	fef42223          	sw	a5,-28(s0)
80003bf0:	fec42783          	lw	a5,-20(s0)
80003bf4:	06000713          	li	a4,96
80003bf8:	00e7a023          	sw	a4,0(a5)
80003bfc:	fd744783          	lbu	a5,-41(s0)
80003c00:	01079793          	slli	a5,a5,0x10
80003c04:	0107d793          	srli	a5,a5,0x10
80003c08:	00078713          	mv	a4,a5
80003c0c:	00070793          	mv	a5,a4
80003c10:	00279793          	slli	a5,a5,0x2
80003c14:	00e787b3          	add	a5,a5,a4
80003c18:	00279793          	slli	a5,a5,0x2
80003c1c:	01079793          	slli	a5,a5,0x10
80003c20:	0107d793          	srli	a5,a5,0x10
80003c24:	00c78793          	addi	a5,a5,12
80003c28:	01079793          	slli	a5,a5,0x10
80003c2c:	0107d793          	srli	a5,a5,0x10
80003c30:	00078513          	mv	a0,a5
80003c34:	89dfe0ef          	jal	ra,800024d0 <__bswap16>
80003c38:	00050793          	mv	a5,a0
80003c3c:	00078713          	mv	a4,a5
80003c40:	fec42783          	lw	a5,-20(s0)
80003c44:	00e79223          	sh	a4,4(a5)
80003c48:	fec42783          	lw	a5,-20(s0)
80003c4c:	01100713          	li	a4,17
80003c50:	00e78323          	sb	a4,6(a5)
80003c54:	fec42783          	lw	a5,-20(s0)
80003c58:	fff00713          	li	a4,-1
80003c5c:	00e783a3          	sb	a4,7(a5)
80003c60:	fda44783          	lbu	a5,-38(s0)
80003c64:	04078063          	beqz	a5,80003ca4 <_send_all_fill_dma+0x120>
80003c68:	fdb44703          	lbu	a4,-37(s0)
80003c6c:	006107b7          	lui	a5,0x610
80003c70:	00f707b3          	add	a5,a4,a5
80003c74:	00879793          	slli	a5,a5,0x8
80003c78:	00078713          	mv	a4,a5
80003c7c:	fec42783          	lw	a5,-20(s0)
80003c80:	02072583          	lw	a1,32(a4)
80003c84:	02472603          	lw	a2,36(a4)
80003c88:	02872683          	lw	a3,40(a4)
80003c8c:	02c72703          	lw	a4,44(a4)
80003c90:	00b7a423          	sw	a1,8(a5) # 610008 <_reset_vector-0x7f9efff8>
80003c94:	00c7a623          	sw	a2,12(a5)
80003c98:	00d7a823          	sw	a3,16(a5)
80003c9c:	00e7aa23          	sw	a4,20(a5)
80003ca0:	03c0006f          	j	80003cdc <_send_all_fill_dma+0x158>
80003ca4:	fdb44703          	lbu	a4,-37(s0)
80003ca8:	006107b7          	lui	a5,0x610
80003cac:	00f707b3          	add	a5,a4,a5
80003cb0:	00879793          	slli	a5,a5,0x8
80003cb4:	00078713          	mv	a4,a5
80003cb8:	fec42783          	lw	a5,-20(s0)
80003cbc:	01072583          	lw	a1,16(a4)
80003cc0:	01472603          	lw	a2,20(a4)
80003cc4:	01872683          	lw	a3,24(a4)
80003cc8:	01c72703          	lw	a4,28(a4)
80003ccc:	00b7a423          	sw	a1,8(a5) # 610008 <_reset_vector-0x7f9efff8>
80003cd0:	00c7a623          	sw	a2,12(a5)
80003cd4:	00d7a823          	sw	a3,16(a5)
80003cd8:	00e7aa23          	sw	a4,20(a5)
80003cdc:	fec42783          	lw	a5,-20(s0)
80003ce0:	0004a583          	lw	a1,0(s1)
80003ce4:	0044a603          	lw	a2,4(s1)
80003ce8:	0084a683          	lw	a3,8(s1)
80003cec:	00c4a703          	lw	a4,12(s1)
80003cf0:	00b7ac23          	sw	a1,24(a5)
80003cf4:	00c7ae23          	sw	a2,28(a5)
80003cf8:	02d7a023          	sw	a3,32(a5)
80003cfc:	02e7a223          	sw	a4,36(a5)
80003d00:	20900513          	li	a0,521
80003d04:	fccfe0ef          	jal	ra,800024d0 <__bswap16>
80003d08:	00050793          	mv	a5,a0
80003d0c:	00078713          	mv	a4,a5
80003d10:	fe842783          	lw	a5,-24(s0)
80003d14:	00e79023          	sh	a4,0(a5)
80003d18:	fe842783          	lw	a5,-24(s0)
80003d1c:	fd845703          	lhu	a4,-40(s0)
80003d20:	00e79123          	sh	a4,2(a5)
80003d24:	fd744783          	lbu	a5,-41(s0)
80003d28:	01079793          	slli	a5,a5,0x10
80003d2c:	0107d793          	srli	a5,a5,0x10
80003d30:	00078713          	mv	a4,a5
80003d34:	00070793          	mv	a5,a4
80003d38:	00279793          	slli	a5,a5,0x2
80003d3c:	00e787b3          	add	a5,a5,a4
80003d40:	00279793          	slli	a5,a5,0x2
80003d44:	01079793          	slli	a5,a5,0x10
80003d48:	0107d793          	srli	a5,a5,0x10
80003d4c:	00c78793          	addi	a5,a5,12
80003d50:	01079793          	slli	a5,a5,0x10
80003d54:	0107d793          	srli	a5,a5,0x10
80003d58:	00078513          	mv	a0,a5
80003d5c:	f74fe0ef          	jal	ra,800024d0 <__bswap16>
80003d60:	00050793          	mv	a5,a0
80003d64:	00078713          	mv	a4,a5
80003d68:	fe842783          	lw	a5,-24(s0)
80003d6c:	00e79223          	sh	a4,4(a5)
80003d70:	fe442783          	lw	a5,-28(s0)
80003d74:	00200713          	li	a4,2
80003d78:	00e78023          	sb	a4,0(a5)
80003d7c:	fe442783          	lw	a5,-28(s0)
80003d80:	00100713          	li	a4,1
80003d84:	00e780a3          	sb	a4,1(a5)
80003d88:	fe442783          	lw	a5,-28(s0)
80003d8c:	00079123          	sh	zero,2(a5)
80003d90:	fd744783          	lbu	a5,-41(s0)
80003d94:	01079793          	slli	a5,a5,0x10
80003d98:	0107d793          	srli	a5,a5,0x10
80003d9c:	00078713          	mv	a4,a5
80003da0:	00070793          	mv	a5,a4
80003da4:	00279793          	slli	a5,a5,0x2
80003da8:	00e787b3          	add	a5,a5,a4
80003dac:	00279793          	slli	a5,a5,0x2
80003db0:	01079793          	slli	a5,a5,0x10
80003db4:	0107d793          	srli	a5,a5,0x10
80003db8:	04278793          	addi	a5,a5,66
80003dbc:	01079713          	slli	a4,a5,0x10
80003dc0:	01075713          	srli	a4,a4,0x10
80003dc4:	680007b7          	lui	a5,0x68000
80003dc8:	00e7a023          	sw	a4,0(a5) # 68000000 <_reset_vector-0x18000000>
80003dcc:	fd744783          	lbu	a5,-41(s0)
80003dd0:	01079793          	slli	a5,a5,0x10
80003dd4:	0107d793          	srli	a5,a5,0x10
80003dd8:	00078713          	mv	a4,a5
80003ddc:	00070793          	mv	a5,a4
80003de0:	00279793          	slli	a5,a5,0x2
80003de4:	00e787b3          	add	a5,a5,a4
80003de8:	00279793          	slli	a5,a5,0x2
80003dec:	01079793          	slli	a5,a5,0x10
80003df0:	0107d793          	srli	a5,a5,0x10
80003df4:	03478793          	addi	a5,a5,52
80003df8:	01079793          	slli	a5,a5,0x10
80003dfc:	0107d793          	srli	a5,a5,0x10
80003e00:	00078593          	mv	a1,a5
80003e04:	fec42503          	lw	a0,-20(s0)
80003e08:	a70fc0ef          	jal	ra,80000078 <validateAndFillChecksum>
80003e0c:	00000013          	nop
80003e10:	02c12083          	lw	ra,44(sp)
80003e14:	02812403          	lw	s0,40(sp)
80003e18:	02412483          	lw	s1,36(sp)
80003e1c:	03010113          	addi	sp,sp,48
80003e20:	00008067          	ret

80003e24 <send_all_ripngentries>:
80003e24:	f6010113          	addi	sp,sp,-160
80003e28:	08112e23          	sw	ra,156(sp)
80003e2c:	08812c23          	sw	s0,152(sp)
80003e30:	08912a23          	sw	s1,148(sp)
80003e34:	0a010413          	addi	s0,sp,160
80003e38:	f6a42e23          	sw	a0,-132(s0)
80003e3c:	00058793          	mv	a5,a1
80003e40:	00060493          	mv	s1,a2
80003e44:	f6f40da3          	sb	a5,-133(s0)
80003e48:	00068793          	mv	a5,a3
80003e4c:	f6f41c23          	sh	a5,-136(s0)
80003e50:	00070793          	mv	a5,a4
80003e54:	f6f40d23          	sb	a5,-134(s0)
80003e58:	fecfc0ef          	jal	ra,80000644 <dma_send_request>
80003e5c:	fe042623          	sw	zero,-20(s0)
80003e60:	f7c42783          	lw	a5,-132(s0)
80003e64:	04278793          	addi	a5,a5,66
80003e68:	fef42223          	sw	a5,-28(s0)
80003e6c:	00100793          	li	a5,1
80003e70:	fef42423          	sw	a5,-24(s0)
80003e74:	3200006f          	j	80004194 <send_all_ripngentries+0x370>
80003e78:	fe842703          	lw	a4,-24(s0)
80003e7c:	00070793          	mv	a5,a4
80003e80:	00279793          	slli	a5,a5,0x2
80003e84:	00e787b3          	add	a5,a5,a4
80003e88:	00279793          	slli	a5,a5,0x2
80003e8c:	00078713          	mv	a4,a5
80003e90:	805007b7          	lui	a5,0x80500
80003e94:	00f707b3          	add	a5,a4,a5
80003e98:	0007c783          	lbu	a5,0(a5) # 80500000 <_bss_end+0x33da10>
80003e9c:	2e078663          	beqz	a5,80004188 <send_all_ripngentries+0x364>
80003ea0:	fe842703          	lw	a4,-24(s0)
80003ea4:	00070793          	mv	a5,a4
80003ea8:	00279793          	slli	a5,a5,0x2
80003eac:	00e787b3          	add	a5,a5,a4
80003eb0:	00279793          	slli	a5,a5,0x2
80003eb4:	00078713          	mv	a4,a5
80003eb8:	805007b7          	lui	a5,0x80500
80003ebc:	00f70733          	add	a4,a4,a5
80003ec0:	fec42683          	lw	a3,-20(s0)
80003ec4:	00068793          	mv	a5,a3
80003ec8:	00279793          	slli	a5,a5,0x2
80003ecc:	00d787b3          	add	a5,a5,a3
80003ed0:	00279793          	slli	a5,a5,0x2
80003ed4:	00078693          	mv	a3,a5
80003ed8:	fe442783          	lw	a5,-28(s0)
80003edc:	00d787b3          	add	a5,a5,a3
80003ee0:	00472583          	lw	a1,4(a4)
80003ee4:	00872603          	lw	a2,8(a4)
80003ee8:	00c72683          	lw	a3,12(a4)
80003eec:	01072703          	lw	a4,16(a4)
80003ef0:	00b7a023          	sw	a1,0(a5) # 80500000 <_bss_end+0x33da10>
80003ef4:	00c7a223          	sw	a2,4(a5)
80003ef8:	00d7a423          	sw	a3,8(a5)
80003efc:	00e7a623          	sw	a4,12(a5)
80003f00:	fe842703          	lw	a4,-24(s0)
80003f04:	00070793          	mv	a5,a4
80003f08:	00279793          	slli	a5,a5,0x2
80003f0c:	00e787b3          	add	a5,a5,a4
80003f10:	00279793          	slli	a5,a5,0x2
80003f14:	00078713          	mv	a4,a5
80003f18:	805007b7          	lui	a5,0x80500
80003f1c:	00f707b3          	add	a5,a4,a5
80003f20:	00478793          	addi	a5,a5,4 # 80500004 <_bss_end+0x33da14>
80003f24:	f8040713          	addi	a4,s0,-128
80003f28:	00070593          	mv	a1,a4
80003f2c:	00078513          	mv	a0,a5
80003f30:	0a1030ef          	jal	ra,800077d0 <printip>
80003f34:	fe842703          	lw	a4,-24(s0)
80003f38:	00070793          	mv	a5,a4
80003f3c:	00279793          	slli	a5,a5,0x2
80003f40:	00e787b3          	add	a5,a5,a4
80003f44:	00279793          	slli	a5,a5,0x2
80003f48:	00078713          	mv	a4,a5
80003f4c:	805007b7          	lui	a5,0x80500
80003f50:	00f707b3          	add	a5,a4,a5
80003f54:	0027c783          	lbu	a5,2(a5) # 80500002 <_bss_end+0x33da12>
80003f58:	00078713          	mv	a4,a5
80003f5c:	f8040793          	addi	a5,s0,-128
80003f60:	00070613          	mv	a2,a4
80003f64:	00078593          	mv	a1,a5
80003f68:	8000c7b7          	lui	a5,0x8000c
80003f6c:	a4878513          	addi	a0,a5,-1464 # 8000ba48 <_bss_end+0xffe49458>
80003f70:	9acfe0ef          	jal	ra,8000211c <printf_>
80003f74:	fec42703          	lw	a4,-20(s0)
80003f78:	00070793          	mv	a5,a4
80003f7c:	00279793          	slli	a5,a5,0x2
80003f80:	00e787b3          	add	a5,a5,a4
80003f84:	00279793          	slli	a5,a5,0x2
80003f88:	00078713          	mv	a4,a5
80003f8c:	fe442783          	lw	a5,-28(s0)
80003f90:	00e787b3          	add	a5,a5,a4
80003f94:	0007a583          	lw	a1,0(a5)
80003f98:	fec42703          	lw	a4,-20(s0)
80003f9c:	00070793          	mv	a5,a4
80003fa0:	00279793          	slli	a5,a5,0x2
80003fa4:	00e787b3          	add	a5,a5,a4
80003fa8:	00279793          	slli	a5,a5,0x2
80003fac:	00078713          	mv	a4,a5
80003fb0:	fe442783          	lw	a5,-28(s0)
80003fb4:	00e787b3          	add	a5,a5,a4
80003fb8:	0047a603          	lw	a2,4(a5)
80003fbc:	fec42703          	lw	a4,-20(s0)
80003fc0:	00070793          	mv	a5,a4
80003fc4:	00279793          	slli	a5,a5,0x2
80003fc8:	00e787b3          	add	a5,a5,a4
80003fcc:	00279793          	slli	a5,a5,0x2
80003fd0:	00078713          	mv	a4,a5
80003fd4:	fe442783          	lw	a5,-28(s0)
80003fd8:	00e787b3          	add	a5,a5,a4
80003fdc:	0087a683          	lw	a3,8(a5)
80003fe0:	fec42703          	lw	a4,-20(s0)
80003fe4:	00070793          	mv	a5,a4
80003fe8:	00279793          	slli	a5,a5,0x2
80003fec:	00e787b3          	add	a5,a5,a4
80003ff0:	00279793          	slli	a5,a5,0x2
80003ff4:	00078713          	mv	a4,a5
80003ff8:	fe442783          	lw	a5,-28(s0)
80003ffc:	00e787b3          	add	a5,a5,a4
80004000:	00c7a783          	lw	a5,12(a5)
80004004:	00078713          	mv	a4,a5
80004008:	8000c7b7          	lui	a5,0x8000c
8000400c:	a6478513          	addi	a0,a5,-1436 # 8000ba64 <_bss_end+0xffe49474>
80004010:	90cfe0ef          	jal	ra,8000211c <printf_>
80004014:	fec42703          	lw	a4,-20(s0)
80004018:	00070793          	mv	a5,a4
8000401c:	00279793          	slli	a5,a5,0x2
80004020:	00e787b3          	add	a5,a5,a4
80004024:	00279793          	slli	a5,a5,0x2
80004028:	00078713          	mv	a4,a5
8000402c:	fe442783          	lw	a5,-28(s0)
80004030:	00e787b3          	add	a5,a5,a4
80004034:	00079823          	sh	zero,16(a5)
80004038:	fe842703          	lw	a4,-24(s0)
8000403c:	00070793          	mv	a5,a4
80004040:	00279793          	slli	a5,a5,0x2
80004044:	00e787b3          	add	a5,a5,a4
80004048:	00279793          	slli	a5,a5,0x2
8000404c:	00078713          	mv	a4,a5
80004050:	805007b7          	lui	a5,0x80500
80004054:	00f706b3          	add	a3,a4,a5
80004058:	fec42703          	lw	a4,-20(s0)
8000405c:	00070793          	mv	a5,a4
80004060:	00279793          	slli	a5,a5,0x2
80004064:	00e787b3          	add	a5,a5,a4
80004068:	00279793          	slli	a5,a5,0x2
8000406c:	00078713          	mv	a4,a5
80004070:	fe442783          	lw	a5,-28(s0)
80004074:	00e787b3          	add	a5,a5,a4
80004078:	0026c703          	lbu	a4,2(a3)
8000407c:	00e78923          	sb	a4,18(a5) # 80500012 <_bss_end+0x33da22>
80004080:	fe842703          	lw	a4,-24(s0)
80004084:	00070793          	mv	a5,a4
80004088:	00279793          	slli	a5,a5,0x2
8000408c:	00e787b3          	add	a5,a5,a4
80004090:	00279793          	slli	a5,a5,0x2
80004094:	00078713          	mv	a4,a5
80004098:	805007b7          	lui	a5,0x80500
8000409c:	00f707b3          	add	a5,a4,a5
800040a0:	0037c783          	lbu	a5,3(a5) # 80500003 <_bss_end+0x33da13>
800040a4:	00579713          	slli	a4,a5,0x5
800040a8:	510007b7          	lui	a5,0x51000
800040ac:	00f707b3          	add	a5,a4,a5
800040b0:	0107a703          	lw	a4,16(a5) # 51000010 <_reset_vector-0x2efffff0>
800040b4:	f7b44783          	lbu	a5,-133(s0)
800040b8:	02f70663          	beq	a4,a5,800040e4 <send_all_ripngentries+0x2c0>
800040bc:	fe842703          	lw	a4,-24(s0)
800040c0:	00070793          	mv	a5,a4
800040c4:	00279793          	slli	a5,a5,0x2
800040c8:	00e787b3          	add	a5,a5,a4
800040cc:	00279793          	slli	a5,a5,0x2
800040d0:	00078713          	mv	a4,a5
800040d4:	805007b7          	lui	a5,0x80500
800040d8:	00f707b3          	add	a5,a4,a5
800040dc:	0017c703          	lbu	a4,1(a5) # 80500001 <_bss_end+0x33da11>
800040e0:	0080006f          	j	800040e8 <send_all_ripngentries+0x2c4>
800040e4:	01000713          	li	a4,16
800040e8:	fec42683          	lw	a3,-20(s0)
800040ec:	00068793          	mv	a5,a3
800040f0:	00279793          	slli	a5,a5,0x2
800040f4:	00d787b3          	add	a5,a5,a3
800040f8:	00279793          	slli	a5,a5,0x2
800040fc:	00078693          	mv	a3,a5
80004100:	fe442783          	lw	a5,-28(s0)
80004104:	00d787b3          	add	a5,a5,a3
80004108:	00e789a3          	sb	a4,19(a5)
8000410c:	fec42783          	lw	a5,-20(s0)
80004110:	00178793          	addi	a5,a5,1
80004114:	fef42623          	sw	a5,-20(s0)
80004118:	fec42703          	lw	a4,-20(s0)
8000411c:	04700793          	li	a5,71
80004120:	06f71463          	bne	a4,a5,80004188 <send_all_ripngentries+0x364>
80004124:	fec42783          	lw	a5,-20(s0)
80004128:	0ff7f513          	andi	a0,a5,255
8000412c:	0004a603          	lw	a2,0(s1)
80004130:	0044a683          	lw	a3,4(s1)
80004134:	0084a703          	lw	a4,8(s1)
80004138:	00c4a783          	lw	a5,12(s1)
8000413c:	f6c42023          	sw	a2,-160(s0)
80004140:	f6d42223          	sw	a3,-156(s0)
80004144:	f6e42423          	sw	a4,-152(s0)
80004148:	f6f42623          	sw	a5,-148(s0)
8000414c:	f7a44703          	lbu	a4,-134(s0)
80004150:	f7845683          	lhu	a3,-136(s0)
80004154:	f6040613          	addi	a2,s0,-160
80004158:	f7b44583          	lbu	a1,-133(s0)
8000415c:	00050793          	mv	a5,a0
80004160:	f7c42503          	lw	a0,-132(s0)
80004164:	a21ff0ef          	jal	ra,80003b84 <_send_all_fill_dma>
80004168:	f7b44783          	lbu	a5,-133(s0)
8000416c:	00078513          	mv	a0,a5
80004170:	dd8fc0ef          	jal	ra,80000748 <dma_set_out_port>
80004174:	d1cfc0ef          	jal	ra,80000690 <dma_send_finish>
80004178:	cccfc0ef          	jal	ra,80000644 <dma_send_request>
8000417c:	fec42783          	lw	a5,-20(s0)
80004180:	fb978793          	addi	a5,a5,-71
80004184:	fef42623          	sw	a5,-20(s0)
80004188:	fe842783          	lw	a5,-24(s0)
8000418c:	00178793          	addi	a5,a5,1
80004190:	fef42423          	sw	a5,-24(s0)
80004194:	801c27b7          	lui	a5,0x801c2
80004198:	5d87a783          	lw	a5,1496(a5) # 801c25d8 <_bss_end+0xffffffe8>
8000419c:	fe842703          	lw	a4,-24(s0)
800041a0:	cce7fce3          	bgeu	a5,a4,80003e78 <send_all_ripngentries+0x54>
800041a4:	fec42783          	lw	a5,-20(s0)
800041a8:	04078c63          	beqz	a5,80004200 <send_all_ripngentries+0x3dc>
800041ac:	fec42783          	lw	a5,-20(s0)
800041b0:	0ff7f513          	andi	a0,a5,255
800041b4:	0004a603          	lw	a2,0(s1)
800041b8:	0044a683          	lw	a3,4(s1)
800041bc:	0084a703          	lw	a4,8(s1)
800041c0:	00c4a783          	lw	a5,12(s1)
800041c4:	f6c42023          	sw	a2,-160(s0)
800041c8:	f6d42223          	sw	a3,-156(s0)
800041cc:	f6e42423          	sw	a4,-152(s0)
800041d0:	f6f42623          	sw	a5,-148(s0)
800041d4:	f7a44703          	lbu	a4,-134(s0)
800041d8:	f7845683          	lhu	a3,-136(s0)
800041dc:	f6040613          	addi	a2,s0,-160
800041e0:	f7b44583          	lbu	a1,-133(s0)
800041e4:	00050793          	mv	a5,a0
800041e8:	f7c42503          	lw	a0,-132(s0)
800041ec:	999ff0ef          	jal	ra,80003b84 <_send_all_fill_dma>
800041f0:	f7b44783          	lbu	a5,-133(s0)
800041f4:	00078513          	mv	a0,a5
800041f8:	d50fc0ef          	jal	ra,80000748 <dma_set_out_port>
800041fc:	c94fc0ef          	jal	ra,80000690 <dma_send_finish>
80004200:	00000013          	nop
80004204:	09c12083          	lw	ra,156(sp)
80004208:	09812403          	lw	s0,152(sp)
8000420c:	09412483          	lw	s1,148(sp)
80004210:	0a010113          	addi	sp,sp,160
80004214:	00008067          	ret

80004218 <debug_ripng>:
80004218:	ff010113          	addi	sp,sp,-16
8000421c:	00812623          	sw	s0,12(sp)
80004220:	01010413          	addi	s0,sp,16
80004224:	00000013          	nop
80004228:	00c12403          	lw	s0,12(sp)
8000422c:	01010113          	addi	sp,sp,16
80004230:	00008067          	ret

80004234 <ripng_timeout>:
80004234:	fc010113          	addi	sp,sp,-64
80004238:	02112e23          	sw	ra,60(sp)
8000423c:	02812c23          	sw	s0,56(sp)
80004240:	04010413          	addi	s0,sp,64
80004244:	fca42e23          	sw	a0,-36(s0)
80004248:	fcb42c23          	sw	a1,-40(s0)
8000424c:	00000513          	li	a0,0
80004250:	001000ef          	jal	ra,80004a50 <mainloop>
80004254:	fe0407a3          	sb	zero,-17(s0)
80004258:	0680006f          	j	800042c0 <ripng_timeout+0x8c>
8000425c:	20900513          	li	a0,521
80004260:	a70fe0ef          	jal	ra,800024d0 <__bswap16>
80004264:	00050793          	mv	a5,a0
80004268:	00078593          	mv	a1,a5
8000426c:	8000c7b7          	lui	a5,0x8000c
80004270:	8a078793          	addi	a5,a5,-1888 # 8000b8a0 <_bss_end+0xffe492b0>
80004274:	0007a603          	lw	a2,0(a5)
80004278:	0047a683          	lw	a3,4(a5)
8000427c:	0087a703          	lw	a4,8(a5)
80004280:	00c7a783          	lw	a5,12(a5)
80004284:	fcc42023          	sw	a2,-64(s0)
80004288:	fcd42223          	sw	a3,-60(s0)
8000428c:	fce42423          	sw	a4,-56(s0)
80004290:	fcf42623          	sw	a5,-52(s0)
80004294:	fc040613          	addi	a2,s0,-64
80004298:	fef44783          	lbu	a5,-17(s0)
8000429c:	00000713          	li	a4,0
800042a0:	00058693          	mv	a3,a1
800042a4:	00078593          	mv	a1,a5
800042a8:	680007b7          	lui	a5,0x68000
800042ac:	00478513          	addi	a0,a5,4 # 68000004 <_reset_vector-0x17fffffc>
800042b0:	b75ff0ef          	jal	ra,80003e24 <send_all_ripngentries>
800042b4:	fef44783          	lbu	a5,-17(s0)
800042b8:	00178793          	addi	a5,a5,1
800042bc:	fef407a3          	sb	a5,-17(s0)
800042c0:	fef44703          	lbu	a4,-17(s0)
800042c4:	00300793          	li	a5,3
800042c8:	f8e7fae3          	bgeu	a5,a4,8000425c <ripng_timeout+0x28>
800042cc:	b50fc0ef          	jal	ra,8000061c <dma_lock_release>
800042d0:	fd842783          	lw	a5,-40(s0)
800042d4:	00078593          	mv	a1,a5
800042d8:	fdc42503          	lw	a0,-36(s0)
800042dc:	009020ef          	jal	ra,80006ae4 <timer_start>
800042e0:	00000013          	nop
800042e4:	03c12083          	lw	ra,60(sp)
800042e8:	03812403          	lw	s0,56(sp)
800042ec:	04010113          	addi	sp,sp,64
800042f0:	00008067          	ret

800042f4 <ripng_init>:
800042f4:	fd010113          	addi	sp,sp,-48
800042f8:	02112623          	sw	ra,44(sp)
800042fc:	02812423          	sw	s0,40(sp)
80004300:	03010413          	addi	s0,sp,48
80004304:	00000513          	li	a0,0
80004308:	748000ef          	jal	ra,80004a50 <mainloop>
8000430c:	680007b7          	lui	a5,0x68000
80004310:	01278793          	addi	a5,a5,18 # 68000012 <_reset_vector-0x17ffffee>
80004314:	fef42423          	sw	a5,-24(s0)
80004318:	680007b7          	lui	a5,0x68000
8000431c:	03a78793          	addi	a5,a5,58 # 6800003a <_reset_vector-0x17ffffc6>
80004320:	fef42223          	sw	a5,-28(s0)
80004324:	680007b7          	lui	a5,0x68000
80004328:	04278793          	addi	a5,a5,66 # 68000042 <_reset_vector-0x17ffffbe>
8000432c:	fef42023          	sw	a5,-32(s0)
80004330:	680007b7          	lui	a5,0x68000
80004334:	04678793          	addi	a5,a5,70 # 68000046 <_reset_vector-0x17ffffba>
80004338:	fcf42e23          	sw	a5,-36(s0)
8000433c:	fe0407a3          	sb	zero,-17(s0)
80004340:	1a00006f          	j	800044e0 <ripng_init+0x1ec>
80004344:	b00fc0ef          	jal	ra,80000644 <dma_send_request>
80004348:	fe842783          	lw	a5,-24(s0)
8000434c:	06000713          	li	a4,96
80004350:	00e7a023          	sw	a4,0(a5)
80004354:	02000513          	li	a0,32
80004358:	978fe0ef          	jal	ra,800024d0 <__bswap16>
8000435c:	00050793          	mv	a5,a0
80004360:	00078713          	mv	a4,a5
80004364:	fe842783          	lw	a5,-24(s0)
80004368:	00e79223          	sh	a4,4(a5)
8000436c:	fe842783          	lw	a5,-24(s0)
80004370:	01100713          	li	a4,17
80004374:	00e78323          	sb	a4,6(a5)
80004378:	fe842783          	lw	a5,-24(s0)
8000437c:	fff00713          	li	a4,-1
80004380:	00e783a3          	sb	a4,7(a5)
80004384:	fef44703          	lbu	a4,-17(s0)
80004388:	006107b7          	lui	a5,0x610
8000438c:	00f707b3          	add	a5,a4,a5
80004390:	00879793          	slli	a5,a5,0x8
80004394:	00078713          	mv	a4,a5
80004398:	fe842783          	lw	a5,-24(s0)
8000439c:	01072583          	lw	a1,16(a4)
800043a0:	01472603          	lw	a2,20(a4)
800043a4:	01872683          	lw	a3,24(a4)
800043a8:	01c72703          	lw	a4,28(a4)
800043ac:	00b7a423          	sw	a1,8(a5) # 610008 <_reset_vector-0x7f9efff8>
800043b0:	00c7a623          	sw	a2,12(a5)
800043b4:	00d7a823          	sw	a3,16(a5)
800043b8:	00e7aa23          	sw	a4,20(a5)
800043bc:	fe842783          	lw	a5,-24(s0)
800043c0:	8000c737          	lui	a4,0x8000c
800043c4:	8a070713          	addi	a4,a4,-1888 # 8000b8a0 <_bss_end+0xffe492b0>
800043c8:	00072583          	lw	a1,0(a4)
800043cc:	00472603          	lw	a2,4(a4)
800043d0:	00872683          	lw	a3,8(a4)
800043d4:	00c72703          	lw	a4,12(a4)
800043d8:	00b7ac23          	sw	a1,24(a5)
800043dc:	00c7ae23          	sw	a2,28(a5)
800043e0:	02d7a023          	sw	a3,32(a5)
800043e4:	02e7a223          	sw	a4,36(a5)
800043e8:	20900513          	li	a0,521
800043ec:	8e4fe0ef          	jal	ra,800024d0 <__bswap16>
800043f0:	00050793          	mv	a5,a0
800043f4:	00078713          	mv	a4,a5
800043f8:	fe442783          	lw	a5,-28(s0)
800043fc:	00e79023          	sh	a4,0(a5)
80004400:	20900513          	li	a0,521
80004404:	8ccfe0ef          	jal	ra,800024d0 <__bswap16>
80004408:	00050793          	mv	a5,a0
8000440c:	00078713          	mv	a4,a5
80004410:	fe442783          	lw	a5,-28(s0)
80004414:	00e79123          	sh	a4,2(a5)
80004418:	02000513          	li	a0,32
8000441c:	8b4fe0ef          	jal	ra,800024d0 <__bswap16>
80004420:	00050793          	mv	a5,a0
80004424:	00078713          	mv	a4,a5
80004428:	fe442783          	lw	a5,-28(s0)
8000442c:	00e79223          	sh	a4,4(a5)
80004430:	fe042783          	lw	a5,-32(s0)
80004434:	00100713          	li	a4,1
80004438:	00e78023          	sb	a4,0(a5)
8000443c:	fe042783          	lw	a5,-32(s0)
80004440:	00100713          	li	a4,1
80004444:	00e780a3          	sb	a4,1(a5)
80004448:	fe042783          	lw	a5,-32(s0)
8000444c:	00079123          	sh	zero,2(a5)
80004450:	fdc42783          	lw	a5,-36(s0)
80004454:	00079023          	sh	zero,0(a5)
80004458:	fdc42783          	lw	a5,-36(s0)
8000445c:	00079123          	sh	zero,2(a5)
80004460:	fdc42783          	lw	a5,-36(s0)
80004464:	00079223          	sh	zero,4(a5)
80004468:	fdc42783          	lw	a5,-36(s0)
8000446c:	00079323          	sh	zero,6(a5)
80004470:	fdc42783          	lw	a5,-36(s0)
80004474:	00079423          	sh	zero,8(a5)
80004478:	fdc42783          	lw	a5,-36(s0)
8000447c:	00079523          	sh	zero,10(a5)
80004480:	fdc42783          	lw	a5,-36(s0)
80004484:	00079623          	sh	zero,12(a5)
80004488:	fdc42783          	lw	a5,-36(s0)
8000448c:	00079723          	sh	zero,14(a5)
80004490:	fdc42783          	lw	a5,-36(s0)
80004494:	00079823          	sh	zero,16(a5)
80004498:	fdc42783          	lw	a5,-36(s0)
8000449c:	00078923          	sb	zero,18(a5)
800044a0:	fdc42783          	lw	a5,-36(s0)
800044a4:	00f00713          	li	a4,15
800044a8:	00e789a3          	sb	a4,19(a5)
800044ac:	680007b7          	lui	a5,0x68000
800044b0:	05600713          	li	a4,86
800044b4:	00e7a023          	sw	a4,0(a5) # 68000000 <_reset_vector-0x18000000>
800044b8:	04800593          	li	a1,72
800044bc:	fe842503          	lw	a0,-24(s0)
800044c0:	bb9fb0ef          	jal	ra,80000078 <validateAndFillChecksum>
800044c4:	fef44783          	lbu	a5,-17(s0)
800044c8:	00078513          	mv	a0,a5
800044cc:	a7cfc0ef          	jal	ra,80000748 <dma_set_out_port>
800044d0:	9c0fc0ef          	jal	ra,80000690 <dma_send_finish>
800044d4:	fef44783          	lbu	a5,-17(s0)
800044d8:	00178793          	addi	a5,a5,1
800044dc:	fef407a3          	sb	a5,-17(s0)
800044e0:	fef44703          	lbu	a4,-17(s0)
800044e4:	00300793          	li	a5,3
800044e8:	e4e7fee3          	bgeu	a5,a4,80004344 <ripng_init+0x50>
800044ec:	930fc0ef          	jal	ra,8000061c <dma_lock_release>
800044f0:	00200593          	li	a1,2
800044f4:	11e1a7b7          	lui	a5,0x11e1a
800044f8:	30078513          	addi	a0,a5,768 # 11e1a300 <_reset_vector-0x6e1e5d00>
800044fc:	36c020ef          	jal	ra,80006868 <timer_init>
80004500:	fca42c23          	sw	a0,-40(s0)
80004504:	800047b7          	lui	a5,0x80004
80004508:	23478593          	addi	a1,a5,564 # 80004234 <_bss_end+0xffe41c44>
8000450c:	fd842503          	lw	a0,-40(s0)
80004510:	460020ef          	jal	ra,80006970 <timer_set_timeout>
80004514:	00100593          	li	a1,1
80004518:	fd842503          	lw	a0,-40(s0)
8000451c:	5c8020ef          	jal	ra,80006ae4 <timer_start>
80004520:	00000013          	nop
80004524:	02c12083          	lw	ra,44(sp)
80004528:	02812403          	lw	s0,40(sp)
8000452c:	03010113          	addi	sp,sp,48
80004530:	00008067          	ret

80004534 <__bswap16>:
80004534:	fe010113          	addi	sp,sp,-32
80004538:	00812e23          	sw	s0,28(sp)
8000453c:	02010413          	addi	s0,sp,32
80004540:	00050793          	mv	a5,a0
80004544:	fef41723          	sh	a5,-18(s0)
80004548:	fee45783          	lhu	a5,-18(s0)
8000454c:	0087d793          	srli	a5,a5,0x8
80004550:	01079793          	slli	a5,a5,0x10
80004554:	0107d793          	srli	a5,a5,0x10
80004558:	01079713          	slli	a4,a5,0x10
8000455c:	41075713          	srai	a4,a4,0x10
80004560:	fee45783          	lhu	a5,-18(s0)
80004564:	00879793          	slli	a5,a5,0x8
80004568:	01079793          	slli	a5,a5,0x10
8000456c:	4107d793          	srai	a5,a5,0x10
80004570:	f007f793          	andi	a5,a5,-256
80004574:	01079793          	slli	a5,a5,0x10
80004578:	4107d793          	srai	a5,a5,0x10
8000457c:	00f767b3          	or	a5,a4,a5
80004580:	01079793          	slli	a5,a5,0x10
80004584:	4107d793          	srai	a5,a5,0x10
80004588:	01079793          	slli	a5,a5,0x10
8000458c:	0107d793          	srli	a5,a5,0x10
80004590:	00078513          	mv	a0,a5
80004594:	01c12403          	lw	s0,28(sp)
80004598:	02010113          	addi	sp,sp,32
8000459c:	00008067          	ret

800045a0 <init_port_config>:
800045a0:	fe010113          	addi	sp,sp,-32
800045a4:	00812e23          	sw	s0,28(sp)
800045a8:	02010413          	addi	s0,sp,32
800045ac:	fe0407a3          	sb	zero,-17(s0)
800045b0:	1300006f          	j	800046e0 <init_port_config+0x140>
800045b4:	fef44703          	lbu	a4,-17(s0)
800045b8:	006107b7          	lui	a5,0x610
800045bc:	00f707b3          	add	a5,a4,a5
800045c0:	00879793          	slli	a5,a5,0x8
800045c4:	fef42423          	sw	a5,-24(s0)
800045c8:	fef44703          	lbu	a4,-17(s0)
800045cc:	006107b7          	lui	a5,0x610
800045d0:	00f707b3          	add	a5,a4,a5
800045d4:	00879793          	slli	a5,a5,0x8
800045d8:	02078793          	addi	a5,a5,32 # 610020 <_reset_vector-0x7f9effe0>
800045dc:	fef42223          	sw	a5,-28(s0)
800045e0:	fe040723          	sb	zero,-18(s0)
800045e4:	0340006f          	j	80004618 <init_port_config+0x78>
800045e8:	fee44703          	lbu	a4,-18(s0)
800045ec:	fee44783          	lbu	a5,-18(s0)
800045f0:	fe842683          	lw	a3,-24(s0)
800045f4:	00f687b3          	add	a5,a3,a5
800045f8:	8000c6b7          	lui	a3,0x8000c
800045fc:	22868693          	addi	a3,a3,552 # 8000c228 <_bss_end+0xffe49c38>
80004600:	00e68733          	add	a4,a3,a4
80004604:	00074703          	lbu	a4,0(a4)
80004608:	00e78023          	sb	a4,0(a5)
8000460c:	fee44783          	lbu	a5,-18(s0)
80004610:	00178793          	addi	a5,a5,1
80004614:	fef40723          	sb	a5,-18(s0)
80004618:	fee44703          	lbu	a4,-18(s0)
8000461c:	00500793          	li	a5,5
80004620:	fce7f4e3          	bgeu	a5,a4,800045e8 <init_port_config+0x48>
80004624:	fe842783          	lw	a5,-24(s0)
80004628:	00578793          	addi	a5,a5,5
8000462c:	0007c783          	lbu	a5,0(a5)
80004630:	0ff7f693          	andi	a3,a5,255
80004634:	fe842783          	lw	a5,-24(s0)
80004638:	00578793          	addi	a5,a5,5
8000463c:	fef44703          	lbu	a4,-17(s0)
80004640:	00e68733          	add	a4,a3,a4
80004644:	0ff77713          	andi	a4,a4,255
80004648:	00e78023          	sb	a4,0(a5)
8000464c:	fef44703          	lbu	a4,-17(s0)
80004650:	006107b7          	lui	a5,0x610
80004654:	00f707b3          	add	a5,a4,a5
80004658:	00879793          	slli	a5,a5,0x8
8000465c:	00078713          	mv	a4,a5
80004660:	00100793          	li	a5,1
80004664:	00f72423          	sw	a5,8(a4)
80004668:	fe0406a3          	sb	zero,-19(s0)
8000466c:	0340006f          	j	800046a0 <init_port_config+0x100>
80004670:	fed44703          	lbu	a4,-19(s0)
80004674:	fed44783          	lbu	a5,-19(s0)
80004678:	fe442683          	lw	a3,-28(s0)
8000467c:	00f687b3          	add	a5,a3,a5
80004680:	8000c6b7          	lui	a3,0x8000c
80004684:	fb468693          	addi	a3,a3,-76 # 8000bfb4 <_bss_end+0xffe499c4>
80004688:	00e68733          	add	a4,a3,a4
8000468c:	00074703          	lbu	a4,0(a4)
80004690:	00e78023          	sb	a4,0(a5) # 610000 <_reset_vector-0x7f9f0000>
80004694:	fed44783          	lbu	a5,-19(s0)
80004698:	00178793          	addi	a5,a5,1
8000469c:	fef406a3          	sb	a5,-19(s0)
800046a0:	fed44703          	lbu	a4,-19(s0)
800046a4:	00f00793          	li	a5,15
800046a8:	fce7f4e3          	bgeu	a5,a4,80004670 <init_port_config+0xd0>
800046ac:	fe442783          	lw	a5,-28(s0)
800046b0:	00778793          	addi	a5,a5,7
800046b4:	0007c783          	lbu	a5,0(a5)
800046b8:	0ff7f693          	andi	a3,a5,255
800046bc:	fe442783          	lw	a5,-28(s0)
800046c0:	00778793          	addi	a5,a5,7
800046c4:	fef44703          	lbu	a4,-17(s0)
800046c8:	00e68733          	add	a4,a3,a4
800046cc:	0ff77713          	andi	a4,a4,255
800046d0:	00e78023          	sb	a4,0(a5)
800046d4:	fef44783          	lbu	a5,-17(s0)
800046d8:	00178793          	addi	a5,a5,1
800046dc:	fef407a3          	sb	a5,-17(s0)
800046e0:	fef44703          	lbu	a4,-17(s0)
800046e4:	00300793          	li	a5,3
800046e8:	ece7f6e3          	bgeu	a5,a4,800045b4 <init_port_config+0x14>
800046ec:	00000013          	nop
800046f0:	00000013          	nop
800046f4:	01c12403          	lw	s0,28(sp)
800046f8:	02010113          	addi	sp,sp,32
800046fc:	00008067          	ret

80004700 <icmp_error_gen>:
80004700:	fd010113          	addi	sp,sp,-48
80004704:	02112623          	sw	ra,44(sp)
80004708:	02812423          	sw	s0,40(sp)
8000470c:	03010413          	addi	s0,sp,48
80004710:	ec9fb0ef          	jal	ra,800005d8 <dma_lock_request>
80004714:	f31fb0ef          	jal	ra,80000644 <dma_send_request>
80004718:	680007b7          	lui	a5,0x68000
8000471c:	0007a783          	lw	a5,0(a5) # 68000000 <_reset_vector-0x18000000>
80004720:	03078713          	addi	a4,a5,48
80004724:	50000793          	li	a5,1280
80004728:	00e7ea63          	bltu	a5,a4,8000473c <icmp_error_gen+0x3c>
8000472c:	680007b7          	lui	a5,0x68000
80004730:	0007a783          	lw	a5,0(a5) # 68000000 <_reset_vector-0x18000000>
80004734:	03078793          	addi	a5,a5,48
80004738:	0080006f          	j	80004740 <icmp_error_gen+0x40>
8000473c:	50000793          	li	a5,1280
80004740:	fef42423          	sw	a5,-24(s0)
80004744:	680007b7          	lui	a5,0x68000
80004748:	fe842703          	lw	a4,-24(s0)
8000474c:	00e7a023          	sw	a4,0(a5) # 68000000 <_reset_vector-0x18000000>
80004750:	fe842783          	lw	a5,-24(s0)
80004754:	fff78793          	addi	a5,a5,-1
80004758:	fef42623          	sw	a5,-20(s0)
8000475c:	03c0006f          	j	80004798 <icmp_error_gen+0x98>
80004760:	fec42703          	lw	a4,-20(s0)
80004764:	680007b7          	lui	a5,0x68000
80004768:	fd478793          	addi	a5,a5,-44 # 67ffffd4 <_reset_vector-0x1800002c>
8000476c:	00f70733          	add	a4,a4,a5
80004770:	fec42683          	lw	a3,-20(s0)
80004774:	680007b7          	lui	a5,0x68000
80004778:	00478793          	addi	a5,a5,4 # 68000004 <_reset_vector-0x17fffffc>
8000477c:	00f687b3          	add	a5,a3,a5
80004780:	00074703          	lbu	a4,0(a4)
80004784:	0ff77713          	andi	a4,a4,255
80004788:	00e78023          	sb	a4,0(a5)
8000478c:	fec42783          	lw	a5,-20(s0)
80004790:	fff78793          	addi	a5,a5,-1
80004794:	fef42623          	sw	a5,-20(s0)
80004798:	fec42703          	lw	a4,-20(s0)
8000479c:	03d00793          	li	a5,61
800047a0:	fce7e0e3          	bltu	a5,a4,80004760 <icmp_error_gen+0x60>
800047a4:	f79fb0ef          	jal	ra,8000071c <dma_get_receive_port>
800047a8:	00050793          	mv	a5,a0
800047ac:	fef403a3          	sb	a5,-25(s0)
800047b0:	680007b7          	lui	a5,0x68000
800047b4:	00478793          	addi	a5,a5,4 # 68000004 <_reset_vector-0x17fffffc>
800047b8:	fef42023          	sw	a5,-32(s0)
800047bc:	680007b7          	lui	a5,0x68000
800047c0:	01278793          	addi	a5,a5,18 # 68000012 <_reset_vector-0x17ffffee>
800047c4:	fcf42e23          	sw	a5,-36(s0)
800047c8:	680007b7          	lui	a5,0x68000
800047cc:	03a78793          	addi	a5,a5,58 # 6800003a <_reset_vector-0x17ffffc6>
800047d0:	fcf42c23          	sw	a5,-40(s0)
800047d4:	fe042783          	lw	a5,-32(s0)
800047d8:	00c7d783          	lhu	a5,12(a5)
800047dc:	0ff7f713          	andi	a4,a5,255
800047e0:	fd842783          	lw	a5,-40(s0)
800047e4:	00e78023          	sb	a4,0(a5)
800047e8:	fe042783          	lw	a5,-32(s0)
800047ec:	00c7d783          	lhu	a5,12(a5)
800047f0:	0087d793          	srli	a5,a5,0x8
800047f4:	01079793          	slli	a5,a5,0x10
800047f8:	0107d793          	srli	a5,a5,0x10
800047fc:	0ff7f713          	andi	a4,a5,255
80004800:	fd842783          	lw	a5,-40(s0)
80004804:	00e780a3          	sb	a4,1(a5)
80004808:	fd842783          	lw	a5,-40(s0)
8000480c:	00079123          	sh	zero,2(a5)
80004810:	fd842783          	lw	a5,-40(s0)
80004814:	0007a223          	sw	zero,4(a5)
80004818:	fdc42783          	lw	a5,-36(s0)
8000481c:	06000713          	li	a4,96
80004820:	00e7a023          	sw	a4,0(a5)
80004824:	fe842783          	lw	a5,-24(s0)
80004828:	01079793          	slli	a5,a5,0x10
8000482c:	0107d793          	srli	a5,a5,0x10
80004830:	fca78793          	addi	a5,a5,-54
80004834:	01079793          	slli	a5,a5,0x10
80004838:	0107d793          	srli	a5,a5,0x10
8000483c:	00078513          	mv	a0,a5
80004840:	cf5ff0ef          	jal	ra,80004534 <__bswap16>
80004844:	00050793          	mv	a5,a0
80004848:	00078713          	mv	a4,a5
8000484c:	fdc42783          	lw	a5,-36(s0)
80004850:	00e79223          	sh	a4,4(a5)
80004854:	fdc42783          	lw	a5,-36(s0)
80004858:	03a00713          	li	a4,58
8000485c:	00e78323          	sb	a4,6(a5)
80004860:	fdc42783          	lw	a5,-36(s0)
80004864:	04000713          	li	a4,64
80004868:	00e783a3          	sb	a4,7(a5)
8000486c:	fdc42783          	lw	a5,-36(s0)
80004870:	fdc42703          	lw	a4,-36(s0)
80004874:	00872583          	lw	a1,8(a4)
80004878:	00c72603          	lw	a2,12(a4)
8000487c:	01072683          	lw	a3,16(a4)
80004880:	01472703          	lw	a4,20(a4)
80004884:	00b7ac23          	sw	a1,24(a5)
80004888:	00c7ae23          	sw	a2,28(a5)
8000488c:	02d7a023          	sw	a3,32(a5)
80004890:	02e7a223          	sw	a4,36(a5)
80004894:	fe744703          	lbu	a4,-25(s0)
80004898:	006107b7          	lui	a5,0x610
8000489c:	00f707b3          	add	a5,a4,a5
800048a0:	00879793          	slli	a5,a5,0x8
800048a4:	00078713          	mv	a4,a5
800048a8:	fdc42783          	lw	a5,-36(s0)
800048ac:	02072583          	lw	a1,32(a4)
800048b0:	02472603          	lw	a2,36(a4)
800048b4:	02872683          	lw	a3,40(a4)
800048b8:	02c72703          	lw	a4,44(a4)
800048bc:	00b7a423          	sw	a1,8(a5) # 610008 <_reset_vector-0x7f9efff8>
800048c0:	00c7a623          	sw	a2,12(a5)
800048c4:	00d7a823          	sw	a3,16(a5)
800048c8:	00e7aa23          	sw	a4,20(a5)
800048cc:	fe842783          	lw	a5,-24(s0)
800048d0:	ff278793          	addi	a5,a5,-14
800048d4:	00078593          	mv	a1,a5
800048d8:	fdc42503          	lw	a0,-36(s0)
800048dc:	f9cfb0ef          	jal	ra,80000078 <validateAndFillChecksum>
800048e0:	db1fb0ef          	jal	ra,80000690 <dma_send_finish>
800048e4:	d39fb0ef          	jal	ra,8000061c <dma_lock_release>
800048e8:	00000013          	nop
800048ec:	02c12083          	lw	ra,44(sp)
800048f0:	02812403          	lw	s0,40(sp)
800048f4:	03010113          	addi	sp,sp,48
800048f8:	00008067          	ret

800048fc <icmp_reply_gen>:
800048fc:	fd010113          	addi	sp,sp,-48
80004900:	02112623          	sw	ra,44(sp)
80004904:	02812423          	sw	s0,40(sp)
80004908:	03010413          	addi	s0,sp,48
8000490c:	ccdfb0ef          	jal	ra,800005d8 <dma_lock_request>
80004910:	d35fb0ef          	jal	ra,80000644 <dma_send_request>
80004914:	680007b7          	lui	a5,0x68000
80004918:	01278793          	addi	a5,a5,18 # 68000012 <_reset_vector-0x17ffffee>
8000491c:	fef42623          	sw	a5,-20(s0)
80004920:	fec42783          	lw	a5,-20(s0)
80004924:	0187c703          	lbu	a4,24(a5)
80004928:	0ff00793          	li	a5,255
8000492c:	04f71c63          	bne	a4,a5,80004984 <icmp_reply_gen+0x88>
80004930:	fec42783          	lw	a5,-20(s0)
80004934:	fec42703          	lw	a4,-20(s0)
80004938:	00872583          	lw	a1,8(a4)
8000493c:	00c72603          	lw	a2,12(a4)
80004940:	01072683          	lw	a3,16(a4)
80004944:	01472703          	lw	a4,20(a4)
80004948:	00b7ac23          	sw	a1,24(a5)
8000494c:	00c7ae23          	sw	a2,28(a5)
80004950:	02d7a023          	sw	a3,32(a5)
80004954:	02e7a223          	sw	a4,36(a5)
80004958:	61000737          	lui	a4,0x61000
8000495c:	fec42783          	lw	a5,-20(s0)
80004960:	02072583          	lw	a1,32(a4) # 61000020 <_reset_vector-0x1effffe0>
80004964:	02472603          	lw	a2,36(a4)
80004968:	02872683          	lw	a3,40(a4)
8000496c:	02c72703          	lw	a4,44(a4)
80004970:	00b7a423          	sw	a1,8(a5)
80004974:	00c7a623          	sw	a2,12(a5)
80004978:	00d7a823          	sw	a3,16(a5)
8000497c:	00e7aa23          	sw	a4,20(a5)
80004980:	0740006f          	j	800049f4 <icmp_reply_gen+0xf8>
80004984:	fec42783          	lw	a5,-20(s0)
80004988:	0187a603          	lw	a2,24(a5)
8000498c:	01c7a683          	lw	a3,28(a5)
80004990:	0207a703          	lw	a4,32(a5)
80004994:	0247a783          	lw	a5,36(a5)
80004998:	fcc42c23          	sw	a2,-40(s0)
8000499c:	fcd42e23          	sw	a3,-36(s0)
800049a0:	fee42023          	sw	a4,-32(s0)
800049a4:	fef42223          	sw	a5,-28(s0)
800049a8:	fec42783          	lw	a5,-20(s0)
800049ac:	fec42703          	lw	a4,-20(s0)
800049b0:	00872583          	lw	a1,8(a4)
800049b4:	00c72603          	lw	a2,12(a4)
800049b8:	01072683          	lw	a3,16(a4)
800049bc:	01472703          	lw	a4,20(a4)
800049c0:	00b7ac23          	sw	a1,24(a5)
800049c4:	00c7ae23          	sw	a2,28(a5)
800049c8:	02d7a023          	sw	a3,32(a5)
800049cc:	02e7a223          	sw	a4,36(a5)
800049d0:	fec42783          	lw	a5,-20(s0)
800049d4:	fd842583          	lw	a1,-40(s0)
800049d8:	fdc42603          	lw	a2,-36(s0)
800049dc:	fe042683          	lw	a3,-32(s0)
800049e0:	fe442703          	lw	a4,-28(s0)
800049e4:	00b7a423          	sw	a1,8(a5)
800049e8:	00c7a623          	sw	a2,12(a5)
800049ec:	00d7a823          	sw	a3,16(a5)
800049f0:	00e7aa23          	sw	a4,20(a5)
800049f4:	680007b7          	lui	a5,0x68000
800049f8:	03a78793          	addi	a5,a5,58 # 6800003a <_reset_vector-0x17ffffc6>
800049fc:	fef42423          	sw	a5,-24(s0)
80004a00:	fe842783          	lw	a5,-24(s0)
80004a04:	f8100713          	li	a4,-127
80004a08:	00e78023          	sb	a4,0(a5)
80004a0c:	fe842783          	lw	a5,-24(s0)
80004a10:	000780a3          	sb	zero,1(a5)
80004a14:	fe842783          	lw	a5,-24(s0)
80004a18:	00079123          	sh	zero,2(a5)
80004a1c:	680007b7          	lui	a5,0x68000
80004a20:	0007a783          	lw	a5,0(a5) # 68000000 <_reset_vector-0x18000000>
80004a24:	ff278793          	addi	a5,a5,-14
80004a28:	00078593          	mv	a1,a5
80004a2c:	fec42503          	lw	a0,-20(s0)
80004a30:	e48fb0ef          	jal	ra,80000078 <validateAndFillChecksum>
80004a34:	c5dfb0ef          	jal	ra,80000690 <dma_send_finish>
80004a38:	be5fb0ef          	jal	ra,8000061c <dma_lock_release>
80004a3c:	00000013          	nop
80004a40:	02c12083          	lw	ra,44(sp)
80004a44:	02812403          	lw	s0,40(sp)
80004a48:	03010113          	addi	sp,sp,48
80004a4c:	00008067          	ret

80004a50 <mainloop>:
80004a50:	fd010113          	addi	sp,sp,-48
80004a54:	02112623          	sw	ra,44(sp)
80004a58:	02812423          	sw	s0,40(sp)
80004a5c:	02912223          	sw	s1,36(sp)
80004a60:	03010413          	addi	s0,sp,48
80004a64:	00050793          	mv	a5,a0
80004a68:	fcf40fa3          	sb	a5,-33(s0)
80004a6c:	fdf44783          	lbu	a5,-33(s0)
80004a70:	0017c793          	xori	a5,a5,1
80004a74:	0ff7f793          	andi	a5,a5,255
80004a78:	00078463          	beqz	a5,80004a80 <mainloop+0x30>
80004a7c:	b5dfb0ef          	jal	ra,800005d8 <dma_lock_request>
80004a80:	c39fb0ef          	jal	ra,800006b8 <dma_read_need>
80004a84:	00050793          	mv	a5,a0
80004a88:	1a078263          	beqz	a5,80004c2c <mainloop+0x1dc>
80004a8c:	680007b7          	lui	a5,0x68000
80004a90:	00478793          	addi	a5,a5,4 # 68000004 <_reset_vector-0x17fffffc>
80004a94:	fef42623          	sw	a5,-20(s0)
80004a98:	fec42783          	lw	a5,-20(s0)
80004a9c:	00c7d783          	lhu	a5,12(a5)
80004aa0:	01079713          	slli	a4,a5,0x10
80004aa4:	01075713          	srli	a4,a4,0x10
80004aa8:	0000e7b7          	lui	a5,0xe
80004aac:	d8678793          	addi	a5,a5,-634 # dd86 <_reset_vector-0x7fff227a>
80004ab0:	00f70663          	beq	a4,a5,80004abc <mainloop+0x6c>
80004ab4:	c4dff0ef          	jal	ra,80004700 <icmp_error_gen>
80004ab8:	15c0006f          	j	80004c14 <mainloop+0x1c4>
80004abc:	680007b7          	lui	a5,0x68000
80004ac0:	01278793          	addi	a5,a5,18 # 68000012 <_reset_vector-0x17ffffee>
80004ac4:	fef42423          	sw	a5,-24(s0)
80004ac8:	fe842783          	lw	a5,-24(s0)
80004acc:	0067c783          	lbu	a5,6(a5)
80004ad0:	0ff7f713          	andi	a4,a5,255
80004ad4:	03a00793          	li	a5,58
80004ad8:	04f71e63          	bne	a4,a5,80004b34 <mainloop+0xe4>
80004adc:	680007b7          	lui	a5,0x68000
80004ae0:	0007a783          	lw	a5,0(a5) # 68000000 <_reset_vector-0x18000000>
80004ae4:	ff278793          	addi	a5,a5,-14
80004ae8:	00078593          	mv	a1,a5
80004aec:	fe842503          	lw	a0,-24(s0)
80004af0:	d88fb0ef          	jal	ra,80000078 <validateAndFillChecksum>
80004af4:	00050793          	mv	a5,a0
80004af8:	02078663          	beqz	a5,80004b24 <mainloop+0xd4>
80004afc:	680007b7          	lui	a5,0x68000
80004b00:	03a78793          	addi	a5,a5,58 # 6800003a <_reset_vector-0x17ffffc6>
80004b04:	fef42023          	sw	a5,-32(s0)
80004b08:	fe042783          	lw	a5,-32(s0)
80004b0c:	0007c783          	lbu	a5,0(a5)
80004b10:	0ff7f713          	andi	a4,a5,255
80004b14:	08000793          	li	a5,128
80004b18:	0ef71e63          	bne	a4,a5,80004c14 <mainloop+0x1c4>
80004b1c:	de1ff0ef          	jal	ra,800048fc <icmp_reply_gen>
80004b20:	0f40006f          	j	80004c14 <mainloop+0x1c4>
80004b24:	8000c7b7          	lui	a5,0x8000c
80004b28:	a7c78513          	addi	a0,a5,-1412 # 8000ba7c <_bss_end+0xffe4948c>
80004b2c:	df0fd0ef          	jal	ra,8000211c <printf_>
80004b30:	0e40006f          	j	80004c14 <mainloop+0x1c4>
80004b34:	fe842783          	lw	a5,-24(s0)
80004b38:	0067c783          	lbu	a5,6(a5)
80004b3c:	0ff7f713          	andi	a4,a5,255
80004b40:	01100793          	li	a5,17
80004b44:	0af71a63          	bne	a4,a5,80004bf8 <mainloop+0x1a8>
80004b48:	680007b7          	lui	a5,0x68000
80004b4c:	0007a783          	lw	a5,0(a5) # 68000000 <_reset_vector-0x18000000>
80004b50:	ff278793          	addi	a5,a5,-14
80004b54:	00078593          	mv	a1,a5
80004b58:	fe842503          	lw	a0,-24(s0)
80004b5c:	d1cfb0ef          	jal	ra,80000078 <validateAndFillChecksum>
80004b60:	00050793          	mv	a5,a0
80004b64:	08078263          	beqz	a5,80004be8 <mainloop+0x198>
80004b68:	680007b7          	lui	a5,0x68000
80004b6c:	03a78793          	addi	a5,a5,58 # 6800003a <_reset_vector-0x17ffffc6>
80004b70:	fef42223          	sw	a5,-28(s0)
80004b74:	fe442783          	lw	a5,-28(s0)
80004b78:	0007d783          	lhu	a5,0(a5)
80004b7c:	01079793          	slli	a5,a5,0x10
80004b80:	0107d793          	srli	a5,a5,0x10
80004b84:	00078713          	mv	a4,a5
80004b88:	fe442783          	lw	a5,-28(s0)
80004b8c:	0027d783          	lhu	a5,2(a5)
80004b90:	01079793          	slli	a5,a5,0x10
80004b94:	0107d793          	srli	a5,a5,0x10
80004b98:	00078613          	mv	a2,a5
80004b9c:	00070593          	mv	a1,a4
80004ba0:	8000c7b7          	lui	a5,0x8000c
80004ba4:	aa478513          	addi	a0,a5,-1372 # 8000baa4 <_bss_end+0xffe494b4>
80004ba8:	d74fd0ef          	jal	ra,8000211c <printf_>
80004bac:	fe442783          	lw	a5,-28(s0)
80004bb0:	0027d783          	lhu	a5,2(a5)
80004bb4:	01079493          	slli	s1,a5,0x10
80004bb8:	0104d493          	srli	s1,s1,0x10
80004bbc:	20900513          	li	a0,521
80004bc0:	975ff0ef          	jal	ra,80004534 <__bswap16>
80004bc4:	00050793          	mv	a5,a0
80004bc8:	04f49663          	bne	s1,a5,80004c14 <mainloop+0x1c4>
80004bcc:	680007b7          	lui	a5,0x68000
80004bd0:	0007a783          	lw	a5,0(a5) # 68000000 <_reset_vector-0x18000000>
80004bd4:	00078593          	mv	a1,a5
80004bd8:	680007b7          	lui	a5,0x68000
80004bdc:	00478513          	addi	a0,a5,4 # 68000004 <_reset_vector-0x17fffffc>
80004be0:	95dfd0ef          	jal	ra,8000253c <receive_ripng>
80004be4:	0300006f          	j	80004c14 <mainloop+0x1c4>
80004be8:	8000c7b7          	lui	a5,0x8000c
80004bec:	acc78513          	addi	a0,a5,-1332 # 8000bacc <_bss_end+0xffe494dc>
80004bf0:	d2cfd0ef          	jal	ra,8000211c <printf_>
80004bf4:	0200006f          	j	80004c14 <mainloop+0x1c4>
80004bf8:	fe842783          	lw	a5,-24(s0)
80004bfc:	0067c783          	lbu	a5,6(a5)
80004c00:	0ff7f793          	andi	a5,a5,255
80004c04:	00078593          	mv	a1,a5
80004c08:	8000c7b7          	lui	a5,0x8000c
80004c0c:	af078513          	addi	a0,a5,-1296 # 8000baf0 <_bss_end+0xffe49500>
80004c10:	d0cfd0ef          	jal	ra,8000211c <printf_>
80004c14:	fdf44783          	lbu	a5,-33(s0)
80004c18:	0017c793          	xori	a5,a5,1
80004c1c:	0ff7f793          	andi	a5,a5,255
80004c20:	00078463          	beqz	a5,80004c28 <mainloop+0x1d8>
80004c24:	9b5fb0ef          	jal	ra,800005d8 <dma_lock_request>
80004c28:	acdfb0ef          	jal	ra,800006f4 <dma_read_finish>
80004c2c:	00000013          	nop
80004c30:	02c12083          	lw	ra,44(sp)
80004c34:	02812403          	lw	s0,40(sp)
80004c38:	02412483          	lw	s1,36(sp)
80004c3c:	03010113          	addi	sp,sp,48
80004c40:	00008067          	ret

80004c44 <check_linklocal_address>:
80004c44:	ff010113          	addi	sp,sp,-16
80004c48:	00812623          	sw	s0,12(sp)
80004c4c:	00912423          	sw	s1,8(sp)
80004c50:	01010413          	addi	s0,sp,16
80004c54:	00050493          	mv	s1,a0
80004c58:	0004d783          	lhu	a5,0(s1)
80004c5c:	00078713          	mv	a4,a5
80004c60:	0000c7b7          	lui	a5,0xc
80004c64:	0ff78793          	addi	a5,a5,255 # c0ff <_reset_vector-0x7fff3f01>
80004c68:	00f77733          	and	a4,a4,a5
80004c6c:	ffff87b7          	lui	a5,0xffff8
80004c70:	f0278793          	addi	a5,a5,-254 # ffff7f02 <_bss_end+0x7fe35912>
80004c74:	00f707b3          	add	a5,a4,a5
80004c78:	0017b793          	seqz	a5,a5
80004c7c:	0ff7f793          	andi	a5,a5,255
80004c80:	00078513          	mv	a0,a5
80004c84:	00c12403          	lw	s0,12(sp)
80004c88:	00812483          	lw	s1,8(sp)
80004c8c:	01010113          	addi	sp,sp,16
80004c90:	00008067          	ret

80004c94 <check_multicast_address>:
80004c94:	ff010113          	addi	sp,sp,-16
80004c98:	00812623          	sw	s0,12(sp)
80004c9c:	00912423          	sw	s1,8(sp)
80004ca0:	01010413          	addi	s0,sp,16
80004ca4:	00050493          	mv	s1,a0
80004ca8:	0004c783          	lbu	a5,0(s1)
80004cac:	f0178793          	addi	a5,a5,-255
80004cb0:	0017b793          	seqz	a5,a5
80004cb4:	0ff7f793          	andi	a5,a5,255
80004cb8:	00078513          	mv	a0,a5
80004cbc:	00c12403          	lw	s0,12(sp)
80004cc0:	00812483          	lw	s1,8(sp)
80004cc4:	01010113          	addi	sp,sp,16
80004cc8:	00008067          	ret

80004ccc <check_own_address>:
80004ccc:	fd010113          	addi	sp,sp,-48
80004cd0:	02112623          	sw	ra,44(sp)
80004cd4:	02812423          	sw	s0,40(sp)
80004cd8:	02912223          	sw	s1,36(sp)
80004cdc:	03010413          	addi	s0,sp,48
80004ce0:	00050493          	mv	s1,a0
80004ce4:	610007b7          	lui	a5,0x61000
80004ce8:	0004a583          	lw	a1,0(s1)
80004cec:	0044a603          	lw	a2,4(s1)
80004cf0:	0084a683          	lw	a3,8(s1)
80004cf4:	00c4a703          	lw	a4,12(s1)
80004cf8:	feb42023          	sw	a1,-32(s0)
80004cfc:	fec42223          	sw	a2,-28(s0)
80004d00:	fed42423          	sw	a3,-24(s0)
80004d04:	fee42623          	sw	a4,-20(s0)
80004d08:	0107a603          	lw	a2,16(a5) # 61000010 <_reset_vector-0x1efffff0>
80004d0c:	0147a683          	lw	a3,20(a5)
80004d10:	0187a703          	lw	a4,24(a5)
80004d14:	01c7a783          	lw	a5,28(a5)
80004d18:	fcc42823          	sw	a2,-48(s0)
80004d1c:	fcd42a23          	sw	a3,-44(s0)
80004d20:	fce42c23          	sw	a4,-40(s0)
80004d24:	fcf42e23          	sw	a5,-36(s0)
80004d28:	fd040713          	addi	a4,s0,-48
80004d2c:	fe040793          	addi	a5,s0,-32
80004d30:	00070593          	mv	a1,a4
80004d34:	00078513          	mv	a0,a5
80004d38:	829fb0ef          	jal	ra,80000560 <in6_addr_equal>
80004d3c:	00050793          	mv	a5,a0
80004d40:	12079863          	bnez	a5,80004e70 <check_own_address+0x1a4>
80004d44:	610007b7          	lui	a5,0x61000
80004d48:	10078793          	addi	a5,a5,256 # 61000100 <_reset_vector-0x1effff00>
80004d4c:	0004a583          	lw	a1,0(s1)
80004d50:	0044a603          	lw	a2,4(s1)
80004d54:	0084a683          	lw	a3,8(s1)
80004d58:	00c4a703          	lw	a4,12(s1)
80004d5c:	fcb42823          	sw	a1,-48(s0)
80004d60:	fcc42a23          	sw	a2,-44(s0)
80004d64:	fcd42c23          	sw	a3,-40(s0)
80004d68:	fce42e23          	sw	a4,-36(s0)
80004d6c:	0107a603          	lw	a2,16(a5)
80004d70:	0147a683          	lw	a3,20(a5)
80004d74:	0187a703          	lw	a4,24(a5)
80004d78:	01c7a783          	lw	a5,28(a5)
80004d7c:	fec42023          	sw	a2,-32(s0)
80004d80:	fed42223          	sw	a3,-28(s0)
80004d84:	fee42423          	sw	a4,-24(s0)
80004d88:	fef42623          	sw	a5,-20(s0)
80004d8c:	fe040713          	addi	a4,s0,-32
80004d90:	fd040793          	addi	a5,s0,-48
80004d94:	00070593          	mv	a1,a4
80004d98:	00078513          	mv	a0,a5
80004d9c:	fc4fb0ef          	jal	ra,80000560 <in6_addr_equal>
80004da0:	00050793          	mv	a5,a0
80004da4:	0c079663          	bnez	a5,80004e70 <check_own_address+0x1a4>
80004da8:	610007b7          	lui	a5,0x61000
80004dac:	20078793          	addi	a5,a5,512 # 61000200 <_reset_vector-0x1efffe00>
80004db0:	0004a583          	lw	a1,0(s1)
80004db4:	0044a603          	lw	a2,4(s1)
80004db8:	0084a683          	lw	a3,8(s1)
80004dbc:	00c4a703          	lw	a4,12(s1)
80004dc0:	fcb42823          	sw	a1,-48(s0)
80004dc4:	fcc42a23          	sw	a2,-44(s0)
80004dc8:	fcd42c23          	sw	a3,-40(s0)
80004dcc:	fce42e23          	sw	a4,-36(s0)
80004dd0:	0107a603          	lw	a2,16(a5)
80004dd4:	0147a683          	lw	a3,20(a5)
80004dd8:	0187a703          	lw	a4,24(a5)
80004ddc:	01c7a783          	lw	a5,28(a5)
80004de0:	fec42023          	sw	a2,-32(s0)
80004de4:	fed42223          	sw	a3,-28(s0)
80004de8:	fee42423          	sw	a4,-24(s0)
80004dec:	fef42623          	sw	a5,-20(s0)
80004df0:	fe040713          	addi	a4,s0,-32
80004df4:	fd040793          	addi	a5,s0,-48
80004df8:	00070593          	mv	a1,a4
80004dfc:	00078513          	mv	a0,a5
80004e00:	f60fb0ef          	jal	ra,80000560 <in6_addr_equal>
80004e04:	00050793          	mv	a5,a0
80004e08:	06079463          	bnez	a5,80004e70 <check_own_address+0x1a4>
80004e0c:	610007b7          	lui	a5,0x61000
80004e10:	30078793          	addi	a5,a5,768 # 61000300 <_reset_vector-0x1efffd00>
80004e14:	0004a583          	lw	a1,0(s1)
80004e18:	0044a603          	lw	a2,4(s1)
80004e1c:	0084a683          	lw	a3,8(s1)
80004e20:	00c4a703          	lw	a4,12(s1)
80004e24:	fcb42823          	sw	a1,-48(s0)
80004e28:	fcc42a23          	sw	a2,-44(s0)
80004e2c:	fcd42c23          	sw	a3,-40(s0)
80004e30:	fce42e23          	sw	a4,-36(s0)
80004e34:	0107a603          	lw	a2,16(a5)
80004e38:	0147a683          	lw	a3,20(a5)
80004e3c:	0187a703          	lw	a4,24(a5)
80004e40:	01c7a783          	lw	a5,28(a5)
80004e44:	fec42023          	sw	a2,-32(s0)
80004e48:	fed42223          	sw	a3,-28(s0)
80004e4c:	fee42423          	sw	a4,-24(s0)
80004e50:	fef42623          	sw	a5,-20(s0)
80004e54:	fe040713          	addi	a4,s0,-32
80004e58:	fd040793          	addi	a5,s0,-48
80004e5c:	00070593          	mv	a1,a4
80004e60:	00078513          	mv	a0,a5
80004e64:	efcfb0ef          	jal	ra,80000560 <in6_addr_equal>
80004e68:	00050793          	mv	a5,a0
80004e6c:	00078663          	beqz	a5,80004e78 <check_own_address+0x1ac>
80004e70:	00100793          	li	a5,1
80004e74:	0080006f          	j	80004e7c <check_own_address+0x1b0>
80004e78:	00000793          	li	a5,0
80004e7c:	0017f793          	andi	a5,a5,1
80004e80:	0ff7f793          	andi	a5,a5,255
80004e84:	00078513          	mv	a0,a5
80004e88:	02c12083          	lw	ra,44(sp)
80004e8c:	02812403          	lw	s0,40(sp)
80004e90:	02412483          	lw	s1,36(sp)
80004e94:	03010113          	addi	sp,sp,48
80004e98:	00008067          	ret

80004e9c <draw_speed>:
80004e9c:	fd010113          	addi	sp,sp,-48
80004ea0:	02112623          	sw	ra,44(sp)
80004ea4:	02812423          	sw	s0,40(sp)
80004ea8:	02912223          	sw	s1,36(sp)
80004eac:	03010413          	addi	s0,sp,48
80004eb0:	fe042623          	sw	zero,-20(s0)
80004eb4:	1340006f          	j	80004fe8 <draw_speed+0x14c>
80004eb8:	fe042423          	sw	zero,-24(s0)
80004ebc:	1140006f          	j	80004fd0 <draw_speed+0x134>
80004ec0:	8000d7b7          	lui	a5,0x8000d
80004ec4:	62c78713          	addi	a4,a5,1580 # 8000d62c <_bss_end+0xffe4b03c>
80004ec8:	fec42783          	lw	a5,-20(s0)
80004ecc:	00279693          	slli	a3,a5,0x2
80004ed0:	fe842783          	lw	a5,-24(s0)
80004ed4:	00f687b3          	add	a5,a3,a5
80004ed8:	00279793          	slli	a5,a5,0x2
80004edc:	00f707b3          	add	a5,a4,a5
80004ee0:	0007a783          	lw	a5,0(a5)
80004ee4:	06400593          	li	a1,100
80004ee8:	00078513          	mv	a0,a5
80004eec:	5dc060ef          	jal	ra,8000b4c8 <__udivsi3>
80004ef0:	00050793          	mv	a5,a0
80004ef4:	00078493          	mv	s1,a5
80004ef8:	8000d7b7          	lui	a5,0x8000d
80004efc:	62c78713          	addi	a4,a5,1580 # 8000d62c <_bss_end+0xffe4b03c>
80004f00:	fec42783          	lw	a5,-20(s0)
80004f04:	00279693          	slli	a3,a5,0x2
80004f08:	fe842783          	lw	a5,-24(s0)
80004f0c:	00f687b3          	add	a5,a3,a5
80004f10:	00279793          	slli	a5,a5,0x2
80004f14:	00f707b3          	add	a5,a4,a5
80004f18:	0007a783          	lw	a5,0(a5)
80004f1c:	06400593          	li	a1,100
80004f20:	00078513          	mv	a0,a5
80004f24:	5ec060ef          	jal	ra,8000b510 <__umodsi3>
80004f28:	00050793          	mv	a5,a0
80004f2c:	fd840713          	addi	a4,s0,-40
80004f30:	00078693          	mv	a3,a5
80004f34:	00048613          	mv	a2,s1
80004f38:	8000c7b7          	lui	a5,0x8000c
80004f3c:	b1878593          	addi	a1,a5,-1256 # 8000bb18 <_bss_end+0xffe49528>
80004f40:	00070513          	mv	a0,a4
80004f44:	a58fd0ef          	jal	ra,8000219c <sprintf_>
80004f48:	fe042223          	sw	zero,-28(s0)
80004f4c:	06c0006f          	j	80004fb8 <draw_speed+0x11c>
80004f50:	00200713          	li	a4,2
80004f54:	fec42783          	lw	a5,-20(s0)
80004f58:	40f70533          	sub	a0,a4,a5
80004f5c:	fe842703          	lw	a4,-24(s0)
80004f60:	00070793          	mv	a5,a4
80004f64:	00279793          	slli	a5,a5,0x2
80004f68:	00e787b3          	add	a5,a5,a4
80004f6c:	00179793          	slli	a5,a5,0x1
80004f70:	04678713          	addi	a4,a5,70
80004f74:	fe442783          	lw	a5,-28(s0)
80004f78:	00f70733          	add	a4,a4,a5
80004f7c:	fe442783          	lw	a5,-28(s0)
80004f80:	ff040693          	addi	a3,s0,-16
80004f84:	00f687b3          	add	a5,a3,a5
80004f88:	fe87c603          	lbu	a2,-24(a5)
80004f8c:	fec42783          	lw	a5,-20(s0)
80004f90:	00078663          	beqz	a5,80004f9c <draw_speed+0x100>
80004f94:	0f100793          	li	a5,241
80004f98:	0080006f          	j	80004fa0 <draw_speed+0x104>
80004f9c:	05700793          	li	a5,87
80004fa0:	00078693          	mv	a3,a5
80004fa4:	00070593          	mv	a1,a4
80004fa8:	b25fb0ef          	jal	ra,80000acc <update_pos>
80004fac:	fe442783          	lw	a5,-28(s0)
80004fb0:	00178793          	addi	a5,a5,1
80004fb4:	fef42223          	sw	a5,-28(s0)
80004fb8:	fe442703          	lw	a4,-28(s0)
80004fbc:	00600793          	li	a5,6
80004fc0:	f8e7d8e3          	bge	a5,a4,80004f50 <draw_speed+0xb4>
80004fc4:	fe842783          	lw	a5,-24(s0)
80004fc8:	00178793          	addi	a5,a5,1
80004fcc:	fef42423          	sw	a5,-24(s0)
80004fd0:	fe842703          	lw	a4,-24(s0)
80004fd4:	00300793          	li	a5,3
80004fd8:	eee7d4e3          	bge	a5,a4,80004ec0 <draw_speed+0x24>
80004fdc:	fec42783          	lw	a5,-20(s0)
80004fe0:	00178793          	addi	a5,a5,1
80004fe4:	fef42623          	sw	a5,-20(s0)
80004fe8:	fec42703          	lw	a4,-20(s0)
80004fec:	00100793          	li	a5,1
80004ff0:	ece7d4e3          	bge	a5,a4,80004eb8 <draw_speed+0x1c>
80004ff4:	00000013          	nop
80004ff8:	00000013          	nop
80004ffc:	02c12083          	lw	ra,44(sp)
80005000:	02812403          	lw	s0,40(sp)
80005004:	02412483          	lw	s1,36(sp)
80005008:	03010113          	addi	sp,sp,48
8000500c:	00008067          	ret

80005010 <display>:
80005010:	f6010113          	addi	sp,sp,-160
80005014:	08112e23          	sw	ra,156(sp)
80005018:	08812c23          	sw	s0,152(sp)
8000501c:	0a010413          	addi	s0,sp,160
80005020:	ae9fb0ef          	jal	ra,80000b08 <flush>
80005024:	8000c7b7          	lui	a5,0x8000c
80005028:	b2478593          	addi	a1,a5,-1244 # 8000bb24 <_bss_end+0xffe49534>
8000502c:	8018d7b7          	lui	a5,0x8018d
80005030:	7dc78513          	addi	a0,a5,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
80005034:	968fd0ef          	jal	ra,8000219c <sprintf_>
80005038:	fe042623          	sw	zero,-20(s0)
8000503c:	0380006f          	j	80005074 <display+0x64>
80005040:	8018d7b7          	lui	a5,0x8018d
80005044:	7dc78713          	addi	a4,a5,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
80005048:	fec42783          	lw	a5,-20(s0)
8000504c:	00f707b3          	add	a5,a4,a5
80005050:	0007c783          	lbu	a5,0(a5)
80005054:	0ef00693          	li	a3,239
80005058:	00078613          	mv	a2,a5
8000505c:	fec42583          	lw	a1,-20(s0)
80005060:	00000513          	li	a0,0
80005064:	a69fb0ef          	jal	ra,80000acc <update_pos>
80005068:	fec42783          	lw	a5,-20(s0)
8000506c:	00178793          	addi	a5,a5,1
80005070:	fef42623          	sw	a5,-20(s0)
80005074:	8018d7b7          	lui	a5,0x8018d
80005078:	7dc78713          	addi	a4,a5,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
8000507c:	fec42783          	lw	a5,-20(s0)
80005080:	00f707b3          	add	a5,a4,a5
80005084:	0007c783          	lbu	a5,0(a5)
80005088:	fa079ce3          	bnez	a5,80005040 <display+0x30>
8000508c:	8000c7b7          	lui	a5,0x8000c
80005090:	b4478593          	addi	a1,a5,-1212 # 8000bb44 <_bss_end+0xffe49554>
80005094:	8018d7b7          	lui	a5,0x8018d
80005098:	7dc78513          	addi	a0,a5,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
8000509c:	900fd0ef          	jal	ra,8000219c <sprintf_>
800050a0:	fe042423          	sw	zero,-24(s0)
800050a4:	0940006f          	j	80005138 <display+0x128>
800050a8:	fe842703          	lw	a4,-24(s0)
800050ac:	00800793          	li	a5,8
800050b0:	02f70463          	beq	a4,a5,800050d8 <display+0xc8>
800050b4:	fe842703          	lw	a4,-24(s0)
800050b8:	00e00793          	li	a5,14
800050bc:	00f70e63          	beq	a4,a5,800050d8 <display+0xc8>
800050c0:	fe842703          	lw	a4,-24(s0)
800050c4:	01700793          	li	a5,23
800050c8:	00f70863          	beq	a4,a5,800050d8 <display+0xc8>
800050cc:	fe842703          	lw	a4,-24(s0)
800050d0:	01f00793          	li	a5,31
800050d4:	02f71863          	bne	a4,a5,80005104 <display+0xf4>
800050d8:	8018d7b7          	lui	a5,0x8018d
800050dc:	7dc78713          	addi	a4,a5,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
800050e0:	fe842783          	lw	a5,-24(s0)
800050e4:	00f707b3          	add	a5,a4,a5
800050e8:	0007c783          	lbu	a5,0(a5)
800050ec:	01c00693          	li	a3,28
800050f0:	00078613          	mv	a2,a5
800050f4:	fe842583          	lw	a1,-24(s0)
800050f8:	00100513          	li	a0,1
800050fc:	9d1fb0ef          	jal	ra,80000acc <update_pos>
80005100:	02c0006f          	j	8000512c <display+0x11c>
80005104:	8018d7b7          	lui	a5,0x8018d
80005108:	7dc78713          	addi	a4,a5,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
8000510c:	fe842783          	lw	a5,-24(s0)
80005110:	00f707b3          	add	a5,a4,a5
80005114:	0007c783          	lbu	a5,0(a5)
80005118:	05700693          	li	a3,87
8000511c:	00078613          	mv	a2,a5
80005120:	fe842583          	lw	a1,-24(s0)
80005124:	00100513          	li	a0,1
80005128:	9a5fb0ef          	jal	ra,80000acc <update_pos>
8000512c:	fe842783          	lw	a5,-24(s0)
80005130:	00178793          	addi	a5,a5,1
80005134:	fef42423          	sw	a5,-24(s0)
80005138:	8018d7b7          	lui	a5,0x8018d
8000513c:	7dc78713          	addi	a4,a5,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
80005140:	fe842783          	lw	a5,-24(s0)
80005144:	00f707b3          	add	a5,a4,a5
80005148:	0007c783          	lbu	a5,0(a5)
8000514c:	f4079ee3          	bnez	a5,800050a8 <display+0x98>
80005150:	8000c7b7          	lui	a5,0x8000c
80005154:	b6c78793          	addi	a5,a5,-1172 # 8000bb6c <_bss_end+0xffe4957c>
80005158:	8000c737          	lui	a4,0x8000c
8000515c:	b7070713          	addi	a4,a4,-1168 # 8000bb70 <_bss_end+0xffe49580>
80005160:	8000c6b7          	lui	a3,0x8000c
80005164:	b7468693          	addi	a3,a3,-1164 # 8000bb74 <_bss_end+0xffe49584>
80005168:	8000c637          	lui	a2,0x8000c
8000516c:	b7860613          	addi	a2,a2,-1160 # 8000bb78 <_bss_end+0xffe49588>
80005170:	8000c5b7          	lui	a1,0x8000c
80005174:	b7c58593          	addi	a1,a1,-1156 # 8000bb7c <_bss_end+0xffe4958c>
80005178:	8018d537          	lui	a0,0x8018d
8000517c:	7dc50513          	addi	a0,a0,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
80005180:	81cfd0ef          	jal	ra,8000219c <sprintf_>
80005184:	fe042223          	sw	zero,-28(s0)
80005188:	03c0006f          	j	800051c4 <display+0x1b4>
8000518c:	fe442783          	lw	a5,-28(s0)
80005190:	03478593          	addi	a1,a5,52
80005194:	8018d7b7          	lui	a5,0x8018d
80005198:	7dc78713          	addi	a4,a5,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
8000519c:	fe442783          	lw	a5,-28(s0)
800051a0:	00f707b3          	add	a5,a4,a5
800051a4:	0007c783          	lbu	a5,0(a5)
800051a8:	0f600693          	li	a3,246
800051ac:	00078613          	mv	a2,a5
800051b0:	00000513          	li	a0,0
800051b4:	919fb0ef          	jal	ra,80000acc <update_pos>
800051b8:	fe442783          	lw	a5,-28(s0)
800051bc:	00178793          	addi	a5,a5,1
800051c0:	fef42223          	sw	a5,-28(s0)
800051c4:	8018d7b7          	lui	a5,0x8018d
800051c8:	7dc78713          	addi	a4,a5,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
800051cc:	fe442783          	lw	a5,-28(s0)
800051d0:	00f707b3          	add	a5,a4,a5
800051d4:	0007c783          	lbu	a5,0(a5)
800051d8:	fa079ae3          	bnez	a5,8000518c <display+0x17c>
800051dc:	8000c7b7          	lui	a5,0x8000c
800051e0:	ba478793          	addi	a5,a5,-1116 # 8000bba4 <_bss_end+0xffe495b4>
800051e4:	8000c737          	lui	a4,0x8000c
800051e8:	ba470713          	addi	a4,a4,-1116 # 8000bba4 <_bss_end+0xffe495b4>
800051ec:	8000c6b7          	lui	a3,0x8000c
800051f0:	ba468693          	addi	a3,a3,-1116 # 8000bba4 <_bss_end+0xffe495b4>
800051f4:	8000c637          	lui	a2,0x8000c
800051f8:	ba460613          	addi	a2,a2,-1116 # 8000bba4 <_bss_end+0xffe495b4>
800051fc:	8000c5b7          	lui	a1,0x8000c
80005200:	ba858593          	addi	a1,a1,-1112 # 8000bba8 <_bss_end+0xffe495b8>
80005204:	8018d537          	lui	a0,0x8018d
80005208:	7dc50513          	addi	a0,a0,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
8000520c:	f91fc0ef          	jal	ra,8000219c <sprintf_>
80005210:	fe042023          	sw	zero,-32(s0)
80005214:	03c0006f          	j	80005250 <display+0x240>
80005218:	fe042783          	lw	a5,-32(s0)
8000521c:	03478593          	addi	a1,a5,52
80005220:	8018d7b7          	lui	a5,0x8018d
80005224:	7dc78713          	addi	a4,a5,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
80005228:	fe042783          	lw	a5,-32(s0)
8000522c:	00f707b3          	add	a5,a4,a5
80005230:	0007c783          	lbu	a5,0(a5)
80005234:	0f600693          	li	a3,246
80005238:	00078613          	mv	a2,a5
8000523c:	00100513          	li	a0,1
80005240:	88dfb0ef          	jal	ra,80000acc <update_pos>
80005244:	fe042783          	lw	a5,-32(s0)
80005248:	00178793          	addi	a5,a5,1
8000524c:	fef42023          	sw	a5,-32(s0)
80005250:	8018d7b7          	lui	a5,0x8018d
80005254:	7dc78713          	addi	a4,a5,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
80005258:	fe042783          	lw	a5,-32(s0)
8000525c:	00f707b3          	add	a5,a4,a5
80005260:	0007c783          	lbu	a5,0(a5)
80005264:	fa079ae3          	bnez	a5,80005218 <display+0x208>
80005268:	8000c7b7          	lui	a5,0x8000c
8000526c:	ba478793          	addi	a5,a5,-1116 # 8000bba4 <_bss_end+0xffe495b4>
80005270:	8000c737          	lui	a4,0x8000c
80005274:	ba470713          	addi	a4,a4,-1116 # 8000bba4 <_bss_end+0xffe495b4>
80005278:	8000c6b7          	lui	a3,0x8000c
8000527c:	ba468693          	addi	a3,a3,-1116 # 8000bba4 <_bss_end+0xffe495b4>
80005280:	8000c637          	lui	a2,0x8000c
80005284:	ba460613          	addi	a2,a2,-1116 # 8000bba4 <_bss_end+0xffe495b4>
80005288:	8000c5b7          	lui	a1,0x8000c
8000528c:	bd058593          	addi	a1,a1,-1072 # 8000bbd0 <_bss_end+0xffe495e0>
80005290:	8018d537          	lui	a0,0x8018d
80005294:	7dc50513          	addi	a0,a0,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
80005298:	f05fc0ef          	jal	ra,8000219c <sprintf_>
8000529c:	fc042e23          	sw	zero,-36(s0)
800052a0:	03c0006f          	j	800052dc <display+0x2cc>
800052a4:	fdc42783          	lw	a5,-36(s0)
800052a8:	03478593          	addi	a1,a5,52
800052ac:	8018d7b7          	lui	a5,0x8018d
800052b0:	7dc78713          	addi	a4,a5,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
800052b4:	fdc42783          	lw	a5,-36(s0)
800052b8:	00f707b3          	add	a5,a4,a5
800052bc:	0007c783          	lbu	a5,0(a5)
800052c0:	0f600693          	li	a3,246
800052c4:	00078613          	mv	a2,a5
800052c8:	00200513          	li	a0,2
800052cc:	801fb0ef          	jal	ra,80000acc <update_pos>
800052d0:	fdc42783          	lw	a5,-36(s0)
800052d4:	00178793          	addi	a5,a5,1
800052d8:	fcf42e23          	sw	a5,-36(s0)
800052dc:	8018d7b7          	lui	a5,0x8018d
800052e0:	7dc78713          	addi	a4,a5,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
800052e4:	fdc42783          	lw	a5,-36(s0)
800052e8:	00f707b3          	add	a5,a4,a5
800052ec:	0007c783          	lbu	a5,0(a5)
800052f0:	fa079ae3          	bnez	a5,800052a4 <display+0x294>
800052f4:	ba9ff0ef          	jal	ra,80004e9c <draw_speed>
800052f8:	8000c7b7          	lui	a5,0x8000c
800052fc:	22e7c783          	lbu	a5,558(a5) # 8000c22e <_bss_end+0xffe49c3e>
80005300:	02078263          	beqz	a5,80005324 <display+0x314>
80005304:	8000d7b7          	lui	a5,0x8000d
80005308:	53478613          	addi	a2,a5,1332 # 8000d534 <_bss_end+0xffe4af44>
8000530c:	8000c7b7          	lui	a5,0x8000c
80005310:	bf878593          	addi	a1,a5,-1032 # 8000bbf8 <_bss_end+0xffe49608>
80005314:	8018d7b7          	lui	a5,0x8018d
80005318:	7dc78513          	addi	a0,a5,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
8000531c:	e81fc0ef          	jal	ra,8000219c <sprintf_>
80005320:	0340006f          	j	80005354 <display+0x344>
80005324:	8000d7b7          	lui	a5,0x8000d
80005328:	53478593          	addi	a1,a5,1332 # 8000d534 <_bss_end+0xffe4af44>
8000532c:	8000c7b7          	lui	a5,0x8000c
80005330:	23078513          	addi	a0,a5,560 # 8000c230 <_bss_end+0xffe49c40>
80005334:	49c020ef          	jal	ra,800077d0 <printip>
80005338:	8000d7b7          	lui	a5,0x8000d
8000533c:	53478613          	addi	a2,a5,1332 # 8000d534 <_bss_end+0xffe4af44>
80005340:	8000c7b7          	lui	a5,0x8000c
80005344:	c1078593          	addi	a1,a5,-1008 # 8000bc10 <_bss_end+0xffe49620>
80005348:	8018d7b7          	lui	a5,0x8018d
8000534c:	7dc78513          	addi	a0,a5,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
80005350:	e4dfc0ef          	jal	ra,8000219c <sprintf_>
80005354:	fc042c23          	sw	zero,-40(s0)
80005358:	0380006f          	j	80005390 <display+0x380>
8000535c:	8018d7b7          	lui	a5,0x8018d
80005360:	7dc78713          	addi	a4,a5,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
80005364:	fd842783          	lw	a5,-40(s0)
80005368:	00f707b3          	add	a5,a4,a5
8000536c:	0007c783          	lbu	a5,0(a5)
80005370:	01c00693          	li	a3,28
80005374:	00078613          	mv	a2,a5
80005378:	fd842583          	lw	a1,-40(s0)
8000537c:	00200513          	li	a0,2
80005380:	f4cfb0ef          	jal	ra,80000acc <update_pos>
80005384:	fd842783          	lw	a5,-40(s0)
80005388:	00178793          	addi	a5,a5,1
8000538c:	fcf42c23          	sw	a5,-40(s0)
80005390:	8018d7b7          	lui	a5,0x8018d
80005394:	7dc78713          	addi	a4,a5,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
80005398:	fd842783          	lw	a5,-40(s0)
8000539c:	00f707b3          	add	a5,a4,a5
800053a0:	0007c783          	lbu	a5,0(a5)
800053a4:	fa079ce3          	bnez	a5,8000535c <display+0x34c>
800053a8:	fc042a23          	sw	zero,-44(s0)
800053ac:	8000c7b7          	lui	a5,0x8000c
800053b0:	c2078613          	addi	a2,a5,-992 # 8000bc20 <_bss_end+0xffe49630>
800053b4:	8000c7b7          	lui	a5,0x8000c
800053b8:	c2878593          	addi	a1,a5,-984 # 8000bc28 <_bss_end+0xffe49638>
800053bc:	8018d7b7          	lui	a5,0x8018d
800053c0:	7dc78513          	addi	a0,a5,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
800053c4:	dd9fc0ef          	jal	ra,8000219c <sprintf_>
800053c8:	fc042823          	sw	zero,-48(s0)
800053cc:	0440006f          	j	80005410 <display+0x400>
800053d0:	fd442783          	lw	a5,-44(s0)
800053d4:	00178713          	addi	a4,a5,1
800053d8:	fce42a23          	sw	a4,-44(s0)
800053dc:	8018d737          	lui	a4,0x8018d
800053e0:	7dc70693          	addi	a3,a4,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
800053e4:	fd042703          	lw	a4,-48(s0)
800053e8:	00e68733          	add	a4,a3,a4
800053ec:	00074703          	lbu	a4,0(a4)
800053f0:	0ff00693          	li	a3,255
800053f4:	00070613          	mv	a2,a4
800053f8:	00078593          	mv	a1,a5
800053fc:	00300513          	li	a0,3
80005400:	eccfb0ef          	jal	ra,80000acc <update_pos>
80005404:	fd042783          	lw	a5,-48(s0)
80005408:	00178793          	addi	a5,a5,1
8000540c:	fcf42823          	sw	a5,-48(s0)
80005410:	8018d7b7          	lui	a5,0x8018d
80005414:	7dc78713          	addi	a4,a5,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
80005418:	fd042783          	lw	a5,-48(s0)
8000541c:	00f707b3          	add	a5,a4,a5
80005420:	0007c783          	lbu	a5,0(a5)
80005424:	fa0796e3          	bnez	a5,800053d0 <display+0x3c0>
80005428:	02c00793          	li	a5,44
8000542c:	fcf42a23          	sw	a5,-44(s0)
80005430:	8000c7b7          	lui	a5,0x8000c
80005434:	c2c78613          	addi	a2,a5,-980 # 8000bc2c <_bss_end+0xffe4963c>
80005438:	8000c7b7          	lui	a5,0x8000c
8000543c:	c2878593          	addi	a1,a5,-984 # 8000bc28 <_bss_end+0xffe49638>
80005440:	8018d7b7          	lui	a5,0x8018d
80005444:	7dc78513          	addi	a0,a5,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
80005448:	d55fc0ef          	jal	ra,8000219c <sprintf_>
8000544c:	fc042623          	sw	zero,-52(s0)
80005450:	0440006f          	j	80005494 <display+0x484>
80005454:	fd442783          	lw	a5,-44(s0)
80005458:	00178713          	addi	a4,a5,1
8000545c:	fce42a23          	sw	a4,-44(s0)
80005460:	8018d737          	lui	a4,0x8018d
80005464:	7dc70693          	addi	a3,a4,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
80005468:	fcc42703          	lw	a4,-52(s0)
8000546c:	00e68733          	add	a4,a3,a4
80005470:	00074703          	lbu	a4,0(a4)
80005474:	05700693          	li	a3,87
80005478:	00070613          	mv	a2,a4
8000547c:	00078593          	mv	a1,a5
80005480:	00300513          	li	a0,3
80005484:	e48fb0ef          	jal	ra,80000acc <update_pos>
80005488:	fcc42783          	lw	a5,-52(s0)
8000548c:	00178793          	addi	a5,a5,1
80005490:	fcf42623          	sw	a5,-52(s0)
80005494:	8018d7b7          	lui	a5,0x8018d
80005498:	7dc78713          	addi	a4,a5,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
8000549c:	fcc42783          	lw	a5,-52(s0)
800054a0:	00f707b3          	add	a5,a4,a5
800054a4:	0007c783          	lbu	a5,0(a5)
800054a8:	fa0796e3          	bnez	a5,80005454 <display+0x444>
800054ac:	03600793          	li	a5,54
800054b0:	fcf42a23          	sw	a5,-44(s0)
800054b4:	8000c7b7          	lui	a5,0x8000c
800054b8:	c3878613          	addi	a2,a5,-968 # 8000bc38 <_bss_end+0xffe49648>
800054bc:	8000c7b7          	lui	a5,0x8000c
800054c0:	c2878593          	addi	a1,a5,-984 # 8000bc28 <_bss_end+0xffe49638>
800054c4:	8018d7b7          	lui	a5,0x8018d
800054c8:	7dc78513          	addi	a0,a5,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
800054cc:	cd1fc0ef          	jal	ra,8000219c <sprintf_>
800054d0:	fc042423          	sw	zero,-56(s0)
800054d4:	0440006f          	j	80005518 <display+0x508>
800054d8:	fd442783          	lw	a5,-44(s0)
800054dc:	00178713          	addi	a4,a5,1
800054e0:	fce42a23          	sw	a4,-44(s0)
800054e4:	8018d737          	lui	a4,0x8018d
800054e8:	7dc70693          	addi	a3,a4,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
800054ec:	fc842703          	lw	a4,-56(s0)
800054f0:	00e68733          	add	a4,a3,a4
800054f4:	00074703          	lbu	a4,0(a4)
800054f8:	01c00693          	li	a3,28
800054fc:	00070613          	mv	a2,a4
80005500:	00078593          	mv	a1,a5
80005504:	00300513          	li	a0,3
80005508:	dc4fb0ef          	jal	ra,80000acc <update_pos>
8000550c:	fc842783          	lw	a5,-56(s0)
80005510:	00178793          	addi	a5,a5,1
80005514:	fcf42423          	sw	a5,-56(s0)
80005518:	8018d7b7          	lui	a5,0x8018d
8000551c:	7dc78713          	addi	a4,a5,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
80005520:	fc842783          	lw	a5,-56(s0)
80005524:	00f707b3          	add	a5,a4,a5
80005528:	0007c783          	lbu	a5,0(a5)
8000552c:	fa0796e3          	bnez	a5,800054d8 <display+0x4c8>
80005530:	06200793          	li	a5,98
80005534:	fcf42a23          	sw	a5,-44(s0)
80005538:	8000c7b7          	lui	a5,0x8000c
8000553c:	c4478613          	addi	a2,a5,-956 # 8000bc44 <_bss_end+0xffe49654>
80005540:	8000c7b7          	lui	a5,0x8000c
80005544:	c2878593          	addi	a1,a5,-984 # 8000bc28 <_bss_end+0xffe49638>
80005548:	8018d7b7          	lui	a5,0x8018d
8000554c:	7dc78513          	addi	a0,a5,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
80005550:	c4dfc0ef          	jal	ra,8000219c <sprintf_>
80005554:	fc042223          	sw	zero,-60(s0)
80005558:	0440006f          	j	8000559c <display+0x58c>
8000555c:	fd442783          	lw	a5,-44(s0)
80005560:	00178713          	addi	a4,a5,1
80005564:	fce42a23          	sw	a4,-44(s0)
80005568:	8018d737          	lui	a4,0x8018d
8000556c:	7dc70693          	addi	a3,a4,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
80005570:	fc442703          	lw	a4,-60(s0)
80005574:	00e68733          	add	a4,a3,a4
80005578:	00074703          	lbu	a4,0(a4)
8000557c:	0ff00693          	li	a3,255
80005580:	00070613          	mv	a2,a4
80005584:	00078593          	mv	a1,a5
80005588:	00300513          	li	a0,3
8000558c:	d40fb0ef          	jal	ra,80000acc <update_pos>
80005590:	fc442783          	lw	a5,-60(s0)
80005594:	00178793          	addi	a5,a5,1
80005598:	fcf42223          	sw	a5,-60(s0)
8000559c:	8018d7b7          	lui	a5,0x8018d
800055a0:	7dc78713          	addi	a4,a5,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
800055a4:	fc442783          	lw	a5,-60(s0)
800055a8:	00f707b3          	add	a5,a4,a5
800055ac:	0007c783          	lbu	a5,0(a5)
800055b0:	fa0796e3          	bnez	a5,8000555c <display+0x54c>
800055b4:	f8042e23          	sw	zero,-100(s0)
800055b8:	8000c7b7          	lui	a5,0x8000c
800055bc:	22e7c583          	lbu	a1,558(a5) # 8000c22e <_bss_end+0xffe49c3e>
800055c0:	f8042623          	sw	zero,-116(s0)
800055c4:	f8042823          	sw	zero,-112(s0)
800055c8:	f8042a23          	sw	zero,-108(s0)
800055cc:	f8042c23          	sw	zero,-104(s0)
800055d0:	8000c7b7          	lui	a5,0x8000c
800055d4:	23078793          	addi	a5,a5,560 # 8000c230 <_bss_end+0xffe49c40>
800055d8:	0007a603          	lw	a2,0(a5)
800055dc:	0047a683          	lw	a3,4(a5)
800055e0:	0087a703          	lw	a4,8(a5)
800055e4:	00c7a783          	lw	a5,12(a5)
800055e8:	f6c42823          	sw	a2,-144(s0)
800055ec:	f6d42a23          	sw	a3,-140(s0)
800055f0:	f6e42c23          	sw	a4,-136(s0)
800055f4:	f6f42e23          	sw	a5,-132(s0)
800055f8:	f8c42603          	lw	a2,-116(s0)
800055fc:	f9042683          	lw	a3,-112(s0)
80005600:	f9442703          	lw	a4,-108(s0)
80005604:	f9842783          	lw	a5,-104(s0)
80005608:	f6c42023          	sw	a2,-160(s0)
8000560c:	f6d42223          	sw	a3,-156(s0)
80005610:	f6e42423          	sw	a4,-152(s0)
80005614:	f6f42623          	sw	a5,-148(s0)
80005618:	f6040793          	addi	a5,s0,-160
8000561c:	f9c40713          	addi	a4,s0,-100
80005620:	f7040613          	addi	a2,s0,-144
80005624:	00078813          	mv	a6,a5
80005628:	00058793          	mv	a5,a1
8000562c:	8000c6b7          	lui	a3,0x8000c
80005630:	24068693          	addi	a3,a3,576 # 8000c240 <_bss_end+0xffe49c50>
80005634:	00000593          	li	a1,0
80005638:	00000513          	li	a0,0
8000563c:	31c040ef          	jal	ra,80009958 <_prefix_query_all>
80005640:	00500793          	li	a5,5
80005644:	fcf42023          	sw	a5,-64(s0)
80005648:	fc042a23          	sw	zero,-44(s0)
8000564c:	fa042e23          	sw	zero,-68(s0)
80005650:	25c0006f          	j	800058ac <display+0x89c>
80005654:	fbc42703          	lw	a4,-68(s0)
80005658:	00070793          	mv	a5,a4
8000565c:	00179793          	slli	a5,a5,0x1
80005660:	00e787b3          	add	a5,a5,a4
80005664:	00479793          	slli	a5,a5,0x4
80005668:	00078713          	mv	a4,a5
8000566c:	8000c7b7          	lui	a5,0x8000c
80005670:	24078793          	addi	a5,a5,576 # 8000c240 <_bss_end+0xffe49c50>
80005674:	00f707b3          	add	a5,a4,a5
80005678:	faf42023          	sw	a5,-96(s0)
8000567c:	fa042703          	lw	a4,-96(s0)
80005680:	fa042783          	lw	a5,-96(s0)
80005684:	0107a783          	lw	a5,16(a5)
80005688:	00078693          	mv	a3,a5
8000568c:	8000d7b7          	lui	a5,0x8000d
80005690:	53478613          	addi	a2,a5,1332 # 8000d534 <_bss_end+0xffe4af44>
80005694:	00068593          	mv	a1,a3
80005698:	00070513          	mv	a0,a4
8000569c:	250020ef          	jal	ra,800078ec <printprefix>
800056a0:	fc042a23          	sw	zero,-44(s0)
800056a4:	fa042c23          	sw	zero,-72(s0)
800056a8:	0440006f          	j	800056ec <display+0x6dc>
800056ac:	fd442783          	lw	a5,-44(s0)
800056b0:	00178713          	addi	a4,a5,1
800056b4:	fce42a23          	sw	a4,-44(s0)
800056b8:	8000d737          	lui	a4,0x8000d
800056bc:	53470693          	addi	a3,a4,1332 # 8000d534 <_bss_end+0xffe4af44>
800056c0:	fb842703          	lw	a4,-72(s0)
800056c4:	00e68733          	add	a4,a3,a4
800056c8:	00074703          	lbu	a4,0(a4)
800056cc:	0ff00693          	li	a3,255
800056d0:	00070613          	mv	a2,a4
800056d4:	00078593          	mv	a1,a5
800056d8:	fc042503          	lw	a0,-64(s0)
800056dc:	bf0fb0ef          	jal	ra,80000acc <update_pos>
800056e0:	fb842783          	lw	a5,-72(s0)
800056e4:	00178793          	addi	a5,a5,1
800056e8:	faf42c23          	sw	a5,-72(s0)
800056ec:	8000d7b7          	lui	a5,0x8000d
800056f0:	53478713          	addi	a4,a5,1332 # 8000d534 <_bss_end+0xffe4af44>
800056f4:	fb842783          	lw	a5,-72(s0)
800056f8:	00f707b3          	add	a5,a4,a5
800056fc:	0007c783          	lbu	a5,0(a5)
80005700:	fa0796e3          	bnez	a5,800056ac <display+0x69c>
80005704:	02c00793          	li	a5,44
80005708:	fcf42a23          	sw	a5,-44(s0)
8000570c:	fa042783          	lw	a5,-96(s0)
80005710:	0147a783          	lw	a5,20(a5)
80005714:	00078613          	mv	a2,a5
80005718:	8000c7b7          	lui	a5,0x8000c
8000571c:	c5078593          	addi	a1,a5,-944 # 8000bc50 <_bss_end+0xffe49660>
80005720:	8018d7b7          	lui	a5,0x8018d
80005724:	7dc78513          	addi	a0,a5,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
80005728:	a75fc0ef          	jal	ra,8000219c <sprintf_>
8000572c:	fa042a23          	sw	zero,-76(s0)
80005730:	0440006f          	j	80005774 <display+0x764>
80005734:	fd442783          	lw	a5,-44(s0)
80005738:	00178713          	addi	a4,a5,1
8000573c:	fce42a23          	sw	a4,-44(s0)
80005740:	8018d737          	lui	a4,0x8018d
80005744:	7dc70693          	addi	a3,a4,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
80005748:	fb442703          	lw	a4,-76(s0)
8000574c:	00e68733          	add	a4,a3,a4
80005750:	00074703          	lbu	a4,0(a4)
80005754:	05700693          	li	a3,87
80005758:	00070613          	mv	a2,a4
8000575c:	00078593          	mv	a1,a5
80005760:	fc042503          	lw	a0,-64(s0)
80005764:	b68fb0ef          	jal	ra,80000acc <update_pos>
80005768:	fb442783          	lw	a5,-76(s0)
8000576c:	00178793          	addi	a5,a5,1
80005770:	faf42a23          	sw	a5,-76(s0)
80005774:	8018d7b7          	lui	a5,0x8018d
80005778:	7dc78713          	addi	a4,a5,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
8000577c:	fb442783          	lw	a5,-76(s0)
80005780:	00f707b3          	add	a5,a4,a5
80005784:	0007c783          	lbu	a5,0(a5)
80005788:	fa0796e3          	bnez	a5,80005734 <display+0x724>
8000578c:	03600793          	li	a5,54
80005790:	fcf42a23          	sw	a5,-44(s0)
80005794:	fa042783          	lw	a5,-96(s0)
80005798:	01878713          	addi	a4,a5,24
8000579c:	8000d7b7          	lui	a5,0x8000d
800057a0:	53478593          	addi	a1,a5,1332 # 8000d534 <_bss_end+0xffe4af44>
800057a4:	00070513          	mv	a0,a4
800057a8:	028020ef          	jal	ra,800077d0 <printip>
800057ac:	fa042823          	sw	zero,-80(s0)
800057b0:	0440006f          	j	800057f4 <display+0x7e4>
800057b4:	fd442783          	lw	a5,-44(s0)
800057b8:	00178713          	addi	a4,a5,1
800057bc:	fce42a23          	sw	a4,-44(s0)
800057c0:	8000d737          	lui	a4,0x8000d
800057c4:	53470693          	addi	a3,a4,1332 # 8000d534 <_bss_end+0xffe4af44>
800057c8:	fb042703          	lw	a4,-80(s0)
800057cc:	00e68733          	add	a4,a3,a4
800057d0:	00074703          	lbu	a4,0(a4)
800057d4:	01c00693          	li	a3,28
800057d8:	00070613          	mv	a2,a4
800057dc:	00078593          	mv	a1,a5
800057e0:	fc042503          	lw	a0,-64(s0)
800057e4:	ae8fb0ef          	jal	ra,80000acc <update_pos>
800057e8:	fb042783          	lw	a5,-80(s0)
800057ec:	00178793          	addi	a5,a5,1
800057f0:	faf42823          	sw	a5,-80(s0)
800057f4:	8000d7b7          	lui	a5,0x8000d
800057f8:	53478713          	addi	a4,a5,1332 # 8000d534 <_bss_end+0xffe4af44>
800057fc:	fb042783          	lw	a5,-80(s0)
80005800:	00f707b3          	add	a5,a4,a5
80005804:	0007c783          	lbu	a5,0(a5)
80005808:	fa0796e3          	bnez	a5,800057b4 <display+0x7a4>
8000580c:	06200793          	li	a5,98
80005810:	fcf42a23          	sw	a5,-44(s0)
80005814:	fa042783          	lw	a5,-96(s0)
80005818:	0287a783          	lw	a5,40(a5)
8000581c:	00078613          	mv	a2,a5
80005820:	8000c7b7          	lui	a5,0x8000c
80005824:	c5078593          	addi	a1,a5,-944 # 8000bc50 <_bss_end+0xffe49660>
80005828:	8018d7b7          	lui	a5,0x8018d
8000582c:	7dc78513          	addi	a0,a5,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
80005830:	96dfc0ef          	jal	ra,8000219c <sprintf_>
80005834:	fa042623          	sw	zero,-84(s0)
80005838:	0440006f          	j	8000587c <display+0x86c>
8000583c:	fd442783          	lw	a5,-44(s0)
80005840:	00178713          	addi	a4,a5,1
80005844:	fce42a23          	sw	a4,-44(s0)
80005848:	8018d737          	lui	a4,0x8018d
8000584c:	7dc70693          	addi	a3,a4,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
80005850:	fac42703          	lw	a4,-84(s0)
80005854:	00e68733          	add	a4,a3,a4
80005858:	00074703          	lbu	a4,0(a4)
8000585c:	0ff00693          	li	a3,255
80005860:	00070613          	mv	a2,a4
80005864:	00078593          	mv	a1,a5
80005868:	fc042503          	lw	a0,-64(s0)
8000586c:	a60fb0ef          	jal	ra,80000acc <update_pos>
80005870:	fac42783          	lw	a5,-84(s0)
80005874:	00178793          	addi	a5,a5,1
80005878:	faf42623          	sw	a5,-84(s0)
8000587c:	8018d7b7          	lui	a5,0x8018d
80005880:	7dc78713          	addi	a4,a5,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
80005884:	fac42783          	lw	a5,-84(s0)
80005888:	00f707b3          	add	a5,a4,a5
8000588c:	0007c783          	lbu	a5,0(a5)
80005890:	fa0796e3          	bnez	a5,8000583c <display+0x82c>
80005894:	fc042783          	lw	a5,-64(s0)
80005898:	00178793          	addi	a5,a5,1
8000589c:	fcf42023          	sw	a5,-64(s0)
800058a0:	fbc42783          	lw	a5,-68(s0)
800058a4:	00178793          	addi	a5,a5,1
800058a8:	faf42e23          	sw	a5,-68(s0)
800058ac:	f9c42783          	lw	a5,-100(s0)
800058b0:	fbc42703          	lw	a4,-68(s0)
800058b4:	daf740e3          	blt	a4,a5,80005654 <display+0x644>
800058b8:	fa042423          	sw	zero,-88(s0)
800058bc:	0380006f          	j	800058f4 <display+0x8e4>
800058c0:	0ff00693          	li	a3,255
800058c4:	02d00613          	li	a2,45
800058c8:	fa842583          	lw	a1,-88(s0)
800058cc:	00400513          	li	a0,4
800058d0:	9fcfb0ef          	jal	ra,80000acc <update_pos>
800058d4:	0ff00693          	li	a3,255
800058d8:	02d00613          	li	a2,45
800058dc:	fa842583          	lw	a1,-88(s0)
800058e0:	02700513          	li	a0,39
800058e4:	9e8fb0ef          	jal	ra,80000acc <update_pos>
800058e8:	fa842783          	lw	a5,-88(s0)
800058ec:	00178793          	addi	a5,a5,1
800058f0:	faf42423          	sw	a5,-88(s0)
800058f4:	fa842703          	lw	a4,-88(s0)
800058f8:	31f00793          	li	a5,799
800058fc:	fce7d2e3          	bge	a5,a4,800058c0 <display+0x8b0>
80005900:	01c00693          	li	a3,28
80005904:	03e00613          	li	a2,62
80005908:	00000593          	li	a1,0
8000590c:	02800513          	li	a0,40
80005910:	9bcfb0ef          	jal	ra,80000acc <update_pos>
80005914:	01c00693          	li	a3,28
80005918:	05f00613          	li	a2,95
8000591c:	00200593          	li	a1,2
80005920:	02800513          	li	a0,40
80005924:	9a8fb0ef          	jal	ra,80000acc <update_pos>
80005928:	fa042223          	sw	zero,-92(s0)
8000592c:	0500006f          	j	8000597c <display+0x96c>
80005930:	8000d7b7          	lui	a5,0x8000d
80005934:	5c878713          	addi	a4,a5,1480 # 8000d5c8 <_bss_end+0xffe4afd8>
80005938:	fa442783          	lw	a5,-92(s0)
8000593c:	00f707b3          	add	a5,a4,a5
80005940:	0007c703          	lbu	a4,0(a5)
80005944:	801c27b7          	lui	a5,0x801c2
80005948:	5c57c783          	lbu	a5,1477(a5) # 801c25c5 <_bss_end+0xffffffd5>
8000594c:	00078663          	beqz	a5,80005958 <display+0x948>
80005950:	0ed00793          	li	a5,237
80005954:	0080006f          	j	8000595c <display+0x94c>
80005958:	01c00793          	li	a5,28
8000595c:	00078693          	mv	a3,a5
80005960:	00070613          	mv	a2,a4
80005964:	fa442583          	lw	a1,-92(s0)
80005968:	02900513          	li	a0,41
8000596c:	960fb0ef          	jal	ra,80000acc <update_pos>
80005970:	fa442783          	lw	a5,-92(s0)
80005974:	00178793          	addi	a5,a5,1
80005978:	faf42223          	sw	a5,-92(s0)
8000597c:	8000d7b7          	lui	a5,0x8000d
80005980:	5c878713          	addi	a4,a5,1480 # 8000d5c8 <_bss_end+0xffe4afd8>
80005984:	fa442783          	lw	a5,-92(s0)
80005988:	00f707b3          	add	a5,a4,a5
8000598c:	0007c783          	lbu	a5,0(a5)
80005990:	fa0790e3          	bnez	a5,80005930 <display+0x920>
80005994:	00000013          	nop
80005998:	00000013          	nop
8000599c:	09c12083          	lw	ra,156(sp)
800059a0:	09812403          	lw	s0,152(sp)
800059a4:	0a010113          	addi	sp,sp,160
800059a8:	00008067          	ret

800059ac <operate_a>:
800059ac:	f9010113          	addi	sp,sp,-112
800059b0:	06112623          	sw	ra,108(sp)
800059b4:	06812423          	sw	s0,104(sp)
800059b8:	07010413          	addi	s0,sp,112
800059bc:	8000d7b7          	lui	a5,0x8000d
800059c0:	50078513          	addi	a0,a5,1280 # 8000d500 <_bss_end+0xffe4af10>
800059c4:	085010ef          	jal	ra,80007248 <_getip>
800059c8:	00050793          	mv	a5,a0
800059cc:	0017c793          	xori	a5,a5,1
800059d0:	0ff7f793          	andi	a5,a5,255
800059d4:	02078063          	beqz	a5,800059f4 <operate_a+0x48>
800059d8:	8000c7b7          	lui	a5,0x8000c
800059dc:	c5478593          	addi	a1,a5,-940 # 8000bc54 <_bss_end+0xffe49664>
800059e0:	8000d7b7          	lui	a5,0x8000d
800059e4:	5c878513          	addi	a0,a5,1480 # 8000d5c8 <_bss_end+0xffe4afd8>
800059e8:	fb4fc0ef          	jal	ra,8000219c <sprintf_>
800059ec:	00000793          	li	a5,0
800059f0:	1f40006f          	j	80005be4 <operate_a+0x238>
800059f4:	7b0010ef          	jal	ra,800071a4 <_getdec>
800059f8:	00050713          	mv	a4,a0
800059fc:	801c27b7          	lui	a5,0x801c2
80005a00:	5ae7ac23          	sw	a4,1464(a5) # 801c25b8 <_bss_end+0xffffffc8>
80005a04:	7a0010ef          	jal	ra,800071a4 <_getdec>
80005a08:	00050713          	mv	a4,a0
80005a0c:	801c27b7          	lui	a5,0x801c2
80005a10:	5ae7ae23          	sw	a4,1468(a5) # 801c25bc <_bss_end+0xffffffcc>
80005a14:	8000d7b7          	lui	a5,0x8000d
80005a18:	51078513          	addi	a0,a5,1296 # 8000d510 <_bss_end+0xffe4af20>
80005a1c:	02d010ef          	jal	ra,80007248 <_getip>
80005a20:	00050793          	mv	a5,a0
80005a24:	0017c793          	xori	a5,a5,1
80005a28:	0ff7f793          	andi	a5,a5,255
80005a2c:	02078063          	beqz	a5,80005a4c <operate_a+0xa0>
80005a30:	8000c7b7          	lui	a5,0x8000c
80005a34:	ca078593          	addi	a1,a5,-864 # 8000bca0 <_bss_end+0xffe496b0>
80005a38:	8000d7b7          	lui	a5,0x8000d
80005a3c:	5c878513          	addi	a0,a5,1480 # 8000d5c8 <_bss_end+0xffe4afd8>
80005a40:	f5cfc0ef          	jal	ra,8000219c <sprintf_>
80005a44:	00000793          	li	a5,0
80005a48:	19c0006f          	j	80005be4 <operate_a+0x238>
80005a4c:	758010ef          	jal	ra,800071a4 <_getdec>
80005a50:	00050713          	mv	a4,a0
80005a54:	801c27b7          	lui	a5,0x801c2
80005a58:	5ce7a023          	sw	a4,1472(a5) # 801c25c0 <_bss_end+0xffffffd0>
80005a5c:	fc042023          	sw	zero,-64(s0)
80005a60:	fc042223          	sw	zero,-60(s0)
80005a64:	fc042423          	sw	zero,-56(s0)
80005a68:	fc042623          	sw	zero,-52(s0)
80005a6c:	fc042823          	sw	zero,-48(s0)
80005a70:	fc042a23          	sw	zero,-44(s0)
80005a74:	fc042c23          	sw	zero,-40(s0)
80005a78:	fc042e23          	sw	zero,-36(s0)
80005a7c:	fe042023          	sw	zero,-32(s0)
80005a80:	fe042223          	sw	zero,-28(s0)
80005a84:	fe042423          	sw	zero,-24(s0)
80005a88:	fe042623          	sw	zero,-20(s0)
80005a8c:	8000d7b7          	lui	a5,0x8000d
80005a90:	50078793          	addi	a5,a5,1280 # 8000d500 <_bss_end+0xffe4af10>
80005a94:	0007a603          	lw	a2,0(a5)
80005a98:	0047a683          	lw	a3,4(a5)
80005a9c:	0087a703          	lw	a4,8(a5)
80005aa0:	00c7a783          	lw	a5,12(a5)
80005aa4:	fcc42023          	sw	a2,-64(s0)
80005aa8:	fcd42223          	sw	a3,-60(s0)
80005aac:	fce42423          	sw	a4,-56(s0)
80005ab0:	fcf42623          	sw	a5,-52(s0)
80005ab4:	801c27b7          	lui	a5,0x801c2
80005ab8:	5b87a783          	lw	a5,1464(a5) # 801c25b8 <_bss_end+0xffffffc8>
80005abc:	fcf42823          	sw	a5,-48(s0)
80005ac0:	801c27b7          	lui	a5,0x801c2
80005ac4:	5bc7a783          	lw	a5,1468(a5) # 801c25bc <_bss_end+0xffffffcc>
80005ac8:	fcf42a23          	sw	a5,-44(s0)
80005acc:	8000d7b7          	lui	a5,0x8000d
80005ad0:	51078793          	addi	a5,a5,1296 # 8000d510 <_bss_end+0xffe4af20>
80005ad4:	0007a603          	lw	a2,0(a5)
80005ad8:	0047a683          	lw	a3,4(a5)
80005adc:	0087a703          	lw	a4,8(a5)
80005ae0:	00c7a783          	lw	a5,12(a5)
80005ae4:	fcc42c23          	sw	a2,-40(s0)
80005ae8:	fcd42e23          	sw	a3,-36(s0)
80005aec:	fee42023          	sw	a4,-32(s0)
80005af0:	fef42223          	sw	a5,-28(s0)
80005af4:	801c27b7          	lui	a5,0x801c2
80005af8:	5c07a783          	lw	a5,1472(a5) # 801c25c0 <_bss_end+0xffffffd0>
80005afc:	fef42423          	sw	a5,-24(s0)
80005b00:	fc042f03          	lw	t5,-64(s0)
80005b04:	fc442e83          	lw	t4,-60(s0)
80005b08:	fc842e03          	lw	t3,-56(s0)
80005b0c:	fcc42303          	lw	t1,-52(s0)
80005b10:	fd042883          	lw	a7,-48(s0)
80005b14:	fd442803          	lw	a6,-44(s0)
80005b18:	fd842503          	lw	a0,-40(s0)
80005b1c:	fdc42583          	lw	a1,-36(s0)
80005b20:	fe042603          	lw	a2,-32(s0)
80005b24:	fe442683          	lw	a3,-28(s0)
80005b28:	fe842703          	lw	a4,-24(s0)
80005b2c:	fec42783          	lw	a5,-20(s0)
80005b30:	f9e42823          	sw	t5,-112(s0)
80005b34:	f9d42a23          	sw	t4,-108(s0)
80005b38:	f9c42c23          	sw	t3,-104(s0)
80005b3c:	f8642e23          	sw	t1,-100(s0)
80005b40:	fb142023          	sw	a7,-96(s0)
80005b44:	fb042223          	sw	a6,-92(s0)
80005b48:	faa42423          	sw	a0,-88(s0)
80005b4c:	fab42623          	sw	a1,-84(s0)
80005b50:	fac42823          	sw	a2,-80(s0)
80005b54:	fad42a23          	sw	a3,-76(s0)
80005b58:	fae42c23          	sw	a4,-72(s0)
80005b5c:	faf42e23          	sw	a5,-68(s0)
80005b60:	f9040793          	addi	a5,s0,-112
80005b64:	00078593          	mv	a1,a5
80005b68:	00100513          	li	a0,1
80005b6c:	66c030ef          	jal	ra,800091d8 <update>
80005b70:	801c27b7          	lui	a5,0x801c2
80005b74:	5b87a783          	lw	a5,1464(a5) # 801c25b8 <_bss_end+0xffffffc8>
80005b78:	00078713          	mv	a4,a5
80005b7c:	8018d7b7          	lui	a5,0x8018d
80005b80:	7dc78613          	addi	a2,a5,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
80005b84:	00070593          	mv	a1,a4
80005b88:	8000d7b7          	lui	a5,0x8000d
80005b8c:	50078513          	addi	a0,a5,1280 # 8000d500 <_bss_end+0xffe4af10>
80005b90:	55d010ef          	jal	ra,800078ec <printprefix>
80005b94:	8018e7b7          	lui	a5,0x8018e
80005b98:	84078793          	addi	a5,a5,-1984 # 8018d840 <_bss_end+0xfffcb250>
80005b9c:	00078593          	mv	a1,a5
80005ba0:	8000d7b7          	lui	a5,0x8000d
80005ba4:	51078513          	addi	a0,a5,1296 # 8000d510 <_bss_end+0xffe4af20>
80005ba8:	429010ef          	jal	ra,800077d0 <printip>
80005bac:	801c27b7          	lui	a5,0x801c2
80005bb0:	5bc7a683          	lw	a3,1468(a5) # 801c25bc <_bss_end+0xffffffcc>
80005bb4:	8018e7b7          	lui	a5,0x8018e
80005bb8:	84078713          	addi	a4,a5,-1984 # 8018d840 <_bss_end+0xfffcb250>
80005bbc:	801c27b7          	lui	a5,0x801c2
80005bc0:	5c07a783          	lw	a5,1472(a5) # 801c25c0 <_bss_end+0xffffffd0>
80005bc4:	8018d637          	lui	a2,0x8018d
80005bc8:	7dc60613          	addi	a2,a2,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
80005bcc:	8000c5b7          	lui	a1,0x8000c
80005bd0:	cec58593          	addi	a1,a1,-788 # 8000bcec <_bss_end+0xffe496fc>
80005bd4:	8000d537          	lui	a0,0x8000d
80005bd8:	5c850513          	addi	a0,a0,1480 # 8000d5c8 <_bss_end+0xffe4afd8>
80005bdc:	dc0fc0ef          	jal	ra,8000219c <sprintf_>
80005be0:	00100793          	li	a5,1
80005be4:	00078513          	mv	a0,a5
80005be8:	06c12083          	lw	ra,108(sp)
80005bec:	06812403          	lw	s0,104(sp)
80005bf0:	07010113          	addi	sp,sp,112
80005bf4:	00008067          	ret

80005bf8 <operate_d>:
80005bf8:	f9010113          	addi	sp,sp,-112
80005bfc:	06112623          	sw	ra,108(sp)
80005c00:	06812423          	sw	s0,104(sp)
80005c04:	07010413          	addi	s0,sp,112
80005c08:	8000d7b7          	lui	a5,0x8000d
80005c0c:	50078513          	addi	a0,a5,1280 # 8000d500 <_bss_end+0xffe4af10>
80005c10:	638010ef          	jal	ra,80007248 <_getip>
80005c14:	00050793          	mv	a5,a0
80005c18:	0017c793          	xori	a5,a5,1
80005c1c:	0ff7f793          	andi	a5,a5,255
80005c20:	02078063          	beqz	a5,80005c40 <operate_d+0x48>
80005c24:	8000c7b7          	lui	a5,0x8000c
80005c28:	d0078593          	addi	a1,a5,-768 # 8000bd00 <_bss_end+0xffe49710>
80005c2c:	8000d7b7          	lui	a5,0x8000d
80005c30:	5c878513          	addi	a0,a5,1480 # 8000d5c8 <_bss_end+0xffe4afd8>
80005c34:	d68fc0ef          	jal	ra,8000219c <sprintf_>
80005c38:	00000793          	li	a5,0
80005c3c:	14c0006f          	j	80005d88 <operate_d+0x190>
80005c40:	564010ef          	jal	ra,800071a4 <_getdec>
80005c44:	00050713          	mv	a4,a0
80005c48:	801c27b7          	lui	a5,0x801c2
80005c4c:	5ae7ac23          	sw	a4,1464(a5) # 801c25b8 <_bss_end+0xffffffc8>
80005c50:	554010ef          	jal	ra,800071a4 <_getdec>
80005c54:	00050713          	mv	a4,a0
80005c58:	801c27b7          	lui	a5,0x801c2
80005c5c:	5ce7a023          	sw	a4,1472(a5) # 801c25c0 <_bss_end+0xffffffd0>
80005c60:	fc042023          	sw	zero,-64(s0)
80005c64:	fc042223          	sw	zero,-60(s0)
80005c68:	fc042423          	sw	zero,-56(s0)
80005c6c:	fc042623          	sw	zero,-52(s0)
80005c70:	fc042823          	sw	zero,-48(s0)
80005c74:	fc042a23          	sw	zero,-44(s0)
80005c78:	fc042c23          	sw	zero,-40(s0)
80005c7c:	fc042e23          	sw	zero,-36(s0)
80005c80:	fe042023          	sw	zero,-32(s0)
80005c84:	fe042223          	sw	zero,-28(s0)
80005c88:	fe042423          	sw	zero,-24(s0)
80005c8c:	fe042623          	sw	zero,-20(s0)
80005c90:	8000d7b7          	lui	a5,0x8000d
80005c94:	50078793          	addi	a5,a5,1280 # 8000d500 <_bss_end+0xffe4af10>
80005c98:	0007a603          	lw	a2,0(a5)
80005c9c:	0047a683          	lw	a3,4(a5)
80005ca0:	0087a703          	lw	a4,8(a5)
80005ca4:	00c7a783          	lw	a5,12(a5)
80005ca8:	fcc42023          	sw	a2,-64(s0)
80005cac:	fcd42223          	sw	a3,-60(s0)
80005cb0:	fce42423          	sw	a4,-56(s0)
80005cb4:	fcf42623          	sw	a5,-52(s0)
80005cb8:	801c27b7          	lui	a5,0x801c2
80005cbc:	5b87a783          	lw	a5,1464(a5) # 801c25b8 <_bss_end+0xffffffc8>
80005cc0:	fcf42823          	sw	a5,-48(s0)
80005cc4:	801c27b7          	lui	a5,0x801c2
80005cc8:	5c07a783          	lw	a5,1472(a5) # 801c25c0 <_bss_end+0xffffffd0>
80005ccc:	fef42423          	sw	a5,-24(s0)
80005cd0:	fc042f03          	lw	t5,-64(s0)
80005cd4:	fc442e83          	lw	t4,-60(s0)
80005cd8:	fc842e03          	lw	t3,-56(s0)
80005cdc:	fcc42303          	lw	t1,-52(s0)
80005ce0:	fd042883          	lw	a7,-48(s0)
80005ce4:	fd442803          	lw	a6,-44(s0)
80005ce8:	fd842503          	lw	a0,-40(s0)
80005cec:	fdc42583          	lw	a1,-36(s0)
80005cf0:	fe042603          	lw	a2,-32(s0)
80005cf4:	fe442683          	lw	a3,-28(s0)
80005cf8:	fe842703          	lw	a4,-24(s0)
80005cfc:	fec42783          	lw	a5,-20(s0)
80005d00:	f9e42823          	sw	t5,-112(s0)
80005d04:	f9d42a23          	sw	t4,-108(s0)
80005d08:	f9c42c23          	sw	t3,-104(s0)
80005d0c:	f8642e23          	sw	t1,-100(s0)
80005d10:	fb142023          	sw	a7,-96(s0)
80005d14:	fb042223          	sw	a6,-92(s0)
80005d18:	faa42423          	sw	a0,-88(s0)
80005d1c:	fab42623          	sw	a1,-84(s0)
80005d20:	fac42823          	sw	a2,-80(s0)
80005d24:	fad42a23          	sw	a3,-76(s0)
80005d28:	fae42c23          	sw	a4,-72(s0)
80005d2c:	faf42e23          	sw	a5,-68(s0)
80005d30:	f9040793          	addi	a5,s0,-112
80005d34:	00078593          	mv	a1,a5
80005d38:	00000513          	li	a0,0
80005d3c:	49c030ef          	jal	ra,800091d8 <update>
80005d40:	8000d7b7          	lui	a5,0x8000d
80005d44:	53478593          	addi	a1,a5,1332 # 8000d534 <_bss_end+0xffe4af44>
80005d48:	8000d7b7          	lui	a5,0x8000d
80005d4c:	50078513          	addi	a0,a5,1280 # 8000d500 <_bss_end+0xffe4af10>
80005d50:	281010ef          	jal	ra,800077d0 <printip>
80005d54:	801c27b7          	lui	a5,0x801c2
80005d58:	5b87a683          	lw	a3,1464(a5) # 801c25b8 <_bss_end+0xffffffc8>
80005d5c:	801c27b7          	lui	a5,0x801c2
80005d60:	5c07a783          	lw	a5,1472(a5) # 801c25c0 <_bss_end+0xffffffd0>
80005d64:	00078713          	mv	a4,a5
80005d68:	8000d7b7          	lui	a5,0x8000d
80005d6c:	53478613          	addi	a2,a5,1332 # 8000d534 <_bss_end+0xffe4af44>
80005d70:	8000c7b7          	lui	a5,0x8000c
80005d74:	d3478593          	addi	a1,a5,-716 # 8000bd34 <_bss_end+0xffe49744>
80005d78:	8000d7b7          	lui	a5,0x8000d
80005d7c:	5c878513          	addi	a0,a5,1480 # 8000d5c8 <_bss_end+0xffe4afd8>
80005d80:	c1cfc0ef          	jal	ra,8000219c <sprintf_>
80005d84:	00100793          	li	a5,1
80005d88:	00078513          	mv	a0,a5
80005d8c:	06c12083          	lw	ra,108(sp)
80005d90:	06812403          	lw	s0,104(sp)
80005d94:	07010113          	addi	sp,sp,112
80005d98:	00008067          	ret

80005d9c <operate_c>:
80005d9c:	f9010113          	addi	sp,sp,-112
80005da0:	06112623          	sw	ra,108(sp)
80005da4:	06812423          	sw	s0,104(sp)
80005da8:	07010413          	addi	s0,sp,112
80005dac:	fc042e23          	sw	zero,-36(s0)
80005db0:	801c27b7          	lui	a5,0x801c2
80005db4:	5d07a783          	lw	a5,1488(a5) # 801c25d0 <_bss_end+0xffffffe0>
80005db8:	8018d737          	lui	a4,0x8018d
80005dbc:	7dc70713          	addi	a4,a4,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
80005dc0:	00f707b3          	add	a5,a4,a5
80005dc4:	0007c703          	lbu	a4,0(a5)
80005dc8:	00a00793          	li	a5,10
80005dcc:	16f71663          	bne	a4,a5,80005f38 <operate_c+0x19c>
80005dd0:	8000c7b7          	lui	a5,0x8000c
80005dd4:	00100713          	li	a4,1
80005dd8:	22e78723          	sb	a4,558(a5) # 8000c22e <_bss_end+0xffe49c3e>
80005ddc:	8000c7b7          	lui	a5,0x8000c
80005de0:	d4878593          	addi	a1,a5,-696 # 8000bd48 <_bss_end+0xffe49758>
80005de4:	8000d7b7          	lui	a5,0x8000d
80005de8:	5c878513          	addi	a0,a5,1480 # 8000d5c8 <_bss_end+0xffe4afd8>
80005dec:	bb0fc0ef          	jal	ra,8000219c <sprintf_>
80005df0:	8000c7b7          	lui	a5,0x8000c
80005df4:	22e7c583          	lbu	a1,558(a5) # 8000c22e <_bss_end+0xffe49c3e>
80005df8:	fa042e23          	sw	zero,-68(s0)
80005dfc:	fc042023          	sw	zero,-64(s0)
80005e00:	fc042223          	sw	zero,-60(s0)
80005e04:	fc042423          	sw	zero,-56(s0)
80005e08:	8000c7b7          	lui	a5,0x8000c
80005e0c:	23078793          	addi	a5,a5,560 # 8000c230 <_bss_end+0xffe49c40>
80005e10:	0007a603          	lw	a2,0(a5)
80005e14:	0047a683          	lw	a3,4(a5)
80005e18:	0087a703          	lw	a4,8(a5)
80005e1c:	00c7a783          	lw	a5,12(a5)
80005e20:	fac42023          	sw	a2,-96(s0)
80005e24:	fad42223          	sw	a3,-92(s0)
80005e28:	fae42423          	sw	a4,-88(s0)
80005e2c:	faf42623          	sw	a5,-84(s0)
80005e30:	fbc42603          	lw	a2,-68(s0)
80005e34:	fc042683          	lw	a3,-64(s0)
80005e38:	fc442703          	lw	a4,-60(s0)
80005e3c:	fc842783          	lw	a5,-56(s0)
80005e40:	f8c42823          	sw	a2,-112(s0)
80005e44:	f8d42a23          	sw	a3,-108(s0)
80005e48:	f8e42c23          	sw	a4,-104(s0)
80005e4c:	f8f42e23          	sw	a5,-100(s0)
80005e50:	f9040793          	addi	a5,s0,-112
80005e54:	fdc40713          	addi	a4,s0,-36
80005e58:	fa040613          	addi	a2,s0,-96
80005e5c:	00078813          	mv	a6,a5
80005e60:	00058793          	mv	a5,a1
80005e64:	8000c6b7          	lui	a3,0x8000c
80005e68:	24068693          	addi	a3,a3,576 # 8000c240 <_bss_end+0xffe49c50>
80005e6c:	00000593          	li	a1,0
80005e70:	00000513          	li	a0,0
80005e74:	2e5030ef          	jal	ra,80009958 <_prefix_query_all>
80005e78:	fe042623          	sw	zero,-20(s0)
80005e7c:	0a80006f          	j	80005f24 <operate_c+0x188>
80005e80:	fec42703          	lw	a4,-20(s0)
80005e84:	00070793          	mv	a5,a4
80005e88:	00179793          	slli	a5,a5,0x1
80005e8c:	00e787b3          	add	a5,a5,a4
80005e90:	00479793          	slli	a5,a5,0x4
80005e94:	00078713          	mv	a4,a5
80005e98:	8000c7b7          	lui	a5,0x8000c
80005e9c:	24078793          	addi	a5,a5,576 # 8000c240 <_bss_end+0xffe49c50>
80005ea0:	00f707b3          	add	a5,a4,a5
80005ea4:	fef42023          	sw	a5,-32(s0)
80005ea8:	fe042703          	lw	a4,-32(s0)
80005eac:	fe042783          	lw	a5,-32(s0)
80005eb0:	0107a783          	lw	a5,16(a5)
80005eb4:	00078693          	mv	a3,a5
80005eb8:	8000d7b7          	lui	a5,0x8000d
80005ebc:	53478613          	addi	a2,a5,1332 # 8000d534 <_bss_end+0xffe4af44>
80005ec0:	00068593          	mv	a1,a3
80005ec4:	00070513          	mv	a0,a4
80005ec8:	225010ef          	jal	ra,800078ec <printprefix>
80005ecc:	fe042783          	lw	a5,-32(s0)
80005ed0:	01878713          	addi	a4,a5,24
80005ed4:	8000d7b7          	lui	a5,0x8000d
80005ed8:	59878793          	addi	a5,a5,1432 # 8000d598 <_bss_end+0xffe4afa8>
80005edc:	00078593          	mv	a1,a5
80005ee0:	00070513          	mv	a0,a4
80005ee4:	0ed010ef          	jal	ra,800077d0 <printip>
80005ee8:	fe042783          	lw	a5,-32(s0)
80005eec:	0147a603          	lw	a2,20(a5)
80005ef0:	8000d7b7          	lui	a5,0x8000d
80005ef4:	59878693          	addi	a3,a5,1432 # 8000d598 <_bss_end+0xffe4afa8>
80005ef8:	fe042783          	lw	a5,-32(s0)
80005efc:	0287a783          	lw	a5,40(a5)
80005f00:	00078713          	mv	a4,a5
80005f04:	8000d7b7          	lui	a5,0x8000d
80005f08:	53478593          	addi	a1,a5,1332 # 8000d534 <_bss_end+0xffe4af44>
80005f0c:	8000c7b7          	lui	a5,0x8000c
80005f10:	d6878513          	addi	a0,a5,-664 # 8000bd68 <_bss_end+0xffe49778>
80005f14:	a08fc0ef          	jal	ra,8000211c <printf_>
80005f18:	fec42783          	lw	a5,-20(s0)
80005f1c:	00178793          	addi	a5,a5,1
80005f20:	fef42623          	sw	a5,-20(s0)
80005f24:	fdc42783          	lw	a5,-36(s0)
80005f28:	fec42703          	lw	a4,-20(s0)
80005f2c:	f4f74ae3          	blt	a4,a5,80005e80 <operate_c+0xe4>
80005f30:	00100793          	li	a5,1
80005f34:	1e80006f          	j	8000611c <operate_c+0x380>
80005f38:	8000d7b7          	lui	a5,0x8000d
80005f3c:	50078513          	addi	a0,a5,1280 # 8000d500 <_bss_end+0xffe4af10>
80005f40:	308010ef          	jal	ra,80007248 <_getip>
80005f44:	00050793          	mv	a5,a0
80005f48:	0017c793          	xori	a5,a5,1
80005f4c:	0ff7f793          	andi	a5,a5,255
80005f50:	02078063          	beqz	a5,80005f70 <operate_c+0x1d4>
80005f54:	8000c7b7          	lui	a5,0x8000c
80005f58:	d7c78593          	addi	a1,a5,-644 # 8000bd7c <_bss_end+0xffe4978c>
80005f5c:	8000d7b7          	lui	a5,0x8000d
80005f60:	5c878513          	addi	a0,a5,1480 # 8000d5c8 <_bss_end+0xffe4afd8>
80005f64:	a38fc0ef          	jal	ra,8000219c <sprintf_>
80005f68:	00000793          	li	a5,0
80005f6c:	1b00006f          	j	8000611c <operate_c+0x380>
80005f70:	8000c7b7          	lui	a5,0x8000c
80005f74:	22078723          	sb	zero,558(a5) # 8000c22e <_bss_end+0xffe49c3e>
80005f78:	8000d7b7          	lui	a5,0x8000d
80005f7c:	53478593          	addi	a1,a5,1332 # 8000d534 <_bss_end+0xffe4af44>
80005f80:	8000d7b7          	lui	a5,0x8000d
80005f84:	50078513          	addi	a0,a5,1280 # 8000d500 <_bss_end+0xffe4af10>
80005f88:	049010ef          	jal	ra,800077d0 <printip>
80005f8c:	8000c7b7          	lui	a5,0x8000c
80005f90:	23078793          	addi	a5,a5,560 # 8000c230 <_bss_end+0xffe49c40>
80005f94:	8000d737          	lui	a4,0x8000d
80005f98:	50070713          	addi	a4,a4,1280 # 8000d500 <_bss_end+0xffe4af10>
80005f9c:	00072583          	lw	a1,0(a4)
80005fa0:	00472603          	lw	a2,4(a4)
80005fa4:	00872683          	lw	a3,8(a4)
80005fa8:	00c72703          	lw	a4,12(a4)
80005fac:	00b7a023          	sw	a1,0(a5)
80005fb0:	00c7a223          	sw	a2,4(a5)
80005fb4:	00d7a423          	sw	a3,8(a5)
80005fb8:	00e7a623          	sw	a4,12(a5)
80005fbc:	8000d7b7          	lui	a5,0x8000d
80005fc0:	53478613          	addi	a2,a5,1332 # 8000d534 <_bss_end+0xffe4af44>
80005fc4:	8000c7b7          	lui	a5,0x8000c
80005fc8:	db878593          	addi	a1,a5,-584 # 8000bdb8 <_bss_end+0xffe497c8>
80005fcc:	8000d7b7          	lui	a5,0x8000d
80005fd0:	5c878513          	addi	a0,a5,1480 # 8000d5c8 <_bss_end+0xffe4afd8>
80005fd4:	9c8fc0ef          	jal	ra,8000219c <sprintf_>
80005fd8:	8000c7b7          	lui	a5,0x8000c
80005fdc:	22e7c583          	lbu	a1,558(a5) # 8000c22e <_bss_end+0xffe49c3e>
80005fe0:	fc042623          	sw	zero,-52(s0)
80005fe4:	fc042823          	sw	zero,-48(s0)
80005fe8:	fc042a23          	sw	zero,-44(s0)
80005fec:	fc042c23          	sw	zero,-40(s0)
80005ff0:	8000c7b7          	lui	a5,0x8000c
80005ff4:	23078793          	addi	a5,a5,560 # 8000c230 <_bss_end+0xffe49c40>
80005ff8:	0007a603          	lw	a2,0(a5)
80005ffc:	0047a683          	lw	a3,4(a5)
80006000:	0087a703          	lw	a4,8(a5)
80006004:	00c7a783          	lw	a5,12(a5)
80006008:	f8c42823          	sw	a2,-112(s0)
8000600c:	f8d42a23          	sw	a3,-108(s0)
80006010:	f8e42c23          	sw	a4,-104(s0)
80006014:	f8f42e23          	sw	a5,-100(s0)
80006018:	fcc42603          	lw	a2,-52(s0)
8000601c:	fd042683          	lw	a3,-48(s0)
80006020:	fd442703          	lw	a4,-44(s0)
80006024:	fd842783          	lw	a5,-40(s0)
80006028:	fac42023          	sw	a2,-96(s0)
8000602c:	fad42223          	sw	a3,-92(s0)
80006030:	fae42423          	sw	a4,-88(s0)
80006034:	faf42623          	sw	a5,-84(s0)
80006038:	fa040793          	addi	a5,s0,-96
8000603c:	fdc40713          	addi	a4,s0,-36
80006040:	f9040613          	addi	a2,s0,-112
80006044:	00078813          	mv	a6,a5
80006048:	00058793          	mv	a5,a1
8000604c:	8000c6b7          	lui	a3,0x8000c
80006050:	24068693          	addi	a3,a3,576 # 8000c240 <_bss_end+0xffe49c50>
80006054:	00000593          	li	a1,0
80006058:	00000513          	li	a0,0
8000605c:	0fd030ef          	jal	ra,80009958 <_prefix_query_all>
80006060:	fe042423          	sw	zero,-24(s0)
80006064:	0a80006f          	j	8000610c <operate_c+0x370>
80006068:	fe842703          	lw	a4,-24(s0)
8000606c:	00070793          	mv	a5,a4
80006070:	00179793          	slli	a5,a5,0x1
80006074:	00e787b3          	add	a5,a5,a4
80006078:	00479793          	slli	a5,a5,0x4
8000607c:	00078713          	mv	a4,a5
80006080:	8000c7b7          	lui	a5,0x8000c
80006084:	24078793          	addi	a5,a5,576 # 8000c240 <_bss_end+0xffe49c50>
80006088:	00f707b3          	add	a5,a4,a5
8000608c:	fef42223          	sw	a5,-28(s0)
80006090:	fe442703          	lw	a4,-28(s0)
80006094:	fe442783          	lw	a5,-28(s0)
80006098:	0107a783          	lw	a5,16(a5)
8000609c:	00078693          	mv	a3,a5
800060a0:	8000d7b7          	lui	a5,0x8000d
800060a4:	53478613          	addi	a2,a5,1332 # 8000d534 <_bss_end+0xffe4af44>
800060a8:	00068593          	mv	a1,a3
800060ac:	00070513          	mv	a0,a4
800060b0:	03d010ef          	jal	ra,800078ec <printprefix>
800060b4:	fe442783          	lw	a5,-28(s0)
800060b8:	01878713          	addi	a4,a5,24
800060bc:	8000d7b7          	lui	a5,0x8000d
800060c0:	59878793          	addi	a5,a5,1432 # 8000d598 <_bss_end+0xffe4afa8>
800060c4:	00078593          	mv	a1,a5
800060c8:	00070513          	mv	a0,a4
800060cc:	704010ef          	jal	ra,800077d0 <printip>
800060d0:	fe442783          	lw	a5,-28(s0)
800060d4:	0147a603          	lw	a2,20(a5)
800060d8:	8000d7b7          	lui	a5,0x8000d
800060dc:	59878693          	addi	a3,a5,1432 # 8000d598 <_bss_end+0xffe4afa8>
800060e0:	fe442783          	lw	a5,-28(s0)
800060e4:	0287a783          	lw	a5,40(a5)
800060e8:	00078713          	mv	a4,a5
800060ec:	8000d7b7          	lui	a5,0x8000d
800060f0:	53478593          	addi	a1,a5,1332 # 8000d534 <_bss_end+0xffe4af44>
800060f4:	8000c7b7          	lui	a5,0x8000c
800060f8:	d6878513          	addi	a0,a5,-664 # 8000bd68 <_bss_end+0xffe49778>
800060fc:	820fc0ef          	jal	ra,8000211c <printf_>
80006100:	fe842783          	lw	a5,-24(s0)
80006104:	00178793          	addi	a5,a5,1
80006108:	fef42423          	sw	a5,-24(s0)
8000610c:	fdc42783          	lw	a5,-36(s0)
80006110:	fe842703          	lw	a4,-24(s0)
80006114:	f4f74ae3          	blt	a4,a5,80006068 <operate_c+0x2cc>
80006118:	00100793          	li	a5,1
8000611c:	00078513          	mv	a0,a5
80006120:	06c12083          	lw	ra,108(sp)
80006124:	06812403          	lw	s0,104(sp)
80006128:	07010113          	addi	sp,sp,112
8000612c:	00008067          	ret

80006130 <operate_q>:
80006130:	fe010113          	addi	sp,sp,-32
80006134:	00112e23          	sw	ra,28(sp)
80006138:	00812c23          	sw	s0,24(sp)
8000613c:	02010413          	addi	s0,sp,32
80006140:	8000d7b7          	lui	a5,0x8000d
80006144:	50078513          	addi	a0,a5,1280 # 8000d500 <_bss_end+0xffe4af10>
80006148:	100010ef          	jal	ra,80007248 <_getip>
8000614c:	00050793          	mv	a5,a0
80006150:	0017c793          	xori	a5,a5,1
80006154:	0ff7f793          	andi	a5,a5,255
80006158:	02078063          	beqz	a5,80006178 <operate_q+0x48>
8000615c:	8000c7b7          	lui	a5,0x8000c
80006160:	ddc78593          	addi	a1,a5,-548 # 8000bddc <_bss_end+0xffe497ec>
80006164:	8000d7b7          	lui	a5,0x8000d
80006168:	5c878513          	addi	a0,a5,1480 # 8000d5c8 <_bss_end+0xffe4afd8>
8000616c:	830fc0ef          	jal	ra,8000219c <sprintf_>
80006170:	00000793          	li	a5,0
80006174:	1000006f          	j	80006274 <operate_q+0x144>
80006178:	02c010ef          	jal	ra,800071a4 <_getdec>
8000617c:	00050713          	mv	a4,a0
80006180:	801c27b7          	lui	a5,0x801c2
80006184:	5ae7ac23          	sw	a4,1464(a5) # 801c25b8 <_bss_end+0xffffffc8>
80006188:	801c27b7          	lui	a5,0x801c2
8000618c:	5b87a783          	lw	a5,1464(a5) # 801c25b8 <_bss_end+0xffffffc8>
80006190:	0ff7f593          	andi	a1,a5,255
80006194:	8000d7b7          	lui	a5,0x8000d
80006198:	50078793          	addi	a5,a5,1280 # 8000d500 <_bss_end+0xffe4af10>
8000619c:	0007a603          	lw	a2,0(a5)
800061a0:	0047a683          	lw	a3,4(a5)
800061a4:	0087a703          	lw	a4,8(a5)
800061a8:	00c7a783          	lw	a5,12(a5)
800061ac:	fec42023          	sw	a2,-32(s0)
800061b0:	fed42223          	sw	a3,-28(s0)
800061b4:	fee42423          	sw	a4,-24(s0)
800061b8:	fef42623          	sw	a5,-20(s0)
800061bc:	fe040513          	addi	a0,s0,-32
800061c0:	801c27b7          	lui	a5,0x801c2
800061c4:	5c078713          	addi	a4,a5,1472 # 801c25c0 <_bss_end+0xffffffd0>
800061c8:	801c27b7          	lui	a5,0x801c2
800061cc:	5bc78693          	addi	a3,a5,1468 # 801c25bc <_bss_end+0xffffffcc>
800061d0:	8000d7b7          	lui	a5,0x8000d
800061d4:	51078613          	addi	a2,a5,1296 # 8000d510 <_bss_end+0xffe4af20>
800061d8:	374030ef          	jal	ra,8000954c <prefix_query>
800061dc:	00050793          	mv	a5,a0
800061e0:	06078e63          	beqz	a5,8000625c <operate_q+0x12c>
800061e4:	8000d7b7          	lui	a5,0x8000d
800061e8:	53478593          	addi	a1,a5,1332 # 8000d534 <_bss_end+0xffe4af44>
800061ec:	8000d7b7          	lui	a5,0x8000d
800061f0:	51078513          	addi	a0,a5,1296 # 8000d510 <_bss_end+0xffe4af20>
800061f4:	5dc010ef          	jal	ra,800077d0 <printip>
800061f8:	8000d7b7          	lui	a5,0x8000d
800061fc:	51078793          	addi	a5,a5,1296 # 8000d510 <_bss_end+0xffe4af20>
80006200:	0007a603          	lw	a2,0(a5)
80006204:	8000d7b7          	lui	a5,0x8000d
80006208:	51078793          	addi	a5,a5,1296 # 8000d510 <_bss_end+0xffe4af20>
8000620c:	0047a683          	lw	a3,4(a5)
80006210:	8000d7b7          	lui	a5,0x8000d
80006214:	51078793          	addi	a5,a5,1296 # 8000d510 <_bss_end+0xffe4af20>
80006218:	0087a703          	lw	a4,8(a5)
8000621c:	8000d7b7          	lui	a5,0x8000d
80006220:	51078793          	addi	a5,a5,1296 # 8000d510 <_bss_end+0xffe4af20>
80006224:	00c7a583          	lw	a1,12(a5)
80006228:	801c27b7          	lui	a5,0x801c2
8000622c:	5bc7a503          	lw	a0,1468(a5) # 801c25bc <_bss_end+0xffffffcc>
80006230:	801c27b7          	lui	a5,0x801c2
80006234:	5c07a783          	lw	a5,1472(a5) # 801c25c0 <_bss_end+0xffffffd0>
80006238:	00078893          	mv	a7,a5
8000623c:	00050813          	mv	a6,a0
80006240:	00058793          	mv	a5,a1
80006244:	8000c5b7          	lui	a1,0x8000c
80006248:	e0458593          	addi	a1,a1,-508 # 8000be04 <_bss_end+0xffe49814>
8000624c:	8000d537          	lui	a0,0x8000d
80006250:	5c850513          	addi	a0,a0,1480 # 8000d5c8 <_bss_end+0xffe4afd8>
80006254:	f49fb0ef          	jal	ra,8000219c <sprintf_>
80006258:	0180006f          	j	80006270 <operate_q+0x140>
8000625c:	8000c7b7          	lui	a5,0x8000c
80006260:	e2078593          	addi	a1,a5,-480 # 8000be20 <_bss_end+0xffe49830>
80006264:	8000d7b7          	lui	a5,0x8000d
80006268:	5c878513          	addi	a0,a5,1480 # 8000d5c8 <_bss_end+0xffe4afd8>
8000626c:	f31fb0ef          	jal	ra,8000219c <sprintf_>
80006270:	00100793          	li	a5,1
80006274:	00078513          	mv	a0,a5
80006278:	01c12083          	lw	ra,28(sp)
8000627c:	01812403          	lw	s0,24(sp)
80006280:	02010113          	addi	sp,sp,32
80006284:	00008067          	ret

80006288 <init_direct_route>:
80006288:	f9010113          	addi	sp,sp,-112
8000628c:	06112623          	sw	ra,108(sp)
80006290:	06812423          	sw	s0,104(sp)
80006294:	07010413          	addi	s0,sp,112
80006298:	00100793          	li	a5,1
8000629c:	fef40623          	sb	a5,-20(s0)
800062a0:	06aa17b7          	lui	a5,0x6aa1
800062a4:	e2a78793          	addi	a5,a5,-470 # 6aa0e2a <_reset_vector-0x7955f1d6>
800062a8:	fcf42023          	sw	a5,-64(s0)
800062ac:	000a97b7          	lui	a5,0xa9
800062b0:	70478793          	addi	a5,a5,1796 # a9704 <_reset_vector-0x7ff568fc>
800062b4:	fcf42223          	sw	a5,-60(s0)
800062b8:	fc042423          	sw	zero,-56(s0)
800062bc:	fc042623          	sw	zero,-52(s0)
800062c0:	04000793          	li	a5,64
800062c4:	fcf42823          	sw	a5,-48(s0)
800062c8:	fc042a23          	sw	zero,-44(s0)
800062cc:	06aa17b7          	lui	a5,0x6aa1
800062d0:	e2a78793          	addi	a5,a5,-470 # 6aa0e2a <_reset_vector-0x7955f1d6>
800062d4:	fcf42c23          	sw	a5,-40(s0)
800062d8:	000a97b7          	lui	a5,0xa9
800062dc:	70478793          	addi	a5,a5,1796 # a9704 <_reset_vector-0x7ff568fc>
800062e0:	fcf42e23          	sw	a5,-36(s0)
800062e4:	fe042023          	sw	zero,-32(s0)
800062e8:	332307b7          	lui	a5,0x33230
800062ec:	fef42223          	sw	a5,-28(s0)
800062f0:	fe042423          	sw	zero,-24(s0)
800062f4:	fc042f03          	lw	t5,-64(s0)
800062f8:	fc442e83          	lw	t4,-60(s0)
800062fc:	fc842e03          	lw	t3,-56(s0)
80006300:	fcc42303          	lw	t1,-52(s0)
80006304:	fd042883          	lw	a7,-48(s0)
80006308:	fd442803          	lw	a6,-44(s0)
8000630c:	fd842503          	lw	a0,-40(s0)
80006310:	fdc42583          	lw	a1,-36(s0)
80006314:	fe042603          	lw	a2,-32(s0)
80006318:	fe442683          	lw	a3,-28(s0)
8000631c:	fe842703          	lw	a4,-24(s0)
80006320:	fec42783          	lw	a5,-20(s0)
80006324:	f9e42823          	sw	t5,-112(s0)
80006328:	f9d42a23          	sw	t4,-108(s0)
8000632c:	f9c42c23          	sw	t3,-104(s0)
80006330:	f8642e23          	sw	t1,-100(s0)
80006334:	fb142023          	sw	a7,-96(s0)
80006338:	fb042223          	sw	a6,-92(s0)
8000633c:	faa42423          	sw	a0,-88(s0)
80006340:	fab42623          	sw	a1,-84(s0)
80006344:	fac42823          	sw	a2,-80(s0)
80006348:	fad42a23          	sw	a3,-76(s0)
8000634c:	fae42c23          	sw	a4,-72(s0)
80006350:	faf42e23          	sw	a5,-68(s0)
80006354:	f9040793          	addi	a5,s0,-112
80006358:	00078593          	mv	a1,a5
8000635c:	00100513          	li	a0,1
80006360:	679020ef          	jal	ra,800091d8 <update>
80006364:	010a97b7          	lui	a5,0x10a9
80006368:	70478793          	addi	a5,a5,1796 # 10a9704 <_reset_vector-0x7ef568fc>
8000636c:	fcf42223          	sw	a5,-60(s0)
80006370:	00100793          	li	a5,1
80006374:	fcf42a23          	sw	a5,-44(s0)
80006378:	010a97b7          	lui	a5,0x10a9
8000637c:	70478793          	addi	a5,a5,1796 # 10a9704 <_reset_vector-0x7ef568fc>
80006380:	fcf42e23          	sw	a5,-36(s0)
80006384:	443407b7          	lui	a5,0x44340
80006388:	fef42223          	sw	a5,-28(s0)
8000638c:	fc042f03          	lw	t5,-64(s0)
80006390:	fc442e83          	lw	t4,-60(s0)
80006394:	fc842e03          	lw	t3,-56(s0)
80006398:	fcc42303          	lw	t1,-52(s0)
8000639c:	fd042883          	lw	a7,-48(s0)
800063a0:	fd442803          	lw	a6,-44(s0)
800063a4:	fd842503          	lw	a0,-40(s0)
800063a8:	fdc42583          	lw	a1,-36(s0)
800063ac:	fe042603          	lw	a2,-32(s0)
800063b0:	fe442683          	lw	a3,-28(s0)
800063b4:	fe842703          	lw	a4,-24(s0)
800063b8:	fec42783          	lw	a5,-20(s0)
800063bc:	f9e42823          	sw	t5,-112(s0)
800063c0:	f9d42a23          	sw	t4,-108(s0)
800063c4:	f9c42c23          	sw	t3,-104(s0)
800063c8:	f8642e23          	sw	t1,-100(s0)
800063cc:	fb142023          	sw	a7,-96(s0)
800063d0:	fb042223          	sw	a6,-92(s0)
800063d4:	faa42423          	sw	a0,-88(s0)
800063d8:	fab42623          	sw	a1,-84(s0)
800063dc:	fac42823          	sw	a2,-80(s0)
800063e0:	fad42a23          	sw	a3,-76(s0)
800063e4:	fae42c23          	sw	a4,-72(s0)
800063e8:	faf42e23          	sw	a5,-68(s0)
800063ec:	f9040793          	addi	a5,s0,-112
800063f0:	00078593          	mv	a1,a5
800063f4:	00100513          	li	a0,1
800063f8:	5e1020ef          	jal	ra,800091d8 <update>
800063fc:	020a97b7          	lui	a5,0x20a9
80006400:	70478793          	addi	a5,a5,1796 # 20a9704 <_reset_vector-0x7df568fc>
80006404:	fcf42223          	sw	a5,-60(s0)
80006408:	00200793          	li	a5,2
8000640c:	fcf42a23          	sw	a5,-44(s0)
80006410:	020a97b7          	lui	a5,0x20a9
80006414:	70478793          	addi	a5,a5,1796 # 20a9704 <_reset_vector-0x7df568fc>
80006418:	fcf42e23          	sw	a5,-36(s0)
8000641c:	554507b7          	lui	a5,0x55450
80006420:	fef42223          	sw	a5,-28(s0)
80006424:	fc042f03          	lw	t5,-64(s0)
80006428:	fc442e83          	lw	t4,-60(s0)
8000642c:	fc842e03          	lw	t3,-56(s0)
80006430:	fcc42303          	lw	t1,-52(s0)
80006434:	fd042883          	lw	a7,-48(s0)
80006438:	fd442803          	lw	a6,-44(s0)
8000643c:	fd842503          	lw	a0,-40(s0)
80006440:	fdc42583          	lw	a1,-36(s0)
80006444:	fe042603          	lw	a2,-32(s0)
80006448:	fe442683          	lw	a3,-28(s0)
8000644c:	fe842703          	lw	a4,-24(s0)
80006450:	fec42783          	lw	a5,-20(s0)
80006454:	f9e42823          	sw	t5,-112(s0)
80006458:	f9d42a23          	sw	t4,-108(s0)
8000645c:	f9c42c23          	sw	t3,-104(s0)
80006460:	f8642e23          	sw	t1,-100(s0)
80006464:	fb142023          	sw	a7,-96(s0)
80006468:	fb042223          	sw	a6,-92(s0)
8000646c:	faa42423          	sw	a0,-88(s0)
80006470:	fab42623          	sw	a1,-84(s0)
80006474:	fac42823          	sw	a2,-80(s0)
80006478:	fad42a23          	sw	a3,-76(s0)
8000647c:	fae42c23          	sw	a4,-72(s0)
80006480:	faf42e23          	sw	a5,-68(s0)
80006484:	f9040793          	addi	a5,s0,-112
80006488:	00078593          	mv	a1,a5
8000648c:	00100513          	li	a0,1
80006490:	549020ef          	jal	ra,800091d8 <update>
80006494:	030a97b7          	lui	a5,0x30a9
80006498:	70478793          	addi	a5,a5,1796 # 30a9704 <_reset_vector-0x7cf568fc>
8000649c:	fcf42223          	sw	a5,-60(s0)
800064a0:	00300793          	li	a5,3
800064a4:	fcf42a23          	sw	a5,-44(s0)
800064a8:	030a97b7          	lui	a5,0x30a9
800064ac:	70478793          	addi	a5,a5,1796 # 30a9704 <_reset_vector-0x7cf568fc>
800064b0:	fcf42e23          	sw	a5,-36(s0)
800064b4:	665607b7          	lui	a5,0x66560
800064b8:	fef42223          	sw	a5,-28(s0)
800064bc:	fc042f03          	lw	t5,-64(s0)
800064c0:	fc442e83          	lw	t4,-60(s0)
800064c4:	fc842e03          	lw	t3,-56(s0)
800064c8:	fcc42303          	lw	t1,-52(s0)
800064cc:	fd042883          	lw	a7,-48(s0)
800064d0:	fd442803          	lw	a6,-44(s0)
800064d4:	fd842503          	lw	a0,-40(s0)
800064d8:	fdc42583          	lw	a1,-36(s0)
800064dc:	fe042603          	lw	a2,-32(s0)
800064e0:	fe442683          	lw	a3,-28(s0)
800064e4:	fe842703          	lw	a4,-24(s0)
800064e8:	fec42783          	lw	a5,-20(s0)
800064ec:	f9e42823          	sw	t5,-112(s0)
800064f0:	f9d42a23          	sw	t4,-108(s0)
800064f4:	f9c42c23          	sw	t3,-104(s0)
800064f8:	f8642e23          	sw	t1,-100(s0)
800064fc:	fb142023          	sw	a7,-96(s0)
80006500:	fb042223          	sw	a6,-92(s0)
80006504:	faa42423          	sw	a0,-88(s0)
80006508:	fab42623          	sw	a1,-84(s0)
8000650c:	fac42823          	sw	a2,-80(s0)
80006510:	fad42a23          	sw	a3,-76(s0)
80006514:	fae42c23          	sw	a4,-72(s0)
80006518:	faf42e23          	sw	a5,-68(s0)
8000651c:	f9040793          	addi	a5,s0,-112
80006520:	00078593          	mv	a1,a5
80006524:	00100513          	li	a0,1
80006528:	4b1020ef          	jal	ra,800091d8 <update>
8000652c:	00000013          	nop
80006530:	06c12083          	lw	ra,108(sp)
80006534:	06812403          	lw	s0,104(sp)
80006538:	07010113          	addi	sp,sp,112
8000653c:	00008067          	ret

80006540 <dpy_led_timeout>:
80006540:	fe010113          	addi	sp,sp,-32
80006544:	00112e23          	sw	ra,28(sp)
80006548:	00812c23          	sw	s0,24(sp)
8000654c:	02010413          	addi	s0,sp,32
80006550:	fea42623          	sw	a0,-20(s0)
80006554:	feb42423          	sw	a1,-24(s0)
80006558:	fe842703          	lw	a4,-24(s0)
8000655c:	00100793          	li	a5,1
80006560:	02f71263          	bne	a4,a5,80006584 <dpy_led_timeout+0x44>
80006564:	200007b7          	lui	a5,0x20000
80006568:	00878793          	addi	a5,a5,8 # 20000008 <_reset_vector-0x5ffffff8>
8000656c:	0007a703          	lw	a4,0(a5)
80006570:	200007b7          	lui	a5,0x20000
80006574:	00878793          	addi	a5,a5,8 # 20000008 <_reset_vector-0x5ffffff8>
80006578:	00170713          	addi	a4,a4,1
8000657c:	00e7a023          	sw	a4,0(a5)
80006580:	0200006f          	j	800065a0 <dpy_led_timeout+0x60>
80006584:	200007b7          	lui	a5,0x20000
80006588:	00878793          	addi	a5,a5,8 # 20000008 <_reset_vector-0x5ffffff8>
8000658c:	0007a703          	lw	a4,0(a5)
80006590:	200007b7          	lui	a5,0x20000
80006594:	00878793          	addi	a5,a5,8 # 20000008 <_reset_vector-0x5ffffff8>
80006598:	01070713          	addi	a4,a4,16
8000659c:	00e7a023          	sw	a4,0(a5)
800065a0:	fe842783          	lw	a5,-24(s0)
800065a4:	00078593          	mv	a1,a5
800065a8:	fec42503          	lw	a0,-20(s0)
800065ac:	538000ef          	jal	ra,80006ae4 <timer_start>
800065b0:	00000013          	nop
800065b4:	01c12083          	lw	ra,28(sp)
800065b8:	01812403          	lw	s0,24(sp)
800065bc:	02010113          	addi	sp,sp,32
800065c0:	00008067          	ret

800065c4 <start>:
800065c4:	fd010113          	addi	sp,sp,-48
800065c8:	02112623          	sw	ra,44(sp)
800065cc:	02812423          	sw	s0,40(sp)
800065d0:	03010413          	addi	s0,sp,48
800065d4:	fca42e23          	sw	a0,-36(s0)
800065d8:	fcb42c23          	sw	a1,-40(s0)
800065dc:	8000c7b7          	lui	a5,0x8000c
800065e0:	23078793          	addi	a5,a5,560 # 8000c230 <_bss_end+0xffe49c40>
800065e4:	fef42623          	sw	a5,-20(s0)
800065e8:	0180006f          	j	80006600 <start+0x3c>
800065ec:	fec42783          	lw	a5,-20(s0)
800065f0:	0007a023          	sw	zero,0(a5)
800065f4:	fec42783          	lw	a5,-20(s0)
800065f8:	00478793          	addi	a5,a5,4
800065fc:	fef42623          	sw	a5,-20(s0)
80006600:	fec42703          	lw	a4,-20(s0)
80006604:	801c27b7          	lui	a5,0x801c2
80006608:	5f078793          	addi	a5,a5,1520 # 801c25f0 <_bss_end+0x0>
8000660c:	fef710e3          	bne	a4,a5,800065ec <start+0x28>
80006610:	dc1fb0ef          	jal	ra,800023d0 <init_uart>
80006614:	f8dfd0ef          	jal	ra,800045a0 <init_port_config>
80006618:	661030ef          	jal	ra,8000a478 <lookup_init>
8000661c:	c6dff0ef          	jal	ra,80006288 <init_direct_route>
80006620:	9f1fe0ef          	jal	ra,80005010 <display>
80006624:	cd1fd0ef          	jal	ra,800042f4 <ripng_init>
80006628:	01000593          	li	a1,16
8000662c:	8000c7b7          	lui	a5,0x8000c
80006630:	e2878513          	addi	a0,a5,-472 # 8000be28 <_bss_end+0xffe49838>
80006634:	ae9fb0ef          	jal	ra,8000211c <printf_>
80006638:	40000593          	li	a1,1024
8000663c:	8018d7b7          	lui	a5,0x8018d
80006640:	7dc78513          	addi	a0,a5,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
80006644:	165000ef          	jal	ra,80006fa8 <_gets>
80006648:	00050793          	mv	a5,a0
8000664c:	fe0786e3          	beqz	a5,80006638 <start+0x74>
80006650:	8018d7b7          	lui	a5,0x8018d
80006654:	7dc78593          	addi	a1,a5,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
80006658:	8000c7b7          	lui	a5,0x8000c
8000665c:	e3c78513          	addi	a0,a5,-452 # 8000be3c <_bss_end+0xffe4984c>
80006660:	abdfb0ef          	jal	ra,8000211c <printf_>
80006664:	801c27b7          	lui	a5,0x801c2
80006668:	5c07a823          	sw	zero,1488(a5) # 801c25d0 <_bss_end+0xffffffe0>
8000666c:	2c1000ef          	jal	ra,8000712c <_getnonspace>
80006670:	00050793          	mv	a5,a0
80006674:	00078713          	mv	a4,a5
80006678:	801c27b7          	lui	a5,0x801c2
8000667c:	5ce78223          	sb	a4,1476(a5) # 801c25c4 <_bss_end+0xffffffd4>
80006680:	801c27b7          	lui	a5,0x801c2
80006684:	5c47c703          	lbu	a4,1476(a5) # 801c25c4 <_bss_end+0xffffffd4>
80006688:	06500793          	li	a5,101
8000668c:	00f71e63          	bne	a4,a5,800066a8 <start+0xe4>
80006690:	8000c7b7          	lui	a5,0x8000c
80006694:	e4878593          	addi	a1,a5,-440 # 8000be48 <_bss_end+0xffe49858>
80006698:	8000d7b7          	lui	a5,0x8000d
8000669c:	5c878513          	addi	a0,a5,1480 # 8000d5c8 <_bss_end+0xffe4afd8>
800066a0:	afdfb0ef          	jal	ra,8000219c <sprintf_>
800066a4:	1480006f          	j	800067ec <start+0x228>
800066a8:	801c27b7          	lui	a5,0x801c2
800066ac:	5c47c703          	lbu	a4,1476(a5) # 801c25c4 <_bss_end+0xffffffd4>
800066b0:	06100793          	li	a5,97
800066b4:	02f71863          	bne	a4,a5,800066e4 <start+0x120>
800066b8:	af4ff0ef          	jal	ra,800059ac <operate_a>
800066bc:	00050793          	mv	a5,a0
800066c0:	00f037b3          	snez	a5,a5
800066c4:	0ff7f793          	andi	a5,a5,255
800066c8:	0017c793          	xori	a5,a5,1
800066cc:	0ff7f793          	andi	a5,a5,255
800066d0:	0017f793          	andi	a5,a5,1
800066d4:	0ff7f713          	andi	a4,a5,255
800066d8:	801c27b7          	lui	a5,0x801c2
800066dc:	5ce782a3          	sb	a4,1477(a5) # 801c25c5 <_bss_end+0xffffffd5>
800066e0:	10c0006f          	j	800067ec <start+0x228>
800066e4:	801c27b7          	lui	a5,0x801c2
800066e8:	5c47c703          	lbu	a4,1476(a5) # 801c25c4 <_bss_end+0xffffffd4>
800066ec:	06400793          	li	a5,100
800066f0:	02f71863          	bne	a4,a5,80006720 <start+0x15c>
800066f4:	d04ff0ef          	jal	ra,80005bf8 <operate_d>
800066f8:	00050793          	mv	a5,a0
800066fc:	00f037b3          	snez	a5,a5
80006700:	0ff7f793          	andi	a5,a5,255
80006704:	0017c793          	xori	a5,a5,1
80006708:	0ff7f793          	andi	a5,a5,255
8000670c:	0017f793          	andi	a5,a5,1
80006710:	0ff7f713          	andi	a4,a5,255
80006714:	801c27b7          	lui	a5,0x801c2
80006718:	5ce782a3          	sb	a4,1477(a5) # 801c25c5 <_bss_end+0xffffffd5>
8000671c:	0d00006f          	j	800067ec <start+0x228>
80006720:	801c27b7          	lui	a5,0x801c2
80006724:	5c47c703          	lbu	a4,1476(a5) # 801c25c4 <_bss_end+0xffffffd4>
80006728:	06300793          	li	a5,99
8000672c:	02f71863          	bne	a4,a5,8000675c <start+0x198>
80006730:	e6cff0ef          	jal	ra,80005d9c <operate_c>
80006734:	00050793          	mv	a5,a0
80006738:	00f037b3          	snez	a5,a5
8000673c:	0ff7f793          	andi	a5,a5,255
80006740:	0017c793          	xori	a5,a5,1
80006744:	0ff7f793          	andi	a5,a5,255
80006748:	0017f793          	andi	a5,a5,1
8000674c:	0ff7f713          	andi	a4,a5,255
80006750:	801c27b7          	lui	a5,0x801c2
80006754:	5ce782a3          	sb	a4,1477(a5) # 801c25c5 <_bss_end+0xffffffd5>
80006758:	0940006f          	j	800067ec <start+0x228>
8000675c:	801c27b7          	lui	a5,0x801c2
80006760:	5c47c703          	lbu	a4,1476(a5) # 801c25c4 <_bss_end+0xffffffd4>
80006764:	06600793          	li	a5,102
80006768:	02f71463          	bne	a4,a5,80006790 <start+0x1cc>
8000676c:	801c27b7          	lui	a5,0x801c2
80006770:	5c0782a3          	sb	zero,1477(a5) # 801c25c5 <_bss_end+0xffffffd5>
80006774:	8000c7b7          	lui	a5,0x8000c
80006778:	e5c78593          	addi	a1,a5,-420 # 8000be5c <_bss_end+0xffe4986c>
8000677c:	8000d7b7          	lui	a5,0x8000d
80006780:	5c878513          	addi	a0,a5,1480 # 8000d5c8 <_bss_end+0xffe4afd8>
80006784:	a19fb0ef          	jal	ra,8000219c <sprintf_>
80006788:	840fa0ef          	jal	ra,800007c8 <dma_demo>
8000678c:	0600006f          	j	800067ec <start+0x228>
80006790:	801c27b7          	lui	a5,0x801c2
80006794:	5c47c703          	lbu	a4,1476(a5) # 801c25c4 <_bss_end+0xffffffd4>
80006798:	07100793          	li	a5,113
8000679c:	02f71863          	bne	a4,a5,800067cc <start+0x208>
800067a0:	991ff0ef          	jal	ra,80006130 <operate_q>
800067a4:	00050793          	mv	a5,a0
800067a8:	00f037b3          	snez	a5,a5
800067ac:	0ff7f793          	andi	a5,a5,255
800067b0:	0017c793          	xori	a5,a5,1
800067b4:	0ff7f793          	andi	a5,a5,255
800067b8:	0017f793          	andi	a5,a5,1
800067bc:	0ff7f713          	andi	a4,a5,255
800067c0:	801c27b7          	lui	a5,0x801c2
800067c4:	5ce782a3          	sb	a4,1477(a5) # 801c25c5 <_bss_end+0xffffffd5>
800067c8:	0240006f          	j	800067ec <start+0x228>
800067cc:	801c27b7          	lui	a5,0x801c2
800067d0:	00100713          	li	a4,1
800067d4:	5ce782a3          	sb	a4,1477(a5) # 801c25c5 <_bss_end+0xffffffd5>
800067d8:	8000c7b7          	lui	a5,0x8000c
800067dc:	e7078593          	addi	a1,a5,-400 # 8000be70 <_bss_end+0xffe49880>
800067e0:	8000d7b7          	lui	a5,0x8000d
800067e4:	5c878513          	addi	a0,a5,1480 # 8000d5c8 <_bss_end+0xffe4afd8>
800067e8:	9b5fb0ef          	jal	ra,8000219c <sprintf_>
800067ec:	8000d7b7          	lui	a5,0x8000d
800067f0:	5c878593          	addi	a1,a5,1480 # 8000d5c8 <_bss_end+0xffe4afd8>
800067f4:	8000c7b7          	lui	a5,0x8000c
800067f8:	e8478513          	addi	a0,a5,-380 # 8000be84 <_bss_end+0xffe49894>
800067fc:	921fb0ef          	jal	ra,8000211c <printf_>
80006800:	811fe0ef          	jal	ra,80005010 <display>
80006804:	e35ff06f          	j	80006638 <start+0x74>

80006808 <_timer_expired>:
80006808:	fe010113          	addi	sp,sp,-32
8000680c:	00812e23          	sw	s0,28(sp)
80006810:	02010413          	addi	s0,sp,32
80006814:	fea42623          	sw	a0,-20(s0)
80006818:	feb42423          	sw	a1,-24(s0)
8000681c:	0200c7b7          	lui	a5,0x200c
80006820:	ff878793          	addi	a5,a5,-8 # 200bff8 <_reset_vector-0x7dff4008>
80006824:	0007a703          	lw	a4,0(a5)
80006828:	fec42783          	lw	a5,-20(s0)
8000682c:	0107a683          	lw	a3,16(a5)
80006830:	fe842783          	lw	a5,-24(s0)
80006834:	00279793          	slli	a5,a5,0x2
80006838:	00f687b3          	add	a5,a3,a5
8000683c:	0007a783          	lw	a5,0(a5)
80006840:	40f70733          	sub	a4,a4,a5
80006844:	fec42783          	lw	a5,-20(s0)
80006848:	0047a783          	lw	a5,4(a5)
8000684c:	00f737b3          	sltu	a5,a4,a5
80006850:	0017c793          	xori	a5,a5,1
80006854:	0ff7f793          	andi	a5,a5,255
80006858:	00078513          	mv	a0,a5
8000685c:	01c12403          	lw	s0,28(sp)
80006860:	02010113          	addi	sp,sp,32
80006864:	00008067          	ret

80006868 <timer_init>:
80006868:	fd010113          	addi	sp,sp,-48
8000686c:	02812623          	sw	s0,44(sp)
80006870:	03010413          	addi	s0,sp,48
80006874:	fca42e23          	sw	a0,-36(s0)
80006878:	fcb42c23          	sw	a1,-40(s0)
8000687c:	801c27b7          	lui	a5,0x801c2
80006880:	5c87a703          	lw	a4,1480(a5) # 801c25c8 <_bss_end+0xffffffd8>
80006884:	00170693          	addi	a3,a4,1
80006888:	801c27b7          	lui	a5,0x801c2
8000688c:	5cd7a423          	sw	a3,1480(a5) # 801c25c8 <_bss_end+0xffffffd8>
80006890:	00070793          	mv	a5,a4
80006894:	00379793          	slli	a5,a5,0x3
80006898:	40e787b3          	sub	a5,a5,a4
8000689c:	00279793          	slli	a5,a5,0x2
800068a0:	8000d737          	lui	a4,0x8000d
800068a4:	64c70713          	addi	a4,a4,1612 # 8000d64c <_bss_end+0xffe4b05c>
800068a8:	00e787b3          	add	a5,a5,a4
800068ac:	fef42623          	sw	a5,-20(s0)
800068b0:	fec42783          	lw	a5,-20(s0)
800068b4:	0007aa23          	sw	zero,20(a5)
800068b8:	fec42783          	lw	a5,-20(s0)
800068bc:	0007ac23          	sw	zero,24(a5)
800068c0:	fec42783          	lw	a5,-20(s0)
800068c4:	fdc42703          	lw	a4,-36(s0)
800068c8:	00e7a223          	sw	a4,4(a5)
800068cc:	801c27b7          	lui	a5,0x801c2
800068d0:	5cc7a783          	lw	a5,1484(a5) # 801c25cc <_bss_end+0xffffffdc>
800068d4:	00279713          	slli	a4,a5,0x2
800068d8:	8000d7b7          	lui	a5,0x8000d
800068dc:	76478793          	addi	a5,a5,1892 # 8000d764 <_bss_end+0xffe4b174>
800068e0:	00f70733          	add	a4,a4,a5
800068e4:	fec42783          	lw	a5,-20(s0)
800068e8:	00e7a423          	sw	a4,8(a5)
800068ec:	801c27b7          	lui	a5,0x801c2
800068f0:	5cc7a703          	lw	a4,1484(a5) # 801c25cc <_bss_end+0xffffffdc>
800068f4:	000207b7          	lui	a5,0x20
800068f8:	00a78793          	addi	a5,a5,10 # 2000a <_reset_vector-0x7ffdfff6>
800068fc:	00f707b3          	add	a5,a4,a5
80006900:	00279713          	slli	a4,a5,0x2
80006904:	8000d7b7          	lui	a5,0x8000d
80006908:	76478793          	addi	a5,a5,1892 # 8000d764 <_bss_end+0xffe4b174>
8000690c:	00f70733          	add	a4,a4,a5
80006910:	fec42783          	lw	a5,-20(s0)
80006914:	00e7a623          	sw	a4,12(a5)
80006918:	801c27b7          	lui	a5,0x801c2
8000691c:	5cc7a703          	lw	a4,1484(a5) # 801c25cc <_bss_end+0xffffffdc>
80006920:	000407b7          	lui	a5,0x40
80006924:	01478793          	addi	a5,a5,20 # 40014 <_reset_vector-0x7ffbffec>
80006928:	00f707b3          	add	a5,a4,a5
8000692c:	00279713          	slli	a4,a5,0x2
80006930:	8000d7b7          	lui	a5,0x8000d
80006934:	76478793          	addi	a5,a5,1892 # 8000d764 <_bss_end+0xffe4b174>
80006938:	00f70733          	add	a4,a4,a5
8000693c:	fec42783          	lw	a5,-20(s0)
80006940:	00e7a823          	sw	a4,16(a5)
80006944:	801c27b7          	lui	a5,0x801c2
80006948:	5cc7a703          	lw	a4,1484(a5) # 801c25cc <_bss_end+0xffffffdc>
8000694c:	fd842783          	lw	a5,-40(s0)
80006950:	00f70733          	add	a4,a4,a5
80006954:	801c27b7          	lui	a5,0x801c2
80006958:	5ce7a623          	sw	a4,1484(a5) # 801c25cc <_bss_end+0xffffffdc>
8000695c:	fec42783          	lw	a5,-20(s0)
80006960:	00078513          	mv	a0,a5
80006964:	02c12403          	lw	s0,44(sp)
80006968:	03010113          	addi	sp,sp,48
8000696c:	00008067          	ret

80006970 <timer_set_timeout>:
80006970:	fe010113          	addi	sp,sp,-32
80006974:	00812e23          	sw	s0,28(sp)
80006978:	02010413          	addi	s0,sp,32
8000697c:	fea42623          	sw	a0,-20(s0)
80006980:	feb42423          	sw	a1,-24(s0)
80006984:	fec42783          	lw	a5,-20(s0)
80006988:	fe842703          	lw	a4,-24(s0)
8000698c:	00e7a023          	sw	a4,0(a5)
80006990:	00000013          	nop
80006994:	01c12403          	lw	s0,28(sp)
80006998:	02010113          	addi	sp,sp,32
8000699c:	00008067          	ret

800069a0 <timer_stop>:
800069a0:	fe010113          	addi	sp,sp,-32
800069a4:	00812e23          	sw	s0,28(sp)
800069a8:	02010413          	addi	s0,sp,32
800069ac:	fea42623          	sw	a0,-20(s0)
800069b0:	feb42423          	sw	a1,-24(s0)
800069b4:	fec42783          	lw	a5,-20(s0)
800069b8:	00c7a703          	lw	a4,12(a5)
800069bc:	fe842783          	lw	a5,-24(s0)
800069c0:	00279793          	slli	a5,a5,0x2
800069c4:	00f707b3          	add	a5,a4,a5
800069c8:	0007a783          	lw	a5,0(a5)
800069cc:	04078463          	beqz	a5,80006a14 <timer_stop+0x74>
800069d0:	fec42783          	lw	a5,-20(s0)
800069d4:	0087a703          	lw	a4,8(a5)
800069d8:	fe842783          	lw	a5,-24(s0)
800069dc:	00279793          	slli	a5,a5,0x2
800069e0:	00f70733          	add	a4,a4,a5
800069e4:	fec42783          	lw	a5,-20(s0)
800069e8:	0087a683          	lw	a3,8(a5)
800069ec:	fec42783          	lw	a5,-20(s0)
800069f0:	00c7a603          	lw	a2,12(a5)
800069f4:	fe842783          	lw	a5,-24(s0)
800069f8:	00279793          	slli	a5,a5,0x2
800069fc:	00f607b3          	add	a5,a2,a5
80006a00:	0007a783          	lw	a5,0(a5)
80006a04:	00279793          	slli	a5,a5,0x2
80006a08:	00f687b3          	add	a5,a3,a5
80006a0c:	00072703          	lw	a4,0(a4)
80006a10:	00e7a023          	sw	a4,0(a5)
80006a14:	fec42783          	lw	a5,-20(s0)
80006a18:	0087a703          	lw	a4,8(a5)
80006a1c:	fe842783          	lw	a5,-24(s0)
80006a20:	00279793          	slli	a5,a5,0x2
80006a24:	00f707b3          	add	a5,a4,a5
80006a28:	0007a783          	lw	a5,0(a5)
80006a2c:	04078463          	beqz	a5,80006a74 <timer_stop+0xd4>
80006a30:	fec42783          	lw	a5,-20(s0)
80006a34:	00c7a703          	lw	a4,12(a5)
80006a38:	fe842783          	lw	a5,-24(s0)
80006a3c:	00279793          	slli	a5,a5,0x2
80006a40:	00f70733          	add	a4,a4,a5
80006a44:	fec42783          	lw	a5,-20(s0)
80006a48:	00c7a683          	lw	a3,12(a5)
80006a4c:	fec42783          	lw	a5,-20(s0)
80006a50:	0087a603          	lw	a2,8(a5)
80006a54:	fe842783          	lw	a5,-24(s0)
80006a58:	00279793          	slli	a5,a5,0x2
80006a5c:	00f607b3          	add	a5,a2,a5
80006a60:	0007a783          	lw	a5,0(a5)
80006a64:	00279793          	slli	a5,a5,0x2
80006a68:	00f687b3          	add	a5,a3,a5
80006a6c:	00072703          	lw	a4,0(a4)
80006a70:	00e7a023          	sw	a4,0(a5)
80006a74:	fec42783          	lw	a5,-20(s0)
80006a78:	0147a783          	lw	a5,20(a5)
80006a7c:	fe842703          	lw	a4,-24(s0)
80006a80:	02f71263          	bne	a4,a5,80006aa4 <timer_stop+0x104>
80006a84:	fec42783          	lw	a5,-20(s0)
80006a88:	0087a703          	lw	a4,8(a5)
80006a8c:	fe842783          	lw	a5,-24(s0)
80006a90:	00279793          	slli	a5,a5,0x2
80006a94:	00f707b3          	add	a5,a4,a5
80006a98:	0007a703          	lw	a4,0(a5)
80006a9c:	fec42783          	lw	a5,-20(s0)
80006aa0:	00e7aa23          	sw	a4,20(a5)
80006aa4:	fec42783          	lw	a5,-20(s0)
80006aa8:	0187a783          	lw	a5,24(a5)
80006aac:	fe842703          	lw	a4,-24(s0)
80006ab0:	02f71263          	bne	a4,a5,80006ad4 <timer_stop+0x134>
80006ab4:	fec42783          	lw	a5,-20(s0)
80006ab8:	00c7a703          	lw	a4,12(a5)
80006abc:	fe842783          	lw	a5,-24(s0)
80006ac0:	00279793          	slli	a5,a5,0x2
80006ac4:	00f707b3          	add	a5,a4,a5
80006ac8:	0007a703          	lw	a4,0(a5)
80006acc:	fec42783          	lw	a5,-20(s0)
80006ad0:	00e7ac23          	sw	a4,24(a5)
80006ad4:	00000013          	nop
80006ad8:	01c12403          	lw	s0,28(sp)
80006adc:	02010113          	addi	sp,sp,32
80006ae0:	00008067          	ret

80006ae4 <timer_start>:
80006ae4:	fe010113          	addi	sp,sp,-32
80006ae8:	00812e23          	sw	s0,28(sp)
80006aec:	02010413          	addi	s0,sp,32
80006af0:	fea42623          	sw	a0,-20(s0)
80006af4:	feb42423          	sw	a1,-24(s0)
80006af8:	0200c7b7          	lui	a5,0x200c
80006afc:	ff878713          	addi	a4,a5,-8 # 200bff8 <_reset_vector-0x7dff4008>
80006b00:	fec42783          	lw	a5,-20(s0)
80006b04:	0107a683          	lw	a3,16(a5)
80006b08:	fe842783          	lw	a5,-24(s0)
80006b0c:	00279793          	slli	a5,a5,0x2
80006b10:	00f687b3          	add	a5,a3,a5
80006b14:	00072703          	lw	a4,0(a4)
80006b18:	00e7a023          	sw	a4,0(a5)
80006b1c:	fec42783          	lw	a5,-20(s0)
80006b20:	0147a783          	lw	a5,20(a5)
80006b24:	04079863          	bnez	a5,80006b74 <timer_start+0x90>
80006b28:	fec42783          	lw	a5,-20(s0)
80006b2c:	fe842703          	lw	a4,-24(s0)
80006b30:	00e7aa23          	sw	a4,20(a5)
80006b34:	fec42783          	lw	a5,-20(s0)
80006b38:	fe842703          	lw	a4,-24(s0)
80006b3c:	00e7ac23          	sw	a4,24(a5)
80006b40:	fec42783          	lw	a5,-20(s0)
80006b44:	0087a703          	lw	a4,8(a5)
80006b48:	fe842783          	lw	a5,-24(s0)
80006b4c:	00279793          	slli	a5,a5,0x2
80006b50:	00f707b3          	add	a5,a4,a5
80006b54:	0007a023          	sw	zero,0(a5)
80006b58:	fec42783          	lw	a5,-20(s0)
80006b5c:	00c7a703          	lw	a4,12(a5)
80006b60:	fe842783          	lw	a5,-24(s0)
80006b64:	00279793          	slli	a5,a5,0x2
80006b68:	00f707b3          	add	a5,a4,a5
80006b6c:	0007a023          	sw	zero,0(a5)
80006b70:	0680006f          	j	80006bd8 <timer_start+0xf4>
80006b74:	fec42783          	lw	a5,-20(s0)
80006b78:	00c7a703          	lw	a4,12(a5)
80006b7c:	fe842783          	lw	a5,-24(s0)
80006b80:	00279793          	slli	a5,a5,0x2
80006b84:	00f707b3          	add	a5,a4,a5
80006b88:	fec42703          	lw	a4,-20(s0)
80006b8c:	01872703          	lw	a4,24(a4)
80006b90:	00e7a023          	sw	a4,0(a5)
80006b94:	fec42783          	lw	a5,-20(s0)
80006b98:	0087a703          	lw	a4,8(a5)
80006b9c:	fe842783          	lw	a5,-24(s0)
80006ba0:	00279793          	slli	a5,a5,0x2
80006ba4:	00f707b3          	add	a5,a4,a5
80006ba8:	0007a023          	sw	zero,0(a5)
80006bac:	fec42783          	lw	a5,-20(s0)
80006bb0:	0087a703          	lw	a4,8(a5)
80006bb4:	fec42783          	lw	a5,-20(s0)
80006bb8:	0187a783          	lw	a5,24(a5)
80006bbc:	00279793          	slli	a5,a5,0x2
80006bc0:	00f707b3          	add	a5,a4,a5
80006bc4:	fe842703          	lw	a4,-24(s0)
80006bc8:	00e7a023          	sw	a4,0(a5)
80006bcc:	fec42783          	lw	a5,-20(s0)
80006bd0:	fe842703          	lw	a4,-24(s0)
80006bd4:	00e7ac23          	sw	a4,24(a5)
80006bd8:	01c12403          	lw	s0,28(sp)
80006bdc:	02010113          	addi	sp,sp,32
80006be0:	00008067          	ret

80006be4 <timer_tick>:
80006be4:	fd010113          	addi	sp,sp,-48
80006be8:	02112623          	sw	ra,44(sp)
80006bec:	02812423          	sw	s0,40(sp)
80006bf0:	03010413          	addi	s0,sp,48
80006bf4:	fca42e23          	sw	a0,-36(s0)
80006bf8:	fdc42783          	lw	a5,-36(s0)
80006bfc:	0147a783          	lw	a5,20(a5)
80006c00:	fef42623          	sw	a5,-20(s0)
80006c04:	0580006f          	j	80006c5c <timer_tick+0x78>
80006c08:	fec42583          	lw	a1,-20(s0)
80006c0c:	fdc42503          	lw	a0,-36(s0)
80006c10:	bf9ff0ef          	jal	ra,80006808 <_timer_expired>
80006c14:	00050793          	mv	a5,a0
80006c18:	02078463          	beqz	a5,80006c40 <timer_tick+0x5c>
80006c1c:	fec42583          	lw	a1,-20(s0)
80006c20:	fdc42503          	lw	a0,-36(s0)
80006c24:	d7dff0ef          	jal	ra,800069a0 <timer_stop>
80006c28:	fdc42783          	lw	a5,-36(s0)
80006c2c:	0007a703          	lw	a4,0(a5)
80006c30:	fec42783          	lw	a5,-20(s0)
80006c34:	00078593          	mv	a1,a5
80006c38:	fdc42503          	lw	a0,-36(s0)
80006c3c:	000700e7          	jalr	a4
80006c40:	fdc42783          	lw	a5,-36(s0)
80006c44:	0087a703          	lw	a4,8(a5)
80006c48:	fec42783          	lw	a5,-20(s0)
80006c4c:	00279793          	slli	a5,a5,0x2
80006c50:	00f707b3          	add	a5,a4,a5
80006c54:	0007a783          	lw	a5,0(a5)
80006c58:	fef42623          	sw	a5,-20(s0)
80006c5c:	fec42783          	lw	a5,-20(s0)
80006c60:	fa0794e3          	bnez	a5,80006c08 <timer_tick+0x24>
80006c64:	00000013          	nop
80006c68:	00000013          	nop
80006c6c:	02c12083          	lw	ra,44(sp)
80006c70:	02812403          	lw	s0,40(sp)
80006c74:	03010113          	addi	sp,sp,48
80006c78:	00008067          	ret

80006c7c <timer_tick_all>:
80006c7c:	fe010113          	addi	sp,sp,-32
80006c80:	00112e23          	sw	ra,28(sp)
80006c84:	00812c23          	sw	s0,24(sp)
80006c88:	02010413          	addi	s0,sp,32
80006c8c:	fe042623          	sw	zero,-20(s0)
80006c90:	0380006f          	j	80006cc8 <timer_tick_all+0x4c>
80006c94:	fec42703          	lw	a4,-20(s0)
80006c98:	00070793          	mv	a5,a4
80006c9c:	00379793          	slli	a5,a5,0x3
80006ca0:	40e787b3          	sub	a5,a5,a4
80006ca4:	00279793          	slli	a5,a5,0x2
80006ca8:	8000d737          	lui	a4,0x8000d
80006cac:	64c70713          	addi	a4,a4,1612 # 8000d64c <_bss_end+0xffe4b05c>
80006cb0:	00e787b3          	add	a5,a5,a4
80006cb4:	00078513          	mv	a0,a5
80006cb8:	f2dff0ef          	jal	ra,80006be4 <timer_tick>
80006cbc:	fec42783          	lw	a5,-20(s0)
80006cc0:	00178793          	addi	a5,a5,1
80006cc4:	fef42623          	sw	a5,-20(s0)
80006cc8:	801c27b7          	lui	a5,0x801c2
80006ccc:	5c87a783          	lw	a5,1480(a5) # 801c25c8 <_bss_end+0xffffffd8>
80006cd0:	fec42703          	lw	a4,-20(s0)
80006cd4:	fcf740e3          	blt	a4,a5,80006c94 <timer_tick_all+0x18>
80006cd8:	00000013          	nop
80006cdc:	00000013          	nop
80006ce0:	01c12083          	lw	ra,28(sp)
80006ce4:	01812403          	lw	s0,24(sp)
80006ce8:	02010113          	addi	sp,sp,32
80006cec:	00008067          	ret

80006cf0 <timer>:
80006cf0:	fc010113          	addi	sp,sp,-64
80006cf4:	02112e23          	sw	ra,60(sp)
80006cf8:	02812c23          	sw	s0,56(sp)
80006cfc:	03212a23          	sw	s2,52(sp)
80006d00:	03312823          	sw	s3,48(sp)
80006d04:	03412623          	sw	s4,44(sp)
80006d08:	03512423          	sw	s5,40(sp)
80006d0c:	03612223          	sw	s6,36(sp)
80006d10:	03712023          	sw	s7,32(sp)
80006d14:	01812e23          	sw	s8,28(sp)
80006d18:	01912c23          	sw	s9,24(sp)
80006d1c:	01a12a23          	sw	s10,20(sp)
80006d20:	01b12823          	sw	s11,16(sp)
80006d24:	04010413          	addi	s0,sp,64
80006d28:	0200c7b7          	lui	a5,0x200c
80006d2c:	ff878793          	addi	a5,a5,-8 # 200bff8 <_reset_vector-0x7dff4008>
80006d30:	0007a783          	lw	a5,0(a5)
80006d34:	fcf42223          	sw	a5,-60(s0)
80006d38:	8018e7b7          	lui	a5,0x8018e
80006d3c:	be07a783          	lw	a5,-1056(a5) # 8018dbe0 <_bss_end+0xfffcb5f0>
80006d40:	fc442703          	lw	a4,-60(s0)
80006d44:	00f77a63          	bgeu	a4,a5,80006d58 <timer+0x68>
80006d48:	8018e7b7          	lui	a5,0x8018e
80006d4c:	fc442703          	lw	a4,-60(s0)
80006d50:	bee7a023          	sw	a4,-1056(a5) # 8018dbe0 <_bss_end+0xfffcb5f0>
80006d54:	18c0006f          	j	80006ee0 <timer+0x1f0>
80006d58:	8018e7b7          	lui	a5,0x8018e
80006d5c:	be07a783          	lw	a5,-1056(a5) # 8018dbe0 <_bss_end+0xfffcb5f0>
80006d60:	fc442703          	lw	a4,-60(s0)
80006d64:	40f70733          	sub	a4,a4,a5
80006d68:	009897b7          	lui	a5,0x989
80006d6c:	68078793          	addi	a5,a5,1664 # 989680 <_reset_vector-0x7f676980>
80006d70:	16e7f863          	bgeu	a5,a4,80006ee0 <timer+0x1f0>
80006d74:	fc042623          	sw	zero,-52(s0)
80006d78:	14c0006f          	j	80006ec4 <timer+0x1d4>
80006d7c:	fc042423          	sw	zero,-56(s0)
80006d80:	12c0006f          	j	80006eac <timer+0x1bc>
80006d84:	fc842703          	lw	a4,-56(s0)
80006d88:	006007b7          	lui	a5,0x600
80006d8c:	00f707b3          	add	a5,a4,a5
80006d90:	00679713          	slli	a4,a5,0x6
80006d94:	fcc42783          	lw	a5,-52(s0)
80006d98:	00f707b3          	add	a5,a4,a5
80006d9c:	00279793          	slli	a5,a5,0x2
80006da0:	0007a783          	lw	a5,0(a5) # 600000 <_reset_vector-0x7fa00000>
80006da4:	fcf42023          	sw	a5,-64(s0)
80006da8:	fc042783          	lw	a5,-64(s0)
80006dac:	00078913          	mv	s2,a5
80006db0:	00000993          	li	s3,0
80006db4:	00090713          	mv	a4,s2
80006db8:	00098793          	mv	a5,s3
80006dbc:	01b75693          	srli	a3,a4,0x1b
80006dc0:	00579a93          	slli	s5,a5,0x5
80006dc4:	0156eab3          	or	s5,a3,s5
80006dc8:	00571a13          	slli	s4,a4,0x5
80006dcc:	000a0713          	mv	a4,s4
80006dd0:	000a8793          	mv	a5,s5
80006dd4:	41270633          	sub	a2,a4,s2
80006dd8:	00060593          	mv	a1,a2
80006ddc:	00b735b3          	sltu	a1,a4,a1
80006de0:	413786b3          	sub	a3,a5,s3
80006de4:	40b687b3          	sub	a5,a3,a1
80006de8:	00078693          	mv	a3,a5
80006dec:	00060713          	mv	a4,a2
80006df0:	00068793          	mv	a5,a3
80006df4:	01e75693          	srli	a3,a4,0x1e
80006df8:	00279b93          	slli	s7,a5,0x2
80006dfc:	0176ebb3          	or	s7,a3,s7
80006e00:	00271b13          	slli	s6,a4,0x2
80006e04:	000b0713          	mv	a4,s6
80006e08:	000b8793          	mv	a5,s7
80006e0c:	01270633          	add	a2,a4,s2
80006e10:	00060593          	mv	a1,a2
80006e14:	00e5b5b3          	sltu	a1,a1,a4
80006e18:	013786b3          	add	a3,a5,s3
80006e1c:	00d587b3          	add	a5,a1,a3
80006e20:	00078693          	mv	a3,a5
80006e24:	00060713          	mv	a4,a2
80006e28:	00068793          	mv	a5,a3
80006e2c:	01d75693          	srli	a3,a4,0x1d
80006e30:	00379c93          	slli	s9,a5,0x3
80006e34:	0196ecb3          	or	s9,a3,s9
80006e38:	00371c13          	slli	s8,a4,0x3
80006e3c:	000c0713          	mv	a4,s8
80006e40:	000c8793          	mv	a5,s9
80006e44:	00070513          	mv	a0,a4
80006e48:	00078593          	mv	a1,a5
80006e4c:	8018e7b7          	lui	a5,0x8018e
80006e50:	be07a783          	lw	a5,-1056(a5) # 8018dbe0 <_bss_end+0xfffcb5f0>
80006e54:	fc442703          	lw	a4,-60(s0)
80006e58:	40f707b3          	sub	a5,a4,a5
80006e5c:	00078d13          	mv	s10,a5
80006e60:	00000d93          	li	s11,0
80006e64:	000d0613          	mv	a2,s10
80006e68:	000d8693          	mv	a3,s11
80006e6c:	000040ef          	jal	ra,8000ae6c <__divdi3>
80006e70:	00050713          	mv	a4,a0
80006e74:	00058793          	mv	a5,a1
80006e78:	00070613          	mv	a2,a4
80006e7c:	8000d7b7          	lui	a5,0x8000d
80006e80:	62c78713          	addi	a4,a5,1580 # 8000d62c <_bss_end+0xffe4b03c>
80006e84:	fcc42783          	lw	a5,-52(s0)
80006e88:	00279693          	slli	a3,a5,0x2
80006e8c:	fc842783          	lw	a5,-56(s0)
80006e90:	00f687b3          	add	a5,a3,a5
80006e94:	00279793          	slli	a5,a5,0x2
80006e98:	00f707b3          	add	a5,a4,a5
80006e9c:	00c7a023          	sw	a2,0(a5)
80006ea0:	fc842783          	lw	a5,-56(s0)
80006ea4:	00178793          	addi	a5,a5,1
80006ea8:	fcf42423          	sw	a5,-56(s0)
80006eac:	fc842703          	lw	a4,-56(s0)
80006eb0:	00300793          	li	a5,3
80006eb4:	ece7d8e3          	bge	a5,a4,80006d84 <timer+0x94>
80006eb8:	fcc42783          	lw	a5,-52(s0)
80006ebc:	00178793          	addi	a5,a5,1
80006ec0:	fcf42623          	sw	a5,-52(s0)
80006ec4:	fcc42703          	lw	a4,-52(s0)
80006ec8:	00100793          	li	a5,1
80006ecc:	eae7d8e3          	bge	a5,a4,80006d7c <timer+0x8c>
80006ed0:	fcdfd0ef          	jal	ra,80004e9c <draw_speed>
80006ed4:	8018e7b7          	lui	a5,0x8018e
80006ed8:	fc442703          	lw	a4,-60(s0)
80006edc:	bee7a023          	sw	a4,-1056(a5) # 8018dbe0 <_bss_end+0xfffcb5f0>
80006ee0:	00000013          	nop
80006ee4:	03c12083          	lw	ra,60(sp)
80006ee8:	03812403          	lw	s0,56(sp)
80006eec:	03412903          	lw	s2,52(sp)
80006ef0:	03012983          	lw	s3,48(sp)
80006ef4:	02c12a03          	lw	s4,44(sp)
80006ef8:	02812a83          	lw	s5,40(sp)
80006efc:	02412b03          	lw	s6,36(sp)
80006f00:	02012b83          	lw	s7,32(sp)
80006f04:	01c12c03          	lw	s8,28(sp)
80006f08:	01812c83          	lw	s9,24(sp)
80006f0c:	01412d03          	lw	s10,20(sp)
80006f10:	01012d83          	lw	s11,16(sp)
80006f14:	04010113          	addi	sp,sp,64
80006f18:	00008067          	ret

80006f1c <_getchar>:
80006f1c:	fe010113          	addi	sp,sp,-32
80006f20:	00112e23          	sw	ra,28(sp)
80006f24:	00812c23          	sw	s0,24(sp)
80006f28:	02010413          	addi	s0,sp,32
80006f2c:	dc5ff0ef          	jal	ra,80006cf0 <timer>
80006f30:	d4dff0ef          	jal	ra,80006c7c <timer_tick_all>
80006f34:	200007b7          	lui	a5,0x20000
80006f38:	0007a783          	lw	a5,0(a5) # 20000000 <_reset_vector-0x60000000>
80006f3c:	fef42623          	sw	a5,-20(s0)
80006f40:	fec42703          	lw	a4,-20(s0)
80006f44:	ff0007b7          	lui	a5,0xff000
80006f48:	00f777b3          	and	a5,a4,a5
80006f4c:	00079a63          	bnez	a5,80006f60 <_getchar+0x44>
80006f50:	fec42503          	lw	a0,-20(s0)
80006f54:	bd1f90ef          	jal	ra,80000b24 <gpio_decode>
80006f58:	00050793          	mv	a5,a0
80006f5c:	0380006f          	j	80006f94 <_getchar+0x78>
80006f60:	100007b7          	lui	a5,0x10000
80006f64:	00578793          	addi	a5,a5,5 # 10000005 <_reset_vector-0x6ffffffb>
80006f68:	0007c783          	lbu	a5,0(a5)
80006f6c:	0ff7f793          	andi	a5,a5,255
80006f70:	0017f793          	andi	a5,a5,1
80006f74:	00078a63          	beqz	a5,80006f88 <_getchar+0x6c>
80006f78:	100007b7          	lui	a5,0x10000
80006f7c:	0007c783          	lbu	a5,0(a5) # 10000000 <_reset_vector-0x70000000>
80006f80:	0ff7f793          	andi	a5,a5,255
80006f84:	0100006f          	j	80006f94 <_getchar+0x78>
80006f88:	00100513          	li	a0,1
80006f8c:	ac5fd0ef          	jal	ra,80004a50 <mainloop>
80006f90:	f9dff06f          	j	80006f2c <_getchar+0x10>
80006f94:	00078513          	mv	a0,a5
80006f98:	01c12083          	lw	ra,28(sp)
80006f9c:	01812403          	lw	s0,24(sp)
80006fa0:	02010113          	addi	sp,sp,32
80006fa4:	00008067          	ret

80006fa8 <_gets>:
80006fa8:	fd010113          	addi	sp,sp,-48
80006fac:	02112623          	sw	ra,44(sp)
80006fb0:	02812423          	sw	s0,40(sp)
80006fb4:	02912223          	sw	s1,36(sp)
80006fb8:	03010413          	addi	s0,sp,48
80006fbc:	fca42e23          	sw	a0,-36(s0)
80006fc0:	fcb42c23          	sw	a1,-40(s0)
80006fc4:	fe042623          	sw	zero,-20(s0)
80006fc8:	13c0006f          	j	80007104 <_gets+0x15c>
80006fcc:	fec42783          	lw	a5,-20(s0)
80006fd0:	fdc42703          	lw	a4,-36(s0)
80006fd4:	00f704b3          	add	s1,a4,a5
80006fd8:	f45ff0ef          	jal	ra,80006f1c <_getchar>
80006fdc:	00050793          	mv	a5,a0
80006fe0:	00f48023          	sb	a5,0(s1)
80006fe4:	fec42783          	lw	a5,-20(s0)
80006fe8:	fdc42703          	lw	a4,-36(s0)
80006fec:	00f707b3          	add	a5,a4,a5
80006ff0:	0007c703          	lbu	a4,0(a5)
80006ff4:	00800793          	li	a5,8
80006ff8:	08f71463          	bne	a4,a5,80007080 <_gets+0xd8>
80006ffc:	fec42783          	lw	a5,-20(s0)
80007000:	fdc42703          	lw	a4,-36(s0)
80007004:	00f707b3          	add	a5,a4,a5
80007008:	00078023          	sb	zero,0(a5)
8000700c:	fec42783          	lw	a5,-20(s0)
80007010:	06f05063          	blez	a5,80007070 <_gets+0xc8>
80007014:	fec42783          	lw	a5,-20(s0)
80007018:	fff78793          	addi	a5,a5,-1
8000701c:	fdc42703          	lw	a4,-36(s0)
80007020:	00f707b3          	add	a5,a4,a5
80007024:	00078023          	sb	zero,0(a5)
80007028:	fec42783          	lw	a5,-20(s0)
8000702c:	00278793          	addi	a5,a5,2
80007030:	0ff00693          	li	a3,255
80007034:	02000613          	li	a2,32
80007038:	00078593          	mv	a1,a5
8000703c:	02800513          	li	a0,40
80007040:	a8df90ef          	jal	ra,80000acc <update_pos>
80007044:	fec42783          	lw	a5,-20(s0)
80007048:	00178793          	addi	a5,a5,1
8000704c:	01c00693          	li	a3,28
80007050:	05f00613          	li	a2,95
80007054:	00078593          	mv	a1,a5
80007058:	02800513          	li	a0,40
8000705c:	a71f90ef          	jal	ra,80000acc <update_pos>
80007060:	fec42783          	lw	a5,-20(s0)
80007064:	ffe78793          	addi	a5,a5,-2
80007068:	fef42623          	sw	a5,-20(s0)
8000706c:	08c0006f          	j	800070f8 <_gets+0x150>
80007070:	fec42783          	lw	a5,-20(s0)
80007074:	fff78793          	addi	a5,a5,-1
80007078:	fef42623          	sw	a5,-20(s0)
8000707c:	07c0006f          	j	800070f8 <_gets+0x150>
80007080:	fec42783          	lw	a5,-20(s0)
80007084:	fdc42703          	lw	a4,-36(s0)
80007088:	00f707b3          	add	a5,a4,a5
8000708c:	0007c703          	lbu	a4,0(a5)
80007090:	00a00793          	li	a5,10
80007094:	02f71063          	bne	a4,a5,800070b4 <_gets+0x10c>
80007098:	fec42783          	lw	a5,-20(s0)
8000709c:	00178793          	addi	a5,a5,1
800070a0:	fdc42703          	lw	a4,-36(s0)
800070a4:	00f707b3          	add	a5,a4,a5
800070a8:	00078023          	sb	zero,0(a5)
800070ac:	00100793          	li	a5,1
800070b0:	0640006f          	j	80007114 <_gets+0x16c>
800070b4:	fec42783          	lw	a5,-20(s0)
800070b8:	00278593          	addi	a1,a5,2
800070bc:	fec42783          	lw	a5,-20(s0)
800070c0:	fdc42703          	lw	a4,-36(s0)
800070c4:	00f707b3          	add	a5,a4,a5
800070c8:	0007c783          	lbu	a5,0(a5)
800070cc:	0ff00693          	li	a3,255
800070d0:	00078613          	mv	a2,a5
800070d4:	02800513          	li	a0,40
800070d8:	9f5f90ef          	jal	ra,80000acc <update_pos>
800070dc:	fec42783          	lw	a5,-20(s0)
800070e0:	00378793          	addi	a5,a5,3
800070e4:	01c00693          	li	a3,28
800070e8:	05f00613          	li	a2,95
800070ec:	00078593          	mv	a1,a5
800070f0:	02800513          	li	a0,40
800070f4:	9d9f90ef          	jal	ra,80000acc <update_pos>
800070f8:	fec42783          	lw	a5,-20(s0)
800070fc:	00178793          	addi	a5,a5,1
80007100:	fef42623          	sw	a5,-20(s0)
80007104:	fec42703          	lw	a4,-20(s0)
80007108:	fd842783          	lw	a5,-40(s0)
8000710c:	ecf740e3          	blt	a4,a5,80006fcc <_gets+0x24>
80007110:	00000793          	li	a5,0
80007114:	00078513          	mv	a0,a5
80007118:	02c12083          	lw	ra,44(sp)
8000711c:	02812403          	lw	s0,40(sp)
80007120:	02412483          	lw	s1,36(sp)
80007124:	03010113          	addi	sp,sp,48
80007128:	00008067          	ret

8000712c <_getnonspace>:
8000712c:	ff010113          	addi	sp,sp,-16
80007130:	00812623          	sw	s0,12(sp)
80007134:	01010413          	addi	s0,sp,16
80007138:	0180006f          	j	80007150 <_getnonspace+0x24>
8000713c:	801c27b7          	lui	a5,0x801c2
80007140:	5d07a783          	lw	a5,1488(a5) # 801c25d0 <_bss_end+0xffffffe0>
80007144:	00178713          	addi	a4,a5,1
80007148:	801c27b7          	lui	a5,0x801c2
8000714c:	5ce7a823          	sw	a4,1488(a5) # 801c25d0 <_bss_end+0xffffffe0>
80007150:	801c27b7          	lui	a5,0x801c2
80007154:	5d07a783          	lw	a5,1488(a5) # 801c25d0 <_bss_end+0xffffffe0>
80007158:	8018d737          	lui	a4,0x8018d
8000715c:	7dc70713          	addi	a4,a4,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
80007160:	00f707b3          	add	a5,a4,a5
80007164:	0007c703          	lbu	a4,0(a5)
80007168:	02000793          	li	a5,32
8000716c:	fcf708e3          	beq	a4,a5,8000713c <_getnonspace+0x10>
80007170:	801c27b7          	lui	a5,0x801c2
80007174:	5d07a783          	lw	a5,1488(a5) # 801c25d0 <_bss_end+0xffffffe0>
80007178:	00178693          	addi	a3,a5,1
8000717c:	801c2737          	lui	a4,0x801c2
80007180:	5cd72823          	sw	a3,1488(a4) # 801c25d0 <_bss_end+0xffffffe0>
80007184:	8018d737          	lui	a4,0x8018d
80007188:	7dc70713          	addi	a4,a4,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
8000718c:	00f707b3          	add	a5,a4,a5
80007190:	0007c783          	lbu	a5,0(a5)
80007194:	00078513          	mv	a0,a5
80007198:	00c12403          	lw	s0,12(sp)
8000719c:	01010113          	addi	sp,sp,16
800071a0:	00008067          	ret

800071a4 <_getdec>:
800071a4:	fe010113          	addi	sp,sp,-32
800071a8:	00112e23          	sw	ra,28(sp)
800071ac:	00812c23          	sw	s0,24(sp)
800071b0:	02010413          	addi	s0,sp,32
800071b4:	fe042623          	sw	zero,-20(s0)
800071b8:	f75ff0ef          	jal	ra,8000712c <_getnonspace>
800071bc:	00050793          	mv	a5,a0
800071c0:	fef405a3          	sb	a5,-21(s0)
800071c4:	0540006f          	j	80007218 <_getdec+0x74>
800071c8:	fec42703          	lw	a4,-20(s0)
800071cc:	00070793          	mv	a5,a4
800071d0:	00279793          	slli	a5,a5,0x2
800071d4:	00e787b3          	add	a5,a5,a4
800071d8:	00179793          	slli	a5,a5,0x1
800071dc:	00078713          	mv	a4,a5
800071e0:	feb44783          	lbu	a5,-21(s0)
800071e4:	00f707b3          	add	a5,a4,a5
800071e8:	fd078793          	addi	a5,a5,-48
800071ec:	fef42623          	sw	a5,-20(s0)
800071f0:	801c27b7          	lui	a5,0x801c2
800071f4:	5d07a783          	lw	a5,1488(a5) # 801c25d0 <_bss_end+0xffffffe0>
800071f8:	00178693          	addi	a3,a5,1
800071fc:	801c2737          	lui	a4,0x801c2
80007200:	5cd72823          	sw	a3,1488(a4) # 801c25d0 <_bss_end+0xffffffe0>
80007204:	8018d737          	lui	a4,0x8018d
80007208:	7dc70713          	addi	a4,a4,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
8000720c:	00f707b3          	add	a5,a4,a5
80007210:	0007c783          	lbu	a5,0(a5)
80007214:	fef405a3          	sb	a5,-21(s0)
80007218:	feb44703          	lbu	a4,-21(s0)
8000721c:	02f00793          	li	a5,47
80007220:	00e7f863          	bgeu	a5,a4,80007230 <_getdec+0x8c>
80007224:	feb44703          	lbu	a4,-21(s0)
80007228:	03900793          	li	a5,57
8000722c:	f8e7fee3          	bgeu	a5,a4,800071c8 <_getdec+0x24>
80007230:	fec42783          	lw	a5,-20(s0)
80007234:	00078513          	mv	a0,a5
80007238:	01c12083          	lw	ra,28(sp)
8000723c:	01812403          	lw	s0,24(sp)
80007240:	02010113          	addi	sp,sp,32
80007244:	00008067          	ret

80007248 <_getip>:
80007248:	fc010113          	addi	sp,sp,-64
8000724c:	02812e23          	sw	s0,60(sp)
80007250:	04010413          	addi	s0,sp,64
80007254:	fca42623          	sw	a0,-52(s0)
80007258:	0180006f          	j	80007270 <_getip+0x28>
8000725c:	801c27b7          	lui	a5,0x801c2
80007260:	5d07a783          	lw	a5,1488(a5) # 801c25d0 <_bss_end+0xffffffe0>
80007264:	00178713          	addi	a4,a5,1
80007268:	801c27b7          	lui	a5,0x801c2
8000726c:	5ce7a823          	sw	a4,1488(a5) # 801c25d0 <_bss_end+0xffffffe0>
80007270:	801c27b7          	lui	a5,0x801c2
80007274:	5d07a783          	lw	a5,1488(a5) # 801c25d0 <_bss_end+0xffffffe0>
80007278:	8018d737          	lui	a4,0x8018d
8000727c:	7dc70713          	addi	a4,a4,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
80007280:	00f707b3          	add	a5,a4,a5
80007284:	0007c703          	lbu	a4,0(a5)
80007288:	02000793          	li	a5,32
8000728c:	fcf708e3          	beq	a4,a5,8000725c <_getip+0x14>
80007290:	801c27b7          	lui	a5,0x801c2
80007294:	5d07a783          	lw	a5,1488(a5) # 801c25d0 <_bss_end+0xffffffe0>
80007298:	fef42623          	sw	a5,-20(s0)
8000729c:	0180006f          	j	800072b4 <_getip+0x6c>
800072a0:	801c27b7          	lui	a5,0x801c2
800072a4:	5d07a783          	lw	a5,1488(a5) # 801c25d0 <_bss_end+0xffffffe0>
800072a8:	00178713          	addi	a4,a5,1
800072ac:	801c27b7          	lui	a5,0x801c2
800072b0:	5ce7a823          	sw	a4,1488(a5) # 801c25d0 <_bss_end+0xffffffe0>
800072b4:	801c27b7          	lui	a5,0x801c2
800072b8:	5d07a783          	lw	a5,1488(a5) # 801c25d0 <_bss_end+0xffffffe0>
800072bc:	8018d737          	lui	a4,0x8018d
800072c0:	7dc70713          	addi	a4,a4,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
800072c4:	00f707b3          	add	a5,a4,a5
800072c8:	0007c703          	lbu	a4,0(a5)
800072cc:	02f00793          	li	a5,47
800072d0:	02e7f263          	bgeu	a5,a4,800072f4 <_getip+0xac>
800072d4:	801c27b7          	lui	a5,0x801c2
800072d8:	5d07a783          	lw	a5,1488(a5) # 801c25d0 <_bss_end+0xffffffe0>
800072dc:	8018d737          	lui	a4,0x8018d
800072e0:	7dc70713          	addi	a4,a4,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
800072e4:	00f707b3          	add	a5,a4,a5
800072e8:	0007c703          	lbu	a4,0(a5)
800072ec:	03900793          	li	a5,57
800072f0:	fae7f8e3          	bgeu	a5,a4,800072a0 <_getip+0x58>
800072f4:	801c27b7          	lui	a5,0x801c2
800072f8:	5d07a783          	lw	a5,1488(a5) # 801c25d0 <_bss_end+0xffffffe0>
800072fc:	8018d737          	lui	a4,0x8018d
80007300:	7dc70713          	addi	a4,a4,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
80007304:	00f707b3          	add	a5,a4,a5
80007308:	0007c703          	lbu	a4,0(a5)
8000730c:	06000793          	li	a5,96
80007310:	02e7f263          	bgeu	a5,a4,80007334 <_getip+0xec>
80007314:	801c27b7          	lui	a5,0x801c2
80007318:	5d07a783          	lw	a5,1488(a5) # 801c25d0 <_bss_end+0xffffffe0>
8000731c:	8018d737          	lui	a4,0x8018d
80007320:	7dc70713          	addi	a4,a4,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
80007324:	00f707b3          	add	a5,a4,a5
80007328:	0007c703          	lbu	a4,0(a5)
8000732c:	06600793          	li	a5,102
80007330:	f6e7f8e3          	bgeu	a5,a4,800072a0 <_getip+0x58>
80007334:	801c27b7          	lui	a5,0x801c2
80007338:	5d07a783          	lw	a5,1488(a5) # 801c25d0 <_bss_end+0xffffffe0>
8000733c:	8018d737          	lui	a4,0x8018d
80007340:	7dc70713          	addi	a4,a4,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
80007344:	00f707b3          	add	a5,a4,a5
80007348:	0007c703          	lbu	a4,0(a5)
8000734c:	03a00793          	li	a5,58
80007350:	f4f708e3          	beq	a4,a5,800072a0 <_getip+0x58>
80007354:	801c27b7          	lui	a5,0x801c2
80007358:	5d07a783          	lw	a5,1488(a5) # 801c25d0 <_bss_end+0xffffffe0>
8000735c:	fcf42823          	sw	a5,-48(s0)
80007360:	fe042423          	sw	zero,-24(s0)
80007364:	0240006f          	j	80007388 <_getip+0x140>
80007368:	fcc42703          	lw	a4,-52(s0)
8000736c:	fe842783          	lw	a5,-24(s0)
80007370:	00179793          	slli	a5,a5,0x1
80007374:	00f707b3          	add	a5,a4,a5
80007378:	00079023          	sh	zero,0(a5)
8000737c:	fe842783          	lw	a5,-24(s0)
80007380:	00178793          	addi	a5,a5,1
80007384:	fef42423          	sw	a5,-24(s0)
80007388:	fe842703          	lw	a4,-24(s0)
8000738c:	00700793          	li	a5,7
80007390:	fce7dce3          	bge	a5,a4,80007368 <_getip+0x120>
80007394:	fec42783          	lw	a5,-20(s0)
80007398:	00278793          	addi	a5,a5,2
8000739c:	fd042703          	lw	a4,-48(s0)
800073a0:	04f71463          	bne	a4,a5,800073e8 <_getip+0x1a0>
800073a4:	8018d7b7          	lui	a5,0x8018d
800073a8:	7dc78713          	addi	a4,a5,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
800073ac:	fec42783          	lw	a5,-20(s0)
800073b0:	00f707b3          	add	a5,a4,a5
800073b4:	0007c703          	lbu	a4,0(a5)
800073b8:	03a00793          	li	a5,58
800073bc:	02f71663          	bne	a4,a5,800073e8 <_getip+0x1a0>
800073c0:	fec42783          	lw	a5,-20(s0)
800073c4:	00178793          	addi	a5,a5,1
800073c8:	8018d737          	lui	a4,0x8018d
800073cc:	7dc70713          	addi	a4,a4,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
800073d0:	00f707b3          	add	a5,a4,a5
800073d4:	0007c703          	lbu	a4,0(a5)
800073d8:	03a00793          	li	a5,58
800073dc:	00f71663          	bne	a4,a5,800073e8 <_getip+0x1a0>
800073e0:	00100793          	li	a5,1
800073e4:	3900006f          	j	80007774 <_getip+0x52c>
800073e8:	fd042703          	lw	a4,-48(s0)
800073ec:	fec42783          	lw	a5,-20(s0)
800073f0:	40f70733          	sub	a4,a4,a5
800073f4:	00200793          	li	a5,2
800073f8:	00e7c663          	blt	a5,a4,80007404 <_getip+0x1bc>
800073fc:	00000793          	li	a5,0
80007400:	3740006f          	j	80007774 <_getip+0x52c>
80007404:	fe042223          	sw	zero,-28(s0)
80007408:	fe042023          	sw	zero,-32(s0)
8000740c:	2bc0006f          	j	800076c8 <_getip+0x480>
80007410:	8018d7b7          	lui	a5,0x8018d
80007414:	7dc78713          	addi	a4,a5,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
80007418:	fec42783          	lw	a5,-20(s0)
8000741c:	00f707b3          	add	a5,a4,a5
80007420:	0007c703          	lbu	a4,0(a5)
80007424:	03a00793          	li	a5,58
80007428:	12f71263          	bne	a4,a5,8000754c <_getip+0x304>
8000742c:	fec42783          	lw	a5,-20(s0)
80007430:	00178793          	addi	a5,a5,1
80007434:	fd042703          	lw	a4,-48(s0)
80007438:	0ee7d663          	bge	a5,a4,80007524 <_getip+0x2dc>
8000743c:	fec42783          	lw	a5,-20(s0)
80007440:	00178793          	addi	a5,a5,1
80007444:	8018d737          	lui	a4,0x8018d
80007448:	7dc70713          	addi	a4,a4,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
8000744c:	00f707b3          	add	a5,a4,a5
80007450:	0007c703          	lbu	a4,0(a5)
80007454:	03a00793          	li	a5,58
80007458:	0cf71663          	bne	a4,a5,80007524 <_getip+0x2dc>
8000745c:	fc042e23          	sw	zero,-36(s0)
80007460:	fec42783          	lw	a5,-20(s0)
80007464:	00178793          	addi	a5,a5,1
80007468:	fcf42c23          	sw	a5,-40(s0)
8000746c:	0700006f          	j	800074dc <_getip+0x294>
80007470:	8018d7b7          	lui	a5,0x8018d
80007474:	7dc78713          	addi	a4,a5,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
80007478:	fd842783          	lw	a5,-40(s0)
8000747c:	00f707b3          	add	a5,a4,a5
80007480:	0007c703          	lbu	a4,0(a5)
80007484:	03a00793          	li	a5,58
80007488:	04f71463          	bne	a4,a5,800074d0 <_getip+0x288>
8000748c:	fdc42783          	lw	a5,-36(s0)
80007490:	00178793          	addi	a5,a5,1
80007494:	fcf42e23          	sw	a5,-36(s0)
80007498:	fd842783          	lw	a5,-40(s0)
8000749c:	00178793          	addi	a5,a5,1
800074a0:	fd042703          	lw	a4,-48(s0)
800074a4:	02e7d663          	bge	a5,a4,800074d0 <_getip+0x288>
800074a8:	fd842783          	lw	a5,-40(s0)
800074ac:	00178793          	addi	a5,a5,1
800074b0:	8018d737          	lui	a4,0x8018d
800074b4:	7dc70713          	addi	a4,a4,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
800074b8:	00f707b3          	add	a5,a4,a5
800074bc:	0007c703          	lbu	a4,0(a5)
800074c0:	03a00793          	li	a5,58
800074c4:	00f71663          	bne	a4,a5,800074d0 <_getip+0x288>
800074c8:	00000793          	li	a5,0
800074cc:	2a80006f          	j	80007774 <_getip+0x52c>
800074d0:	fd842783          	lw	a5,-40(s0)
800074d4:	00178793          	addi	a5,a5,1
800074d8:	fcf42c23          	sw	a5,-40(s0)
800074dc:	fd842703          	lw	a4,-40(s0)
800074e0:	fd042783          	lw	a5,-48(s0)
800074e4:	f8f746e3          	blt	a4,a5,80007470 <_getip+0x228>
800074e8:	fe442703          	lw	a4,-28(s0)
800074ec:	fdc42783          	lw	a5,-36(s0)
800074f0:	00f70733          	add	a4,a4,a5
800074f4:	00800793          	li	a5,8
800074f8:	00e7d663          	bge	a5,a4,80007504 <_getip+0x2bc>
800074fc:	00000793          	li	a5,0
80007500:	2740006f          	j	80007774 <_getip+0x52c>
80007504:	00800713          	li	a4,8
80007508:	fdc42783          	lw	a5,-36(s0)
8000750c:	40f707b3          	sub	a5,a4,a5
80007510:	fef42223          	sw	a5,-28(s0)
80007514:	fec42783          	lw	a5,-20(s0)
80007518:	00178793          	addi	a5,a5,1
8000751c:	fef42623          	sw	a5,-20(s0)
80007520:	0240006f          	j	80007544 <_getip+0x2fc>
80007524:	fe442783          	lw	a5,-28(s0)
80007528:	00178793          	addi	a5,a5,1
8000752c:	fef42223          	sw	a5,-28(s0)
80007530:	fe442703          	lw	a4,-28(s0)
80007534:	00700793          	li	a5,7
80007538:	00e7d663          	bge	a5,a4,80007544 <_getip+0x2fc>
8000753c:	00000793          	li	a5,0
80007540:	2340006f          	j	80007774 <_getip+0x52c>
80007544:	fe042023          	sw	zero,-32(s0)
80007548:	1740006f          	j	800076bc <_getip+0x474>
8000754c:	fe042783          	lw	a5,-32(s0)
80007550:	00178793          	addi	a5,a5,1
80007554:	fef42023          	sw	a5,-32(s0)
80007558:	fe042703          	lw	a4,-32(s0)
8000755c:	00400793          	li	a5,4
80007560:	00e7d663          	bge	a5,a4,8000756c <_getip+0x324>
80007564:	00000793          	li	a5,0
80007568:	20c0006f          	j	80007774 <_getip+0x52c>
8000756c:	8018d7b7          	lui	a5,0x8018d
80007570:	7dc78713          	addi	a4,a5,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
80007574:	fec42783          	lw	a5,-20(s0)
80007578:	00f707b3          	add	a5,a4,a5
8000757c:	0007c703          	lbu	a4,0(a5)
80007580:	02f00793          	li	a5,47
80007584:	08e7f663          	bgeu	a5,a4,80007610 <_getip+0x3c8>
80007588:	8018d7b7          	lui	a5,0x8018d
8000758c:	7dc78713          	addi	a4,a5,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
80007590:	fec42783          	lw	a5,-20(s0)
80007594:	00f707b3          	add	a5,a4,a5
80007598:	0007c703          	lbu	a4,0(a5)
8000759c:	03900793          	li	a5,57
800075a0:	06e7e863          	bltu	a5,a4,80007610 <_getip+0x3c8>
800075a4:	fcc42703          	lw	a4,-52(s0)
800075a8:	fe442783          	lw	a5,-28(s0)
800075ac:	00179793          	slli	a5,a5,0x1
800075b0:	00f707b3          	add	a5,a4,a5
800075b4:	0007d783          	lhu	a5,0(a5)
800075b8:	00479793          	slli	a5,a5,0x4
800075bc:	01079713          	slli	a4,a5,0x10
800075c0:	01075713          	srli	a4,a4,0x10
800075c4:	8018d7b7          	lui	a5,0x8018d
800075c8:	7dc78693          	addi	a3,a5,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
800075cc:	fec42783          	lw	a5,-20(s0)
800075d0:	00f687b3          	add	a5,a3,a5
800075d4:	0007c783          	lbu	a5,0(a5)
800075d8:	01079793          	slli	a5,a5,0x10
800075dc:	0107d793          	srli	a5,a5,0x10
800075e0:	00f707b3          	add	a5,a4,a5
800075e4:	01079793          	slli	a5,a5,0x10
800075e8:	0107d793          	srli	a5,a5,0x10
800075ec:	fd078793          	addi	a5,a5,-48
800075f0:	01079713          	slli	a4,a5,0x10
800075f4:	01075713          	srli	a4,a4,0x10
800075f8:	fcc42683          	lw	a3,-52(s0)
800075fc:	fe442783          	lw	a5,-28(s0)
80007600:	00179793          	slli	a5,a5,0x1
80007604:	00f687b3          	add	a5,a3,a5
80007608:	00e79023          	sh	a4,0(a5)
8000760c:	0b00006f          	j	800076bc <_getip+0x474>
80007610:	8018d7b7          	lui	a5,0x8018d
80007614:	7dc78713          	addi	a4,a5,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
80007618:	fec42783          	lw	a5,-20(s0)
8000761c:	00f707b3          	add	a5,a4,a5
80007620:	0007c703          	lbu	a4,0(a5)
80007624:	06000793          	li	a5,96
80007628:	08e7f663          	bgeu	a5,a4,800076b4 <_getip+0x46c>
8000762c:	8018d7b7          	lui	a5,0x8018d
80007630:	7dc78713          	addi	a4,a5,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
80007634:	fec42783          	lw	a5,-20(s0)
80007638:	00f707b3          	add	a5,a4,a5
8000763c:	0007c703          	lbu	a4,0(a5)
80007640:	06600793          	li	a5,102
80007644:	06e7e863          	bltu	a5,a4,800076b4 <_getip+0x46c>
80007648:	fcc42703          	lw	a4,-52(s0)
8000764c:	fe442783          	lw	a5,-28(s0)
80007650:	00179793          	slli	a5,a5,0x1
80007654:	00f707b3          	add	a5,a4,a5
80007658:	0007d783          	lhu	a5,0(a5)
8000765c:	00479793          	slli	a5,a5,0x4
80007660:	01079713          	slli	a4,a5,0x10
80007664:	01075713          	srli	a4,a4,0x10
80007668:	8018d7b7          	lui	a5,0x8018d
8000766c:	7dc78693          	addi	a3,a5,2012 # 8018d7dc <_bss_end+0xfffcb1ec>
80007670:	fec42783          	lw	a5,-20(s0)
80007674:	00f687b3          	add	a5,a3,a5
80007678:	0007c783          	lbu	a5,0(a5)
8000767c:	01079793          	slli	a5,a5,0x10
80007680:	0107d793          	srli	a5,a5,0x10
80007684:	00f707b3          	add	a5,a4,a5
80007688:	01079793          	slli	a5,a5,0x10
8000768c:	0107d793          	srli	a5,a5,0x10
80007690:	fa978793          	addi	a5,a5,-87
80007694:	01079713          	slli	a4,a5,0x10
80007698:	01075713          	srli	a4,a4,0x10
8000769c:	fcc42683          	lw	a3,-52(s0)
800076a0:	fe442783          	lw	a5,-28(s0)
800076a4:	00179793          	slli	a5,a5,0x1
800076a8:	00f687b3          	add	a5,a3,a5
800076ac:	00e79023          	sh	a4,0(a5)
800076b0:	00c0006f          	j	800076bc <_getip+0x474>
800076b4:	00000793          	li	a5,0
800076b8:	0bc0006f          	j	80007774 <_getip+0x52c>
800076bc:	fec42783          	lw	a5,-20(s0)
800076c0:	00178793          	addi	a5,a5,1
800076c4:	fef42623          	sw	a5,-20(s0)
800076c8:	fec42703          	lw	a4,-20(s0)
800076cc:	fd042783          	lw	a5,-48(s0)
800076d0:	d4f740e3          	blt	a4,a5,80007410 <_getip+0x1c8>
800076d4:	fc042a23          	sw	zero,-44(s0)
800076d8:	0800006f          	j	80007758 <_getip+0x510>
800076dc:	fcc42703          	lw	a4,-52(s0)
800076e0:	fd442783          	lw	a5,-44(s0)
800076e4:	00179793          	slli	a5,a5,0x1
800076e8:	00f707b3          	add	a5,a4,a5
800076ec:	0007d783          	lhu	a5,0(a5)
800076f0:	00879793          	slli	a5,a5,0x8
800076f4:	01079713          	slli	a4,a5,0x10
800076f8:	41075713          	srai	a4,a4,0x10
800076fc:	fcc42683          	lw	a3,-52(s0)
80007700:	fd442783          	lw	a5,-44(s0)
80007704:	00179793          	slli	a5,a5,0x1
80007708:	00f687b3          	add	a5,a3,a5
8000770c:	0007d783          	lhu	a5,0(a5)
80007710:	0087d793          	srli	a5,a5,0x8
80007714:	01079793          	slli	a5,a5,0x10
80007718:	0107d793          	srli	a5,a5,0x10
8000771c:	01079793          	slli	a5,a5,0x10
80007720:	4107d793          	srai	a5,a5,0x10
80007724:	00f767b3          	or	a5,a4,a5
80007728:	01079793          	slli	a5,a5,0x10
8000772c:	4107d793          	srai	a5,a5,0x10
80007730:	01079713          	slli	a4,a5,0x10
80007734:	01075713          	srli	a4,a4,0x10
80007738:	fcc42683          	lw	a3,-52(s0)
8000773c:	fd442783          	lw	a5,-44(s0)
80007740:	00179793          	slli	a5,a5,0x1
80007744:	00f687b3          	add	a5,a3,a5
80007748:	00e79023          	sh	a4,0(a5)
8000774c:	fd442783          	lw	a5,-44(s0)
80007750:	00178793          	addi	a5,a5,1
80007754:	fcf42a23          	sw	a5,-44(s0)
80007758:	fd442703          	lw	a4,-44(s0)
8000775c:	00700793          	li	a5,7
80007760:	f6e7dee3          	bge	a5,a4,800076dc <_getip+0x494>
80007764:	fe442783          	lw	a5,-28(s0)
80007768:	ff978793          	addi	a5,a5,-7
8000776c:	0017b793          	seqz	a5,a5
80007770:	0ff7f793          	andi	a5,a5,255
80007774:	00078513          	mv	a0,a5
80007778:	03c12403          	lw	s0,60(sp)
8000777c:	04010113          	addi	sp,sp,64
80007780:	00008067          	ret

80007784 <hextochar>:
80007784:	fe010113          	addi	sp,sp,-32
80007788:	00812e23          	sw	s0,28(sp)
8000778c:	02010413          	addi	s0,sp,32
80007790:	00050793          	mv	a5,a0
80007794:	fef407a3          	sb	a5,-17(s0)
80007798:	fef44703          	lbu	a4,-17(s0)
8000779c:	00900793          	li	a5,9
800077a0:	00e7ea63          	bltu	a5,a4,800077b4 <hextochar+0x30>
800077a4:	fef44783          	lbu	a5,-17(s0)
800077a8:	03078793          	addi	a5,a5,48
800077ac:	0ff7f793          	andi	a5,a5,255
800077b0:	0100006f          	j	800077c0 <hextochar+0x3c>
800077b4:	fef44783          	lbu	a5,-17(s0)
800077b8:	05778793          	addi	a5,a5,87
800077bc:	0ff7f793          	andi	a5,a5,255
800077c0:	00078513          	mv	a0,a5
800077c4:	01c12403          	lw	s0,28(sp)
800077c8:	02010113          	addi	sp,sp,32
800077cc:	00008067          	ret

800077d0 <printip>:
800077d0:	fd010113          	addi	sp,sp,-48
800077d4:	02112623          	sw	ra,44(sp)
800077d8:	02812423          	sw	s0,40(sp)
800077dc:	02912223          	sw	s1,36(sp)
800077e0:	03010413          	addi	s0,sp,48
800077e4:	fca42e23          	sw	a0,-36(s0)
800077e8:	fcb42c23          	sw	a1,-40(s0)
800077ec:	fe042623          	sw	zero,-20(s0)
800077f0:	fe042423          	sw	zero,-24(s0)
800077f4:	0c40006f          	j	800078b8 <printip+0xe8>
800077f8:	fe842783          	lw	a5,-24(s0)
800077fc:	02f05863          	blez	a5,8000782c <printip+0x5c>
80007800:	fe842783          	lw	a5,-24(s0)
80007804:	0017f793          	andi	a5,a5,1
80007808:	02079263          	bnez	a5,8000782c <printip+0x5c>
8000780c:	fec42783          	lw	a5,-20(s0)
80007810:	00178713          	addi	a4,a5,1
80007814:	fee42623          	sw	a4,-20(s0)
80007818:	00078713          	mv	a4,a5
8000781c:	fd842783          	lw	a5,-40(s0)
80007820:	00e787b3          	add	a5,a5,a4
80007824:	03a00713          	li	a4,58
80007828:	00e78023          	sb	a4,0(a5)
8000782c:	fdc42703          	lw	a4,-36(s0)
80007830:	fe842783          	lw	a5,-24(s0)
80007834:	00f707b3          	add	a5,a4,a5
80007838:	0007c783          	lbu	a5,0(a5)
8000783c:	0047d793          	srli	a5,a5,0x4
80007840:	0ff7f693          	andi	a3,a5,255
80007844:	fec42783          	lw	a5,-20(s0)
80007848:	00178713          	addi	a4,a5,1
8000784c:	fee42623          	sw	a4,-20(s0)
80007850:	00078713          	mv	a4,a5
80007854:	fd842783          	lw	a5,-40(s0)
80007858:	00e784b3          	add	s1,a5,a4
8000785c:	00068513          	mv	a0,a3
80007860:	f25ff0ef          	jal	ra,80007784 <hextochar>
80007864:	00050793          	mv	a5,a0
80007868:	00f48023          	sb	a5,0(s1)
8000786c:	fdc42703          	lw	a4,-36(s0)
80007870:	fe842783          	lw	a5,-24(s0)
80007874:	00f707b3          	add	a5,a4,a5
80007878:	0007c783          	lbu	a5,0(a5)
8000787c:	00f7f793          	andi	a5,a5,15
80007880:	0ff7f693          	andi	a3,a5,255
80007884:	fec42783          	lw	a5,-20(s0)
80007888:	00178713          	addi	a4,a5,1
8000788c:	fee42623          	sw	a4,-20(s0)
80007890:	00078713          	mv	a4,a5
80007894:	fd842783          	lw	a5,-40(s0)
80007898:	00e784b3          	add	s1,a5,a4
8000789c:	00068513          	mv	a0,a3
800078a0:	ee5ff0ef          	jal	ra,80007784 <hextochar>
800078a4:	00050793          	mv	a5,a0
800078a8:	00f48023          	sb	a5,0(s1)
800078ac:	fe842783          	lw	a5,-24(s0)
800078b0:	00178793          	addi	a5,a5,1
800078b4:	fef42423          	sw	a5,-24(s0)
800078b8:	fe842703          	lw	a4,-24(s0)
800078bc:	00f00793          	li	a5,15
800078c0:	f2e7dce3          	bge	a5,a4,800077f8 <printip+0x28>
800078c4:	fec42783          	lw	a5,-20(s0)
800078c8:	fd842703          	lw	a4,-40(s0)
800078cc:	00f707b3          	add	a5,a4,a5
800078d0:	00078023          	sb	zero,0(a5)
800078d4:	00000013          	nop
800078d8:	02c12083          	lw	ra,44(sp)
800078dc:	02812403          	lw	s0,40(sp)
800078e0:	02412483          	lw	s1,36(sp)
800078e4:	03010113          	addi	sp,sp,48
800078e8:	00008067          	ret

800078ec <printprefix>:
800078ec:	fd010113          	addi	sp,sp,-48
800078f0:	02112623          	sw	ra,44(sp)
800078f4:	02812423          	sw	s0,40(sp)
800078f8:	02912223          	sw	s1,36(sp)
800078fc:	03010413          	addi	s0,sp,48
80007900:	fca42e23          	sw	a0,-36(s0)
80007904:	fcb42c23          	sw	a1,-40(s0)
80007908:	fcc42a23          	sw	a2,-44(s0)
8000790c:	fe042623          	sw	zero,-20(s0)
80007910:	fe042423          	sw	zero,-24(s0)
80007914:	0f80006f          	j	80007a0c <printprefix+0x120>
80007918:	fe842783          	lw	a5,-24(s0)
8000791c:	06f05263          	blez	a5,80007980 <printprefix+0x94>
80007920:	fe842783          	lw	a5,-24(s0)
80007924:	0017f793          	andi	a5,a5,1
80007928:	04079c63          	bnez	a5,80007980 <printprefix+0x94>
8000792c:	fec42783          	lw	a5,-20(s0)
80007930:	00178713          	addi	a4,a5,1
80007934:	fee42623          	sw	a4,-20(s0)
80007938:	00078713          	mv	a4,a5
8000793c:	fd442783          	lw	a5,-44(s0)
80007940:	00e787b3          	add	a5,a5,a4
80007944:	03a00713          	li	a4,58
80007948:	00e78023          	sb	a4,0(a5)
8000794c:	fe842783          	lw	a5,-24(s0)
80007950:	00379793          	slli	a5,a5,0x3
80007954:	fd842703          	lw	a4,-40(s0)
80007958:	02e7c463          	blt	a5,a4,80007980 <printprefix+0x94>
8000795c:	fec42783          	lw	a5,-20(s0)
80007960:	00178713          	addi	a4,a5,1
80007964:	fee42623          	sw	a4,-20(s0)
80007968:	00078713          	mv	a4,a5
8000796c:	fd442783          	lw	a5,-44(s0)
80007970:	00e787b3          	add	a5,a5,a4
80007974:	03a00713          	li	a4,58
80007978:	00e78023          	sb	a4,0(a5)
8000797c:	09c0006f          	j	80007a18 <printprefix+0x12c>
80007980:	fdc42703          	lw	a4,-36(s0)
80007984:	fe842783          	lw	a5,-24(s0)
80007988:	00f707b3          	add	a5,a4,a5
8000798c:	0007c783          	lbu	a5,0(a5)
80007990:	0047d793          	srli	a5,a5,0x4
80007994:	0ff7f693          	andi	a3,a5,255
80007998:	fec42783          	lw	a5,-20(s0)
8000799c:	00178713          	addi	a4,a5,1
800079a0:	fee42623          	sw	a4,-20(s0)
800079a4:	00078713          	mv	a4,a5
800079a8:	fd442783          	lw	a5,-44(s0)
800079ac:	00e784b3          	add	s1,a5,a4
800079b0:	00068513          	mv	a0,a3
800079b4:	dd1ff0ef          	jal	ra,80007784 <hextochar>
800079b8:	00050793          	mv	a5,a0
800079bc:	00f48023          	sb	a5,0(s1)
800079c0:	fdc42703          	lw	a4,-36(s0)
800079c4:	fe842783          	lw	a5,-24(s0)
800079c8:	00f707b3          	add	a5,a4,a5
800079cc:	0007c783          	lbu	a5,0(a5)
800079d0:	00f7f793          	andi	a5,a5,15
800079d4:	0ff7f693          	andi	a3,a5,255
800079d8:	fec42783          	lw	a5,-20(s0)
800079dc:	00178713          	addi	a4,a5,1
800079e0:	fee42623          	sw	a4,-20(s0)
800079e4:	00078713          	mv	a4,a5
800079e8:	fd442783          	lw	a5,-44(s0)
800079ec:	00e784b3          	add	s1,a5,a4
800079f0:	00068513          	mv	a0,a3
800079f4:	d91ff0ef          	jal	ra,80007784 <hextochar>
800079f8:	00050793          	mv	a5,a0
800079fc:	00f48023          	sb	a5,0(s1)
80007a00:	fe842783          	lw	a5,-24(s0)
80007a04:	00178793          	addi	a5,a5,1
80007a08:	fef42423          	sw	a5,-24(s0)
80007a0c:	fe842703          	lw	a4,-24(s0)
80007a10:	00f00793          	li	a5,15
80007a14:	f0e7d2e3          	bge	a5,a4,80007918 <printprefix+0x2c>
80007a18:	fec42783          	lw	a5,-20(s0)
80007a1c:	fd442703          	lw	a4,-44(s0)
80007a20:	00f70733          	add	a4,a4,a5
80007a24:	fd842603          	lw	a2,-40(s0)
80007a28:	8000c7b7          	lui	a5,0x8000c
80007a2c:	e8c78593          	addi	a1,a5,-372 # 8000be8c <_bss_end+0xffe4989c>
80007a30:	00070513          	mv	a0,a4
80007a34:	f68fa0ef          	jal	ra,8000219c <sprintf_>
80007a38:	00000013          	nop
80007a3c:	02c12083          	lw	ra,44(sp)
80007a40:	02812403          	lw	s0,40(sp)
80007a44:	02412483          	lw	s1,36(sp)
80007a48:	03010113          	addi	sp,sp,48
80007a4c:	00008067          	ret

80007a50 <popcnt>:
80007a50:	fd010113          	addi	sp,sp,-48
80007a54:	02812623          	sw	s0,44(sp)
80007a58:	03010413          	addi	s0,sp,48
80007a5c:	fca42e23          	sw	a0,-36(s0)
80007a60:	fe042623          	sw	zero,-20(s0)
80007a64:	0280006f          	j	80007a8c <popcnt+0x3c>
80007a68:	fdc42783          	lw	a5,-36(s0)
80007a6c:	0017f793          	andi	a5,a5,1
80007a70:	00078863          	beqz	a5,80007a80 <popcnt+0x30>
80007a74:	fec42783          	lw	a5,-20(s0)
80007a78:	00178793          	addi	a5,a5,1
80007a7c:	fef42623          	sw	a5,-20(s0)
80007a80:	fdc42783          	lw	a5,-36(s0)
80007a84:	0017d793          	srli	a5,a5,0x1
80007a88:	fcf42e23          	sw	a5,-36(s0)
80007a8c:	fdc42783          	lw	a5,-36(s0)
80007a90:	fc079ce3          	bnez	a5,80007a68 <popcnt+0x18>
80007a94:	fec42783          	lw	a5,-20(s0)
80007a98:	00078513          	mv	a0,a5
80007a9c:	02c12403          	lw	s0,44(sp)
80007aa0:	03010113          	addi	sp,sp,48
80007aa4:	00008067          	ret

80007aa8 <INDEX>:
80007aa8:	fd010113          	addi	sp,sp,-48
80007aac:	02812623          	sw	s0,44(sp)
80007ab0:	02912423          	sw	s1,40(sp)
80007ab4:	03010413          	addi	s0,sp,48
80007ab8:	00050493          	mv	s1,a0
80007abc:	fcb42e23          	sw	a1,-36(s0)
80007ac0:	fcc42c23          	sw	a2,-40(s0)
80007ac4:	fe042623          	sw	zero,-20(s0)
80007ac8:	08000713          	li	a4,128
80007acc:	fdc42783          	lw	a5,-36(s0)
80007ad0:	40f70733          	sub	a4,a4,a5
80007ad4:	fd842783          	lw	a5,-40(s0)
80007ad8:	40f707b3          	sub	a5,a4,a5
80007adc:	fef42423          	sw	a5,-24(s0)
80007ae0:	00f00793          	li	a5,15
80007ae4:	fef42223          	sw	a5,-28(s0)
80007ae8:	0a40006f          	j	80007b8c <INDEX+0xe4>
80007aec:	fe842783          	lw	a5,-24(s0)
80007af0:	0207ce63          	bltz	a5,80007b2c <INDEX+0x84>
80007af4:	fe842703          	lw	a4,-24(s0)
80007af8:	00700793          	li	a5,7
80007afc:	02e7c863          	blt	a5,a4,80007b2c <INDEX+0x84>
80007b00:	fe442783          	lw	a5,-28(s0)
80007b04:	00f487b3          	add	a5,s1,a5
80007b08:	0007c783          	lbu	a5,0(a5)
80007b0c:	00078713          	mv	a4,a5
80007b10:	fe842783          	lw	a5,-24(s0)
80007b14:	40f757b3          	sra	a5,a4,a5
80007b18:	00078713          	mv	a4,a5
80007b1c:	fec42783          	lw	a5,-20(s0)
80007b20:	00e7e7b3          	or	a5,a5,a4
80007b24:	fef42623          	sw	a5,-20(s0)
80007b28:	0400006f          	j	80007b68 <INDEX+0xc0>
80007b2c:	fe842783          	lw	a5,-24(s0)
80007b30:	0207dc63          	bgez	a5,80007b68 <INDEX+0xc0>
80007b34:	fe842703          	lw	a4,-24(s0)
80007b38:	ff900793          	li	a5,-7
80007b3c:	02f74663          	blt	a4,a5,80007b68 <INDEX+0xc0>
80007b40:	fe442783          	lw	a5,-28(s0)
80007b44:	00f487b3          	add	a5,s1,a5
80007b48:	0007c783          	lbu	a5,0(a5)
80007b4c:	00078713          	mv	a4,a5
80007b50:	fe842783          	lw	a5,-24(s0)
80007b54:	40f007b3          	neg	a5,a5
80007b58:	00f717b3          	sll	a5,a4,a5
80007b5c:	fec42703          	lw	a4,-20(s0)
80007b60:	00f767b3          	or	a5,a4,a5
80007b64:	fef42623          	sw	a5,-20(s0)
80007b68:	fe842783          	lw	a5,-24(s0)
80007b6c:	ff878793          	addi	a5,a5,-8
80007b70:	fef42423          	sw	a5,-24(s0)
80007b74:	fe842703          	lw	a4,-24(s0)
80007b78:	fe000793          	li	a5,-32
80007b7c:	00f74e63          	blt	a4,a5,80007b98 <INDEX+0xf0>
80007b80:	fe442783          	lw	a5,-28(s0)
80007b84:	fff78793          	addi	a5,a5,-1
80007b88:	fef42223          	sw	a5,-28(s0)
80007b8c:	fe442783          	lw	a5,-28(s0)
80007b90:	f407dee3          	bgez	a5,80007aec <INDEX+0x44>
80007b94:	0080006f          	j	80007b9c <INDEX+0xf4>
80007b98:	00000013          	nop
80007b9c:	fd842783          	lw	a5,-40(s0)
80007ba0:	00100713          	li	a4,1
80007ba4:	00f717b3          	sll	a5,a4,a5
80007ba8:	fff78793          	addi	a5,a5,-1
80007bac:	fec42703          	lw	a4,-20(s0)
80007bb0:	00f777b3          	and	a5,a4,a5
80007bb4:	fef42623          	sw	a5,-20(s0)
80007bb8:	fec42783          	lw	a5,-20(s0)
80007bbc:	00078513          	mv	a0,a5
80007bc0:	02c12403          	lw	s0,44(sp)
80007bc4:	02812483          	lw	s1,40(sp)
80007bc8:	03010113          	addi	sp,sp,48
80007bcc:	00008067          	ret

80007bd0 <_new_entry>:
80007bd0:	fb010113          	addi	sp,sp,-80
80007bd4:	04112623          	sw	ra,76(sp)
80007bd8:	04812423          	sw	s0,72(sp)
80007bdc:	04912223          	sw	s1,68(sp)
80007be0:	05010413          	addi	s0,sp,80
80007be4:	00050793          	mv	a5,a0
80007be8:	00058493          	mv	s1,a1
80007bec:	fcc42c23          	sw	a2,-40(s0)
80007bf0:	fcf40fa3          	sb	a5,-33(s0)
80007bf4:	fe0407a3          	sb	zero,-17(s0)
80007bf8:	0bc0006f          	j	80007cb4 <_new_entry+0xe4>
80007bfc:	fef44783          	lbu	a5,-17(s0)
80007c00:	00579713          	slli	a4,a5,0x5
80007c04:	510007b7          	lui	a5,0x51000
80007c08:	00f707b3          	add	a5,a4,a5
80007c0c:	0107a703          	lw	a4,16(a5) # 51000010 <_reset_vector-0x2efffff0>
80007c10:	fdf44783          	lbu	a5,-33(s0)
80007c14:	08f71a63          	bne	a4,a5,80007ca8 <_new_entry+0xd8>
80007c18:	fef44783          	lbu	a5,-17(s0)
80007c1c:	00579713          	slli	a4,a5,0x5
80007c20:	510007b7          	lui	a5,0x51000
80007c24:	00f707b3          	add	a5,a4,a5
80007c28:	0007a603          	lw	a2,0(a5) # 51000000 <_reset_vector-0x2f000000>
80007c2c:	0047a683          	lw	a3,4(a5)
80007c30:	0087a703          	lw	a4,8(a5)
80007c34:	00c7a783          	lw	a5,12(a5)
80007c38:	fcc42023          	sw	a2,-64(s0)
80007c3c:	fcd42223          	sw	a3,-60(s0)
80007c40:	fce42423          	sw	a4,-56(s0)
80007c44:	fcf42623          	sw	a5,-52(s0)
80007c48:	0004a603          	lw	a2,0(s1)
80007c4c:	0044a683          	lw	a3,4(s1)
80007c50:	0084a703          	lw	a4,8(s1)
80007c54:	00c4a783          	lw	a5,12(s1)
80007c58:	fac42823          	sw	a2,-80(s0)
80007c5c:	fad42a23          	sw	a3,-76(s0)
80007c60:	fae42c23          	sw	a4,-72(s0)
80007c64:	faf42e23          	sw	a5,-68(s0)
80007c68:	fb040713          	addi	a4,s0,-80
80007c6c:	fc040793          	addi	a5,s0,-64
80007c70:	00070593          	mv	a1,a4
80007c74:	00078513          	mv	a0,a5
80007c78:	8e9f80ef          	jal	ra,80000560 <in6_addr_equal>
80007c7c:	00050793          	mv	a5,a0
80007c80:	02078463          	beqz	a5,80007ca8 <_new_entry+0xd8>
80007c84:	fef44783          	lbu	a5,-17(s0)
80007c88:	00579713          	slli	a4,a5,0x5
80007c8c:	510007b7          	lui	a5,0x51000
80007c90:	00f707b3          	add	a5,a4,a5
80007c94:	0147a783          	lw	a5,20(a5) # 51000014 <_reset_vector-0x2effffec>
80007c98:	fd842703          	lw	a4,-40(s0)
80007c9c:	00f71663          	bne	a4,a5,80007ca8 <_new_entry+0xd8>
80007ca0:	fef44783          	lbu	a5,-17(s0)
80007ca4:	0a40006f          	j	80007d48 <_new_entry+0x178>
80007ca8:	fef44783          	lbu	a5,-17(s0)
80007cac:	00178793          	addi	a5,a5,1
80007cb0:	fef407a3          	sb	a5,-17(s0)
80007cb4:	801c27b7          	lui	a5,0x801c2
80007cb8:	5d47c783          	lbu	a5,1492(a5) # 801c25d4 <_bss_end+0xffffffe4>
80007cbc:	fef44703          	lbu	a4,-17(s0)
80007cc0:	f2f76ee3          	bltu	a4,a5,80007bfc <_new_entry+0x2c>
80007cc4:	801c27b7          	lui	a5,0x801c2
80007cc8:	5d47c783          	lbu	a5,1492(a5) # 801c25d4 <_bss_end+0xffffffe4>
80007ccc:	00579713          	slli	a4,a5,0x5
80007cd0:	510007b7          	lui	a5,0x51000
80007cd4:	00f707b3          	add	a5,a4,a5
80007cd8:	fdf44703          	lbu	a4,-33(s0)
80007cdc:	00e7a823          	sw	a4,16(a5) # 51000010 <_reset_vector-0x2efffff0>
80007ce0:	801c27b7          	lui	a5,0x801c2
80007ce4:	5d47c783          	lbu	a5,1492(a5) # 801c25d4 <_bss_end+0xffffffe4>
80007ce8:	00579713          	slli	a4,a5,0x5
80007cec:	510007b7          	lui	a5,0x51000
80007cf0:	00f707b3          	add	a5,a4,a5
80007cf4:	0004a583          	lw	a1,0(s1)
80007cf8:	0044a603          	lw	a2,4(s1)
80007cfc:	0084a683          	lw	a3,8(s1)
80007d00:	00c4a703          	lw	a4,12(s1)
80007d04:	00b7a023          	sw	a1,0(a5) # 51000000 <_reset_vector-0x2f000000>
80007d08:	00c7a223          	sw	a2,4(a5)
80007d0c:	00d7a423          	sw	a3,8(a5)
80007d10:	00e7a623          	sw	a4,12(a5)
80007d14:	801c27b7          	lui	a5,0x801c2
80007d18:	5d47c783          	lbu	a5,1492(a5) # 801c25d4 <_bss_end+0xffffffe4>
80007d1c:	00579713          	slli	a4,a5,0x5
80007d20:	510007b7          	lui	a5,0x51000
80007d24:	00f707b3          	add	a5,a4,a5
80007d28:	fd842703          	lw	a4,-40(s0)
80007d2c:	00e7aa23          	sw	a4,20(a5) # 51000014 <_reset_vector-0x2effffec>
80007d30:	801c27b7          	lui	a5,0x801c2
80007d34:	5d47c783          	lbu	a5,1492(a5) # 801c25d4 <_bss_end+0xffffffe4>
80007d38:	00178713          	addi	a4,a5,1
80007d3c:	0ff77693          	andi	a3,a4,255
80007d40:	801c2737          	lui	a4,0x801c2
80007d44:	5cd70a23          	sb	a3,1492(a4) # 801c25d4 <_bss_end+0xffffffe4>
80007d48:	00078513          	mv	a0,a5
80007d4c:	04c12083          	lw	ra,76(sp)
80007d50:	04812403          	lw	s0,72(sp)
80007d54:	04412483          	lw	s1,68(sp)
80007d58:	05010113          	addi	sp,sp,80
80007d5c:	00008067          	ret

80007d60 <_new_leaf_node>:
80007d60:	fd010113          	addi	sp,sp,-48
80007d64:	02112623          	sw	ra,44(sp)
80007d68:	02812423          	sw	s0,40(sp)
80007d6c:	03010413          	addi	s0,sp,48
80007d70:	00050093          	mv	ra,a0
80007d74:	801c27b7          	lui	a5,0x801c2
80007d78:	5d87a783          	lw	a5,1496(a5) # 801c25d8 <_bss_end+0xffffffe8>
80007d7c:	00178713          	addi	a4,a5,1
80007d80:	801c27b7          	lui	a5,0x801c2
80007d84:	5ce7ac23          	sw	a4,1496(a5) # 801c25d8 <_bss_end+0xffffffe8>
80007d88:	801c27b7          	lui	a5,0x801c2
80007d8c:	5d87a783          	lw	a5,1496(a5) # 801c25d8 <_bss_end+0xffffffe8>
80007d90:	fef42623          	sw	a5,-20(s0)
80007d94:	0140a783          	lw	a5,20(ra)
80007d98:	0ff7f513          	andi	a0,a5,255
80007d9c:	0280a583          	lw	a1,40(ra)
80007da0:	0180a603          	lw	a2,24(ra)
80007da4:	01c0a683          	lw	a3,28(ra)
80007da8:	0200a703          	lw	a4,32(ra)
80007dac:	0240a783          	lw	a5,36(ra)
80007db0:	fcc42823          	sw	a2,-48(s0)
80007db4:	fcd42a23          	sw	a3,-44(s0)
80007db8:	fce42c23          	sw	a4,-40(s0)
80007dbc:	fcf42e23          	sw	a5,-36(s0)
80007dc0:	fd040793          	addi	a5,s0,-48
80007dc4:	00058613          	mv	a2,a1
80007dc8:	00078593          	mv	a1,a5
80007dcc:	e05ff0ef          	jal	ra,80007bd0 <_new_entry>
80007dd0:	00050793          	mv	a5,a0
80007dd4:	fef407a3          	sb	a5,-17(s0)
80007dd8:	fec42783          	lw	a5,-20(s0)
80007ddc:	00078513          	mv	a0,a5
80007de0:	02c12083          	lw	ra,44(sp)
80007de4:	02812403          	lw	s0,40(sp)
80007de8:	03010113          	addi	sp,sp,48
80007dec:	00008067          	ret

80007df0 <_copy_leaf>:
80007df0:	fe010113          	addi	sp,sp,-32
80007df4:	00812e23          	sw	s0,28(sp)
80007df8:	02010413          	addi	s0,sp,32
80007dfc:	fea42623          	sw	a0,-20(s0)
80007e00:	feb42423          	sw	a1,-24(s0)
80007e04:	fec42783          	lw	a5,-20(s0)
80007e08:	00279713          	slli	a4,a5,0x2
80007e0c:	804007b7          	lui	a5,0x80400
80007e10:	00f70733          	add	a4,a4,a5
80007e14:	fe842783          	lw	a5,-24(s0)
80007e18:	00279693          	slli	a3,a5,0x2
80007e1c:	804007b7          	lui	a5,0x80400
80007e20:	00f687b3          	add	a5,a3,a5
80007e24:	00072703          	lw	a4,0(a4)
80007e28:	00e7a023          	sw	a4,0(a5) # 80400000 <_bss_end+0x23da10>
80007e2c:	00000013          	nop
80007e30:	01c12403          	lw	s0,28(sp)
80007e34:	02010113          	addi	sp,sp,32
80007e38:	00008067          	ret

80007e3c <_set_leaf>:
80007e3c:	fe010113          	addi	sp,sp,-32
80007e40:	00812e23          	sw	s0,28(sp)
80007e44:	02010413          	addi	s0,sp,32
80007e48:	fea42623          	sw	a0,-20(s0)
80007e4c:	feb42423          	sw	a1,-24(s0)
80007e50:	fec42783          	lw	a5,-20(s0)
80007e54:	00279713          	slli	a4,a5,0x2
80007e58:	804007b7          	lui	a5,0x80400
80007e5c:	00f707b3          	add	a5,a4,a5
80007e60:	fe842703          	lw	a4,-24(s0)
80007e64:	00e7a023          	sw	a4,0(a5) # 80400000 <_bss_end+0x23da10>
80007e68:	00000013          	nop
80007e6c:	01c12403          	lw	s0,28(sp)
80007e70:	02010113          	addi	sp,sp,32
80007e74:	00008067          	ret

80007e78 <_insert_node>:
80007e78:	fa010113          	addi	sp,sp,-96
80007e7c:	04112e23          	sw	ra,92(sp)
80007e80:	04812c23          	sw	s0,88(sp)
80007e84:	06010413          	addi	s0,sp,96
80007e88:	faa42623          	sw	a0,-84(s0)
80007e8c:	fab42423          	sw	a1,-88(s0)
80007e90:	fac42223          	sw	a2,-92(s0)
80007e94:	fad42023          	sw	a3,-96(s0)
80007e98:	fac42783          	lw	a5,-84(s0)
80007e9c:	00478793          	addi	a5,a5,4
80007ea0:	41f7d713          	srai	a4,a5,0x1f
80007ea4:	00f77713          	andi	a4,a4,15
80007ea8:	00f707b3          	add	a5,a4,a5
80007eac:	4047d793          	srai	a5,a5,0x4
80007eb0:	fcf42423          	sw	a5,-56(s0)
80007eb4:	fa042783          	lw	a5,-96(s0)
80007eb8:	0007a783          	lw	a5,0(a5)
80007ebc:	1c079263          	bnez	a5,80008080 <_insert_node+0x208>
80007ec0:	fa042783          	lw	a5,-96(s0)
80007ec4:	0047a703          	lw	a4,4(a5)
80007ec8:	00200793          	li	a5,2
80007ecc:	1af71a63          	bne	a4,a5,80008080 <_insert_node+0x208>
80007ed0:	fa842783          	lw	a5,-88(s0)
80007ed4:	0007a783          	lw	a5,0(a5)
80007ed8:	04079e63          	bnez	a5,80007f34 <_insert_node+0xbc>
80007edc:	fa042783          	lw	a5,-96(s0)
80007ee0:	00c7a783          	lw	a5,12(a5)
80007ee4:	01079713          	slli	a4,a5,0x10
80007ee8:	01075713          	srli	a4,a4,0x10
80007eec:	fa842783          	lw	a5,-88(s0)
80007ef0:	00e79423          	sh	a4,8(a5)
80007ef4:	fa842783          	lw	a5,-88(s0)
80007ef8:	00a7d783          	lhu	a5,10(a5)
80007efc:	0807e793          	ori	a5,a5,128
80007f00:	01079713          	slli	a4,a5,0x10
80007f04:	01075713          	srli	a4,a4,0x10
80007f08:	fa842783          	lw	a5,-88(s0)
80007f0c:	00e79523          	sh	a4,10(a5)
80007f10:	fa842783          	lw	a5,-88(s0)
80007f14:	0007a703          	lw	a4,0(a5)
80007f18:	fa442783          	lw	a5,-92(s0)
80007f1c:	00100693          	li	a3,1
80007f20:	00f697b3          	sll	a5,a3,a5
80007f24:	00f76733          	or	a4,a4,a5
80007f28:	fa842783          	lw	a5,-88(s0)
80007f2c:	00e7a023          	sw	a4,0(a5)
80007f30:	5780006f          	j	800084a8 <_insert_node+0x630>
80007f34:	fa842783          	lw	a5,-88(s0)
80007f38:	00a7d783          	lhu	a5,10(a5)
80007f3c:	0807f793          	andi	a5,a5,128
80007f40:	14078063          	beqz	a5,80008080 <_insert_node+0x208>
80007f44:	fa842783          	lw	a5,-88(s0)
80007f48:	0007a783          	lw	a5,0(a5)
80007f4c:	00078513          	mv	a0,a5
80007f50:	b01ff0ef          	jal	ra,80007a50 <popcnt>
80007f54:	fca42223          	sw	a0,-60(s0)
80007f58:	fc442783          	lw	a5,-60(s0)
80007f5c:	00178793          	addi	a5,a5,1
80007f60:	00078513          	mv	a0,a5
80007f64:	525020ef          	jal	ra,8000ac88 <leaf_malloc>
80007f68:	fca42023          	sw	a0,-64(s0)
80007f6c:	fe042623          	sw	zero,-20(s0)
80007f70:	fa842783          	lw	a5,-88(s0)
80007f74:	0087d783          	lhu	a5,8(a5)
80007f78:	fef42423          	sw	a5,-24(s0)
80007f7c:	fc042783          	lw	a5,-64(s0)
80007f80:	fef42223          	sw	a5,-28(s0)
80007f84:	0900006f          	j	80008014 <_insert_node+0x19c>
80007f88:	fec42703          	lw	a4,-20(s0)
80007f8c:	fa442783          	lw	a5,-92(s0)
80007f90:	02f71863          	bne	a4,a5,80007fc0 <_insert_node+0x148>
80007f94:	fa042783          	lw	a5,-96(s0)
80007f98:	00c7a783          	lw	a5,12(a5)
80007f9c:	00078713          	mv	a4,a5
80007fa0:	fe442783          	lw	a5,-28(s0)
80007fa4:	00078593          	mv	a1,a5
80007fa8:	00070513          	mv	a0,a4
80007fac:	e45ff0ef          	jal	ra,80007df0 <_copy_leaf>
80007fb0:	fe442783          	lw	a5,-28(s0)
80007fb4:	00178793          	addi	a5,a5,1
80007fb8:	fef42223          	sw	a5,-28(s0)
80007fbc:	04c0006f          	j	80008008 <_insert_node+0x190>
80007fc0:	fa842783          	lw	a5,-88(s0)
80007fc4:	0007a703          	lw	a4,0(a5)
80007fc8:	fec42783          	lw	a5,-20(s0)
80007fcc:	00100693          	li	a3,1
80007fd0:	00f697b3          	sll	a5,a3,a5
80007fd4:	00f777b3          	and	a5,a4,a5
80007fd8:	02078863          	beqz	a5,80008008 <_insert_node+0x190>
80007fdc:	fe842783          	lw	a5,-24(s0)
80007fe0:	fe442703          	lw	a4,-28(s0)
80007fe4:	00070593          	mv	a1,a4
80007fe8:	00078513          	mv	a0,a5
80007fec:	e05ff0ef          	jal	ra,80007df0 <_copy_leaf>
80007ff0:	fe442783          	lw	a5,-28(s0)
80007ff4:	00178793          	addi	a5,a5,1
80007ff8:	fef42223          	sw	a5,-28(s0)
80007ffc:	fe842783          	lw	a5,-24(s0)
80008000:	00178793          	addi	a5,a5,1
80008004:	fef42423          	sw	a5,-24(s0)
80008008:	fec42783          	lw	a5,-20(s0)
8000800c:	00178793          	addi	a5,a5,1
80008010:	fef42623          	sw	a5,-20(s0)
80008014:	fec42703          	lw	a4,-20(s0)
80008018:	00f00793          	li	a5,15
8000801c:	f6e7f6e3          	bgeu	a5,a4,80007f88 <_insert_node+0x110>
80008020:	fa842783          	lw	a5,-88(s0)
80008024:	0087d783          	lhu	a5,8(a5)
80008028:	fc442583          	lw	a1,-60(s0)
8000802c:	00078513          	mv	a0,a5
80008030:	559020ef          	jal	ra,8000ad88 <leaf_free>
80008034:	fc042783          	lw	a5,-64(s0)
80008038:	01079713          	slli	a4,a5,0x10
8000803c:	01075713          	srli	a4,a4,0x10
80008040:	fa842783          	lw	a5,-88(s0)
80008044:	00e79423          	sh	a4,8(a5)
80008048:	fa842783          	lw	a5,-88(s0)
8000804c:	0007a703          	lw	a4,0(a5)
80008050:	fa442783          	lw	a5,-92(s0)
80008054:	00100693          	li	a3,1
80008058:	00f697b3          	sll	a5,a3,a5
8000805c:	00f76733          	or	a4,a4,a5
80008060:	fa842783          	lw	a5,-88(s0)
80008064:	00e7a023          	sw	a4,0(a5)
80008068:	fa042783          	lw	a5,-96(s0)
8000806c:	00c7a783          	lw	a5,12(a5)
80008070:	00100593          	li	a1,1
80008074:	00078513          	mv	a0,a5
80008078:	511020ef          	jal	ra,8000ad88 <leaf_free>
8000807c:	42c0006f          	j	800084a8 <_insert_node+0x630>
80008080:	fa842783          	lw	a5,-88(s0)
80008084:	00a7d783          	lhu	a5,10(a5)
80008088:	0807f793          	andi	a5,a5,128
8000808c:	20078463          	beqz	a5,80008294 <_insert_node+0x41c>
80008090:	fa842783          	lw	a5,-88(s0)
80008094:	0007a783          	lw	a5,0(a5)
80008098:	00078513          	mv	a0,a5
8000809c:	9b5ff0ef          	jal	ra,80007a50 <popcnt>
800080a0:	faa42a23          	sw	a0,-76(s0)
800080a4:	fb442783          	lw	a5,-76(s0)
800080a8:	00178793          	addi	a5,a5,1
800080ac:	00078593          	mv	a1,a5
800080b0:	fc842503          	lw	a0,-56(s0)
800080b4:	175020ef          	jal	ra,8000aa28 <node_malloc>
800080b8:	faa42823          	sw	a0,-80(s0)
800080bc:	fe042023          	sw	zero,-32(s0)
800080c0:	fa842783          	lw	a5,-88(s0)
800080c4:	0087d783          	lhu	a5,8(a5)
800080c8:	fcf42e23          	sw	a5,-36(s0)
800080cc:	fb042783          	lw	a5,-80(s0)
800080d0:	fcf42c23          	sw	a5,-40(s0)
800080d4:	16c0006f          	j	80008240 <_insert_node+0x3c8>
800080d8:	fe042703          	lw	a4,-32(s0)
800080dc:	fa442783          	lw	a5,-92(s0)
800080e0:	04f71c63          	bne	a4,a5,80008138 <_insert_node+0x2c0>
800080e4:	fd842783          	lw	a5,-40(s0)
800080e8:	00479793          	slli	a5,a5,0x4
800080ec:	fc842703          	lw	a4,-56(s0)
800080f0:	01871713          	slli	a4,a4,0x18
800080f4:	00e78733          	add	a4,a5,a4
800080f8:	400007b7          	lui	a5,0x40000
800080fc:	00f707b3          	add	a5,a4,a5
80008100:	00078713          	mv	a4,a5
80008104:	fa042783          	lw	a5,-96(s0)
80008108:	0007a583          	lw	a1,0(a5) # 40000000 <_reset_vector-0x40000000>
8000810c:	0047a603          	lw	a2,4(a5)
80008110:	0087a683          	lw	a3,8(a5)
80008114:	00c7a783          	lw	a5,12(a5)
80008118:	00b72023          	sw	a1,0(a4)
8000811c:	00c72223          	sw	a2,4(a4)
80008120:	00d72423          	sw	a3,8(a4)
80008124:	00f72623          	sw	a5,12(a4)
80008128:	fd842783          	lw	a5,-40(s0)
8000812c:	00178793          	addi	a5,a5,1
80008130:	fcf42c23          	sw	a5,-40(s0)
80008134:	1000006f          	j	80008234 <_insert_node+0x3bc>
80008138:	fa842783          	lw	a5,-88(s0)
8000813c:	0007a703          	lw	a4,0(a5)
80008140:	fe042783          	lw	a5,-32(s0)
80008144:	00100693          	li	a3,1
80008148:	00f697b3          	sll	a5,a3,a5
8000814c:	00f777b3          	and	a5,a4,a5
80008150:	0e078263          	beqz	a5,80008234 <_insert_node+0x3bc>
80008154:	fd842783          	lw	a5,-40(s0)
80008158:	00479793          	slli	a5,a5,0x4
8000815c:	fc842703          	lw	a4,-56(s0)
80008160:	01871713          	slli	a4,a4,0x18
80008164:	00e78733          	add	a4,a5,a4
80008168:	400007b7          	lui	a5,0x40000
8000816c:	00f707b3          	add	a5,a4,a5
80008170:	00079523          	sh	zero,10(a5) # 4000000a <_reset_vector-0x3ffffff6>
80008174:	fd842783          	lw	a5,-40(s0)
80008178:	00479793          	slli	a5,a5,0x4
8000817c:	fc842703          	lw	a4,-56(s0)
80008180:	01871713          	slli	a4,a4,0x18
80008184:	00e78733          	add	a4,a5,a4
80008188:	400007b7          	lui	a5,0x40000
8000818c:	00f707b3          	add	a5,a4,a5
80008190:	0007a023          	sw	zero,0(a5) # 40000000 <_reset_vector-0x40000000>
80008194:	fd842783          	lw	a5,-40(s0)
80008198:	00479793          	slli	a5,a5,0x4
8000819c:	fc842703          	lw	a4,-56(s0)
800081a0:	01871713          	slli	a4,a4,0x18
800081a4:	00e78733          	add	a4,a5,a4
800081a8:	400007b7          	lui	a5,0x40000
800081ac:	00f707b3          	add	a5,a4,a5
800081b0:	00078713          	mv	a4,a5
800081b4:	00200793          	li	a5,2
800081b8:	00f72223          	sw	a5,4(a4)
800081bc:	00100513          	li	a0,1
800081c0:	2c9020ef          	jal	ra,8000ac88 <leaf_malloc>
800081c4:	00050693          	mv	a3,a0
800081c8:	fd842783          	lw	a5,-40(s0)
800081cc:	00479793          	slli	a5,a5,0x4
800081d0:	fc842703          	lw	a4,-56(s0)
800081d4:	01871713          	slli	a4,a4,0x18
800081d8:	00e78733          	add	a4,a5,a4
800081dc:	400007b7          	lui	a5,0x40000
800081e0:	00f707b3          	add	a5,a4,a5
800081e4:	00068713          	mv	a4,a3
800081e8:	00e7a623          	sw	a4,12(a5) # 4000000c <_reset_vector-0x3ffffff4>
800081ec:	fdc42683          	lw	a3,-36(s0)
800081f0:	fd842783          	lw	a5,-40(s0)
800081f4:	00479793          	slli	a5,a5,0x4
800081f8:	fc842703          	lw	a4,-56(s0)
800081fc:	01871713          	slli	a4,a4,0x18
80008200:	00e78733          	add	a4,a5,a4
80008204:	400007b7          	lui	a5,0x40000
80008208:	00f707b3          	add	a5,a4,a5
8000820c:	00c7a783          	lw	a5,12(a5) # 4000000c <_reset_vector-0x3ffffff4>
80008210:	00078593          	mv	a1,a5
80008214:	00068513          	mv	a0,a3
80008218:	bd9ff0ef          	jal	ra,80007df0 <_copy_leaf>
8000821c:	fd842783          	lw	a5,-40(s0)
80008220:	00178793          	addi	a5,a5,1
80008224:	fcf42c23          	sw	a5,-40(s0)
80008228:	fdc42783          	lw	a5,-36(s0)
8000822c:	00178793          	addi	a5,a5,1
80008230:	fcf42e23          	sw	a5,-36(s0)
80008234:	fe042783          	lw	a5,-32(s0)
80008238:	00178793          	addi	a5,a5,1
8000823c:	fef42023          	sw	a5,-32(s0)
80008240:	fe042703          	lw	a4,-32(s0)
80008244:	00f00793          	li	a5,15
80008248:	e8e7f8e3          	bgeu	a5,a4,800080d8 <_insert_node+0x260>
8000824c:	fa842783          	lw	a5,-88(s0)
80008250:	0087d783          	lhu	a5,8(a5)
80008254:	fb442583          	lw	a1,-76(s0)
80008258:	00078513          	mv	a0,a5
8000825c:	32d020ef          	jal	ra,8000ad88 <leaf_free>
80008260:	fb042783          	lw	a5,-80(s0)
80008264:	01079713          	slli	a4,a5,0x10
80008268:	01075713          	srli	a4,a4,0x10
8000826c:	fa842783          	lw	a5,-88(s0)
80008270:	00e79423          	sh	a4,8(a5)
80008274:	fa842783          	lw	a5,-88(s0)
80008278:	00a7d783          	lhu	a5,10(a5)
8000827c:	f7f7f793          	andi	a5,a5,-129
80008280:	01079713          	slli	a4,a5,0x10
80008284:	01075713          	srli	a4,a4,0x10
80008288:	fa842783          	lw	a5,-88(s0)
8000828c:	00e79523          	sh	a4,10(a5)
80008290:	1f80006f          	j	80008488 <_insert_node+0x610>
80008294:	fa842783          	lw	a5,-88(s0)
80008298:	0007a783          	lw	a5,0(a5)
8000829c:	06079863          	bnez	a5,8000830c <_insert_node+0x494>
800082a0:	00100593          	li	a1,1
800082a4:	fc842503          	lw	a0,-56(s0)
800082a8:	780020ef          	jal	ra,8000aa28 <node_malloc>
800082ac:	00050793          	mv	a5,a0
800082b0:	01079713          	slli	a4,a5,0x10
800082b4:	01075713          	srli	a4,a4,0x10
800082b8:	fa842783          	lw	a5,-88(s0)
800082bc:	00e79423          	sh	a4,8(a5)
800082c0:	fa842783          	lw	a5,-88(s0)
800082c4:	0087d783          	lhu	a5,8(a5)
800082c8:	00479793          	slli	a5,a5,0x4
800082cc:	fc842703          	lw	a4,-56(s0)
800082d0:	01871713          	slli	a4,a4,0x18
800082d4:	00e78733          	add	a4,a5,a4
800082d8:	400007b7          	lui	a5,0x40000
800082dc:	00f707b3          	add	a5,a4,a5
800082e0:	00078713          	mv	a4,a5
800082e4:	fa042783          	lw	a5,-96(s0)
800082e8:	0007a583          	lw	a1,0(a5) # 40000000 <_reset_vector-0x40000000>
800082ec:	0047a603          	lw	a2,4(a5)
800082f0:	0087a683          	lw	a3,8(a5)
800082f4:	00c7a783          	lw	a5,12(a5)
800082f8:	00b72023          	sw	a1,0(a4)
800082fc:	00c72223          	sw	a2,4(a4)
80008300:	00d72423          	sw	a3,8(a4)
80008304:	00f72623          	sw	a5,12(a4)
80008308:	1800006f          	j	80008488 <_insert_node+0x610>
8000830c:	fa842783          	lw	a5,-88(s0)
80008310:	0007a783          	lw	a5,0(a5)
80008314:	00078513          	mv	a0,a5
80008318:	f38ff0ef          	jal	ra,80007a50 <popcnt>
8000831c:	faa42e23          	sw	a0,-68(s0)
80008320:	fbc42783          	lw	a5,-68(s0)
80008324:	00178793          	addi	a5,a5,1
80008328:	00078593          	mv	a1,a5
8000832c:	fc842503          	lw	a0,-56(s0)
80008330:	6f8020ef          	jal	ra,8000aa28 <node_malloc>
80008334:	faa42c23          	sw	a0,-72(s0)
80008338:	fc042a23          	sw	zero,-44(s0)
8000833c:	fa842783          	lw	a5,-88(s0)
80008340:	0087d783          	lhu	a5,8(a5)
80008344:	fcf42823          	sw	a5,-48(s0)
80008348:	fb842783          	lw	a5,-72(s0)
8000834c:	fcf42623          	sw	a5,-52(s0)
80008350:	1000006f          	j	80008450 <_insert_node+0x5d8>
80008354:	fd442703          	lw	a4,-44(s0)
80008358:	fa442783          	lw	a5,-92(s0)
8000835c:	04f71c63          	bne	a4,a5,800083b4 <_insert_node+0x53c>
80008360:	fcc42783          	lw	a5,-52(s0)
80008364:	00479793          	slli	a5,a5,0x4
80008368:	fc842703          	lw	a4,-56(s0)
8000836c:	01871713          	slli	a4,a4,0x18
80008370:	00e78733          	add	a4,a5,a4
80008374:	400007b7          	lui	a5,0x40000
80008378:	00f707b3          	add	a5,a4,a5
8000837c:	00078713          	mv	a4,a5
80008380:	fa042783          	lw	a5,-96(s0)
80008384:	0007a583          	lw	a1,0(a5) # 40000000 <_reset_vector-0x40000000>
80008388:	0047a603          	lw	a2,4(a5)
8000838c:	0087a683          	lw	a3,8(a5)
80008390:	00c7a783          	lw	a5,12(a5)
80008394:	00b72023          	sw	a1,0(a4)
80008398:	00c72223          	sw	a2,4(a4)
8000839c:	00d72423          	sw	a3,8(a4)
800083a0:	00f72623          	sw	a5,12(a4)
800083a4:	fcc42783          	lw	a5,-52(s0)
800083a8:	00178793          	addi	a5,a5,1
800083ac:	fcf42623          	sw	a5,-52(s0)
800083b0:	0940006f          	j	80008444 <_insert_node+0x5cc>
800083b4:	fa842783          	lw	a5,-88(s0)
800083b8:	0007a703          	lw	a4,0(a5)
800083bc:	fd442783          	lw	a5,-44(s0)
800083c0:	00100693          	li	a3,1
800083c4:	00f697b3          	sll	a5,a3,a5
800083c8:	00f777b3          	and	a5,a4,a5
800083cc:	06078c63          	beqz	a5,80008444 <_insert_node+0x5cc>
800083d0:	fd042783          	lw	a5,-48(s0)
800083d4:	00479793          	slli	a5,a5,0x4
800083d8:	fc842703          	lw	a4,-56(s0)
800083dc:	01871713          	slli	a4,a4,0x18
800083e0:	00e78733          	add	a4,a5,a4
800083e4:	400007b7          	lui	a5,0x40000
800083e8:	00f707b3          	add	a5,a4,a5
800083ec:	00078713          	mv	a4,a5
800083f0:	fcc42783          	lw	a5,-52(s0)
800083f4:	00479793          	slli	a5,a5,0x4
800083f8:	fc842683          	lw	a3,-56(s0)
800083fc:	01869693          	slli	a3,a3,0x18
80008400:	00d786b3          	add	a3,a5,a3
80008404:	400007b7          	lui	a5,0x40000
80008408:	00f687b3          	add	a5,a3,a5
8000840c:	00072583          	lw	a1,0(a4)
80008410:	00472603          	lw	a2,4(a4)
80008414:	00872683          	lw	a3,8(a4)
80008418:	00c72703          	lw	a4,12(a4)
8000841c:	00b7a023          	sw	a1,0(a5) # 40000000 <_reset_vector-0x40000000>
80008420:	00c7a223          	sw	a2,4(a5)
80008424:	00d7a423          	sw	a3,8(a5)
80008428:	00e7a623          	sw	a4,12(a5)
8000842c:	fcc42783          	lw	a5,-52(s0)
80008430:	00178793          	addi	a5,a5,1
80008434:	fcf42623          	sw	a5,-52(s0)
80008438:	fd042783          	lw	a5,-48(s0)
8000843c:	00178793          	addi	a5,a5,1
80008440:	fcf42823          	sw	a5,-48(s0)
80008444:	fd442783          	lw	a5,-44(s0)
80008448:	00178793          	addi	a5,a5,1
8000844c:	fcf42a23          	sw	a5,-44(s0)
80008450:	fd442703          	lw	a4,-44(s0)
80008454:	00f00793          	li	a5,15
80008458:	eee7fee3          	bgeu	a5,a4,80008354 <_insert_node+0x4dc>
8000845c:	fa842783          	lw	a5,-88(s0)
80008460:	0087d783          	lhu	a5,8(a5)
80008464:	fbc42603          	lw	a2,-68(s0)
80008468:	00078593          	mv	a1,a5
8000846c:	fc842503          	lw	a0,-56(s0)
80008470:	6fc020ef          	jal	ra,8000ab6c <node_free>
80008474:	fb842783          	lw	a5,-72(s0)
80008478:	01079713          	slli	a4,a5,0x10
8000847c:	01075713          	srli	a4,a4,0x10
80008480:	fa842783          	lw	a5,-88(s0)
80008484:	00e79423          	sh	a4,8(a5)
80008488:	fa842783          	lw	a5,-88(s0)
8000848c:	0007a703          	lw	a4,0(a5)
80008490:	fa442783          	lw	a5,-92(s0)
80008494:	00100693          	li	a3,1
80008498:	00f697b3          	sll	a5,a3,a5
8000849c:	00f76733          	or	a4,a4,a5
800084a0:	fa842783          	lw	a5,-88(s0)
800084a4:	00e7a023          	sw	a4,0(a5)
800084a8:	05c12083          	lw	ra,92(sp)
800084ac:	05812403          	lw	s0,88(sp)
800084b0:	06010113          	addi	sp,sp,96
800084b4:	00008067          	ret

800084b8 <_insert_leaf>:
800084b8:	fc010113          	addi	sp,sp,-64
800084bc:	02112e23          	sw	ra,60(sp)
800084c0:	02812c23          	sw	s0,56(sp)
800084c4:	04010413          	addi	s0,sp,64
800084c8:	fca42623          	sw	a0,-52(s0)
800084cc:	fcb42423          	sw	a1,-56(s0)
800084d0:	fcc42223          	sw	a2,-60(s0)
800084d4:	fcd42023          	sw	a3,-64(s0)
800084d8:	fc842783          	lw	a5,-56(s0)
800084dc:	0047a783          	lw	a5,4(a5)
800084e0:	00078513          	mv	a0,a5
800084e4:	d6cff0ef          	jal	ra,80007a50 <popcnt>
800084e8:	fea42023          	sw	a0,-32(s0)
800084ec:	fe042783          	lw	a5,-32(s0)
800084f0:	02079a63          	bnez	a5,80008524 <_insert_leaf+0x6c>
800084f4:	00100513          	li	a0,1
800084f8:	790020ef          	jal	ra,8000ac88 <leaf_malloc>
800084fc:	00050793          	mv	a5,a0
80008500:	00078713          	mv	a4,a5
80008504:	fc842783          	lw	a5,-56(s0)
80008508:	00e7a623          	sw	a4,12(a5)
8000850c:	fc842783          	lw	a5,-56(s0)
80008510:	00c7a783          	lw	a5,12(a5)
80008514:	fc042583          	lw	a1,-64(s0)
80008518:	00078513          	mv	a0,a5
8000851c:	921ff0ef          	jal	ra,80007e3c <_set_leaf>
80008520:	0e40006f          	j	80008604 <_insert_leaf+0x14c>
80008524:	fe042783          	lw	a5,-32(s0)
80008528:	00178793          	addi	a5,a5,1
8000852c:	00078513          	mv	a0,a5
80008530:	758020ef          	jal	ra,8000ac88 <leaf_malloc>
80008534:	fca42e23          	sw	a0,-36(s0)
80008538:	00100793          	li	a5,1
8000853c:	fef42623          	sw	a5,-20(s0)
80008540:	fc842783          	lw	a5,-56(s0)
80008544:	00c7a783          	lw	a5,12(a5)
80008548:	fef42423          	sw	a5,-24(s0)
8000854c:	fdc42783          	lw	a5,-36(s0)
80008550:	fef42223          	sw	a5,-28(s0)
80008554:	0840006f          	j	800085d8 <_insert_leaf+0x120>
80008558:	fec42703          	lw	a4,-20(s0)
8000855c:	fc442783          	lw	a5,-60(s0)
80008560:	02f71263          	bne	a4,a5,80008584 <_insert_leaf+0xcc>
80008564:	fe442783          	lw	a5,-28(s0)
80008568:	fc042583          	lw	a1,-64(s0)
8000856c:	00078513          	mv	a0,a5
80008570:	8cdff0ef          	jal	ra,80007e3c <_set_leaf>
80008574:	fe442783          	lw	a5,-28(s0)
80008578:	00178793          	addi	a5,a5,1
8000857c:	fef42223          	sw	a5,-28(s0)
80008580:	04c0006f          	j	800085cc <_insert_leaf+0x114>
80008584:	fc842783          	lw	a5,-56(s0)
80008588:	0047a703          	lw	a4,4(a5)
8000858c:	fec42783          	lw	a5,-20(s0)
80008590:	00100693          	li	a3,1
80008594:	00f697b3          	sll	a5,a3,a5
80008598:	00f777b3          	and	a5,a4,a5
8000859c:	02078863          	beqz	a5,800085cc <_insert_leaf+0x114>
800085a0:	fe842783          	lw	a5,-24(s0)
800085a4:	fe442703          	lw	a4,-28(s0)
800085a8:	00070593          	mv	a1,a4
800085ac:	00078513          	mv	a0,a5
800085b0:	841ff0ef          	jal	ra,80007df0 <_copy_leaf>
800085b4:	fe442783          	lw	a5,-28(s0)
800085b8:	00178793          	addi	a5,a5,1
800085bc:	fef42223          	sw	a5,-28(s0)
800085c0:	fe842783          	lw	a5,-24(s0)
800085c4:	00178793          	addi	a5,a5,1
800085c8:	fef42423          	sw	a5,-24(s0)
800085cc:	fec42783          	lw	a5,-20(s0)
800085d0:	00178793          	addi	a5,a5,1
800085d4:	fef42623          	sw	a5,-20(s0)
800085d8:	fec42703          	lw	a4,-20(s0)
800085dc:	00f00793          	li	a5,15
800085e0:	f6e7fce3          	bgeu	a5,a4,80008558 <_insert_leaf+0xa0>
800085e4:	fc842783          	lw	a5,-56(s0)
800085e8:	00c7a783          	lw	a5,12(a5)
800085ec:	fe042583          	lw	a1,-32(s0)
800085f0:	00078513          	mv	a0,a5
800085f4:	794020ef          	jal	ra,8000ad88 <leaf_free>
800085f8:	fdc42703          	lw	a4,-36(s0)
800085fc:	fc842783          	lw	a5,-56(s0)
80008600:	00e7a623          	sw	a4,12(a5)
80008604:	fc842783          	lw	a5,-56(s0)
80008608:	0047a703          	lw	a4,4(a5)
8000860c:	fc442783          	lw	a5,-60(s0)
80008610:	00100693          	li	a3,1
80008614:	00f697b3          	sll	a5,a3,a5
80008618:	00f76733          	or	a4,a4,a5
8000861c:	fc842783          	lw	a5,-56(s0)
80008620:	00e7a223          	sw	a4,4(a5)
80008624:	00000013          	nop
80008628:	03c12083          	lw	ra,60(sp)
8000862c:	03812403          	lw	s0,56(sp)
80008630:	04010113          	addi	sp,sp,64
80008634:	00008067          	ret

80008638 <_remove_leaf>:
80008638:	fd010113          	addi	sp,sp,-48
8000863c:	02112623          	sw	ra,44(sp)
80008640:	02812423          	sw	s0,40(sp)
80008644:	03010413          	addi	s0,sp,48
80008648:	fca42e23          	sw	a0,-36(s0)
8000864c:	fcb42c23          	sw	a1,-40(s0)
80008650:	fcc42a23          	sw	a2,-44(s0)
80008654:	fd842783          	lw	a5,-40(s0)
80008658:	0047a703          	lw	a4,4(a5)
8000865c:	fd442783          	lw	a5,-44(s0)
80008660:	00200693          	li	a3,2
80008664:	00f697b3          	sll	a5,a3,a5
80008668:	fff78793          	addi	a5,a5,-1
8000866c:	00f777b3          	and	a5,a4,a5
80008670:	00078513          	mv	a0,a5
80008674:	bdcff0ef          	jal	ra,80007a50 <popcnt>
80008678:	fea42623          	sw	a0,-20(s0)
8000867c:	fec42703          	lw	a4,-20(s0)
80008680:	00100793          	li	a5,1
80008684:	06e7c063          	blt	a5,a4,800086e4 <_remove_leaf+0xac>
80008688:	fd842783          	lw	a5,-40(s0)
8000868c:	0047a703          	lw	a4,4(a5)
80008690:	fd442783          	lw	a5,-44(s0)
80008694:	00100693          	li	a3,1
80008698:	00f697b3          	sll	a5,a3,a5
8000869c:	fff7c793          	not	a5,a5
800086a0:	00f77733          	and	a4,a4,a5
800086a4:	fd842783          	lw	a5,-40(s0)
800086a8:	00e7a223          	sw	a4,4(a5)
800086ac:	fd842783          	lw	a5,-40(s0)
800086b0:	0047a783          	lw	a5,4(a5)
800086b4:	00079c63          	bnez	a5,800086cc <_remove_leaf+0x94>
800086b8:	fd842783          	lw	a5,-40(s0)
800086bc:	00c7a783          	lw	a5,12(a5)
800086c0:	00100593          	li	a1,1
800086c4:	00078513          	mv	a0,a5
800086c8:	6c0020ef          	jal	ra,8000ad88 <leaf_free>
800086cc:	fd842783          	lw	a5,-40(s0)
800086d0:	00c7a783          	lw	a5,12(a5)
800086d4:	00178713          	addi	a4,a5,1
800086d8:	fd842783          	lw	a5,-40(s0)
800086dc:	00e7a623          	sw	a4,12(a5)
800086e0:	0a40006f          	j	80008784 <_remove_leaf+0x14c>
800086e4:	fd842783          	lw	a5,-40(s0)
800086e8:	00c7a703          	lw	a4,12(a5)
800086ec:	fec42783          	lw	a5,-20(s0)
800086f0:	00f707b3          	add	a5,a4,a5
800086f4:	fff78793          	addi	a5,a5,-1
800086f8:	fef42623          	sw	a5,-20(s0)
800086fc:	fd442783          	lw	a5,-44(s0)
80008700:	00178793          	addi	a5,a5,1
80008704:	fef42423          	sw	a5,-24(s0)
80008708:	04c0006f          	j	80008754 <_remove_leaf+0x11c>
8000870c:	fd842783          	lw	a5,-40(s0)
80008710:	0047a703          	lw	a4,4(a5)
80008714:	fe842783          	lw	a5,-24(s0)
80008718:	00100693          	li	a3,1
8000871c:	00f697b3          	sll	a5,a3,a5
80008720:	00f777b3          	and	a5,a4,a5
80008724:	02078263          	beqz	a5,80008748 <_remove_leaf+0x110>
80008728:	fec42783          	lw	a5,-20(s0)
8000872c:	00178793          	addi	a5,a5,1
80008730:	fec42583          	lw	a1,-20(s0)
80008734:	00078513          	mv	a0,a5
80008738:	eb8ff0ef          	jal	ra,80007df0 <_copy_leaf>
8000873c:	fec42783          	lw	a5,-20(s0)
80008740:	00178793          	addi	a5,a5,1
80008744:	fef42623          	sw	a5,-20(s0)
80008748:	fe842783          	lw	a5,-24(s0)
8000874c:	00178793          	addi	a5,a5,1
80008750:	fef42423          	sw	a5,-24(s0)
80008754:	fe842703          	lw	a4,-24(s0)
80008758:	00f00793          	li	a5,15
8000875c:	fae7f8e3          	bgeu	a5,a4,8000870c <_remove_leaf+0xd4>
80008760:	fd842783          	lw	a5,-40(s0)
80008764:	0047a703          	lw	a4,4(a5)
80008768:	fd442783          	lw	a5,-44(s0)
8000876c:	00100693          	li	a3,1
80008770:	00f697b3          	sll	a5,a3,a5
80008774:	fff7c793          	not	a5,a5
80008778:	00f77733          	and	a4,a4,a5
8000877c:	fd842783          	lw	a5,-40(s0)
80008780:	00e7a223          	sw	a4,4(a5)
80008784:	00000013          	nop
80008788:	02c12083          	lw	ra,44(sp)
8000878c:	02812403          	lw	s0,40(sp)
80008790:	03010113          	addi	sp,sp,48
80008794:	00008067          	ret

80008798 <_remove_lin>:
80008798:	fd010113          	addi	sp,sp,-48
8000879c:	02112623          	sw	ra,44(sp)
800087a0:	02812423          	sw	s0,40(sp)
800087a4:	03010413          	addi	s0,sp,48
800087a8:	fca42e23          	sw	a0,-36(s0)
800087ac:	fcb42c23          	sw	a1,-40(s0)
800087b0:	fcc42a23          	sw	a2,-44(s0)
800087b4:	fd842783          	lw	a5,-40(s0)
800087b8:	0007a703          	lw	a4,0(a5)
800087bc:	fd442783          	lw	a5,-44(s0)
800087c0:	00200693          	li	a3,2
800087c4:	00f697b3          	sll	a5,a3,a5
800087c8:	fff78793          	addi	a5,a5,-1
800087cc:	00f777b3          	and	a5,a4,a5
800087d0:	00078513          	mv	a0,a5
800087d4:	a7cff0ef          	jal	ra,80007a50 <popcnt>
800087d8:	fea42623          	sw	a0,-20(s0)
800087dc:	fec42703          	lw	a4,-20(s0)
800087e0:	00100793          	li	a5,1
800087e4:	08e7c263          	blt	a5,a4,80008868 <_remove_lin+0xd0>
800087e8:	fd842783          	lw	a5,-40(s0)
800087ec:	0007a703          	lw	a4,0(a5)
800087f0:	fd442783          	lw	a5,-44(s0)
800087f4:	00100693          	li	a3,1
800087f8:	00f697b3          	sll	a5,a3,a5
800087fc:	fff7c793          	not	a5,a5
80008800:	00f77733          	and	a4,a4,a5
80008804:	fd842783          	lw	a5,-40(s0)
80008808:	00e7a023          	sw	a4,0(a5)
8000880c:	fd842783          	lw	a5,-40(s0)
80008810:	0007a783          	lw	a5,0(a5)
80008814:	02079a63          	bnez	a5,80008848 <_remove_lin+0xb0>
80008818:	fd842783          	lw	a5,-40(s0)
8000881c:	00a7d783          	lhu	a5,10(a5)
80008820:	f7f7f793          	andi	a5,a5,-129
80008824:	01079713          	slli	a4,a5,0x10
80008828:	01075713          	srli	a4,a4,0x10
8000882c:	fd842783          	lw	a5,-40(s0)
80008830:	00e79523          	sh	a4,10(a5)
80008834:	fd842783          	lw	a5,-40(s0)
80008838:	0087d783          	lhu	a5,8(a5)
8000883c:	00100593          	li	a1,1
80008840:	00078513          	mv	a0,a5
80008844:	544020ef          	jal	ra,8000ad88 <leaf_free>
80008848:	fd842783          	lw	a5,-40(s0)
8000884c:	0087d783          	lhu	a5,8(a5)
80008850:	00178793          	addi	a5,a5,1
80008854:	01079713          	slli	a4,a5,0x10
80008858:	01075713          	srli	a4,a4,0x10
8000885c:	fd842783          	lw	a5,-40(s0)
80008860:	00e79423          	sh	a4,8(a5)
80008864:	0a80006f          	j	8000890c <_remove_lin+0x174>
80008868:	fd842783          	lw	a5,-40(s0)
8000886c:	0087d783          	lhu	a5,8(a5)
80008870:	00078713          	mv	a4,a5
80008874:	fec42783          	lw	a5,-20(s0)
80008878:	00f707b3          	add	a5,a4,a5
8000887c:	fff78793          	addi	a5,a5,-1
80008880:	fef42623          	sw	a5,-20(s0)
80008884:	fd442783          	lw	a5,-44(s0)
80008888:	00178793          	addi	a5,a5,1
8000888c:	fef42423          	sw	a5,-24(s0)
80008890:	04c0006f          	j	800088dc <_remove_lin+0x144>
80008894:	fd842783          	lw	a5,-40(s0)
80008898:	0007a703          	lw	a4,0(a5)
8000889c:	fe842783          	lw	a5,-24(s0)
800088a0:	00100693          	li	a3,1
800088a4:	00f697b3          	sll	a5,a3,a5
800088a8:	00f777b3          	and	a5,a4,a5
800088ac:	02078263          	beqz	a5,800088d0 <_remove_lin+0x138>
800088b0:	fec42783          	lw	a5,-20(s0)
800088b4:	00178793          	addi	a5,a5,1
800088b8:	fec42583          	lw	a1,-20(s0)
800088bc:	00078513          	mv	a0,a5
800088c0:	d30ff0ef          	jal	ra,80007df0 <_copy_leaf>
800088c4:	fec42783          	lw	a5,-20(s0)
800088c8:	00178793          	addi	a5,a5,1
800088cc:	fef42623          	sw	a5,-20(s0)
800088d0:	fe842783          	lw	a5,-24(s0)
800088d4:	00178793          	addi	a5,a5,1
800088d8:	fef42423          	sw	a5,-24(s0)
800088dc:	fe842703          	lw	a4,-24(s0)
800088e0:	00f00793          	li	a5,15
800088e4:	fae7f8e3          	bgeu	a5,a4,80008894 <_remove_lin+0xfc>
800088e8:	fd842783          	lw	a5,-40(s0)
800088ec:	0007a703          	lw	a4,0(a5)
800088f0:	fd442783          	lw	a5,-44(s0)
800088f4:	00100693          	li	a3,1
800088f8:	00f697b3          	sll	a5,a3,a5
800088fc:	fff7c793          	not	a5,a5
80008900:	00f77733          	and	a4,a4,a5
80008904:	fd842783          	lw	a5,-40(s0)
80008908:	00e7a023          	sw	a4,0(a5)
8000890c:	00000013          	nop
80008910:	02c12083          	lw	ra,44(sp)
80008914:	02812403          	lw	s0,40(sp)
80008918:	03010113          	addi	sp,sp,48
8000891c:	00008067          	ret

80008920 <insert_entry>:
80008920:	f9010113          	addi	sp,sp,-112
80008924:	06112623          	sw	ra,108(sp)
80008928:	06812423          	sw	s0,104(sp)
8000892c:	06912223          	sw	s1,100(sp)
80008930:	07212023          	sw	s2,96(sp)
80008934:	05312e23          	sw	s3,92(sp)
80008938:	07010413          	addi	s0,sp,112
8000893c:	faa42623          	sw	a0,-84(s0)
80008940:	fab42423          	sw	a1,-88(s0)
80008944:	00060493          	mv	s1,a2
80008948:	fad42223          	sw	a3,-92(s0)
8000894c:	fae42023          	sw	a4,-96(s0)
80008950:	fac42783          	lw	a5,-84(s0)
80008954:	00378793          	addi	a5,a5,3
80008958:	fa442703          	lw	a4,-92(s0)
8000895c:	0ce7ce63          	blt	a5,a4,80008a38 <insert_entry+0x118>
80008960:	fa442703          	lw	a4,-92(s0)
80008964:	fac42783          	lw	a5,-84(s0)
80008968:	40f707b3          	sub	a5,a4,a5
8000896c:	faf42c23          	sw	a5,-72(s0)
80008970:	0004a603          	lw	a2,0(s1)
80008974:	0044a683          	lw	a3,4(s1)
80008978:	0084a703          	lw	a4,8(s1)
8000897c:	00c4a783          	lw	a5,12(s1)
80008980:	f8c42823          	sw	a2,-112(s0)
80008984:	f8d42a23          	sw	a3,-108(s0)
80008988:	f8e42c23          	sw	a4,-104(s0)
8000898c:	f8f42e23          	sw	a5,-100(s0)
80008990:	f9040793          	addi	a5,s0,-112
80008994:	fb842603          	lw	a2,-72(s0)
80008998:	fac42583          	lw	a1,-84(s0)
8000899c:	00078513          	mv	a0,a5
800089a0:	908ff0ef          	jal	ra,80007aa8 <INDEX>
800089a4:	00050693          	mv	a3,a0
800089a8:	fb842783          	lw	a5,-72(s0)
800089ac:	00100713          	li	a4,1
800089b0:	00f717b3          	sll	a5,a4,a5
800089b4:	00f6e7b3          	or	a5,a3,a5
800089b8:	faf42a23          	sw	a5,-76(s0)
800089bc:	fa842783          	lw	a5,-88(s0)
800089c0:	0047a703          	lw	a4,4(a5)
800089c4:	fb442783          	lw	a5,-76(s0)
800089c8:	00100693          	li	a3,1
800089cc:	00f697b3          	sll	a5,a3,a5
800089d0:	00f777b3          	and	a5,a4,a5
800089d4:	04078663          	beqz	a5,80008a20 <insert_entry+0x100>
800089d8:	fa842783          	lw	a5,-88(s0)
800089dc:	00c7a483          	lw	s1,12(a5)
800089e0:	fa842783          	lw	a5,-88(s0)
800089e4:	0047a703          	lw	a4,4(a5)
800089e8:	fb442783          	lw	a5,-76(s0)
800089ec:	00200693          	li	a3,2
800089f0:	00f697b3          	sll	a5,a3,a5
800089f4:	fff78793          	addi	a5,a5,-1
800089f8:	00f777b3          	and	a5,a4,a5
800089fc:	00078513          	mv	a0,a5
80008a00:	850ff0ef          	jal	ra,80007a50 <popcnt>
80008a04:	00050793          	mv	a5,a0
80008a08:	00f487b3          	add	a5,s1,a5
80008a0c:	fff78793          	addi	a5,a5,-1
80008a10:	fa042583          	lw	a1,-96(s0)
80008a14:	00078513          	mv	a0,a5
80008a18:	c24ff0ef          	jal	ra,80007e3c <_set_leaf>
80008a1c:	4200006f          	j	80008e3c <insert_entry+0x51c>
80008a20:	fa042683          	lw	a3,-96(s0)
80008a24:	fb442603          	lw	a2,-76(s0)
80008a28:	fa842583          	lw	a1,-88(s0)
80008a2c:	fac42503          	lw	a0,-84(s0)
80008a30:	a89ff0ef          	jal	ra,800084b8 <_insert_leaf>
80008a34:	4080006f          	j	80008e3c <insert_entry+0x51c>
80008a38:	0004a603          	lw	a2,0(s1)
80008a3c:	0044a683          	lw	a3,4(s1)
80008a40:	0084a703          	lw	a4,8(s1)
80008a44:	00c4a783          	lw	a5,12(s1)
80008a48:	f8c42823          	sw	a2,-112(s0)
80008a4c:	f8d42a23          	sw	a3,-108(s0)
80008a50:	f8e42c23          	sw	a4,-104(s0)
80008a54:	f8f42e23          	sw	a5,-100(s0)
80008a58:	f9040793          	addi	a5,s0,-112
80008a5c:	00400613          	li	a2,4
80008a60:	fac42583          	lw	a1,-84(s0)
80008a64:	00078513          	mv	a0,a5
80008a68:	840ff0ef          	jal	ra,80007aa8 <INDEX>
80008a6c:	fca42823          	sw	a0,-48(s0)
80008a70:	fa842783          	lw	a5,-88(s0)
80008a74:	0007a703          	lw	a4,0(a5)
80008a78:	fd042783          	lw	a5,-48(s0)
80008a7c:	00100693          	li	a3,1
80008a80:	00f697b3          	sll	a5,a3,a5
80008a84:	00f777b3          	and	a5,a4,a5
80008a88:	30078263          	beqz	a5,80008d8c <insert_entry+0x46c>
80008a8c:	fa842783          	lw	a5,-88(s0)
80008a90:	00a7d783          	lhu	a5,10(a5)
80008a94:	0807f793          	andi	a5,a5,128
80008a98:	06078063          	beqz	a5,80008af8 <insert_entry+0x1d8>
80008a9c:	fac42783          	lw	a5,-84(s0)
80008aa0:	00478793          	addi	a5,a5,4
80008aa4:	fa442703          	lw	a4,-92(s0)
80008aa8:	04f71863          	bne	a4,a5,80008af8 <insert_entry+0x1d8>
80008aac:	fa842783          	lw	a5,-88(s0)
80008ab0:	0087d783          	lhu	a5,8(a5)
80008ab4:	00078493          	mv	s1,a5
80008ab8:	fa842783          	lw	a5,-88(s0)
80008abc:	0007a703          	lw	a4,0(a5)
80008ac0:	fd042783          	lw	a5,-48(s0)
80008ac4:	00200693          	li	a3,2
80008ac8:	00f697b3          	sll	a5,a3,a5
80008acc:	fff78793          	addi	a5,a5,-1
80008ad0:	00f777b3          	and	a5,a4,a5
80008ad4:	00078513          	mv	a0,a5
80008ad8:	f79fe0ef          	jal	ra,80007a50 <popcnt>
80008adc:	00050793          	mv	a5,a0
80008ae0:	00f487b3          	add	a5,s1,a5
80008ae4:	fff78793          	addi	a5,a5,-1
80008ae8:	fa042583          	lw	a1,-96(s0)
80008aec:	00078513          	mv	a0,a5
80008af0:	b4cff0ef          	jal	ra,80007e3c <_set_leaf>
80008af4:	3480006f          	j	80008e3c <insert_entry+0x51c>
80008af8:	fac42783          	lw	a5,-84(s0)
80008afc:	00478793          	addi	a5,a5,4
80008b00:	41f7d713          	srai	a4,a5,0x1f
80008b04:	00f77713          	andi	a4,a4,15
80008b08:	00f707b3          	add	a5,a4,a5
80008b0c:	4047d793          	srai	a5,a5,0x4
80008b10:	fcf42423          	sw	a5,-56(s0)
80008b14:	fa842783          	lw	a5,-88(s0)
80008b18:	00a7d783          	lhu	a5,10(a5)
80008b1c:	0807f793          	andi	a5,a5,128
80008b20:	1c078663          	beqz	a5,80008cec <insert_entry+0x3cc>
80008b24:	fac42783          	lw	a5,-84(s0)
80008b28:	00478793          	addi	a5,a5,4
80008b2c:	fa442703          	lw	a4,-92(s0)
80008b30:	1af70e63          	beq	a4,a5,80008cec <insert_entry+0x3cc>
80008b34:	fa842783          	lw	a5,-88(s0)
80008b38:	0007a783          	lw	a5,0(a5)
80008b3c:	00078513          	mv	a0,a5
80008b40:	f11fe0ef          	jal	ra,80007a50 <popcnt>
80008b44:	fca42223          	sw	a0,-60(s0)
80008b48:	fc442583          	lw	a1,-60(s0)
80008b4c:	fc842503          	lw	a0,-56(s0)
80008b50:	6d9010ef          	jal	ra,8000aa28 <node_malloc>
80008b54:	fca42023          	sw	a0,-64(s0)
80008b58:	fc042e23          	sw	zero,-36(s0)
80008b5c:	fa842783          	lw	a5,-88(s0)
80008b60:	0087d783          	lhu	a5,8(a5)
80008b64:	fcf42c23          	sw	a5,-40(s0)
80008b68:	fc042783          	lw	a5,-64(s0)
80008b6c:	fcf42a23          	sw	a5,-44(s0)
80008b70:	12c0006f          	j	80008c9c <insert_entry+0x37c>
80008b74:	fa842783          	lw	a5,-88(s0)
80008b78:	0007a703          	lw	a4,0(a5)
80008b7c:	fdc42783          	lw	a5,-36(s0)
80008b80:	00100693          	li	a3,1
80008b84:	00f697b3          	sll	a5,a3,a5
80008b88:	00f777b3          	and	a5,a4,a5
80008b8c:	10078263          	beqz	a5,80008c90 <insert_entry+0x370>
80008b90:	fd442783          	lw	a5,-44(s0)
80008b94:	00479793          	slli	a5,a5,0x4
80008b98:	fc842703          	lw	a4,-56(s0)
80008b9c:	01871713          	slli	a4,a4,0x18
80008ba0:	00e78733          	add	a4,a5,a4
80008ba4:	400007b7          	lui	a5,0x40000
80008ba8:	00f707b3          	add	a5,a4,a5
80008bac:	00079523          	sh	zero,10(a5) # 4000000a <_reset_vector-0x3ffffff6>
80008bb0:	fd442783          	lw	a5,-44(s0)
80008bb4:	00479793          	slli	a5,a5,0x4
80008bb8:	fc842703          	lw	a4,-56(s0)
80008bbc:	01871713          	slli	a4,a4,0x18
80008bc0:	00e78733          	add	a4,a5,a4
80008bc4:	400007b7          	lui	a5,0x40000
80008bc8:	00f707b3          	add	a5,a4,a5
80008bcc:	0007a023          	sw	zero,0(a5) # 40000000 <_reset_vector-0x40000000>
80008bd0:	fd442783          	lw	a5,-44(s0)
80008bd4:	00479793          	slli	a5,a5,0x4
80008bd8:	fc842703          	lw	a4,-56(s0)
80008bdc:	01871713          	slli	a4,a4,0x18
80008be0:	00e78733          	add	a4,a5,a4
80008be4:	400007b7          	lui	a5,0x40000
80008be8:	00f707b3          	add	a5,a4,a5
80008bec:	00078713          	mv	a4,a5
80008bf0:	00200793          	li	a5,2
80008bf4:	00f72223          	sw	a5,4(a4)
80008bf8:	00100513          	li	a0,1
80008bfc:	08c020ef          	jal	ra,8000ac88 <leaf_malloc>
80008c00:	00050693          	mv	a3,a0
80008c04:	fd442783          	lw	a5,-44(s0)
80008c08:	00479793          	slli	a5,a5,0x4
80008c0c:	fc842703          	lw	a4,-56(s0)
80008c10:	01871713          	slli	a4,a4,0x18
80008c14:	00e78733          	add	a4,a5,a4
80008c18:	400007b7          	lui	a5,0x40000
80008c1c:	00f707b3          	add	a5,a4,a5
80008c20:	00068713          	mv	a4,a3
80008c24:	00e7a623          	sw	a4,12(a5) # 4000000c <_reset_vector-0x3ffffff4>
80008c28:	fd842683          	lw	a3,-40(s0)
80008c2c:	fd442783          	lw	a5,-44(s0)
80008c30:	00479793          	slli	a5,a5,0x4
80008c34:	fc842703          	lw	a4,-56(s0)
80008c38:	01871713          	slli	a4,a4,0x18
80008c3c:	00e78733          	add	a4,a5,a4
80008c40:	400007b7          	lui	a5,0x40000
80008c44:	00f707b3          	add	a5,a4,a5
80008c48:	00c7a783          	lw	a5,12(a5) # 4000000c <_reset_vector-0x3ffffff4>
80008c4c:	00078593          	mv	a1,a5
80008c50:	00068513          	mv	a0,a3
80008c54:	99cff0ef          	jal	ra,80007df0 <_copy_leaf>
80008c58:	fd442783          	lw	a5,-44(s0)
80008c5c:	00479793          	slli	a5,a5,0x4
80008c60:	fc842703          	lw	a4,-56(s0)
80008c64:	01871713          	slli	a4,a4,0x18
80008c68:	00e78733          	add	a4,a5,a4
80008c6c:	400007b7          	lui	a5,0x40000
80008c70:	00f707b3          	add	a5,a4,a5
80008c74:	00079423          	sh	zero,8(a5) # 40000008 <_reset_vector-0x3ffffff8>
80008c78:	fd442783          	lw	a5,-44(s0)
80008c7c:	00178793          	addi	a5,a5,1
80008c80:	fcf42a23          	sw	a5,-44(s0)
80008c84:	fd842783          	lw	a5,-40(s0)
80008c88:	00178793          	addi	a5,a5,1
80008c8c:	fcf42c23          	sw	a5,-40(s0)
80008c90:	fdc42783          	lw	a5,-36(s0)
80008c94:	00178793          	addi	a5,a5,1
80008c98:	fcf42e23          	sw	a5,-36(s0)
80008c9c:	fdc42703          	lw	a4,-36(s0)
80008ca0:	00f00793          	li	a5,15
80008ca4:	ece7f8e3          	bgeu	a5,a4,80008b74 <insert_entry+0x254>
80008ca8:	fa842783          	lw	a5,-88(s0)
80008cac:	0087d783          	lhu	a5,8(a5)
80008cb0:	fc442583          	lw	a1,-60(s0)
80008cb4:	00078513          	mv	a0,a5
80008cb8:	0d0020ef          	jal	ra,8000ad88 <leaf_free>
80008cbc:	fc042783          	lw	a5,-64(s0)
80008cc0:	01079713          	slli	a4,a5,0x10
80008cc4:	01075713          	srli	a4,a4,0x10
80008cc8:	fa842783          	lw	a5,-88(s0)
80008ccc:	00e79423          	sh	a4,8(a5)
80008cd0:	fa842783          	lw	a5,-88(s0)
80008cd4:	00a7d783          	lhu	a5,10(a5)
80008cd8:	f7f7f793          	andi	a5,a5,-129
80008cdc:	01079713          	slli	a4,a5,0x10
80008ce0:	01075713          	srli	a4,a4,0x10
80008ce4:	fa842783          	lw	a5,-88(s0)
80008ce8:	00e79523          	sh	a4,10(a5)
80008cec:	fc842783          	lw	a5,-56(s0)
80008cf0:	01879793          	slli	a5,a5,0x18
80008cf4:	00078913          	mv	s2,a5
80008cf8:	fa842783          	lw	a5,-88(s0)
80008cfc:	0087d783          	lhu	a5,8(a5)
80008d00:	00078993          	mv	s3,a5
80008d04:	fa842783          	lw	a5,-88(s0)
80008d08:	0007a703          	lw	a4,0(a5)
80008d0c:	fd042783          	lw	a5,-48(s0)
80008d10:	00200693          	li	a3,2
80008d14:	00f697b3          	sll	a5,a3,a5
80008d18:	fff78793          	addi	a5,a5,-1
80008d1c:	00f777b3          	and	a5,a4,a5
80008d20:	00078513          	mv	a0,a5
80008d24:	d2dfe0ef          	jal	ra,80007a50 <popcnt>
80008d28:	00050793          	mv	a5,a0
80008d2c:	00f987b3          	add	a5,s3,a5
80008d30:	00479793          	slli	a5,a5,0x4
80008d34:	00f90733          	add	a4,s2,a5
80008d38:	400007b7          	lui	a5,0x40000
80008d3c:	ff078793          	addi	a5,a5,-16 # 3ffffff0 <_reset_vector-0x40000010>
80008d40:	00f707b3          	add	a5,a4,a5
80008d44:	faf42e23          	sw	a5,-68(s0)
80008d48:	fac42783          	lw	a5,-84(s0)
80008d4c:	00478513          	addi	a0,a5,4
80008d50:	0004a603          	lw	a2,0(s1)
80008d54:	0044a683          	lw	a3,4(s1)
80008d58:	0084a703          	lw	a4,8(s1)
80008d5c:	00c4a783          	lw	a5,12(s1)
80008d60:	f8c42823          	sw	a2,-112(s0)
80008d64:	f8d42a23          	sw	a3,-108(s0)
80008d68:	f8e42c23          	sw	a4,-104(s0)
80008d6c:	f8f42e23          	sw	a5,-100(s0)
80008d70:	f9040793          	addi	a5,s0,-112
80008d74:	fa042703          	lw	a4,-96(s0)
80008d78:	fa442683          	lw	a3,-92(s0)
80008d7c:	00078613          	mv	a2,a5
80008d80:	fbc42583          	lw	a1,-68(s0)
80008d84:	b9dff0ef          	jal	ra,80008920 <insert_entry>
80008d88:	0b40006f          	j	80008e3c <insert_entry+0x51c>
80008d8c:	fac42783          	lw	a5,-84(s0)
80008d90:	41f7d713          	srai	a4,a5,0x1f
80008d94:	00377713          	andi	a4,a4,3
80008d98:	00f707b3          	add	a5,a4,a5
80008d9c:	4027d793          	srai	a5,a5,0x2
80008da0:	00178793          	addi	a5,a5,1
80008da4:	00479713          	slli	a4,a5,0x4
80008da8:	8018e7b7          	lui	a5,0x8018e
80008dac:	be478793          	addi	a5,a5,-1052 # 8018dbe4 <_bss_end+0xfffcb5f4>
80008db0:	00f707b3          	add	a5,a4,a5
80008db4:	fcf42623          	sw	a5,-52(s0)
80008db8:	fcc42783          	lw	a5,-52(s0)
80008dbc:	0007a223          	sw	zero,4(a5)
80008dc0:	fcc42783          	lw	a5,-52(s0)
80008dc4:	0047a703          	lw	a4,4(a5)
80008dc8:	fcc42783          	lw	a5,-52(s0)
80008dcc:	00e7a023          	sw	a4,0(a5)
80008dd0:	fcc42783          	lw	a5,-52(s0)
80008dd4:	00079423          	sh	zero,8(a5)
80008dd8:	fcc42783          	lw	a5,-52(s0)
80008ddc:	0007a623          	sw	zero,12(a5)
80008de0:	fcc42783          	lw	a5,-52(s0)
80008de4:	00079523          	sh	zero,10(a5)
80008de8:	fac42783          	lw	a5,-84(s0)
80008dec:	00478513          	addi	a0,a5,4
80008df0:	0004a603          	lw	a2,0(s1)
80008df4:	0044a683          	lw	a3,4(s1)
80008df8:	0084a703          	lw	a4,8(s1)
80008dfc:	00c4a783          	lw	a5,12(s1)
80008e00:	f8c42823          	sw	a2,-112(s0)
80008e04:	f8d42a23          	sw	a3,-108(s0)
80008e08:	f8e42c23          	sw	a4,-104(s0)
80008e0c:	f8f42e23          	sw	a5,-100(s0)
80008e10:	f9040793          	addi	a5,s0,-112
80008e14:	fa042703          	lw	a4,-96(s0)
80008e18:	fa442683          	lw	a3,-92(s0)
80008e1c:	00078613          	mv	a2,a5
80008e20:	fcc42583          	lw	a1,-52(s0)
80008e24:	afdff0ef          	jal	ra,80008920 <insert_entry>
80008e28:	fcc42683          	lw	a3,-52(s0)
80008e2c:	fd042603          	lw	a2,-48(s0)
80008e30:	fa842583          	lw	a1,-88(s0)
80008e34:	fac42503          	lw	a0,-84(s0)
80008e38:	840ff0ef          	jal	ra,80007e78 <_insert_node>
80008e3c:	06c12083          	lw	ra,108(sp)
80008e40:	06812403          	lw	s0,104(sp)
80008e44:	06412483          	lw	s1,100(sp)
80008e48:	06012903          	lw	s2,96(sp)
80008e4c:	05c12983          	lw	s3,92(sp)
80008e50:	07010113          	addi	sp,sp,112
80008e54:	00008067          	ret

80008e58 <remove_entry>:
80008e58:	fa010113          	addi	sp,sp,-96
80008e5c:	04112e23          	sw	ra,92(sp)
80008e60:	04812c23          	sw	s0,88(sp)
80008e64:	04912a23          	sw	s1,84(sp)
80008e68:	05212823          	sw	s2,80(sp)
80008e6c:	05312623          	sw	s3,76(sp)
80008e70:	06010413          	addi	s0,sp,96
80008e74:	faa42e23          	sw	a0,-68(s0)
80008e78:	fab42c23          	sw	a1,-72(s0)
80008e7c:	00060493          	mv	s1,a2
80008e80:	fad42a23          	sw	a3,-76(s0)
80008e84:	fb842783          	lw	a5,-72(s0)
80008e88:	00479713          	slli	a4,a5,0x4
80008e8c:	fbc42783          	lw	a5,-68(s0)
80008e90:	41f7d693          	srai	a3,a5,0x1f
80008e94:	00f6f693          	andi	a3,a3,15
80008e98:	00f687b3          	add	a5,a3,a5
80008e9c:	4047d793          	srai	a5,a5,0x4
80008ea0:	01879793          	slli	a5,a5,0x18
80008ea4:	00f70733          	add	a4,a4,a5
80008ea8:	400007b7          	lui	a5,0x40000
80008eac:	00f707b3          	add	a5,a4,a5
80008eb0:	fcf42e23          	sw	a5,-36(s0)
80008eb4:	fbc42783          	lw	a5,-68(s0)
80008eb8:	00378793          	addi	a5,a5,3 # 40000003 <_reset_vector-0x3ffffffd>
80008ebc:	fb442703          	lw	a4,-76(s0)
80008ec0:	0ee7c663          	blt	a5,a4,80008fac <remove_entry+0x154>
80008ec4:	fb442703          	lw	a4,-76(s0)
80008ec8:	fbc42783          	lw	a5,-68(s0)
80008ecc:	40f707b3          	sub	a5,a4,a5
80008ed0:	fcf42a23          	sw	a5,-44(s0)
80008ed4:	0004a603          	lw	a2,0(s1)
80008ed8:	0044a683          	lw	a3,4(s1)
80008edc:	0084a703          	lw	a4,8(s1)
80008ee0:	00c4a783          	lw	a5,12(s1)
80008ee4:	fac42023          	sw	a2,-96(s0)
80008ee8:	fad42223          	sw	a3,-92(s0)
80008eec:	fae42423          	sw	a4,-88(s0)
80008ef0:	faf42623          	sw	a5,-84(s0)
80008ef4:	fa040793          	addi	a5,s0,-96
80008ef8:	fd442603          	lw	a2,-44(s0)
80008efc:	fbc42583          	lw	a1,-68(s0)
80008f00:	00078513          	mv	a0,a5
80008f04:	ba5fe0ef          	jal	ra,80007aa8 <INDEX>
80008f08:	00050693          	mv	a3,a0
80008f0c:	fd442783          	lw	a5,-44(s0)
80008f10:	00100713          	li	a4,1
80008f14:	00f717b3          	sll	a5,a4,a5
80008f18:	00f6e7b3          	or	a5,a3,a5
80008f1c:	fcf42823          	sw	a5,-48(s0)
80008f20:	fdc42783          	lw	a5,-36(s0)
80008f24:	0047a703          	lw	a4,4(a5)
80008f28:	fd042783          	lw	a5,-48(s0)
80008f2c:	00100693          	li	a3,1
80008f30:	00f697b3          	sll	a5,a3,a5
80008f34:	00f777b3          	and	a5,a4,a5
80008f38:	16078e63          	beqz	a5,800090b4 <remove_entry+0x25c>
80008f3c:	fdc42783          	lw	a5,-36(s0)
80008f40:	00c7a483          	lw	s1,12(a5)
80008f44:	fdc42783          	lw	a5,-36(s0)
80008f48:	0047a703          	lw	a4,4(a5)
80008f4c:	fd042783          	lw	a5,-48(s0)
80008f50:	00200693          	li	a3,2
80008f54:	00f697b3          	sll	a5,a3,a5
80008f58:	fff78793          	addi	a5,a5,-1
80008f5c:	00f777b3          	and	a5,a4,a5
80008f60:	00078513          	mv	a0,a5
80008f64:	aedfe0ef          	jal	ra,80007a50 <popcnt>
80008f68:	00050793          	mv	a5,a0
80008f6c:	00f487b3          	add	a5,s1,a5
80008f70:	00279713          	slli	a4,a5,0x2
80008f74:	804007b7          	lui	a5,0x80400
80008f78:	ffc78793          	addi	a5,a5,-4 # 803ffffc <_bss_end+0x23da0c>
80008f7c:	00f707b3          	add	a5,a4,a5
80008f80:	0007a703          	lw	a4,0(a5)
80008f84:	010007b7          	lui	a5,0x1000
80008f88:	fff78793          	addi	a5,a5,-1 # ffffff <_reset_vector-0x7f000001>
80008f8c:	00f777b3          	and	a5,a4,a5
80008f90:	fcf42623          	sw	a5,-52(s0)
80008f94:	fd042603          	lw	a2,-48(s0)
80008f98:	fdc42583          	lw	a1,-36(s0)
80008f9c:	fbc42503          	lw	a0,-68(s0)
80008fa0:	e98ff0ef          	jal	ra,80008638 <_remove_leaf>
80008fa4:	fcc42783          	lw	a5,-52(s0)
80008fa8:	1100006f          	j	800090b8 <remove_entry+0x260>
80008fac:	0004a603          	lw	a2,0(s1)
80008fb0:	0044a683          	lw	a3,4(s1)
80008fb4:	0084a703          	lw	a4,8(s1)
80008fb8:	00c4a783          	lw	a5,12(s1)
80008fbc:	fac42023          	sw	a2,-96(s0)
80008fc0:	fad42223          	sw	a3,-92(s0)
80008fc4:	fae42423          	sw	a4,-88(s0)
80008fc8:	faf42623          	sw	a5,-84(s0)
80008fcc:	fa040793          	addi	a5,s0,-96
80008fd0:	00400613          	li	a2,4
80008fd4:	fbc42583          	lw	a1,-68(s0)
80008fd8:	00078513          	mv	a0,a5
80008fdc:	acdfe0ef          	jal	ra,80007aa8 <INDEX>
80008fe0:	fca42c23          	sw	a0,-40(s0)
80008fe4:	fdc42783          	lw	a5,-36(s0)
80008fe8:	0007a703          	lw	a4,0(a5)
80008fec:	fd842783          	lw	a5,-40(s0)
80008ff0:	00100693          	li	a3,1
80008ff4:	00f697b3          	sll	a5,a3,a5
80008ff8:	00f777b3          	and	a5,a4,a5
80008ffc:	0a078c63          	beqz	a5,800090b4 <remove_entry+0x25c>
80009000:	fdc42783          	lw	a5,-36(s0)
80009004:	00a7d783          	lhu	a5,10(a5)
80009008:	0807f793          	andi	a5,a5,128
8000900c:	02078463          	beqz	a5,80009034 <remove_entry+0x1dc>
80009010:	fbc42783          	lw	a5,-68(s0)
80009014:	00478793          	addi	a5,a5,4
80009018:	fb442703          	lw	a4,-76(s0)
8000901c:	08f71c63          	bne	a4,a5,800090b4 <remove_entry+0x25c>
80009020:	fd842603          	lw	a2,-40(s0)
80009024:	fdc42583          	lw	a1,-36(s0)
80009028:	fbc42503          	lw	a0,-68(s0)
8000902c:	f6cff0ef          	jal	ra,80008798 <_remove_lin>
80009030:	0840006f          	j	800090b4 <remove_entry+0x25c>
80009034:	fbc42783          	lw	a5,-68(s0)
80009038:	00478913          	addi	s2,a5,4
8000903c:	fdc42783          	lw	a5,-36(s0)
80009040:	0087d783          	lhu	a5,8(a5)
80009044:	00078993          	mv	s3,a5
80009048:	fdc42783          	lw	a5,-36(s0)
8000904c:	0007a703          	lw	a4,0(a5)
80009050:	fd842783          	lw	a5,-40(s0)
80009054:	00200693          	li	a3,2
80009058:	00f697b3          	sll	a5,a3,a5
8000905c:	fff78793          	addi	a5,a5,-1
80009060:	00f777b3          	and	a5,a4,a5
80009064:	00078513          	mv	a0,a5
80009068:	9e9fe0ef          	jal	ra,80007a50 <popcnt>
8000906c:	00050793          	mv	a5,a0
80009070:	00f987b3          	add	a5,s3,a5
80009074:	fff78593          	addi	a1,a5,-1
80009078:	0004a603          	lw	a2,0(s1)
8000907c:	0044a683          	lw	a3,4(s1)
80009080:	0084a703          	lw	a4,8(s1)
80009084:	00c4a783          	lw	a5,12(s1)
80009088:	fac42023          	sw	a2,-96(s0)
8000908c:	fad42223          	sw	a3,-92(s0)
80009090:	fae42423          	sw	a4,-88(s0)
80009094:	faf42623          	sw	a5,-84(s0)
80009098:	fa040793          	addi	a5,s0,-96
8000909c:	fb442683          	lw	a3,-76(s0)
800090a0:	00078613          	mv	a2,a5
800090a4:	00090513          	mv	a0,s2
800090a8:	db1ff0ef          	jal	ra,80008e58 <remove_entry>
800090ac:	00050793          	mv	a5,a0
800090b0:	0080006f          	j	800090b8 <remove_entry+0x260>
800090b4:	fff00793          	li	a5,-1
800090b8:	00078513          	mv	a0,a5
800090bc:	05c12083          	lw	ra,92(sp)
800090c0:	05812403          	lw	s0,88(sp)
800090c4:	05412483          	lw	s1,84(sp)
800090c8:	05012903          	lw	s2,80(sp)
800090cc:	04c12983          	lw	s3,76(sp)
800090d0:	06010113          	addi	sp,sp,96
800090d4:	00008067          	ret

800090d8 <timeout_timeout>:
800090d8:	fd010113          	addi	sp,sp,-48
800090dc:	02112623          	sw	ra,44(sp)
800090e0:	02812423          	sw	s0,40(sp)
800090e4:	03010413          	addi	s0,sp,48
800090e8:	fea42623          	sw	a0,-20(s0)
800090ec:	feb42423          	sw	a1,-24(s0)
800090f0:	fe842703          	lw	a4,-24(s0)
800090f4:	00070793          	mv	a5,a4
800090f8:	00279793          	slli	a5,a5,0x2
800090fc:	00e787b3          	add	a5,a5,a4
80009100:	00279793          	slli	a5,a5,0x2
80009104:	00078713          	mv	a4,a5
80009108:	805007b7          	lui	a5,0x80500
8000910c:	00f707b3          	add	a5,a4,a5
80009110:	0007c783          	lbu	a5,0(a5) # 80500000 <_bss_end+0x33da10>
80009114:	0a078863          	beqz	a5,800091c4 <timeout_timeout+0xec>
80009118:	fe842703          	lw	a4,-24(s0)
8000911c:	00070793          	mv	a5,a4
80009120:	00279793          	slli	a5,a5,0x2
80009124:	00e787b3          	add	a5,a5,a4
80009128:	00279793          	slli	a5,a5,0x2
8000912c:	00078713          	mv	a4,a5
80009130:	805007b7          	lui	a5,0x80500
80009134:	00f707b3          	add	a5,a4,a5
80009138:	00078023          	sb	zero,0(a5) # 80500000 <_bss_end+0x33da10>
8000913c:	801c27b7          	lui	a5,0x801c2
80009140:	5dc7a503          	lw	a0,1500(a5) # 801c25dc <_bss_end+0xffffffec>
80009144:	fe842703          	lw	a4,-24(s0)
80009148:	00070793          	mv	a5,a4
8000914c:	00279793          	slli	a5,a5,0x2
80009150:	00e787b3          	add	a5,a5,a4
80009154:	00279793          	slli	a5,a5,0x2
80009158:	00078713          	mv	a4,a5
8000915c:	805007b7          	lui	a5,0x80500
80009160:	00f70733          	add	a4,a4,a5
80009164:	fe842683          	lw	a3,-24(s0)
80009168:	00068793          	mv	a5,a3
8000916c:	00279793          	slli	a5,a5,0x2
80009170:	00d787b3          	add	a5,a5,a3
80009174:	00279793          	slli	a5,a5,0x2
80009178:	00078693          	mv	a3,a5
8000917c:	805007b7          	lui	a5,0x80500
80009180:	00f687b3          	add	a5,a3,a5
80009184:	0027c783          	lbu	a5,2(a5) # 80500002 <_bss_end+0x33da12>
80009188:	00078813          	mv	a6,a5
8000918c:	00472583          	lw	a1,4(a4)
80009190:	00872603          	lw	a2,8(a4)
80009194:	00c72683          	lw	a3,12(a4)
80009198:	01072783          	lw	a5,16(a4)
8000919c:	fcb42823          	sw	a1,-48(s0)
800091a0:	fcc42a23          	sw	a2,-44(s0)
800091a4:	fcd42c23          	sw	a3,-40(s0)
800091a8:	fcf42e23          	sw	a5,-36(s0)
800091ac:	fd040793          	addi	a5,s0,-48
800091b0:	00080693          	mv	a3,a6
800091b4:	00078613          	mv	a2,a5
800091b8:	00050593          	mv	a1,a0
800091bc:	00000513          	li	a0,0
800091c0:	c99ff0ef          	jal	ra,80008e58 <remove_entry>
800091c4:	00000013          	nop
800091c8:	02c12083          	lw	ra,44(sp)
800091cc:	02812403          	lw	s0,40(sp)
800091d0:	03010113          	addi	sp,sp,48
800091d4:	00008067          	ret

800091d8 <update>:
800091d8:	fa010113          	addi	sp,sp,-96
800091dc:	04112e23          	sw	ra,92(sp)
800091e0:	04812c23          	sw	s0,88(sp)
800091e4:	04912a23          	sw	s1,84(sp)
800091e8:	06010413          	addi	s0,sp,96
800091ec:	00050793          	mv	a5,a0
800091f0:	00058493          	mv	s1,a1
800091f4:	fcf40fa3          	sb	a5,-33(s0)
800091f8:	fdf44783          	lbu	a5,-33(s0)
800091fc:	18078263          	beqz	a5,80009380 <update+0x1a8>
80009200:	0004af03          	lw	t5,0(s1)
80009204:	0044ae83          	lw	t4,4(s1)
80009208:	0084ae03          	lw	t3,8(s1)
8000920c:	00c4a303          	lw	t1,12(s1)
80009210:	0104a883          	lw	a7,16(s1)
80009214:	0144a803          	lw	a6,20(s1)
80009218:	0184a503          	lw	a0,24(s1)
8000921c:	01c4a583          	lw	a1,28(s1)
80009220:	0204a603          	lw	a2,32(s1)
80009224:	0244a683          	lw	a3,36(s1)
80009228:	0284a703          	lw	a4,40(s1)
8000922c:	02c4a783          	lw	a5,44(s1)
80009230:	fbe42023          	sw	t5,-96(s0)
80009234:	fbd42223          	sw	t4,-92(s0)
80009238:	fbc42423          	sw	t3,-88(s0)
8000923c:	fa642623          	sw	t1,-84(s0)
80009240:	fb142823          	sw	a7,-80(s0)
80009244:	fb042a23          	sw	a6,-76(s0)
80009248:	faa42c23          	sw	a0,-72(s0)
8000924c:	fab42e23          	sw	a1,-68(s0)
80009250:	fcc42023          	sw	a2,-64(s0)
80009254:	fcd42223          	sw	a3,-60(s0)
80009258:	fce42423          	sw	a4,-56(s0)
8000925c:	fcf42623          	sw	a5,-52(s0)
80009260:	fa040793          	addi	a5,s0,-96
80009264:	00078513          	mv	a0,a5
80009268:	af9fe0ef          	jal	ra,80007d60 <_new_leaf_node>
8000926c:	00050793          	mv	a5,a0
80009270:	fef42223          	sw	a5,-28(s0)
80009274:	fe442703          	lw	a4,-28(s0)
80009278:	010007b7          	lui	a5,0x1000
8000927c:	fff78793          	addi	a5,a5,-1 # ffffff <_reset_vector-0x7f000001>
80009280:	00f77733          	and	a4,a4,a5
80009284:	00070793          	mv	a5,a4
80009288:	00279793          	slli	a5,a5,0x2
8000928c:	00e787b3          	add	a5,a5,a4
80009290:	00279793          	slli	a5,a5,0x2
80009294:	00078713          	mv	a4,a5
80009298:	805007b7          	lui	a5,0x80500
8000929c:	00f707b3          	add	a5,a4,a5
800092a0:	fef42423          	sw	a5,-24(s0)
800092a4:	fe842783          	lw	a5,-24(s0)
800092a8:	00100713          	li	a4,1
800092ac:	00e78023          	sb	a4,0(a5) # 80500000 <_bss_end+0x33da10>
800092b0:	02c4c703          	lbu	a4,44(s1)
800092b4:	fe842783          	lw	a5,-24(s0)
800092b8:	00e780a3          	sb	a4,1(a5)
800092bc:	fe744703          	lbu	a4,-25(s0)
800092c0:	fe842783          	lw	a5,-24(s0)
800092c4:	00e781a3          	sb	a4,3(a5)
800092c8:	0104a783          	lw	a5,16(s1)
800092cc:	0ff7f713          	andi	a4,a5,255
800092d0:	fe842783          	lw	a5,-24(s0)
800092d4:	00e78123          	sb	a4,2(a5)
800092d8:	fe842783          	lw	a5,-24(s0)
800092dc:	0004a583          	lw	a1,0(s1)
800092e0:	0044a603          	lw	a2,4(s1)
800092e4:	0084a683          	lw	a3,8(s1)
800092e8:	00c4a703          	lw	a4,12(s1)
800092ec:	00b7a223          	sw	a1,4(a5)
800092f0:	00c7a423          	sw	a2,8(a5)
800092f4:	00d7a623          	sw	a3,12(a5)
800092f8:	00e7a823          	sw	a4,16(a5)
800092fc:	801c27b7          	lui	a5,0x801c2
80009300:	5dc7a783          	lw	a5,1500(a5) # 801c25dc <_bss_end+0xffffffec>
80009304:	00479713          	slli	a4,a5,0x4
80009308:	400007b7          	lui	a5,0x40000
8000930c:	00f705b3          	add	a1,a4,a5
80009310:	0104a783          	lw	a5,16(s1)
80009314:	00078513          	mv	a0,a5
80009318:	0004a603          	lw	a2,0(s1)
8000931c:	0044a683          	lw	a3,4(s1)
80009320:	0084a703          	lw	a4,8(s1)
80009324:	00c4a783          	lw	a5,12(s1)
80009328:	fac42023          	sw	a2,-96(s0)
8000932c:	fad42223          	sw	a3,-92(s0)
80009330:	fae42423          	sw	a4,-88(s0)
80009334:	faf42623          	sw	a5,-84(s0)
80009338:	fa040793          	addi	a5,s0,-96
8000933c:	fe442703          	lw	a4,-28(s0)
80009340:	00050693          	mv	a3,a0
80009344:	00078613          	mv	a2,a5
80009348:	00000513          	li	a0,0
8000934c:	dd4ff0ef          	jal	ra,80008920 <insert_entry>
80009350:	0284a783          	lw	a5,40(s1)
80009354:	0c078863          	beqz	a5,80009424 <update+0x24c>
80009358:	801c27b7          	lui	a5,0x801c2
8000935c:	5e07a683          	lw	a3,1504(a5) # 801c25e0 <_bss_end+0xfffffff0>
80009360:	fe442703          	lw	a4,-28(s0)
80009364:	010007b7          	lui	a5,0x1000
80009368:	fff78793          	addi	a5,a5,-1 # ffffff <_reset_vector-0x7f000001>
8000936c:	00f777b3          	and	a5,a4,a5
80009370:	00078593          	mv	a1,a5
80009374:	00068513          	mv	a0,a3
80009378:	f6cfd0ef          	jal	ra,80006ae4 <timer_start>
8000937c:	0a80006f          	j	80009424 <update+0x24c>
80009380:	0284a783          	lw	a5,40(s1)
80009384:	00f037b3          	snez	a5,a5
80009388:	0ff7f793          	andi	a5,a5,255
8000938c:	00100593          	li	a1,1
80009390:	00078513          	mv	a0,a5
80009394:	a81f70ef          	jal	ra,80000e14 <assert_id>
80009398:	801c27b7          	lui	a5,0x801c2
8000939c:	5dc7a583          	lw	a1,1500(a5) # 801c25dc <_bss_end+0xffffffec>
800093a0:	0104a783          	lw	a5,16(s1)
800093a4:	00078513          	mv	a0,a5
800093a8:	0004a603          	lw	a2,0(s1)
800093ac:	0044a683          	lw	a3,4(s1)
800093b0:	0084a703          	lw	a4,8(s1)
800093b4:	00c4a783          	lw	a5,12(s1)
800093b8:	fac42023          	sw	a2,-96(s0)
800093bc:	fad42223          	sw	a3,-92(s0)
800093c0:	fae42423          	sw	a4,-88(s0)
800093c4:	faf42623          	sw	a5,-84(s0)
800093c8:	fa040793          	addi	a5,s0,-96
800093cc:	00050693          	mv	a3,a0
800093d0:	00078613          	mv	a2,a5
800093d4:	00000513          	li	a0,0
800093d8:	a81ff0ef          	jal	ra,80008e58 <remove_entry>
800093dc:	fea42623          	sw	a0,-20(s0)
800093e0:	fec42703          	lw	a4,-20(s0)
800093e4:	fff00793          	li	a5,-1
800093e8:	02f70e63          	beq	a4,a5,80009424 <update+0x24c>
800093ec:	fec42703          	lw	a4,-20(s0)
800093f0:	00070793          	mv	a5,a4
800093f4:	00279793          	slli	a5,a5,0x2
800093f8:	00e787b3          	add	a5,a5,a4
800093fc:	00279793          	slli	a5,a5,0x2
80009400:	00078713          	mv	a4,a5
80009404:	805007b7          	lui	a5,0x80500
80009408:	00f707b3          	add	a5,a4,a5
8000940c:	00078023          	sb	zero,0(a5) # 80500000 <_bss_end+0x33da10>
80009410:	801c27b7          	lui	a5,0x801c2
80009414:	5e07a783          	lw	a5,1504(a5) # 801c25e0 <_bss_end+0xfffffff0>
80009418:	fec42583          	lw	a1,-20(s0)
8000941c:	00078513          	mv	a0,a5
80009420:	d80fd0ef          	jal	ra,800069a0 <timer_stop>
80009424:	00000013          	nop
80009428:	05c12083          	lw	ra,92(sp)
8000942c:	05812403          	lw	s0,88(sp)
80009430:	05412483          	lw	s1,84(sp)
80009434:	06010113          	addi	sp,sp,96
80009438:	00008067          	ret

8000943c <update_leaf_info>:
8000943c:	fc010113          	addi	sp,sp,-64
80009440:	02112e23          	sw	ra,60(sp)
80009444:	02812c23          	sw	s0,56(sp)
80009448:	04010413          	addi	s0,sp,64
8000944c:	fca42e23          	sw	a0,-36(s0)
80009450:	00058793          	mv	a5,a1
80009454:	00060713          	mv	a4,a2
80009458:	00068093          	mv	ra,a3
8000945c:	fcf40da3          	sb	a5,-37(s0)
80009460:	00070793          	mv	a5,a4
80009464:	fcf40d23          	sb	a5,-38(s0)
80009468:	fdb44703          	lbu	a4,-37(s0)
8000946c:	0ff00793          	li	a5,255
80009470:	02f70663          	beq	a4,a5,8000949c <update_leaf_info+0x60>
80009474:	fdc42703          	lw	a4,-36(s0)
80009478:	00070793          	mv	a5,a4
8000947c:	00279793          	slli	a5,a5,0x2
80009480:	00e787b3          	add	a5,a5,a4
80009484:	00279793          	slli	a5,a5,0x2
80009488:	00078713          	mv	a4,a5
8000948c:	805007b7          	lui	a5,0x80500
80009490:	00f707b3          	add	a5,a4,a5
80009494:	fdb44703          	lbu	a4,-37(s0)
80009498:	00e780a3          	sb	a4,1(a5) # 80500001 <_bss_end+0x33da11>
8000949c:	fda44703          	lbu	a4,-38(s0)
800094a0:	0ff00793          	li	a5,255
800094a4:	06f70663          	beq	a4,a5,80009510 <update_leaf_info+0xd4>
800094a8:	0000a603          	lw	a2,0(ra)
800094ac:	0040a683          	lw	a3,4(ra)
800094b0:	0080a703          	lw	a4,8(ra)
800094b4:	00c0a783          	lw	a5,12(ra)
800094b8:	fcc42023          	sw	a2,-64(s0)
800094bc:	fcd42223          	sw	a3,-60(s0)
800094c0:	fce42423          	sw	a4,-56(s0)
800094c4:	fcf42623          	sw	a5,-52(s0)
800094c8:	fc040713          	addi	a4,s0,-64
800094cc:	fda44783          	lbu	a5,-38(s0)
800094d0:	00100613          	li	a2,1
800094d4:	00070593          	mv	a1,a4
800094d8:	00078513          	mv	a0,a5
800094dc:	ef4fe0ef          	jal	ra,80007bd0 <_new_entry>
800094e0:	00050793          	mv	a5,a0
800094e4:	fef407a3          	sb	a5,-17(s0)
800094e8:	fdc42703          	lw	a4,-36(s0)
800094ec:	00070793          	mv	a5,a4
800094f0:	00279793          	slli	a5,a5,0x2
800094f4:	00e787b3          	add	a5,a5,a4
800094f8:	00279793          	slli	a5,a5,0x2
800094fc:	00078713          	mv	a4,a5
80009500:	805007b7          	lui	a5,0x80500
80009504:	00f707b3          	add	a5,a4,a5
80009508:	fef44703          	lbu	a4,-17(s0)
8000950c:	00e781a3          	sb	a4,3(a5) # 80500003 <_bss_end+0x33da13>
80009510:	801c27b7          	lui	a5,0x801c2
80009514:	5e07a783          	lw	a5,1504(a5) # 801c25e0 <_bss_end+0xfffffff0>
80009518:	fdc42583          	lw	a1,-36(s0)
8000951c:	00078513          	mv	a0,a5
80009520:	c80fd0ef          	jal	ra,800069a0 <timer_stop>
80009524:	801c27b7          	lui	a5,0x801c2
80009528:	5e07a783          	lw	a5,1504(a5) # 801c25e0 <_bss_end+0xfffffff0>
8000952c:	fdc42583          	lw	a1,-36(s0)
80009530:	00078513          	mv	a0,a5
80009534:	db0fd0ef          	jal	ra,80006ae4 <timer_start>
80009538:	00000013          	nop
8000953c:	03c12083          	lw	ra,60(sp)
80009540:	03812403          	lw	s0,56(sp)
80009544:	04010113          	addi	sp,sp,64
80009548:	00008067          	ret

8000954c <prefix_query>:
8000954c:	fa010113          	addi	sp,sp,-96
80009550:	04112e23          	sw	ra,92(sp)
80009554:	04812c23          	sw	s0,88(sp)
80009558:	04912a23          	sw	s1,84(sp)
8000955c:	05212823          	sw	s2,80(sp)
80009560:	05312623          	sw	s3,76(sp)
80009564:	06010413          	addi	s0,sp,96
80009568:	00050493          	mv	s1,a0
8000956c:	00058793          	mv	a5,a1
80009570:	fac42c23          	sw	a2,-72(s0)
80009574:	fad42a23          	sw	a3,-76(s0)
80009578:	fae42823          	sw	a4,-80(s0)
8000957c:	faf40fa3          	sb	a5,-65(s0)
80009580:	fc042e23          	sw	zero,-36(s0)
80009584:	801c27b7          	lui	a5,0x801c2
80009588:	5dc7a783          	lw	a5,1500(a5) # 801c25dc <_bss_end+0xffffffec>
8000958c:	00479713          	slli	a4,a5,0x4
80009590:	400007b7          	lui	a5,0x40000
80009594:	00f707b3          	add	a5,a4,a5
80009598:	fcf42c23          	sw	a5,-40(s0)
8000959c:	fc042a23          	sw	zero,-44(s0)
800095a0:	2100006f          	j	800097b0 <prefix_query+0x264>
800095a4:	0004a603          	lw	a2,0(s1)
800095a8:	0044a683          	lw	a3,4(s1)
800095ac:	0084a703          	lw	a4,8(s1)
800095b0:	00c4a783          	lw	a5,12(s1)
800095b4:	fac42023          	sw	a2,-96(s0)
800095b8:	fad42223          	sw	a3,-92(s0)
800095bc:	fae42423          	sw	a4,-88(s0)
800095c0:	faf42623          	sw	a5,-84(s0)
800095c4:	fa040793          	addi	a5,s0,-96
800095c8:	00400613          	li	a2,4
800095cc:	fd442583          	lw	a1,-44(s0)
800095d0:	00078513          	mv	a0,a5
800095d4:	cd4fe0ef          	jal	ra,80007aa8 <INDEX>
800095d8:	fca42423          	sw	a0,-56(s0)
800095dc:	fd442783          	lw	a5,-44(s0)
800095e0:	00378793          	addi	a5,a5,3 # 40000003 <_reset_vector-0x3ffffffd>
800095e4:	fcf42823          	sw	a5,-48(s0)
800095e8:	fc842783          	lw	a5,-56(s0)
800095ec:	0017d793          	srli	a5,a5,0x1
800095f0:	0087e793          	ori	a5,a5,8
800095f4:	fcf42623          	sw	a5,-52(s0)
800095f8:	09c0006f          	j	80009694 <prefix_query+0x148>
800095fc:	fd842783          	lw	a5,-40(s0)
80009600:	0047a703          	lw	a4,4(a5)
80009604:	fcc42783          	lw	a5,-52(s0)
80009608:	00100693          	li	a3,1
8000960c:	00f697b3          	sll	a5,a3,a5
80009610:	00f777b3          	and	a5,a4,a5
80009614:	06078463          	beqz	a5,8000967c <prefix_query+0x130>
80009618:	fbf44703          	lbu	a4,-65(s0)
8000961c:	0ff00793          	li	a5,255
80009620:	00f70863          	beq	a4,a5,80009630 <prefix_query+0xe4>
80009624:	fbf44783          	lbu	a5,-65(s0)
80009628:	fd042703          	lw	a4,-48(s0)
8000962c:	04f71863          	bne	a4,a5,8000967c <prefix_query+0x130>
80009630:	fd842783          	lw	a5,-40(s0)
80009634:	00c7a903          	lw	s2,12(a5)
80009638:	fd842783          	lw	a5,-40(s0)
8000963c:	0047a703          	lw	a4,4(a5)
80009640:	fcc42783          	lw	a5,-52(s0)
80009644:	00200693          	li	a3,2
80009648:	00f697b3          	sll	a5,a3,a5
8000964c:	fff78793          	addi	a5,a5,-1
80009650:	00f777b3          	and	a5,a4,a5
80009654:	00078513          	mv	a0,a5
80009658:	bf8fe0ef          	jal	ra,80007a50 <popcnt>
8000965c:	00050793          	mv	a5,a0
80009660:	00f907b3          	add	a5,s2,a5
80009664:	00279713          	slli	a4,a5,0x2
80009668:	804007b7          	lui	a5,0x80400
8000966c:	ffc78793          	addi	a5,a5,-4 # 803ffffc <_bss_end+0x23da0c>
80009670:	00f707b3          	add	a5,a4,a5
80009674:	fcf42e23          	sw	a5,-36(s0)
80009678:	0240006f          	j	8000969c <prefix_query+0x150>
8000967c:	fcc42783          	lw	a5,-52(s0)
80009680:	0017d793          	srli	a5,a5,0x1
80009684:	fcf42623          	sw	a5,-52(s0)
80009688:	fd042783          	lw	a5,-48(s0)
8000968c:	fff78793          	addi	a5,a5,-1
80009690:	fcf42823          	sw	a5,-48(s0)
80009694:	fcc42783          	lw	a5,-52(s0)
80009698:	f60792e3          	bnez	a5,800095fc <prefix_query+0xb0>
8000969c:	fd842783          	lw	a5,-40(s0)
800096a0:	0007a703          	lw	a4,0(a5)
800096a4:	fc842783          	lw	a5,-56(s0)
800096a8:	00100693          	li	a3,1
800096ac:	00f697b3          	sll	a5,a3,a5
800096b0:	00f777b3          	and	a5,a4,a5
800096b4:	10078663          	beqz	a5,800097c0 <prefix_query+0x274>
800096b8:	fd842783          	lw	a5,-40(s0)
800096bc:	00a7d783          	lhu	a5,10(a5)
800096c0:	0807f793          	andi	a5,a5,128
800096c4:	06078863          	beqz	a5,80009734 <prefix_query+0x1e8>
800096c8:	fbf44703          	lbu	a4,-65(s0)
800096cc:	0ff00793          	li	a5,255
800096d0:	00f70a63          	beq	a4,a5,800096e4 <prefix_query+0x198>
800096d4:	fbf44703          	lbu	a4,-65(s0)
800096d8:	fd442783          	lw	a5,-44(s0)
800096dc:	00478793          	addi	a5,a5,4
800096e0:	0cf71263          	bne	a4,a5,800097a4 <prefix_query+0x258>
800096e4:	fd842783          	lw	a5,-40(s0)
800096e8:	0087d783          	lhu	a5,8(a5)
800096ec:	00078493          	mv	s1,a5
800096f0:	fd842783          	lw	a5,-40(s0)
800096f4:	0007a703          	lw	a4,0(a5)
800096f8:	fc842783          	lw	a5,-56(s0)
800096fc:	00200693          	li	a3,2
80009700:	00f697b3          	sll	a5,a3,a5
80009704:	fff78793          	addi	a5,a5,-1
80009708:	00f777b3          	and	a5,a4,a5
8000970c:	00078513          	mv	a0,a5
80009710:	b40fe0ef          	jal	ra,80007a50 <popcnt>
80009714:	00050793          	mv	a5,a0
80009718:	00f487b3          	add	a5,s1,a5
8000971c:	00279713          	slli	a4,a5,0x2
80009720:	804007b7          	lui	a5,0x80400
80009724:	ffc78793          	addi	a5,a5,-4 # 803ffffc <_bss_end+0x23da0c>
80009728:	00f707b3          	add	a5,a4,a5
8000972c:	fcf42e23          	sw	a5,-36(s0)
80009730:	0940006f          	j	800097c4 <prefix_query+0x278>
80009734:	fd442783          	lw	a5,-44(s0)
80009738:	00478793          	addi	a5,a5,4
8000973c:	41f7d713          	srai	a4,a5,0x1f
80009740:	00f77713          	andi	a4,a4,15
80009744:	00f707b3          	add	a5,a4,a5
80009748:	4047d793          	srai	a5,a5,0x4
8000974c:	01879793          	slli	a5,a5,0x18
80009750:	00078913          	mv	s2,a5
80009754:	fd842783          	lw	a5,-40(s0)
80009758:	0087d783          	lhu	a5,8(a5)
8000975c:	00078993          	mv	s3,a5
80009760:	fd842783          	lw	a5,-40(s0)
80009764:	0007a703          	lw	a4,0(a5)
80009768:	fc842783          	lw	a5,-56(s0)
8000976c:	00200693          	li	a3,2
80009770:	00f697b3          	sll	a5,a3,a5
80009774:	fff78793          	addi	a5,a5,-1
80009778:	00f777b3          	and	a5,a4,a5
8000977c:	00078513          	mv	a0,a5
80009780:	ad0fe0ef          	jal	ra,80007a50 <popcnt>
80009784:	00050793          	mv	a5,a0
80009788:	00f987b3          	add	a5,s3,a5
8000978c:	00479793          	slli	a5,a5,0x4
80009790:	00f90733          	add	a4,s2,a5
80009794:	400007b7          	lui	a5,0x40000
80009798:	ff078793          	addi	a5,a5,-16 # 3ffffff0 <_reset_vector-0x40000010>
8000979c:	00f707b3          	add	a5,a4,a5
800097a0:	fcf42c23          	sw	a5,-40(s0)
800097a4:	fd442783          	lw	a5,-44(s0)
800097a8:	00478793          	addi	a5,a5,4
800097ac:	fcf42a23          	sw	a5,-44(s0)
800097b0:	fbf44783          	lbu	a5,-65(s0)
800097b4:	fd442703          	lw	a4,-44(s0)
800097b8:	def746e3          	blt	a4,a5,800095a4 <prefix_query+0x58>
800097bc:	0080006f          	j	800097c4 <prefix_query+0x278>
800097c0:	00000013          	nop
800097c4:	fdc42783          	lw	a5,-36(s0)
800097c8:	00079663          	bnez	a5,800097d4 <prefix_query+0x288>
800097cc:	00000793          	li	a5,0
800097d0:	09c0006f          	j	8000986c <prefix_query+0x320>
800097d4:	fb842783          	lw	a5,-72(s0)
800097d8:	02078e63          	beqz	a5,80009814 <prefix_query+0x2c8>
800097dc:	fdc42783          	lw	a5,-36(s0)
800097e0:	0037c783          	lbu	a5,3(a5)
800097e4:	00579713          	slli	a4,a5,0x5
800097e8:	510007b7          	lui	a5,0x51000
800097ec:	00f70733          	add	a4,a4,a5
800097f0:	fb842783          	lw	a5,-72(s0)
800097f4:	00072583          	lw	a1,0(a4)
800097f8:	00472603          	lw	a2,4(a4)
800097fc:	00872683          	lw	a3,8(a4)
80009800:	00c72703          	lw	a4,12(a4)
80009804:	00b7a023          	sw	a1,0(a5) # 51000000 <_reset_vector-0x2f000000>
80009808:	00c7a223          	sw	a2,4(a5)
8000980c:	00d7a423          	sw	a3,8(a5)
80009810:	00e7a623          	sw	a4,12(a5)
80009814:	fb442783          	lw	a5,-76(s0)
80009818:	02078263          	beqz	a5,8000983c <prefix_query+0x2f0>
8000981c:	fdc42783          	lw	a5,-36(s0)
80009820:	0037c783          	lbu	a5,3(a5)
80009824:	00579713          	slli	a4,a5,0x5
80009828:	510007b7          	lui	a5,0x51000
8000982c:	00f707b3          	add	a5,a4,a5
80009830:	0107a703          	lw	a4,16(a5) # 51000010 <_reset_vector-0x2efffff0>
80009834:	fb442783          	lw	a5,-76(s0)
80009838:	00e7a023          	sw	a4,0(a5)
8000983c:	fb042783          	lw	a5,-80(s0)
80009840:	02078263          	beqz	a5,80009864 <prefix_query+0x318>
80009844:	fdc42783          	lw	a5,-36(s0)
80009848:	0037c783          	lbu	a5,3(a5)
8000984c:	00579713          	slli	a4,a5,0x5
80009850:	510007b7          	lui	a5,0x51000
80009854:	00f707b3          	add	a5,a4,a5
80009858:	0147a703          	lw	a4,20(a5) # 51000014 <_reset_vector-0x2effffec>
8000985c:	fb042783          	lw	a5,-80(s0)
80009860:	00e7a023          	sw	a4,0(a5)
80009864:	fdc42783          	lw	a5,-36(s0)
80009868:	0037c783          	lbu	a5,3(a5)
8000986c:	00078513          	mv	a0,a5
80009870:	05c12083          	lw	ra,92(sp)
80009874:	05812403          	lw	s0,88(sp)
80009878:	05412483          	lw	s1,84(sp)
8000987c:	05012903          	lw	s2,80(sp)
80009880:	04c12983          	lw	s3,76(sp)
80009884:	06010113          	addi	sp,sp,96
80009888:	00008067          	ret

8000988c <_append_answer>:
8000988c:	fe010113          	addi	sp,sp,-32
80009890:	00812e23          	sw	s0,28(sp)
80009894:	02010413          	addi	s0,sp,32
80009898:	fea42623          	sw	a0,-20(s0)
8000989c:	feb42423          	sw	a1,-24(s0)
800098a0:	fec42223          	sw	a2,-28(s0)
800098a4:	fed42023          	sw	a3,-32(s0)
800098a8:	fec42783          	lw	a5,-20(s0)
800098ac:	fe842703          	lw	a4,-24(s0)
800098b0:	00072583          	lw	a1,0(a4)
800098b4:	00472603          	lw	a2,4(a4)
800098b8:	00872683          	lw	a3,8(a4)
800098bc:	00c72703          	lw	a4,12(a4)
800098c0:	00b7a023          	sw	a1,0(a5)
800098c4:	00c7a223          	sw	a2,4(a5)
800098c8:	00d7a423          	sw	a3,8(a5)
800098cc:	00e7a623          	sw	a4,12(a5)
800098d0:	fe442703          	lw	a4,-28(s0)
800098d4:	fec42783          	lw	a5,-20(s0)
800098d8:	00e7a823          	sw	a4,16(a5)
800098dc:	fe344783          	lbu	a5,-29(s0)
800098e0:	00579713          	slli	a4,a5,0x5
800098e4:	510007b7          	lui	a5,0x51000
800098e8:	00f70733          	add	a4,a4,a5
800098ec:	fec42783          	lw	a5,-20(s0)
800098f0:	00072583          	lw	a1,0(a4)
800098f4:	00472603          	lw	a2,4(a4)
800098f8:	00872683          	lw	a3,8(a4)
800098fc:	00c72703          	lw	a4,12(a4)
80009900:	00b7ac23          	sw	a1,24(a5) # 51000018 <_reset_vector-0x2effffe8>
80009904:	00c7ae23          	sw	a2,28(a5)
80009908:	02d7a023          	sw	a3,32(a5)
8000990c:	02e7a223          	sw	a4,36(a5)
80009910:	fe344783          	lbu	a5,-29(s0)
80009914:	00579713          	slli	a4,a5,0x5
80009918:	510007b7          	lui	a5,0x51000
8000991c:	00f707b3          	add	a5,a4,a5
80009920:	0107a703          	lw	a4,16(a5) # 51000010 <_reset_vector-0x2efffff0>
80009924:	fec42783          	lw	a5,-20(s0)
80009928:	00e7aa23          	sw	a4,20(a5)
8000992c:	fe344783          	lbu	a5,-29(s0)
80009930:	00579713          	slli	a4,a5,0x5
80009934:	510007b7          	lui	a5,0x51000
80009938:	00f707b3          	add	a5,a4,a5
8000993c:	0147a703          	lw	a4,20(a5) # 51000014 <_reset_vector-0x2effffec>
80009940:	fec42783          	lw	a5,-20(s0)
80009944:	02e7a423          	sw	a4,40(a5)
80009948:	00000013          	nop
8000994c:	01c12403          	lw	s0,28(sp)
80009950:	02010113          	addi	sp,sp,32
80009954:	00008067          	ret

80009958 <_prefix_query_all>:
80009958:	f7010113          	addi	sp,sp,-144
8000995c:	08112623          	sw	ra,140(sp)
80009960:	08812423          	sw	s0,136(sp)
80009964:	08912223          	sw	s1,132(sp)
80009968:	09212023          	sw	s2,128(sp)
8000996c:	07312e23          	sw	s3,124(sp)
80009970:	07412c23          	sw	s4,120(sp)
80009974:	07512a23          	sw	s5,116(sp)
80009978:	09010413          	addi	s0,sp,144
8000997c:	faa42623          	sw	a0,-84(s0)
80009980:	fab42423          	sw	a1,-88(s0)
80009984:	00060913          	mv	s2,a2
80009988:	fad42223          	sw	a3,-92(s0)
8000998c:	fae42023          	sw	a4,-96(s0)
80009990:	00080493          	mv	s1,a6
80009994:	f8f40fa3          	sb	a5,-97(s0)
80009998:	fac42703          	lw	a4,-84(s0)
8000999c:	08000793          	li	a5,128
800099a0:	12e7c2e3          	blt	a5,a4,8000a2c4 <_prefix_query_all+0x96c>
800099a4:	fa842783          	lw	a5,-88(s0)
800099a8:	00479713          	slli	a4,a5,0x4
800099ac:	fac42783          	lw	a5,-84(s0)
800099b0:	41f7d693          	srai	a3,a5,0x1f
800099b4:	00f6f693          	andi	a3,a3,15
800099b8:	00f687b3          	add	a5,a3,a5
800099bc:	4047d793          	srai	a5,a5,0x4
800099c0:	01879793          	slli	a5,a5,0x18
800099c4:	00f70733          	add	a4,a4,a5
800099c8:	400007b7          	lui	a5,0x40000
800099cc:	00f707b3          	add	a5,a4,a5
800099d0:	fcf42623          	sw	a5,-52(s0)
800099d4:	f9f44783          	lbu	a5,-97(s0)
800099d8:	4a078a63          	beqz	a5,80009e8c <_prefix_query_all+0x534>
800099dc:	00100793          	li	a5,1
800099e0:	fcf42e23          	sw	a5,-36(s0)
800099e4:	2280006f          	j	80009c0c <_prefix_query_all+0x2b4>
800099e8:	fcc42783          	lw	a5,-52(s0)
800099ec:	0047a703          	lw	a4,4(a5) # 40000004 <_reset_vector-0x3ffffffc>
800099f0:	fdc42783          	lw	a5,-36(s0)
800099f4:	00100693          	li	a3,1
800099f8:	00f697b3          	sll	a5,a3,a5
800099fc:	00f777b3          	and	a5,a4,a5
80009a00:	1e078e63          	beqz	a5,80009bfc <_prefix_query_all+0x2a4>
80009a04:	00300793          	li	a5,3
80009a08:	fcf42c23          	sw	a5,-40(s0)
80009a0c:	1e40006f          	j	80009bf0 <_prefix_query_all+0x298>
80009a10:	fd842783          	lw	a5,-40(s0)
80009a14:	fdc42703          	lw	a4,-36(s0)
80009a18:	40f757b3          	sra	a5,a4,a5
80009a1c:	0017f793          	andi	a5,a5,1
80009a20:	1c078263          	beqz	a5,80009be4 <_prefix_query_all+0x28c>
80009a24:	fcc42783          	lw	a5,-52(s0)
80009a28:	00c7a983          	lw	s3,12(a5)
80009a2c:	fcc42783          	lw	a5,-52(s0)
80009a30:	0047a703          	lw	a4,4(a5)
80009a34:	fdc42783          	lw	a5,-36(s0)
80009a38:	00200693          	li	a3,2
80009a3c:	00f697b3          	sll	a5,a3,a5
80009a40:	fff78793          	addi	a5,a5,-1
80009a44:	00f777b3          	and	a5,a4,a5
80009a48:	00078513          	mv	a0,a5
80009a4c:	804fe0ef          	jal	ra,80007a50 <popcnt>
80009a50:	00050793          	mv	a5,a0
80009a54:	00f987b3          	add	a5,s3,a5
80009a58:	00279713          	slli	a4,a5,0x2
80009a5c:	804007b7          	lui	a5,0x80400
80009a60:	ffc78793          	addi	a5,a5,-4 # 803ffffc <_bss_end+0x23da0c>
80009a64:	00f707b3          	add	a5,a4,a5
80009a68:	0007a783          	lw	a5,0(a5)
80009a6c:	faf42c23          	sw	a5,-72(s0)
80009a70:	fac42783          	lw	a5,-84(s0)
80009a74:	0077f793          	andi	a5,a5,7
80009a78:	08079863          	bnez	a5,80009b08 <_prefix_query_all+0x1b0>
80009a7c:	fac42783          	lw	a5,-84(s0)
80009a80:	41f7d713          	srai	a4,a5,0x1f
80009a84:	00777713          	andi	a4,a4,7
80009a88:	00f707b3          	add	a5,a4,a5
80009a8c:	4037d793          	srai	a5,a5,0x3
80009a90:	00f487b3          	add	a5,s1,a5
80009a94:	0007c783          	lbu	a5,0(a5)
80009a98:	01879793          	slli	a5,a5,0x18
80009a9c:	4187d793          	srai	a5,a5,0x18
80009aa0:	00f7f793          	andi	a5,a5,15
80009aa4:	01879713          	slli	a4,a5,0x18
80009aa8:	41875713          	srai	a4,a4,0x18
80009aac:	fd842783          	lw	a5,-40(s0)
80009ab0:	00100693          	li	a3,1
80009ab4:	00f696b3          	sll	a3,a3,a5
80009ab8:	fdc42783          	lw	a5,-36(s0)
80009abc:	00f6c6b3          	xor	a3,a3,a5
80009ac0:	00800613          	li	a2,8
80009ac4:	fd842783          	lw	a5,-40(s0)
80009ac8:	40f607b3          	sub	a5,a2,a5
80009acc:	00f697b3          	sll	a5,a3,a5
80009ad0:	01879793          	slli	a5,a5,0x18
80009ad4:	4187d793          	srai	a5,a5,0x18
80009ad8:	00f767b3          	or	a5,a4,a5
80009adc:	01879693          	slli	a3,a5,0x18
80009ae0:	4186d693          	srai	a3,a3,0x18
80009ae4:	fac42783          	lw	a5,-84(s0)
80009ae8:	41f7d713          	srai	a4,a5,0x1f
80009aec:	00777713          	andi	a4,a4,7
80009af0:	00f707b3          	add	a5,a4,a5
80009af4:	4037d793          	srai	a5,a5,0x3
80009af8:	0ff6f713          	andi	a4,a3,255
80009afc:	00f487b3          	add	a5,s1,a5
80009b00:	00e78023          	sb	a4,0(a5)
80009b04:	08c0006f          	j	80009b90 <_prefix_query_all+0x238>
80009b08:	fac42783          	lw	a5,-84(s0)
80009b0c:	41f7d713          	srai	a4,a5,0x1f
80009b10:	00777713          	andi	a4,a4,7
80009b14:	00f707b3          	add	a5,a4,a5
80009b18:	4037d793          	srai	a5,a5,0x3
80009b1c:	00f487b3          	add	a5,s1,a5
80009b20:	0007c783          	lbu	a5,0(a5)
80009b24:	01879793          	slli	a5,a5,0x18
80009b28:	4187d793          	srai	a5,a5,0x18
80009b2c:	ff07f793          	andi	a5,a5,-16
80009b30:	01879713          	slli	a4,a5,0x18
80009b34:	41875713          	srai	a4,a4,0x18
80009b38:	fd842783          	lw	a5,-40(s0)
80009b3c:	00100693          	li	a3,1
80009b40:	00f696b3          	sll	a3,a3,a5
80009b44:	fdc42783          	lw	a5,-36(s0)
80009b48:	00f6c6b3          	xor	a3,a3,a5
80009b4c:	00400613          	li	a2,4
80009b50:	fd842783          	lw	a5,-40(s0)
80009b54:	40f607b3          	sub	a5,a2,a5
80009b58:	00f697b3          	sll	a5,a3,a5
80009b5c:	01879793          	slli	a5,a5,0x18
80009b60:	4187d793          	srai	a5,a5,0x18
80009b64:	00f767b3          	or	a5,a4,a5
80009b68:	01879693          	slli	a3,a5,0x18
80009b6c:	4186d693          	srai	a3,a3,0x18
80009b70:	fac42783          	lw	a5,-84(s0)
80009b74:	41f7d713          	srai	a4,a5,0x1f
80009b78:	00777713          	andi	a4,a4,7
80009b7c:	00f707b3          	add	a5,a4,a5
80009b80:	4037d793          	srai	a5,a5,0x3
80009b84:	0ff6f713          	andi	a4,a3,255
80009b88:	00f487b3          	add	a5,s1,a5
80009b8c:	00e78023          	sb	a4,0(a5)
80009b90:	fa042783          	lw	a5,-96(s0)
80009b94:	0007a783          	lw	a5,0(a5)
80009b98:	00178693          	addi	a3,a5,1
80009b9c:	fa042703          	lw	a4,-96(s0)
80009ba0:	00d72023          	sw	a3,0(a4)
80009ba4:	00078713          	mv	a4,a5
80009ba8:	00070793          	mv	a5,a4
80009bac:	00179793          	slli	a5,a5,0x1
80009bb0:	00e787b3          	add	a5,a5,a4
80009bb4:	00479793          	slli	a5,a5,0x4
80009bb8:	00078713          	mv	a4,a5
80009bbc:	fa442783          	lw	a5,-92(s0)
80009bc0:	00e78533          	add	a0,a5,a4
80009bc4:	fac42703          	lw	a4,-84(s0)
80009bc8:	fd842783          	lw	a5,-40(s0)
80009bcc:	00f707b3          	add	a5,a4,a5
80009bd0:	fb842683          	lw	a3,-72(s0)
80009bd4:	00078613          	mv	a2,a5
80009bd8:	00048593          	mv	a1,s1
80009bdc:	cb1ff0ef          	jal	ra,8000988c <_append_answer>
80009be0:	0200006f          	j	80009c00 <_prefix_query_all+0x2a8>
80009be4:	fd842783          	lw	a5,-40(s0)
80009be8:	fff78793          	addi	a5,a5,-1
80009bec:	fcf42c23          	sw	a5,-40(s0)
80009bf0:	fd842783          	lw	a5,-40(s0)
80009bf4:	e007dee3          	bgez	a5,80009a10 <_prefix_query_all+0xb8>
80009bf8:	0080006f          	j	80009c00 <_prefix_query_all+0x2a8>
80009bfc:	00000013          	nop
80009c00:	fdc42783          	lw	a5,-36(s0)
80009c04:	00178793          	addi	a5,a5,1
80009c08:	fcf42e23          	sw	a5,-36(s0)
80009c0c:	fdc42703          	lw	a4,-36(s0)
80009c10:	00f00793          	li	a5,15
80009c14:	dce7dae3          	bge	a5,a4,800099e8 <_prefix_query_all+0x90>
80009c18:	fc042a23          	sw	zero,-44(s0)
80009c1c:	2600006f          	j	80009e7c <_prefix_query_all+0x524>
80009c20:	fcc42783          	lw	a5,-52(s0)
80009c24:	0007a703          	lw	a4,0(a5)
80009c28:	fd442783          	lw	a5,-44(s0)
80009c2c:	00100693          	li	a3,1
80009c30:	00f697b3          	sll	a5,a3,a5
80009c34:	00f777b3          	and	a5,a4,a5
80009c38:	22078c63          	beqz	a5,80009e70 <_prefix_query_all+0x518>
80009c3c:	fac42783          	lw	a5,-84(s0)
80009c40:	0077f793          	andi	a5,a5,7
80009c44:	06079a63          	bnez	a5,80009cb8 <_prefix_query_all+0x360>
80009c48:	fac42783          	lw	a5,-84(s0)
80009c4c:	41f7d713          	srai	a4,a5,0x1f
80009c50:	00777713          	andi	a4,a4,7
80009c54:	00f707b3          	add	a5,a4,a5
80009c58:	4037d793          	srai	a5,a5,0x3
80009c5c:	00f487b3          	add	a5,s1,a5
80009c60:	0007c783          	lbu	a5,0(a5)
80009c64:	01879793          	slli	a5,a5,0x18
80009c68:	4187d793          	srai	a5,a5,0x18
80009c6c:	00f7f793          	andi	a5,a5,15
80009c70:	01879713          	slli	a4,a5,0x18
80009c74:	41875713          	srai	a4,a4,0x18
80009c78:	fd442783          	lw	a5,-44(s0)
80009c7c:	00479793          	slli	a5,a5,0x4
80009c80:	01879793          	slli	a5,a5,0x18
80009c84:	4187d793          	srai	a5,a5,0x18
80009c88:	00f767b3          	or	a5,a4,a5
80009c8c:	01879693          	slli	a3,a5,0x18
80009c90:	4186d693          	srai	a3,a3,0x18
80009c94:	fac42783          	lw	a5,-84(s0)
80009c98:	41f7d713          	srai	a4,a5,0x1f
80009c9c:	00777713          	andi	a4,a4,7
80009ca0:	00f707b3          	add	a5,a4,a5
80009ca4:	4037d793          	srai	a5,a5,0x3
80009ca8:	0ff6f713          	andi	a4,a3,255
80009cac:	00f487b3          	add	a5,s1,a5
80009cb0:	00e78023          	sb	a4,0(a5)
80009cb4:	06c0006f          	j	80009d20 <_prefix_query_all+0x3c8>
80009cb8:	fac42783          	lw	a5,-84(s0)
80009cbc:	41f7d713          	srai	a4,a5,0x1f
80009cc0:	00777713          	andi	a4,a4,7
80009cc4:	00f707b3          	add	a5,a4,a5
80009cc8:	4037d793          	srai	a5,a5,0x3
80009ccc:	00f487b3          	add	a5,s1,a5
80009cd0:	0007c783          	lbu	a5,0(a5)
80009cd4:	01879793          	slli	a5,a5,0x18
80009cd8:	4187d793          	srai	a5,a5,0x18
80009cdc:	ff07f793          	andi	a5,a5,-16
80009ce0:	01879713          	slli	a4,a5,0x18
80009ce4:	41875713          	srai	a4,a4,0x18
80009ce8:	fd442783          	lw	a5,-44(s0)
80009cec:	01879793          	slli	a5,a5,0x18
80009cf0:	4187d793          	srai	a5,a5,0x18
80009cf4:	00f767b3          	or	a5,a4,a5
80009cf8:	01879693          	slli	a3,a5,0x18
80009cfc:	4186d693          	srai	a3,a3,0x18
80009d00:	fac42783          	lw	a5,-84(s0)
80009d04:	41f7d713          	srai	a4,a5,0x1f
80009d08:	00777713          	andi	a4,a4,7
80009d0c:	00f707b3          	add	a5,a4,a5
80009d10:	4037d793          	srai	a5,a5,0x3
80009d14:	0ff6f713          	andi	a4,a3,255
80009d18:	00f487b3          	add	a5,s1,a5
80009d1c:	00e78023          	sb	a4,0(a5)
80009d20:	fcc42783          	lw	a5,-52(s0)
80009d24:	00a7d783          	lhu	a5,10(a5)
80009d28:	0807f793          	andi	a5,a5,128
80009d2c:	0a078063          	beqz	a5,80009dcc <_prefix_query_all+0x474>
80009d30:	fa042783          	lw	a5,-96(s0)
80009d34:	0007a783          	lw	a5,0(a5)
80009d38:	00178693          	addi	a3,a5,1
80009d3c:	fa042703          	lw	a4,-96(s0)
80009d40:	00d72023          	sw	a3,0(a4)
80009d44:	00078713          	mv	a4,a5
80009d48:	00070793          	mv	a5,a4
80009d4c:	00179793          	slli	a5,a5,0x1
80009d50:	00e787b3          	add	a5,a5,a4
80009d54:	00479793          	slli	a5,a5,0x4
80009d58:	00078713          	mv	a4,a5
80009d5c:	fa442783          	lw	a5,-92(s0)
80009d60:	00e789b3          	add	s3,a5,a4
80009d64:	fac42783          	lw	a5,-84(s0)
80009d68:	00478a13          	addi	s4,a5,4
80009d6c:	fcc42783          	lw	a5,-52(s0)
80009d70:	0087d783          	lhu	a5,8(a5)
80009d74:	00078a93          	mv	s5,a5
80009d78:	fcc42783          	lw	a5,-52(s0)
80009d7c:	0007a703          	lw	a4,0(a5)
80009d80:	fd442783          	lw	a5,-44(s0)
80009d84:	00200693          	li	a3,2
80009d88:	00f697b3          	sll	a5,a3,a5
80009d8c:	fff78793          	addi	a5,a5,-1
80009d90:	00f777b3          	and	a5,a4,a5
80009d94:	00078513          	mv	a0,a5
80009d98:	cb9fd0ef          	jal	ra,80007a50 <popcnt>
80009d9c:	00050793          	mv	a5,a0
80009da0:	00fa87b3          	add	a5,s5,a5
80009da4:	00279713          	slli	a4,a5,0x2
80009da8:	804007b7          	lui	a5,0x80400
80009dac:	ffc78793          	addi	a5,a5,-4 # 803ffffc <_bss_end+0x23da0c>
80009db0:	00f707b3          	add	a5,a4,a5
80009db4:	0007a683          	lw	a3,0(a5)
80009db8:	000a0613          	mv	a2,s4
80009dbc:	00048593          	mv	a1,s1
80009dc0:	00098513          	mv	a0,s3
80009dc4:	ac9ff0ef          	jal	ra,8000988c <_append_answer>
80009dc8:	0a80006f          	j	80009e70 <_prefix_query_all+0x518>
80009dcc:	fac42783          	lw	a5,-84(s0)
80009dd0:	00478993          	addi	s3,a5,4
80009dd4:	fcc42783          	lw	a5,-52(s0)
80009dd8:	0087d783          	lhu	a5,8(a5)
80009ddc:	00078a13          	mv	s4,a5
80009de0:	fcc42783          	lw	a5,-52(s0)
80009de4:	0007a703          	lw	a4,0(a5)
80009de8:	fd442783          	lw	a5,-44(s0)
80009dec:	00200693          	li	a3,2
80009df0:	00f697b3          	sll	a5,a3,a5
80009df4:	fff78793          	addi	a5,a5,-1
80009df8:	00f777b3          	and	a5,a4,a5
80009dfc:	00078513          	mv	a0,a5
80009e00:	c51fd0ef          	jal	ra,80007a50 <popcnt>
80009e04:	00050793          	mv	a5,a0
80009e08:	00fa07b3          	add	a5,s4,a5
80009e0c:	fff78593          	addi	a1,a5,-1
80009e10:	00092603          	lw	a2,0(s2)
80009e14:	00492683          	lw	a3,4(s2)
80009e18:	00892703          	lw	a4,8(s2)
80009e1c:	00c92783          	lw	a5,12(s2)
80009e20:	f8c42023          	sw	a2,-128(s0)
80009e24:	f8d42223          	sw	a3,-124(s0)
80009e28:	f8e42423          	sw	a4,-120(s0)
80009e2c:	f8f42623          	sw	a5,-116(s0)
80009e30:	0004a603          	lw	a2,0(s1)
80009e34:	0044a683          	lw	a3,4(s1)
80009e38:	0084a703          	lw	a4,8(s1)
80009e3c:	00c4a783          	lw	a5,12(s1)
80009e40:	f6c42823          	sw	a2,-144(s0)
80009e44:	f6d42a23          	sw	a3,-140(s0)
80009e48:	f6e42c23          	sw	a4,-136(s0)
80009e4c:	f6f42e23          	sw	a5,-132(s0)
80009e50:	f7040713          	addi	a4,s0,-144
80009e54:	f9f44783          	lbu	a5,-97(s0)
80009e58:	f8040613          	addi	a2,s0,-128
80009e5c:	00070813          	mv	a6,a4
80009e60:	fa042703          	lw	a4,-96(s0)
80009e64:	fa442683          	lw	a3,-92(s0)
80009e68:	00098513          	mv	a0,s3
80009e6c:	aedff0ef          	jal	ra,80009958 <_prefix_query_all>
80009e70:	fd442783          	lw	a5,-44(s0)
80009e74:	00178793          	addi	a5,a5,1
80009e78:	fcf42a23          	sw	a5,-44(s0)
80009e7c:	fd442703          	lw	a4,-44(s0)
80009e80:	00f00793          	li	a5,15
80009e84:	d8e7dee3          	bge	a5,a4,80009c20 <_prefix_query_all+0x2c8>
80009e88:	4400006f          	j	8000a2c8 <_prefix_query_all+0x970>
80009e8c:	00092603          	lw	a2,0(s2)
80009e90:	00492683          	lw	a3,4(s2)
80009e94:	00892703          	lw	a4,8(s2)
80009e98:	00c92783          	lw	a5,12(s2)
80009e9c:	f6c42823          	sw	a2,-144(s0)
80009ea0:	f6d42a23          	sw	a3,-140(s0)
80009ea4:	f6e42c23          	sw	a4,-136(s0)
80009ea8:	f6f42e23          	sw	a5,-132(s0)
80009eac:	f7040793          	addi	a5,s0,-144
80009eb0:	00400613          	li	a2,4
80009eb4:	fac42583          	lw	a1,-84(s0)
80009eb8:	00078513          	mv	a0,a5
80009ebc:	bedfd0ef          	jal	ra,80007aa8 <INDEX>
80009ec0:	fca42423          	sw	a0,-56(s0)
80009ec4:	fc842783          	lw	a5,-56(s0)
80009ec8:	0017d793          	srli	a5,a5,0x1
80009ecc:	0087e793          	ori	a5,a5,8
80009ed0:	fcf42223          	sw	a5,-60(s0)
80009ed4:	fc042823          	sw	zero,-48(s0)
80009ed8:	1b80006f          	j	8000a090 <_prefix_query_all+0x738>
80009edc:	fd042783          	lw	a5,-48(s0)
80009ee0:	fc442703          	lw	a4,-60(s0)
80009ee4:	00f757b3          	srl	a5,a4,a5
80009ee8:	fcf42023          	sw	a5,-64(s0)
80009eec:	fd042783          	lw	a5,-48(s0)
80009ef0:	00178793          	addi	a5,a5,1
80009ef4:	fc842703          	lw	a4,-56(s0)
80009ef8:	00f757b3          	srl	a5,a4,a5
80009efc:	faf42e23          	sw	a5,-68(s0)
80009f00:	fcc42783          	lw	a5,-52(s0)
80009f04:	0047a703          	lw	a4,4(a5)
80009f08:	fc042783          	lw	a5,-64(s0)
80009f0c:	00100693          	li	a3,1
80009f10:	00f697b3          	sll	a5,a3,a5
80009f14:	00f777b3          	and	a5,a4,a5
80009f18:	16078663          	beqz	a5,8000a084 <_prefix_query_all+0x72c>
80009f1c:	fcc42783          	lw	a5,-52(s0)
80009f20:	00c7a983          	lw	s3,12(a5)
80009f24:	fcc42783          	lw	a5,-52(s0)
80009f28:	0047a703          	lw	a4,4(a5)
80009f2c:	fc042783          	lw	a5,-64(s0)
80009f30:	00200693          	li	a3,2
80009f34:	00f697b3          	sll	a5,a3,a5
80009f38:	fff78793          	addi	a5,a5,-1
80009f3c:	00f777b3          	and	a5,a4,a5
80009f40:	00078513          	mv	a0,a5
80009f44:	b0dfd0ef          	jal	ra,80007a50 <popcnt>
80009f48:	00050793          	mv	a5,a0
80009f4c:	00f987b3          	add	a5,s3,a5
80009f50:	00279713          	slli	a4,a5,0x2
80009f54:	804007b7          	lui	a5,0x80400
80009f58:	ffc78793          	addi	a5,a5,-4 # 803ffffc <_bss_end+0x23da0c>
80009f5c:	00f707b3          	add	a5,a4,a5
80009f60:	0007a783          	lw	a5,0(a5)
80009f64:	faf42a23          	sw	a5,-76(s0)
80009f68:	fac42783          	lw	a5,-84(s0)
80009f6c:	0077f793          	andi	a5,a5,7
80009f70:	06079263          	bnez	a5,80009fd4 <_prefix_query_all+0x67c>
80009f74:	fac42783          	lw	a5,-84(s0)
80009f78:	41f7d713          	srai	a4,a5,0x1f
80009f7c:	00777713          	andi	a4,a4,7
80009f80:	00f707b3          	add	a5,a4,a5
80009f84:	4037d793          	srai	a5,a5,0x3
80009f88:	00f487b3          	add	a5,s1,a5
80009f8c:	0007c783          	lbu	a5,0(a5)
80009f90:	00f7f793          	andi	a5,a5,15
80009f94:	0ff7f693          	andi	a3,a5,255
80009f98:	fd042783          	lw	a5,-48(s0)
80009f9c:	00578793          	addi	a5,a5,5
80009fa0:	fbc42703          	lw	a4,-68(s0)
80009fa4:	00f717b3          	sll	a5,a4,a5
80009fa8:	0ff7f713          	andi	a4,a5,255
80009fac:	fac42783          	lw	a5,-84(s0)
80009fb0:	41f7d613          	srai	a2,a5,0x1f
80009fb4:	00767613          	andi	a2,a2,7
80009fb8:	00f607b3          	add	a5,a2,a5
80009fbc:	4037d793          	srai	a5,a5,0x3
80009fc0:	00e6e733          	or	a4,a3,a4
80009fc4:	0ff77713          	andi	a4,a4,255
80009fc8:	00f487b3          	add	a5,s1,a5
80009fcc:	00e78023          	sb	a4,0(a5)
80009fd0:	0600006f          	j	8000a030 <_prefix_query_all+0x6d8>
80009fd4:	fac42783          	lw	a5,-84(s0)
80009fd8:	41f7d713          	srai	a4,a5,0x1f
80009fdc:	00777713          	andi	a4,a4,7
80009fe0:	00f707b3          	add	a5,a4,a5
80009fe4:	4037d793          	srai	a5,a5,0x3
80009fe8:	00f487b3          	add	a5,s1,a5
80009fec:	0007c783          	lbu	a5,0(a5)
80009ff0:	ff07f793          	andi	a5,a5,-16
80009ff4:	0ff7f693          	andi	a3,a5,255
80009ff8:	fd042783          	lw	a5,-48(s0)
80009ffc:	00178793          	addi	a5,a5,1
8000a000:	fbc42703          	lw	a4,-68(s0)
8000a004:	00f717b3          	sll	a5,a4,a5
8000a008:	0ff7f713          	andi	a4,a5,255
8000a00c:	fac42783          	lw	a5,-84(s0)
8000a010:	41f7d613          	srai	a2,a5,0x1f
8000a014:	00767613          	andi	a2,a2,7
8000a018:	00f607b3          	add	a5,a2,a5
8000a01c:	4037d793          	srai	a5,a5,0x3
8000a020:	00e6e733          	or	a4,a3,a4
8000a024:	0ff77713          	andi	a4,a4,255
8000a028:	00f487b3          	add	a5,s1,a5
8000a02c:	00e78023          	sb	a4,0(a5)
8000a030:	fa042783          	lw	a5,-96(s0)
8000a034:	0007a783          	lw	a5,0(a5)
8000a038:	00178693          	addi	a3,a5,1
8000a03c:	fa042703          	lw	a4,-96(s0)
8000a040:	00d72023          	sw	a3,0(a4)
8000a044:	00078713          	mv	a4,a5
8000a048:	00070793          	mv	a5,a4
8000a04c:	00179793          	slli	a5,a5,0x1
8000a050:	00e787b3          	add	a5,a5,a4
8000a054:	00479793          	slli	a5,a5,0x4
8000a058:	00078713          	mv	a4,a5
8000a05c:	fa442783          	lw	a5,-92(s0)
8000a060:	00e78533          	add	a0,a5,a4
8000a064:	fac42783          	lw	a5,-84(s0)
8000a068:	00378713          	addi	a4,a5,3
8000a06c:	fd042783          	lw	a5,-48(s0)
8000a070:	40f707b3          	sub	a5,a4,a5
8000a074:	fb442683          	lw	a3,-76(s0)
8000a078:	00078613          	mv	a2,a5
8000a07c:	00048593          	mv	a1,s1
8000a080:	80dff0ef          	jal	ra,8000988c <_append_answer>
8000a084:	fd042783          	lw	a5,-48(s0)
8000a088:	00178793          	addi	a5,a5,1
8000a08c:	fcf42823          	sw	a5,-48(s0)
8000a090:	fd042703          	lw	a4,-48(s0)
8000a094:	00300793          	li	a5,3
8000a098:	e4e7d2e3          	bge	a5,a4,80009edc <_prefix_query_all+0x584>
8000a09c:	fcc42783          	lw	a5,-52(s0)
8000a0a0:	0007a703          	lw	a4,0(a5)
8000a0a4:	fc842783          	lw	a5,-56(s0)
8000a0a8:	00100693          	li	a3,1
8000a0ac:	00f697b3          	sll	a5,a3,a5
8000a0b0:	00f777b3          	and	a5,a4,a5
8000a0b4:	20078a63          	beqz	a5,8000a2c8 <_prefix_query_all+0x970>
8000a0b8:	fac42783          	lw	a5,-84(s0)
8000a0bc:	0077f793          	andi	a5,a5,7
8000a0c0:	06079063          	bnez	a5,8000a120 <_prefix_query_all+0x7c8>
8000a0c4:	fac42783          	lw	a5,-84(s0)
8000a0c8:	41f7d713          	srai	a4,a5,0x1f
8000a0cc:	00777713          	andi	a4,a4,7
8000a0d0:	00f707b3          	add	a5,a4,a5
8000a0d4:	4037d793          	srai	a5,a5,0x3
8000a0d8:	00f487b3          	add	a5,s1,a5
8000a0dc:	0007c783          	lbu	a5,0(a5)
8000a0e0:	00f7f793          	andi	a5,a5,15
8000a0e4:	0ff7f693          	andi	a3,a5,255
8000a0e8:	fc842783          	lw	a5,-56(s0)
8000a0ec:	0ff7f793          	andi	a5,a5,255
8000a0f0:	00479793          	slli	a5,a5,0x4
8000a0f4:	0ff7f713          	andi	a4,a5,255
8000a0f8:	fac42783          	lw	a5,-84(s0)
8000a0fc:	41f7d613          	srai	a2,a5,0x1f
8000a100:	00767613          	andi	a2,a2,7
8000a104:	00f607b3          	add	a5,a2,a5
8000a108:	4037d793          	srai	a5,a5,0x3
8000a10c:	00e6e733          	or	a4,a3,a4
8000a110:	0ff77713          	andi	a4,a4,255
8000a114:	00f487b3          	add	a5,s1,a5
8000a118:	00e78023          	sb	a4,0(a5)
8000a11c:	0540006f          	j	8000a170 <_prefix_query_all+0x818>
8000a120:	fac42783          	lw	a5,-84(s0)
8000a124:	41f7d713          	srai	a4,a5,0x1f
8000a128:	00777713          	andi	a4,a4,7
8000a12c:	00f707b3          	add	a5,a4,a5
8000a130:	4037d793          	srai	a5,a5,0x3
8000a134:	00f487b3          	add	a5,s1,a5
8000a138:	0007c783          	lbu	a5,0(a5)
8000a13c:	ff07f793          	andi	a5,a5,-16
8000a140:	0ff7f693          	andi	a3,a5,255
8000a144:	fc842783          	lw	a5,-56(s0)
8000a148:	0ff7f713          	andi	a4,a5,255
8000a14c:	fac42783          	lw	a5,-84(s0)
8000a150:	41f7d613          	srai	a2,a5,0x1f
8000a154:	00767613          	andi	a2,a2,7
8000a158:	00f607b3          	add	a5,a2,a5
8000a15c:	4037d793          	srai	a5,a5,0x3
8000a160:	00e6e733          	or	a4,a3,a4
8000a164:	0ff77713          	andi	a4,a4,255
8000a168:	00f487b3          	add	a5,s1,a5
8000a16c:	00e78023          	sb	a4,0(a5)
8000a170:	fcc42783          	lw	a5,-52(s0)
8000a174:	00a7d783          	lhu	a5,10(a5)
8000a178:	0807f793          	andi	a5,a5,128
8000a17c:	0a078063          	beqz	a5,8000a21c <_prefix_query_all+0x8c4>
8000a180:	fa042783          	lw	a5,-96(s0)
8000a184:	0007a783          	lw	a5,0(a5)
8000a188:	00178693          	addi	a3,a5,1
8000a18c:	fa042703          	lw	a4,-96(s0)
8000a190:	00d72023          	sw	a3,0(a4)
8000a194:	00078713          	mv	a4,a5
8000a198:	00070793          	mv	a5,a4
8000a19c:	00179793          	slli	a5,a5,0x1
8000a1a0:	00e787b3          	add	a5,a5,a4
8000a1a4:	00479793          	slli	a5,a5,0x4
8000a1a8:	00078713          	mv	a4,a5
8000a1ac:	fa442783          	lw	a5,-92(s0)
8000a1b0:	00e78933          	add	s2,a5,a4
8000a1b4:	fac42783          	lw	a5,-84(s0)
8000a1b8:	00478993          	addi	s3,a5,4
8000a1bc:	fcc42783          	lw	a5,-52(s0)
8000a1c0:	0087d783          	lhu	a5,8(a5)
8000a1c4:	00078a13          	mv	s4,a5
8000a1c8:	fcc42783          	lw	a5,-52(s0)
8000a1cc:	0007a703          	lw	a4,0(a5)
8000a1d0:	fc842783          	lw	a5,-56(s0)
8000a1d4:	00200693          	li	a3,2
8000a1d8:	00f697b3          	sll	a5,a3,a5
8000a1dc:	fff78793          	addi	a5,a5,-1
8000a1e0:	00f777b3          	and	a5,a4,a5
8000a1e4:	00078513          	mv	a0,a5
8000a1e8:	869fd0ef          	jal	ra,80007a50 <popcnt>
8000a1ec:	00050793          	mv	a5,a0
8000a1f0:	00fa07b3          	add	a5,s4,a5
8000a1f4:	00279713          	slli	a4,a5,0x2
8000a1f8:	804007b7          	lui	a5,0x80400
8000a1fc:	ffc78793          	addi	a5,a5,-4 # 803ffffc <_bss_end+0x23da0c>
8000a200:	00f707b3          	add	a5,a4,a5
8000a204:	0007a683          	lw	a3,0(a5)
8000a208:	00098613          	mv	a2,s3
8000a20c:	00048593          	mv	a1,s1
8000a210:	00090513          	mv	a0,s2
8000a214:	e78ff0ef          	jal	ra,8000988c <_append_answer>
8000a218:	0b00006f          	j	8000a2c8 <_prefix_query_all+0x970>
8000a21c:	fac42783          	lw	a5,-84(s0)
8000a220:	00478993          	addi	s3,a5,4
8000a224:	fcc42783          	lw	a5,-52(s0)
8000a228:	0087d783          	lhu	a5,8(a5)
8000a22c:	00078a13          	mv	s4,a5
8000a230:	fcc42783          	lw	a5,-52(s0)
8000a234:	0007a703          	lw	a4,0(a5)
8000a238:	fc842783          	lw	a5,-56(s0)
8000a23c:	00200693          	li	a3,2
8000a240:	00f697b3          	sll	a5,a3,a5
8000a244:	fff78793          	addi	a5,a5,-1
8000a248:	00f777b3          	and	a5,a4,a5
8000a24c:	00078513          	mv	a0,a5
8000a250:	801fd0ef          	jal	ra,80007a50 <popcnt>
8000a254:	00050793          	mv	a5,a0
8000a258:	00fa07b3          	add	a5,s4,a5
8000a25c:	fff78593          	addi	a1,a5,-1
8000a260:	00092603          	lw	a2,0(s2)
8000a264:	00492683          	lw	a3,4(s2)
8000a268:	00892703          	lw	a4,8(s2)
8000a26c:	00c92783          	lw	a5,12(s2)
8000a270:	f6c42823          	sw	a2,-144(s0)
8000a274:	f6d42a23          	sw	a3,-140(s0)
8000a278:	f6e42c23          	sw	a4,-136(s0)
8000a27c:	f6f42e23          	sw	a5,-132(s0)
8000a280:	0004a603          	lw	a2,0(s1)
8000a284:	0044a683          	lw	a3,4(s1)
8000a288:	0084a703          	lw	a4,8(s1)
8000a28c:	00c4a783          	lw	a5,12(s1)
8000a290:	f8c42023          	sw	a2,-128(s0)
8000a294:	f8d42223          	sw	a3,-124(s0)
8000a298:	f8e42423          	sw	a4,-120(s0)
8000a29c:	f8f42623          	sw	a5,-116(s0)
8000a2a0:	f8040713          	addi	a4,s0,-128
8000a2a4:	f9f44783          	lbu	a5,-97(s0)
8000a2a8:	f7040613          	addi	a2,s0,-144
8000a2ac:	00070813          	mv	a6,a4
8000a2b0:	fa042703          	lw	a4,-96(s0)
8000a2b4:	fa442683          	lw	a3,-92(s0)
8000a2b8:	00098513          	mv	a0,s3
8000a2bc:	e9cff0ef          	jal	ra,80009958 <_prefix_query_all>
8000a2c0:	0080006f          	j	8000a2c8 <_prefix_query_all+0x970>
8000a2c4:	00000013          	nop
8000a2c8:	08c12083          	lw	ra,140(sp)
8000a2cc:	08812403          	lw	s0,136(sp)
8000a2d0:	08412483          	lw	s1,132(sp)
8000a2d4:	08012903          	lw	s2,128(sp)
8000a2d8:	07c12983          	lw	s3,124(sp)
8000a2dc:	07812a03          	lw	s4,120(sp)
8000a2e0:	07412a83          	lw	s5,116(sp)
8000a2e4:	09010113          	addi	sp,sp,144
8000a2e8:	00008067          	ret

8000a2ec <test>:
8000a2ec:	ff010113          	addi	sp,sp,-16
8000a2f0:	00112623          	sw	ra,12(sp)
8000a2f4:	00812423          	sw	s0,8(sp)
8000a2f8:	01010413          	addi	s0,sp,16
8000a2fc:	400007b7          	lui	a5,0x40000
8000a300:	01078713          	addi	a4,a5,16 # 40000010 <_reset_vector-0x3ffffff0>
8000a304:	400007b7          	lui	a5,0x40000
8000a308:	02078793          	addi	a5,a5,32 # 40000020 <_reset_vector-0x3fffffe0>
8000a30c:	00072583          	lw	a1,0(a4)
8000a310:	00472603          	lw	a2,4(a4)
8000a314:	00872683          	lw	a3,8(a4)
8000a318:	00c72703          	lw	a4,12(a4)
8000a31c:	00b7a023          	sw	a1,0(a5)
8000a320:	00c7a223          	sw	a2,4(a5)
8000a324:	00d7a423          	sw	a3,8(a5)
8000a328:	00e7a623          	sw	a4,12(a5)
8000a32c:	400007b7          	lui	a5,0x40000
8000a330:	02078793          	addi	a5,a5,32 # 40000020 <_reset_vector-0x3fffffe0>
8000a334:	0087d783          	lhu	a5,8(a5)
8000a338:	00078713          	mv	a4,a5
8000a33c:	400007b7          	lui	a5,0x40000
8000a340:	02078793          	addi	a5,a5,32 # 40000020 <_reset_vector-0x3fffffe0>
8000a344:	00a7d783          	lhu	a5,10(a5)
8000a348:	00078613          	mv	a2,a5
8000a34c:	00070593          	mv	a1,a4
8000a350:	8000c7b7          	lui	a5,0x8000c
8000a354:	e9078513          	addi	a0,a5,-368 # 8000be90 <_bss_end+0xffe498a0>
8000a358:	dc5f70ef          	jal	ra,8000211c <printf_>
8000a35c:	400007b7          	lui	a5,0x40000
8000a360:	02078793          	addi	a5,a5,32 # 40000020 <_reset_vector-0x3fffffe0>
8000a364:	00a7d703          	lhu	a4,10(a5)
8000a368:	400007b7          	lui	a5,0x40000
8000a36c:	02078793          	addi	a5,a5,32 # 40000020 <_reset_vector-0x3fffffe0>
8000a370:	08076713          	ori	a4,a4,128
8000a374:	01071713          	slli	a4,a4,0x10
8000a378:	01075713          	srli	a4,a4,0x10
8000a37c:	00e79523          	sh	a4,10(a5)
8000a380:	400007b7          	lui	a5,0x40000
8000a384:	02078793          	addi	a5,a5,32 # 40000020 <_reset_vector-0x3fffffe0>
8000a388:	0087d703          	lhu	a4,8(a5)
8000a38c:	400007b7          	lui	a5,0x40000
8000a390:	02078793          	addi	a5,a5,32 # 40000020 <_reset_vector-0x3fffffe0>
8000a394:	02076713          	ori	a4,a4,32
8000a398:	01071713          	slli	a4,a4,0x10
8000a39c:	01075713          	srli	a4,a4,0x10
8000a3a0:	00e79423          	sh	a4,8(a5)
8000a3a4:	400007b7          	lui	a5,0x40000
8000a3a8:	02078793          	addi	a5,a5,32 # 40000020 <_reset_vector-0x3fffffe0>
8000a3ac:	0087d783          	lhu	a5,8(a5)
8000a3b0:	00078713          	mv	a4,a5
8000a3b4:	400007b7          	lui	a5,0x40000
8000a3b8:	02078793          	addi	a5,a5,32 # 40000020 <_reset_vector-0x3fffffe0>
8000a3bc:	00a7d783          	lhu	a5,10(a5)
8000a3c0:	00078613          	mv	a2,a5
8000a3c4:	00070593          	mv	a1,a4
8000a3c8:	8000c7b7          	lui	a5,0x8000c
8000a3cc:	e9c78513          	addi	a0,a5,-356 # 8000be9c <_bss_end+0xffe498ac>
8000a3d0:	d4df70ef          	jal	ra,8000211c <printf_>
8000a3d4:	400007b7          	lui	a5,0x40000
8000a3d8:	02078793          	addi	a5,a5,32 # 40000020 <_reset_vector-0x3fffffe0>
8000a3dc:	00a7d703          	lhu	a4,10(a5)
8000a3e0:	400007b7          	lui	a5,0x40000
8000a3e4:	02078793          	addi	a5,a5,32 # 40000020 <_reset_vector-0x3fffffe0>
8000a3e8:	f7f77713          	andi	a4,a4,-129
8000a3ec:	01071713          	slli	a4,a4,0x10
8000a3f0:	01075713          	srli	a4,a4,0x10
8000a3f4:	00e79523          	sh	a4,10(a5)
8000a3f8:	00100593          	li	a1,1
8000a3fc:	00000513          	li	a0,0
8000a400:	628000ef          	jal	ra,8000aa28 <node_malloc>
8000a404:	00050713          	mv	a4,a0
8000a408:	400007b7          	lui	a5,0x40000
8000a40c:	02078793          	addi	a5,a5,32 # 40000020 <_reset_vector-0x3fffffe0>
8000a410:	01071713          	slli	a4,a4,0x10
8000a414:	01075713          	srli	a4,a4,0x10
8000a418:	00e79423          	sh	a4,8(a5)
8000a41c:	400007b7          	lui	a5,0x40000
8000a420:	02078793          	addi	a5,a5,32 # 40000020 <_reset_vector-0x3fffffe0>
8000a424:	0087d783          	lhu	a5,8(a5)
8000a428:	00078713          	mv	a4,a5
8000a42c:	400007b7          	lui	a5,0x40000
8000a430:	02078793          	addi	a5,a5,32 # 40000020 <_reset_vector-0x3fffffe0>
8000a434:	00a7d783          	lhu	a5,10(a5)
8000a438:	00078613          	mv	a2,a5
8000a43c:	00070593          	mv	a1,a4
8000a440:	8000c7b7          	lui	a5,0x8000c
8000a444:	ea878513          	addi	a0,a5,-344 # 8000bea8 <_bss_end+0xffe498b8>
8000a448:	cd5f70ef          	jal	ra,8000211c <printf_>
8000a44c:	400007b7          	lui	a5,0x40000
8000a450:	02078793          	addi	a5,a5,32 # 40000020 <_reset_vector-0x3fffffe0>
8000a454:	00079523          	sh	zero,10(a5)
8000a458:	400007b7          	lui	a5,0x40000
8000a45c:	02078793          	addi	a5,a5,32 # 40000020 <_reset_vector-0x3fffffe0>
8000a460:	00079423          	sh	zero,8(a5)
8000a464:	00000013          	nop
8000a468:	00c12083          	lw	ra,12(sp)
8000a46c:	00812403          	lw	s0,8(sp)
8000a470:	01010113          	addi	sp,sp,16
8000a474:	00008067          	ret

8000a478 <lookup_init>:
8000a478:	ff010113          	addi	sp,sp,-16
8000a47c:	00112623          	sw	ra,12(sp)
8000a480:	00812423          	sw	s0,8(sp)
8000a484:	01010413          	addi	s0,sp,16
8000a488:	2c4000ef          	jal	ra,8000a74c <memhelper_init>
8000a48c:	000105b7          	lui	a1,0x10
8000a490:	05f5e7b7          	lui	a5,0x5f5e
8000a494:	10078513          	addi	a0,a5,256 # 5f5e100 <_reset_vector-0x7a0a1f00>
8000a498:	bd0fc0ef          	jal	ra,80006868 <timer_init>
8000a49c:	00050713          	mv	a4,a0
8000a4a0:	801c27b7          	lui	a5,0x801c2
8000a4a4:	5ee7a023          	sw	a4,1504(a5) # 801c25e0 <_bss_end+0xfffffff0>
8000a4a8:	801c27b7          	lui	a5,0x801c2
8000a4ac:	5e07a703          	lw	a4,1504(a5) # 801c25e0 <_bss_end+0xfffffff0>
8000a4b0:	800097b7          	lui	a5,0x80009
8000a4b4:	0d878593          	addi	a1,a5,216 # 800090d8 <_bss_end+0xffe46ae8>
8000a4b8:	00070513          	mv	a0,a4
8000a4bc:	cb4fc0ef          	jal	ra,80006970 <timer_set_timeout>
8000a4c0:	00000013          	nop
8000a4c4:	00c12083          	lw	ra,12(sp)
8000a4c8:	00812403          	lw	s0,8(sp)
8000a4cc:	01010113          	addi	sp,sp,16
8000a4d0:	00008067          	ret

8000a4d4 <_blk_push>:
8000a4d4:	fe010113          	addi	sp,sp,-32
8000a4d8:	00112e23          	sw	ra,28(sp)
8000a4dc:	00812c23          	sw	s0,24(sp)
8000a4e0:	02010413          	addi	s0,sp,32
8000a4e4:	fea42623          	sw	a0,-20(s0)
8000a4e8:	feb42423          	sw	a1,-24(s0)
8000a4ec:	fec42223          	sw	a2,-28(s0)
8000a4f0:	801c27b7          	lui	a5,0x801c2
8000a4f4:	0f078693          	addi	a3,a5,240 # 801c20f0 <_bss_end+0xfffffb00>
8000a4f8:	fec42703          	lw	a4,-20(s0)
8000a4fc:	00070793          	mv	a5,a4
8000a500:	00479793          	slli	a5,a5,0x4
8000a504:	00e787b3          	add	a5,a5,a4
8000a508:	fe842703          	lw	a4,-24(s0)
8000a50c:	00e787b3          	add	a5,a5,a4
8000a510:	00279793          	slli	a5,a5,0x2
8000a514:	00f687b3          	add	a5,a3,a5
8000a518:	0007a683          	lw	a3,0(a5)
8000a51c:	fec42703          	lw	a4,-20(s0)
8000a520:	00700793          	li	a5,7
8000a524:	02e7ca63          	blt	a5,a4,8000a558 <_blk_push+0x84>
8000a528:	8000c7b7          	lui	a5,0x8000c
8000a52c:	fc478613          	addi	a2,a5,-60 # 8000bfc4 <_bss_end+0xffe499d4>
8000a530:	fec42703          	lw	a4,-20(s0)
8000a534:	00070793          	mv	a5,a4
8000a538:	00479793          	slli	a5,a5,0x4
8000a53c:	00e787b3          	add	a5,a5,a4
8000a540:	fe842703          	lw	a4,-24(s0)
8000a544:	00e787b3          	add	a5,a5,a4
8000a548:	00279793          	slli	a5,a5,0x2
8000a54c:	00f607b3          	add	a5,a2,a5
8000a550:	0007a783          	lw	a5,0(a5)
8000a554:	01c0006f          	j	8000a570 <_blk_push+0x9c>
8000a558:	8000c7b7          	lui	a5,0x8000c
8000a55c:	1e478713          	addi	a4,a5,484 # 8000c1e4 <_bss_end+0xffe49bf4>
8000a560:	fe842783          	lw	a5,-24(s0)
8000a564:	00279793          	slli	a5,a5,0x2
8000a568:	00f707b3          	add	a5,a4,a5
8000a56c:	0007a783          	lw	a5,0(a5)
8000a570:	00f6a7b3          	slt	a5,a3,a5
8000a574:	0ff7f793          	andi	a5,a5,255
8000a578:	00078513          	mv	a0,a5
8000a57c:	851f60ef          	jal	ra,80000dcc <assert>
8000a580:	801c27b7          	lui	a5,0x801c2
8000a584:	e8c78693          	addi	a3,a5,-372 # 801c1e8c <_bss_end+0xfffff89c>
8000a588:	fec42703          	lw	a4,-20(s0)
8000a58c:	00070793          	mv	a5,a4
8000a590:	00479793          	slli	a5,a5,0x4
8000a594:	00e787b3          	add	a5,a5,a4
8000a598:	fe842703          	lw	a4,-24(s0)
8000a59c:	00e787b3          	add	a5,a5,a4
8000a5a0:	00279793          	slli	a5,a5,0x2
8000a5a4:	00f687b3          	add	a5,a3,a5
8000a5a8:	0007a603          	lw	a2,0(a5)
8000a5ac:	801c27b7          	lui	a5,0x801c2
8000a5b0:	0f078693          	addi	a3,a5,240 # 801c20f0 <_bss_end+0xfffffb00>
8000a5b4:	fec42703          	lw	a4,-20(s0)
8000a5b8:	00070793          	mv	a5,a4
8000a5bc:	00479793          	slli	a5,a5,0x4
8000a5c0:	00e787b3          	add	a5,a5,a4
8000a5c4:	fe842703          	lw	a4,-24(s0)
8000a5c8:	00e787b3          	add	a5,a5,a4
8000a5cc:	00279793          	slli	a5,a5,0x2
8000a5d0:	00f687b3          	add	a5,a3,a5
8000a5d4:	0007a703          	lw	a4,0(a5)
8000a5d8:	00170593          	addi	a1,a4,1
8000a5dc:	801c27b7          	lui	a5,0x801c2
8000a5e0:	0f078513          	addi	a0,a5,240 # 801c20f0 <_bss_end+0xfffffb00>
8000a5e4:	fec42683          	lw	a3,-20(s0)
8000a5e8:	00068793          	mv	a5,a3
8000a5ec:	00479793          	slli	a5,a5,0x4
8000a5f0:	00d787b3          	add	a5,a5,a3
8000a5f4:	fe842683          	lw	a3,-24(s0)
8000a5f8:	00d787b3          	add	a5,a5,a3
8000a5fc:	00279793          	slli	a5,a5,0x2
8000a600:	00f507b3          	add	a5,a0,a5
8000a604:	00b7a023          	sw	a1,0(a5)
8000a608:	00070793          	mv	a5,a4
8000a60c:	00279793          	slli	a5,a5,0x2
8000a610:	00f607b3          	add	a5,a2,a5
8000a614:	fe442703          	lw	a4,-28(s0)
8000a618:	00e7a023          	sw	a4,0(a5)
8000a61c:	00000013          	nop
8000a620:	01c12083          	lw	ra,28(sp)
8000a624:	01812403          	lw	s0,24(sp)
8000a628:	02010113          	addi	sp,sp,32
8000a62c:	00008067          	ret

8000a630 <_blk_pop>:
8000a630:	fe010113          	addi	sp,sp,-32
8000a634:	00812e23          	sw	s0,28(sp)
8000a638:	02010413          	addi	s0,sp,32
8000a63c:	fea42623          	sw	a0,-20(s0)
8000a640:	feb42423          	sw	a1,-24(s0)
8000a644:	801c27b7          	lui	a5,0x801c2
8000a648:	0f078693          	addi	a3,a5,240 # 801c20f0 <_bss_end+0xfffffb00>
8000a64c:	fec42703          	lw	a4,-20(s0)
8000a650:	00070793          	mv	a5,a4
8000a654:	00479793          	slli	a5,a5,0x4
8000a658:	00e787b3          	add	a5,a5,a4
8000a65c:	fe842703          	lw	a4,-24(s0)
8000a660:	00e787b3          	add	a5,a5,a4
8000a664:	00279793          	slli	a5,a5,0x2
8000a668:	00f687b3          	add	a5,a3,a5
8000a66c:	0007a783          	lw	a5,0(a5)
8000a670:	00f04663          	bgtz	a5,8000a67c <_blk_pop+0x4c>
8000a674:	fff00793          	li	a5,-1
8000a678:	0c40006f          	j	8000a73c <_blk_pop+0x10c>
8000a67c:	801c27b7          	lui	a5,0x801c2
8000a680:	e8c78693          	addi	a3,a5,-372 # 801c1e8c <_bss_end+0xfffff89c>
8000a684:	fec42703          	lw	a4,-20(s0)
8000a688:	00070793          	mv	a5,a4
8000a68c:	00479793          	slli	a5,a5,0x4
8000a690:	00e787b3          	add	a5,a5,a4
8000a694:	fe842703          	lw	a4,-24(s0)
8000a698:	00e787b3          	add	a5,a5,a4
8000a69c:	00279793          	slli	a5,a5,0x2
8000a6a0:	00f687b3          	add	a5,a3,a5
8000a6a4:	0007a683          	lw	a3,0(a5)
8000a6a8:	801c27b7          	lui	a5,0x801c2
8000a6ac:	0f078613          	addi	a2,a5,240 # 801c20f0 <_bss_end+0xfffffb00>
8000a6b0:	fec42703          	lw	a4,-20(s0)
8000a6b4:	00070793          	mv	a5,a4
8000a6b8:	00479793          	slli	a5,a5,0x4
8000a6bc:	00e787b3          	add	a5,a5,a4
8000a6c0:	fe842703          	lw	a4,-24(s0)
8000a6c4:	00e787b3          	add	a5,a5,a4
8000a6c8:	00279793          	slli	a5,a5,0x2
8000a6cc:	00f607b3          	add	a5,a2,a5
8000a6d0:	0007a783          	lw	a5,0(a5)
8000a6d4:	fff78613          	addi	a2,a5,-1
8000a6d8:	801c27b7          	lui	a5,0x801c2
8000a6dc:	0f078593          	addi	a1,a5,240 # 801c20f0 <_bss_end+0xfffffb00>
8000a6e0:	fec42703          	lw	a4,-20(s0)
8000a6e4:	00070793          	mv	a5,a4
8000a6e8:	00479793          	slli	a5,a5,0x4
8000a6ec:	00e787b3          	add	a5,a5,a4
8000a6f0:	fe842703          	lw	a4,-24(s0)
8000a6f4:	00e787b3          	add	a5,a5,a4
8000a6f8:	00279793          	slli	a5,a5,0x2
8000a6fc:	00f587b3          	add	a5,a1,a5
8000a700:	00c7a023          	sw	a2,0(a5)
8000a704:	801c27b7          	lui	a5,0x801c2
8000a708:	0f078613          	addi	a2,a5,240 # 801c20f0 <_bss_end+0xfffffb00>
8000a70c:	fec42703          	lw	a4,-20(s0)
8000a710:	00070793          	mv	a5,a4
8000a714:	00479793          	slli	a5,a5,0x4
8000a718:	00e787b3          	add	a5,a5,a4
8000a71c:	fe842703          	lw	a4,-24(s0)
8000a720:	00e787b3          	add	a5,a5,a4
8000a724:	00279793          	slli	a5,a5,0x2
8000a728:	00f607b3          	add	a5,a2,a5
8000a72c:	0007a783          	lw	a5,0(a5)
8000a730:	00279793          	slli	a5,a5,0x2
8000a734:	00f687b3          	add	a5,a3,a5
8000a738:	0007a783          	lw	a5,0(a5)
8000a73c:	00078513          	mv	a0,a5
8000a740:	01c12403          	lw	s0,28(sp)
8000a744:	02010113          	addi	sp,sp,32
8000a748:	00008067          	ret

8000a74c <memhelper_init>:
8000a74c:	fd010113          	addi	sp,sp,-48
8000a750:	02112623          	sw	ra,44(sp)
8000a754:	02812423          	sw	s0,40(sp)
8000a758:	03010413          	addi	s0,sp,48
8000a75c:	fe042623          	sw	zero,-20(s0)
8000a760:	fe042423          	sw	zero,-24(s0)
8000a764:	fe042223          	sw	zero,-28(s0)
8000a768:	1840006f          	j	8000a8ec <memhelper_init+0x1a0>
8000a76c:	fe042423          	sw	zero,-24(s0)
8000a770:	00100793          	li	a5,1
8000a774:	fef42023          	sw	a5,-32(s0)
8000a778:	15c0006f          	j	8000a8d4 <memhelper_init+0x188>
8000a77c:	fec42783          	lw	a5,-20(s0)
8000a780:	00279713          	slli	a4,a5,0x2
8000a784:	8018e7b7          	lui	a5,0x8018e
8000a788:	df478793          	addi	a5,a5,-524 # 8018ddf4 <_bss_end+0xfffcb804>
8000a78c:	00f706b3          	add	a3,a4,a5
8000a790:	801c27b7          	lui	a5,0x801c2
8000a794:	e8c78613          	addi	a2,a5,-372 # 801c1e8c <_bss_end+0xfffff89c>
8000a798:	fe442703          	lw	a4,-28(s0)
8000a79c:	00070793          	mv	a5,a4
8000a7a0:	00479793          	slli	a5,a5,0x4
8000a7a4:	00e787b3          	add	a5,a5,a4
8000a7a8:	fe042703          	lw	a4,-32(s0)
8000a7ac:	00e787b3          	add	a5,a5,a4
8000a7b0:	00279793          	slli	a5,a5,0x2
8000a7b4:	00f607b3          	add	a5,a2,a5
8000a7b8:	00d7a023          	sw	a3,0(a5)
8000a7bc:	fc042e23          	sw	zero,-36(s0)
8000a7c0:	0200006f          	j	8000a7e0 <memhelper_init+0x94>
8000a7c4:	fdc42603          	lw	a2,-36(s0)
8000a7c8:	fe042583          	lw	a1,-32(s0)
8000a7cc:	fe442503          	lw	a0,-28(s0)
8000a7d0:	d05ff0ef          	jal	ra,8000a4d4 <_blk_push>
8000a7d4:	fdc42783          	lw	a5,-36(s0)
8000a7d8:	00178793          	addi	a5,a5,1
8000a7dc:	fcf42e23          	sw	a5,-36(s0)
8000a7e0:	8000c7b7          	lui	a5,0x8000c
8000a7e4:	fc478693          	addi	a3,a5,-60 # 8000bfc4 <_bss_end+0xffe499d4>
8000a7e8:	fe442703          	lw	a4,-28(s0)
8000a7ec:	00070793          	mv	a5,a4
8000a7f0:	00479793          	slli	a5,a5,0x4
8000a7f4:	00e787b3          	add	a5,a5,a4
8000a7f8:	fe042703          	lw	a4,-32(s0)
8000a7fc:	00e787b3          	add	a5,a5,a4
8000a800:	00279793          	slli	a5,a5,0x2
8000a804:	00f687b3          	add	a5,a3,a5
8000a808:	0007a783          	lw	a5,0(a5)
8000a80c:	fdc42703          	lw	a4,-36(s0)
8000a810:	faf74ae3          	blt	a4,a5,8000a7c4 <memhelper_init+0x78>
8000a814:	8000c7b7          	lui	a5,0x8000c
8000a818:	fc478693          	addi	a3,a5,-60 # 8000bfc4 <_bss_end+0xffe499d4>
8000a81c:	fe442703          	lw	a4,-28(s0)
8000a820:	00070793          	mv	a5,a4
8000a824:	00479793          	slli	a5,a5,0x4
8000a828:	00e787b3          	add	a5,a5,a4
8000a82c:	fe042703          	lw	a4,-32(s0)
8000a830:	00e787b3          	add	a5,a5,a4
8000a834:	00279793          	slli	a5,a5,0x2
8000a838:	00f687b3          	add	a5,a3,a5
8000a83c:	0007a783          	lw	a5,0(a5)
8000a840:	fec42703          	lw	a4,-20(s0)
8000a844:	00f707b3          	add	a5,a4,a5
8000a848:	fef42623          	sw	a5,-20(s0)
8000a84c:	801c27b7          	lui	a5,0x801c2
8000a850:	35478693          	addi	a3,a5,852 # 801c2354 <_bss_end+0xfffffd64>
8000a854:	fe442703          	lw	a4,-28(s0)
8000a858:	00070793          	mv	a5,a4
8000a85c:	00479793          	slli	a5,a5,0x4
8000a860:	00e787b3          	add	a5,a5,a4
8000a864:	fe042703          	lw	a4,-32(s0)
8000a868:	00e787b3          	add	a5,a5,a4
8000a86c:	00279793          	slli	a5,a5,0x2
8000a870:	00f687b3          	add	a5,a3,a5
8000a874:	fe842703          	lw	a4,-24(s0)
8000a878:	00e7a023          	sw	a4,0(a5)
8000a87c:	8000c7b7          	lui	a5,0x8000c
8000a880:	fc478693          	addi	a3,a5,-60 # 8000bfc4 <_bss_end+0xffe499d4>
8000a884:	fe442703          	lw	a4,-28(s0)
8000a888:	00070793          	mv	a5,a4
8000a88c:	00479793          	slli	a5,a5,0x4
8000a890:	00e787b3          	add	a5,a5,a4
8000a894:	fe042703          	lw	a4,-32(s0)
8000a898:	00e787b3          	add	a5,a5,a4
8000a89c:	00279793          	slli	a5,a5,0x2
8000a8a0:	00f687b3          	add	a5,a3,a5
8000a8a4:	0007a783          	lw	a5,0(a5)
8000a8a8:	fe042583          	lw	a1,-32(s0)
8000a8ac:	00078513          	mv	a0,a5
8000a8b0:	3ed000ef          	jal	ra,8000b49c <__mulsi3>
8000a8b4:	00050793          	mv	a5,a0
8000a8b8:	00078713          	mv	a4,a5
8000a8bc:	fe842783          	lw	a5,-24(s0)
8000a8c0:	00e787b3          	add	a5,a5,a4
8000a8c4:	fef42423          	sw	a5,-24(s0)
8000a8c8:	fe042783          	lw	a5,-32(s0)
8000a8cc:	00178793          	addi	a5,a5,1
8000a8d0:	fef42023          	sw	a5,-32(s0)
8000a8d4:	fe042703          	lw	a4,-32(s0)
8000a8d8:	01000793          	li	a5,16
8000a8dc:	eae7d0e3          	bge	a5,a4,8000a77c <memhelper_init+0x30>
8000a8e0:	fe442783          	lw	a5,-28(s0)
8000a8e4:	00178793          	addi	a5,a5,1
8000a8e8:	fef42223          	sw	a5,-28(s0)
8000a8ec:	fe442703          	lw	a4,-28(s0)
8000a8f0:	00700793          	li	a5,7
8000a8f4:	e6e7dce3          	bge	a5,a4,8000a76c <memhelper_init+0x20>
8000a8f8:	fe042423          	sw	zero,-24(s0)
8000a8fc:	00100793          	li	a5,1
8000a900:	fcf42c23          	sw	a5,-40(s0)
8000a904:	1000006f          	j	8000aa04 <memhelper_init+0x2b8>
8000a908:	fec42783          	lw	a5,-20(s0)
8000a90c:	00279713          	slli	a4,a5,0x2
8000a910:	8018e7b7          	lui	a5,0x8018e
8000a914:	df478793          	addi	a5,a5,-524 # 8018ddf4 <_bss_end+0xfffcb804>
8000a918:	00f70733          	add	a4,a4,a5
8000a91c:	801c27b7          	lui	a5,0x801c2
8000a920:	e8c78693          	addi	a3,a5,-372 # 801c1e8c <_bss_end+0xfffff89c>
8000a924:	fd842783          	lw	a5,-40(s0)
8000a928:	08878793          	addi	a5,a5,136
8000a92c:	00279793          	slli	a5,a5,0x2
8000a930:	00f687b3          	add	a5,a3,a5
8000a934:	00e7a023          	sw	a4,0(a5)
8000a938:	8000c7b7          	lui	a5,0x8000c
8000a93c:	1e478713          	addi	a4,a5,484 # 8000c1e4 <_bss_end+0xffe49bf4>
8000a940:	fd842783          	lw	a5,-40(s0)
8000a944:	00279793          	slli	a5,a5,0x2
8000a948:	00f707b3          	add	a5,a4,a5
8000a94c:	0007a783          	lw	a5,0(a5)
8000a950:	fec42703          	lw	a4,-20(s0)
8000a954:	00f707b3          	add	a5,a4,a5
8000a958:	fef42623          	sw	a5,-20(s0)
8000a95c:	fc042a23          	sw	zero,-44(s0)
8000a960:	0200006f          	j	8000a980 <memhelper_init+0x234>
8000a964:	fd442603          	lw	a2,-44(s0)
8000a968:	fd842583          	lw	a1,-40(s0)
8000a96c:	00800513          	li	a0,8
8000a970:	b65ff0ef          	jal	ra,8000a4d4 <_blk_push>
8000a974:	fd442783          	lw	a5,-44(s0)
8000a978:	00178793          	addi	a5,a5,1
8000a97c:	fcf42a23          	sw	a5,-44(s0)
8000a980:	8000c7b7          	lui	a5,0x8000c
8000a984:	1e478713          	addi	a4,a5,484 # 8000c1e4 <_bss_end+0xffe49bf4>
8000a988:	fd842783          	lw	a5,-40(s0)
8000a98c:	00279793          	slli	a5,a5,0x2
8000a990:	00f707b3          	add	a5,a4,a5
8000a994:	0007a783          	lw	a5,0(a5)
8000a998:	fd442703          	lw	a4,-44(s0)
8000a99c:	fcf744e3          	blt	a4,a5,8000a964 <memhelper_init+0x218>
8000a9a0:	801c27b7          	lui	a5,0x801c2
8000a9a4:	35478713          	addi	a4,a5,852 # 801c2354 <_bss_end+0xfffffd64>
8000a9a8:	fd842783          	lw	a5,-40(s0)
8000a9ac:	08878793          	addi	a5,a5,136
8000a9b0:	00279793          	slli	a5,a5,0x2
8000a9b4:	00f707b3          	add	a5,a4,a5
8000a9b8:	fe842703          	lw	a4,-24(s0)
8000a9bc:	00e7a023          	sw	a4,0(a5)
8000a9c0:	8000c7b7          	lui	a5,0x8000c
8000a9c4:	1e478713          	addi	a4,a5,484 # 8000c1e4 <_bss_end+0xffe49bf4>
8000a9c8:	fd842783          	lw	a5,-40(s0)
8000a9cc:	00279793          	slli	a5,a5,0x2
8000a9d0:	00f707b3          	add	a5,a4,a5
8000a9d4:	0007a783          	lw	a5,0(a5)
8000a9d8:	fd842583          	lw	a1,-40(s0)
8000a9dc:	00078513          	mv	a0,a5
8000a9e0:	2bd000ef          	jal	ra,8000b49c <__mulsi3>
8000a9e4:	00050793          	mv	a5,a0
8000a9e8:	00078713          	mv	a4,a5
8000a9ec:	fe842783          	lw	a5,-24(s0)
8000a9f0:	00e787b3          	add	a5,a5,a4
8000a9f4:	fef42423          	sw	a5,-24(s0)
8000a9f8:	fd842783          	lw	a5,-40(s0)
8000a9fc:	00178793          	addi	a5,a5,1
8000aa00:	fcf42c23          	sw	a5,-40(s0)
8000aa04:	fd842703          	lw	a4,-40(s0)
8000aa08:	01000793          	li	a5,16
8000aa0c:	eee7dee3          	bge	a5,a4,8000a908 <memhelper_init+0x1bc>
8000aa10:	00000013          	nop
8000aa14:	00000013          	nop
8000aa18:	02c12083          	lw	ra,44(sp)
8000aa1c:	02812403          	lw	s0,40(sp)
8000aa20:	03010113          	addi	sp,sp,48
8000aa24:	00008067          	ret

8000aa28 <node_malloc>:
8000aa28:	fd010113          	addi	sp,sp,-48
8000aa2c:	02112623          	sw	ra,44(sp)
8000aa30:	02812423          	sw	s0,40(sp)
8000aa34:	02912223          	sw	s1,36(sp)
8000aa38:	03010413          	addi	s0,sp,48
8000aa3c:	fca42e23          	sw	a0,-36(s0)
8000aa40:	fcb42c23          	sw	a1,-40(s0)
8000aa44:	fd842583          	lw	a1,-40(s0)
8000aa48:	fdc42503          	lw	a0,-36(s0)
8000aa4c:	be5ff0ef          	jal	ra,8000a630 <_blk_pop>
8000aa50:	fea42623          	sw	a0,-20(s0)
8000aa54:	0340006f          	j	8000aa88 <node_malloc+0x60>
8000aa58:	fd842783          	lw	a5,-40(s0)
8000aa5c:	0107a793          	slti	a5,a5,16
8000aa60:	0ff7f793          	andi	a5,a5,255
8000aa64:	00078513          	mv	a0,a5
8000aa68:	b64f60ef          	jal	ra,80000dcc <assert>
8000aa6c:	fd842783          	lw	a5,-40(s0)
8000aa70:	00178793          	addi	a5,a5,1
8000aa74:	fcf42c23          	sw	a5,-40(s0)
8000aa78:	fd842583          	lw	a1,-40(s0)
8000aa7c:	fdc42503          	lw	a0,-36(s0)
8000aa80:	bb1ff0ef          	jal	ra,8000a630 <_blk_pop>
8000aa84:	fea42623          	sw	a0,-20(s0)
8000aa88:	fec42703          	lw	a4,-20(s0)
8000aa8c:	fff00793          	li	a5,-1
8000aa90:	fcf704e3          	beq	a4,a5,8000aa58 <node_malloc+0x30>
8000aa94:	801c27b7          	lui	a5,0x801c2
8000aa98:	35478693          	addi	a3,a5,852 # 801c2354 <_bss_end+0xfffffd64>
8000aa9c:	fdc42703          	lw	a4,-36(s0)
8000aaa0:	00070793          	mv	a5,a4
8000aaa4:	00479793          	slli	a5,a5,0x4
8000aaa8:	00e787b3          	add	a5,a5,a4
8000aaac:	fd842703          	lw	a4,-40(s0)
8000aab0:	00e787b3          	add	a5,a5,a4
8000aab4:	00279793          	slli	a5,a5,0x2
8000aab8:	00f687b3          	add	a5,a3,a5
8000aabc:	0007a483          	lw	s1,0(a5)
8000aac0:	fd842583          	lw	a1,-40(s0)
8000aac4:	fec42503          	lw	a0,-20(s0)
8000aac8:	1d5000ef          	jal	ra,8000b49c <__mulsi3>
8000aacc:	00050793          	mv	a5,a0
8000aad0:	00f48733          	add	a4,s1,a5
8000aad4:	fd842783          	lw	a5,-40(s0)
8000aad8:	00f706b3          	add	a3,a4,a5
8000aadc:	8000c7b7          	lui	a5,0x8000c
8000aae0:	fc478613          	addi	a2,a5,-60 # 8000bfc4 <_bss_end+0xffe499d4>
8000aae4:	fdc42703          	lw	a4,-36(s0)
8000aae8:	00070793          	mv	a5,a4
8000aaec:	00479793          	slli	a5,a5,0x4
8000aaf0:	00e787b3          	add	a5,a5,a4
8000aaf4:	00279793          	slli	a5,a5,0x2
8000aaf8:	00f607b3          	add	a5,a2,a5
8000aafc:	0007a783          	lw	a5,0(a5)
8000ab00:	00d7a7b3          	slt	a5,a5,a3
8000ab04:	0017c793          	xori	a5,a5,1
8000ab08:	0ff7f793          	andi	a5,a5,255
8000ab0c:	00078513          	mv	a0,a5
8000ab10:	abcf60ef          	jal	ra,80000dcc <assert>
8000ab14:	801c27b7          	lui	a5,0x801c2
8000ab18:	35478693          	addi	a3,a5,852 # 801c2354 <_bss_end+0xfffffd64>
8000ab1c:	fdc42703          	lw	a4,-36(s0)
8000ab20:	00070793          	mv	a5,a4
8000ab24:	00479793          	slli	a5,a5,0x4
8000ab28:	00e787b3          	add	a5,a5,a4
8000ab2c:	fd842703          	lw	a4,-40(s0)
8000ab30:	00e787b3          	add	a5,a5,a4
8000ab34:	00279793          	slli	a5,a5,0x2
8000ab38:	00f687b3          	add	a5,a3,a5
8000ab3c:	0007a483          	lw	s1,0(a5)
8000ab40:	fd842583          	lw	a1,-40(s0)
8000ab44:	fec42503          	lw	a0,-20(s0)
8000ab48:	155000ef          	jal	ra,8000b49c <__mulsi3>
8000ab4c:	00050793          	mv	a5,a0
8000ab50:	00f487b3          	add	a5,s1,a5
8000ab54:	00078513          	mv	a0,a5
8000ab58:	02c12083          	lw	ra,44(sp)
8000ab5c:	02812403          	lw	s0,40(sp)
8000ab60:	02412483          	lw	s1,36(sp)
8000ab64:	03010113          	addi	sp,sp,48
8000ab68:	00008067          	ret

8000ab6c <node_free>:
8000ab6c:	fd010113          	addi	sp,sp,-48
8000ab70:	02112623          	sw	ra,44(sp)
8000ab74:	02812423          	sw	s0,40(sp)
8000ab78:	03010413          	addi	s0,sp,48
8000ab7c:	fca42e23          	sw	a0,-36(s0)
8000ab80:	fcb42c23          	sw	a1,-40(s0)
8000ab84:	fcc42a23          	sw	a2,-44(s0)
8000ab88:	0100006f          	j	8000ab98 <node_free+0x2c>
8000ab8c:	fd442783          	lw	a5,-44(s0)
8000ab90:	00178793          	addi	a5,a5,1
8000ab94:	fcf42a23          	sw	a5,-44(s0)
8000ab98:	fd442703          	lw	a4,-44(s0)
8000ab9c:	00f00793          	li	a5,15
8000aba0:	02e7ce63          	blt	a5,a4,8000abdc <node_free+0x70>
8000aba4:	fd442783          	lw	a5,-44(s0)
8000aba8:	00178613          	addi	a2,a5,1
8000abac:	801c27b7          	lui	a5,0x801c2
8000abb0:	35478693          	addi	a3,a5,852 # 801c2354 <_bss_end+0xfffffd64>
8000abb4:	fdc42703          	lw	a4,-36(s0)
8000abb8:	00070793          	mv	a5,a4
8000abbc:	00479793          	slli	a5,a5,0x4
8000abc0:	00e787b3          	add	a5,a5,a4
8000abc4:	00c787b3          	add	a5,a5,a2
8000abc8:	00279793          	slli	a5,a5,0x2
8000abcc:	00f687b3          	add	a5,a3,a5
8000abd0:	0007a783          	lw	a5,0(a5)
8000abd4:	fd842703          	lw	a4,-40(s0)
8000abd8:	faf75ae3          	bge	a4,a5,8000ab8c <node_free+0x20>
8000abdc:	801c27b7          	lui	a5,0x801c2
8000abe0:	35478693          	addi	a3,a5,852 # 801c2354 <_bss_end+0xfffffd64>
8000abe4:	fdc42703          	lw	a4,-36(s0)
8000abe8:	00070793          	mv	a5,a4
8000abec:	00479793          	slli	a5,a5,0x4
8000abf0:	00e787b3          	add	a5,a5,a4
8000abf4:	fd442703          	lw	a4,-44(s0)
8000abf8:	00e787b3          	add	a5,a5,a4
8000abfc:	00279793          	slli	a5,a5,0x2
8000ac00:	00f687b3          	add	a5,a3,a5
8000ac04:	0007a783          	lw	a5,0(a5)
8000ac08:	fd842703          	lw	a4,-40(s0)
8000ac0c:	40f707b3          	sub	a5,a4,a5
8000ac10:	fd442583          	lw	a1,-44(s0)
8000ac14:	00078513          	mv	a0,a5
8000ac18:	0a9000ef          	jal	ra,8000b4c0 <__divsi3>
8000ac1c:	00050793          	mv	a5,a0
8000ac20:	fef42623          	sw	a5,-20(s0)
8000ac24:	8000c7b7          	lui	a5,0x8000c
8000ac28:	fc478693          	addi	a3,a5,-60 # 8000bfc4 <_bss_end+0xffe499d4>
8000ac2c:	fdc42703          	lw	a4,-36(s0)
8000ac30:	00070793          	mv	a5,a4
8000ac34:	00479793          	slli	a5,a5,0x4
8000ac38:	00e787b3          	add	a5,a5,a4
8000ac3c:	fd442703          	lw	a4,-44(s0)
8000ac40:	00e787b3          	add	a5,a5,a4
8000ac44:	00279793          	slli	a5,a5,0x2
8000ac48:	00f687b3          	add	a5,a3,a5
8000ac4c:	0007a783          	lw	a5,0(a5)
8000ac50:	fec42703          	lw	a4,-20(s0)
8000ac54:	00f727b3          	slt	a5,a4,a5
8000ac58:	0ff7f793          	andi	a5,a5,255
8000ac5c:	00078513          	mv	a0,a5
8000ac60:	96cf60ef          	jal	ra,80000dcc <assert>
8000ac64:	fec42603          	lw	a2,-20(s0)
8000ac68:	fd442583          	lw	a1,-44(s0)
8000ac6c:	fdc42503          	lw	a0,-36(s0)
8000ac70:	865ff0ef          	jal	ra,8000a4d4 <_blk_push>
8000ac74:	00000013          	nop
8000ac78:	02c12083          	lw	ra,44(sp)
8000ac7c:	02812403          	lw	s0,40(sp)
8000ac80:	03010113          	addi	sp,sp,48
8000ac84:	00008067          	ret

8000ac88 <leaf_malloc>:
8000ac88:	fd010113          	addi	sp,sp,-48
8000ac8c:	02112623          	sw	ra,44(sp)
8000ac90:	02812423          	sw	s0,40(sp)
8000ac94:	02912223          	sw	s1,36(sp)
8000ac98:	03010413          	addi	s0,sp,48
8000ac9c:	fca42e23          	sw	a0,-36(s0)
8000aca0:	fdc42583          	lw	a1,-36(s0)
8000aca4:	00800513          	li	a0,8
8000aca8:	989ff0ef          	jal	ra,8000a630 <_blk_pop>
8000acac:	fea42623          	sw	a0,-20(s0)
8000acb0:	0340006f          	j	8000ace4 <leaf_malloc+0x5c>
8000acb4:	fdc42783          	lw	a5,-36(s0)
8000acb8:	0107a793          	slti	a5,a5,16
8000acbc:	0ff7f793          	andi	a5,a5,255
8000acc0:	00078513          	mv	a0,a5
8000acc4:	908f60ef          	jal	ra,80000dcc <assert>
8000acc8:	fdc42783          	lw	a5,-36(s0)
8000accc:	00178793          	addi	a5,a5,1
8000acd0:	fcf42e23          	sw	a5,-36(s0)
8000acd4:	fdc42583          	lw	a1,-36(s0)
8000acd8:	00800513          	li	a0,8
8000acdc:	955ff0ef          	jal	ra,8000a630 <_blk_pop>
8000ace0:	fea42623          	sw	a0,-20(s0)
8000ace4:	fec42703          	lw	a4,-20(s0)
8000ace8:	fff00793          	li	a5,-1
8000acec:	fcf704e3          	beq	a4,a5,8000acb4 <leaf_malloc+0x2c>
8000acf0:	801c27b7          	lui	a5,0x801c2
8000acf4:	35478713          	addi	a4,a5,852 # 801c2354 <_bss_end+0xfffffd64>
8000acf8:	fdc42783          	lw	a5,-36(s0)
8000acfc:	08878793          	addi	a5,a5,136
8000ad00:	00279793          	slli	a5,a5,0x2
8000ad04:	00f707b3          	add	a5,a4,a5
8000ad08:	0007a483          	lw	s1,0(a5)
8000ad0c:	fdc42583          	lw	a1,-36(s0)
8000ad10:	fec42503          	lw	a0,-20(s0)
8000ad14:	788000ef          	jal	ra,8000b49c <__mulsi3>
8000ad18:	00050793          	mv	a5,a0
8000ad1c:	00f48733          	add	a4,s1,a5
8000ad20:	fdc42783          	lw	a5,-36(s0)
8000ad24:	00f70733          	add	a4,a4,a5
8000ad28:	000107b7          	lui	a5,0x10
8000ad2c:	fff78793          	addi	a5,a5,-1 # ffff <_reset_vector-0x7fff0001>
8000ad30:	00f727b3          	slt	a5,a4,a5
8000ad34:	0ff7f793          	andi	a5,a5,255
8000ad38:	00078513          	mv	a0,a5
8000ad3c:	890f60ef          	jal	ra,80000dcc <assert>
8000ad40:	801c27b7          	lui	a5,0x801c2
8000ad44:	35478713          	addi	a4,a5,852 # 801c2354 <_bss_end+0xfffffd64>
8000ad48:	fdc42783          	lw	a5,-36(s0)
8000ad4c:	08878793          	addi	a5,a5,136
8000ad50:	00279793          	slli	a5,a5,0x2
8000ad54:	00f707b3          	add	a5,a4,a5
8000ad58:	0007a483          	lw	s1,0(a5)
8000ad5c:	fdc42583          	lw	a1,-36(s0)
8000ad60:	fec42503          	lw	a0,-20(s0)
8000ad64:	738000ef          	jal	ra,8000b49c <__mulsi3>
8000ad68:	00050793          	mv	a5,a0
8000ad6c:	00f487b3          	add	a5,s1,a5
8000ad70:	00078513          	mv	a0,a5
8000ad74:	02c12083          	lw	ra,44(sp)
8000ad78:	02812403          	lw	s0,40(sp)
8000ad7c:	02412483          	lw	s1,36(sp)
8000ad80:	03010113          	addi	sp,sp,48
8000ad84:	00008067          	ret

8000ad88 <leaf_free>:
8000ad88:	fd010113          	addi	sp,sp,-48
8000ad8c:	02112623          	sw	ra,44(sp)
8000ad90:	02812423          	sw	s0,40(sp)
8000ad94:	03010413          	addi	s0,sp,48
8000ad98:	fca42e23          	sw	a0,-36(s0)
8000ad9c:	fcb42c23          	sw	a1,-40(s0)
8000ada0:	0100006f          	j	8000adb0 <leaf_free+0x28>
8000ada4:	fd842783          	lw	a5,-40(s0)
8000ada8:	00178793          	addi	a5,a5,1
8000adac:	fcf42c23          	sw	a5,-40(s0)
8000adb0:	fd842703          	lw	a4,-40(s0)
8000adb4:	00f00793          	li	a5,15
8000adb8:	02e7c663          	blt	a5,a4,8000ade4 <leaf_free+0x5c>
8000adbc:	fd842783          	lw	a5,-40(s0)
8000adc0:	00178793          	addi	a5,a5,1
8000adc4:	801c2737          	lui	a4,0x801c2
8000adc8:	35470713          	addi	a4,a4,852 # 801c2354 <_bss_end+0xfffffd64>
8000adcc:	08878793          	addi	a5,a5,136
8000add0:	00279793          	slli	a5,a5,0x2
8000add4:	00f707b3          	add	a5,a4,a5
8000add8:	0007a783          	lw	a5,0(a5)
8000addc:	fdc42703          	lw	a4,-36(s0)
8000ade0:	fcf752e3          	bge	a4,a5,8000ada4 <leaf_free+0x1c>
8000ade4:	801c27b7          	lui	a5,0x801c2
8000ade8:	35478713          	addi	a4,a5,852 # 801c2354 <_bss_end+0xfffffd64>
8000adec:	fd842783          	lw	a5,-40(s0)
8000adf0:	08878793          	addi	a5,a5,136
8000adf4:	00279793          	slli	a5,a5,0x2
8000adf8:	00f707b3          	add	a5,a4,a5
8000adfc:	0007a783          	lw	a5,0(a5)
8000ae00:	fdc42703          	lw	a4,-36(s0)
8000ae04:	40f707b3          	sub	a5,a4,a5
8000ae08:	fd842583          	lw	a1,-40(s0)
8000ae0c:	00078513          	mv	a0,a5
8000ae10:	6b0000ef          	jal	ra,8000b4c0 <__divsi3>
8000ae14:	00050793          	mv	a5,a0
8000ae18:	fef42623          	sw	a5,-20(s0)
8000ae1c:	8000c7b7          	lui	a5,0x8000c
8000ae20:	1e478713          	addi	a4,a5,484 # 8000c1e4 <_bss_end+0xffe49bf4>
8000ae24:	fd842783          	lw	a5,-40(s0)
8000ae28:	00279793          	slli	a5,a5,0x2
8000ae2c:	00f707b3          	add	a5,a4,a5
8000ae30:	0007a783          	lw	a5,0(a5)
8000ae34:	fec42703          	lw	a4,-20(s0)
8000ae38:	00f727b3          	slt	a5,a4,a5
8000ae3c:	0ff7f793          	andi	a5,a5,255
8000ae40:	00078513          	mv	a0,a5
8000ae44:	f89f50ef          	jal	ra,80000dcc <assert>
8000ae48:	fec42603          	lw	a2,-20(s0)
8000ae4c:	fd842583          	lw	a1,-40(s0)
8000ae50:	00800513          	li	a0,8
8000ae54:	e80ff0ef          	jal	ra,8000a4d4 <_blk_push>
8000ae58:	00000013          	nop
8000ae5c:	02c12083          	lw	ra,44(sp)
8000ae60:	02812403          	lw	s0,40(sp)
8000ae64:	03010113          	addi	sp,sp,48
8000ae68:	00008067          	ret

8000ae6c <__divdi3>:
8000ae6c:	fc010113          	addi	sp,sp,-64
8000ae70:	02812c23          	sw	s0,56(sp)
8000ae74:	03212823          	sw	s2,48(sp)
8000ae78:	01712e23          	sw	s7,28(sp)
8000ae7c:	02112e23          	sw	ra,60(sp)
8000ae80:	02912a23          	sw	s1,52(sp)
8000ae84:	03312623          	sw	s3,44(sp)
8000ae88:	03412423          	sw	s4,40(sp)
8000ae8c:	03512223          	sw	s5,36(sp)
8000ae90:	03612023          	sw	s6,32(sp)
8000ae94:	01812c23          	sw	s8,24(sp)
8000ae98:	01912a23          	sw	s9,20(sp)
8000ae9c:	01a12823          	sw	s10,16(sp)
8000aea0:	01b12623          	sw	s11,12(sp)
8000aea4:	00050b93          	mv	s7,a0
8000aea8:	00058413          	mv	s0,a1
8000aeac:	00000913          	li	s2,0
8000aeb0:	0005dc63          	bgez	a1,8000aec8 <__divdi3+0x5c>
8000aeb4:	00a037b3          	snez	a5,a0
8000aeb8:	40b00433          	neg	s0,a1
8000aebc:	40f40433          	sub	s0,s0,a5
8000aec0:	40a00bb3          	neg	s7,a0
8000aec4:	fff00913          	li	s2,-1
8000aec8:	0006dc63          	bgez	a3,8000aee0 <__divdi3+0x74>
8000aecc:	00c037b3          	snez	a5,a2
8000aed0:	40d006b3          	neg	a3,a3
8000aed4:	fff94913          	not	s2,s2
8000aed8:	40f686b3          	sub	a3,a3,a5
8000aedc:	40c00633          	neg	a2,a2
8000aee0:	00060993          	mv	s3,a2
8000aee4:	00068a93          	mv	s5,a3
8000aee8:	000b8a13          	mv	s4,s7
8000aeec:	00040c13          	mv	s8,s0
8000aef0:	3a069263          	bnez	a3,8000b294 <__divdi3+0x428>
8000aef4:	00001497          	auipc	s1,0x1
8000aef8:	fc048493          	addi	s1,s1,-64 # 8000beb4 <__clz_tab>
8000aefc:	12c47663          	bgeu	s0,a2,8000b028 <__divdi3+0x1bc>
8000af00:	000107b7          	lui	a5,0x10
8000af04:	10f67863          	bgeu	a2,a5,8000b014 <__divdi3+0x1a8>
8000af08:	0ff00793          	li	a5,255
8000af0c:	00c7b7b3          	sltu	a5,a5,a2
8000af10:	00379793          	slli	a5,a5,0x3
8000af14:	00f65733          	srl	a4,a2,a5
8000af18:	00e484b3          	add	s1,s1,a4
8000af1c:	0004c703          	lbu	a4,0(s1)
8000af20:	02000693          	li	a3,32
8000af24:	00f707b3          	add	a5,a4,a5
8000af28:	40f68733          	sub	a4,a3,a5
8000af2c:	00f68c63          	beq	a3,a5,8000af44 <__divdi3+0xd8>
8000af30:	00e41433          	sll	s0,s0,a4
8000af34:	00fbd7b3          	srl	a5,s7,a5
8000af38:	00e619b3          	sll	s3,a2,a4
8000af3c:	0087ec33          	or	s8,a5,s0
8000af40:	00eb9a33          	sll	s4,s7,a4
8000af44:	0109da93          	srli	s5,s3,0x10
8000af48:	000a8593          	mv	a1,s5
8000af4c:	000c0513          	mv	a0,s8
8000af50:	5c0000ef          	jal	ra,8000b510 <__umodsi3>
8000af54:	00050493          	mv	s1,a0
8000af58:	000a8593          	mv	a1,s5
8000af5c:	01099b13          	slli	s6,s3,0x10
8000af60:	000c0513          	mv	a0,s8
8000af64:	564000ef          	jal	ra,8000b4c8 <__udivsi3>
8000af68:	010b5b13          	srli	s6,s6,0x10
8000af6c:	00050413          	mv	s0,a0
8000af70:	00050593          	mv	a1,a0
8000af74:	000b0513          	mv	a0,s6
8000af78:	524000ef          	jal	ra,8000b49c <__mulsi3>
8000af7c:	01049493          	slli	s1,s1,0x10
8000af80:	010a5713          	srli	a4,s4,0x10
8000af84:	00e4e733          	or	a4,s1,a4
8000af88:	00040b93          	mv	s7,s0
8000af8c:	00a77e63          	bgeu	a4,a0,8000afa8 <__divdi3+0x13c>
8000af90:	01370733          	add	a4,a4,s3
8000af94:	fff40b93          	addi	s7,s0,-1
8000af98:	01376863          	bltu	a4,s3,8000afa8 <__divdi3+0x13c>
8000af9c:	00a77663          	bgeu	a4,a0,8000afa8 <__divdi3+0x13c>
8000afa0:	ffe40b93          	addi	s7,s0,-2
8000afa4:	01370733          	add	a4,a4,s3
8000afa8:	40a70433          	sub	s0,a4,a0
8000afac:	000a8593          	mv	a1,s5
8000afb0:	00040513          	mv	a0,s0
8000afb4:	55c000ef          	jal	ra,8000b510 <__umodsi3>
8000afb8:	00050493          	mv	s1,a0
8000afbc:	000a8593          	mv	a1,s5
8000afc0:	00040513          	mv	a0,s0
8000afc4:	504000ef          	jal	ra,8000b4c8 <__udivsi3>
8000afc8:	010a1a13          	slli	s4,s4,0x10
8000afcc:	00050413          	mv	s0,a0
8000afd0:	00050593          	mv	a1,a0
8000afd4:	01049493          	slli	s1,s1,0x10
8000afd8:	000b0513          	mv	a0,s6
8000afdc:	010a5a13          	srli	s4,s4,0x10
8000afe0:	4bc000ef          	jal	ra,8000b49c <__mulsi3>
8000afe4:	0144ea33          	or	s4,s1,s4
8000afe8:	00040613          	mv	a2,s0
8000afec:	00aa7c63          	bgeu	s4,a0,8000b004 <__divdi3+0x198>
8000aff0:	01498a33          	add	s4,s3,s4
8000aff4:	fff40613          	addi	a2,s0,-1
8000aff8:	013a6663          	bltu	s4,s3,8000b004 <__divdi3+0x198>
8000affc:	00aa7463          	bgeu	s4,a0,8000b004 <__divdi3+0x198>
8000b000:	ffe40613          	addi	a2,s0,-2
8000b004:	010b9793          	slli	a5,s7,0x10
8000b008:	00c7e7b3          	or	a5,a5,a2
8000b00c:	00000a93          	li	s5,0
8000b010:	12c0006f          	j	8000b13c <__divdi3+0x2d0>
8000b014:	01000737          	lui	a4,0x1000
8000b018:	01000793          	li	a5,16
8000b01c:	eee66ce3          	bltu	a2,a4,8000af14 <__divdi3+0xa8>
8000b020:	01800793          	li	a5,24
8000b024:	ef1ff06f          	j	8000af14 <__divdi3+0xa8>
8000b028:	00061a63          	bnez	a2,8000b03c <__divdi3+0x1d0>
8000b02c:	00000593          	li	a1,0
8000b030:	00100513          	li	a0,1
8000b034:	494000ef          	jal	ra,8000b4c8 <__udivsi3>
8000b038:	00050993          	mv	s3,a0
8000b03c:	000107b7          	lui	a5,0x10
8000b040:	14f9fa63          	bgeu	s3,a5,8000b194 <__divdi3+0x328>
8000b044:	0ff00793          	li	a5,255
8000b048:	0137f463          	bgeu	a5,s3,8000b050 <__divdi3+0x1e4>
8000b04c:	00800a93          	li	s5,8
8000b050:	0159d7b3          	srl	a5,s3,s5
8000b054:	00f484b3          	add	s1,s1,a5
8000b058:	0004cb03          	lbu	s6,0(s1)
8000b05c:	02000713          	li	a4,32
8000b060:	015b0b33          	add	s6,s6,s5
8000b064:	416707b3          	sub	a5,a4,s6
8000b068:	15671063          	bne	a4,s6,8000b1a8 <__divdi3+0x33c>
8000b06c:	41340433          	sub	s0,s0,s3
8000b070:	00100a93          	li	s5,1
8000b074:	0109db13          	srli	s6,s3,0x10
8000b078:	000b0593          	mv	a1,s6
8000b07c:	00040513          	mv	a0,s0
8000b080:	490000ef          	jal	ra,8000b510 <__umodsi3>
8000b084:	00050493          	mv	s1,a0
8000b088:	000b0593          	mv	a1,s6
8000b08c:	00040513          	mv	a0,s0
8000b090:	01099b93          	slli	s7,s3,0x10
8000b094:	434000ef          	jal	ra,8000b4c8 <__udivsi3>
8000b098:	010bdb93          	srli	s7,s7,0x10
8000b09c:	00050413          	mv	s0,a0
8000b0a0:	00050593          	mv	a1,a0
8000b0a4:	000b8513          	mv	a0,s7
8000b0a8:	3f4000ef          	jal	ra,8000b49c <__mulsi3>
8000b0ac:	01049493          	slli	s1,s1,0x10
8000b0b0:	010a5713          	srli	a4,s4,0x10
8000b0b4:	00e4e733          	or	a4,s1,a4
8000b0b8:	00040c13          	mv	s8,s0
8000b0bc:	00a77e63          	bgeu	a4,a0,8000b0d8 <__divdi3+0x26c>
8000b0c0:	01370733          	add	a4,a4,s3
8000b0c4:	fff40c13          	addi	s8,s0,-1
8000b0c8:	01376863          	bltu	a4,s3,8000b0d8 <__divdi3+0x26c>
8000b0cc:	00a77663          	bgeu	a4,a0,8000b0d8 <__divdi3+0x26c>
8000b0d0:	ffe40c13          	addi	s8,s0,-2
8000b0d4:	01370733          	add	a4,a4,s3
8000b0d8:	40a70433          	sub	s0,a4,a0
8000b0dc:	000b0593          	mv	a1,s6
8000b0e0:	00040513          	mv	a0,s0
8000b0e4:	42c000ef          	jal	ra,8000b510 <__umodsi3>
8000b0e8:	00050493          	mv	s1,a0
8000b0ec:	000b0593          	mv	a1,s6
8000b0f0:	00040513          	mv	a0,s0
8000b0f4:	3d4000ef          	jal	ra,8000b4c8 <__udivsi3>
8000b0f8:	010a1a13          	slli	s4,s4,0x10
8000b0fc:	00050413          	mv	s0,a0
8000b100:	00050593          	mv	a1,a0
8000b104:	01049493          	slli	s1,s1,0x10
8000b108:	000b8513          	mv	a0,s7
8000b10c:	010a5a13          	srli	s4,s4,0x10
8000b110:	38c000ef          	jal	ra,8000b49c <__mulsi3>
8000b114:	0144ea33          	or	s4,s1,s4
8000b118:	00040613          	mv	a2,s0
8000b11c:	00aa7c63          	bgeu	s4,a0,8000b134 <__divdi3+0x2c8>
8000b120:	01498a33          	add	s4,s3,s4
8000b124:	fff40613          	addi	a2,s0,-1
8000b128:	013a6663          	bltu	s4,s3,8000b134 <__divdi3+0x2c8>
8000b12c:	00aa7463          	bgeu	s4,a0,8000b134 <__divdi3+0x2c8>
8000b130:	ffe40613          	addi	a2,s0,-2
8000b134:	010c1793          	slli	a5,s8,0x10
8000b138:	00c7e7b3          	or	a5,a5,a2
8000b13c:	00078513          	mv	a0,a5
8000b140:	000a8593          	mv	a1,s5
8000b144:	00090a63          	beqz	s2,8000b158 <__divdi3+0x2ec>
8000b148:	00f037b3          	snez	a5,a5
8000b14c:	415005b3          	neg	a1,s5
8000b150:	40f585b3          	sub	a1,a1,a5
8000b154:	40a00533          	neg	a0,a0
8000b158:	03c12083          	lw	ra,60(sp)
8000b15c:	03812403          	lw	s0,56(sp)
8000b160:	03412483          	lw	s1,52(sp)
8000b164:	03012903          	lw	s2,48(sp)
8000b168:	02c12983          	lw	s3,44(sp)
8000b16c:	02812a03          	lw	s4,40(sp)
8000b170:	02412a83          	lw	s5,36(sp)
8000b174:	02012b03          	lw	s6,32(sp)
8000b178:	01c12b83          	lw	s7,28(sp)
8000b17c:	01812c03          	lw	s8,24(sp)
8000b180:	01412c83          	lw	s9,20(sp)
8000b184:	01012d03          	lw	s10,16(sp)
8000b188:	00c12d83          	lw	s11,12(sp)
8000b18c:	04010113          	addi	sp,sp,64
8000b190:	00008067          	ret
8000b194:	010007b7          	lui	a5,0x1000
8000b198:	01000a93          	li	s5,16
8000b19c:	eaf9eae3          	bltu	s3,a5,8000b050 <__divdi3+0x1e4>
8000b1a0:	01800a93          	li	s5,24
8000b1a4:	eadff06f          	j	8000b050 <__divdi3+0x1e4>
8000b1a8:	00f999b3          	sll	s3,s3,a5
8000b1ac:	01645ab3          	srl	s5,s0,s6
8000b1b0:	00f41433          	sll	s0,s0,a5
8000b1b4:	016bdb33          	srl	s6,s7,s6
8000b1b8:	008b6b33          	or	s6,s6,s0
8000b1bc:	0109d413          	srli	s0,s3,0x10
8000b1c0:	00040593          	mv	a1,s0
8000b1c4:	000a8513          	mv	a0,s5
8000b1c8:	00fb9a33          	sll	s4,s7,a5
8000b1cc:	344000ef          	jal	ra,8000b510 <__umodsi3>
8000b1d0:	00050493          	mv	s1,a0
8000b1d4:	00040593          	mv	a1,s0
8000b1d8:	000a8513          	mv	a0,s5
8000b1dc:	01099b93          	slli	s7,s3,0x10
8000b1e0:	2e8000ef          	jal	ra,8000b4c8 <__udivsi3>
8000b1e4:	010bdb93          	srli	s7,s7,0x10
8000b1e8:	00050a93          	mv	s5,a0
8000b1ec:	00050593          	mv	a1,a0
8000b1f0:	000b8513          	mv	a0,s7
8000b1f4:	2a8000ef          	jal	ra,8000b49c <__mulsi3>
8000b1f8:	01049493          	slli	s1,s1,0x10
8000b1fc:	010b5793          	srli	a5,s6,0x10
8000b200:	00f4e7b3          	or	a5,s1,a5
8000b204:	000a8c13          	mv	s8,s5
8000b208:	00a7fe63          	bgeu	a5,a0,8000b224 <__divdi3+0x3b8>
8000b20c:	013787b3          	add	a5,a5,s3
8000b210:	fffa8c13          	addi	s8,s5,-1
8000b214:	0137e863          	bltu	a5,s3,8000b224 <__divdi3+0x3b8>
8000b218:	00a7f663          	bgeu	a5,a0,8000b224 <__divdi3+0x3b8>
8000b21c:	ffea8c13          	addi	s8,s5,-2
8000b220:	013787b3          	add	a5,a5,s3
8000b224:	40a78ab3          	sub	s5,a5,a0
8000b228:	00040593          	mv	a1,s0
8000b22c:	000a8513          	mv	a0,s5
8000b230:	2e0000ef          	jal	ra,8000b510 <__umodsi3>
8000b234:	00040593          	mv	a1,s0
8000b238:	00050493          	mv	s1,a0
8000b23c:	000a8513          	mv	a0,s5
8000b240:	288000ef          	jal	ra,8000b4c8 <__udivsi3>
8000b244:	010b1413          	slli	s0,s6,0x10
8000b248:	00050c93          	mv	s9,a0
8000b24c:	00050593          	mv	a1,a0
8000b250:	01049493          	slli	s1,s1,0x10
8000b254:	000b8513          	mv	a0,s7
8000b258:	01045413          	srli	s0,s0,0x10
8000b25c:	240000ef          	jal	ra,8000b49c <__mulsi3>
8000b260:	0084e433          	or	s0,s1,s0
8000b264:	000c8a93          	mv	s5,s9
8000b268:	00a47e63          	bgeu	s0,a0,8000b284 <__divdi3+0x418>
8000b26c:	01340433          	add	s0,s0,s3
8000b270:	fffc8a93          	addi	s5,s9,-1
8000b274:	01346863          	bltu	s0,s3,8000b284 <__divdi3+0x418>
8000b278:	00a47663          	bgeu	s0,a0,8000b284 <__divdi3+0x418>
8000b27c:	ffec8a93          	addi	s5,s9,-2
8000b280:	01340433          	add	s0,s0,s3
8000b284:	010c1593          	slli	a1,s8,0x10
8000b288:	40a40433          	sub	s0,s0,a0
8000b28c:	0155eab3          	or	s5,a1,s5
8000b290:	de5ff06f          	j	8000b074 <__divdi3+0x208>
8000b294:	1ed46e63          	bltu	s0,a3,8000b490 <__divdi3+0x624>
8000b298:	000107b7          	lui	a5,0x10
8000b29c:	04f6f463          	bgeu	a3,a5,8000b2e4 <__divdi3+0x478>
8000b2a0:	0ff00b13          	li	s6,255
8000b2a4:	00db37b3          	sltu	a5,s6,a3
8000b2a8:	00379793          	slli	a5,a5,0x3
8000b2ac:	00f6d5b3          	srl	a1,a3,a5
8000b2b0:	00001717          	auipc	a4,0x1
8000b2b4:	c0470713          	addi	a4,a4,-1020 # 8000beb4 <__clz_tab>
8000b2b8:	00b70733          	add	a4,a4,a1
8000b2bc:	00074b03          	lbu	s6,0(a4)
8000b2c0:	00fb0b33          	add	s6,s6,a5
8000b2c4:	02000793          	li	a5,32
8000b2c8:	41678ab3          	sub	s5,a5,s6
8000b2cc:	03679663          	bne	a5,s6,8000b2f8 <__divdi3+0x48c>
8000b2d0:	00100793          	li	a5,1
8000b2d4:	e686e4e3          	bltu	a3,s0,8000b13c <__divdi3+0x2d0>
8000b2d8:	00cbb633          	sltu	a2,s7,a2
8000b2dc:	00164793          	xori	a5,a2,1
8000b2e0:	e5dff06f          	j	8000b13c <__divdi3+0x2d0>
8000b2e4:	01000737          	lui	a4,0x1000
8000b2e8:	01000793          	li	a5,16
8000b2ec:	fce6e0e3          	bltu	a3,a4,8000b2ac <__divdi3+0x440>
8000b2f0:	01800793          	li	a5,24
8000b2f4:	fb9ff06f          	j	8000b2ac <__divdi3+0x440>
8000b2f8:	01665d33          	srl	s10,a2,s6
8000b2fc:	015696b3          	sll	a3,a3,s5
8000b300:	00dd6d33          	or	s10,s10,a3
8000b304:	016454b3          	srl	s1,s0,s6
8000b308:	010d5c13          	srli	s8,s10,0x10
8000b30c:	000c0593          	mv	a1,s8
8000b310:	00048513          	mv	a0,s1
8000b314:	01561a33          	sll	s4,a2,s5
8000b318:	1f8000ef          	jal	ra,8000b510 <__umodsi3>
8000b31c:	00050993          	mv	s3,a0
8000b320:	000c0593          	mv	a1,s8
8000b324:	010d1c93          	slli	s9,s10,0x10
8000b328:	00048513          	mv	a0,s1
8000b32c:	19c000ef          	jal	ra,8000b4c8 <__udivsi3>
8000b330:	01541433          	sll	s0,s0,s5
8000b334:	016bdb33          	srl	s6,s7,s6
8000b338:	010cdc93          	srli	s9,s9,0x10
8000b33c:	008b6b33          	or	s6,s6,s0
8000b340:	00050593          	mv	a1,a0
8000b344:	00050413          	mv	s0,a0
8000b348:	000c8513          	mv	a0,s9
8000b34c:	150000ef          	jal	ra,8000b49c <__mulsi3>
8000b350:	01099993          	slli	s3,s3,0x10
8000b354:	010b5713          	srli	a4,s6,0x10
8000b358:	00e9e733          	or	a4,s3,a4
8000b35c:	00040d93          	mv	s11,s0
8000b360:	00a77e63          	bgeu	a4,a0,8000b37c <__divdi3+0x510>
8000b364:	01a70733          	add	a4,a4,s10
8000b368:	fff40d93          	addi	s11,s0,-1
8000b36c:	01a76863          	bltu	a4,s10,8000b37c <__divdi3+0x510>
8000b370:	00a77663          	bgeu	a4,a0,8000b37c <__divdi3+0x510>
8000b374:	ffe40d93          	addi	s11,s0,-2
8000b378:	01a70733          	add	a4,a4,s10
8000b37c:	40a704b3          	sub	s1,a4,a0
8000b380:	000c0593          	mv	a1,s8
8000b384:	00048513          	mv	a0,s1
8000b388:	188000ef          	jal	ra,8000b510 <__umodsi3>
8000b38c:	00050993          	mv	s3,a0
8000b390:	000c0593          	mv	a1,s8
8000b394:	00048513          	mv	a0,s1
8000b398:	130000ef          	jal	ra,8000b4c8 <__udivsi3>
8000b39c:	010b1413          	slli	s0,s6,0x10
8000b3a0:	00050493          	mv	s1,a0
8000b3a4:	00050593          	mv	a1,a0
8000b3a8:	01099993          	slli	s3,s3,0x10
8000b3ac:	000c8513          	mv	a0,s9
8000b3b0:	01045413          	srli	s0,s0,0x10
8000b3b4:	0e8000ef          	jal	ra,8000b49c <__mulsi3>
8000b3b8:	0089e433          	or	s0,s3,s0
8000b3bc:	00048613          	mv	a2,s1
8000b3c0:	00a47e63          	bgeu	s0,a0,8000b3dc <__divdi3+0x570>
8000b3c4:	01a40433          	add	s0,s0,s10
8000b3c8:	fff48613          	addi	a2,s1,-1
8000b3cc:	01a46863          	bltu	s0,s10,8000b3dc <__divdi3+0x570>
8000b3d0:	00a47663          	bgeu	s0,a0,8000b3dc <__divdi3+0x570>
8000b3d4:	ffe48613          	addi	a2,s1,-2
8000b3d8:	01a40433          	add	s0,s0,s10
8000b3dc:	010d9793          	slli	a5,s11,0x10
8000b3e0:	00010e37          	lui	t3,0x10
8000b3e4:	00c7e7b3          	or	a5,a5,a2
8000b3e8:	fffe0313          	addi	t1,t3,-1 # ffff <_reset_vector-0x7fff0001>
8000b3ec:	0067f8b3          	and	a7,a5,t1
8000b3f0:	006a7333          	and	t1,s4,t1
8000b3f4:	40a40433          	sub	s0,s0,a0
8000b3f8:	0107de93          	srli	t4,a5,0x10
8000b3fc:	010a5a13          	srli	s4,s4,0x10
8000b400:	00088513          	mv	a0,a7
8000b404:	00030593          	mv	a1,t1
8000b408:	094000ef          	jal	ra,8000b49c <__mulsi3>
8000b40c:	00050813          	mv	a6,a0
8000b410:	000a0593          	mv	a1,s4
8000b414:	00088513          	mv	a0,a7
8000b418:	084000ef          	jal	ra,8000b49c <__mulsi3>
8000b41c:	00050893          	mv	a7,a0
8000b420:	00030593          	mv	a1,t1
8000b424:	000e8513          	mv	a0,t4
8000b428:	074000ef          	jal	ra,8000b49c <__mulsi3>
8000b42c:	00050313          	mv	t1,a0
8000b430:	000a0593          	mv	a1,s4
8000b434:	000e8513          	mv	a0,t4
8000b438:	064000ef          	jal	ra,8000b49c <__mulsi3>
8000b43c:	01085713          	srli	a4,a6,0x10
8000b440:	006888b3          	add	a7,a7,t1
8000b444:	01170733          	add	a4,a4,a7
8000b448:	00050693          	mv	a3,a0
8000b44c:	00677463          	bgeu	a4,t1,8000b454 <__divdi3+0x5e8>
8000b450:	01c506b3          	add	a3,a0,t3
8000b454:	01075513          	srli	a0,a4,0x10
8000b458:	00d506b3          	add	a3,a0,a3
8000b45c:	02d46663          	bltu	s0,a3,8000b488 <__divdi3+0x61c>
8000b460:	bad416e3          	bne	s0,a3,8000b00c <__divdi3+0x1a0>
8000b464:	00010537          	lui	a0,0x10
8000b468:	fff50513          	addi	a0,a0,-1 # ffff <_reset_vector-0x7fff0001>
8000b46c:	00a77733          	and	a4,a4,a0
8000b470:	01071713          	slli	a4,a4,0x10
8000b474:	00a87833          	and	a6,a6,a0
8000b478:	015b9bb3          	sll	s7,s7,s5
8000b47c:	01070733          	add	a4,a4,a6
8000b480:	00000a93          	li	s5,0
8000b484:	caebfce3          	bgeu	s7,a4,8000b13c <__divdi3+0x2d0>
8000b488:	fff78793          	addi	a5,a5,-1 # ffff <_reset_vector-0x7fff0001>
8000b48c:	b81ff06f          	j	8000b00c <__divdi3+0x1a0>
8000b490:	00000a93          	li	s5,0
8000b494:	00000793          	li	a5,0
8000b498:	ca5ff06f          	j	8000b13c <__divdi3+0x2d0>

8000b49c <__mulsi3>:
8000b49c:	00050613          	mv	a2,a0
8000b4a0:	00000513          	li	a0,0
8000b4a4:	0015f693          	andi	a3,a1,1
8000b4a8:	00068463          	beqz	a3,8000b4b0 <__mulsi3+0x14>
8000b4ac:	00c50533          	add	a0,a0,a2
8000b4b0:	0015d593          	srli	a1,a1,0x1
8000b4b4:	00161613          	slli	a2,a2,0x1
8000b4b8:	fe0596e3          	bnez	a1,8000b4a4 <__mulsi3+0x8>
8000b4bc:	00008067          	ret

8000b4c0 <__divsi3>:
8000b4c0:	06054063          	bltz	a0,8000b520 <__umodsi3+0x10>
8000b4c4:	0605c663          	bltz	a1,8000b530 <__umodsi3+0x20>

8000b4c8 <__udivsi3>:
8000b4c8:	00058613          	mv	a2,a1
8000b4cc:	00050593          	mv	a1,a0
8000b4d0:	fff00513          	li	a0,-1
8000b4d4:	02060c63          	beqz	a2,8000b50c <__udivsi3+0x44>
8000b4d8:	00100693          	li	a3,1
8000b4dc:	00b67a63          	bgeu	a2,a1,8000b4f0 <__udivsi3+0x28>
8000b4e0:	00c05863          	blez	a2,8000b4f0 <__udivsi3+0x28>
8000b4e4:	00161613          	slli	a2,a2,0x1
8000b4e8:	00169693          	slli	a3,a3,0x1
8000b4ec:	feb66ae3          	bltu	a2,a1,8000b4e0 <__udivsi3+0x18>
8000b4f0:	00000513          	li	a0,0
8000b4f4:	00c5e663          	bltu	a1,a2,8000b500 <__udivsi3+0x38>
8000b4f8:	40c585b3          	sub	a1,a1,a2
8000b4fc:	00d56533          	or	a0,a0,a3
8000b500:	0016d693          	srli	a3,a3,0x1
8000b504:	00165613          	srli	a2,a2,0x1
8000b508:	fe0696e3          	bnez	a3,8000b4f4 <__udivsi3+0x2c>
8000b50c:	00008067          	ret

8000b510 <__umodsi3>:
8000b510:	00008293          	mv	t0,ra
8000b514:	fb5ff0ef          	jal	ra,8000b4c8 <__udivsi3>
8000b518:	00058513          	mv	a0,a1
8000b51c:	00028067          	jr	t0
8000b520:	40a00533          	neg	a0,a0
8000b524:	00b04863          	bgtz	a1,8000b534 <__umodsi3+0x24>
8000b528:	40b005b3          	neg	a1,a1
8000b52c:	f9dff06f          	j	8000b4c8 <__udivsi3>
8000b530:	40b005b3          	neg	a1,a1
8000b534:	00008293          	mv	t0,ra
8000b538:	f91ff0ef          	jal	ra,8000b4c8 <__udivsi3>
8000b53c:	40a00533          	neg	a0,a0
8000b540:	00028067          	jr	t0

8000b544 <__modsi3>:
8000b544:	00008293          	mv	t0,ra
8000b548:	0005ca63          	bltz	a1,8000b55c <__modsi3+0x18>
8000b54c:	00054c63          	bltz	a0,8000b564 <__modsi3+0x20>
8000b550:	f79ff0ef          	jal	ra,8000b4c8 <__udivsi3>
8000b554:	00058513          	mv	a0,a1
8000b558:	00028067          	jr	t0
8000b55c:	40b005b3          	neg	a1,a1
8000b560:	fe0558e3          	bgez	a0,8000b550 <__modsi3+0xc>
8000b564:	40a00533          	neg	a0,a0
8000b568:	f61ff0ef          	jal	ra,8000b4c8 <__udivsi3>
8000b56c:	40b00533          	neg	a0,a1
8000b570:	00028067          	jr	t0
