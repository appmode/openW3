{
	"type"    : "tlabs/or/contentbox",
	"name"    : "settingsProblems",
	"preload" : true,
	"rpc"        :
	[
		"get_systeminfo"
	],
	"style"   :
	{
		"visible"  : false
	},
	"Children":
	{
		"ttlProblem":
		{
			"type"  : "tlabs/content/title",
			"i18n"  : "config_problemHandling_caption"
		},
		"fraRestart":
		{
			"type"      : "tlabs/content/frame",
			"i18n"      : "key_startNew",
			"open"      : true,
			"Children"  :
			{
				"txtRestart":
				{
					"type"      : "tlabs/content/text",
					"i18n"      : "config_problemHandling_save_content_1"
				},
				"txtLastRestart":
				{
					"type"       : "tlabs/content/text",
					"i18n"       : 
					[
						"config_problemHandling_save_content_2_1",
						null,
						"config_problemHandling_save_content_2_2",
						null
					],
					"dataSource"     : "sysinfo",
					"dataField"      : "uptime",
					"dataMemberType" : "output",
					"Register"       : ["dataSource"]
				},
				"btnRestart":
				{
					"type"  : "tlabs/content/button",
					"i18n"  : "key_startNew",
					"rpc"   : "reboot"
				}
			}
		}
	}
}
