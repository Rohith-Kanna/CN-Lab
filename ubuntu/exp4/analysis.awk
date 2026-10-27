BEGIN {
	rec=0
	drop=0
	sent=0
	ratio=0
	
}
$1=="+" && $3==0 {
	sent++
}
$1=="r" && $4==4 {
	rec++
}
$1=="d"{
	drop++
}
END {
	
	if(sent>0)
		ratio=(rec/sent)*100

	printf("\nTotal Packets Sent : %d",sent)
	printf("\nTotal Packets Rec : %d",rec)	
	printf("\nTotal Packets Dropped : %d",drop)
	printf("\nPacket Delivery Ratio: %.2f%%",ratio)
}
