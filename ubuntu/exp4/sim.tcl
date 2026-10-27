set ns [new Simulator]

set tracefile [open wired.tr w]
$ns trace-all $tracefile

set namfile [open wired.nam w]
$ns namtrace-all $namfile

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

$ns duplex-link $n0 $n2 10Mb 2Ms DropTail
$ns duplex-link $n1 $n2 7Mb 8Ms DropTail
$ns duplex-link $n2 $n3 5Mb 5Ms DropTail
$ns duplex-link $n3 $n4 6Mb 4Ms DropTail
$ns duplex-link $n3 $n5 2Mb 2Ms DropTail


set udp [new Agent/UDP]
set null [new Agent/Null]
$ns attach-agent $n0 $udp
$ns attach-agent $n4 $null
$ns connect $udp $null

set tcp [new Agent/TCP]
set sink [new Agent/TCPSink]
$ns attach-agent $n1 $tcp
$ns attach-agent $n5 $sink
$ns connect $tcp $sink

set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp

set ftp [new Application/FTP]
$ftp attach-agent $tcp

$ns at 1.0 "$cbr start"
$ns at 2.0 "$ftp start"
$ns at 10.0 "finish"

proc finish {} {
	global ns tracefile namfile
	$ns flush-trace
	close $tracefile
	close $namfile
	exit 0
}

$ns run
