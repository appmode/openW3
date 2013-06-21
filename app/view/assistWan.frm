{
	"type": "tlabs/or/contentbox",
	"name": "assistWan",
	"dataSource": "wan_assistant",
	"preload": true,
	"rpc": ["get_wan"],
	"style": {
		"visible": false,
		"minHeight": "431px"
	},
	"Children": {
		"headerWan": {
			"type": "tlabs/assistant/header",
			"i18nStep1": "a_ic_train_internetAccess",
			"i18nStep2": "a_ic_train_connect",
			"statusStep1": "active",
			"statusStep2": "inactive"
		},
		"ttlWan": {
			"type": "tlabs/assistant/title",
			"i18n": "key_accessData"
		},
		"txtWan": {
			"type": "tlabs/content/text",
			"i18n": "a_ic_s1p1_content"
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
				"width": "442px"
			}
		},
		"inpConnectionId": {
			"type": "tlabs/content/textinput",
			"i18n": "callingLineID_label",
			"i18nError": "error_message_callIdent",
			"dataField": "t_callident",
			"style": {
				"width": "442px"
			}
		},
		"inpAccessNo": {
			"type": "tlabs/content/textinput",
			"i18n": "tonline_number_label",
			"i18nError": "error_message_tOnlineNumber",
			"dataField": "t_number",
			"style": {
				"width": "442px"
			}
		},
		"inpJointUserNo": {
			"type": "tlabs/content/jointusernumberinput",
			"i18n": "joint_user_number_label",
			"dataField": "t_mbnr",
			"style": {
				"width": "442px"
			}
		},
		"inpPassword": {
			"type": "tlabs/content/passwordinput",
			"i18n": "internet_password_label",
			"i18nError": "error_message_privateCode",
			"displayOption"	: true,
			"style": {
				"width": "442px"
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
			"dataSource": "wan_assistant",
			"style":
			{
				"position" 		: "absolute",
				"bottom"		: "0px"
			}
		}
	}
}
