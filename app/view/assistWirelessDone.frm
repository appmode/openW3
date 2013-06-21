{
	"type": "tlabs/or/contentbox",
	"name": "assistWirelessDone",
	"preload": true,
	"style": {
		"visible": false,
		"minHeight": "431px"
	},
	"Children": {
		"ttlWifi": {
			"type": "tlabs/content/title",
			"i18n": "a_wlan_done_caption"
		},
		"txtWifi": {
			"type": "tlabs/content/text",
			"i18n": "a_wlan_done_content_1",
			"style": {
				"marginTop": "-6px"
			}
		},
		"txtWifiActive": {
			"type": "tlabs/content/text",
			"dataSource": "wireless",
			"dataField": "radio0.up",
			"dataMemberType" : "output",
			"i18n": "a_wlan_done_content_2_active",
			"style": {
				"marginTop": "-12px"
			}
		},
		"txtWifiInactive1": {
			"type": "tlabs/content/text",
			"dataSource": "wireless",
			"dataField": "radio0.up",
			"dataMemberType" : "output",
			"i18n": "a_wlan_done_content_2_inactive",
			"style": {
				"marginTop": "-12px"
			}
		},
		"txtWifiInactive2": {
			"type": "tlabs/content/text",
			"dataSource": "wireless",
			"dataField": "radio0.up",
			"dataMemberType" : "output",
			"i18n": "a_wlan_done_content_3_inactive",
			"style": {
				"marginTop": "-12px"
			}
		},
		"lightboxWifi": {
			"type": "tlabs/assistant/helplightbox",
			"i18nTitle": "a_wlan_done_link",
			"lightbox" : "orHowToWirelessAdd"
		},
		"spcPadding1": {
			"type": "tlabs/content/space",
			"style": {
				"height": "80px"
			}
		},
		"headerWan": {
			"type": "tlabs/overview/header",
			"i18n": "category_internet",
			"dataSource": "wan",
			"dataField": "up",
			"iconSprite": "icon/tlabs/or/72x72.png",
			"iconFrame": 2,
			"style": {
				"float" : "left", "width" : "120", "margin-left" : "20px"
			}
		},
		"headerVoip": {
			"type": "tlabs/overview/header",
			"i18n": "category_phone",
			"dataSource": "voip",
			"dataField": "up",
			"iconSprite": "icon/tlabs/or/72x72.png",
			"iconFrame": 3,
			"style": {
				"float" : "left", "width" : "120"
			}
		},
		"headerHomenetwork": {
			"type": "tlabs/overview/header",
			"i18n": "category_lan",
			"dataSource": "wireless",
			"dataField": "radio0.up",
			"iconSprite": "icon/tlabs/or/72x72.png",
			"iconFrame": 4,
			"style": {
				"float" : "left", "width" : "120"
			}
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
					"action" : "done",
					"i18n"   : "btn_end_assistant"
				}
			]
		}
	}
}
