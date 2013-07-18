{
	"type"    : "tlabs/or/overviewbox",
	"name"    : "overview",
	"preload" : true,
	"rpc"     :
	[
		"get_systeminfo",
		"get_overview"
	],
	"style"   :
	{
		"visible"  : false
	},
	"Children":
	{
		"wan" :
		{
			"type"       : "tlabs/overview/frame",
			"dataSource" : "wan",
			"Children":
			{
				"header":
				{
					"type"    : "tlabs/overview/header",
					"i18n"    : "category_internet",
					"dataField"  : "up",
					"iconSprite" : "icon/openw3/default/72x72.png",
					"iconFrame"  : 2
				},
				"title":
				{
					"type"    : "tlabs/overview/title",
					"i18n"    : ""
				},
				"lblActive":
				{
					"type"      : "tlabs/overview/label",
					"dataField" : "up",
					"options"	:
					[
						{"i18n" : "content_wan_notConfigured"},
						{"i18n" : "content_wan_active"}
					]
				},
				"actActive":
				{
					"type"      : "tlabs/overview/action",
					"dataField" : "up",
					"options"	:
					[
						{
							"i18n" : "button_connect",
							"rpc"  : "set_wan"
						},
						{
							"i18n" : "button_disconnect",
							"rpc"  : "disconnect_wan"
						}
					]
				},
				"lblOnline":
				{
					"type"       : "tlabs/overview/label",
					"i18n"       : "label_uptime"
				},
				"lblOnlineTime":
				{
					"type"       : "tlabs/overview/label",
					"i18n"       : "label_uptimeDays",
					"dataSource" : "sysinfo",
					"dataField"  : "uptime"
				},
				"actAssistant":
				{
					"type"    : "tlabs/overview/action",
					"i18n"    : "action_wan_configure",
					"target"  : ["wan", "wan"],
					"style"   :
					{
						"position" : "absolute",
						"left"     : "0px",
						"bottom"   : "30px"
					}
				},
				"help":
				{
					"type"    : "tlabs/overview/help",
					"i18n"    : "overview_howTo",
					"buttons" :
					[
						{
							"i18n" : "overview_linkBox_internet_customerCare",
							"view" : "howToWanCustomerCenter"
						},
						{
							"i18n" : "overview_linkBox_internet_games",
							"view" : "howToWanFirewall"
						}
					]
				}
			}
		},
		"voip" :
		{
			"type"       : "tlabs/overview/frame",
			"dataSource" : "voip",
			"Children":
			{
				"header":
				{
					"type"    : "tlabs/overview/header",
					"i18n"    : "category_phone",
					"dataField"  : "????",
					"iconSprite" : "icon/openw3/default/72x72.png",
					"iconFrame"  : 3
				},
				"title":
				{
					"type"    : "tlabs/overview/title",
					"i18n"    : ""
				},
				"lblActive":
				{
					"type"      : "tlabs/overview/label",
					"i18n"      : "overview_phone_subitem_2_opt1",
					"dataField" : "????",
					"options"	:
					[
						{"i18n" : "overview_phone_subitem_2_opt2"},
						{"i18n" : "overview_phone_subitem_2_opt1"}
					]
				},
				"actActive":
				{
					"type"      : "tlabs/overview/action",
					"i18n"      : "change",
					"target"    : ["voip", "voip"]
				},
				"actAssistant":
				{
					"type"    : "tlabs/overview/action",
					"i18n"    : "overview_linkToAssistant_phone",
					"target"  : ["assistant", "assistVoip"],
					"style"   :
					{
						"position" : "absolute",
						"left"     : "0px",
						"bottom"   : "30px"
					}
				},
				"help":
				{
					"type"    : "tlabs/overview/help",
					"i18n"    : "overview_howTo",
					"buttons" :
					[
						{
							"i18n" : "overview_linkBox_phone_functions",
							"view" : "howToVoipManage"
						},
						{
							"i18n" : "overview_linkBox_phone_wireless",
							"view" : "howToVoipDect"
						}
					]
				}
			}
		},
		"network" :
		{
			"type"       : "tlabs/overview/frame",
			"dataSource" : "wireless",
			"Children":
			{
				"header":
				{
					"type"       : "tlabs/overview/header",
					"i18n"       : "category_lan",
					"dataField"  : "????",
					"iconSprite" : "icon/openw3/default/72x72.png",
					"iconFrame"  : 4
				},
				"title":
				{
					"type"    : "tlabs/overview/title",
					"i18n"    : "overview_lan_co1_1_caption"
				},
				"lblActive2":
				{
					"type"      : "tlabs/overview/label",
					"dataField" : "radio0.up",
					"options"	:
					[
						{"i18n" : "overview_network_wlan_subitem_1_opt2"},
						{"i18n" : "overview_network_wlan_subitem_1_opt1"}
						
					]
				},
				"actActive2":
				{
					"type"      : "tlabs/overview/action",
					"dataField" : "radio0.up",
					"options"	:
					[
						{
							"i18n"     : "key_switchOn",
							"rpc"      : "set_wireless",
							"rpcParam" : {"radio0" : {"disabled" : 0}}
						},
						{
							"i18n"     : "overview_subitem_content_2",
							"rpc"      : "set_wireless",
							"rpcParam" : {"radio0" : {"disabled" : 1}}
						}
					]
				},
				"lblActive5":
				{
					"type"      : "tlabs/overview/label",
					"dataField" : "radio1.up",
					"options"	:
					[
						{"i18n" : "overview_network_wlan_5ghz_subitem_1_opt2"},
						{"i18n" : "overview_network_wlan_5ghz_subitem_1_opt1"}
					]
				},
				"actActive5":
				{
					"type"      : "tlabs/overview/action",
					"dataField" : "radio1.up",
					"options"	:
					[
						{
							"i18n"     : "key_switchOn",
							"rpc"      : "set_wireless",
							"rpcParam" : {"radio1" : {"disabled" : 0}}
						},
						{
							"i18n"     : "overview_subitem_content_2",
							"rpc"      : "set_wireless",
							"rpcParam" : {"radio1" : {"disabled" : 1}}
						}
					]
				},
				"lblActiveWlan":
				{
					"type"      : "tlabs/overview/label",
					"dataField" : "radio0.encryption",
					"options"	:
					{
						"none"      : {"i18n" : "key_wlanNotEncrypted"},
						"wep"       : {"i18n" : "key_wlanEncrypted"},
						"psk"       : {"i18n" : "key_wlanEncrypted"},
						"mixed-psk" : {"i18n" : "key_wlanEncrypted"},
						"psk2"      : {"i18n" : "key_wlanEncrypted"}
					}
				},
				"actActiveWlan":
				{
					"type"    : "tlabs/overview/action",
					"i18n"    : "change",
					"target"  : ["network", "wireless"]
				},
				"actAssistant":
				{
					"type"    : "tlabs/overview/action",
					"i18n"    : "overview_linkToAssistant_network_wlan",
					"target"  : ["assistant", "assistWireless"],
					"style"   :
					{
						"position" : "absolute",
						"left"     : "0px",
						"bottom"   : "30px"
					}
				},
				"help":
				{
					"type"    : "tlabs/overview/help",
					"i18n"    : "overview_howTo",
					"buttons" :
					[
						{
							"i18n" : "overview_linkBox_network_lan",
							"view" : "howToLanAdd"
						},
						{
							"i18n" : "overview_linkBox_network_wlan",
							"view" : "howToWirelessAdd"
						}
					]
				}
			}
		}
	}
}
