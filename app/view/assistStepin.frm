{
	"type": "tlabs/or/contentbox",
	"name": "assistStepin",
	"preload": true,
	"style": {
		"visible": false,
		"minHeight": "431px"
	},
	"Children": {
		"ttlStepin": {
			"type": "tlabs/content/title",
			"i18n": "a_start_caption"
		},
		"txtStepin": {
			"type": "tlabs/content/text",
			"i18n": "a_start_content"
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
			"iconSprite": "icon/tlabs/or/72x72.png",
			"iconFrame": 2,
			"style": {
				"float": "left",
				"width": "120",
				"margin-left": "20px"
			}
		},
		"headerVoip": {
			"type": "tlabs/overview/header",
			"i18n": "category_phone",
			"iconSprite": "icon/tlabs/or/72x72.png",
			"iconFrame": 3,
			"style": {
				"float": "left",
				"width": "120"
			}
		},
		"headerHomenetwork": {
			"type": "tlabs/overview/header",
			"i18n": "category_lan",
			"iconSprite": "icon/tlabs/or/72x72.png",
			"iconFrame": 4,
			"style": {
				"float": "left",
				"width": "120"
			}
		},
		"spcPadding2": {
			"type": "tlabs/content/space",
			"style": {
				"height": "69px"
			}
		},
		"btnSave": {
			"type": "tlabs/assistant/assbuttonbaroverview",
			"buttons": [
				{
					"action": "cancel",
					"i18n": "btn_break"
				}, {
					"action": "next",
					"i18n": "btn_start_assistent"
				}
			]
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
					"action" : "start",
					"i18n"   : "btn_start_assistent"
				}
			]
		}
	}
}
