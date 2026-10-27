
# Create simulator
set ns [new Simulator]

# Create trace files
set nf [open prog.nam w]
$ns namtrace-all $nf

set nd [open prog.tr w]
$ns trace-all $nd

# Finish procedure
proc finish {} {
    global ns nf nd
    $ns flush-trace
    close $nf
    close $nd
    #exec nam prog.nam &
    exit 0
}

# Create seven nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]

# Create Ethernet LAN
$ns make-lan "$n0 $n1 $n2 $n3 $n4 $n5 $n6" 0.2Mb 40ms LL Queue/DropTail Mac/802_3

# Create TCP connection
set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp

set sink [new Agent/TCPSink]
$ns attach-agent $n5 $sink
$ns connect $tcp $sink

# Attach FTP to TCP
set ftp [new Application/FTP]
$ftp attach-agent $tcp

# Schedule events
$ns at 1.0 "$ftp start"
$ns at 5.0 "$ftp stop"
$ns at 5.5 "finish"

# Run simulation
$ns run
