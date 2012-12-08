{
	"type"       : "tlabs/or/contentbox",
	"name"       : "settingsPwd",
	"preload"    : true,
	"dataSource" : "pwd",
	"rpc"        : false,
	"style"   :
	{
		"visible"  : false
	},
	"Children":
	{
		"ttlPwd":
		{
			"type"  : "tlabs/content/title",
			"i18n"  : "config_pwd_caption"
		},
		"hlpPwd":
		{
			"type"      : "tlabs/content/help",
			"i18nTitle"	: "helpme_device_pwd",
			"i18n"	    : "helpme_device_pwd_content"
		},
		"inpOldPwd":
		{
			"type"      : "tlabs/content/passwordinput",
			"i18n"      : "config_pwd_input_currentPwd_label",
			"i18nError" : "config_pwd_input_currentpwd_validation_error",
			"dataField" : "old"
		},
		"hlpFindPwd":
		{
			"type"      : "tlabs/content/help",
			"i18nTitle"	: "helpme_find_pwd",
			"i18n"	    : "helpme_find_pwd_content",
			"alt"		: "Speedport back"
		},
		"hlpLostPwd":
		{
			"type"      : "tlabs/content/help",
			"i18nTitle"	: "helpme_lost_pwd",
			"i18n"      : "helpme_lost_pwd_content"
		},
		"inpNewPwd":
		{
			"type"          : "tlabs/content/passwordinput",
			"i18n"          : "config_pwd_input_newPwd_label",
			"i18nError"     : "config_pwd_input_newpwd_validation_error",
			"dataField"     : "new",
			"displayOption"	: true
		},
		"btnSave":
		{
			"type"       : "tlabs/content/buttonbar",
			"dataSource" : "pwd",
			"status":
			{
				"info"  : "config_pwd_info_change",
				"error" : "error_message_generalnvalid"
			}
		}
	}
}


