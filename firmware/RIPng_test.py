#!/usr/bin/env python3

# Requirements:
#   sudo apt install python3-pip
#   sudo pip3 install scapy
# Usage:
#   ./gen_frame [send]
# or
#   python3 gen_frame [send]

from scapy import *
from scapy.utils import *
from scapy.utils6 import *
from scapy.layers.l2 import *
from scapy.layers.inet import *
from scapy.layers.inet6 import *
from scapy.layers.rip import *
from scapy.contrib.ripng import *
import binascii
import sys
import struct
import time

# The broadcast MAC address.
# Also used when we do not know the router's MAC address when sending IP packets.
MAC_BROADCAST = 'ff:ff:ff:ff:ff:ff'

MAC_DUT0 = '8C:1F:64:69:10:30'
MAC_DUT1 = '8C:1F:64:69:10:31'

MAC_TESTER0 = '00:E0:4C:68:00:2E'
MAC_TESTER1 = '00:E0:4C:68:00:3C'
MAC_OTHERS = '40:41:42:43:44:45'
IFACE_DEFAULT_ROUTE = 3
MAC_DEFAULT_ROUTE = '54:45:53:54:5f:33'

# FIXME: change this to your own link-local IP
LL_TESTER0 = 'fe80::540e:add7:2714:9cf2'
LL_TESTER1 = 'fe80::b015:b6df:4d93:77dd'

# You may need to change these IP addresses.
# The following configuration assumes that
#   1. The IP addresses of Interface 0 of the router are link-local and prefix:0::1/64.
#   2. The IP addresses of Interface 1 of the router are link-local and prefix:1::1/64.
#   3. The IP addresses of Interface 2 of the router are link-local and prefix:2::1/64.
#   4. The IP addresses of Interface 3 of the router are link-local and prefix:3::1/64.
#   5. There exists a 2000::/3 route (not default route), and its next hop is Interface 3, TESTER3.
IP_PREFIX = '2a0e:aa06:497:'
IP_TESTER0 = IP_PREFIX + '0::2333'
IP_TESTER1 = IP_PREFIX + '1::3444'
IP_DUT0 = 'fe80::1'  # Device under test.
IP_DUT0_GUA = IP_PREFIX + '0::1'
IP_DUT1 = 'fe80::1'
IP_DUT3 = 'fe80::1'
# The IP address of the default route.
IP_DEFAULT_ROUTE = 'fe80::5645:53ff:fe54:5f33'
IP_TEST_NDP = 'fe80::8888'
IP_TEST_DST = '2402:f000::1'  # Forward destination. Route should exist.
# Forward destination. Route should exist. MAC address should not exist.
IP_TEST_DST_NO_MAC = IP_PREFIX + '0::100'
# Forward destination. Route should not exist.
IP_TEST_DST_NO_ROUTE = 'fd00::1'
IP_RIP = 'ff02::9'  # RIP multicast group address.

# FIXME: change this to your own interfaces
INTERFACES = ['Realtek USB GbE Family Controller', 'Realtek USB GbE Family Controller #3']

# frames.txt format:
# <Ingress Interface ID> <Frame Length> <Frame Data...>
pout = RawPcapWriter('in_frames.pcap', DLT_EN10MB)  # for wireshark

def send_frame(iface, f):
    # print('Writing frame (interface #{}):'.format(iface))
    # f.show()
    # data = bytes(f)
    # pout.write(data[:12] + struct.pack('>HH',
    #            0x8100, 1000 + iface) + data[12:])
    sendp(f, iface=INTERFACES[iface])


def getll(mac):
    data = binascii.a2b_hex(mac.replace(':', ''))
    a = [0xfe, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00,
         0x00, *data[:3], 0xff, 0xfe, *data[3:]]
    a[8] ^= 0x02
    return inet_ntop(socket.AF_INET6, a)


def getnsma(a):
    return inet_ntop(socket.AF_INET6, in6_getnsma(inet_pton(socket.AF_INET6, a)))

def routes_in_pcap(path):
    pkt = rdpcap(path)
    routes = []
    for p in pkt:
        if p.haslayer(RIPng):
            p = p['RIPng']
            while p.payload:
                p = p.payload
                routes.append((p.prefix_or_nh, p.prefixlen))
                # print(p.prefix_or_nh, p.prefixlen)
    return routes

def checkerror():
    pkt = rdpcap('error.pcap')[0]
    pkt['Ether'].src = MAC_TESTER0
    pkt['Ether'].dst = MAC_DUT0
    pkt.show()
    send_frame(0, pkt)
# exit()

def check_no_response():
    routes = routes_in_pcap('RIPresponse.pcapng')
    with open('lookup/fib_shuffled.txt', 'r') as f:
        for line in f.readlines()[:1000]:
            prefix = line.strip().split(' ')[0]
            len = int(line.strip().split(' ')[1])
            if (prefix, len) not in routes:
                print(prefix, len)
                send_frame(0, Ether(src=MAC_TESTER0) /
                IPv6(src=LL_TESTER0, dst=IP_RIP, hlim=255) /
                UDP() /
                RIPng(cmd=2) /
                RIPngEntry(prefix_or_nh=prefix, prefixlen=len, metric=1))
# exit()

def fib_shuffled(size):
    for i in range(100):
        cnt = 0
        p = Ether(src=MAC_TESTER0) / IPv6(src=LL_TESTER0, dst=IP_RIP, hlim=255) / UDP() / RIPng(cmd=2)
        sent = []
        with open('lookup/fib_shuffled.txt', 'r') as f:
            for line in f.readlines()[:size]:
                prefix = line.strip().split(' ')[0]
                len = int(line.strip().split(' ')[1])
                # assert((prefix, len) not in sent)
                # sent.append((prefix, len))
                p /= RIPngEntry(prefix_or_nh=prefix, prefixlen=len, metric=4)
                cnt += 1
                if cnt >= 71:
                    cnt = 0
                    send_frame(0, p)
                    p = Ether(src=MAC_TESTER0) / IPv6(src=LL_TESTER0, dst=IP_RIP, hlim=255) / UDP() / RIPng(cmd=2)
                    # time.sleep(0.15)
        if cnt > 0:
            send_frame(0, p)

def validate():
    # ping
    send_frame(0, Ether(src=MAC_TESTER0) /
                IPv6(src=LL_TESTER0, dst=getnsma(IP_DUT0)) /
                ICMPv6EchoRequest())

    # ping 2
    send_frame(0, Ether(src=MAC_TESTER0) /
                IPv6(src=LL_TESTER0, dst=getnsma(IP_DUT0)) /
                ICMPv6EchoRequest())

    # RIPng response
    send_frame(0, Ether(src=MAC_TESTER0) /
                IPv6(src=LL_TESTER0, dst=IP_RIP, hlim=255) /
                UDP() /
                RIPng(cmd=2) /
                RIPngEntry(prefix_or_nh='2001:da8:200::', prefixlen=48, metric=1) /             # new
                RIPngEntry(prefix_or_nh='2002:fabc:e000::', prefixlen=35, metric=2) /           # new
                RIPngEntry(prefix_or_nh='2003:acdc:eeee:7777:aa80::', prefixlen=74, metric=3) / # new
                RIPngEntry(prefix_or_nh='2222:a000::', prefixlen=20, metric=15) /               # unable to reach
                RIPngEntry(prefix_or_nh='2333:3444:4555::', prefixlen=0, metric=255)/           # set nexthop
                RIPngEntry(prefix_or_nh='2004::', prefixlen=16, metric=4)                       # new
        )

    # exit()

    # RIPng request 
    send_frame(0, Ether(src=MAC_TESTER0) /
                IPv6(src=LL_TESTER0, dst=IP_RIP, hlim=1) /
                UDP() /
                RIPng(cmd=1) /
                RIPngEntry(prefix_or_nh='2001:da8:200::', prefixlen=48) /
                RIPngEntry(prefix_or_nh='2003:acdc:eeee:7777:aa80::', prefixlen=76) /
                RIPngEntry(prefix_or_nh='2a0e:aa06:497:a01::', prefixlen=64) /
                RIPngEntry(prefix_or_nh='2a0e:aa06:497:a02::3444', prefixlen=128) /
                RIPngEntry(prefix_or_nh='::', prefixlen=0, metric=10))

    # RIPng response 2 (unicast)
    send_frame(1, Ether(src=MAC_TESTER1) /
                IPv6(src=LL_TESTER1, dst=IP_DUT1, hlim=255) /
                UDP() /
                RIPng(cmd=2) /
                RIPngEntry(prefix_or_nh='2001:da8:200::', prefixlen=48, metric=10) /   # not update
                RIPngEntry(prefix_or_nh='2002:fabc:e000::', prefixlen=35, metric=1) / # update
                RIPngEntry(prefix_or_nh='2005:1234:5678::', prefixlen=46, metric=5) / # new
                RIPngEntry(prefix_or_nh=LL_TESTER0, prefixlen=0, metric=255)/  # set nexthop
                RIPngEntry(prefix_or_nh='2003:acdc:eeee:7777:aa80::', prefixlen=74, metric=10)       # port is not same so dont update
            )     

    # RIPng response 3
    send_frame(0, Ether(src=MAC_TESTER0) /
                IPv6(src=LL_TESTER0, dst=IP_RIP, hlim=255) /
                UDP() /
                RIPng(cmd=2) /
                RIPngEntry(prefix_or_nh='2333:3444:4555::', prefixlen=0, metric=255)/           # set nexthop
                RIPngEntry(prefix_or_nh='2004::', prefixlen=16, metric=11))                     # update even if metric is bigger

    # RIPng request all
    send_frame(0, Ether(src=MAC_TESTER0) /
                IPv6(src=LL_TESTER0, dst=IP_RIP, hlim=1) /
                UDP() /
                RIPng(cmd=1) /
                RIPngEntry(prefix_or_nh='::', prefixlen=0, metric=16))

    # exit()

    # RIP test (bad, source address is GUA).
    send_frame(0, Ether(src=MAC_TESTER0) /
                IPv6(src=IP_TESTER0, dst=IP_RIP, hlim=1) /
                UDP() /
                RIPng() /
                RIPngEntry(prefix_or_nh='2001:da8:200::', prefixlen=48) /
                RIPngEntry(prefix_or_nh='2402:f000::', prefixlen=32) /
                RIPngEntry(prefix_or_nh='240a:a000::', prefixlen=20))

    # RIP test (wrong checksum).
    send_frame(0, Ether(src=MAC_TESTER0) /
                IPv6(src=LL_TESTER0, dst=IP_RIP, hlim=1) /
                UDP(chksum=0x2222) /
                RIPng() /
                RIPngEntry(prefix_or_nh='2001:da8:200::', prefixlen=48) /
                RIPngEntry(prefix_or_nh='2402:f000::', prefixlen=32) /
                RIPngEntry(prefix_or_nh='240a:a000::', prefixlen=20))

    # RIP test (no checksum, illegal in IPv6).
    send_frame(0, Ether(src=MAC_TESTER0) /
                IPv6(src=LL_TESTER0, dst=IP_RIP, hlim=1) /
                UDP(chksum=0x0000) /
                RIPng() /
                RIPngEntry(prefix_or_nh='2001:da8:200::', prefixlen=48) /
                RIPngEntry(prefix_or_nh='2402:f000::', prefixlen=32) /
                RIPngEntry(prefix_or_nh='240a:a000::', prefixlen=20))
    # You can construct more frames to test your datapath.

    # for i in range(99):
    #     send_frame(0, Ether(src=MAC_TESTER0) /
    #             IPv6(src=LL_TESTER0, dst=IP_RIP, hlim=255) /
    #             UDP() /
    #             RIPng(cmd=2) /
    #             RIPngEntry(prefix_or_nh=f'2001:da8:{i}::', prefixlen=48, metric=4))

    send_frame(1, Ether(src=MAC_TESTER1) /
                IPv6(src=LL_TESTER1, dst=IP_RIP, hlim=1) /
                UDP() /
                RIPng(cmd=1) /
                RIPngEntry(prefix_or_nh='::', prefixlen=0, metric=16))


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print('arg!!!')
        exit()
    if sys.argv[1] == 'validate':
        validate()
    elif sys.argv[1] == 'fib':
        fib_shuffled(int(sys.argv[2]) if len(sys.argv) > 2 else 10000)