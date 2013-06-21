{
	"type": "tlabs/or/contentbox",
	"name": "assistWirelessData",
	"dataSource": "wireless_assistant",
	"preload": true,
	"rpc": ["get_wireless"],
	"style": {
		"visible": false,
		"minHeight": "431px"
	},
	"Children": {
		"headerWirelessData": {
			"type": "tlabs/assistant/headeronestep",
			"i18nStep1": "a_wc_train_wlanAccessdata",
			"statusStep1": "active",
			"statusPart1": "active",
			"statusPart2": "active"
		},
		"chkWireless24": {
			"type": "tlabs/content/checkbox",
			"i18n": "network_wlan_basics_checkbox_wlan_on_label",
			"dataField": "radio0.disabled",
			"reverseValue": true,
			"style" : {
				"margin" : "4px 0 6px 15px"
			}
		},
		"chkWireless50": {
			"type": "tlabs/content/checkbox",
			"i18n": "network_wlan_basics_checkbox_wlan_5ghz_on_label",
			"dataField": "radio1.disabled",
			"reverseValue": true,
			"style" : {
				"margin" : "4px 0 6px 15px"
			}
		},
		"hlpWireless": {
			"type": "tlabs/content/help",
			"i18nTitle": "helpme_deactivateWlan",
			"i18n": "helpme_deactivateWlan_content",
			"style" : {
				"margin-top" : "-6px"
			}
		},
		"inpWireless24Ssid":
		{
			"type"       : "tlabs/content/textinput",
			"i18n"	     : "network_wlan_basics_ssid_label",
			"i18nError"  : "network_wlan_basics_ssid_validation_error",
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
			"i18n"      : "helpme_wlan_ssid_content",
			"i18nTitle"	: ""
		},
		"radWireless24Visible": {
			"type": "tlabs/content/radioinput",
			"i18n": "network_wlan_basics_visibility_label",
			"dataField": "radio0.hidden",
			"buttons": [
				{
					"i18n": "opt_visibility_visible",
					"value": 0
				}, {
					"i18n": "opt_visibility_invisible",
					"value": 1
				}
			],
			"style": {
				"width": "442px"
			}
		},
		"hlpVisible": {
			"type": "tlabs/content/help",
			"i18nTitle": "helpme_wlan_visibility",
			"i18n": "helpme_wlan_visibility_content"
		},
		"selEncryptionType": {
			"type": "tlabs/content/selectinput",
			"i18n": "wlan_encryptionType_label",
			"dataField": "radio0.encryption",
			"options": [
				{
					"i18n": "opt_encryptionType_wpa2",
					"value": "psk2"
				}, {
					"i18n": "opt_encryptionType_wpa",
					"value": "mixed-psk"
				}, {
					"i18n": "opt_encryptionType_wpa1",
					"value": "psk"
				}, {
					"i18n": "opt_encryptionType_wep",
					"value": "wep"
				}, {
					"i18n": "opt_encryptionType_none",
					"value": "none"
				}
			],
			"style": {
				"width": "442px"
			}
		},
		"hlpEncryptionType": {
			"type": "tlabs/content/help",
			"i18nTitle": "helpme_encryptionType",
			"i18n": "helpme_encryptionType_content"
		},
		"inpWirelessKey": {
			"type": "tlabs/content/textinput",
			"i18n": "wlan_key_label",
			"i18nError": "wpakey_validation_error",
			"dataField": "radio0.key",
			"style": {
				"width": "442px"
			}
		},
		"hlpWirelessKey": {
			"type": "tlabs/content/help",
			"i18nTitle": "helpme_whereToUseWLANKey",
			"i18n": "helpme_whereToUseWLANKey_content_1"
		},
		"spcBottom": {
			"type": "tlabs/content/space",
			"style" : {
				"width"  : "442px",
				"height" : "50px"
			}
		},
		"btnSave": {
			"type": "tlabs/content/buttonbar",
			"dataSource": "wireless_assistant",
			"style":
			{
				"position" 		: "absolute",
				"bottom"		: "0px"
			}
		}
	}
}
