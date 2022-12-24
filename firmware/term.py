import time
import serial

ser = serial.Serial(
    port='COM3',
    baudrate=115200
)

write_list = "f\nw62 8c 1f 64 69 10 30 8c 1f 64 69 10 32 86 dd 60 00 00 00 00 08 3a 40 fe 80 00 00 00 00 00 00 8e 1f 64 ff fe 69 10 32 fe 80 00 00 00 00 00 00 8e 1f 64 ff fe 69 10 30 80 00 7f 47 00 00 00 00\r\r"
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
