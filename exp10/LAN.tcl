# Experiment 10: IEEE 802.3 Wired Ethernet LAN (based on supplied lab PDF)
# Six nodes, shared LAN, two FTP-over-TCP flows, 10-second simulation.

set ns [new Simulator]

# Optional first argument changes LAN delay, e.g. 10ms, 20ms, 40ms.
set delay "20ms"
if {$argc > 0} {
    set delay [lindex $argv 0]
}

set traceFile "LAN_${delay}.tr"
set namFile "LAN_${delay}.nam"
set metricsFile "metrics_${delay}.txt"
set tr [open $traceFile w]
$ns trace-all $tr
set nam [open $namFile w]
$ns namtrace-all $nam

# Create six nodes: n0 through n5
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

# Shared IEEE 802.3 LAN: bandwidth fixed at 0.2 Mb, delay configurable
$ns make-lan "$n0 $n1 $n2 $n3 $n4 $n5" 0.2Mb $delay LL Queue/DropTail Mac/802_3

# Flow 1: n0 -> n5
set tcp1 [new Agent/TCP]
set sink1 [new Agent/TCPSink]
$ns attach-agent $n0 $tcp1
$ns attach-agent $n5 $sink1
$ns connect $tcp1 $sink1
set app1 [new Application/FTP]
$app1 attach-agent $tcp1

# Flow 2: n1 -> n4
set tcp2 [new Agent/TCP]
set sink2 [new Agent/TCPSink]
$ns attach-agent $n1 $tcp2
$ns attach-agent $n4 $sink2
$ns connect $tcp2 $sink2
set app2 [new Application/FTP]
$app2 attach-agent $tcp2

proc finish {} {
    global ns tr nam traceFile namFile metricsFile showNam
    $ns flush-trace
    close $tr
    close $nam
    # Analyze the closed trace after the simulation has finished.
    if {[file exists "anal.awk"] && [file exists $traceFile]} {
        if {[catch {exec gawk -f anal.awk $traceFile > $metricsFile} err]} {
            puts "AWK analysis was not run: $err"
            puts "Run manually: gawk -f anal.awk $traceFile"
        } else {
            puts "\nAnalysis saved to $metricsFile"
            set f [open $metricsFile r]
            puts [read $f]
            close $f
        }
    }
    # Open NAM animation. Set second argument to 0 to skip NAM.
    if {$showNam} {
        exec nam $namFile &
    }
    exit 0
}

set showNam 1
if {$argc > 1} {
    set showNam [lindex $argv 1]
}

# Start FTP sessions at different times, as in the lab PDF
$ns at 0.1 "$app1 start"
$ns at 0.4 "$app2 start"

# Finish at 10 seconds
$ns at 10.0 "finish"
$ns run
