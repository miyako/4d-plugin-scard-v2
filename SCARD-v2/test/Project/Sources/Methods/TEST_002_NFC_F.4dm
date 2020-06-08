//%attributes = {}
  //SONY S360 might not work after 1st call

$options:=New object:C1471("libnfc";True:C214)
$readers:=SCARD Get readers ($options)

$readers:=$readers.query("nfc != null")

If ($readers.length#0)
	
	$reader:=$readers[0]
	
	$reader.timeout:=9  //seconds
	
	$status:=SCARD Read tag ($reader)
	
	If ($status.success)
		ALERT:C41($status.IDm+":"+$status.PMm)
	End if 
	
End if 