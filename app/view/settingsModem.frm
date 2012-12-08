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
			"i18n"  : "conf_externalModem_caption"
		},
		"chkModem":
		{
			"type"  : "tlabs/content/checkbox",
			"i18n"  : "conf_externalModem_content",
			"dataSource" : "modem",
			"dataField"  : "enable"
		},
		"hlpModem":
		{
			"type"      : "tlabs/content/help",
			"i18nTitle"	: "helpmeWhatDoesThatMean",
			"i18n"      : "helpme_externalModem_content"
		}
	}
}
