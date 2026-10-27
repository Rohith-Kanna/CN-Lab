#to run : awk -f analysis prog.tr
BEGIN {
    sent = 0
    recv = 0
    drop = 0
    bytes = 0
}

# TCP packets sent from node 0
$1 == "+" && $3 == 0 && $5 == "tcp" {
    sent++
}

# TCP packets received at node 5
$1 == "r" && $4 == 5 && $5 == "tcp" {
    recv++
    bytes += $6
}

# Dropped TCP packets
$1 == "d" && $5 == "tcp" {
    drop++
}

END {
    printf("Packets Sent      = %d\n", sent)
    printf("Packets Received  = %d\n", recv)
    printf("Packets Dropped   = %d\n", drop)

    if (sent > 0) {
        printf("Packet Delivery Ratio               = %.2f%%\n", recv / sent * 100)
        printf("Packet Loss       = %.2f%%\n", (sent - recv) / sent * 100)
    }

    printf("Received Bytes    = %d\n", bytes)
    printf("Throughput        = %.4f Mbps\n", bytes * 8 / 5.5 / 1000000)
}
