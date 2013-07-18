{
	"type": "tlabs/or/contentbox",
	"name": "assistVoipDone",
	"preload": true,
	"rpc": false,
	"style": {
		"visible": false,
		"minHeight": "431px"
	},
	"Children": {
		"ttlVoip": {
			"type": "tlabs/content/title",
			"i18n": "a_pc_done_caption"
		},
		"txtVoip": {
			"type": "tlabs/content/text",
			"dataField": "up",
			"i18n": "a_pc_done_content"
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
			"iconSprite": "icon/openw3/default/72x72.png",
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
			"iconSprite": "icon/openw3/default/72x72.png",
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
			"iconSprite": "icon/openw3/default/72x72.png",
			"iconFrame": 4,
			"style": {
				"float" : "left", "width" : "120"
			}
		},
		"spcPadding2": {
			"type": "tlabs/content/space",
			"style": {
				"height": "69px"
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
