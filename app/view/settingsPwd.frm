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
			"i18n"  : "title_settings_pwd"
		},
		"hlpPwd":
		{
			"type"      : "tlabs/content/help",
			"i18nTitle"	: "helpTtl_aboutPwd",
			"i18n"	    : "helpCnt_aboutPwd"
		},
		"inpOldPwd":
		{
			"type"      : "tlabs/content/passwordinput",
			"i18n"      : "label_currentPwd",
			"i18nError" : "error_currentPwd_incorrect",
			"dataField" : "old"
		},
		"hlpFindPwd":
		{
			"type"      : "tlabs/content/help",
			"i18nTitle"	: "helpTtl_findPwd",
			"i18n"	    : "helpCnt_findPwd",
			"alt"		: "Speedport back"
		},
		"hlpLostPwd":
		{
			"type"      : "tlabs/content/help",
			"i18nTitle"	: "helpTtl_lostPwd",
			"i18n"      : "helpCnt_lostPwd"
		},
		"inpNewPwd":
		{
			"type"          : "tlabs/content/passwordinput",
			"i18n"          : "label_newPwd",
			"i18nError"     : "error_newPwd_invalid",
			"dataField"     : "new",
			"displayOption"	: true
		},
		"btnSave":
		{
			"type"       : "tlabs/content/buttonbar",
			"dataSource" : "pwd",
			"status":
			{
				"info"  : "info_passwordChanged",
				"error" : "info_invalidEntry"
			}
		}
	}
}


