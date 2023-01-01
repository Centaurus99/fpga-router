
lookup/lookup.o:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <popcnt>:
       0:	fd010113          	addi	sp,sp,-48
       4:	02812623          	sw	s0,44(sp)
       8:	03010413          	addi	s0,sp,48
       c:	fca42e23          	sw	a0,-36(s0)
      10:	fe042623          	sw	zero,-20(s0)
      14:	0280006f          	j	3c <.L2>

00000018 <.L4>:
      18:	fdc42783          	lw	a5,-36(s0)
      1c:	0017f793          	andi	a5,a5,1
      20:	00078863          	beqz	a5,30 <.L3>
      24:	fec42783          	lw	a5,-20(s0)
      28:	00178793          	addi	a5,a5,1
      2c:	fef42623          	sw	a5,-20(s0)

00000030 <.L3>:
      30:	fdc42783          	lw	a5,-36(s0)
      34:	4017d793          	srai	a5,a5,0x1
      38:	fcf42e23          	sw	a5,-36(s0)

0000003c <.L2>:
      3c:	fdc42783          	lw	a5,-36(s0)
      40:	fc079ce3          	bnez	a5,18 <.L4>
      44:	fec42783          	lw	a5,-20(s0)
      48:	00078513          	mv	a0,a5
      4c:	02c12403          	lw	s0,44(sp)
      50:	03010113          	addi	sp,sp,48
      54:	00008067          	ret

00000058 <INDEX>:
      58:	fd010113          	addi	sp,sp,-48
      5c:	02812623          	sw	s0,44(sp)
      60:	02912423          	sw	s1,40(sp)
      64:	03010413          	addi	s0,sp,48
      68:	00050493          	mv	s1,a0
      6c:	fcb42e23          	sw	a1,-36(s0)
      70:	fcc42c23          	sw	a2,-40(s0)
      74:	fe042623          	sw	zero,-20(s0)
      78:	08000713          	li	a4,128
      7c:	fdc42783          	lw	a5,-36(s0)
      80:	40f70733          	sub	a4,a4,a5
      84:	fd842783          	lw	a5,-40(s0)
      88:	40f707b3          	sub	a5,a4,a5
      8c:	fef42423          	sw	a5,-24(s0)

00000090 <.LBB2>:
      90:	00f00793          	li	a5,15
      94:	fef42223          	sw	a5,-28(s0)
      98:	0a40006f          	j	13c <.L7>

0000009c <.L12>:
      9c:	fe842783          	lw	a5,-24(s0)
      a0:	0207ce63          	bltz	a5,dc <.L8>
      a4:	fe842703          	lw	a4,-24(s0)
      a8:	00700793          	li	a5,7
      ac:	02e7c863          	blt	a5,a4,dc <.L8>
      b0:	fe442783          	lw	a5,-28(s0)
      b4:	00f487b3          	add	a5,s1,a5
      b8:	0007c783          	lbu	a5,0(a5)
      bc:	00078713          	mv	a4,a5
      c0:	fe842783          	lw	a5,-24(s0)
      c4:	40f757b3          	sra	a5,a4,a5
      c8:	00078713          	mv	a4,a5
      cc:	fec42783          	lw	a5,-20(s0)
      d0:	00e7e7b3          	or	a5,a5,a4
      d4:	fef42623          	sw	a5,-20(s0)
      d8:	0400006f          	j	118 <.L9>

000000dc <.L8>:
      dc:	fe842783          	lw	a5,-24(s0)
      e0:	0207dc63          	bgez	a5,118 <.L9>
      e4:	fe842703          	lw	a4,-24(s0)
      e8:	ff900793          	li	a5,-7
      ec:	02f74663          	blt	a4,a5,118 <.L9>
      f0:	fe442783          	lw	a5,-28(s0)
      f4:	00f487b3          	add	a5,s1,a5
      f8:	0007c783          	lbu	a5,0(a5)
      fc:	00078713          	mv	a4,a5
     100:	fe842783          	lw	a5,-24(s0)
     104:	40f007b3          	neg	a5,a5
     108:	00f717b3          	sll	a5,a4,a5
     10c:	fec42703          	lw	a4,-20(s0)
     110:	00f767b3          	or	a5,a4,a5
     114:	fef42623          	sw	a5,-20(s0)

00000118 <.L9>:
     118:	fe842783          	lw	a5,-24(s0)
     11c:	ff878793          	addi	a5,a5,-8
     120:	fef42423          	sw	a5,-24(s0)
     124:	fe842703          	lw	a4,-24(s0)
     128:	fe000793          	li	a5,-32
     12c:	00f74e63          	blt	a4,a5,148 <.L14>
     130:	fe442783          	lw	a5,-28(s0)
     134:	fff78793          	addi	a5,a5,-1
     138:	fef42223          	sw	a5,-28(s0)

0000013c <.L7>:
     13c:	fe442783          	lw	a5,-28(s0)
     140:	f407dee3          	bgez	a5,9c <.L12>
     144:	0080006f          	j	14c <.L11>

00000148 <.L14>:
     148:	00000013          	nop

0000014c <.L11>:
     14c:	fd842783          	lw	a5,-40(s0)
     150:	00100713          	li	a4,1
     154:	00f717b3          	sll	a5,a4,a5
     158:	fff78793          	addi	a5,a5,-1
     15c:	fec42703          	lw	a4,-20(s0)
     160:	00f777b3          	and	a5,a4,a5
     164:	fef42623          	sw	a5,-20(s0)
     168:	fec42783          	lw	a5,-20(s0)
     16c:	00078513          	mv	a0,a5
     170:	02c12403          	lw	s0,44(sp)
     174:	02812483          	lw	s1,40(sp)
     178:	03010113          	addi	sp,sp,48
     17c:	00008067          	ret

00000180 <_new_entry>:
     180:	fe010113          	addi	sp,sp,-32
     184:	00812e23          	sw	s0,28(sp)
     188:	00912c23          	sw	s1,24(sp)
     18c:	02010413          	addi	s0,sp,32
     190:	00050493          	mv	s1,a0

00000194 <.LBB3>:
     194:	fe0407a3          	sb	zero,-17(s0)
     198:	0c00006f          	j	258 <.L16>

0000019c <.L19>:
     19c:	fef44783          	lbu	a5,-17(s0)
     1a0:	00579713          	slli	a4,a5,0x5
     1a4:	510007b7          	lui	a5,0x51000
     1a8:	00f707b3          	add	a5,a4,a5
     1ac:	0107a703          	lw	a4,16(a5) # 51000010 <.LFE13+0x50ffdaec>
     1b0:	0144a783          	lw	a5,20(s1)
     1b4:	08f71c63          	bne	a4,a5,24c <.L17>
     1b8:	fef44783          	lbu	a5,-17(s0)
     1bc:	00579713          	slli	a4,a5,0x5
     1c0:	510007b7          	lui	a5,0x51000
     1c4:	00f707b3          	add	a5,a4,a5
     1c8:	0007a703          	lw	a4,0(a5) # 51000000 <.LFE13+0x50ffdadc>
     1cc:	0184a783          	lw	a5,24(s1)
     1d0:	06f71e63          	bne	a4,a5,24c <.L17>
     1d4:	fef44783          	lbu	a5,-17(s0)
     1d8:	00579713          	slli	a4,a5,0x5
     1dc:	510007b7          	lui	a5,0x51000
     1e0:	00f707b3          	add	a5,a4,a5
     1e4:	0047a703          	lw	a4,4(a5) # 51000004 <.LFE13+0x50ffdae0>
     1e8:	01c4a783          	lw	a5,28(s1)
     1ec:	06f71063          	bne	a4,a5,24c <.L17>
     1f0:	fef44783          	lbu	a5,-17(s0)
     1f4:	00579713          	slli	a4,a5,0x5
     1f8:	510007b7          	lui	a5,0x51000
     1fc:	00f707b3          	add	a5,a4,a5
     200:	0087a703          	lw	a4,8(a5) # 51000008 <.LFE13+0x50ffdae4>
     204:	0204a783          	lw	a5,32(s1)
     208:	04f71263          	bne	a4,a5,24c <.L17>
     20c:	fef44783          	lbu	a5,-17(s0)
     210:	00579713          	slli	a4,a5,0x5
     214:	510007b7          	lui	a5,0x51000
     218:	00f707b3          	add	a5,a4,a5
     21c:	00c7a703          	lw	a4,12(a5) # 5100000c <.LFE13+0x50ffdae8>
     220:	0244a783          	lw	a5,36(s1)
     224:	02f71463          	bne	a4,a5,24c <.L17>
     228:	fef44783          	lbu	a5,-17(s0)
     22c:	00579713          	slli	a4,a5,0x5
     230:	510007b7          	lui	a5,0x51000
     234:	00f707b3          	add	a5,a4,a5
     238:	0147a703          	lw	a4,20(a5) # 51000014 <.LFE13+0x50ffdaf0>
     23c:	0284a783          	lw	a5,40(s1)
     240:	00f71663          	bne	a4,a5,24c <.L17>
     244:	fef44783          	lbu	a5,-17(s0)
     248:	0e00006f          	j	328 <.L18>

0000024c <.L17>:
     24c:	fef44783          	lbu	a5,-17(s0)
     250:	00178793          	addi	a5,a5,1
     254:	fef407a3          	sb	a5,-17(s0)

00000258 <.L16>:
     258:	000007b7          	lui	a5,0x0
     25c:	0007c783          	lbu	a5,0(a5) # 0 <popcnt>
     260:	fef44703          	lbu	a4,-17(s0)
     264:	f2f76ce3          	bltu	a4,a5,19c <.L19>

00000268 <.LBE3>:
     268:	000007b7          	lui	a5,0x0
     26c:	0007c783          	lbu	a5,0(a5) # 0 <popcnt>
     270:	00579713          	slli	a4,a5,0x5
     274:	510007b7          	lui	a5,0x51000
     278:	00f707b3          	add	a5,a4,a5
     27c:	0144a703          	lw	a4,20(s1)
     280:	00e7a823          	sw	a4,16(a5) # 51000010 <.LFE13+0x50ffdaec>
     284:	000007b7          	lui	a5,0x0
     288:	0007c783          	lbu	a5,0(a5) # 0 <popcnt>
     28c:	00579713          	slli	a4,a5,0x5
     290:	510007b7          	lui	a5,0x51000
     294:	00f707b3          	add	a5,a4,a5
     298:	0184a703          	lw	a4,24(s1)
     29c:	00e7a023          	sw	a4,0(a5) # 51000000 <.LFE13+0x50ffdadc>
     2a0:	000007b7          	lui	a5,0x0
     2a4:	0007c783          	lbu	a5,0(a5) # 0 <popcnt>
     2a8:	00579713          	slli	a4,a5,0x5
     2ac:	510007b7          	lui	a5,0x51000
     2b0:	00f707b3          	add	a5,a4,a5
     2b4:	01c4a703          	lw	a4,28(s1)
     2b8:	00e7a223          	sw	a4,4(a5) # 51000004 <.LFE13+0x50ffdae0>
     2bc:	000007b7          	lui	a5,0x0
     2c0:	0007c783          	lbu	a5,0(a5) # 0 <popcnt>
     2c4:	00579713          	slli	a4,a5,0x5
     2c8:	510007b7          	lui	a5,0x51000
     2cc:	00f707b3          	add	a5,a4,a5
     2d0:	0204a703          	lw	a4,32(s1)
     2d4:	00e7a423          	sw	a4,8(a5) # 51000008 <.LFE13+0x50ffdae4>
     2d8:	000007b7          	lui	a5,0x0
     2dc:	0007c783          	lbu	a5,0(a5) # 0 <popcnt>
     2e0:	00579713          	slli	a4,a5,0x5
     2e4:	510007b7          	lui	a5,0x51000
     2e8:	00f707b3          	add	a5,a4,a5
     2ec:	0244a703          	lw	a4,36(s1)
     2f0:	00e7a623          	sw	a4,12(a5) # 5100000c <.LFE13+0x50ffdae8>
     2f4:	000007b7          	lui	a5,0x0
     2f8:	0007c783          	lbu	a5,0(a5) # 0 <popcnt>
     2fc:	00579713          	slli	a4,a5,0x5
     300:	510007b7          	lui	a5,0x51000
     304:	00f707b3          	add	a5,a4,a5
     308:	0284a703          	lw	a4,40(s1)
     30c:	00e7aa23          	sw	a4,20(a5) # 51000014 <.LFE13+0x50ffdaf0>
     310:	000007b7          	lui	a5,0x0
     314:	0007c783          	lbu	a5,0(a5) # 0 <popcnt>
     318:	00178713          	addi	a4,a5,1
     31c:	0ff77693          	andi	a3,a4,255
     320:	00000737          	lui	a4,0x0
     324:	00d70023          	sb	a3,0(a4) # 0 <popcnt>

00000328 <.L18>:
     328:	00078513          	mv	a0,a5
     32c:	01c12403          	lw	s0,28(sp)
     330:	01812483          	lw	s1,24(sp)
     334:	02010113          	addi	sp,sp,32
     338:	00008067          	ret

0000033c <_insert_node>:
     33c:	fa010113          	addi	sp,sp,-96
     340:	04112e23          	sw	ra,92(sp)
     344:	04812c23          	sw	s0,88(sp)
     348:	06010413          	addi	s0,sp,96
     34c:	faa42623          	sw	a0,-84(s0)
     350:	fab42423          	sw	a1,-88(s0)
     354:	fac42223          	sw	a2,-92(s0)
     358:	fad42023          	sw	a3,-96(s0)
     35c:	fac42783          	lw	a5,-84(s0)
     360:	00478793          	addi	a5,a5,4
     364:	41f7d713          	srai	a4,a5,0x1f
     368:	00f77713          	andi	a4,a4,15
     36c:	00f707b3          	add	a5,a4,a5
     370:	4047d793          	srai	a5,a5,0x4
     374:	fcf42423          	sw	a5,-56(s0)
     378:	fa042783          	lw	a5,-96(s0)
     37c:	0007a783          	lw	a5,0(a5)
     380:	1c079c63          	bnez	a5,558 <.L21>
     384:	fa042783          	lw	a5,-96(s0)
     388:	0047a703          	lw	a4,4(a5)
     38c:	00100793          	li	a5,1
     390:	1cf71463          	bne	a4,a5,558 <.L21>
     394:	fa842783          	lw	a5,-88(s0)
     398:	0007a783          	lw	a5,0(a5)
     39c:	04079e63          	bnez	a5,3f8 <.L22>
     3a0:	fa042783          	lw	a5,-96(s0)
     3a4:	00c7a783          	lw	a5,12(a5)
     3a8:	01079713          	slli	a4,a5,0x10
     3ac:	01075713          	srli	a4,a4,0x10
     3b0:	fa842783          	lw	a5,-88(s0)
     3b4:	00e79423          	sh	a4,8(a5)
     3b8:	fa842783          	lw	a5,-88(s0)
     3bc:	00a7d783          	lhu	a5,10(a5)
     3c0:	1007e793          	ori	a5,a5,256
     3c4:	01079713          	slli	a4,a5,0x10
     3c8:	01075713          	srli	a4,a4,0x10
     3cc:	fa842783          	lw	a5,-88(s0)
     3d0:	00e79523          	sh	a4,10(a5)
     3d4:	fa842783          	lw	a5,-88(s0)
     3d8:	0007a703          	lw	a4,0(a5)
     3dc:	fa442783          	lw	a5,-92(s0)
     3e0:	00100693          	li	a3,1
     3e4:	00f697b3          	sll	a5,a3,a5
     3e8:	00f76733          	or	a4,a4,a5
     3ec:	fa842783          	lw	a5,-88(s0)
     3f0:	00e7a023          	sw	a4,0(a5)
     3f4:	5580006f          	j	94c <.L20>

000003f8 <.L22>:
     3f8:	fa842783          	lw	a5,-88(s0)
     3fc:	00a7d783          	lhu	a5,10(a5)
     400:	1007f793          	andi	a5,a5,256
     404:	14078a63          	beqz	a5,558 <.L21>

00000408 <.LBB4>:
     408:	fa842783          	lw	a5,-88(s0)
     40c:	0007a783          	lw	a5,0(a5)
     410:	00078513          	mv	a0,a5
     414:	00000097          	auipc	ra,0x0
     418:	000080e7          	jalr	ra # 414 <.LBB4+0xc>
     41c:	fca42223          	sw	a0,-60(s0)
     420:	fc442783          	lw	a5,-60(s0)
     424:	00178793          	addi	a5,a5,1
     428:	00078513          	mv	a0,a5
     42c:	00000097          	auipc	ra,0x0
     430:	000080e7          	jalr	ra # 42c <.LBB4+0x24>
     434:	fca42023          	sw	a0,-64(s0)

00000438 <.LBB5>:
     438:	fe042623          	sw	zero,-20(s0)
     43c:	fa842783          	lw	a5,-88(s0)
     440:	0087d783          	lhu	a5,8(a5)
     444:	fef42423          	sw	a5,-24(s0)
     448:	fc042783          	lw	a5,-64(s0)
     44c:	fef42223          	sw	a5,-28(s0)
     450:	0ac0006f          	j	4fc <.L24>

00000454 <.L27>:
     454:	fec42703          	lw	a4,-20(s0)
     458:	fa442783          	lw	a5,-92(s0)
     45c:	02f71e63          	bne	a4,a5,498 <.L25>
     460:	fa042783          	lw	a5,-96(s0)
     464:	00c7a703          	lw	a4,12(a5)
     468:	500007b7          	lui	a5,0x50000
     46c:	00f70733          	add	a4,a4,a5
     470:	fe442683          	lw	a3,-28(s0)
     474:	500007b7          	lui	a5,0x50000
     478:	00f687b3          	add	a5,a3,a5
     47c:	00074703          	lbu	a4,0(a4)
     480:	0ff77713          	andi	a4,a4,255
     484:	00e78023          	sb	a4,0(a5) # 50000000 <.LFE13+0x4fffdadc>
     488:	fe442783          	lw	a5,-28(s0)
     48c:	00178793          	addi	a5,a5,1
     490:	fef42223          	sw	a5,-28(s0)
     494:	05c0006f          	j	4f0 <.L26>

00000498 <.L25>:
     498:	fa842783          	lw	a5,-88(s0)
     49c:	0007a703          	lw	a4,0(a5)
     4a0:	fec42783          	lw	a5,-20(s0)
     4a4:	00100693          	li	a3,1
     4a8:	00f697b3          	sll	a5,a3,a5
     4ac:	00f777b3          	and	a5,a4,a5
     4b0:	04078063          	beqz	a5,4f0 <.L26>
     4b4:	fe842703          	lw	a4,-24(s0)
     4b8:	500007b7          	lui	a5,0x50000
     4bc:	00f70733          	add	a4,a4,a5
     4c0:	fe442683          	lw	a3,-28(s0)
     4c4:	500007b7          	lui	a5,0x50000
     4c8:	00f687b3          	add	a5,a3,a5
     4cc:	00074703          	lbu	a4,0(a4)
     4d0:	0ff77713          	andi	a4,a4,255
     4d4:	00e78023          	sb	a4,0(a5) # 50000000 <.LFE13+0x4fffdadc>
     4d8:	fe442783          	lw	a5,-28(s0)
     4dc:	00178793          	addi	a5,a5,1
     4e0:	fef42223          	sw	a5,-28(s0)
     4e4:	fe842783          	lw	a5,-24(s0)
     4e8:	00178793          	addi	a5,a5,1
     4ec:	fef42423          	sw	a5,-24(s0)

000004f0 <.L26>:
     4f0:	fec42783          	lw	a5,-20(s0)
     4f4:	00178793          	addi	a5,a5,1
     4f8:	fef42623          	sw	a5,-20(s0)

000004fc <.L24>:
     4fc:	fec42703          	lw	a4,-20(s0)
     500:	00f00793          	li	a5,15
     504:	f4e7f8e3          	bgeu	a5,a4,454 <.L27>

00000508 <.LBE5>:
     508:	fc042783          	lw	a5,-64(s0)
     50c:	01079713          	slli	a4,a5,0x10
     510:	01075713          	srli	a4,a4,0x10
     514:	fa842783          	lw	a5,-88(s0)
     518:	00e79423          	sh	a4,8(a5)
     51c:	fa842783          	lw	a5,-88(s0)
     520:	0007a703          	lw	a4,0(a5)
     524:	fa442783          	lw	a5,-92(s0)
     528:	00100693          	li	a3,1
     52c:	00f697b3          	sll	a5,a3,a5
     530:	00f76733          	or	a4,a4,a5
     534:	fa842783          	lw	a5,-88(s0)
     538:	00e7a023          	sw	a4,0(a5)
     53c:	fa042783          	lw	a5,-96(s0)
     540:	00c7a783          	lw	a5,12(a5)
     544:	00100593          	li	a1,1
     548:	00078513          	mv	a0,a5
     54c:	00000097          	auipc	ra,0x0
     550:	000080e7          	jalr	ra # 54c <.LBE5+0x44>
     554:	3f80006f          	j	94c <.L20>

00000558 <.L21>:
     558:	fa842783          	lw	a5,-88(s0)
     55c:	00a7d783          	lhu	a5,10(a5)
     560:	1007f793          	andi	a5,a5,256
     564:	1c078263          	beqz	a5,728 <.L28>

00000568 <.LBB6>:
     568:	fa842783          	lw	a5,-88(s0)
     56c:	0007a783          	lw	a5,0(a5)
     570:	00078513          	mv	a0,a5
     574:	00000097          	auipc	ra,0x0
     578:	000080e7          	jalr	ra # 574 <.LBB6+0xc>
     57c:	faa42a23          	sw	a0,-76(s0)
     580:	fb442783          	lw	a5,-76(s0)
     584:	00178793          	addi	a5,a5,1
     588:	00078593          	mv	a1,a5
     58c:	fc842503          	lw	a0,-56(s0)
     590:	00000097          	auipc	ra,0x0
     594:	000080e7          	jalr	ra # 590 <.LBB6+0x28>
     598:	faa42823          	sw	a0,-80(s0)

0000059c <.LBB7>:
     59c:	fe042023          	sw	zero,-32(s0)
     5a0:	fa842783          	lw	a5,-88(s0)
     5a4:	0087d783          	lhu	a5,8(a5)
     5a8:	fcf42e23          	sw	a5,-36(s0)
     5ac:	fb042783          	lw	a5,-80(s0)
     5b0:	fcf42c23          	sw	a5,-40(s0)
     5b4:	1340006f          	j	6e8 <.L29>

000005b8 <.L32>:
     5b8:	fe042703          	lw	a4,-32(s0)
     5bc:	fa442783          	lw	a5,-92(s0)
     5c0:	04f71c63          	bne	a4,a5,618 <.L30>
     5c4:	fd842783          	lw	a5,-40(s0)
     5c8:	00479793          	slli	a5,a5,0x4
     5cc:	fc842703          	lw	a4,-56(s0)
     5d0:	01871713          	slli	a4,a4,0x18
     5d4:	00e78733          	add	a4,a5,a4
     5d8:	400007b7          	lui	a5,0x40000
     5dc:	00f707b3          	add	a5,a4,a5
     5e0:	00078713          	mv	a4,a5
     5e4:	fa042783          	lw	a5,-96(s0)
     5e8:	0007a583          	lw	a1,0(a5) # 40000000 <.LFE13+0x3fffdadc>
     5ec:	0047a603          	lw	a2,4(a5)
     5f0:	0087a683          	lw	a3,8(a5)
     5f4:	00c7a783          	lw	a5,12(a5)
     5f8:	00b72023          	sw	a1,0(a4)
     5fc:	00c72223          	sw	a2,4(a4)
     600:	00d72423          	sw	a3,8(a4)
     604:	00f72623          	sw	a5,12(a4)
     608:	fd842783          	lw	a5,-40(s0)
     60c:	00178793          	addi	a5,a5,1
     610:	fcf42c23          	sw	a5,-40(s0)
     614:	0c80006f          	j	6dc <.L31>

00000618 <.L30>:
     618:	fa842783          	lw	a5,-88(s0)
     61c:	0007a703          	lw	a4,0(a5)
     620:	fe042783          	lw	a5,-32(s0)
     624:	00100693          	li	a3,1
     628:	00f697b3          	sll	a5,a3,a5
     62c:	00f777b3          	and	a5,a4,a5
     630:	0a078663          	beqz	a5,6dc <.L31>
     634:	fd842783          	lw	a5,-40(s0)
     638:	00479793          	slli	a5,a5,0x4
     63c:	fc842703          	lw	a4,-56(s0)
     640:	01871713          	slli	a4,a4,0x18
     644:	00e78733          	add	a4,a5,a4
     648:	400007b7          	lui	a5,0x40000
     64c:	00f707b3          	add	a5,a4,a5
     650:	00079523          	sh	zero,10(a5) # 4000000a <.LFE13+0x3fffdae6>
     654:	fd842783          	lw	a5,-40(s0)
     658:	00479793          	slli	a5,a5,0x4
     65c:	fc842703          	lw	a4,-56(s0)
     660:	01871713          	slli	a4,a4,0x18
     664:	00e78733          	add	a4,a5,a4
     668:	400007b7          	lui	a5,0x40000
     66c:	00f707b3          	add	a5,a4,a5
     670:	0007a023          	sw	zero,0(a5) # 40000000 <.LFE13+0x3fffdadc>
     674:	fd842783          	lw	a5,-40(s0)
     678:	00479793          	slli	a5,a5,0x4
     67c:	fc842703          	lw	a4,-56(s0)
     680:	01871713          	slli	a4,a4,0x18
     684:	00e78733          	add	a4,a5,a4
     688:	400007b7          	lui	a5,0x40000
     68c:	00f707b3          	add	a5,a4,a5
     690:	00078713          	mv	a4,a5
     694:	00100793          	li	a5,1
     698:	00f72223          	sw	a5,4(a4)
     69c:	fd842783          	lw	a5,-40(s0)
     6a0:	00479793          	slli	a5,a5,0x4
     6a4:	fc842703          	lw	a4,-56(s0)
     6a8:	01871713          	slli	a4,a4,0x18
     6ac:	00e78733          	add	a4,a5,a4
     6b0:	400007b7          	lui	a5,0x40000
     6b4:	00f707b3          	add	a5,a4,a5
     6b8:	00078713          	mv	a4,a5
     6bc:	fdc42783          	lw	a5,-36(s0)
     6c0:	00f72623          	sw	a5,12(a4)
     6c4:	fd842783          	lw	a5,-40(s0)
     6c8:	00178793          	addi	a5,a5,1 # 40000001 <.LFE13+0x3fffdadd>
     6cc:	fcf42c23          	sw	a5,-40(s0)
     6d0:	fdc42783          	lw	a5,-36(s0)
     6d4:	00178793          	addi	a5,a5,1
     6d8:	fcf42e23          	sw	a5,-36(s0)

000006dc <.L31>:
     6dc:	fe042783          	lw	a5,-32(s0)
     6e0:	00178793          	addi	a5,a5,1
     6e4:	fef42023          	sw	a5,-32(s0)

000006e8 <.L29>:
     6e8:	fe042703          	lw	a4,-32(s0)
     6ec:	00f00793          	li	a5,15
     6f0:	ece7f4e3          	bgeu	a5,a4,5b8 <.L32>

000006f4 <.LBE7>:
     6f4:	fb042783          	lw	a5,-80(s0)
     6f8:	01079713          	slli	a4,a5,0x10
     6fc:	01075713          	srli	a4,a4,0x10
     700:	fa842783          	lw	a5,-88(s0)
     704:	00e79423          	sh	a4,8(a5)
     708:	fa842783          	lw	a5,-88(s0)
     70c:	00a7d783          	lhu	a5,10(a5)
     710:	eff7f793          	andi	a5,a5,-257
     714:	01079713          	slli	a4,a5,0x10
     718:	01075713          	srli	a4,a4,0x10
     71c:	fa842783          	lw	a5,-88(s0)
     720:	00e79523          	sh	a4,10(a5)

00000724 <.LBE6>:
     724:	2080006f          	j	92c <.L33>

00000728 <.L28>:
     728:	fa842783          	lw	a5,-88(s0)
     72c:	0007a783          	lw	a5,0(a5)
     730:	06079a63          	bnez	a5,7a4 <.L34>
     734:	00100593          	li	a1,1
     738:	fc842503          	lw	a0,-56(s0)
     73c:	00000097          	auipc	ra,0x0
     740:	000080e7          	jalr	ra # 73c <.L28+0x14>
     744:	00050793          	mv	a5,a0
     748:	01079713          	slli	a4,a5,0x10
     74c:	01075713          	srli	a4,a4,0x10
     750:	fa842783          	lw	a5,-88(s0)
     754:	00e79423          	sh	a4,8(a5)
     758:	fa842783          	lw	a5,-88(s0)
     75c:	0087d783          	lhu	a5,8(a5)
     760:	00479793          	slli	a5,a5,0x4
     764:	fc842703          	lw	a4,-56(s0)
     768:	01871713          	slli	a4,a4,0x18
     76c:	00e78733          	add	a4,a5,a4
     770:	400007b7          	lui	a5,0x40000
     774:	00f707b3          	add	a5,a4,a5
     778:	00078713          	mv	a4,a5
     77c:	fa042783          	lw	a5,-96(s0)
     780:	0007a583          	lw	a1,0(a5) # 40000000 <.LFE13+0x3fffdadc>
     784:	0047a603          	lw	a2,4(a5)
     788:	0087a683          	lw	a3,8(a5)
     78c:	00c7a783          	lw	a5,12(a5)
     790:	00b72023          	sw	a1,0(a4)
     794:	00c72223          	sw	a2,4(a4)
     798:	00d72423          	sw	a3,8(a4)
     79c:	00f72623          	sw	a5,12(a4)
     7a0:	18c0006f          	j	92c <.L33>

000007a4 <.L34>:
     7a4:	fa842783          	lw	a5,-88(s0)
     7a8:	0007a783          	lw	a5,0(a5)
     7ac:	00078513          	mv	a0,a5
     7b0:	00000097          	auipc	ra,0x0
     7b4:	000080e7          	jalr	ra # 7b0 <.L34+0xc>
     7b8:	faa42e23          	sw	a0,-68(s0)
     7bc:	fbc42783          	lw	a5,-68(s0)
     7c0:	00178793          	addi	a5,a5,1
     7c4:	00078593          	mv	a1,a5
     7c8:	fc842503          	lw	a0,-56(s0)
     7cc:	00000097          	auipc	ra,0x0
     7d0:	000080e7          	jalr	ra # 7cc <.L34+0x28>
     7d4:	faa42c23          	sw	a0,-72(s0)

000007d8 <.LBB9>:
     7d8:	fc042a23          	sw	zero,-44(s0)
     7dc:	fa842783          	lw	a5,-88(s0)
     7e0:	0087d783          	lhu	a5,8(a5)
     7e4:	fcf42823          	sw	a5,-48(s0)
     7e8:	fb842783          	lw	a5,-72(s0)
     7ec:	fcf42623          	sw	a5,-52(s0)
     7f0:	1000006f          	j	8f0 <.L35>

000007f4 <.L38>:
     7f4:	fd442703          	lw	a4,-44(s0)
     7f8:	fa442783          	lw	a5,-92(s0)
     7fc:	04f71c63          	bne	a4,a5,854 <.L36>
     800:	fcc42783          	lw	a5,-52(s0)
     804:	00479793          	slli	a5,a5,0x4
     808:	fc842703          	lw	a4,-56(s0)
     80c:	01871713          	slli	a4,a4,0x18
     810:	00e78733          	add	a4,a5,a4
     814:	400007b7          	lui	a5,0x40000
     818:	00f707b3          	add	a5,a4,a5
     81c:	00078713          	mv	a4,a5
     820:	fa042783          	lw	a5,-96(s0)
     824:	0007a583          	lw	a1,0(a5) # 40000000 <.LFE13+0x3fffdadc>
     828:	0047a603          	lw	a2,4(a5)
     82c:	0087a683          	lw	a3,8(a5)
     830:	00c7a783          	lw	a5,12(a5)
     834:	00b72023          	sw	a1,0(a4)
     838:	00c72223          	sw	a2,4(a4)
     83c:	00d72423          	sw	a3,8(a4)
     840:	00f72623          	sw	a5,12(a4)
     844:	fcc42783          	lw	a5,-52(s0)
     848:	00178793          	addi	a5,a5,1
     84c:	fcf42623          	sw	a5,-52(s0)
     850:	0940006f          	j	8e4 <.L37>

00000854 <.L36>:
     854:	fa842783          	lw	a5,-88(s0)
     858:	0007a703          	lw	a4,0(a5)
     85c:	fd442783          	lw	a5,-44(s0)
     860:	00100693          	li	a3,1
     864:	00f697b3          	sll	a5,a3,a5
     868:	00f777b3          	and	a5,a4,a5
     86c:	06078c63          	beqz	a5,8e4 <.L37>
     870:	fd042783          	lw	a5,-48(s0)
     874:	00479793          	slli	a5,a5,0x4
     878:	fc842703          	lw	a4,-56(s0)
     87c:	01871713          	slli	a4,a4,0x18
     880:	00e78733          	add	a4,a5,a4
     884:	400007b7          	lui	a5,0x40000
     888:	00f707b3          	add	a5,a4,a5
     88c:	00078713          	mv	a4,a5
     890:	fcc42783          	lw	a5,-52(s0)
     894:	00479793          	slli	a5,a5,0x4
     898:	fc842683          	lw	a3,-56(s0)
     89c:	01869693          	slli	a3,a3,0x18
     8a0:	00d786b3          	add	a3,a5,a3
     8a4:	400007b7          	lui	a5,0x40000
     8a8:	00f687b3          	add	a5,a3,a5
     8ac:	00072583          	lw	a1,0(a4)
     8b0:	00472603          	lw	a2,4(a4)
     8b4:	00872683          	lw	a3,8(a4)
     8b8:	00c72703          	lw	a4,12(a4)
     8bc:	00b7a023          	sw	a1,0(a5) # 40000000 <.LFE13+0x3fffdadc>
     8c0:	00c7a223          	sw	a2,4(a5)
     8c4:	00d7a423          	sw	a3,8(a5)
     8c8:	00e7a623          	sw	a4,12(a5)
     8cc:	fcc42783          	lw	a5,-52(s0)
     8d0:	00178793          	addi	a5,a5,1
     8d4:	fcf42623          	sw	a5,-52(s0)
     8d8:	fd042783          	lw	a5,-48(s0)
     8dc:	00178793          	addi	a5,a5,1
     8e0:	fcf42823          	sw	a5,-48(s0)

000008e4 <.L37>:
     8e4:	fd442783          	lw	a5,-44(s0)
     8e8:	00178793          	addi	a5,a5,1
     8ec:	fcf42a23          	sw	a5,-44(s0)

000008f0 <.L35>:
     8f0:	fd442703          	lw	a4,-44(s0)
     8f4:	00f00793          	li	a5,15
     8f8:	eee7fee3          	bgeu	a5,a4,7f4 <.L38>

000008fc <.LBE9>:
     8fc:	fa842783          	lw	a5,-88(s0)
     900:	0087d783          	lhu	a5,8(a5)
     904:	fbc42603          	lw	a2,-68(s0)
     908:	00078593          	mv	a1,a5
     90c:	fc842503          	lw	a0,-56(s0)
     910:	00000097          	auipc	ra,0x0
     914:	000080e7          	jalr	ra # 910 <.LBE9+0x14>
     918:	fb842783          	lw	a5,-72(s0)
     91c:	01079713          	slli	a4,a5,0x10
     920:	01075713          	srli	a4,a4,0x10
     924:	fa842783          	lw	a5,-88(s0)
     928:	00e79423          	sh	a4,8(a5)

0000092c <.L33>:
     92c:	fa842783          	lw	a5,-88(s0)
     930:	0007a703          	lw	a4,0(a5)
     934:	fa442783          	lw	a5,-92(s0)
     938:	00100693          	li	a3,1
     93c:	00f697b3          	sll	a5,a3,a5
     940:	00f76733          	or	a4,a4,a5
     944:	fa842783          	lw	a5,-88(s0)
     948:	00e7a023          	sw	a4,0(a5)

0000094c <.L20>:
     94c:	05c12083          	lw	ra,92(sp)
     950:	05812403          	lw	s0,88(sp)
     954:	06010113          	addi	sp,sp,96
     958:	00008067          	ret

0000095c <_insert_leaf>:
     95c:	fc010113          	addi	sp,sp,-64
     960:	02112e23          	sw	ra,60(sp)
     964:	02812c23          	sw	s0,56(sp)
     968:	04010413          	addi	s0,sp,64
     96c:	fca42623          	sw	a0,-52(s0)
     970:	fcb42423          	sw	a1,-56(s0)
     974:	fcc42223          	sw	a2,-60(s0)
     978:	00068793          	mv	a5,a3
     97c:	fcf401a3          	sb	a5,-61(s0)
     980:	fc842783          	lw	a5,-56(s0)
     984:	0047a783          	lw	a5,4(a5)
     988:	00078513          	mv	a0,a5
     98c:	00000097          	auipc	ra,0x0
     990:	000080e7          	jalr	ra # 98c <_insert_leaf+0x30>
     994:	fea42023          	sw	a0,-32(s0)
     998:	fe042783          	lw	a5,-32(s0)
     99c:	02079e63          	bnez	a5,9d8 <.L40>
     9a0:	00100513          	li	a0,1
     9a4:	00000097          	auipc	ra,0x0
     9a8:	000080e7          	jalr	ra # 9a4 <_insert_leaf+0x48>
     9ac:	00050793          	mv	a5,a0
     9b0:	00078713          	mv	a4,a5
     9b4:	fc842783          	lw	a5,-56(s0)
     9b8:	00e7a623          	sw	a4,12(a5)
     9bc:	fc842783          	lw	a5,-56(s0)
     9c0:	00c7a703          	lw	a4,12(a5)
     9c4:	500007b7          	lui	a5,0x50000
     9c8:	00f707b3          	add	a5,a4,a5
     9cc:	fc344703          	lbu	a4,-61(s0)
     9d0:	00e78023          	sb	a4,0(a5) # 50000000 <.LFE13+0x4fffdadc>
     9d4:	1000006f          	j	ad4 <.L41>

000009d8 <.L40>:
     9d8:	fe042783          	lw	a5,-32(s0)
     9dc:	00178793          	addi	a5,a5,1
     9e0:	00078513          	mv	a0,a5
     9e4:	00000097          	auipc	ra,0x0
     9e8:	000080e7          	jalr	ra # 9e4 <.L40+0xc>
     9ec:	fca42e23          	sw	a0,-36(s0)

000009f0 <.LBB11>:
     9f0:	00100793          	li	a5,1
     9f4:	fef42623          	sw	a5,-20(s0)
     9f8:	fc842783          	lw	a5,-56(s0)
     9fc:	00c7a783          	lw	a5,12(a5)
     a00:	fef42423          	sw	a5,-24(s0)
     a04:	fdc42783          	lw	a5,-36(s0)
     a08:	fef42223          	sw	a5,-28(s0)
     a0c:	0980006f          	j	aa4 <.L42>

00000a10 <.L45>:
     a10:	fec42703          	lw	a4,-20(s0)
     a14:	fc442783          	lw	a5,-60(s0)
     a18:	02f71463          	bne	a4,a5,a40 <.L43>
     a1c:	fe442703          	lw	a4,-28(s0)
     a20:	500007b7          	lui	a5,0x50000
     a24:	00f707b3          	add	a5,a4,a5
     a28:	fc344703          	lbu	a4,-61(s0)
     a2c:	00e78023          	sb	a4,0(a5) # 50000000 <.LFE13+0x4fffdadc>
     a30:	fe442783          	lw	a5,-28(s0)
     a34:	00178793          	addi	a5,a5,1
     a38:	fef42223          	sw	a5,-28(s0)
     a3c:	05c0006f          	j	a98 <.L44>

00000a40 <.L43>:
     a40:	fc842783          	lw	a5,-56(s0)
     a44:	0047a703          	lw	a4,4(a5)
     a48:	fec42783          	lw	a5,-20(s0)
     a4c:	00100693          	li	a3,1
     a50:	00f697b3          	sll	a5,a3,a5
     a54:	00f777b3          	and	a5,a4,a5
     a58:	04078063          	beqz	a5,a98 <.L44>
     a5c:	fe842703          	lw	a4,-24(s0)
     a60:	500007b7          	lui	a5,0x50000
     a64:	00f70733          	add	a4,a4,a5
     a68:	fe442683          	lw	a3,-28(s0)
     a6c:	500007b7          	lui	a5,0x50000
     a70:	00f687b3          	add	a5,a3,a5
     a74:	00074703          	lbu	a4,0(a4)
     a78:	0ff77713          	andi	a4,a4,255
     a7c:	00e78023          	sb	a4,0(a5) # 50000000 <.LFE13+0x4fffdadc>
     a80:	fe442783          	lw	a5,-28(s0)
     a84:	00178793          	addi	a5,a5,1
     a88:	fef42223          	sw	a5,-28(s0)
     a8c:	fe842783          	lw	a5,-24(s0)
     a90:	00178793          	addi	a5,a5,1
     a94:	fef42423          	sw	a5,-24(s0)

00000a98 <.L44>:
     a98:	fec42783          	lw	a5,-20(s0)
     a9c:	00178793          	addi	a5,a5,1
     aa0:	fef42623          	sw	a5,-20(s0)

00000aa4 <.L42>:
     aa4:	fec42703          	lw	a4,-20(s0)
     aa8:	00f00793          	li	a5,15
     aac:	f6e7f2e3          	bgeu	a5,a4,a10 <.L45>

00000ab0 <.LBE11>:
     ab0:	fc842783          	lw	a5,-56(s0)
     ab4:	00c7a783          	lw	a5,12(a5)
     ab8:	fe042583          	lw	a1,-32(s0)
     abc:	00078513          	mv	a0,a5
     ac0:	00000097          	auipc	ra,0x0
     ac4:	000080e7          	jalr	ra # ac0 <.LBE11+0x10>
     ac8:	fdc42703          	lw	a4,-36(s0)
     acc:	fc842783          	lw	a5,-56(s0)
     ad0:	00e7a623          	sw	a4,12(a5)

00000ad4 <.L41>:
     ad4:	fc842783          	lw	a5,-56(s0)
     ad8:	0047a703          	lw	a4,4(a5)
     adc:	fc442783          	lw	a5,-60(s0)
     ae0:	00100693          	li	a3,1
     ae4:	00f697b3          	sll	a5,a3,a5
     ae8:	00f76733          	or	a4,a4,a5
     aec:	fc842783          	lw	a5,-56(s0)
     af0:	00e7a223          	sw	a4,4(a5)
     af4:	00000013          	nop
     af8:	03c12083          	lw	ra,60(sp)
     afc:	03812403          	lw	s0,56(sp)
     b00:	04010113          	addi	sp,sp,64
     b04:	00008067          	ret

00000b08 <_remove_leaf>:
     b08:	fd010113          	addi	sp,sp,-48
     b0c:	02112623          	sw	ra,44(sp)
     b10:	02812423          	sw	s0,40(sp)
     b14:	03010413          	addi	s0,sp,48
     b18:	fca42e23          	sw	a0,-36(s0)
     b1c:	fcb42c23          	sw	a1,-40(s0)
     b20:	fcc42a23          	sw	a2,-44(s0)
     b24:	fd842783          	lw	a5,-40(s0)
     b28:	0047a703          	lw	a4,4(a5)
     b2c:	fd442783          	lw	a5,-44(s0)
     b30:	00200693          	li	a3,2
     b34:	00f697b3          	sll	a5,a3,a5
     b38:	fff78793          	addi	a5,a5,-1
     b3c:	00f777b3          	and	a5,a4,a5
     b40:	00078513          	mv	a0,a5
     b44:	00000097          	auipc	ra,0x0
     b48:	000080e7          	jalr	ra # b44 <_remove_leaf+0x3c>
     b4c:	fea42623          	sw	a0,-20(s0)
     b50:	fec42703          	lw	a4,-20(s0)
     b54:	00100793          	li	a5,1
     b58:	02e7ca63          	blt	a5,a4,b8c <.L47>
     b5c:	fd842783          	lw	a5,-40(s0)
     b60:	00c7a783          	lw	a5,12(a5)
     b64:	00100593          	li	a1,1
     b68:	00078513          	mv	a0,a5
     b6c:	00000097          	auipc	ra,0x0
     b70:	000080e7          	jalr	ra # b6c <_remove_leaf+0x64>
     b74:	fd842783          	lw	a5,-40(s0)
     b78:	00c7a783          	lw	a5,12(a5)
     b7c:	00178713          	addi	a4,a5,1
     b80:	fd842783          	lw	a5,-40(s0)
     b84:	00e7a623          	sw	a4,12(a5)
     b88:	0a40006f          	j	c2c <.L48>

00000b8c <.L47>:
     b8c:	fd842783          	lw	a5,-40(s0)
     b90:	00c7a703          	lw	a4,12(a5)
     b94:	fec42783          	lw	a5,-20(s0)
     b98:	00f707b3          	add	a5,a4,a5
     b9c:	fff78793          	addi	a5,a5,-1
     ba0:	fef42623          	sw	a5,-20(s0)

00000ba4 <.LBB12>:
     ba4:	fd442783          	lw	a5,-44(s0)
     ba8:	00178793          	addi	a5,a5,1
     bac:	fef42423          	sw	a5,-24(s0)
     bb0:	0600006f          	j	c10 <.L49>

00000bb4 <.L51>:
     bb4:	fd842783          	lw	a5,-40(s0)
     bb8:	0047a703          	lw	a4,4(a5)
     bbc:	fe842783          	lw	a5,-24(s0)
     bc0:	00100693          	li	a3,1
     bc4:	00f697b3          	sll	a5,a3,a5
     bc8:	00f777b3          	and	a5,a4,a5
     bcc:	02078c63          	beqz	a5,c04 <.L50>
     bd0:	fec42703          	lw	a4,-20(s0)
     bd4:	500007b7          	lui	a5,0x50000
     bd8:	00178793          	addi	a5,a5,1 # 50000001 <.LFE13+0x4fffdadd>
     bdc:	00f70733          	add	a4,a4,a5
     be0:	fec42683          	lw	a3,-20(s0)
     be4:	500007b7          	lui	a5,0x50000
     be8:	00f687b3          	add	a5,a3,a5
     bec:	00074703          	lbu	a4,0(a4)
     bf0:	0ff77713          	andi	a4,a4,255
     bf4:	00e78023          	sb	a4,0(a5) # 50000000 <.LFE13+0x4fffdadc>
     bf8:	fec42783          	lw	a5,-20(s0)
     bfc:	00178793          	addi	a5,a5,1
     c00:	fef42623          	sw	a5,-20(s0)

00000c04 <.L50>:
     c04:	fe842783          	lw	a5,-24(s0)
     c08:	00178793          	addi	a5,a5,1
     c0c:	fef42423          	sw	a5,-24(s0)

00000c10 <.L49>:
     c10:	fe842703          	lw	a4,-24(s0)
     c14:	00f00793          	li	a5,15
     c18:	f8e7fee3          	bgeu	a5,a4,bb4 <.L51>

00000c1c <.LBE12>:
     c1c:	00100593          	li	a1,1
     c20:	fec42503          	lw	a0,-20(s0)
     c24:	00000097          	auipc	ra,0x0
     c28:	000080e7          	jalr	ra # c24 <.LBE12+0x8>

00000c2c <.L48>:
     c2c:	fd842783          	lw	a5,-40(s0)
     c30:	0047a703          	lw	a4,4(a5)
     c34:	fd442783          	lw	a5,-44(s0)
     c38:	00100693          	li	a3,1
     c3c:	00f697b3          	sll	a5,a3,a5
     c40:	fff7c793          	not	a5,a5
     c44:	00f77733          	and	a4,a4,a5
     c48:	fd842783          	lw	a5,-40(s0)
     c4c:	00e7a223          	sw	a4,4(a5)
     c50:	00000013          	nop
     c54:	02c12083          	lw	ra,44(sp)
     c58:	02812403          	lw	s0,40(sp)
     c5c:	03010113          	addi	sp,sp,48
     c60:	00008067          	ret

00000c64 <_remove_lin>:
     c64:	fd010113          	addi	sp,sp,-48
     c68:	02112623          	sw	ra,44(sp)
     c6c:	02812423          	sw	s0,40(sp)
     c70:	03010413          	addi	s0,sp,48
     c74:	fca42e23          	sw	a0,-36(s0)
     c78:	fcb42c23          	sw	a1,-40(s0)
     c7c:	fcc42a23          	sw	a2,-44(s0)
     c80:	fd842783          	lw	a5,-40(s0)
     c84:	0007a703          	lw	a4,0(a5)
     c88:	fd442783          	lw	a5,-44(s0)
     c8c:	00200693          	li	a3,2
     c90:	00f697b3          	sll	a5,a3,a5
     c94:	fff78793          	addi	a5,a5,-1
     c98:	00f777b3          	and	a5,a4,a5
     c9c:	00078513          	mv	a0,a5
     ca0:	00000097          	auipc	ra,0x0
     ca4:	000080e7          	jalr	ra # ca0 <_remove_lin+0x3c>
     ca8:	fea42623          	sw	a0,-20(s0)
     cac:	fec42703          	lw	a4,-20(s0)
     cb0:	00100793          	li	a5,1
     cb4:	02e7ce63          	blt	a5,a4,cf0 <.L53>
     cb8:	fd842783          	lw	a5,-40(s0)
     cbc:	0087d783          	lhu	a5,8(a5)
     cc0:	00100593          	li	a1,1
     cc4:	00078513          	mv	a0,a5
     cc8:	00000097          	auipc	ra,0x0
     ccc:	000080e7          	jalr	ra # cc8 <_remove_lin+0x64>
     cd0:	fd842783          	lw	a5,-40(s0)
     cd4:	00a7d783          	lhu	a5,10(a5)
     cd8:	eff7f793          	andi	a5,a5,-257
     cdc:	01079713          	slli	a4,a5,0x10
     ce0:	01075713          	srli	a4,a4,0x10
     ce4:	fd842783          	lw	a5,-40(s0)
     ce8:	00e79523          	sh	a4,10(a5)
     cec:	0a80006f          	j	d94 <.L54>

00000cf0 <.L53>:
     cf0:	fd842783          	lw	a5,-40(s0)
     cf4:	0087d783          	lhu	a5,8(a5)
     cf8:	00078713          	mv	a4,a5
     cfc:	fec42783          	lw	a5,-20(s0)
     d00:	00f707b3          	add	a5,a4,a5
     d04:	fff78793          	addi	a5,a5,-1
     d08:	fef42623          	sw	a5,-20(s0)

00000d0c <.LBB13>:
     d0c:	fd442783          	lw	a5,-44(s0)
     d10:	00178793          	addi	a5,a5,1
     d14:	fef42423          	sw	a5,-24(s0)
     d18:	0600006f          	j	d78 <.L55>

00000d1c <.L57>:
     d1c:	fd842783          	lw	a5,-40(s0)
     d20:	0007a703          	lw	a4,0(a5)
     d24:	fe842783          	lw	a5,-24(s0)
     d28:	00100693          	li	a3,1
     d2c:	00f697b3          	sll	a5,a3,a5
     d30:	00f777b3          	and	a5,a4,a5
     d34:	02078c63          	beqz	a5,d6c <.L56>
     d38:	fec42703          	lw	a4,-20(s0)
     d3c:	500007b7          	lui	a5,0x50000
     d40:	00178793          	addi	a5,a5,1 # 50000001 <.LFE13+0x4fffdadd>
     d44:	00f70733          	add	a4,a4,a5
     d48:	fec42683          	lw	a3,-20(s0)
     d4c:	500007b7          	lui	a5,0x50000
     d50:	00f687b3          	add	a5,a3,a5
     d54:	00074703          	lbu	a4,0(a4)
     d58:	0ff77713          	andi	a4,a4,255
     d5c:	00e78023          	sb	a4,0(a5) # 50000000 <.LFE13+0x4fffdadc>
     d60:	fec42783          	lw	a5,-20(s0)
     d64:	00178793          	addi	a5,a5,1
     d68:	fef42623          	sw	a5,-20(s0)

00000d6c <.L56>:
     d6c:	fe842783          	lw	a5,-24(s0)
     d70:	00178793          	addi	a5,a5,1
     d74:	fef42423          	sw	a5,-24(s0)

00000d78 <.L55>:
     d78:	fe842703          	lw	a4,-24(s0)
     d7c:	00f00793          	li	a5,15
     d80:	f8e7fee3          	bgeu	a5,a4,d1c <.L57>

00000d84 <.LBE13>:
     d84:	00100593          	li	a1,1
     d88:	fec42503          	lw	a0,-20(s0)
     d8c:	00000097          	auipc	ra,0x0
     d90:	000080e7          	jalr	ra # d8c <.LBE13+0x8>

00000d94 <.L54>:
     d94:	fd842783          	lw	a5,-40(s0)
     d98:	0007a703          	lw	a4,0(a5)
     d9c:	fd442783          	lw	a5,-44(s0)
     da0:	00100693          	li	a3,1
     da4:	00f697b3          	sll	a5,a3,a5
     da8:	fff7c793          	not	a5,a5
     dac:	00f77733          	and	a4,a4,a5
     db0:	fd842783          	lw	a5,-40(s0)
     db4:	00e7a023          	sw	a4,0(a5)
     db8:	00000013          	nop
     dbc:	02c12083          	lw	ra,44(sp)
     dc0:	02812403          	lw	s0,40(sp)
     dc4:	03010113          	addi	sp,sp,48
     dc8:	00008067          	ret

00000dcc <insert_entry>:
     dcc:	f9010113          	addi	sp,sp,-112
     dd0:	06112623          	sw	ra,108(sp)
     dd4:	06812423          	sw	s0,104(sp)
     dd8:	06912223          	sw	s1,100(sp)
     ddc:	07212023          	sw	s2,96(sp)
     de0:	05312e23          	sw	s3,92(sp)
     de4:	07010413          	addi	s0,sp,112
     de8:	faa42623          	sw	a0,-84(s0)
     dec:	fab42423          	sw	a1,-88(s0)
     df0:	00060493          	mv	s1,a2
     df4:	fad42223          	sw	a3,-92(s0)
     df8:	00070793          	mv	a5,a4
     dfc:	faf401a3          	sb	a5,-93(s0)
     e00:	fac42783          	lw	a5,-84(s0)
     e04:	00378793          	addi	a5,a5,3
     e08:	fa442703          	lw	a4,-92(s0)
     e0c:	0ee7c863          	blt	a5,a4,efc <.L59>

00000e10 <.LBB14>:
     e10:	fa442703          	lw	a4,-92(s0)
     e14:	fac42783          	lw	a5,-84(s0)
     e18:	40f707b3          	sub	a5,a4,a5
     e1c:	faf42c23          	sw	a5,-72(s0)
     e20:	0004a603          	lw	a2,0(s1)
     e24:	0044a683          	lw	a3,4(s1)
     e28:	0084a703          	lw	a4,8(s1)
     e2c:	00c4a783          	lw	a5,12(s1)
     e30:	f8c42823          	sw	a2,-112(s0)
     e34:	f8d42a23          	sw	a3,-108(s0)
     e38:	f8e42c23          	sw	a4,-104(s0)
     e3c:	f8f42e23          	sw	a5,-100(s0)
     e40:	f9040793          	addi	a5,s0,-112
     e44:	fb842603          	lw	a2,-72(s0)
     e48:	fac42583          	lw	a1,-84(s0)
     e4c:	00078513          	mv	a0,a5
     e50:	00000097          	auipc	ra,0x0
     e54:	000080e7          	jalr	ra # e50 <.LBB14+0x40>
     e58:	00050693          	mv	a3,a0
     e5c:	fb842783          	lw	a5,-72(s0)
     e60:	00100713          	li	a4,1
     e64:	00f717b3          	sll	a5,a4,a5
     e68:	00f6e7b3          	or	a5,a3,a5
     e6c:	faf42a23          	sw	a5,-76(s0)
     e70:	fa842783          	lw	a5,-88(s0)
     e74:	0047a703          	lw	a4,4(a5)
     e78:	fb442783          	lw	a5,-76(s0)
     e7c:	00100693          	li	a3,1
     e80:	00f697b3          	sll	a5,a3,a5
     e84:	00f777b3          	and	a5,a4,a5
     e88:	04078a63          	beqz	a5,edc <.L60>
     e8c:	fa842783          	lw	a5,-88(s0)
     e90:	00c7a483          	lw	s1,12(a5)
     e94:	fa842783          	lw	a5,-88(s0)
     e98:	0047a703          	lw	a4,4(a5)
     e9c:	fb442783          	lw	a5,-76(s0)
     ea0:	00200693          	li	a3,2
     ea4:	00f697b3          	sll	a5,a3,a5
     ea8:	fff78793          	addi	a5,a5,-1
     eac:	00f777b3          	and	a5,a4,a5
     eb0:	00078513          	mv	a0,a5
     eb4:	00000097          	auipc	ra,0x0
     eb8:	000080e7          	jalr	ra # eb4 <.LBB14+0xa4>
     ebc:	00050793          	mv	a5,a0
     ec0:	00f48733          	add	a4,s1,a5
     ec4:	500007b7          	lui	a5,0x50000
     ec8:	fff78793          	addi	a5,a5,-1 # 4fffffff <.LFE13+0x4fffdadb>
     ecc:	00f707b3          	add	a5,a4,a5
     ed0:	fa344703          	lbu	a4,-93(s0)
     ed4:	00e78023          	sb	a4,0(a5)
     ed8:	3dc0006f          	j	12b4 <.L58>

00000edc <.L60>:
     edc:	fa344783          	lbu	a5,-93(s0)
     ee0:	00078693          	mv	a3,a5
     ee4:	fb442603          	lw	a2,-76(s0)
     ee8:	fa842583          	lw	a1,-88(s0)
     eec:	fac42503          	lw	a0,-84(s0)
     ef0:	00000097          	auipc	ra,0x0
     ef4:	000080e7          	jalr	ra # ef0 <.L60+0x14>
     ef8:	3bc0006f          	j	12b4 <.L58>

00000efc <.L59>:
     efc:	0004a603          	lw	a2,0(s1)
     f00:	0044a683          	lw	a3,4(s1)
     f04:	0084a703          	lw	a4,8(s1)
     f08:	00c4a783          	lw	a5,12(s1)
     f0c:	f8c42823          	sw	a2,-112(s0)
     f10:	f8d42a23          	sw	a3,-108(s0)
     f14:	f8e42c23          	sw	a4,-104(s0)
     f18:	f8f42e23          	sw	a5,-100(s0)
     f1c:	f9040793          	addi	a5,s0,-112
     f20:	00400613          	li	a2,4
     f24:	fac42583          	lw	a1,-84(s0)
     f28:	00078513          	mv	a0,a5
     f2c:	00000097          	auipc	ra,0x0
     f30:	000080e7          	jalr	ra # f2c <.L59+0x30>
     f34:	fca42823          	sw	a0,-48(s0)
     f38:	fa842783          	lw	a5,-88(s0)
     f3c:	0007a703          	lw	a4,0(a5)
     f40:	fd042783          	lw	a5,-48(s0)
     f44:	00100693          	li	a3,1
     f48:	00f697b3          	sll	a5,a3,a5
     f4c:	00f777b3          	and	a5,a4,a5
     f50:	2a078e63          	beqz	a5,120c <.L62>

00000f54 <.LBB16>:
     f54:	fa842783          	lw	a5,-88(s0)
     f58:	00a7d783          	lhu	a5,10(a5)
     f5c:	1007f793          	andi	a5,a5,256
     f60:	06078663          	beqz	a5,fcc <.L63>
     f64:	fac42783          	lw	a5,-84(s0)
     f68:	00478793          	addi	a5,a5,4
     f6c:	fa442703          	lw	a4,-92(s0)
     f70:	04f71e63          	bne	a4,a5,fcc <.L63>
     f74:	fa842783          	lw	a5,-88(s0)
     f78:	0087d783          	lhu	a5,8(a5)
     f7c:	00078493          	mv	s1,a5
     f80:	fa842783          	lw	a5,-88(s0)
     f84:	0007a703          	lw	a4,0(a5)
     f88:	fd042783          	lw	a5,-48(s0)
     f8c:	00200693          	li	a3,2
     f90:	00f697b3          	sll	a5,a3,a5
     f94:	fff78793          	addi	a5,a5,-1
     f98:	00f777b3          	and	a5,a4,a5
     f9c:	00078513          	mv	a0,a5
     fa0:	00000097          	auipc	ra,0x0
     fa4:	000080e7          	jalr	ra # fa0 <.LBB16+0x4c>
     fa8:	00050793          	mv	a5,a0
     fac:	00f487b3          	add	a5,s1,a5
     fb0:	00078713          	mv	a4,a5
     fb4:	500007b7          	lui	a5,0x50000
     fb8:	fff78793          	addi	a5,a5,-1 # 4fffffff <.LFE13+0x4fffdadb>
     fbc:	00f707b3          	add	a5,a4,a5
     fc0:	fa344703          	lbu	a4,-93(s0)
     fc4:	00e78023          	sb	a4,0(a5)
     fc8:	2ec0006f          	j	12b4 <.L58>

00000fcc <.L63>:
     fcc:	fac42783          	lw	a5,-84(s0)
     fd0:	00478793          	addi	a5,a5,4
     fd4:	41f7d713          	srai	a4,a5,0x1f
     fd8:	00f77713          	andi	a4,a4,15
     fdc:	00f707b3          	add	a5,a4,a5
     fe0:	4047d793          	srai	a5,a5,0x4
     fe4:	fcf42423          	sw	a5,-56(s0)
     fe8:	fa842783          	lw	a5,-88(s0)
     fec:	00a7d783          	lhu	a5,10(a5)
     ff0:	1007f793          	andi	a5,a5,256
     ff4:	16078863          	beqz	a5,1164 <.L64>
     ff8:	fac42783          	lw	a5,-84(s0)
     ffc:	00478793          	addi	a5,a5,4
    1000:	fa442703          	lw	a4,-92(s0)
    1004:	16f70063          	beq	a4,a5,1164 <.L64>

00001008 <.LBB17>:
    1008:	fa842783          	lw	a5,-88(s0)
    100c:	0007a783          	lw	a5,0(a5)
    1010:	00078513          	mv	a0,a5
    1014:	00000097          	auipc	ra,0x0
    1018:	000080e7          	jalr	ra # 1014 <.LBB17+0xc>
    101c:	fca42223          	sw	a0,-60(s0)
    1020:	fc442783          	lw	a5,-60(s0)
    1024:	00178793          	addi	a5,a5,1
    1028:	00078593          	mv	a1,a5
    102c:	fc842503          	lw	a0,-56(s0)
    1030:	00000097          	auipc	ra,0x0
    1034:	000080e7          	jalr	ra # 1030 <.LBB17+0x28>
    1038:	fca42023          	sw	a0,-64(s0)

0000103c <.LBB18>:
    103c:	fc042e23          	sw	zero,-36(s0)
    1040:	fa842783          	lw	a5,-88(s0)
    1044:	0087d783          	lhu	a5,8(a5)
    1048:	fcf42c23          	sw	a5,-40(s0)
    104c:	fc042783          	lw	a5,-64(s0)
    1050:	fcf42a23          	sw	a5,-44(s0)
    1054:	0d40006f          	j	1128 <.L65>

00001058 <.L67>:
    1058:	fa842783          	lw	a5,-88(s0)
    105c:	0007a703          	lw	a4,0(a5)
    1060:	fdc42783          	lw	a5,-36(s0)
    1064:	00100693          	li	a3,1
    1068:	00f697b3          	sll	a5,a3,a5
    106c:	00f777b3          	and	a5,a4,a5
    1070:	0a078663          	beqz	a5,111c <.L66>
    1074:	fd442783          	lw	a5,-44(s0)
    1078:	00479793          	slli	a5,a5,0x4
    107c:	fc842703          	lw	a4,-56(s0)
    1080:	01871713          	slli	a4,a4,0x18
    1084:	00e78733          	add	a4,a5,a4
    1088:	400007b7          	lui	a5,0x40000
    108c:	00f707b3          	add	a5,a4,a5
    1090:	00079523          	sh	zero,10(a5) # 4000000a <.LFE13+0x3fffdae6>
    1094:	fd442783          	lw	a5,-44(s0)
    1098:	00479793          	slli	a5,a5,0x4
    109c:	fc842703          	lw	a4,-56(s0)
    10a0:	01871713          	slli	a4,a4,0x18
    10a4:	00e78733          	add	a4,a5,a4
    10a8:	400007b7          	lui	a5,0x40000
    10ac:	00f707b3          	add	a5,a4,a5
    10b0:	0007a023          	sw	zero,0(a5) # 40000000 <.LFE13+0x3fffdadc>
    10b4:	fd442783          	lw	a5,-44(s0)
    10b8:	00479793          	slli	a5,a5,0x4
    10bc:	fc842703          	lw	a4,-56(s0)
    10c0:	01871713          	slli	a4,a4,0x18
    10c4:	00e78733          	add	a4,a5,a4
    10c8:	400007b7          	lui	a5,0x40000
    10cc:	00f707b3          	add	a5,a4,a5
    10d0:	00078713          	mv	a4,a5
    10d4:	00100793          	li	a5,1
    10d8:	00f72223          	sw	a5,4(a4)
    10dc:	fd442783          	lw	a5,-44(s0)
    10e0:	00479793          	slli	a5,a5,0x4
    10e4:	fc842703          	lw	a4,-56(s0)
    10e8:	01871713          	slli	a4,a4,0x18
    10ec:	00e78733          	add	a4,a5,a4
    10f0:	400007b7          	lui	a5,0x40000
    10f4:	00f707b3          	add	a5,a4,a5
    10f8:	00078713          	mv	a4,a5
    10fc:	fd842783          	lw	a5,-40(s0)
    1100:	00f72623          	sw	a5,12(a4)
    1104:	fd442783          	lw	a5,-44(s0)
    1108:	00178793          	addi	a5,a5,1 # 40000001 <.LFE13+0x3fffdadd>
    110c:	fcf42a23          	sw	a5,-44(s0)
    1110:	fd842783          	lw	a5,-40(s0)
    1114:	00178793          	addi	a5,a5,1
    1118:	fcf42c23          	sw	a5,-40(s0)

0000111c <.L66>:
    111c:	fdc42783          	lw	a5,-36(s0)
    1120:	00178793          	addi	a5,a5,1
    1124:	fcf42e23          	sw	a5,-36(s0)

00001128 <.L65>:
    1128:	fdc42703          	lw	a4,-36(s0)
    112c:	00f00793          	li	a5,15
    1130:	f2e7f4e3          	bgeu	a5,a4,1058 <.L67>

00001134 <.LBE18>:
    1134:	fc042783          	lw	a5,-64(s0)
    1138:	01079713          	slli	a4,a5,0x10
    113c:	01075713          	srli	a4,a4,0x10
    1140:	fa842783          	lw	a5,-88(s0)
    1144:	00e79423          	sh	a4,8(a5)
    1148:	fa842783          	lw	a5,-88(s0)
    114c:	00a7d783          	lhu	a5,10(a5)
    1150:	eff7f793          	andi	a5,a5,-257
    1154:	01079713          	slli	a4,a5,0x10
    1158:	01075713          	srli	a4,a4,0x10
    115c:	fa842783          	lw	a5,-88(s0)
    1160:	00e79523          	sh	a4,10(a5)

00001164 <.L64>:
    1164:	fc842783          	lw	a5,-56(s0)
    1168:	01879793          	slli	a5,a5,0x18
    116c:	00078913          	mv	s2,a5
    1170:	fa842783          	lw	a5,-88(s0)
    1174:	0087d783          	lhu	a5,8(a5)
    1178:	00078993          	mv	s3,a5
    117c:	fa842783          	lw	a5,-88(s0)
    1180:	0007a703          	lw	a4,0(a5)
    1184:	fd042783          	lw	a5,-48(s0)
    1188:	00200693          	li	a3,2
    118c:	00f697b3          	sll	a5,a3,a5
    1190:	fff78793          	addi	a5,a5,-1
    1194:	00f777b3          	and	a5,a4,a5
    1198:	00078513          	mv	a0,a5
    119c:	00000097          	auipc	ra,0x0
    11a0:	000080e7          	jalr	ra # 119c <.L64+0x38>
    11a4:	00050793          	mv	a5,a0
    11a8:	00f987b3          	add	a5,s3,a5
    11ac:	00479793          	slli	a5,a5,0x4
    11b0:	00f90733          	add	a4,s2,a5
    11b4:	400007b7          	lui	a5,0x40000
    11b8:	ff078793          	addi	a5,a5,-16 # 3ffffff0 <.LFE13+0x3fffdacc>
    11bc:	00f707b3          	add	a5,a4,a5
    11c0:	faf42e23          	sw	a5,-68(s0)
    11c4:	fac42783          	lw	a5,-84(s0)
    11c8:	00478513          	addi	a0,a5,4
    11cc:	0004a603          	lw	a2,0(s1)
    11d0:	0044a683          	lw	a3,4(s1)
    11d4:	0084a703          	lw	a4,8(s1)
    11d8:	00c4a783          	lw	a5,12(s1)
    11dc:	f8c42823          	sw	a2,-112(s0)
    11e0:	f8d42a23          	sw	a3,-108(s0)
    11e4:	f8e42c23          	sw	a4,-104(s0)
    11e8:	f8f42e23          	sw	a5,-100(s0)
    11ec:	fa344703          	lbu	a4,-93(s0)
    11f0:	f9040793          	addi	a5,s0,-112
    11f4:	fa442683          	lw	a3,-92(s0)
    11f8:	00078613          	mv	a2,a5
    11fc:	fbc42583          	lw	a1,-68(s0)
    1200:	00000097          	auipc	ra,0x0
    1204:	000080e7          	jalr	ra # 1200 <.L64+0x9c>

00001208 <.LBE16>:
    1208:	0ac0006f          	j	12b4 <.L58>

0000120c <.L62>:
    120c:	fac42783          	lw	a5,-84(s0)
    1210:	41f7d713          	srai	a4,a5,0x1f
    1214:	00377713          	andi	a4,a4,3
    1218:	00f707b3          	add	a5,a4,a5
    121c:	4027d793          	srai	a5,a5,0x2
    1220:	00178793          	addi	a5,a5,1
    1224:	00479713          	slli	a4,a5,0x4
    1228:	000007b7          	lui	a5,0x0
    122c:	00078793          	mv	a5,a5
    1230:	00f707b3          	add	a5,a4,a5
    1234:	fcf42623          	sw	a5,-52(s0)
    1238:	fcc42783          	lw	a5,-52(s0)
    123c:	0007a223          	sw	zero,4(a5) # 4 <popcnt+0x4>
    1240:	fcc42783          	lw	a5,-52(s0)
    1244:	0047a703          	lw	a4,4(a5)
    1248:	fcc42783          	lw	a5,-52(s0)
    124c:	00e7a023          	sw	a4,0(a5)
    1250:	fcc42783          	lw	a5,-52(s0)
    1254:	00079523          	sh	zero,10(a5)
    1258:	fac42783          	lw	a5,-84(s0)
    125c:	00478513          	addi	a0,a5,4
    1260:	0004a603          	lw	a2,0(s1)
    1264:	0044a683          	lw	a3,4(s1)
    1268:	0084a703          	lw	a4,8(s1)
    126c:	00c4a783          	lw	a5,12(s1)
    1270:	f8c42823          	sw	a2,-112(s0)
    1274:	f8d42a23          	sw	a3,-108(s0)
    1278:	f8e42c23          	sw	a4,-104(s0)
    127c:	f8f42e23          	sw	a5,-100(s0)
    1280:	fa344703          	lbu	a4,-93(s0)
    1284:	f9040793          	addi	a5,s0,-112
    1288:	fa442683          	lw	a3,-92(s0)
    128c:	00078613          	mv	a2,a5
    1290:	fcc42583          	lw	a1,-52(s0)
    1294:	00000097          	auipc	ra,0x0
    1298:	000080e7          	jalr	ra # 1294 <.L62+0x88>
    129c:	fcc42683          	lw	a3,-52(s0)
    12a0:	fd042603          	lw	a2,-48(s0)
    12a4:	fa842583          	lw	a1,-88(s0)
    12a8:	fac42503          	lw	a0,-84(s0)
    12ac:	00000097          	auipc	ra,0x0
    12b0:	000080e7          	jalr	ra # 12ac <.L62+0xa0>

000012b4 <.L58>:
    12b4:	06c12083          	lw	ra,108(sp)
    12b8:	06812403          	lw	s0,104(sp)
    12bc:	06412483          	lw	s1,100(sp)
    12c0:	06012903          	lw	s2,96(sp)
    12c4:	05c12983          	lw	s3,92(sp)
    12c8:	07010113          	addi	sp,sp,112
    12cc:	00008067          	ret

000012d0 <remove_entry>:
    12d0:	fb010113          	addi	sp,sp,-80
    12d4:	04112623          	sw	ra,76(sp)
    12d8:	04812423          	sw	s0,72(sp)
    12dc:	04912223          	sw	s1,68(sp)
    12e0:	05212023          	sw	s2,64(sp)
    12e4:	03312e23          	sw	s3,60(sp)
    12e8:	05010413          	addi	s0,sp,80
    12ec:	fca42623          	sw	a0,-52(s0)
    12f0:	fcb42423          	sw	a1,-56(s0)
    12f4:	00060493          	mv	s1,a2
    12f8:	fcd42223          	sw	a3,-60(s0)
    12fc:	fc842783          	lw	a5,-56(s0)
    1300:	00479713          	slli	a4,a5,0x4
    1304:	fcc42783          	lw	a5,-52(s0)
    1308:	41f7d693          	srai	a3,a5,0x1f
    130c:	00f6f693          	andi	a3,a3,15
    1310:	00f687b3          	add	a5,a3,a5
    1314:	4047d793          	srai	a5,a5,0x4
    1318:	01879793          	slli	a5,a5,0x18
    131c:	00f70733          	add	a4,a4,a5
    1320:	400007b7          	lui	a5,0x40000
    1324:	00f707b3          	add	a5,a4,a5
    1328:	fcf42e23          	sw	a5,-36(s0)
    132c:	fcc42783          	lw	a5,-52(s0)
    1330:	00378793          	addi	a5,a5,3 # 40000003 <.LFE13+0x3fffdadf>
    1334:	fc442703          	lw	a4,-60(s0)
    1338:	08e7cc63          	blt	a5,a4,13d0 <.L69>

0000133c <.LBB20>:
    133c:	fc442703          	lw	a4,-60(s0)
    1340:	fcc42783          	lw	a5,-52(s0)
    1344:	40f707b3          	sub	a5,a4,a5
    1348:	fcf42a23          	sw	a5,-44(s0)
    134c:	0004a603          	lw	a2,0(s1)
    1350:	0044a683          	lw	a3,4(s1)
    1354:	0084a703          	lw	a4,8(s1)
    1358:	00c4a783          	lw	a5,12(s1)
    135c:	fac42823          	sw	a2,-80(s0)
    1360:	fad42a23          	sw	a3,-76(s0)
    1364:	fae42c23          	sw	a4,-72(s0)
    1368:	faf42e23          	sw	a5,-68(s0)
    136c:	fb040793          	addi	a5,s0,-80
    1370:	fd442603          	lw	a2,-44(s0)
    1374:	fcc42583          	lw	a1,-52(s0)
    1378:	00078513          	mv	a0,a5
    137c:	00000097          	auipc	ra,0x0
    1380:	000080e7          	jalr	ra # 137c <.LBB20+0x40>
    1384:	00050693          	mv	a3,a0
    1388:	fd442783          	lw	a5,-44(s0)
    138c:	00100713          	li	a4,1
    1390:	00f717b3          	sll	a5,a4,a5
    1394:	00f6e7b3          	or	a5,a3,a5
    1398:	fcf42823          	sw	a5,-48(s0)
    139c:	fdc42783          	lw	a5,-36(s0)
    13a0:	0047a703          	lw	a4,4(a5)
    13a4:	fd042783          	lw	a5,-48(s0)
    13a8:	00100693          	li	a3,1
    13ac:	00f697b3          	sll	a5,a3,a5
    13b0:	00f777b3          	and	a5,a4,a5
    13b4:	12078663          	beqz	a5,14e0 <.L72>
    13b8:	fd042603          	lw	a2,-48(s0)
    13bc:	fdc42583          	lw	a1,-36(s0)
    13c0:	fcc42503          	lw	a0,-52(s0)
    13c4:	00000097          	auipc	ra,0x0
    13c8:	000080e7          	jalr	ra # 13c4 <.LBB20+0x88>

000013cc <.LBE20>:
    13cc:	1140006f          	j	14e0 <.L72>

000013d0 <.L69>:
    13d0:	0004a603          	lw	a2,0(s1)
    13d4:	0044a683          	lw	a3,4(s1)
    13d8:	0084a703          	lw	a4,8(s1)
    13dc:	00c4a783          	lw	a5,12(s1)
    13e0:	fac42823          	sw	a2,-80(s0)
    13e4:	fad42a23          	sw	a3,-76(s0)
    13e8:	fae42c23          	sw	a4,-72(s0)
    13ec:	faf42e23          	sw	a5,-68(s0)
    13f0:	fb040793          	addi	a5,s0,-80
    13f4:	00400613          	li	a2,4
    13f8:	fcc42583          	lw	a1,-52(s0)
    13fc:	00078513          	mv	a0,a5
    1400:	00000097          	auipc	ra,0x0
    1404:	000080e7          	jalr	ra # 1400 <.L69+0x30>
    1408:	fca42c23          	sw	a0,-40(s0)
    140c:	fdc42783          	lw	a5,-36(s0)
    1410:	0007a703          	lw	a4,0(a5)
    1414:	fd842783          	lw	a5,-40(s0)
    1418:	00100693          	li	a3,1
    141c:	00f697b3          	sll	a5,a3,a5
    1420:	00f777b3          	and	a5,a4,a5
    1424:	0a078e63          	beqz	a5,14e0 <.L72>
    1428:	fdc42783          	lw	a5,-36(s0)
    142c:	00a7d783          	lhu	a5,10(a5)
    1430:	1007f793          	andi	a5,a5,256
    1434:	02078663          	beqz	a5,1460 <.L71>
    1438:	fcc42783          	lw	a5,-52(s0)
    143c:	00478793          	addi	a5,a5,4
    1440:	fc442703          	lw	a4,-60(s0)
    1444:	08f71e63          	bne	a4,a5,14e0 <.L72>
    1448:	fd842603          	lw	a2,-40(s0)
    144c:	fdc42583          	lw	a1,-36(s0)
    1450:	fcc42503          	lw	a0,-52(s0)
    1454:	00000097          	auipc	ra,0x0
    1458:	000080e7          	jalr	ra # 1454 <.L69+0x84>

0000145c <.LBE21>:
    145c:	0840006f          	j	14e0 <.L72>

00001460 <.L71>:
    1460:	fcc42783          	lw	a5,-52(s0)
    1464:	00478913          	addi	s2,a5,4
    1468:	fdc42783          	lw	a5,-36(s0)
    146c:	0087d783          	lhu	a5,8(a5)
    1470:	00078993          	mv	s3,a5
    1474:	fdc42783          	lw	a5,-36(s0)
    1478:	0007a703          	lw	a4,0(a5)
    147c:	fd842783          	lw	a5,-40(s0)
    1480:	00200693          	li	a3,2
    1484:	00f697b3          	sll	a5,a3,a5
    1488:	fff78793          	addi	a5,a5,-1
    148c:	00f777b3          	and	a5,a4,a5
    1490:	00078513          	mv	a0,a5
    1494:	00000097          	auipc	ra,0x0
    1498:	000080e7          	jalr	ra # 1494 <.L71+0x34>
    149c:	00050793          	mv	a5,a0
    14a0:	00f987b3          	add	a5,s3,a5
    14a4:	fff78593          	addi	a1,a5,-1
    14a8:	0004a603          	lw	a2,0(s1)
    14ac:	0044a683          	lw	a3,4(s1)
    14b0:	0084a703          	lw	a4,8(s1)
    14b4:	00c4a783          	lw	a5,12(s1)
    14b8:	fac42823          	sw	a2,-80(s0)
    14bc:	fad42a23          	sw	a3,-76(s0)
    14c0:	fae42c23          	sw	a4,-72(s0)
    14c4:	faf42e23          	sw	a5,-68(s0)
    14c8:	fb040793          	addi	a5,s0,-80
    14cc:	fc442683          	lw	a3,-60(s0)
    14d0:	00078613          	mv	a2,a5
    14d4:	00090513          	mv	a0,s2
    14d8:	00000097          	auipc	ra,0x0
    14dc:	000080e7          	jalr	ra # 14d8 <.L71+0x78>

000014e0 <.L72>:
    14e0:	00000013          	nop
    14e4:	04c12083          	lw	ra,76(sp)
    14e8:	04812403          	lw	s0,72(sp)
    14ec:	04412483          	lw	s1,68(sp)
    14f0:	04012903          	lw	s2,64(sp)
    14f4:	03c12983          	lw	s3,60(sp)
    14f8:	05010113          	addi	sp,sp,80
    14fc:	00008067          	ret

00001500 <update>:
    1500:	fa010113          	addi	sp,sp,-96
    1504:	04112e23          	sw	ra,92(sp)
    1508:	04812c23          	sw	s0,88(sp)
    150c:	04912a23          	sw	s1,84(sp)
    1510:	06010413          	addi	s0,sp,96
    1514:	00050793          	mv	a5,a0
    1518:	00058493          	mv	s1,a1
    151c:	fcf40fa3          	sb	a5,-33(s0)
    1520:	fdf44783          	lbu	a5,-33(s0)
    1524:	0c078863          	beqz	a5,15f4 <.L74>

00001528 <.LBB23>:
    1528:	0004ae83          	lw	t4,0(s1)
    152c:	0044ae03          	lw	t3,4(s1)
    1530:	0084a303          	lw	t1,8(s1)
    1534:	00c4a883          	lw	a7,12(s1)
    1538:	0104a803          	lw	a6,16(s1)
    153c:	0144a503          	lw	a0,20(s1)
    1540:	0184a583          	lw	a1,24(s1)
    1544:	01c4a603          	lw	a2,28(s1)
    1548:	0204a683          	lw	a3,32(s1)
    154c:	0244a703          	lw	a4,36(s1)
    1550:	0284a783          	lw	a5,40(s1)
    1554:	fbd42023          	sw	t4,-96(s0)
    1558:	fbc42223          	sw	t3,-92(s0)
    155c:	fa642423          	sw	t1,-88(s0)
    1560:	fb142623          	sw	a7,-84(s0)
    1564:	fb042823          	sw	a6,-80(s0)
    1568:	faa42a23          	sw	a0,-76(s0)
    156c:	fab42c23          	sw	a1,-72(s0)
    1570:	fac42e23          	sw	a2,-68(s0)
    1574:	fcd42023          	sw	a3,-64(s0)
    1578:	fce42223          	sw	a4,-60(s0)
    157c:	fcf42423          	sw	a5,-56(s0)
    1580:	fa040793          	addi	a5,s0,-96
    1584:	00078513          	mv	a0,a5
    1588:	00000097          	auipc	ra,0x0
    158c:	000080e7          	jalr	ra # 1588 <.LBB23+0x60>
    1590:	00050793          	mv	a5,a0
    1594:	fef407a3          	sb	a5,-17(s0)
    1598:	000007b7          	lui	a5,0x0
    159c:	0007a783          	lw	a5,0(a5) # 0 <popcnt>
    15a0:	00479713          	slli	a4,a5,0x4
    15a4:	400007b7          	lui	a5,0x40000
    15a8:	00f705b3          	add	a1,a4,a5
    15ac:	0104a783          	lw	a5,16(s1)
    15b0:	00078513          	mv	a0,a5
    15b4:	0004a603          	lw	a2,0(s1)
    15b8:	0044a683          	lw	a3,4(s1)
    15bc:	0084a703          	lw	a4,8(s1)
    15c0:	00c4a783          	lw	a5,12(s1)
    15c4:	fac42023          	sw	a2,-96(s0)
    15c8:	fad42223          	sw	a3,-92(s0)
    15cc:	fae42423          	sw	a4,-88(s0)
    15d0:	faf42623          	sw	a5,-84(s0)
    15d4:	fef44703          	lbu	a4,-17(s0)
    15d8:	fa040793          	addi	a5,s0,-96
    15dc:	00050693          	mv	a3,a0
    15e0:	00078613          	mv	a2,a5
    15e4:	00000513          	li	a0,0
    15e8:	00000097          	auipc	ra,0x0
    15ec:	000080e7          	jalr	ra # 15e8 <.LBB23+0xc0>

000015f0 <.LBE23>:
    15f0:	04c0006f          	j	163c <.L76>

000015f4 <.L74>:
    15f4:	000007b7          	lui	a5,0x0
    15f8:	0007a583          	lw	a1,0(a5) # 0 <popcnt>
    15fc:	0104a783          	lw	a5,16(s1)
    1600:	00078513          	mv	a0,a5
    1604:	0004a603          	lw	a2,0(s1)
    1608:	0044a683          	lw	a3,4(s1)
    160c:	0084a703          	lw	a4,8(s1)
    1610:	00c4a783          	lw	a5,12(s1)
    1614:	fac42023          	sw	a2,-96(s0)
    1618:	fad42223          	sw	a3,-92(s0)
    161c:	fae42423          	sw	a4,-88(s0)
    1620:	faf42623          	sw	a5,-84(s0)
    1624:	fa040793          	addi	a5,s0,-96
    1628:	00050693          	mv	a3,a0
    162c:	00078613          	mv	a2,a5
    1630:	00000513          	li	a0,0
    1634:	00000097          	auipc	ra,0x0
    1638:	000080e7          	jalr	ra # 1634 <.L74+0x40>

0000163c <.L76>:
    163c:	00000013          	nop
    1640:	05c12083          	lw	ra,92(sp)
    1644:	05812403          	lw	s0,88(sp)
    1648:	05412483          	lw	s1,84(sp)
    164c:	06010113          	addi	sp,sp,96
    1650:	00008067          	ret

00001654 <prefix_query>:
    1654:	fa010113          	addi	sp,sp,-96
    1658:	04112e23          	sw	ra,92(sp)
    165c:	04812c23          	sw	s0,88(sp)
    1660:	04912a23          	sw	s1,84(sp)
    1664:	05212823          	sw	s2,80(sp)
    1668:	05312623          	sw	s3,76(sp)
    166c:	06010413          	addi	s0,sp,96
    1670:	00050493          	mv	s1,a0
    1674:	fab42e23          	sw	a1,-68(s0)
    1678:	fac42c23          	sw	a2,-72(s0)
    167c:	fad42a23          	sw	a3,-76(s0)
    1680:	fff00793          	li	a5,-1
    1684:	fcf42e23          	sw	a5,-36(s0)
    1688:	000007b7          	lui	a5,0x0
    168c:	0007a783          	lw	a5,0(a5) # 0 <popcnt>
    1690:	00479713          	slli	a4,a5,0x4
    1694:	400007b7          	lui	a5,0x40000
    1698:	00f707b3          	add	a5,a4,a5
    169c:	fcf42c23          	sw	a5,-40(s0)

000016a0 <.LBB24>:
    16a0:	fc042a23          	sw	zero,-44(s0)
    16a4:	1e00006f          	j	1884 <.L78>

000016a8 <.L87>:
    16a8:	0004a603          	lw	a2,0(s1)
    16ac:	0044a683          	lw	a3,4(s1)
    16b0:	0084a703          	lw	a4,8(s1)
    16b4:	00c4a783          	lw	a5,12(s1)
    16b8:	fac42023          	sw	a2,-96(s0)
    16bc:	fad42223          	sw	a3,-92(s0)
    16c0:	fae42423          	sw	a4,-88(s0)
    16c4:	faf42623          	sw	a5,-84(s0)
    16c8:	fa040793          	addi	a5,s0,-96
    16cc:	00400613          	li	a2,4
    16d0:	fd442583          	lw	a1,-44(s0)
    16d4:	00078513          	mv	a0,a5
    16d8:	00000097          	auipc	ra,0x0
    16dc:	000080e7          	jalr	ra # 16d8 <.L87+0x30>
    16e0:	fca42623          	sw	a0,-52(s0)

000016e4 <.LBB26>:
    16e4:	fcc42783          	lw	a5,-52(s0)
    16e8:	0017d793          	srli	a5,a5,0x1
    16ec:	0087e793          	ori	a5,a5,8
    16f0:	fcf42823          	sw	a5,-48(s0)
    16f4:	0800006f          	j	1774 <.L79>

000016f8 <.L82>:
    16f8:	fd842783          	lw	a5,-40(s0)
    16fc:	0047a703          	lw	a4,4(a5) # 40000004 <.LFE13+0x3fffdae0>
    1700:	fd042783          	lw	a5,-48(s0)
    1704:	00100693          	li	a3,1
    1708:	00f697b3          	sll	a5,a3,a5
    170c:	00f777b3          	and	a5,a4,a5
    1710:	04078c63          	beqz	a5,1768 <.L80>
    1714:	fd842783          	lw	a5,-40(s0)
    1718:	00c7a903          	lw	s2,12(a5)
    171c:	fd842783          	lw	a5,-40(s0)
    1720:	0047a703          	lw	a4,4(a5)
    1724:	fd042783          	lw	a5,-48(s0)
    1728:	00200693          	li	a3,2
    172c:	00f697b3          	sll	a5,a3,a5
    1730:	fff78793          	addi	a5,a5,-1
    1734:	00f777b3          	and	a5,a4,a5
    1738:	00078513          	mv	a0,a5
    173c:	00000097          	auipc	ra,0x0
    1740:	000080e7          	jalr	ra # 173c <.L82+0x44>
    1744:	00050793          	mv	a5,a0
    1748:	00f90733          	add	a4,s2,a5
    174c:	500007b7          	lui	a5,0x50000
    1750:	fff78793          	addi	a5,a5,-1 # 4fffffff <.LFE13+0x4fffdadb>
    1754:	00f707b3          	add	a5,a4,a5
    1758:	0007c783          	lbu	a5,0(a5)
    175c:	0ff7f793          	andi	a5,a5,255
    1760:	fcf42e23          	sw	a5,-36(s0)
    1764:	0180006f          	j	177c <.L81>

00001768 <.L80>:
    1768:	fd042783          	lw	a5,-48(s0)
    176c:	0017d793          	srli	a5,a5,0x1
    1770:	fcf42823          	sw	a5,-48(s0)

00001774 <.L79>:
    1774:	fd042783          	lw	a5,-48(s0)
    1778:	f80790e3          	bnez	a5,16f8 <.L82>

0000177c <.L81>:
    177c:	fd842783          	lw	a5,-40(s0)
    1780:	0007a703          	lw	a4,0(a5)
    1784:	fcc42783          	lw	a5,-52(s0)
    1788:	00100693          	li	a3,1
    178c:	00f697b3          	sll	a5,a3,a5
    1790:	00f777b3          	and	a5,a4,a5
    1794:	10078063          	beqz	a5,1894 <.L90>
    1798:	fd842783          	lw	a5,-40(s0)
    179c:	00a7d783          	lhu	a5,10(a5)
    17a0:	1007f793          	andi	a5,a5,256
    17a4:	06078063          	beqz	a5,1804 <.L84>
    17a8:	fd842783          	lw	a5,-40(s0)
    17ac:	0087d783          	lhu	a5,8(a5)
    17b0:	00078913          	mv	s2,a5
    17b4:	fd842783          	lw	a5,-40(s0)
    17b8:	0007a703          	lw	a4,0(a5)
    17bc:	fcc42783          	lw	a5,-52(s0)
    17c0:	00200693          	li	a3,2
    17c4:	00f697b3          	sll	a5,a3,a5
    17c8:	fff78793          	addi	a5,a5,-1
    17cc:	00f777b3          	and	a5,a4,a5
    17d0:	00078513          	mv	a0,a5
    17d4:	00000097          	auipc	ra,0x0
    17d8:	000080e7          	jalr	ra # 17d4 <.L81+0x58>
    17dc:	00050793          	mv	a5,a0
    17e0:	00f907b3          	add	a5,s2,a5
    17e4:	00078713          	mv	a4,a5
    17e8:	500007b7          	lui	a5,0x50000
    17ec:	fff78793          	addi	a5,a5,-1 # 4fffffff <.LFE13+0x4fffdadb>
    17f0:	00f707b3          	add	a5,a4,a5
    17f4:	0007c783          	lbu	a5,0(a5)
    17f8:	0ff7f793          	andi	a5,a5,255
    17fc:	fcf42e23          	sw	a5,-36(s0)
    1800:	0780006f          	j	1878 <.L85>

00001804 <.L84>:
    1804:	fd442783          	lw	a5,-44(s0)
    1808:	00478793          	addi	a5,a5,4
    180c:	41f7d713          	srai	a4,a5,0x1f
    1810:	00f77713          	andi	a4,a4,15
    1814:	00f707b3          	add	a5,a4,a5
    1818:	4047d793          	srai	a5,a5,0x4
    181c:	01879793          	slli	a5,a5,0x18
    1820:	00078913          	mv	s2,a5
    1824:	fd842783          	lw	a5,-40(s0)
    1828:	0087d783          	lhu	a5,8(a5)
    182c:	00078993          	mv	s3,a5
    1830:	fd842783          	lw	a5,-40(s0)
    1834:	0007a703          	lw	a4,0(a5)
    1838:	fcc42783          	lw	a5,-52(s0)
    183c:	00200693          	li	a3,2
    1840:	00f697b3          	sll	a5,a3,a5
    1844:	fff78793          	addi	a5,a5,-1
    1848:	00f777b3          	and	a5,a4,a5
    184c:	00078513          	mv	a0,a5
    1850:	00000097          	auipc	ra,0x0
    1854:	000080e7          	jalr	ra # 1850 <.L84+0x4c>
    1858:	00050793          	mv	a5,a0
    185c:	00f987b3          	add	a5,s3,a5
    1860:	00479793          	slli	a5,a5,0x4
    1864:	00f90733          	add	a4,s2,a5
    1868:	400007b7          	lui	a5,0x40000
    186c:	ff078793          	addi	a5,a5,-16 # 3ffffff0 <.LFE13+0x3fffdacc>
    1870:	00f707b3          	add	a5,a4,a5
    1874:	fcf42c23          	sw	a5,-40(s0)

00001878 <.L85>:
    1878:	fd442783          	lw	a5,-44(s0)
    187c:	00478793          	addi	a5,a5,4
    1880:	fcf42a23          	sw	a5,-44(s0)

00001884 <.L78>:
    1884:	fd442703          	lw	a4,-44(s0)
    1888:	07f00793          	li	a5,127
    188c:	e0e7dee3          	bge	a5,a4,16a8 <.L87>
    1890:	0080006f          	j	1898 <.L86>

00001894 <.L90>:
    1894:	00000013          	nop

00001898 <.L86>:
    1898:	fdc42703          	lw	a4,-36(s0)
    189c:	fff00793          	li	a5,-1
    18a0:	00f71663          	bne	a4,a5,18ac <.L88>
    18a4:	00000793          	li	a5,0
    18a8:	0b00006f          	j	1958 <.L89>

000018ac <.L88>:
    18ac:	fdc42783          	lw	a5,-36(s0)
    18b0:	00579713          	slli	a4,a5,0x5
    18b4:	510007b7          	lui	a5,0x51000
    18b8:	00f707b3          	add	a5,a4,a5
    18bc:	0007a703          	lw	a4,0(a5) # 51000000 <.LFE13+0x50ffdadc>
    18c0:	fbc42783          	lw	a5,-68(s0)
    18c4:	00e7a023          	sw	a4,0(a5)
    18c8:	fdc42783          	lw	a5,-36(s0)
    18cc:	00579713          	slli	a4,a5,0x5
    18d0:	510007b7          	lui	a5,0x51000
    18d4:	00f707b3          	add	a5,a4,a5
    18d8:	0047a703          	lw	a4,4(a5) # 51000004 <.LFE13+0x50ffdae0>
    18dc:	fbc42783          	lw	a5,-68(s0)
    18e0:	00e7a223          	sw	a4,4(a5)
    18e4:	fdc42783          	lw	a5,-36(s0)
    18e8:	00579713          	slli	a4,a5,0x5
    18ec:	510007b7          	lui	a5,0x51000
    18f0:	00f707b3          	add	a5,a4,a5
    18f4:	0087a703          	lw	a4,8(a5) # 51000008 <.LFE13+0x50ffdae4>
    18f8:	fbc42783          	lw	a5,-68(s0)
    18fc:	00e7a423          	sw	a4,8(a5)
    1900:	fdc42783          	lw	a5,-36(s0)
    1904:	00579713          	slli	a4,a5,0x5
    1908:	510007b7          	lui	a5,0x51000
    190c:	00f707b3          	add	a5,a4,a5
    1910:	00c7a703          	lw	a4,12(a5) # 5100000c <.LFE13+0x50ffdae8>
    1914:	fbc42783          	lw	a5,-68(s0)
    1918:	00e7a623          	sw	a4,12(a5)
    191c:	fdc42783          	lw	a5,-36(s0)
    1920:	00579713          	slli	a4,a5,0x5
    1924:	510007b7          	lui	a5,0x51000
    1928:	00f707b3          	add	a5,a4,a5
    192c:	0107a703          	lw	a4,16(a5) # 51000010 <.LFE13+0x50ffdaec>
    1930:	fb842783          	lw	a5,-72(s0)
    1934:	00e7a023          	sw	a4,0(a5)
    1938:	fdc42783          	lw	a5,-36(s0)
    193c:	00579713          	slli	a4,a5,0x5
    1940:	510007b7          	lui	a5,0x51000
    1944:	00f707b3          	add	a5,a4,a5
    1948:	0147a703          	lw	a4,20(a5) # 51000014 <.LFE13+0x50ffdaf0>
    194c:	fb442783          	lw	a5,-76(s0)
    1950:	00e7a023          	sw	a4,0(a5)
    1954:	00100793          	li	a5,1

00001958 <.L89>:
    1958:	00078513          	mv	a0,a5
    195c:	05c12083          	lw	ra,92(sp)
    1960:	05812403          	lw	s0,88(sp)
    1964:	05412483          	lw	s1,84(sp)
    1968:	05012903          	lw	s2,80(sp)
    196c:	04c12983          	lw	s3,76(sp)
    1970:	06010113          	addi	sp,sp,96
    1974:	00008067          	ret

00001978 <_append_answer>:
    1978:	fe010113          	addi	sp,sp,-32
    197c:	00812e23          	sw	s0,28(sp)
    1980:	02010413          	addi	s0,sp,32
    1984:	fea42623          	sw	a0,-20(s0)
    1988:	feb42423          	sw	a1,-24(s0)
    198c:	fec42223          	sw	a2,-28(s0)
    1990:	fed42023          	sw	a3,-32(s0)
    1994:	fec42783          	lw	a5,-20(s0)
    1998:	fe842703          	lw	a4,-24(s0)
    199c:	00072583          	lw	a1,0(a4)
    19a0:	00472603          	lw	a2,4(a4)
    19a4:	00872683          	lw	a3,8(a4)
    19a8:	00c72703          	lw	a4,12(a4)
    19ac:	00b7a023          	sw	a1,0(a5)
    19b0:	00c7a223          	sw	a2,4(a5)
    19b4:	00d7a423          	sw	a3,8(a5)
    19b8:	00e7a623          	sw	a4,12(a5)
    19bc:	fe442703          	lw	a4,-28(s0)
    19c0:	fec42783          	lw	a5,-20(s0)
    19c4:	00e7a823          	sw	a4,16(a5)
    19c8:	fe042783          	lw	a5,-32(s0)
    19cc:	00579713          	slli	a4,a5,0x5
    19d0:	510007b7          	lui	a5,0x51000
    19d4:	00f707b3          	add	a5,a4,a5
    19d8:	0007a703          	lw	a4,0(a5) # 51000000 <.LFE13+0x50ffdadc>
    19dc:	fec42783          	lw	a5,-20(s0)
    19e0:	00e7ac23          	sw	a4,24(a5)
    19e4:	fe042783          	lw	a5,-32(s0)
    19e8:	00579713          	slli	a4,a5,0x5
    19ec:	510007b7          	lui	a5,0x51000
    19f0:	00f707b3          	add	a5,a4,a5
    19f4:	0047a703          	lw	a4,4(a5) # 51000004 <.LFE13+0x50ffdae0>
    19f8:	fec42783          	lw	a5,-20(s0)
    19fc:	00e7ae23          	sw	a4,28(a5)
    1a00:	fe042783          	lw	a5,-32(s0)
    1a04:	00579713          	slli	a4,a5,0x5
    1a08:	510007b7          	lui	a5,0x51000
    1a0c:	00f707b3          	add	a5,a4,a5
    1a10:	0087a703          	lw	a4,8(a5) # 51000008 <.LFE13+0x50ffdae4>
    1a14:	fec42783          	lw	a5,-20(s0)
    1a18:	02e7a023          	sw	a4,32(a5)
    1a1c:	fe042783          	lw	a5,-32(s0)
    1a20:	00579713          	slli	a4,a5,0x5
    1a24:	510007b7          	lui	a5,0x51000
    1a28:	00f707b3          	add	a5,a4,a5
    1a2c:	00c7a703          	lw	a4,12(a5) # 5100000c <.LFE13+0x50ffdae8>
    1a30:	fec42783          	lw	a5,-20(s0)
    1a34:	02e7a223          	sw	a4,36(a5)
    1a38:	fe042783          	lw	a5,-32(s0)
    1a3c:	00579713          	slli	a4,a5,0x5
    1a40:	510007b7          	lui	a5,0x51000
    1a44:	00f707b3          	add	a5,a4,a5
    1a48:	0107a703          	lw	a4,16(a5) # 51000010 <.LFE13+0x50ffdaec>
    1a4c:	fec42783          	lw	a5,-20(s0)
    1a50:	00e7aa23          	sw	a4,20(a5)
    1a54:	fe042783          	lw	a5,-32(s0)
    1a58:	00579713          	slli	a4,a5,0x5
    1a5c:	510007b7          	lui	a5,0x51000
    1a60:	00f707b3          	add	a5,a4,a5
    1a64:	0147a703          	lw	a4,20(a5) # 51000014 <.LFE13+0x50ffdaf0>
    1a68:	fec42783          	lw	a5,-20(s0)
    1a6c:	02e7a423          	sw	a4,40(a5)
    1a70:	00000013          	nop
    1a74:	01c12403          	lw	s0,28(sp)
    1a78:	02010113          	addi	sp,sp,32
    1a7c:	00008067          	ret

00001a80 <_prefix_query_all>:
    1a80:	f7010113          	addi	sp,sp,-144
    1a84:	08112623          	sw	ra,140(sp)
    1a88:	08812423          	sw	s0,136(sp)
    1a8c:	08912223          	sw	s1,132(sp)
    1a90:	09212023          	sw	s2,128(sp)
    1a94:	07312e23          	sw	s3,124(sp)
    1a98:	07412c23          	sw	s4,120(sp)
    1a9c:	07512a23          	sw	s5,116(sp)
    1aa0:	09010413          	addi	s0,sp,144
    1aa4:	faa42623          	sw	a0,-84(s0)
    1aa8:	fab42423          	sw	a1,-88(s0)
    1aac:	00060913          	mv	s2,a2
    1ab0:	fad42223          	sw	a3,-92(s0)
    1ab4:	fae42023          	sw	a4,-96(s0)
    1ab8:	00080493          	mv	s1,a6
    1abc:	f8f40fa3          	sb	a5,-97(s0)
    1ac0:	fac42703          	lw	a4,-84(s0)
    1ac4:	08000793          	li	a5,128
    1ac8:	18e7c4e3          	blt	a5,a4,2450 <.L119>
    1acc:	fa842783          	lw	a5,-88(s0)
    1ad0:	00479713          	slli	a4,a5,0x4
    1ad4:	fac42783          	lw	a5,-84(s0)
    1ad8:	41f7d693          	srai	a3,a5,0x1f
    1adc:	00f6f693          	andi	a3,a3,15
    1ae0:	00f687b3          	add	a5,a3,a5
    1ae4:	4047d793          	srai	a5,a5,0x4
    1ae8:	01879793          	slli	a5,a5,0x18
    1aec:	00f70733          	add	a4,a4,a5
    1af0:	400007b7          	lui	a5,0x40000
    1af4:	00f707b3          	add	a5,a4,a5
    1af8:	fcf42623          	sw	a5,-52(s0)
    1afc:	f9f44783          	lbu	a5,-97(s0)
    1b00:	4e078263          	beqz	a5,1fe4 <.L95>

00001b04 <.LBB28>:
    1b04:	00100793          	li	a5,1
    1b08:	fcf42e23          	sw	a5,-36(s0)
    1b0c:	2380006f          	j	1d44 <.L96>

00001b10 <.L104>:
    1b10:	fcc42783          	lw	a5,-52(s0)
    1b14:	0047a703          	lw	a4,4(a5) # 40000004 <.LFE13+0x3fffdae0>
    1b18:	fdc42783          	lw	a5,-36(s0)
    1b1c:	00100693          	li	a3,1
    1b20:	00f697b3          	sll	a5,a3,a5
    1b24:	00f777b3          	and	a5,a4,a5
    1b28:	20078663          	beqz	a5,1d34 <.L120>

00001b2c <.LBB29>:
    1b2c:	00300793          	li	a5,3
    1b30:	fcf42c23          	sw	a5,-40(s0)
    1b34:	1f40006f          	j	1d28 <.L99>

00001b38 <.L103>:
    1b38:	fd842783          	lw	a5,-40(s0)
    1b3c:	fdc42703          	lw	a4,-36(s0)
    1b40:	40f757b3          	sra	a5,a4,a5
    1b44:	0017f793          	andi	a5,a5,1
    1b48:	1c078a63          	beqz	a5,1d1c <.L100>

00001b4c <.LBB30>:
    1b4c:	fcc42783          	lw	a5,-52(s0)
    1b50:	00c7a983          	lw	s3,12(a5)
    1b54:	fcc42783          	lw	a5,-52(s0)
    1b58:	0047a703          	lw	a4,4(a5)
    1b5c:	fdc42783          	lw	a5,-36(s0)
    1b60:	00200693          	li	a3,2
    1b64:	00f697b3          	sll	a5,a3,a5
    1b68:	fff78793          	addi	a5,a5,-1
    1b6c:	00f777b3          	and	a5,a4,a5
    1b70:	00078513          	mv	a0,a5
    1b74:	00000097          	auipc	ra,0x0
    1b78:	000080e7          	jalr	ra # 1b74 <.LBB30+0x28>
    1b7c:	00050793          	mv	a5,a0
    1b80:	00f98733          	add	a4,s3,a5
    1b84:	500007b7          	lui	a5,0x50000
    1b88:	fff78793          	addi	a5,a5,-1 # 4fffffff <.LFE13+0x4fffdadb>
    1b8c:	00f707b3          	add	a5,a4,a5
    1b90:	0007c783          	lbu	a5,0(a5)
    1b94:	0ff7f793          	andi	a5,a5,255
    1b98:	faf42a23          	sw	a5,-76(s0)
    1b9c:	fac42783          	lw	a5,-84(s0)
    1ba0:	0077f793          	andi	a5,a5,7
    1ba4:	08079863          	bnez	a5,1c34 <.L101>
    1ba8:	fac42783          	lw	a5,-84(s0)
    1bac:	41f7d713          	srai	a4,a5,0x1f
    1bb0:	00777713          	andi	a4,a4,7
    1bb4:	00f707b3          	add	a5,a4,a5
    1bb8:	4037d793          	srai	a5,a5,0x3
    1bbc:	00f487b3          	add	a5,s1,a5
    1bc0:	0007c783          	lbu	a5,0(a5)
    1bc4:	01879793          	slli	a5,a5,0x18
    1bc8:	4187d793          	srai	a5,a5,0x18
    1bcc:	00f7f793          	andi	a5,a5,15
    1bd0:	01879713          	slli	a4,a5,0x18
    1bd4:	41875713          	srai	a4,a4,0x18
    1bd8:	fd842783          	lw	a5,-40(s0)
    1bdc:	00100693          	li	a3,1
    1be0:	00f696b3          	sll	a3,a3,a5
    1be4:	fdc42783          	lw	a5,-36(s0)
    1be8:	00f6c6b3          	xor	a3,a3,a5
    1bec:	00800613          	li	a2,8
    1bf0:	fd842783          	lw	a5,-40(s0)
    1bf4:	40f607b3          	sub	a5,a2,a5
    1bf8:	00f697b3          	sll	a5,a3,a5
    1bfc:	01879793          	slli	a5,a5,0x18
    1c00:	4187d793          	srai	a5,a5,0x18
    1c04:	00f767b3          	or	a5,a4,a5
    1c08:	01879693          	slli	a3,a5,0x18
    1c0c:	4186d693          	srai	a3,a3,0x18
    1c10:	fac42783          	lw	a5,-84(s0)
    1c14:	41f7d713          	srai	a4,a5,0x1f
    1c18:	00777713          	andi	a4,a4,7
    1c1c:	00f707b3          	add	a5,a4,a5
    1c20:	4037d793          	srai	a5,a5,0x3
    1c24:	0ff6f713          	andi	a4,a3,255
    1c28:	00f487b3          	add	a5,s1,a5
    1c2c:	00e78023          	sb	a4,0(a5)
    1c30:	08c0006f          	j	1cbc <.L102>

00001c34 <.L101>:
    1c34:	fac42783          	lw	a5,-84(s0)
    1c38:	41f7d713          	srai	a4,a5,0x1f
    1c3c:	00777713          	andi	a4,a4,7
    1c40:	00f707b3          	add	a5,a4,a5
    1c44:	4037d793          	srai	a5,a5,0x3
    1c48:	00f487b3          	add	a5,s1,a5
    1c4c:	0007c783          	lbu	a5,0(a5)
    1c50:	01879793          	slli	a5,a5,0x18
    1c54:	4187d793          	srai	a5,a5,0x18
    1c58:	ff07f793          	andi	a5,a5,-16
    1c5c:	01879713          	slli	a4,a5,0x18
    1c60:	41875713          	srai	a4,a4,0x18
    1c64:	fd842783          	lw	a5,-40(s0)
    1c68:	00100693          	li	a3,1
    1c6c:	00f696b3          	sll	a3,a3,a5
    1c70:	fdc42783          	lw	a5,-36(s0)
    1c74:	00f6c6b3          	xor	a3,a3,a5
    1c78:	00400613          	li	a2,4
    1c7c:	fd842783          	lw	a5,-40(s0)
    1c80:	40f607b3          	sub	a5,a2,a5
    1c84:	00f697b3          	sll	a5,a3,a5
    1c88:	01879793          	slli	a5,a5,0x18
    1c8c:	4187d793          	srai	a5,a5,0x18
    1c90:	00f767b3          	or	a5,a4,a5
    1c94:	01879693          	slli	a3,a5,0x18
    1c98:	4186d693          	srai	a3,a3,0x18
    1c9c:	fac42783          	lw	a5,-84(s0)
    1ca0:	41f7d713          	srai	a4,a5,0x1f
    1ca4:	00777713          	andi	a4,a4,7
    1ca8:	00f707b3          	add	a5,a4,a5
    1cac:	4037d793          	srai	a5,a5,0x3
    1cb0:	0ff6f713          	andi	a4,a3,255
    1cb4:	00f487b3          	add	a5,s1,a5
    1cb8:	00e78023          	sb	a4,0(a5)

00001cbc <.L102>:
    1cbc:	fa042783          	lw	a5,-96(s0)
    1cc0:	0007a783          	lw	a5,0(a5)
    1cc4:	00178693          	addi	a3,a5,1
    1cc8:	fa042703          	lw	a4,-96(s0)
    1ccc:	00d72023          	sw	a3,0(a4)
    1cd0:	00078713          	mv	a4,a5
    1cd4:	00070793          	mv	a5,a4
    1cd8:	00179793          	slli	a5,a5,0x1
    1cdc:	00e787b3          	add	a5,a5,a4
    1ce0:	00279793          	slli	a5,a5,0x2
    1ce4:	40e787b3          	sub	a5,a5,a4
    1ce8:	00279793          	slli	a5,a5,0x2
    1cec:	00078713          	mv	a4,a5
    1cf0:	fa442783          	lw	a5,-92(s0)
    1cf4:	00e78533          	add	a0,a5,a4
    1cf8:	fac42703          	lw	a4,-84(s0)
    1cfc:	fd842783          	lw	a5,-40(s0)
    1d00:	00f707b3          	add	a5,a4,a5
    1d04:	fb442683          	lw	a3,-76(s0)
    1d08:	00078613          	mv	a2,a5
    1d0c:	00048593          	mv	a1,s1
    1d10:	00000097          	auipc	ra,0x0
    1d14:	000080e7          	jalr	ra # 1d10 <.L102+0x54>
    1d18:	0200006f          	j	1d38 <.L98>

00001d1c <.L100>:
    1d1c:	fd842783          	lw	a5,-40(s0)
    1d20:	fff78793          	addi	a5,a5,-1
    1d24:	fcf42c23          	sw	a5,-40(s0)

00001d28 <.L99>:
    1d28:	fd842783          	lw	a5,-40(s0)
    1d2c:	e007d6e3          	bgez	a5,1b38 <.L103>
    1d30:	0080006f          	j	1d38 <.L98>

00001d34 <.L120>:
    1d34:	00000013          	nop

00001d38 <.L98>:
    1d38:	fdc42783          	lw	a5,-36(s0)
    1d3c:	00178793          	addi	a5,a5,1
    1d40:	fcf42e23          	sw	a5,-36(s0)

00001d44 <.L96>:
    1d44:	fdc42703          	lw	a4,-36(s0)
    1d48:	00f00793          	li	a5,15
    1d4c:	dce7d2e3          	bge	a5,a4,1b10 <.L104>

00001d50 <.LBB31>:
    1d50:	fc042a23          	sw	zero,-44(s0)
    1d54:	2800006f          	j	1fd4 <.L105>

00001d58 <.L110>:
    1d58:	fcc42783          	lw	a5,-52(s0)
    1d5c:	0007a703          	lw	a4,0(a5)
    1d60:	fd442783          	lw	a5,-44(s0)
    1d64:	00100693          	li	a3,1
    1d68:	00f697b3          	sll	a5,a3,a5
    1d6c:	00f777b3          	and	a5,a4,a5
    1d70:	24078c63          	beqz	a5,1fc8 <.L106>
    1d74:	fac42783          	lw	a5,-84(s0)
    1d78:	0077f793          	andi	a5,a5,7
    1d7c:	06079a63          	bnez	a5,1df0 <.L107>
    1d80:	fac42783          	lw	a5,-84(s0)
    1d84:	41f7d713          	srai	a4,a5,0x1f
    1d88:	00777713          	andi	a4,a4,7
    1d8c:	00f707b3          	add	a5,a4,a5
    1d90:	4037d793          	srai	a5,a5,0x3
    1d94:	00f487b3          	add	a5,s1,a5
    1d98:	0007c783          	lbu	a5,0(a5)
    1d9c:	01879793          	slli	a5,a5,0x18
    1da0:	4187d793          	srai	a5,a5,0x18
    1da4:	00f7f793          	andi	a5,a5,15
    1da8:	01879713          	slli	a4,a5,0x18
    1dac:	41875713          	srai	a4,a4,0x18
    1db0:	fd442783          	lw	a5,-44(s0)
    1db4:	00479793          	slli	a5,a5,0x4
    1db8:	01879793          	slli	a5,a5,0x18
    1dbc:	4187d793          	srai	a5,a5,0x18
    1dc0:	00f767b3          	or	a5,a4,a5
    1dc4:	01879693          	slli	a3,a5,0x18
    1dc8:	4186d693          	srai	a3,a3,0x18
    1dcc:	fac42783          	lw	a5,-84(s0)
    1dd0:	41f7d713          	srai	a4,a5,0x1f
    1dd4:	00777713          	andi	a4,a4,7
    1dd8:	00f707b3          	add	a5,a4,a5
    1ddc:	4037d793          	srai	a5,a5,0x3
    1de0:	0ff6f713          	andi	a4,a3,255
    1de4:	00f487b3          	add	a5,s1,a5
    1de8:	00e78023          	sb	a4,0(a5)
    1dec:	06c0006f          	j	1e58 <.L108>

00001df0 <.L107>:
    1df0:	fac42783          	lw	a5,-84(s0)
    1df4:	41f7d713          	srai	a4,a5,0x1f
    1df8:	00777713          	andi	a4,a4,7
    1dfc:	00f707b3          	add	a5,a4,a5
    1e00:	4037d793          	srai	a5,a5,0x3
    1e04:	00f487b3          	add	a5,s1,a5
    1e08:	0007c783          	lbu	a5,0(a5)
    1e0c:	01879793          	slli	a5,a5,0x18
    1e10:	4187d793          	srai	a5,a5,0x18
    1e14:	ff07f793          	andi	a5,a5,-16
    1e18:	01879713          	slli	a4,a5,0x18
    1e1c:	41875713          	srai	a4,a4,0x18
    1e20:	fd442783          	lw	a5,-44(s0)
    1e24:	01879793          	slli	a5,a5,0x18
    1e28:	4187d793          	srai	a5,a5,0x18
    1e2c:	00f767b3          	or	a5,a4,a5
    1e30:	01879693          	slli	a3,a5,0x18
    1e34:	4186d693          	srai	a3,a3,0x18
    1e38:	fac42783          	lw	a5,-84(s0)
    1e3c:	41f7d713          	srai	a4,a5,0x1f
    1e40:	00777713          	andi	a4,a4,7
    1e44:	00f707b3          	add	a5,a4,a5
    1e48:	4037d793          	srai	a5,a5,0x3
    1e4c:	0ff6f713          	andi	a4,a3,255
    1e50:	00f487b3          	add	a5,s1,a5
    1e54:	00e78023          	sb	a4,0(a5)

00001e58 <.L108>:
    1e58:	fcc42783          	lw	a5,-52(s0)
    1e5c:	00a7d783          	lhu	a5,10(a5)
    1e60:	1007f793          	andi	a5,a5,256
    1e64:	0a078c63          	beqz	a5,1f1c <.L109>
    1e68:	fa042783          	lw	a5,-96(s0)
    1e6c:	0007a783          	lw	a5,0(a5)
    1e70:	00178693          	addi	a3,a5,1
    1e74:	fa042703          	lw	a4,-96(s0)
    1e78:	00d72023          	sw	a3,0(a4)
    1e7c:	00078713          	mv	a4,a5
    1e80:	00070793          	mv	a5,a4
    1e84:	00179793          	slli	a5,a5,0x1
    1e88:	00e787b3          	add	a5,a5,a4
    1e8c:	00279793          	slli	a5,a5,0x2
    1e90:	40e787b3          	sub	a5,a5,a4
    1e94:	00279793          	slli	a5,a5,0x2
    1e98:	00078713          	mv	a4,a5
    1e9c:	fa442783          	lw	a5,-92(s0)
    1ea0:	00e789b3          	add	s3,a5,a4
    1ea4:	fac42783          	lw	a5,-84(s0)
    1ea8:	00478a13          	addi	s4,a5,4
    1eac:	fcc42783          	lw	a5,-52(s0)
    1eb0:	0087d783          	lhu	a5,8(a5)
    1eb4:	00078a93          	mv	s5,a5
    1eb8:	fcc42783          	lw	a5,-52(s0)
    1ebc:	0007a703          	lw	a4,0(a5)
    1ec0:	fd442783          	lw	a5,-44(s0)
    1ec4:	00200693          	li	a3,2
    1ec8:	00f697b3          	sll	a5,a3,a5
    1ecc:	fff78793          	addi	a5,a5,-1
    1ed0:	00f777b3          	and	a5,a4,a5
    1ed4:	00078513          	mv	a0,a5
    1ed8:	00000097          	auipc	ra,0x0
    1edc:	000080e7          	jalr	ra # 1ed8 <.L108+0x80>
    1ee0:	00050793          	mv	a5,a0
    1ee4:	00fa87b3          	add	a5,s5,a5
    1ee8:	00078713          	mv	a4,a5
    1eec:	500007b7          	lui	a5,0x50000
    1ef0:	fff78793          	addi	a5,a5,-1 # 4fffffff <.LFE13+0x4fffdadb>
    1ef4:	00f707b3          	add	a5,a4,a5
    1ef8:	0007c783          	lbu	a5,0(a5)
    1efc:	0ff7f793          	andi	a5,a5,255
    1f00:	00078693          	mv	a3,a5
    1f04:	000a0613          	mv	a2,s4
    1f08:	00048593          	mv	a1,s1
    1f0c:	00098513          	mv	a0,s3
    1f10:	00000097          	auipc	ra,0x0
    1f14:	000080e7          	jalr	ra # 1f10 <.L108+0xb8>
    1f18:	0b00006f          	j	1fc8 <.L106>

00001f1c <.L109>:
    1f1c:	fac42783          	lw	a5,-84(s0)
    1f20:	00478993          	addi	s3,a5,4
    1f24:	fcc42783          	lw	a5,-52(s0)
    1f28:	0087d783          	lhu	a5,8(a5)
    1f2c:	00078a13          	mv	s4,a5
    1f30:	fcc42783          	lw	a5,-52(s0)
    1f34:	0007a703          	lw	a4,0(a5)
    1f38:	fd442783          	lw	a5,-44(s0)
    1f3c:	00200693          	li	a3,2
    1f40:	00f697b3          	sll	a5,a3,a5
    1f44:	fff78793          	addi	a5,a5,-1
    1f48:	00f777b3          	and	a5,a4,a5
    1f4c:	00078513          	mv	a0,a5
    1f50:	00000097          	auipc	ra,0x0
    1f54:	000080e7          	jalr	ra # 1f50 <.L109+0x34>
    1f58:	00050793          	mv	a5,a0
    1f5c:	00fa07b3          	add	a5,s4,a5
    1f60:	fff78593          	addi	a1,a5,-1
    1f64:	00092603          	lw	a2,0(s2)
    1f68:	00492683          	lw	a3,4(s2)
    1f6c:	00892703          	lw	a4,8(s2)
    1f70:	00c92783          	lw	a5,12(s2)
    1f74:	f8c42023          	sw	a2,-128(s0)
    1f78:	f8d42223          	sw	a3,-124(s0)
    1f7c:	f8e42423          	sw	a4,-120(s0)
    1f80:	f8f42623          	sw	a5,-116(s0)
    1f84:	0004a603          	lw	a2,0(s1)
    1f88:	0044a683          	lw	a3,4(s1)
    1f8c:	0084a703          	lw	a4,8(s1)
    1f90:	00c4a783          	lw	a5,12(s1)
    1f94:	f6c42823          	sw	a2,-144(s0)
    1f98:	f6d42a23          	sw	a3,-140(s0)
    1f9c:	f6e42c23          	sw	a4,-136(s0)
    1fa0:	f6f42e23          	sw	a5,-132(s0)
    1fa4:	f7040713          	addi	a4,s0,-144
    1fa8:	f9f44783          	lbu	a5,-97(s0)
    1fac:	f8040613          	addi	a2,s0,-128
    1fb0:	00070813          	mv	a6,a4
    1fb4:	fa042703          	lw	a4,-96(s0)
    1fb8:	fa442683          	lw	a3,-92(s0)
    1fbc:	00098513          	mv	a0,s3
    1fc0:	00000097          	auipc	ra,0x0
    1fc4:	000080e7          	jalr	ra # 1fc0 <.L109+0xa4>

00001fc8 <.L106>:
    1fc8:	fd442783          	lw	a5,-44(s0)
    1fcc:	00178793          	addi	a5,a5,1
    1fd0:	fcf42a23          	sw	a5,-44(s0)

00001fd4 <.L105>:
    1fd4:	fd442703          	lw	a4,-44(s0)
    1fd8:	00f00793          	li	a5,15
    1fdc:	d6e7dee3          	bge	a5,a4,1d58 <.L110>
    1fe0:	4740006f          	j	2454 <.L92>

00001fe4 <.L95>:
    1fe4:	00092603          	lw	a2,0(s2)
    1fe8:	00492683          	lw	a3,4(s2)
    1fec:	00892703          	lw	a4,8(s2)
    1ff0:	00c92783          	lw	a5,12(s2)
    1ff4:	f6c42823          	sw	a2,-144(s0)
    1ff8:	f6d42a23          	sw	a3,-140(s0)
    1ffc:	f6e42c23          	sw	a4,-136(s0)
    2000:	f6f42e23          	sw	a5,-132(s0)
    2004:	f7040793          	addi	a5,s0,-144
    2008:	00400613          	li	a2,4
    200c:	fac42583          	lw	a1,-84(s0)
    2010:	00078513          	mv	a0,a5
    2014:	00000097          	auipc	ra,0x0
    2018:	000080e7          	jalr	ra # 2014 <.L95+0x30>
    201c:	fca42423          	sw	a0,-56(s0)
    2020:	fc842783          	lw	a5,-56(s0)
    2024:	0017d793          	srli	a5,a5,0x1
    2028:	0087e793          	ori	a5,a5,8
    202c:	fcf42223          	sw	a5,-60(s0)

00002030 <.LBB33>:
    2030:	fc042823          	sw	zero,-48(s0)
    2034:	1c80006f          	j	21fc <.L111>

00002038 <.L115>:
    2038:	fd042783          	lw	a5,-48(s0)
    203c:	fc442703          	lw	a4,-60(s0)
    2040:	00f757b3          	srl	a5,a4,a5
    2044:	fcf42023          	sw	a5,-64(s0)
    2048:	fd042783          	lw	a5,-48(s0)
    204c:	00178793          	addi	a5,a5,1
    2050:	fc842703          	lw	a4,-56(s0)
    2054:	00f757b3          	srl	a5,a4,a5
    2058:	faf42e23          	sw	a5,-68(s0)
    205c:	fcc42783          	lw	a5,-52(s0)
    2060:	0047a703          	lw	a4,4(a5)
    2064:	fc042783          	lw	a5,-64(s0)
    2068:	00100693          	li	a3,1
    206c:	00f697b3          	sll	a5,a3,a5
    2070:	00f777b3          	and	a5,a4,a5
    2074:	16078e63          	beqz	a5,21f0 <.L112>

00002078 <.LBB35>:
    2078:	fcc42783          	lw	a5,-52(s0)
    207c:	00c7a983          	lw	s3,12(a5)
    2080:	fcc42783          	lw	a5,-52(s0)
    2084:	0047a703          	lw	a4,4(a5)
    2088:	fc042783          	lw	a5,-64(s0)
    208c:	00200693          	li	a3,2
    2090:	00f697b3          	sll	a5,a3,a5
    2094:	fff78793          	addi	a5,a5,-1
    2098:	00f777b3          	and	a5,a4,a5
    209c:	00078513          	mv	a0,a5
    20a0:	00000097          	auipc	ra,0x0
    20a4:	000080e7          	jalr	ra # 20a0 <.LBB35+0x28>
    20a8:	00050793          	mv	a5,a0
    20ac:	00f98733          	add	a4,s3,a5
    20b0:	500007b7          	lui	a5,0x50000
    20b4:	fff78793          	addi	a5,a5,-1 # 4fffffff <.LFE13+0x4fffdadb>
    20b8:	00f707b3          	add	a5,a4,a5
    20bc:	0007c783          	lbu	a5,0(a5)
    20c0:	0ff7f793          	andi	a5,a5,255
    20c4:	faf42c23          	sw	a5,-72(s0)
    20c8:	fac42783          	lw	a5,-84(s0)
    20cc:	0077f793          	andi	a5,a5,7
    20d0:	06079263          	bnez	a5,2134 <.L113>
    20d4:	fac42783          	lw	a5,-84(s0)
    20d8:	41f7d713          	srai	a4,a5,0x1f
    20dc:	00777713          	andi	a4,a4,7
    20e0:	00f707b3          	add	a5,a4,a5
    20e4:	4037d793          	srai	a5,a5,0x3
    20e8:	00f487b3          	add	a5,s1,a5
    20ec:	0007c783          	lbu	a5,0(a5)
    20f0:	00f7f793          	andi	a5,a5,15
    20f4:	0ff7f693          	andi	a3,a5,255
    20f8:	fd042783          	lw	a5,-48(s0)
    20fc:	00578793          	addi	a5,a5,5
    2100:	fbc42703          	lw	a4,-68(s0)
    2104:	00f717b3          	sll	a5,a4,a5
    2108:	0ff7f713          	andi	a4,a5,255
    210c:	fac42783          	lw	a5,-84(s0)
    2110:	41f7d613          	srai	a2,a5,0x1f
    2114:	00767613          	andi	a2,a2,7
    2118:	00f607b3          	add	a5,a2,a5
    211c:	4037d793          	srai	a5,a5,0x3
    2120:	00e6e733          	or	a4,a3,a4
    2124:	0ff77713          	andi	a4,a4,255
    2128:	00f487b3          	add	a5,s1,a5
    212c:	00e78023          	sb	a4,0(a5)
    2130:	0600006f          	j	2190 <.L114>

00002134 <.L113>:
    2134:	fac42783          	lw	a5,-84(s0)
    2138:	41f7d713          	srai	a4,a5,0x1f
    213c:	00777713          	andi	a4,a4,7
    2140:	00f707b3          	add	a5,a4,a5
    2144:	4037d793          	srai	a5,a5,0x3
    2148:	00f487b3          	add	a5,s1,a5
    214c:	0007c783          	lbu	a5,0(a5)
    2150:	ff07f793          	andi	a5,a5,-16
    2154:	0ff7f693          	andi	a3,a5,255
    2158:	fd042783          	lw	a5,-48(s0)
    215c:	00178793          	addi	a5,a5,1
    2160:	fbc42703          	lw	a4,-68(s0)
    2164:	00f717b3          	sll	a5,a4,a5
    2168:	0ff7f713          	andi	a4,a5,255
    216c:	fac42783          	lw	a5,-84(s0)
    2170:	41f7d613          	srai	a2,a5,0x1f
    2174:	00767613          	andi	a2,a2,7
    2178:	00f607b3          	add	a5,a2,a5
    217c:	4037d793          	srai	a5,a5,0x3
    2180:	00e6e733          	or	a4,a3,a4
    2184:	0ff77713          	andi	a4,a4,255
    2188:	00f487b3          	add	a5,s1,a5
    218c:	00e78023          	sb	a4,0(a5)

00002190 <.L114>:
    2190:	fa042783          	lw	a5,-96(s0)
    2194:	0007a783          	lw	a5,0(a5)
    2198:	00178693          	addi	a3,a5,1
    219c:	fa042703          	lw	a4,-96(s0)
    21a0:	00d72023          	sw	a3,0(a4)
    21a4:	00078713          	mv	a4,a5
    21a8:	00070793          	mv	a5,a4
    21ac:	00179793          	slli	a5,a5,0x1
    21b0:	00e787b3          	add	a5,a5,a4
    21b4:	00279793          	slli	a5,a5,0x2
    21b8:	40e787b3          	sub	a5,a5,a4
    21bc:	00279793          	slli	a5,a5,0x2
    21c0:	00078713          	mv	a4,a5
    21c4:	fa442783          	lw	a5,-92(s0)
    21c8:	00e78533          	add	a0,a5,a4
    21cc:	fac42783          	lw	a5,-84(s0)
    21d0:	00378713          	addi	a4,a5,3
    21d4:	fd042783          	lw	a5,-48(s0)
    21d8:	40f707b3          	sub	a5,a4,a5
    21dc:	fb842683          	lw	a3,-72(s0)
    21e0:	00078613          	mv	a2,a5
    21e4:	00048593          	mv	a1,s1
    21e8:	00000097          	auipc	ra,0x0
    21ec:	000080e7          	jalr	ra # 21e8 <.L114+0x58>

000021f0 <.L112>:
    21f0:	fd042783          	lw	a5,-48(s0)
    21f4:	00178793          	addi	a5,a5,1
    21f8:	fcf42823          	sw	a5,-48(s0)

000021fc <.L111>:
    21fc:	fd042703          	lw	a4,-48(s0)
    2200:	00300793          	li	a5,3
    2204:	e2e7dae3          	bge	a5,a4,2038 <.L115>

00002208 <.LBE33>:
    2208:	fcc42783          	lw	a5,-52(s0)
    220c:	0007a703          	lw	a4,0(a5)
    2210:	fc842783          	lw	a5,-56(s0)
    2214:	00100693          	li	a3,1
    2218:	00f697b3          	sll	a5,a3,a5
    221c:	00f777b3          	and	a5,a4,a5
    2220:	22078a63          	beqz	a5,2454 <.L92>
    2224:	fac42783          	lw	a5,-84(s0)
    2228:	0077f793          	andi	a5,a5,7
    222c:	06079063          	bnez	a5,228c <.L116>
    2230:	fac42783          	lw	a5,-84(s0)
    2234:	41f7d713          	srai	a4,a5,0x1f
    2238:	00777713          	andi	a4,a4,7
    223c:	00f707b3          	add	a5,a4,a5
    2240:	4037d793          	srai	a5,a5,0x3
    2244:	00f487b3          	add	a5,s1,a5
    2248:	0007c783          	lbu	a5,0(a5)
    224c:	00f7f793          	andi	a5,a5,15
    2250:	0ff7f693          	andi	a3,a5,255
    2254:	fc842783          	lw	a5,-56(s0)
    2258:	0ff7f793          	andi	a5,a5,255
    225c:	00479793          	slli	a5,a5,0x4
    2260:	0ff7f713          	andi	a4,a5,255
    2264:	fac42783          	lw	a5,-84(s0)
    2268:	41f7d613          	srai	a2,a5,0x1f
    226c:	00767613          	andi	a2,a2,7
    2270:	00f607b3          	add	a5,a2,a5
    2274:	4037d793          	srai	a5,a5,0x3
    2278:	00e6e733          	or	a4,a3,a4
    227c:	0ff77713          	andi	a4,a4,255
    2280:	00f487b3          	add	a5,s1,a5
    2284:	00e78023          	sb	a4,0(a5)
    2288:	0540006f          	j	22dc <.L117>

0000228c <.L116>:
    228c:	fac42783          	lw	a5,-84(s0)
    2290:	41f7d713          	srai	a4,a5,0x1f
    2294:	00777713          	andi	a4,a4,7
    2298:	00f707b3          	add	a5,a4,a5
    229c:	4037d793          	srai	a5,a5,0x3
    22a0:	00f487b3          	add	a5,s1,a5
    22a4:	0007c783          	lbu	a5,0(a5)
    22a8:	ff07f793          	andi	a5,a5,-16
    22ac:	0ff7f693          	andi	a3,a5,255
    22b0:	fc842783          	lw	a5,-56(s0)
    22b4:	0ff7f713          	andi	a4,a5,255
    22b8:	fac42783          	lw	a5,-84(s0)
    22bc:	41f7d613          	srai	a2,a5,0x1f
    22c0:	00767613          	andi	a2,a2,7
    22c4:	00f607b3          	add	a5,a2,a5
    22c8:	4037d793          	srai	a5,a5,0x3
    22cc:	00e6e733          	or	a4,a3,a4
    22d0:	0ff77713          	andi	a4,a4,255
    22d4:	00f487b3          	add	a5,s1,a5
    22d8:	00e78023          	sb	a4,0(a5)

000022dc <.L117>:
    22dc:	fcc42783          	lw	a5,-52(s0)
    22e0:	00a7d783          	lhu	a5,10(a5)
    22e4:	1007f793          	andi	a5,a5,256
    22e8:	0a078c63          	beqz	a5,23a0 <.L118>
    22ec:	fa042783          	lw	a5,-96(s0)
    22f0:	0007a783          	lw	a5,0(a5)
    22f4:	00178693          	addi	a3,a5,1
    22f8:	fa042703          	lw	a4,-96(s0)
    22fc:	00d72023          	sw	a3,0(a4)
    2300:	00078713          	mv	a4,a5
    2304:	00070793          	mv	a5,a4
    2308:	00179793          	slli	a5,a5,0x1
    230c:	00e787b3          	add	a5,a5,a4
    2310:	00279793          	slli	a5,a5,0x2
    2314:	40e787b3          	sub	a5,a5,a4
    2318:	00279793          	slli	a5,a5,0x2
    231c:	00078713          	mv	a4,a5
    2320:	fa442783          	lw	a5,-92(s0)
    2324:	00e78933          	add	s2,a5,a4
    2328:	fac42783          	lw	a5,-84(s0)
    232c:	00478993          	addi	s3,a5,4
    2330:	fcc42783          	lw	a5,-52(s0)
    2334:	0087d783          	lhu	a5,8(a5)
    2338:	00078a13          	mv	s4,a5
    233c:	fcc42783          	lw	a5,-52(s0)
    2340:	0007a703          	lw	a4,0(a5)
    2344:	fc842783          	lw	a5,-56(s0)
    2348:	00200693          	li	a3,2
    234c:	00f697b3          	sll	a5,a3,a5
    2350:	fff78793          	addi	a5,a5,-1
    2354:	00f777b3          	and	a5,a4,a5
    2358:	00078513          	mv	a0,a5
    235c:	00000097          	auipc	ra,0x0
    2360:	000080e7          	jalr	ra # 235c <.L117+0x80>
    2364:	00050793          	mv	a5,a0
    2368:	00fa07b3          	add	a5,s4,a5
    236c:	00078713          	mv	a4,a5
    2370:	500007b7          	lui	a5,0x50000
    2374:	fff78793          	addi	a5,a5,-1 # 4fffffff <.LFE13+0x4fffdadb>
    2378:	00f707b3          	add	a5,a4,a5
    237c:	0007c783          	lbu	a5,0(a5)
    2380:	0ff7f793          	andi	a5,a5,255
    2384:	00078693          	mv	a3,a5
    2388:	00098613          	mv	a2,s3
    238c:	00048593          	mv	a1,s1
    2390:	00090513          	mv	a0,s2
    2394:	00000097          	auipc	ra,0x0
    2398:	000080e7          	jalr	ra # 2394 <.L117+0xb8>
    239c:	0b80006f          	j	2454 <.L92>

000023a0 <.L118>:
    23a0:	fac42783          	lw	a5,-84(s0)
    23a4:	00478993          	addi	s3,a5,4
    23a8:	fcc42783          	lw	a5,-52(s0)
    23ac:	0087d783          	lhu	a5,8(a5)
    23b0:	00078a13          	mv	s4,a5
    23b4:	fcc42783          	lw	a5,-52(s0)
    23b8:	0007a703          	lw	a4,0(a5)
    23bc:	fc842783          	lw	a5,-56(s0)
    23c0:	00200693          	li	a3,2
    23c4:	00f697b3          	sll	a5,a3,a5
    23c8:	fff78793          	addi	a5,a5,-1
    23cc:	00f777b3          	and	a5,a4,a5
    23d0:	00078513          	mv	a0,a5
    23d4:	00000097          	auipc	ra,0x0
    23d8:	000080e7          	jalr	ra # 23d4 <.L118+0x34>
    23dc:	00050793          	mv	a5,a0
    23e0:	00fa07b3          	add	a5,s4,a5
    23e4:	fff78593          	addi	a1,a5,-1
    23e8:	00092603          	lw	a2,0(s2)
    23ec:	00492683          	lw	a3,4(s2)
    23f0:	00892703          	lw	a4,8(s2)
    23f4:	00c92783          	lw	a5,12(s2)
    23f8:	f6c42823          	sw	a2,-144(s0)
    23fc:	f6d42a23          	sw	a3,-140(s0)
    2400:	f6e42c23          	sw	a4,-136(s0)
    2404:	f6f42e23          	sw	a5,-132(s0)
    2408:	0004a603          	lw	a2,0(s1)
    240c:	0044a683          	lw	a3,4(s1)
    2410:	0084a703          	lw	a4,8(s1)
    2414:	00c4a783          	lw	a5,12(s1)
    2418:	f8c42023          	sw	a2,-128(s0)
    241c:	f8d42223          	sw	a3,-124(s0)
    2420:	f8e42423          	sw	a4,-120(s0)
    2424:	f8f42623          	sw	a5,-116(s0)
    2428:	f8040713          	addi	a4,s0,-128
    242c:	f9f44783          	lbu	a5,-97(s0)
    2430:	f7040613          	addi	a2,s0,-144
    2434:	00070813          	mv	a6,a4
    2438:	fa042703          	lw	a4,-96(s0)
    243c:	fa442683          	lw	a3,-92(s0)
    2440:	00098513          	mv	a0,s3
    2444:	00000097          	auipc	ra,0x0
    2448:	000080e7          	jalr	ra # 2444 <.L118+0xa4>
    244c:	0080006f          	j	2454 <.L92>

00002450 <.L119>:
    2450:	00000013          	nop

00002454 <.L92>:
    2454:	08c12083          	lw	ra,140(sp)
    2458:	08812403          	lw	s0,136(sp)
    245c:	08412483          	lw	s1,132(sp)
    2460:	08012903          	lw	s2,128(sp)
    2464:	07c12983          	lw	s3,124(sp)
    2468:	07812a03          	lw	s4,120(sp)
    246c:	07412a83          	lw	s5,116(sp)
    2470:	09010113          	addi	sp,sp,144
    2474:	00008067          	ret

00002478 <test>:
    2478:	ff010113          	addi	sp,sp,-16
    247c:	00812623          	sw	s0,12(sp)
    2480:	01010413          	addi	s0,sp,16
    2484:	400007b7          	lui	a5,0x40000
    2488:	01078713          	addi	a4,a5,16 # 40000010 <.LFE13+0x3fffdaec>
    248c:	400007b7          	lui	a5,0x40000
    2490:	02078793          	addi	a5,a5,32 # 40000020 <.LFE13+0x3fffdafc>
    2494:	00072583          	lw	a1,0(a4)
    2498:	00472603          	lw	a2,4(a4)
    249c:	00872683          	lw	a3,8(a4)
    24a0:	00c72703          	lw	a4,12(a4)
    24a4:	00b7a023          	sw	a1,0(a5)
    24a8:	00c7a223          	sw	a2,4(a5)
    24ac:	00d7a423          	sw	a3,8(a5)
    24b0:	00e7a623          	sw	a4,12(a5)
    24b4:	400007b7          	lui	a5,0x40000
    24b8:	02078793          	addi	a5,a5,32 # 40000020 <.LFE13+0x3fffdafc>
    24bc:	00a7d783          	lhu	a5,10(a5)
    24c0:	01079713          	slli	a4,a5,0x10
    24c4:	01075713          	srli	a4,a4,0x10
    24c8:	400007b7          	lui	a5,0x40000
    24cc:	02078793          	addi	a5,a5,32 # 40000020 <.LFE13+0x3fffdafc>
    24d0:	10076713          	ori	a4,a4,256
    24d4:	01071713          	slli	a4,a4,0x10
    24d8:	01075713          	srli	a4,a4,0x10
    24dc:	00e79523          	sh	a4,10(a5)
    24e0:	400007b7          	lui	a5,0x40000
    24e4:	02078793          	addi	a5,a5,32 # 40000020 <.LFE13+0x3fffdafc>
    24e8:	0087d783          	lhu	a5,8(a5)
    24ec:	01079713          	slli	a4,a5,0x10
    24f0:	01075713          	srli	a4,a4,0x10
    24f4:	400007b7          	lui	a5,0x40000
    24f8:	02078793          	addi	a5,a5,32 # 40000020 <.LFE13+0x3fffdafc>
    24fc:	fdf77713          	andi	a4,a4,-33
    2500:	01071713          	slli	a4,a4,0x10
    2504:	01075713          	srli	a4,a4,0x10
    2508:	00e79423          	sh	a4,8(a5)
    250c:	400007b7          	lui	a5,0x40000
    2510:	02078793          	addi	a5,a5,32 # 40000020 <.LFE13+0x3fffdafc>
    2514:	00078513          	mv	a0,a5
    2518:	00c12403          	lw	s0,12(sp)
    251c:	01010113          	addi	sp,sp,16
    2520:	00008067          	ret
