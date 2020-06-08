//%attributes = {}
  //SONY S360 might not work after 1st call

$options:=New object:C1471("libnfc";True:C214)
$readers:=SCARD Get readers ($options)

$readers:=$readers.query("nfc != null")

If ($readers.length#0)
	
	$reader:=$readers[0]
	
	$reader.timeout:=9  //seconds
	$reader.card:="TypeB"
	
	$status:=SCARD Read tag ($reader)
	
	If ($status.success)
		ALERT:C41($status.pupi+":"+$status.appdata+":"+$status.pinfo)
	End if 
	
End if 