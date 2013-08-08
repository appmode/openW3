{
	"type"    : "tlabs/or/contentbox",
	"name"    : "voip",
	"preload" : true,
	"rpc"        :
	[
		"get_voip"
	],
	"style"   :
	{
		"visible"  : false
	},
	"Children":
	{
		"ttlVoip":
		{
			"type"  : "tlabs/content/title",
			"i18n"  : "title_voip"
		},
		"txtVoip":
		{
			"type"  : "tlabs/content/text",
			"i18n"  : "content_voip_info"
		},
		"fraVoip":
		{
			"type"  : "tlabs/content/frame",
			"title" : "Telekom",
			"open"  : true,
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
				"telNumber":
				{
					"type"       : "tlabs/content/telnum",
					"i18nError"  : "error_areacode_invalid",
					"dataSource" : "voip",
					"dataField"  : "*"
				},
				"hlpRegister":
				{
					"type"       : "tlabs/content/help",
					"i18nTitle"  : "helpTtl_voipRegistration",
					"i18nPrefix" : "helpPre_voipRegistration",
					"i18nSuffix" : "helpSuf_voipRegistration",
					"i18n"       : "helpCnt_voipRegistration",
					"style"	:
					{
						"display" : "none"
					}
				},
				"btnSave":
				{
					"type"  : "tlabs/content/buttonbar",
					"dataSource" : "voip",
					"style"	:
					{
						"width"	   : "442px",
						"position" : "relative"
					}
				}
			}
		}
	}
}
