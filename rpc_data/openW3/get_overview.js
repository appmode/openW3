{
	"error"  : null, 
	"id"     : null, 
	"result" :
	{
		"wireless" :
		{
			"radio0" :
			{
				"channel"    : 11, 
				"disabled"   : 0,
				"encryption" : "psk2", 
				"hidden"     : 0, 
				"key"        : "passwordpassword", 
				"macaddr"    : "00:0e:8e:3e:54:3a", 
				"ssid"       : "fnord_24GHz",
				"up"         : true
			},
			"radio1" :
			{
				"channel"    : 11, 
				"disabled"   : 0,
				"encryption" : "psk2", 
				"hidden"     : 1, 
				"key"        : "passwordpassword", 
				"macaddr"    : "00:0e:8e:3e:54:82",
				"ssid"       : "fnord_5GHz_hidden",
				"up"         : true
			}
		},
		"wan" :
		{
			"dns": "217.0.43.65",
			"dns2": "217.0.43.66",  
			"ipaddr": "80.129.29.110", 
			"netmask": "255.255.255.255", 
			"password": "78370871", 
			"proto": "pppoe", 
			"route": "217.0.117.133", 
			"t_callident": "002650773832", 
			"t_mbnr": [
				"0", 
				"0", 
				"0", 
				"1" 
			], 
			"t_number": "551115461297", 
			"up": false,
			"pending": false,
			"username": "0026507738325511154612970001@t-online.de" 
		},
		"voip" :
		{
			"line" :
			{
				"03023635314":{
					"trunk":"telekom",
					"clir":"1",
					"ring":[
					   "1001"
					]
				 },
				 "03023635309":{
					"trunk":"telekom",
					"ring":[
					   "1000"
					]
				 },
				 "03023635311":{
					"trunk":"telekom",
					"ring":[
					   "1001"
					]
				 }
			},
			"ext" :
			{
				 "1000":{
					"target":"TAPI/1",
					"cid":"03023635309"
				 },
				 "1001":{
					"target":"TAPI/2",
					"cid":"03023635309"
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
			"up" : true
		},
		"vpn" :
		{
			"type" : "server",
			"enable" : "1",
			"port" : "1194",
			"proto" : "udp",
			"dev" : "tun",
			"ca" : "/etc/easy-rsa/keys/ca.crt",
			"cert" : "/etc/easy-rsa/keys/server-dogfood.crt",
			"key" : "/etc/easy-rsa/keys/server-dogfood.key",
			"dh" : "/etc/easy-rsa/keys/dh2048.pem",
			"ifconfig_pool_persist" : "/tmp/ipp.txt",
			"keepalive" : "10 120",
			"comp_lzo" : "0",
			"persist_key" : "1",
			"persist_tun" : "1",
			"status" : "/var/log/openvpn-status.log",
			"log" : "/var/log/openvpn.log",
			"verb" : "3",
			"server" : "10.0.0.0 255.255.255.0",
			"up" : false
		},
		"openrouter_config" :
		{
			"assistant":
			{
				".name": "assistant",
				".type": "assistant",
				"wlanFinished": "1",
				".anonymous": false,
				".index": 0
			}
		},
		"lan" :
		{
			"proto": "static",
			"ipaddr": "192.168.2.1",
			"up": true,
			"netmask": "255.255.255.0",
			"mac_address": "AC:9A:96:F0:63:A0" 
		},
		"external_modem" :
		{
			"enabled" : 0
		}
	}
}
