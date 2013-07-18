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
			"i18n"  : "title_settings_info"
		},
		"fraInfo":
		{
			"type"      : "tlabs/content/frame",
			"i18n"      : "subtitle_settings_info",
			"open"      : true,
			"Children"  :
			{
				"lblDate":
				{
					"type"       : "tlabs/content/labelinput",
					"i18n"	     : "label_dateTime",
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
					"i18n"	     : "label_dslDownstream",
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
					"i18n"	     : "label_dslUpstream",
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
					"i18n"	     : "label_firmwareVersion",
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
					"i18n"	     : "label_modifiedPackages",
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
			"i18n"      : "subtitle_settings_messages",
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
