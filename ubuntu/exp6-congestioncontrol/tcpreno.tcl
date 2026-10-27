set ns [new Simulator]

set tr [open reno.tr w]
$ns trace-all $tr

set nf [open reno.nam w]
$ns namtrace-all $nf

set tf [open "throughput_reno" w]

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

$ns duplex-link $n0 $n2 10Mb 2ms DropTail
$ns duplex-link $n1 $n2 3Mb 12ms DropTail
$ns duplex-link $n3 $n2 5Mb 1ms DropTail
$ns duplex-link $n3 $n4 2Mb 5ms DropTail
$ns duplex-link $n3 $n5 7Mb 2ms DropTail

set tcpreno [new Agent/TCP/Reno]
set sink [new Agent/TCPSink]
$ns attach-agent $n0  $tcpreno
$ns attach-agent $n5 $sink
$ns connect $tcpreno $sink

$sink set bytes_ 0

set http [new Application/Traffic/Exponential]
$http attach-agent $tcpreno



proc record {} {
	global ns tf sink
	
	set time 0.1
	set now [$ns now]
	set bw [$sink set bytes_]
	
	puts $tf "$now [expr $bw/$time*8/1000000]"
	$sink set bytes_ 0
	$ns at [expr $time+$now] "record"
}

proc plotwindow {tcp outfile} {
	global ns 
	
	set time 0.1
	set now [$ns now]
	set cwnd [$tcp set cwnd_]
	
	puts $outfile "$now $cwnd"
	$ns at [expr $time+$now] "plotwindow $tcp $outfile"
}
set of [open "renoplot" w]
$ns at 0.0 "plotwindow $tcpreno $of"

proc finish {} {
	global ns tf nf tr
	
	$ns flush-trace
	close $tf
	close $nf
	close $tr
	
	exec nam reno.nam &
	exec xgraph throughput_reno &
	exec xgraph renoplot &
	exit 0

}
$ns at 0.4 "record"
$ns at 1.0 "$http start"
$ns at 7.0 "$http stop"
$ns at 10.0 "finish"
$ns run















