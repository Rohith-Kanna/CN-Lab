#Create a simulator objectset
set ns [new Simulator]

#Create a trace file, this file is for logging purpose
set tracefile [open wired.tr w]
$ns trace-all $tracefile

#Create a animation infomration or NAM file creationset
namfile [open wired.nam w]
$ns namtrace-all $namfile

#Create nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

#Creation of link between nodes with DropTail Queue
#Droptail means Dropping the tail.
$ns duplex-link $n0 $n2 5Mb 2ms DropTail
$ns duplex-link $n1 $n2 10Mb 5ms DropTail
$ns duplex-link $n2 $n3 4Mb 3ms DropTail
$ns duplex-link $n3 $n4 100Mb 2ms DropTail
$ns duplex-link $n3 $n5 15Mb 4ms DropTail

#Creation of Agents
#Node 0 to Node 4
set udp [new Agent/UDP]
set null [new Agent/Null]
$ns attach-agent $n0 $udp
$ns attach-agent $n4 $null
$ns connect $udp $null

#Creation of TCP Agent
set tcp [new Agent/TCP]
set sink [new Agent/TCPSink]
$ns attach-agent $n1 $tcp
$ns attach-agent $n5 $sink
$ns connect $tcp $sink

#Creation of Application CBR, FTP
#CBR - Constant Bit Rate (Example mp3 files that have a CBR or 192kbps, 320kbps, etc.)
#FTP - File Transfer Protocol (Ex: To download a file from a network)

set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp

set ftp [new Application/FTP]
$ftp attach-agent $tcp

#Start the traffic
$ns at 1.0 "$cbr start"
$ns at 2.0 "$ftp start"

$ns at 10.0 "finish"

#The following procedure will be called at 10.0 seconds
proc finish {} {
global ns tracefile namfile
$ns flush-trace
close $tracefile
close $namfile
exit 0
}

puts "Simulation is starting..."
$ns run