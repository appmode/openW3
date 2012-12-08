{
	"type"    : "tlabs/or/box",
	"name"    : "header",
	"preload" : true,
	"style":
	{
		"top"     : "0px",
		"height"  : "200px",
		"visible" : true
	},
	"Children":
	{
		"brand":
		{
			"type"  : "tlabs/or/brand",
			"style" : 
			{
				"backgroundImage" : "image/tlabs/logo/logoBg.gif"
			},
			"logoImage" : "image/tlabs/logo/t.gif",
			"homeUrl"   : "",
			"links":
			[
				{
					"title" : "Deutsch",
					"url"   : "javascript:w3.i18n.setLanguage('de');"
				},
				{
					"title" : "English",
					"url"   : "javascript:w3.i18n.setLanguage('en');"
				},
				{
					"i18n" : "key_customerCenter",
					"url"   : "http://www.t-online.de/service/redir/aws_kc_telefonie.htm"
				},
				{
					"i18n" : "key_netManager",
					"url"   : "http://www.t-online.de/service/redir/aws_netzmanager.htm"
				},
				{
					"i18n" : "logout",
					"url"   : ""
				}
			]
		},
		"nav":
		{
			"type"  : "tlabs/or/nav",
			"style" : 
			{
				"top" : "60px"
			},
			"title" : "T-Labs Open Router",
			"iconSprite" : "icon/tlabs/or/30x30.png",
			"backgroundSprite" : "image/tlabs/or/nav.sprite.png",
			"homeUrl"   : "",
			"buttons":
			[
				{
					"name" : "overview",
					"i18n" : "category_overview",
					"iconFrame" : 1,
					"menu"  :
					[
						{
							"name"  : "overview",
							"i18n"  : "",
							"view"  : "orOverview"
						}
					]
				},
				{
					"name" : "wan",
					"i18n" : "category_internet",
					"iconFrame" : 2,
					"menu"  :
					[
						{
							"name"        : "wan",
							"i18n"        : "nav_internet_connection",
							"i18nTooltip" : "nav_internet_connection_tooltip",
							"view"        : "orWan"
						}
					]
				},
				{
					"name" : "voip",
					"i18n" : "category_phone",
					"iconFrame" : 3,
					"menu"  :
					[
						{
							"name"        : "voip",
							"i18n"        : "nav_phone_internet",
							"i18nTooltip" : "nav_phone_internet_tooltip",
							"view"        : "orVoip"
						},
						{
							"name"        : "assign",
							"i18n"        : "nav_phone_deviations",
							"i18nTooltip" : "nav_phone_deviations_tooltip",
							"view"        : "orVoipAssign"
						},
						{
							"name"        : "line",
							"i18n"        : "nav_phone_lineset",
							"i18nTooltip" : "nav_phone_lineset_tooltip",
							"view"        : "orVoipLine"
						}
					]
				},
				{
					"name" : "network",
					"i18n" : "category_lan",
					"iconFrame" : 4,
					"menu"  :
					[
						{
							"name"        : "wireless",
							"i18n"        : "nav_wlan_basic",
							"i18nTooltip" : "nav_wlan_basic_tooltip",
							"view"        : "orWireless"
						},
						{
							"name"        : "lan",
							"i18n"        : "nav_lan",
							"i18nTooltip" : "nav_lan_tooltip",
							"view"        : "orLan"
						}
					]
				},
				null,
				{
					"name" : "settings",
					"i18n" : "category_router",
					"iconFrame" : 5,
					"menu"  :
					[
						{
							"name"        : "pwd",
							"i18n"        : "config_pwd_caption",
							"i18nTooltip" : "nav_router_pwd_tooltip",
							"view"        : "orSettingsPwd"
						},
						{
							"name"        : "problems",
							"i18n"        : "config_problemHandling_caption",
							"i18nTooltip" : "nav_router_problemHandling_tooltip",
							"view"        : "orSettingsProblems"
						},
						{
							"name"        : "info",
							"i18n"        : "conf_sysinfo_caption",
							"i18nTooltip" : "nav_router_sysInfo_tooltip",
							"view"        : "orSettingsInfo"
						},
						{
							"name"        : "modem",
							"i18n"        : "conf_externalModem_caption",
							"i18nTooltip" : "nav_router_externalModem_tooltip",
							"view"        : "orSettingsModem"
						}
					]
				}
				
			]
		}
	}
}
