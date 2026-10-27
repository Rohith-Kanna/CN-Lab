set ns [new Simulator]

set tr [open lam.tr w]
$ns trace-all $tr

set nf [open lam.nam w]
$ns namtrace-all $nf

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]

$ns make-lan "$n0 $n1 $n2 $n3 $n4 $n5 $n6" 0.2Mb 10ms LL Queue/DropTail Mac/802_3

set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp

set sink [new Agent/TCPSink]
$ns attach-agent $n5 $sink

$ns connect $tcp $sink

set ftp [new Application/FTP]
$ftp attach-agent $tcp

$ns at 1.0 "$ftp start"
$ns at 2.0 "$ftp stop"
$ns at 5.0 "finish"

proc finish {} {
	global ns tr nf
	$ns flush-trace
	close $nf
	close $tr
	exit 0
}

$ns run















