set ns [new Simulator]
$ns rtproto DV

set tracefile [open dvr.tr w]
$ns trace-all $tracefile

set namfile [open dvr.nam w]
$ns namtrace-all $namfile

set dvrf [open dvr_th w]

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]


$ns duplex-link $n0 $n2 10Mb 2ms DropTail
$ns duplex-link $n1 $n2 7Mb 8ms DropTail
$ns duplex-link $n2 $n3 5Mb 5ms DropTail
$ns duplex-link $n3 $n4 6Mb 4ms DropTail
$ns duplex-link $n3 $n5 2Mb 2ms DropTail

set tcp [new Agent/TCP]
set sink [new Agent/LossMonitor]
$ns attach-agent $n1 $tcp
$ns attach-agent $n0 $sink
$ns connect $tcp $sink

set ftp [new Application/FTP]
$ftp attach-agent $tcp

proc  record {} {
	global dvrf sink ns
	set now [$ns now]
	set time 0.1
	set bw0 [$sink set bytes_]
	puts $dvrf "$now [expr $bw0/$time*8/1000000]"
	$sink set bytes_ 0
	
	$ns at [expr $now+$time] "record"

}
proc finish {} {
	global ns tracefile namfile dvrf
	$ns flush-trace
	close $tracefile
	close $namfile
	close $dvrf
	
	exec nam dvr.nam &
	exec xgraph dvr_th &
	
	exit 0
}

$ns at 1.0 "$ftp start"
$ns at 0.5 "record"

$ns rtmodel-at 2.0 down $n2 $n3
$ns rtmodel-at 3.0 up $n2 $n3
$ns at 5.0 "$ftp stop"
$ns at 10.0 "finish"

$ns run
