{
	"type"       : "tlabs/or/contentbox",
	"name"       : "lan",
	"dataSource" : "lan",
	"preload"    : true,
	"rpc"        :
	[
		"get_lan"
	],
	"style" :
	{
		"visible"  : false
	},
	"Children":
	{
		"ttlSettings":
		{
			"type"  : "tlabs/content/title",
			"i18n"  : "network_lan"
		},
		"hlpLan":
		{
			"type"      : "tlabs/content/help",
			"i18nTitle"	: "helpme_lan",
			"i18n"      : "helpme_lan_content"
		},
		"hlpAddress":
		{
			"type"      : "tlabs/content/help",
			"i18nTitle"	: "helpme_RouterName",
			"i18n"      : "helpme_RouterName_content"
		},
		"lblHostName":
		{
			"type"  : "tlabs/content/labelinput",
			"i18n"	: "network_lan_router_content_2",
			"value" : "openrouter.ip"
		},
		"lblMacAddress":
		{
			"type"      : "tlabs/content/labelinput",
			"i18n"	    : "network_lan_mac_content",
			"dataField" : "mac_address"
		},
		"inpIpV4":
		{
			"type"      : "tlabs/content/ipv4input",
			"i18n"	    : "network_lan_router_ip_v4",
			"dataField" : "ipaddr"
		},
		"btnSave":
		{
			"type"  : "tlabs/content/buttonbar",
			"style"	:
			{
				"position" : "absolute",
				"bottom"   : "0px"
			},
			"dataSource" : "lan",
			"confirm"    :
			{
				"i18nTitle"   : "lightbox_LAN_ip_change_headline",
				"i18nContent" : "lightbox_LAN_ip_change_content"
			}
		}
	}
}
