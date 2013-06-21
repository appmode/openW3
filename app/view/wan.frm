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
			"i18n"  : "internet_settings_caption"
		},
		"txtWan":
		{
			"type"  : "tlabs/content/text",
			"dataField" : "up",
			"options"	:
			[
				{"i18n" : "internet_settings_disconnected"},
				{"i18n" : "internet_settings_connected"}
			]
		},
		"btnDisconnect":
		{
			"type"  : "tlabs/content/button",
			"dataField" : "up",
			"options"	:
			[
				{
					"i18n" : "btn_internet_reconnect"
				},
				{
					"i18n" : "btn_internet_disconnect",
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
					"i18n"	: "key_provider",
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
					"i18n"	     : "callingLineID_label",
					"i18nError"  : "error_message_callIdent",
					"dataField"  : "t_callident",
					"style"	:
					{
						"width"	: "442px"
					}
				},
				"inpAccessNo":
				{
					"type"       : "tlabs/content/textinput",
					"i18n"	     : "tonline_number_label",
					"i18nError"  : "error_message_tOnlineNumber",
					"dataField"  : "t_number",
					"style"	:
					{
						"width"	: "442px"
					}
				},
				"inpPassword":
				{
					"type"  : "tlabs/content/passwordinput",
					"i18n"	: "internet_password_label",
					"i18nError"  : "error_message_privateCode",
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
			"i18n"	: "connection_ip_addressinfo",
			"Children"	:
			{
				"ttlIpV4":
				{
					"type"  : "tlabs/content/title",
					"i18n"  : "connection_ip_info_v4"
				},
				"lblIp":
				{
					"type"       : "tlabs/content/labelinput",
					"i18n"	     : "connection_public_ip_v4",
					"dataField"  : "ipaddr",
					"style"	:
					{
						"width"	: "442px"
					}
				},
				"lblGateway":
				{
					"type"       : "tlabs/content/labelinput",
					"i18n"	     : "connection_gateway_ip_v4",
					"dataField"  : "route",
					"style"	:
					{
						"width"	: "442px"
					}
				},
				"lblPrimaryDns":
				{
					"type"       : "tlabs/content/labelinput",
					"i18n"	     : "connection_dns_ip_v4",
					"dataField"  : "dns",
					"style"	:
					{
						"width"	: "442px"
					}
				},
				"lblSecondaryDns":
				{
					"type"       : "tlabs/content/labelinput",
					"i18n"	     : "connection_sec_dns_ip_v4",
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
