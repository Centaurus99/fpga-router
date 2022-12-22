import os

ncnt = [[0 for i in range(17)] for i in range(8)]
lcnt = [0 for i in range(17)]
nmax = [[0 for i in range(17)] for i in range(8)]
lmax = [0 for i in range(17)]
nave = [[0 for i in range(17)] for i in range(8)]
lave = [0 for i in range(17)]

def init():
    for i in range(8):
        for j in range(17):
            ncnt[i][j] = 0
    for i in range(17):
        lcnt[i] = 0
    
    os.system(f'python grade.py gen_ionly {N}')
    os.system('./lookup < data/I_only_input.txt > data/I_only_trace.txt')
    

def main(N):
    for x in range(10):
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
                    if ncnt[int(line[1])][int(line[2])] > nmax[int(line[1])][int(line[2])]:
                        nmax[int(line[1])][int(line[2])] = ncnt[int(line[1])][int(line[2])]
        for i in range(8):
            for j in range(17):
                nave[i][j] += ncnt[i][j]
        for i in range(17):
            lave[i] += lcnt[i]

    print(f'{N} Insertions:')
    print('Stage\t', end=' ')
    for j in range(17):
        print((f'{j}'+' '*12)[:10], end=' ')
    print()
    for i in range(8):
        print(i, end='\t')
        for j in range(17):
            print((f'{nave[i][j]//10}/{nmax[i][j]}'+' '*12)[:10], end=' ')
        print()
    print('Leaf', end='\t')
    for i in range(17):
        print((f'{lave[i]//10}/{lmax[i]}'+' '*12)[:10], end=' ')
    print()
            

if __name__ == '__main__':
    N = 10000
    main(N)