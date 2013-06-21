{
	"type": "tlabs/or/contentbox",
	"name": "assistVoipAssignDefault",
	"dataSource": "voip",
	"preload": true,
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
			"statusPart22": "inactive",
			"statusPart23": "inactive"
		},		
		"ttlVoip": {
			"type": "tlabs/assistant/title",
			"i18n": "a_pc_s3p1_caption"
		},
		"hlpIncom": {
			"type": "tlabs/assistant/helpitemvoipassignin",
			"i18nTitle": "a_pc_s3p1_listEntry_1_link",
			"i18nPrefix": "a_pc_s3p1_listEntry_1_part_1",
			"i18nSuffix": "a_pc_s3p1_listEntry_1_part_2",
			"i18n": "helpme_incomingCalls"
		},
		"hlpOut": {
			"type": "tlabs/assistant/helpitemvoipassignout",
			"i18nTitle": "key_outgoingCalls",
			"i18nSuffix": "a_pc_s3p1_listEntry_2_part_1",
			"i18nSuffix2": "a_pc_s3p1_listEntry_2_part_2",
			"i18n": "helpme_outgoingCalls",
			"dataField": "*"
		},
		"txtStandard": {
			"type": "tlabs/content/text",
			"i18n": "a_pc_s3p1_content"
		},
		"radStandard":
		{
			"type"       : "tlabs/assistant/radioinputleft",
			"value"      : 0,
			"buttons":
			[
				{
					"i18n"  : "a_pc_s3p1_radioButton_label1",
					"value" : 0
				},
				{
					"i18n" : "a_pc_s3p1_radioButton_label2",
					"value" : 1
				}
			],
			"style"	:
			{
				"width" : "442px"
			}
		},
		"helpStandard":{
			"type"      : "tlabs/content/help",
			"i18nTitle"	: "helpme_manual_number_assignment",
			"i18n"      : "helpme_manual_number_assignment_content"
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
			"buttons":
            [
                {
                    "action" : "next",
                    "i18n"   : "btn_next"
                }
            ],
			"style":
			{
				"position" 		: "absolute",
				"bottom"		: "0px"
			}
		}
	}
}
