import time
import serial
from scapy.all import *
from scapy.layers.inet import *
from scapy.layers.inet6 import *

ser = serial.Serial(
    port='COM3',
    baudrate=115200
)

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
