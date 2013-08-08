{
	"type"    : "tlabs/or/contentbox",
	"name"    : "settingsModem",
	"preload" : true,
	"rpc"        :
	[
		"get_external_modem"
	],
	"style"   :
	{
		"visible"  : false
	},
	"Children":
	{
		"ttlModem":
		{
			"type"  : "tlabs/content/title",
			"i18n"  : "title_settings_externalModem"
		},
		"chkModem":
		{
			"type"  : "tlabs/content/checkbox",
			"i18n"  : "content_settings_externalModem",
			"dataSource" : "modem",
			"dataField"  : "enable"
		},
		"hlpModem":
		{
			"type"      : "tlabs/content/help",
			"i18nTitle"	: "helpTtl_settings_externalModem",
			"i18n"      : "helpCnt_settings_externalModem"
		}
	}
}
