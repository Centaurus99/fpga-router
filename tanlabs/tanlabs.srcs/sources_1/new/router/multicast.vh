`ifndef _MULTICAST_VH_
`define _MULTICAST_VH_

function logic [127:0] solicited_node_IP(input [127:0] ip);
    static logic [103:0] ip_prefix = {<<8{104'hff02_0000_0000_0000_0000_0001_ff}};
    return {ip[127:104], ip_prefix};
endfunction

function logic [47:0] multicast_MAC(input [127:0] ip);
    static logic [15:0] mac_suffix = {<<8{16'h3333}};
    return {ip[127:96], mac_suffix};
endfunction

`endif
