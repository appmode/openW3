{
	"type"       : "tlabs/or/contentbox",
	"name"       : "settingsInfo",
	"preload"    : true,
	"rpc"        :
	[
		"get_systeminfo",
		"get_modified_packages"
	],
	"style" :
	{
		"visible"  : false
	},
	"Children":
	{
		"ttlInfo":
		{
			"type"  : "tlabs/content/title",
			"i18n"  : "conf_sysinfo_caption"
		},
		"fraInfo":
		{
			"type"      : "tlabs/content/frame",
			"i18n"      : "conf_sysinfo_caption1",
			"open"      : true,
			"Children"  :
			{
				"lblDate":
				{
					"type"       : "tlabs/content/labelinput",
					"i18n"	     : "conf_sysinfo_content_6",
					"dataSource" : "sysinfo",
					"dataField"  : "router_date",
					"style"	:
					{
						"width"	: "442px"
					}
				},
				"lblDown":
				{
					"type"       : "tlabs/content/labelinput",
					"i18n"	     : "conf_sysinfo_content_8",
					"dataSource" : "dsl",
					"dataField"  : "data_rate_down_s",
					"style"	:
					{
						"width"	: "442px"
					}
				},
				"lblUp":
				{
					"type"       : "tlabs/content/labelinput",
					"i18n"	     : "conf_sysinfo_content_9",
					"dataSource" : "dsl",
					"dataField"  : "data_rate_up_s",
					"style"	:
					{
						"width"	: "442px"
					}
				},
				"lblFirmware":
				{
					"type"       : "tlabs/content/labelinput",
					"i18n"	     : "conf_sysinfo_content_1",
					"dataSource" : "sysinfo",
					"dataField"  : "firmware_version",
					"style"	:
					{
						"width"	: "442px"
					}
				},
				"lblPackages":
				{
					"type"       : "tlabs/content/labelinput",
					"i18n"	     : "conf_sysinfo_modifpack",
					"dataSource" : "packages",
					"dataField"  : "*",
					"style"	:
					{
						"width"	: "442px"
					}
				}
			}
		},
		"fraMessage":
		{
			"type"      : "tlabs/content/frame",
			"i18n"      : "conf_sysinfo_caption2",
			"Children"  :
			{
				"msgMessages":
				{
					"type"       : "tlabs/content/message",
					"dataSource" : "sysinfo",
					"dataField"  : "system_log"
				}
			}
		}
	}
}
