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
			"i18n"  : "title_settings_problems"
		},
		"fraRestart":
		{
			"type"      : "tlabs/content/frame",
			"i18n"      : "subtitle_settings_restart",
			"open"      : true,
			"Children"  :
			{
				"txtRestart":
				{
					"type"      : "tlabs/content/text",
					"i18n"      : "content_settings_restart"
				},
				"txtLastRestart":
				{
					"type"       : "tlabs/content/text",
					"i18n"       : 
					[
						"content_settings_restart_date",
						null,
						"content_settings_restart_time",
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
					"i18n"  : "button_restart",
					"rpc"   : "reboot"
				}
			}
		}
	}
}
