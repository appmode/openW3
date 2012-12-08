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
			"i18n"  : "phone_internet_caption"
		},
		"txtVoip":
		{
			"type"  : "tlabs/content/text",
			"i18n"  : "phone_internet_content_1"
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
				"telNumber":
				{
					"type"       : "tlabs/content/telnum",
					"i18nError"  : "error_message_no_areacode",
					"dataSource" : "voip",
					"dataField"  : "*"
				},
				"hlpRegister":
				{
					"type"       : "tlabs/content/help",
					"i18nTitle"  : "helpme_register_caption",
					"i18nPrefix" : "a_pc_s2p2_regDefault_1",
					"i18nSuffix" : "a_pc_s2p2_regDefault_2",
					"i18n"       : "helpme_register_content",
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
						"width"	  : "442px"
					}
				}
			}
		}
	}
}
