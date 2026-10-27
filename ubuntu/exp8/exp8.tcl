set ns [new Simulator -multicast on]

set tracefile [open mcast.tr w]
$ns trace-all $tracefile

set namfile [open mcast.nam w]
$ns namtrace-all $namfile

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]

$ns duplex-link $n0 $n2 1.5Mb 10ms DropTail
$ns duplex-link $n1 $n2 1.5Mb 10ms DropTail
$ns duplex-link $n2 $n3 1.5Mb 10ms DropTail
$ns duplex-link $n3 $n4 1.5Mb 10ms DropTail
$ns duplex-link $n3 $n7 1.5Mb 10ms DropTail
$ns duplex-link $n4 $n5 1.5Mb 10ms DropTail
$ns duplex-link $n4 $n6 1.5Mb 10ms DropTail

set mproto DM
set mrthandle [$ns mrtproto $mproto {}]

set group1 [Node allocaddr]
set group2 [Node allocaddr]

#grp1
set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0

$udp0 set dst_addr_ $group1
$udp0 set dst_port_ 0

set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp0

#grp2
set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1

$udp1 set dst_addr_ $group1
$udp1 set dst_port_ 0

set cbr2 [new Application/Traffic/CBR]
$cbr2 attach-agent $udp1


#rec for grp1
set rec1 [new Agent/Null]
$ns attach-agent $n5 $rec1
$ns at 1.0 "$n5 join-group $rec1 $group1"

set rec2 [new Agent/Null]
$ns attach-agent $n6 $rec2
$ns at 1.0 "$n6 join-group $rec2 $group1"

set rec3 [new Agent/Null]
$ns attach-agent $n7 $rec3
$ns at 1.0 "$n7 join-group $rec3 $group1"

#rec for grp2
set rec4 [new Agent/Null]
$ns attach-agent $n5 $rec4
$ns at 1.0 "$n5 join-group $rec4 $group2"

set rec5 [new Agent/Null]
$ns attach-agent $n6 $rec5
$ns at 1.0 "$n6 join-group $rec5 $group2"

set rec6 [new Agent/Null]
$ns attach-agent $n7 $rec6
$ns at 1.0 "$n7 join-group $rec6 $group2"

#leave grp
$ns at 4.0 "$n5 leave-group $rec1 $group1"
$ns at 4.5 "$n6 leave-group $rec2 $group1"
$ns at 5.0 "$n7 leave-group $rec3 $group1"


$ns at 5.5 "$n5 leave-group $rec1 $group2"
$ns at 6.0 "$n6 leave-group $rec2 $group2"
$ns at 6.5 "$n7 leave-group $rec3 $group2"

$ns at 0.5 "$cbr1 start"
$ns at 9.5 "$cbr1 stop"

$ns at 0.5 "$cbr2 start"
$ns at 9.5 "$cbr2 stop"

$ns at 10.0 "finish"

proc finish {} {
	global ns tracefile namfile
	$ns flush-trace
	close $tracefile
	close $namfile
	exec nam mcast.nam &
	exit 0
}

$ns run
