//%attributes = {}
  //use native API on both platforms. device driver from vendor must be installed 
$readers:=SCARD Get readers 

If ($readers.length#0)
	
	$reader:=$readers[0]
	
	  //no need to specify card type (FeLiCa, TypeA, TypeB...)
	  //default timeout is 3s
	
	$reader.timeout:=9
	
	  //valid options are: mode, scope, protocol
	
	$status:=SCARD Read tag ($reader)
	
	If ($status.success)
		
		Case of 
			: ($status.typeName=Null:C1517)  //D.C. metro SmarTrip
				ALERT:C41($status.IDm+":"+$status.PMm+":"+$status.type+":"+$status.cid)
				
			: ($status.typeName="Type A(T=CL)")  //S. Korea CITYPASS+, London oyster
				ALERT:C41(Substring:C12($status.IDm;1;8)+":"+Substring:C12($status.PMm;1;8)+":"+$status.type+":"+$status.cid)
				
			: ($status.typeName="FeLiCa")  //PASMO, nanaco
				ALERT:C41($status.IDm+":"+$status.PMm+":"+$status.type+":"+$status.cid)
				
			: ($status.typeName="Type A")  //SECOM Wireless IC Card
				ALERT:C41(Substring:C12($status.IDm;1;8)+":"+$status.cid)
				
		End case 
		
	End if 
	
End if 

