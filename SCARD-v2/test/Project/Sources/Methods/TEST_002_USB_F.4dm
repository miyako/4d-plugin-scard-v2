//%attributes = {}
  //libusb: SONY S380 specific (doesn't work for other models!)

$options:=New object:C1471("libusb";True:C214)
$readers:=SCARD Get readers ($options)

$readers:=$readers.query("usb != null and manufacturer == :1";"Sony")

If ($readers.length#0)
	
	$reader:=$readers[0]
	
	$reader.timeout:=9  //seconds
	
	$status:=SCARD Read tag ($reader)
	
	If ($status.success)
		ALERT:C41($status.IDm+":"+$status.PMm)
	End if 
	
End if 