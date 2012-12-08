{
	"type"    : "tlabs/or/contentbox",
	"name"    : "voipAssign",
	"preload" : true,
	"rpc"        :
	[
		"get_voip"
	],
	"style"   :
	{
		"visible"  : false
	},
	"Children":
	{
		"ttlVoip":
		{
			"type"  : "tlabs/content/title",
			"i18n"  : "phone_numberAssigment_headline"
		},
		"txtVoip":
		{
			"type"  : "tlabs/content/text",
			"i18n"  : "phone_internet_content_1"
		},
		"fraIncoming":
		{
			"type"      : "tlabs/content/frame",
			"i18n"      : "phone_numberAssigment_incoming",
			"Children"	:
			{
				"hlpNumber":
				{
					"type"       : "tlabs/content/help",
					"i18nTitle"  : "phone_numberAssigment_incoming_helpme_link",
					"i18n"       : "phone_numberAssigment_incoming_helpme_content"
				},
				"numIncoming":
				{
					"type"       : "tlabs/content/telnumincoming",
					"dataSource" : "voipIncoming",
					"dataField"  : "*"
				},
				"btnSave":
				{
					"type"  : "tlabs/content/buttonbar",
					"dataSource" : "voipIncoming",
					"style"	:
					{
						"width"	: "442px"
					}
				}
			}
		},
		"fraOutgoing":
		{
			"type"      : "tlabs/content/frame",
			"i18n"      : "key_outgoingCalls",
			"Children"	:
			{
				"hlpNumber":
				{
					"type"       : "tlabs/content/help",
					"i18nTitle"  : "phone_numberAssigment_outgoing_helpme_link",
					"i18n"       : "phone_numberAssigment_outgoing_helpme_content"
				},
				"numOutgoing":
				{
					"type"       : "tlabs/content/telnumoutgoing",
					"dataSource" : "voipOutgoing",
					"dataField"  : "*"
				},
				"btnSave":
				{
					"type"  : "tlabs/content/buttonbar",
					"dataSource" : "voipOutgoing",
					"style"	:
					{
						"width"	: "442px"
					}
				}
			}
		}
	}
}
