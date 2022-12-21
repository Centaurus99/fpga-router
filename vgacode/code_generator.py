from PIL import Image
import numpy as np

graph = Image.open('test.png')

for i in range(graph.size[1]):
    for j in range(graph.size[0]):
        if((j - i) % 50 > 25):
            graph.putpixel((j, i), (255, 255, 255, 255))
        else:
            graph.putpixel((j, i), (0, 0, 0, 255))

graph.save('result.png')
            

print("图像宽度：", graph.size[0])
print("图像高度：", graph.size[1])

asm_file = open("../asmcode/vga_test.s", 'w', encoding = 'utf-8')

asm_file.write("initial:\n")
asm_file.write("\tli t0, 0x30000000\n")
asm_file.write("\tli t1, 0x00000000\n")
asm_file.write("load_graph:\n")

buffer = []

for i in range(graph.size[1]):
    for j in range(graph.size[0]):
        if(len(buffer) == 4):
            num = (buffer[3] << 24) + (buffer[2] << 16) + (buffer[1] << 8) + buffer[0]
            asm_file.write(f"\tli t1, {hex(num)}\n")
            asm_file.write(f"\tsw t1, 0(t0)\n")
            asm_file.write(f"\taddi t0, t0, 4\n")
            buffer = []
        color_tuple = graph.getpixel((j, i))
        red, green, blue, reserve = color_tuple
        buffer.append(((red >> 5) << 5) + ((green >> 5) << 2) + (blue >> 6))
        
num = (buffer[3] << 24) + (buffer[2] << 16) + (buffer[1] << 8) + buffer[0]
asm_file.write(f"\tli t1, {hex(num)}\n")
asm_file.write(f"\tsw t1, 0(t0)\n")
asm_file.write(f"\taddi t0, t0, 4\n")
buffer = []        
        
asm_file.close()

