set ns [new Simulator]
set tf [open 1684.tr w]
$ns trace-all $tf
set topo [new Topography]
$topo load_flatgrid 1000 1000
set nf [open 1684.nam w]
$ns namtrace-all-wireless $nf 1000 1000
set val(chan) Channel/WirelessChannel;
set val(prop) Propagation/TwoRayGround;

set val(netif) Phy/WirelessPhy;
set val(mac) Mac/802_11;
set val(ifq) Queue/DropTail/PriQueue;
set val(ll) LL;
set val(ant) Antenna/OmniAntenna;
set val(ifqlen) 50;
set val(nn) 2;
set val(rp) AODV;
set val(x) 500;
set val(y) 400;
set val(stop) 10.0;

$ns node-config -adhocRouting $val(rp)\
-llType $val(ll)\
-macType $val(mac)\
-ifqType $val(ifq)\
-ifqLen $val(ifqlen)\
-antType $val(ant)\
-propType $val(prop)\
-phyType $val(netif)\
-channelType $val(chan)\
-topoInstance $topo\
-agentTrace ON\
-routerTrace ON\
-macTrace OFF\
-movementTrace ON

create-god 3
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]

$n0 label "tcp0"
$n1 label "sink1/tcp1"
$n2 label "sink2"

$n0 set X_ 50
$n0 set Y_ 50
$n0 set Z_ 0
$n1 set X_ 100
$n1 set Y_ 100
$n1 set Z_ 0
$n2 set X_ 600
$n2 set Y_ 600
$n2 set Z_ 0
$ns at 0.1 "$n0 setdest 50 50 15"
$ns at 0.1 "$n1 setdest 100 100 25"
$ns at 0.1 "$n2 setdest 600 600 25"

set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
set sink1 [new Agent/TCPSink]
$ns attach-agent $n1 $sink1
$ns connect $tcp0 $sink1
set tcp1 [new Agent/TCP]
$ns attach-agent $n1 $tcp1
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
set sink2 [new Agent/TCPSink]
$ns attach-agent $n2 $sink2
$ns connect $tcp1 $sink2
$ns at 5 "$ftp0 start"
$ns at 5 "$ftp1 start"
$ns at 100 "$n1 setdest 550 550 15"
$ns at 190 "$n1 setdest 70 70 15"

proc finish { } {
global ns nf tf
$ns flush-trace
exec nam 1684.nam &
close $tf
exit 0
}
$ns at 250 "finish"
$ns run
