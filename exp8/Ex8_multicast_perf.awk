BEGIN {
    sent_packets = 0;
    received_packets = 0;
}

{
    # NS-2 trace format columns:
    # $1=event (s=send, r=receive, d=drop)
    # $5=packet type (cbr, tcp, etc.)
   
    event = $1;
    pkt_type = $5;

    # Count all CBR packets sent by the traffic sources
    if (event == "+" && pkt_type == "cbr") {
        sent_packets++;
    }

    # Count all CBR packets successfully received at destination nodes
    if (event == "r" && pkt_type == "cbr") {
        received_packets++;
    }
}

END {
    print "==========================================";
    print "       MULTICAST ROUTING ANALYSIS         ";
    print "==========================================";
    printf "Total CBR Packets Sent     : %d\n", sent_packets;
    printf "Total CBR Packets Received : %d\n", received_packets;
   
    if (sent_packets > 0) {
        pdr = (received_packets / sent_packets) * 100;
        printf "Packet Delivery Ratio (PDR): %.2f%%\n", pdr;
    } else {
        print "Packet Delivery Ratio (PDR): 0.00% (No packets sent)";
    }
    print "==========================================";
}
