{
	"type": "tlabs/or/contentbox",
	"name": "assistVoipAssignIn",
	"preload": true,
	"rpc": false,
	"style": {
		"visible": false,
		"minHeight": "431px"
	},
	"Children": {
		"headerAssignDefault": {
			"type": "tlabs/assistant/header",
			"i18nStep1": "a_pc_train_phone_setup",
			"i18nStep2": "a_pc_train_number_assignment",
			"statusStep1": "active",
			"statusStep2": "active",
			"statusPart21": "active",
			"statusPart22": "active",
			"statusPart23": "inactive"
		},		
		"ttlVoip": {
			"type": "tlabs/assistant/title",
			"i18n": "a_pc_s3p2_caption"
		},
		"hlpNumber":
		{
			"type"       : "tlabs/content/help",
			"i18nTitle"  : "phone_numberAssigment_incoming_helpme_link",
			"i18n"       : "phone_numberAssigment_incoming_helpme_content"
		},
		"numIncoming":
		{
			"type"       : "tlabs/content/telnumincoming",
			"dataSource" : "voipIncoming_assistant",
			"dataField"  : "*"
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
			"dataSource": "voipIncoming_assistant",
			"style":
			{
				"position" 		: "absolute",
				"bottom"		: "0px"
			}
		}
	}
}
