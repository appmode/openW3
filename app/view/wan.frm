{
	"type"       : "tlabs/or/contentbox",
	"name"       : "wan",
	"dataSource" : "wan",
	"preload"    : true,
	"rpc"        :
	[
		"get_wan"
	],
	"style"      :
	{
		"visible"  : false
	},
	"Children":
	{
		"ttlWan":
		{
			"type"  : "tlabs/content/title",
			"i18n"  : "title_wan"
		},
		"txtWan":
		{
			"type"  : "tlabs/content/text",
			"dataField" : "up",
			"options"	:
			[
				{"i18n" : "content_wan_disconnected"},
				{"i18n" : "content_wan_connected"}
			]
		},
		"btnDisconnect":
		{
			"type"  : "tlabs/content/button",
			"dataField" : "up",
			"options"	:
			[
				{
					"i18n" : "button_connect"
				},
				{
					"i18n" : "button_disconnect",
					"rpc"  : "disconnect_wan"
				}
			]
		},
		"evtPending":
		{
			"type"  : "tlabs/base/dataevent",
			"dataField" : "pending"
		},
		"fraAccess":
		{
			"type"  : "tlabs/content/frame",
			"i18n"	: "key_accessData",
			"Children"	:
			{
				"selProvider":
				{
					"type"  : "tlabs/content/selectinput",
					"i18n"	: "label_provider",
					"options":
					[
						{
							"title" : "Telekom",
							"value"	: "0"
						}
					],
					"style"	:
					{
						"width"	  : "442px",
						"display" : "none"
					}
				},
				"inpConnectionId":
				{
					"type"       : "tlabs/content/textinput",
					"i18n"	     : "label_connectionId",
					"i18nError"  : "error_connectionId_invalid",
					"dataField"  : "t_callident",
					"style"	:
					{
						"width"	: "442px"
					}
				},
				"inpAccessNo":
				{
					"type"       : "tlabs/content/textinput",
					"i18n"	     : "label_accessNo",
					"i18nError"  : "error_accessNo_invalid",
					"dataField"  : "t_number",
					"style"	:
					{
						"width"	: "442px"
					}
				},
				"inpPassword":
				{
					"type"       : "tlabs/content/passwordinput",
					"i18n"	     : "label_pwd",
					"i18nError"  : "error_pwd_invalid",
					"dataField"  : "password",
					"style"	:
					{
						"width"	: "442px"
					}
				},
				"spcPadding":
				{
					"type"  : "tlabs/content/space"
				},
				"btnSave":
				{
					"type"  : "tlabs/content/buttonbar",
					"style"	:
					{
						"width"	: "442px",
						"position" : "relative"
					},
					"dataSource" : "wan",
					"status":
					{
						"pending"  :
						{
							"status" : "warn",
							"i18n"   : "????"
						}
					}
				}
			}
		},
		"fraIp":
		{
			"type"  : "tlabs/content/frame",
			"i18n"	: "subtitle_wan_ipInfo",
			"Children"	:
			{
				"ttlIpV4":
				{
					"type"  : "tlabs/content/title",
					"i18n"  : "title_wan_ipV4Info"
				},
				"lblIp":
				{
					"type"       : "tlabs/content/labelinput",
					"i18n"	     : "label_wanIp",
					"dataField"  : "ipaddr",
					"style"	:
					{
						"width"	: "442px"
					}
				},
				"lblGateway":
				{
					"type"       : "tlabs/content/labelinput",
					"i18n"	     : "label_gateway",
					"dataField"  : "route",
					"style"	:
					{
						"width"	: "442px"
					}
				},
				"lblPrimaryDns":
				{
					"type"       : "tlabs/content/labelinput",
					"i18n"	     : "label_dns1",
					"dataField"  : "dns",
					"style"	:
					{
						"width"	: "442px"
					}
				},
				"lblSecondaryDns":
				{
					"type"       : "tlabs/content/labelinput",
					"i18n"	     : "label_dns2",
					"dataField"  : "dns2",
					"style"	:
					{
						"width"	: "442px"
					}
				}
			}
		}
	}
}
