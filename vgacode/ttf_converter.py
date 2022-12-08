from PIL import Image
import numpy as np

graph = Image.open('charmap.png')

# graph.crop((98, 79, 105, 91)).save('charmap_crop.png')
# print(graph.crop((98, 79, 105, 91)).size)
# graph.crop((98 + 14, 79, 105 + 14, 91)).save('charmap_crop.png')
# graph.crop((98 + 98, 79 + 39, 105 + 98, 93 + 39)).save('charmap_crop.png')

read_word = [
    [' ', '!', '"', '#', '$', '%', '&', "'", '(', ')', '*', '+', ',', '-', '.', '/'],
    ['0', '1', '2', '3', '4', '5', '6', "7", '8', '9', ':', ';', '<', '=', '>', '?'],
    ['@', 'A', 'B', 'C', 'D', 'E', 'F', "G", 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O'],
    ['P', 'Q', 'R', 'S', 'T', 'U', 'V', "W", 'X', 'Y', 'Z', '[', '\\', ']', '^', '_'],
    ['`', 'a', 'b', 'c', 'd', 'e', 'f', "g", 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o'],
    ['p', 'q', 'r', 's', 't', 'u', 'v', "w", 'x', 'y', 'z', '{', '|', '}', '~']
    
]

top = 66
left = 98

black_i = [0 for i in range(graph.size[0])]
black_j = [0 for j in range(graph.size[1])]

output_file = open('c_code.c', 'w')
output_file.write('char char_bitmap[95][14] = {\n')

for charlist in read_word:
    for char in charlist:
        crop = graph.crop((left, top, left + 7, top + 14))
        if(char == '0'):
            crop.save('charmap_crop.png')
        curline = '\t{'
        for j in range(crop.size[1]):
            cur_num = '0b'
            for i in range(crop.size[0]):
                if(crop.getpixel((i, j))[0] > 128):
                    cur_num += '1'
                else:
                    cur_num += '0'
            curline += cur_num
            if(j == crop.size[1] - 1):
                curline += '},\n'
            else:
                curline += ', '
        output_file.write(curline)
        left += 14
    top += 13
    left = 98
    
        
output_file.write('};')
        
                
                
                
                
# maxi = 0   
# for i in range(graph.size[0]):
#     if(black_i[i] > black_i[maxi]):
#         maxi = i
# print(maxi)
        
# maxi = 0
# for j in range(graph.size[0]):
#     if(black_j[j] > black_j[maxi]):
#         maxi = j
# print(maxi)