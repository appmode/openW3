{
    "error": null, 
    "id": null, 
    "result": {
		"vpn" :
		{
			"vpnmode" : "0",
			"openrouterserver" :
			{
				"enable" : "1",
				"ca" : "/etc/easy-rsa/keys/ca.crt",
				"cert" : "/etc/easy-rsa/keys/server-dogfood.crt",
				"key" : "/etc/easy-rsa/keys/server-dogfood.key",
				"dh" : "/etc/easy-rsa/keys/dh2048.pem",
				"up" : true,
				"route" : "192.168.42.0 255.255.255.0",
				"clientcn" : "client-catfood",
				"clientip" : "80.129.27.153",
				"clientrx" : "9384",
				"clienttx" : "11144"
			},
			"openrouterclient" :
			{
				"enable" : "0",
				"ca" : "/etc/easy-rsa/keys/ca.crt",
				"cert" : "/etc/easy-rsa/keys/client-catfood.crt",
				"key" : "/etc/easy-rsa/keys/client-catfood.key",
				"dh" : "/etc/easy-rsa/keys/dh2048.pem",
				"up" : true,
				"remote" : "dogfood.zapto.org"
			}
		}
    }
}
