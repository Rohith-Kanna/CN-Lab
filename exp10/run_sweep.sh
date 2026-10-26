#!/usr/bin/env bash
set -euo pipefail

command -v ns >/dev/null || { echo "ns not found. Enter the ns2lab Distrobox and install ns2." >&2; exit 1; }
command -v gawk >/dev/null || { echo "gawk not found. Install it with: sudo apt install gawk" >&2; exit 1; }

printf 'delay_ms,flow1_mbps,flow2_mbps\n' > results.csv
for d in 10ms 20ms 40ms 60ms 80ms; do
    echo "Running delay $d ..."
    ns LAN.tcl "$d" 0
    m="metrics_${d}.txt"
    f1=$(gawk '/FLOW 1:/ {flow=1; next} /FLOW 2:/ {flow=2; next} /Throughput \(Mbps\)/ && flow==1 {print $4; exit}' "$m")
    f2=$(gawk '/FLOW 1:/ {flow=1; next} /FLOW 2:/ {flow=2; next} /Throughput \(Mbps\)/ && flow==2 {print $4; exit}' "$m")
    printf '%s,%s,%s\n' "${d%ms}" "${f1:-0}" "${f2:-0}" >> results.csv
done

echo "Saved: results.csv"
if command -v gnuplot >/dev/null; then
    gnuplot <<'GPLOT'
set datafile separator comma
set terminal pngcairo size 1000,650
set output 'throughput_vs_delay.png'
set title 'IEEE 802.3 Ethernet: Throughput vs LAN Delay'
set xlabel 'LAN propagation delay (ms)'
set ylabel 'Throughput (Mbps)'
set key outside
set grid
plot 'results.csv' every ::1 using 1:2 with linespoints title 'Flow n0 -> n5', \
     'results.csv' every ::1 using 1:3 with linespoints title 'Flow n1 -> n4'
GPLOT
    echo "Saved: throughput_vs_delay.png"
else
    echo "gnuplot not installed; install it with: sudo apt install gnuplot -y"
fi
