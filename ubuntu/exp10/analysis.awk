BEGIN {
send=0
rec=0
drop=0
bytes=0
}


$1=="+" && $3="0" &&$5=="tcp"{
send++
}
$1=="r" && $3="5" &&$5=="tcp"{
rec++
}
$1=="d" &&$5=="tcp"{
drop++
}

END{
printf("Sent : %d",send)
printf("rec : %d",rec)
printf("dropped : %d",sdrop)
}
