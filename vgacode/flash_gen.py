try:
    file_1 = open('gpio_test.bin', 'rb')
except:
    file_1 = None
try:
    file_2 = open('name2.bin', 'rb')
except:
    file_2 = None

NUM_4M = 2 ** 22

if(file_1 != None):
    bitline_1 = file_1.read()
    if(len(bitline_1) > NUM_4M):
        raise
    bitline_1 += bytes(NUM_4M - len(bitline_1))
else:
    bitline_1 = bytes(NUM_4M)
    
if(file_2 != None):
    bitline_2 = file_2.read()
    if(len(bitline_2) > NUM_4M):
        raise
    bitline_2 += bytes(NUM_4M - len(bitline_2))
else:
    bitline_2 = bytes(NUM_4M)
    
file_3 = open('../asmcode/flash.bin', 'wb')
file_3.write(bitline_1 + bitline_2)
file_3.close()


