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
			"i18n"  : "phone_lineset_caption"
		},
		"txtVoip":
		{
			"type"  : "tlabs/content/text",
			"i18n"  : "phone_lineset_expl"
		},
		"hlpNumber":
		{
			"type"       : "tlabs/content/help",
			"i18nTitle"  : "helpme_lineset_elements",
			"i18n"       : "helpme_lineset_elements_content_listEntry_3"
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
