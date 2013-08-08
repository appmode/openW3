{
	"type"       : "tlabs/or/contentbox",
	"name"       : "wireless",
	"dataSource" : "wireless",
	"preload"    : true,
	"rpc"        :
	[
		"get_wireless"
	],
	"style" :
	{
		"visible"  : false
	},
	"Children":
	{
		"ttlBasicSettings":
		{
			"type"  : "tlabs/content/title",
			"i18n"  : "title_wireless"
		},
		"hlpWireless":
		{
			"type"      : "tlabs/content/help",
			"i18nTitle"	: "helpTtl_aboutWireless",
			"i18n"      : "helpCnt_aboutWireless"
		},
		"chkWireless24":
		{
			"type"         : "tlabs/content/checkbox",
			"i18n"         : "checkbox_wireless_2gEnable",
			"dataField"    : "radio0.disabled",
			"reverseValue" : true
		},
		"chkWireless50":
		{
			"type"         : "tlabs/content/checkbox",
			"i18n"         : "checkbox_wireless_5gEnable",
			"dataField"    : "radio1.disabled",
			"reverseValue" : true
		},
		"inpWireless24Ssid":
		{
			"type"       : "tlabs/content/textinput",
			"i18n"	     : "label_ssid",
			"i18nError"  : "error_ssid_invalid",
			"dataField"  : "radio0.ssid",
			"style"	:
			{
				"width"	: "442px"
			},
			"Children":
			{
				"trgWireless24Ssid":
				{
					"type"   : "tlabs/content/helptrigger",
					"prefix" : "(",
					"title"	 : "SSID",
					"suffix" : ")",
					"target" : "hlpWireless24Ssid"
				}
			}
		},
		"hlpWireless24Ssid":
		{
			"type"      : "tlabs/content/help",
			"i18n"      : "helpCnt_aboutSsid",
			"i18nTitle"	: ""
		},
		"radWireless24Visible":
		{
			"type"       : "tlabs/content/radioinput",
			"i18n"	     : "label_ssidVisibility",
			"dataField"  : "radio0.hidden",
			"buttons":
			[
				{
					"i18n"  : "option_visible",
					"value" : 0
				},
				{
					"i18n" : "option_hidden",
					"value" : 1
				}
			],
			"style"	:
			{
				"width"	: "442px"
			}
		},
		"hlpVisible":
		{
			"type"      : "tlabs/content/help",
			"i18nTitle"	: "helpTtl_ssidVisibility",
			"i18n"	    : "helpCnt_ssidVisibility"
		},
		"selEncryptionType":
		{
			"type"       : "tlabs/content/selectinput",
			"i18n"	     : "label_encryptionType",
			"dataField"  : "radio0.encryption",
			"options" :
			[
				{
					"i18n"  : "option_wpa2",
					"value"	: "psk2"
				},
				{
					"i18n"  : "option_wpa",
					"value"	: "mixed-psk"
				},
				{
					"i18n"  : "option_wpa1",
					"value"	: "psk"
				},
				{
					"i18n"  : "option_wep",
					"value"	: "wep"
				},
				{
					"i18n"  : "option_unenencrypted",
					"value"	: "none"
				}
			],
			"style"	:
			{
				"width"	: "442px"
			}
		},
		"hlpEncryptionType":
		{
			"type"      : "tlabs/content/help",
			"i18nTitle"	: "helpTtl_encryptionType",
			"i18n"	    : "helpCnt_encryptionType"
		},
		"inpWirelessKey":
		{
			"type"       : "tlabs/content/textinput",
			"i18n"	     : "label_wifiKey",
			"i18nError"  : "error_wifiKey_invalid",
			"dataField"  : "radio0.key",
			"style"	:
			{
				"width"	: "442px"
			}
		},
		"hlpWirelessKey":
		{
			"type"      : "tlabs/content/help",
			"i18nTitle"	: "helpTtl_aboutWifiKey",
			"i18n"	    : "helpCnt_aboutWifiKey"
		},
		"btnSave":
		{
			"type"  : "tlabs/content/buttonbar",
			"style"	:
			{
				"width"	: "442px"
			},
			"dataSource" : "wireless"
		}
	}
}
