BEGIN {
    flag = 0
    first = 0
    last = 0
    bytes = 0
}

{
    if ($1 == "r" && $4 == "AGT") {
        if (flag == 0) {
            flag=1
            first = $2
        }
        bytes += $6
        last = $2
    }
}

END {
    duration = last - first
    throughput = (duration > 0) ? (bytes * 8) / (duration * 1000) : 0

    printf "Throughput = %.2f Kbps\n", throughput
}