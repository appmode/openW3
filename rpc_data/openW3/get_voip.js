{
    "error"  : null, 
    "id"     : null, 
    "result" :
    {
		"voip" :
		{
			"line" :
			{
				"03023635314":
				{
					"trunk" :"telekom",
					"clir"  :"1",
					"ring"  :
					[
					   "1001"
					]
				 },
				 "03023635309":
				 {
					"trunk" :"telekom",
					"ring"  :
					[
					   "1000"
					]
				 },
				 "03023635311":
				 {
					"trunk" :"telekom",
					"ring"  :
					[
					   "1001"
					]
				 }
			},
			"ext" :
			{
				 "1000":
				 {
					"target" : "TAPI/1",
					"cid"    : "03023635309"
				 },
				 "1001" :
				 {
					"target" : "TAPI/2",
					"cid"    : "03023635309"
				 }
			},
			"trunk" :
			{
				"telekom" :
				{
					"disabled" : "0",
					"type"     : "telekom",
					"t_mail"   : "anonymous@t-online.de",
					"use_wan_credentials" : "1" 
				}
			},
			"up" : false
		}
    }
}
