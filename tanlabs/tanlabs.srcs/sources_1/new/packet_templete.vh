`ifndef _PACKET_TEMPLETE_VH_
`define _PACKET_TEMPLETE_VH_

`include "frame_datapath.vh"

function ether_hdr IPv6_packet(
    input [ 47:0] dst_mac,
    input [ 47:0] src_mac,
    input [ 15:0] payload_len,
    input [  7:0] next_hdr,
    input [  7:0] hop_limit,
    input [127:0] src_ip,
    input [127:0] dst_ip
);
    automatic ether_hdr packet = 0;
    // MAC 部分
    packet.src       = src_mac;
    packet.dst       = dst_mac;
    packet.ethertype = ETHERTYPE_IP6;

    // IP 部分
    packet.ip6.flow_hi     = 4'b0;
    packet.ip6.version     = 4'd6;
    packet.ip6.flow_lo     = 24'b0;
    packet.ip6.payload_len = payload_len;
    packet.ip6.next_hdr    = next_hdr;
    packet.ip6.hop_limit   = hop_limit;
    packet.ip6.src         = src_ip;
    packet.ip6.dst         = dst_ip;

    return packet;

endfunction

`endif
