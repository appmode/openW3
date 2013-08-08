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
			"i18n"  : "title_voip_assign"
		},
		"txtVoip":
		{
			"type"  : "tlabs/content/text",
			"i18n"  : "content_voip_assign_info"
		},
		"fraIncoming":
		{
			"type"      : "tlabs/content/frame",
			"i18n"      : "subtitle_voip_incoming",
			"Children"	:
			{
				"hlpNumber":
				{
					"type"       : "tlabs/content/help",
					"i18nTitle"  : "helpTtl_voipIncoming",
					"i18n"       : "helpCnt_voipIncoming"
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
			"i18n"      : "subtitle_voip_outgoing",
			"Children"	:
			{
				"hlpNumber":
				{
					"type"       : "tlabs/content/help",
					"i18nTitle"  : "helpTtl_voipOutgoing",
					"i18n"       : "helpCnt_voipOutgoing"
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
