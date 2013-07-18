{
	"type"    : "tlabs/or/box",
	"name"    : "header",
	"preload" : true,
	"style":
	{
		"top"     : "0px",
		"height"  : "125px",
		"visible" : true,
		"overflow" : "visible"
	},
	"Children":
	{
		"brand":
		{
			"type"  : "tlabs/or/brand",
			"style" : 
			{
				"left" : "10px",
				"backgroundImage" : "image/openw3/default/logo/logoBg.png"
			},
			"logoImage" : "image/openw3/default/logo/logo.png",
			"homeUrl"   : "",
			"links":
			[
				{
					"title" : "English",
					"url"   : "javascript:w3.i18n.setLanguage('en');"
				},
				{
					"title" : "Deutsch",
					"url"   : "javascript:w3.i18n.setLanguage('de');"
				},
				{
					"title" : "openW3",
					"url"   : "https://github.com/appmode/openW3"
				},
				{
					"title" : "openWRT",
					"url"   : "https://openwrt.org/"
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
				"top"  : "60px",
				"left" : "2px"
			},
			"title" : "openW3 Router",
			"iconSprite" : "icon/openw3/default/30x30.png",
			"backgroundSprite" : "image/openw3/default/nav.sprite.png",
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
							"view"  : "overview"
						}
					]
				},
				{
					"name" : "wan",
					"i18n" : "category_wan",
					"iconFrame" : 2,
					"menu"  :
					[
						{
							"name"        : "wan",
							"i18n"        : "menu_wan",
							"i18nTooltip" : "menu_wan_tooltip",
							"view"        : "wan"
						},
						{
							"name"        : "vpn",
							"i18n"        : "menu_vpn",
							"i18nTooltip" : "menu_vpn_tooltip",
							"view"        : "vpn"
						}
					]
				},
				{
					"name" : "voip",
					"i18n" : "category_voip",
					"iconFrame" : 3,
					"menu"  :
					[
						{
							"name"        : "voip",
							"i18n"        : "menu_voip",
							"i18nTooltip" : "menu_voip_tooltip",
							"view"        : "voip"
						},
						{
							"name"        : "assign",
							"i18n"        : "menu_voip_assign",
							"i18nTooltip" : "menu_voip_assign_tooltip",
							"view"        : "voipAssign"
						},
						{
							"name"        : "line",
							"i18n"        : "menu_voip_line",
							"i18nTooltip" : "menu_voip_line_tooltip",
							"view"        : "voipLine"
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
							"i18n"        : "menu_wireless",
							"i18nTooltip" : "menu_wireless_tooltip",
							"view"        : "wireless"
						},
						{
							"name"        : "lan",
							"i18n"        : "menu_lan",
							"i18nTooltip" : "menu_lan_tooltip",
							"view"        : "lan"
						}
					]
				},
				null,
				{
					"name" : "settings",
					"i18n" : "category_settings",
					"iconFrame" : 5,
					"menu"  :
					[
						{
							"name"        : "pwd",
							"i18n"        : "menu_pwd",
							"i18nTooltip" : "menu_pwd_tooltip",
							"view"        : "settingsPwd"
						},
						{
							"name"        : "problems",
							"i18n"        : "menu_problems",
							"i18nTooltip" : "menu_problems_tooltip",
							"view"        : "settingsProblems"
						},
						{
							"name"        : "info",
							"i18n"        : "menu_info",
							"i18nTooltip" : "menu_info_tooltip",
							"view"        : "settingsInfo"
						},
						{
							"name"        : "modem",
							"i18n"        : "menu_modem",
							"i18nTooltip" : "menu_modem_tooltip",
							"view"        : "settingsModem"
						}
					]
				}
				
			]
		}
	}
}
