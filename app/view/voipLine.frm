{
	"type"    : "tlabs/or/contentbox",
	"name"    : "voipLine",
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
			"i18n"  : "title_voip_line"
		},
		"txtVoip":
		{
			"type"  : "tlabs/content/text",
			"i18n"  : "content_voip_line_info"
		},
		"hlpNumber":
		{
			"type"       : "tlabs/content/help",
			"i18nTitle"  : "helpTtl_voipLineSettings",
			"i18n"       : "helpCnt_voipLineSettings"
		},
		"numSettings":
		{
			"type"       : "tlabs/content/telnumsettings",
			"dataSource" : "voipSettings",
			"dataField"  : "*"
		},
		"btnSave":
		{
			"type"       : "tlabs/content/buttonbar",
			"dataSource" : "voipSettings"
		}
	}
}
