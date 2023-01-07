#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import re
import sys
import os
import json
import subprocess
import time
from os.path import isfile, join
import random
import string
import signal
import glob
import traceback
import ipaddress

prefix = 'lookup'
exe = prefix
exe2 = prefix + '_bf'

total = len(glob.glob("data/{}_input*.txt".format(prefix)))

def write_grade(grade, total):
    data = {}
    data['grade'] = grade
    if os.isatty(1):
        print('Passed: {}/{}'.format(grade, total))
    else:
        print(json.dumps(data))

def compare(out_file_1, out_file_2):
    try:
        out = [line.strip() for line in open(out_file_1, 'r').readlines() if line.strip()]
        out2 = [line.strip() for line in open(out_file_2, 'r').readlines() if line.strip()]
            
        if out == out2:
            return 1
        elif os.isatty(1):
            print('Diff: ')
            os.system('diff -u {} {} | head -n 10'.format(out_file_1, out_file_2))
    except Exception:
        if os.isatty(1):
            print('Unexpected exception caught:')
            traceback.print_exc()
    return 0


def hex_(b):
    return ('00'+hex(b)[2:])[-2:]

def to_u32s(ip_s):
    b = ipaddress.ip_address(ip_s).packed
    return (hex_(b[3])+hex_(b[2])+hex_(b[1])+hex_(b[0])) + ' ' + \
        (hex_(b[7])+hex_(b[6])+hex_(b[5])+hex_(b[4])) + ' ' + \
            (hex_(b[11])+hex_(b[10])+hex_(b[9])+hex_(b[8])) + ' ' + \
                (hex_(b[15])+hex_(b[14])+hex_(b[13])+hex_(b[12]))

entrys = []
def gen_input(in_file, in_file2, N, query_after_update_complete=0):
    table = []
    f2 = open(in_file2, 'w')
    with open(in_file, 'w') as f:
        for l in open('data/direct_route.txt', 'r'):
            f.write(l)
        f.write('\n')
        while N>0 or query_after_update_complete>0:
            c = random.randint(0, 4)
            if N and (c == 0 or not table):
                eid = random.randint(0, len(entrys) - 1)
                e = entrys[eid]
                if e not in table:
                    N -= 1
                    table.append(eid)
                f.write(f'I {to_u32s(e[0])} {e[1]} {e[3]} {to_u32s(e[2])} 2\n')
                f2.write(f'a {e[0]} {e[1]} {e[3]} {e[2]} 2\n')
            elif N and c == 1:
                if random.randint(0, 2) < 2 and table:
                    tid = random.randint(0, len(table) - 1)
                    e = entrys[table[tid]]
                else:
                    eid = random.randint(0, len(entrys) - 1)
                    e = entrys[eid]
                f.write(f'D {to_u32s(e[0])} {e[1]} 2\n')
                f2.write(f'd {e[0]} {e[1]} 2\n')
            elif (N == 0 and query_after_update_complete > 0) or (query_after_update_complete <= 0):
                tid = random.randint(0, len(table) - 1)
                e = entrys[table[tid]]
                if random.randint(0, 5) <= 4:
                    if (int(e[1]) <= 120):
                        subnet = ipaddress.ip_network(f'{e[0]}/{e[1]}')
                        ip = subnet[random.randint(0, 15 * 15) * (2 ** (120 - int(e[1])))]
                    else:
                        ip = e[0]
                else:
                    ip = random.choice(entrys)[0]
                f.write(f'Q {to_u32s(ip)}\n')
                f2.write(f'q {ip}\n')
                query_after_update_complete -= 1

def gen_ionly_input(in_file, N):
    random.shuffle(entrys)
    with open(in_file, 'w') as f:
        # for l in open('data/direct_route.txt', 'r'):
        #     f.write(l)
        # f.write('\n')
        for i in range(N):
            e = entrys[i]
            f.write(f'I {to_u32s(e[0])} {e[1]} {e[3]} {to_u32s(e[2])} 2\n')

def run(exe, in_file, out_file):
    p = subprocess.Popen(['./{}'.format(exe)], stdout=open(out_file, 'w'), stdin=open(in_file, 'r'))
    start_time = time.time()
    p.wait()


if __name__ == '__main__':

    # if os.isatty(1):
    #     print('Removing all output files')
    # os.system('rm -f data/{}_output*.txt'.format(prefix))

    entrys = [line.strip().split(' ') for line in open('fib_shuffled.txt', 'r').readlines() if line.strip()]

    
    in_file = "data/test_input.txt"
    in_file2 = "data/test_input_readable.txt"
    out_file = "data/test_output.txt"
    ans_file = "data/test_answer.txt"

    if len(sys.argv) > 1:
        if (sys.argv[1] == 'gen_forsim'):
            gen_input("data/forsim_input.txt", "data/forsim_input_readable.txt", 10, 20)
            sys.exit(0)
        elif sys.argv[1] == 'gen_ionly':
            gen_ionly_input('data/I_only_input.txt'.format(prefix), int(sys.argv[2]))
            sys.exit(0)
        elif sys.argv[1] == 'gen_once':
            gen_input(in_file, in_file2, int(sys.argv[2]))
            run(exe2, in_file, ans_file)
            sys.exit(0)
    
    print("对拍：")
    for i in range(100000):
        gen_input(in_file, in_file2, 1000)
        run(exe, in_file, out_file)
        run(exe2, in_file, ans_file)

        if not compare(out_file, ans_file):
            sys.exit(0)
        print(f'{i} correct')