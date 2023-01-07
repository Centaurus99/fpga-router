import os

ncnt = [[0 for i in range(17)] for i in range(8)]
lcnt = [0 for i in range(17)]
nmax = [[0 for i in range(17)] for i in range(8)]
lmax = [0 for i in range(17)]
nave = [[0 for i in range(17)] for i in range(8)]
lave = [0 for i in range(17)]
nsum = [0 for i in range(8)]
nsummax = [0 for i in range(8)]
lsum = 0
lsummax = 0

def init():
    global lsum
    for i in range(8):
        for j in range(17):
            ncnt[i][j] = 0
        nsum[i] = 0
    for i in range(17):
        lcnt[i] = 0
    lsum = 0
    
    os.system(f'python grade.py gen_ionly {N}')
    os.system('./lookup < data/I_only_input.txt > data/I_only_trace.txt')

def export(ratio=1.0):
    node_cnt = 0
    blk_cnt = 0
    for i in range(8):
        nmax[i][0] = 0
        for j in range(1, 17):
            nmax[i][j] = int((nmax[i][j]+5)*ratio)
            nmax[i][0] += nmax[i][j]*j
            blk_cnt += nmax[i][j]
        x = int((1024 - (nmax[i][0] % 1024)) // 16)
        nmax[i][0] += x * 16
        nmax[i][j] += x
        blk_cnt += x

        node_cnt += nmax[i][0]
    for i in range(1, 17):
        lmax[i] = int((lmax[i]+10)*ratio)
        lmax[0] += lmax[i]*i
        blk_cnt += lmax[i]
    x = int((1024 - (lmax[0] % 1024)) // 16)
    lmax[0] += x * 16
    lmax[16] += x
    blk_cnt += x
    with open('blk_cnt.txt', 'w') as f:
        f.write(f'// {N} insertions, {M} times, {ratio}x size\n')
        f.write('int node_blk_cnt[8][17] = {\n')
        for i in range(8):
            f.write('\t{')
            for j in range(17):
                f.write((f'{nmax[i][j]}'+' '*10)[:5] + (',' if j<16 else '}'))
            f.write(',\n'if i<7 else '};\n')

        f.write('int leaf_blk_cnt[17] = \n\t{')
        for j in range(17):
            f.write((f'{lmax[j]}'+' '*10)[:5] + (',' if j<16 else '}'))
        f.write(';\n')
        f.write('#ifndef ON_BOARD\n')
        f.write(f'TrieNode node_pool[{node_cnt}];\n')
        f.write('extern TrieNode *_nodes[8];\n')
        f.write('#endif\n')
        f.write(f'int blk_pool[{blk_cnt}];')

def main(N, M, R):
    global lsum, lsummax
    for x in range(M):
        init()
        with open('data/I_only_trace.txt', 'r') as f:
            for line in f:
                if line[0] != 'L' and line[0] != 'N':
                    continue
                line = line.strip().split()
                inc = 1 if line[-1] == '+' else -1
                if line[0] == 'L':
                    lcnt[int(line[1])] += inc
                    if lcnt[int(line[1])] > lmax[int(line[1])]:
                        lmax[int(line[1])] = lcnt[int(line[1])]
                else:
                    ncnt[int(line[1])][int(line[2])] += inc
                    if(ncnt[int(line[1])][int(line[2])] < 0):
                        print(line)
                        return
                    if ncnt[int(line[1])][int(line[2])] > nmax[int(line[1])][int(line[2])]:
                        nmax[int(line[1])][int(line[2])] = ncnt[int(line[1])][int(line[2])]
        for i in range(8):
            for j in range(17):
                nave[i][j] += ncnt[i][j]
                nsum[i] += ncnt[i][j]*j
            if nsum[i] > nsummax[i]:
                nsummax[i] = nsum[i]
        for i in range(17):
            lave[i] += lcnt[i]
            lsum += lcnt[i]*i
        if lsum > lsummax:
            lsummax = lsum
        

    print(f'{N} Insertions:')
    print('Stage\t', end=' ')
    for j in range(1, 17):
        print((f'{j}'+' '*12)[:12], end=' ')
    print(('sum'+' '*12)[:12], end=' ')
    print()
    for i in range(8):
        print(i, end='\t')
        for j in range(1, 17):
            print((f'{nave[i][j]//M}/{nmax[i][j]}'+' '*12)[:12], end=' ')
        print((f'{nsummax[i]}'+' '*12)[:12], end=' ')
        print()
    print('Leaf', end='\t')
    for i in range(1, 17):
        print((f'{lave[i]//M}/{lmax[i]}'+' '*12)[:12], end=' ')
    print((f'{lsummax}'+' '*12)[:12], end=' ')
    print()

    export(R)
            
import sys
if __name__ == '__main__':
    N = int(sys.argv[1]) if len(sys.argv) > 1 else 10000
    M = int(sys.argv[2]) if len(sys.argv) > 2 else 10
    R = float(sys.argv[3]) if len(sys.argv) > 3 else 1.0
    os.system('make clean')
    os.system('make TRACE=y')
    main(N, M, R)