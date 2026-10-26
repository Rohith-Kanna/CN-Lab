# AWK analysis for the old NS-2 trace format used by the supplied lab PDF.
# Flow 1: n0 (0.0) -> n5 (5.0); Flow 2: n1 (1.0) -> n4 (4.0).

BEGIN {
    sent1 = recv1 = bytes1 = delaySum1 = delayCount1 = 0
    sent2 = recv2 = bytes2 = delaySum2 = delayCount2 = 0
    firstSend1 = firstSend2 = -1
    lastRecv1 = lastRecv2 = -1
}

# Flow 1 packet handed to the LAN (h = hop/transmission event)
$1 == "h" && $5 == "tcp" && $9 == "0.0" && $10 == "5.0" {
    sent1++
    sendTime1[$12] = $2
    if (firstSend1 < 0) firstSend1 = $2
}

# Flow 1 received TCP packet
$1 == "r" && $5 == "tcp" && $9 == "0.0" && $10 == "5.0" {
    recv1++
    bytes1 += $6
    lastRecv1 = $2
    if ($12 in sendTime1) {
        delaySum1 += ($2 - sendTime1[$12])
        delayCount1++
    }
}

# Flow 2 packet handed to the LAN
$1 == "h" && $5 == "tcp" && $9 == "1.0" && $10 == "4.0" {
    sent2++
    sendTime2[$12] = $2
    if (firstSend2 < 0) firstSend2 = $2
}

# Flow 2 received TCP packet
$1 == "r" && $5 == "tcp" && $9 == "1.0" && $10 == "4.0" {
    recv2++
    bytes2 += $6
    lastRecv2 = $2
    if ($12 in sendTime2) {
        delaySum2 += ($2 - sendTime2[$12])
        delayCount2++
    }
}

END {
    pdr1 = (sent1 > 0) ? (recv1 / sent1) * 100 : 0
    plr1 = 100 - pdr1
    pdr2 = (sent2 > 0) ? (recv2 / sent2) * 100 : 0
    plr2 = 100 - pdr2

    throughput1 = (lastRecv1 > firstSend1 && firstSend1 >= 0) ? (bytes1 * 8) / ((lastRecv1 - firstSend1) * 1000000) : 0
    throughput2 = (lastRecv2 > firstSend2 && firstSend2 >= 0) ? (bytes2 * 8) / ((lastRecv2 - firstSend2) * 1000000) : 0
    avgDelay1 = (delayCount1 > 0) ? delaySum1 / delayCount1 : 0
    avgDelay2 = (delayCount2 > 0) ? delaySum2 / delayCount2 : 0

    print "======================================================="
    print "        IEEE 802.3 WIRED ETHERNET ANALYSIS"
    print "======================================================="
    print "FLOW 1: n0 -> n5"
    printf "Packets Sent       : %d\n", sent1
    printf "Packets Received   : %d\n", recv1
    printf "Packets Lost*      : %d\n", (sent1 - recv1)
    printf "Total Data (Bytes) : %.0f\n", bytes1
    printf "PDR (%%)            : %.2f\n", pdr1
    printf "PLR (%%)            : %.2f\n", plr1
    printf "Average Delay (s)  : %.6f\n", avgDelay1
    printf "Throughput (Mbps)  : %.6f\n\n", throughput1

    print "FLOW 2: n1 -> n4"
    printf "Packets Sent       : %d\n", sent2
    printf "Packets Received   : %d\n", recv2
    printf "Packets Lost*      : %d\n", (sent2 - recv2)
    printf "Total Data (Bytes) : %.0f\n", bytes2
    printf "PDR (%%)            : %.2f\n", pdr2
    printf "PLR (%%)            : %.2f\n", plr2
    printf "Average Delay (s)  : %.6f\n", avgDelay2
    printf "Throughput (Mbps)  : %.6f\n", throughput2
    print "======================================================="
    print "*Packets Lost = packets counted as sent minus received;"
    print "  interpret cautiously when TCP retransmissions occur."
}
