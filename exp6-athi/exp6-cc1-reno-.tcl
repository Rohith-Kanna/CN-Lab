set ns [new Simulator]

set tf [open reno.tr w]
$ns trace-all $tf

set nf [open reno.nam w]
$ns namtrace-all $nf

# Throughput file
set ft3 [open reno_Sender_throughput w]

# Create 6 nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

# Create links
$ns duplex-link $n0 $n1 10Kb 10ms DropTail
$ns duplex-link $n0 $n3 100Kb 10ms RED
$ns duplex-link $n1 $n2 50Kb 10ms DropTail
$ns duplex-link $n2 $n5 200Kb 10ms RED
$ns duplex-link $n3 $n4 70Kb 10ms DropTail
$ns duplex-link $n4 $n5 100Kb 10ms DropTail

# TCP Reno
set tcp3 [new Agent/TCP/Reno]
set sink3 [new Agent/TCPSink]

$ns attach-agent $n0 $tcp3
$ns attach-agent $n5 $sink3
$ns connect $tcp3 $sink3

# Traffic
set http1 [new Application/Traffic/Exponential]
$http1 attach-agent $tcp3

# Record throughput
proc record {} {
    global ns sink3 ft3

    set time 0.1
    set now [$ns now]
    set bw [$sink3 set bytes_]

    puts $ft3 "$now [expr $bw/$time*8/1000000]"

    $sink3 set bytes_ 0
    $ns at [expr $now+$time] "record"
}

# Record congestion window
proc plotWindow {tcpSource outfile} {
    global ns

    set now [$ns now]
    set cwnd [$tcpSource set cwnd_]

    puts $outfile "$now $cwnd"
    $ns at [expr $now+0.1] "plotWindow $tcpSource $outfile"
}

set outfile [open congestion.xg w]
$ns at 0.0 "plotWindow $tcp3 $outfile"

# Finish
proc finish {} {
    global ns tf nf ft3

    $ns flush-trace
    close $tf
    close $nf
    close $ft3

    exec xgraph reno_Sender_throughput &
    exec xgraph congestion.xg &
    exec nam reno.nam &
    exit 0
}

# Schedule events
$ns at 0.5 "record"
$ns at 0.2 "$http1 start"
$ns at 3.2 "$http1 stop"
$ns at 5.0 "finish"

$ns run