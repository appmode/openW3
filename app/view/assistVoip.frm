{
	"type": "tlabs/or/contentbox",
	"name": "assistVoip",
	"dataSource": "voip_assistant",
	"preload": true,
	"rpc": ["get_voip"],
	"style": {
		"visible": false,
		"minHeight": "431px"
	},
	"Children": {
		"headerVoip": {
			"type": "tlabs/assistant/header",
			"i18nStep1": "a_pc_train_phone_setup",
			"i18nStep2": "a_pc_train_number_assignment",
			"statusStep1": "active",
			"statusStep2": "inactive"
		},	
		"ttlVoip": {
			"type": "tlabs/assistant/title",
			"i18n": "a_pc_s2p2_caption"
		},
		"hlpNumber": {
			"type": "tlabs/assistant/helpfloatleft",
			"i18nTitle": "a_pc_s2p2_content_1_link",
			"i18nPrefix": "a_pc_s2p2_content_1_part_1",
			"i18nSuffix": "a_pc_s2p2_content_1_part_2",
			"i18nSuffix2": "a_pc_s2p2_content_2",
			"i18n": "helpme_voipNumber"
		},
		"selProvider": {
			"type": "tlabs/content/selectinput",
			"i18n": "key_provider",
			"options": [
				{
					"title": "Telekom",
					"value": "0"
				}
			],
			"style": {
				"width": "442px",
				"display": "none"
			}
		},
		"telNumber": {
			"type": "tlabs/assistant/telnum",
			"i18nError": "error_message_no_areacode",
			"dataSource": "voip_assistant",
			"dataField": "*",
			"style" : {
				"margin-top" : "10px"
			}
		},
		"hlpRegister": {
			"type": "tlabs/assistant/helpfloatleft",
			"i18nTitle": "helpme_register_caption",
			"i18nPrefix": "a_pc_s2p2_regDefault_1",
			"i18nSuffix": "a_pc_s2p2_regDefault_2",
			"i18n": "helpme_register_content"
		},
		"noteVoipCall": {
			"type": "tlabs/content/notification",
			"i18n": "a_pc_s2p2_content_4",
			"style" : {
				"top"	: "8px",
				"left"	: "12px"
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
			"dataSource": "voip_assistant",
			"style":
			{
				"position" 		: "absolute",
				"bottom"		: "0px"
			}
		}
	}
}
