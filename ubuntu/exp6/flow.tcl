set ns [new Simulator]

set tr [open flow.tr w]
$ns trace-all $tr

set nf [open flow.nam w]
$ns namtrace-all $nf

set ft0 [open "throughput1" w]
set ft1 [open "throughput2" w]
set ft2 [open "throughput3" w]
set ft3 [open "total_throughput" w]


set bw0 [open "bandwidth1" w]
set bw1 [open "bandwidth2" w]
set bw2 [open "bandwidth3" w]
set bw3 [open "total_bandwidth" w]

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

set tcp1 [new Agent/TCP]
set sink1 [new Agent/TCPSink]
$ns attach-agent $n0 $tcp1
$ns attach-agent $n5 $sink1
$ns connect $tcp1 $sink1
$sink1 set bytes_ 0

set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1

set tcp2 [new Agent/TCP]
set sink2 [new Agent/TCPSink]
$ns attach-agent $n1 $tcp2
$ns attach-agent $n4 $sink2
$ns connect $tcp2 $sink2
$sink2 set bytes_ 0

set smtp1 [new Application/Traffic/Exponential]
$smtp1 attach-agent $tcp2

set tcp3 [new Agent/TCP]
set sink3 [new Agent/TCPSink]
$ns attach-agent $n2 $tcp3
$ns attach-agent $n3 $sink3
$ns connect $tcp3 $sink3
$sink3 set bytes_ 0

set http1 [new Application/Traffic/Exponential]
$http1 attach-agent $tcp3


$ns at 1.0 "$ftp1 start"
$ns at 2.0 "$ftp1 stop"

$ns at 3.0 "$smtp1 start"
$ns at 4.0 "$smtp1 stop"

$ns at 5.0 "$http1 start"
$ns at 6.0 "$http1 stop"




proc record {} {
	global ns nf ft1 ft2 ft3 ft0 bw0 bw1 bw2 bw3
	global sink1 sink2 sink3
	set time 0.1
	set now [$ns now]
	
	set bt0 [$sink1 set bytes_]
	set bt1 [$sink2 set bytes_]
	set bt2 [$sink3 set bytes_]
	set bt3 [expr $bt0+$bt1+$bt2]
	
	puts $ft0 "$now [expr $bt0/$time *8/1000000]"
	puts $ft1 "$now [expr $bt1/$time *8/1000000]"
	puts $ft2 "$now [expr $bt2/$time *8/1000000]"
	puts $ft3 "$now [expr $bt3/$time *8/1000000]"
	
	puts $bw0 "$now $bt0"
	puts $bw1 "$now $bt1"
	puts $bw2 "$now $bt2"
	puts $bw3 "$now $bt3"
	
	$sink1 set bytes_ 0
	$sink2 set bytes_ 0
	$sink3 set bytes_ 0
	
	
	$ns at [expr $now+$time] "record"
}

$ns at 1.0 "record"
proc finish {} {
	global tr nf ft1 ft2 ft3 ft0 bw0 bw1 bw2 bw3

	close $nf
	close $tr
	close $ft1
	close $ft2
	close $ft3
	close $ft0
	close $bw0
	close $bw1
	close $bw2
	close $bw3
	exec nam flow.nam &
	exec xgraph throughput1 throughput2 throughput3 total_throughput &
	exec xgraph bandwidth1 bandwidth2 bandwidth3 total_bandwidth &
	
	exit 0	
}
$ns at 10.0 "finish"
$ns run








