import time
import serial

ser = serial.Serial(
    port='COM3',
    baudrate=115200
)

# 包通过以下方式由 gen_frame 生成至 frames.txt, 第一个字节为长度
# 
# 由于 frame_datapath 中 CPU 发包相当于发至 4 端口, 模 4 后为 0, 故 mac_dst 为 0 号端口 mac 地址
# 由于 GUA 地址暂时未和邻居缓存结合, 故若希望收到回复, 则不应使用 GUA 地址作为 ipv6_src 地址
#
# write_frame(0, Ether(src="8c:1f:64:69:10:32", dst="8c:1f:64:69:10:30") /
#             IPv6(src="fe80::8e1f:64ff:fe69:1032", dst="2a0e:aa06:497:a02::5678") /
#             ICMPv6EchoRequest())

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

    time.sleep(0.01)
