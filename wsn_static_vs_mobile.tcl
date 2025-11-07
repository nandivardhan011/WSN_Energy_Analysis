# ======================================================================
# Title  : WSN Energy Analysis - Static vs Mobile Nodes
# Author : B NANDIVARDHAN REDDY
# Date   : 2025
# Description:
#   This TCL script simulates Wireless Sensor Networks (WSN) in NS-2
#   for static, half-mobile, and fully mobile node scenarios.
#   The script logs energy consumption for each node over time.
# ======================================================================

# -------------- Simulation Parameters --------------
set val(chan)           Channel/WirelessChannel
set val(prop)           Propagation/TwoRayGround
set val(netif)          Phy/WirelessPhy
set val(mac)            Mac/802_11
set val(ifq)            Queue/DropTail/PriQueue
set val(ll)             LL
set val(ant)            Antenna/OmniAntenna
set val(ifqlen)         50
set val(nn)             50                    ;# number of nodes
set val(x)              500                   ;# X dimension
set val(y)              500                   ;# Y dimension
set val(stop)           20.0                  ;# simulation stop time (sec)
set val(rp)             AODV                  ;# routing protocol
set val(initialenergy)  1000                  ;# initial energy in Joules
set val(txPower)        0.660                 ;# Tx power (W)
set val(rxPower)        0.395                 ;# Rx power (W)
set val(idlePower)      0.035                 ;# Idle power (W)
set val(mobile_fraction) 0.5                  ;# 0.0 = Static, 0.5 = Half-Mobile, 1.0 = Fully Mobile

# Create simulator
set ns_ [new Simulator]

# Open trace files
set tracefile [open wsn.tr w]
set namfile   [open wsn.nam w]
$ns_ trace-all $tracefile
$ns_ namtrace-all-wireless $namfile $val(x) $val(y)

# Topography
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)

# God (Global Operations Director)
create-god $val(nn)

# Define channel
set chan [new $val(chan)]

# Configure node parameters
$ns_ node-config \
    -adhocRouting $val(rp) \
    -llType $val(ll) \
    -macType $val(mac) \
    -ifqType $val(ifq) \
    -ifqLen $val(ifqlen) \
    -antType $val(ant) \
    -propType $val(prop) \
    -phyType $val(netif) \
    -channel $chan \
    -topoInstance $topo \
    -energyModel EnergyModel \
    -initialEnergy $val(initialenergy) \
    -rxPower $val(rxPower) \
    -txPower $val(txPower) \
    -idlePower $val(idlePower)

# -------------- Node Creation --------------
for {set i 0} {$i < $val(nn)} {incr i} {
    set node_($i) [$ns_ node]
    $node_($i) random-motion 0 ;# Disable random motion initially
}

# -------------- Node Placement --------------
for {set i 0} {$i < $val(nn)} {incr i} {
    set x [expr rand()*$val(x)]
    set y [expr rand()*$val(y)]
    $node_($i) set X_ $x
    $node_($i) set Y_ $y
    $node_($i) set Z_ 0.0
}

# -------------- Mobility Configuration --------------
set num_mobile [expr int($val(nn) * $val(mobile_fraction))]
for {set i 0} {$i < $num_mobile} {incr i} {
    set mx [expr rand()*$val(x)]
    set my [expr rand()*$val(y)]
    set speed [expr 2.0 + (rand()*4.0)] ;# 2–6 m/s
    $ns_ at 1.0 "$node_($i) setdest $mx $my $speed"
}

# -------------- Traffic Configuration (CBR over UDP) --------------
set cbr_start 1.0
set cbr_interval 1.0

for {set i 0} {$i < 10} {incr i} {
    set udp_($i) [new Agent/UDP]
    set null_($i) [new Agent/Null]
    set cbr_($i) [new Application/Traffic/CBR]
    $cbr_($i) set packetSize_ 512
    $cbr_($i) set interval_ 0.5

    set src [expr int(rand()*$val(nn))]
    set dst [expr int(rand()*$val(nn))]

    if {$src != $dst} {
        $ns_ attach-agent $node_($src) $udp_($i)
        $ns_ attach-agent $node_($dst) $null_($i)
        $ns_ connect $udp_($i) $null_($i)
        $cbr_($i) attach-agent $udp_($i)
        $ns_ at $cbr_start "$cbr_($i) start"
    }
}

# -------------- Energy Logging Function --------------
set energy_log [open "energy_log.txt" w]
puts $energy_log "#time node energy"

proc log_energy {ns file nodes interval stop_time} {
    for {set t 0.0} {$t <= $stop_time} {set t [expr $t + $interval]} {
        $ns at $t "record_energy $file $nodes $t"
    }
}

proc record_energy {file nodes t} {
    global node_
    for {set i 0} {$i < $nodes} {incr i} {
        set energy [$node_($i) energy]
        puts $file "$t $i $energy"
    }
}

log_energy $ns_ $energy_log $val(nn) 1.0 $val(stop)

# -------------- End Simulation --------------
$ns_ at $val(stop) "finish"

proc finish {} {
    global ns_ tracefile namfile energy_log
    $ns_ flush-trace
    close $tracefile
    close $namfile
    close $energy_log
    puts "Simulation finished. Energy data saved to energy_log.txt"
    exec nam wsn.nam &
    exit 0
}

puts "Simulation running... please wait"
$ns_ run
