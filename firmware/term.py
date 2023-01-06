import time
import serial
from scapy.all import *
from scapy.layers.inet import *
from scapy.layers.inet6 import *
import sys

ser = serial.Serial(
    port='COM3',
    baudrate=115200
)


def serial_run(in_file='lookup/data/test_input_readable.txt', out_file='lookup/data/test_output.txt'):
    fin = open(in_file, 'r')
    fout = open(out_file, 'w')
    for line in fin.readlines():
        for l in line:
            ser.write(l.encode('ascii'))
            time.sleep(0.005)
        time.sleep(0.08)
        bytesToRead = ser.inWaiting()
        if (bytesToRead):
            s = ser.read(bytesToRead).decode('ascii')
            s1 = s.split('\n')[1]
            if s1[0] != 'D' and s1[0] != 'A':
                fout.write(s1)
            print(s, end='', flush=True)

if len(sys.argv) > 1:
    serial_run()
    exit(0)

# 包通过以下方式由 gen_frame 生成至 frames.txt, 第一个字节为长度
#
# 由于 GUA 地址暂时未和邻居缓存结合, 故若希望收到回复, 则不应使用 GUA 地址作为 ipv6_src 地址

pkt = (Ether(src="00:00:00:00:00:00", dst="00:00:00:00:00:00") /
       IPv6(src="fe80::8e1f:64ff:fe69:1032", dst="2a0e:aa06:497:a02::5678") /
       ICMPv6EchoRequest(data="Hello!"))

pkt.show2()
pkt = bytes(pkt)
pkt = [hex(x)[2:] for x in pkt]
pkt = [x if len(x) == 2 else '0' + x for x in pkt]
pkt = [str(len(pkt))] + list(pkt)
pkt = [x + ' ' for x in pkt]
pkt = ''.join(pkt)
write_list = 'f\r\nw' + pkt + '\r\r'

write_list = "f\nw62 8c 1f 64 69 10 30 8c 1f 64 69 10 32 86 dd 60 00 00 00 00 08 3a 40 fe 80 00 00 00 00 00 00 8e 1f 64 ff fe 69 10 32 2a 0e aa 06 04 97 0a 02 00 00 00 00 00 00 56 78 80 00 46 5b 00 00 00 00\r\r"
i = 0
while True:
    bytesToRead = ser.inWaiting()
    if (bytesToRead):
        s = ser.read(bytesToRead)
        print(s.decode('ascii'), end='', flush=True)

    if (i < len(write_list)):
        ser.write(write_list[i].encode('ascii'))
        i += 1

    time.sleep(0.005)
