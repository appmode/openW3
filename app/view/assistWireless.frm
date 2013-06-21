{
	"type": "tlabs/or/contentbox",
	"name": "assistWireless",
	"dataSource": "wireless_assistant",
	"preload": true,
	"rpc": ["get_wireless"],
	"style": {
		"visible": false,
		"minHeight": "431px"
	},
	"Children": {
		"headerWireless": {
			"type": "tlabs/assistant/headeronestep",
			"i18nStep1": "a_wc_train_wlanAccessdata",
			"statusStep1": "active",
			"statusPart1": "active",
			"statusPart2": "inactive"
		},	
		"ttlWifi": {
			"type": "tlabs/assistant/title",
			"i18n": "a_wc_s1p1_caption"
		},
		"inactiveWifi": {
			"type": "tlabs/assistant/helpitemwifiinactive",
			"i18nTitle": "",
			"title": "WLAN",
			"i18nSuffix": "a_wc_s1p1_isInactive",
			"i18n": "helpme_wlan_content",
			"dataSource": "wireless_assistant",
			"dataField": "*"			
		},
		"activeWifiListItem1": {
			"type": "tlabs/assistant/helpitemwifi",
			"itemNumber": "1.",
			"i18nTitle": "",
			"title": "WLAN",
			"i18nSuffix": "a_wc_s1p1_isActive",
			"suffix": ")",
			"i18n": "helpme_wlan_content",
			"dataSource": "wireless_assistant",
			"dataField": "*"
		},
		"activeWifiListItem2Secure": {
			"type": "tlabs/assistant/helpitemwifi",
			"itemNumber": "2.",
			"i18nTitle": "helpme_protected_secure",
			"i18nPrefix": "a_wc_s1p1_protected",
			"i18n": "helpme_protected_secure_content",
			"suffix": "",
			"dataSource": "wireless_assistant",
			"dataField": "*"
		},
		"activeWifiListItem2LessSecure": {
			"type": "tlabs/assistant/helpitemwifi",
			"itemNumber": "2.",
			"i18nTitle": "helpme_protected_lessSecure",
			"i18nPrefix": "a_wc_s1p1_protected",
			"i18n": "helpme_protected_lessSecure_content",
			"suffix": "",
			"dataSource": "wireless_assistant",
			"dataField": "*"
		},
		"activeWifiListItem2Insecure": {
			"type": "tlabs/assistant/helpitemwifi",
			"itemNumber": "2.",
			"i18nTitle": "key_notEntrypted",
			"i18nPrefix": "a_wc_s1p1_protected",
			"i18n": "helpme_protected_insecure_content",
			"suffix": "",
			"dataSource": "wireless_assistant",
			"dataField": "*"
		},
		"txtWifi": {
			"type": "tlabs/content/text",
			"i18n": "a_wc_s1p1_content"
		},
		"radWifi": {
			"type": "tlabs/assistant/radioinputleft",
			"value" : 0,
			"buttons": [
				{
					"i18n": "opt_settings_default",
					"value": 0
				}, {
					"i18n": "opt_settings_change",
					"value": 1
				}
			],
			"style": {
				"width": "442px"
			}
		},
		"helpWifi": {
			"type": "tlabs/content/help",
			"i18nTitle": "helpme_change_settings",
			"i18n": "helpme_change_settings_content"
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
			"style":
			{
				"position" 		: "absolute",
				"bottom"		: "0px"
			},
			"buttons":
			[
				{
					"action" : "next",
					"i18n"   : "btn_next"
				}
			]
		}
	}
}
