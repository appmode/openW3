{
	"type"    : "tlabs/or/contentbox",
	"name"    : "login",
	"preload" : true,
	"style"   :
	{
		"visible"  : true
	},
	"Children":
	{
		"ttlLogin":
		{
			"type"  : "tlabs/content/title",
			"i18n"  : "login_caption"
		},
		"txtLogin1":
		{
			"type"  : "tlabs/content/text",
			"value" : [null, "T-Labs Open Router"],
			"i18n"  : ["login_content_1", null, "login_content_2"]
		},
		"txtLogin2":
		{
			"type"  : "tlabs/content/text",
			"i18n"  : "login_content_3"
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
			"i18n"	    : "helpme_lost_pwd_content"
		},
		"inpPwd":
		{
			"type"  : "tlabs/content/passwordinput",
			"i18n"	: "login_pwd_label",
			"displayOption"	: true
		},
		"spcPadding":
		{
			"type"  : "tlabs/content/space",
			"style"	:
			{
				"height" : "40px"
			}
		},
		"btnLogin":
		{
			"type"  : "tlabs/content/buttonBar",
			"style" :
			{
				"position" : "absolute",
				"bottom"   : "0px"
			},
			"buttons":
			[
				{
					"action" : "login",
					"i18n"   : "btn_login"
				}
			],
			"status":
			{
				"error" : ""
			}
		}
	}
	
}
