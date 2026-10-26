
# Simplified NS2 Wireless Simulation
# 15 nodes, AODV routing, CBR and FTP traffic

# Wireless parameters
set val(chan)   Channel/WirelessChannel
set val(prop)   Propagation/TwoRayGround
set val(ant)    Antenna/OmniAntenna
set val(ll)     LL
set val(ifq)    Queue/DropTail/PriQueue
set val(ifqlen) 50
set val(netif)  Phy/WirelessPhy
set val(mac)    Mac/802_11
set val(nn)     15
set val(rp)     AODV
set val(x)      800
set val(y)      800

Mac/802_11 set dataRate_ 1Mb

# Create simulator and trace files
set ns [new Simulator]

set tr [open complexdcf.tr w]
$ns trace-all $tr

set nf [open complexdcf.nam w]
$ns namtrace-all-wireless $nf $val(x) $val(y)

set tf [open C_DCF_AT.tr w]

# Create topology and wireless channel
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)
create-god $val(nn)

set chan [new $val(chan)]

# Configure wireless nodes
$ns node-config \
    -adhocRouting $val(rp) \
    -llType $val(ll) \
    -macType $val(mac) \
    -ifqType $val(ifq) \
    -ifqLen $val(ifqlen) \
    -antType $val(ant) \
    -propType $val(prop) \
    -phyType $val(netif) \
    -topoInstance $topo \
    -agentTrace ON \
    -routerTrace ON \
    -macTrace ON \
    -movementTrace OFF \
    -channel $chan

# Create 15 wireless nodes
for {set i 0} {$i < $val(nn)} {incr i} {
    set n($i) [$ns node]
    $n($i) random-motion 0
}

# Initial node positions
for {set i 0} {$i < $val(nn)} {incr i} {
    $ns initial_node_pos $n($i) 30
}

# Node movement
set positions {
    {100 100} {200 200} {300 200} {400 300} {500 300}
    {600 400} {600 100} {600 200} {600 300} {600 350}
    {700 100} {700 200} {700 300} {700 350} {700 400}
}

for {set i 0} {$i < $val(nn)} {incr i} {
    set pos [lindex $positions $i]
    set x [lindex $pos 0]
    set y [lindex $pos 1]
    $ns at 0.0 "$n($i) setdest $x $y 3000"
}

$ns at 2.0 "$n(5) setdest 100 400 500"
$ns at 1.5 "$n(3) setdest 450 150 500"
$ns at 50.0 "$n(7) setdest 300 400 500"
$ns at 2.0 "$n(10) setdest 200 400 500"
$ns at 2.0 "$n(11) setdest 650 400 500"

# Create receiving agents
foreach id {1 3 7 10 11} {
    set sink($id) [new Agent/LossMonitor]
    $ns attach-agent $n($id) $sink($id)
}

# Create TCP and FTP connections
foreach {src dst} {
    6 10
    14 10
    9 7
    13 7
    8 11
    12 11
} {
    set tcp($src) [new Agent/TCP]
    $ns attach-agent $n($src) $tcp($src)
    $ns connect $tcp($src) $sink($dst)

    set ftp($src) [new Application/FTP]
    $ftp($src) attach-agent $tcp($src)
}

# Create CBR traffic
proc makeCBR {src dst} {
    global ns n sink

    set cbr [new Agent/CBR]
    $cbr set packetSize_ 1000
    $cbr set interval_ 0.015

    $ns attach-agent $n($src) $cbr
    $ns connect $cbr $sink($dst)

    return $cbr
}

set cbr0 [makeCBR 0 3]
set cbr1 [makeCBR 5 3]
set cbr2 [makeCBR 2 1]
set cbr3 [makeCBR 4 1]

# Throughput calculation every 0.5 seconds
proc record {} {
    global ns sink tf

    set interval 0.5
    set total 0

    foreach id {1 3 7 10 11} {
        set bytes [$sink($id) set bytes_]
        set total [expr {$total + $bytes}]
        $sink($id) set bytes_ 0
    }

    set now [$ns now]
    set throughput [expr {$total * 8.0 / $interval / 1000000.0}]
    puts $tf "$now $throughput"

    if {$now < 899.5} {
        $ns at [expr {$now + $interval}] "record"
    }
}

# Start and stop CBR traffic
$ns at 20.0 "$cbr0 start"
$ns at 30.0 "$cbr1 start"
$ns at 20.0 "$cbr2 start"
$ns at 30.0 "$cbr3 start"

$ns at 800.0 "$cbr0 stop"
$ns at 850.0 "$cbr1 stop"
$ns at 850.0 "$cbr2 stop"
$ns at 870.0 "$cbr3 stop"

# Start and stop FTP traffic
foreach {src start stop} {
    6  25 810
    14 25 860
    9  35 830
    13 35 889
    8  40 820
    12 40 890
} {
    $ns at $start "$ftp($src) start"
    $ns at $stop  "$ftp($src) stop"
}

# Finish simulation
proc finish {} {
    global ns tr nf tf

    $ns flush-trace
    close $tr
    close $nf
    close $tf

    exec nam complexdcf.nam &
    exit 0
}

$ns at 0.0 "record"
$ns at 900.0 "finish"

puts "Starting wireless simulation..."
$ns run

