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
if len(sys.argv) > 1:
    exe = sys.argv[1]

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

entrys = []
def gen_input(in_file, N, query_after_update_complete=0):
    table = []
    with open(in_file, 'w') as f:
        while N + query_after_update_complete:
            c = random.randint(0, 4)
            if N and (c == 0 or not table):
                eid = random.randint(0, len(entrys) - 1)
                e = entrys[eid]
                if e not in table:
                    table.append(eid)
                N -= 1
                f.write(f'I {e[0]} {e[1]} {e[3]} {e[2]}\n')
            elif N and c == 1:
                if random.randint(0, 2) < 2 and table:
                    tid = random.randint(0, len(table) - 1)
                    e = entrys[table[tid]]
                else:
                    eid = random.randint(0, len(entrys) - 1)
                    e = entrys[eid]
                f.write(f'D {e[0]} {e[1]}\n')
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
                f.write(f'Q {ip}\n')
                query_after_update_complete -= 1

                    

def run(exe, in_file, out_file):
    p = subprocess.Popen(['./{}'.format(exe)], stdout=open(out_file, 'w'), stdin=open(in_file, 'r'))
    start_time = time.time()
    p.wait()

if __name__ == '__main__':

    if os.isatty(1):
        print('Removing all output files')
    os.system('rm -f data/{}_output*.txt'.format(prefix))

    # print("Running examples:")
    # grade = 0
    # for i in range(1, total+1):
    #     in_file = "data/{}_input{}.txt".format(prefix, i)
    #     out_file = "data/{}_output{}.txt".format(prefix, i)
    #     ans_file = "data/{}_answer{}.txt".format(prefix, i)

    #     if os.isatty(1):
    #         print('Running \'./{} < {} > {}\''.format(exe, in_file, out_file))
    #     p = subprocess.Popen(['./{}'.format(exe)], stdout=open(out_file, 'w'), stdin=open(in_file, 'r'))
    #     start_time = time.time()

    #     while p.poll() is None:
    #         if time.time() - start_time > 1:
    #             p.kill()

    #     grade += compare(out_file, ans_file)

    # write_grade(grade, total)

    # if (grade < total):
    #     sys.exit(0)

    entrys = [line.strip().split(' ') for line in open('fib_shuffled.txt', 'r').readlines() if line.strip()]

    for i in range(100000):
        in_file = "data/test_input.txt"
        out_file = "data/test_output.txt"
        ans_file = "data/test_answer.txt"
        gen_input(in_file, 150)
        run(exe, in_file, out_file)
        run(exe2, in_file, ans_file)

        if not compare(out_file, ans_file):
            sys.exit(0)
        print(f'{i} correct')