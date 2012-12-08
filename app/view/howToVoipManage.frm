{
	"type"    : "tlabs/or/lightbox",
	"name"    : "howToVoipManage",
	"Children":
	{
		"fraHowTo" : 
		{
			"type" : "tlabs/howto/frame",
			"i18n" : "lightbox_phoneFunctions_caption",
			"Children" :
			{
				"txtContent" :
				{
					"type"    : "tlabs/howto/txt",
					"content" :
					[
						{"i18n"  : "lightbox_phoneFunctions_content_1"},
						{"value" : "T-Labs Open Router"},
						{"i18n"  : "lightbox_phoneFunctions_content_2"}
					]
				},
				"ulContent" :
				{
					"type"    : "tlabs/howto/list",
					"items" :
					[
						{"i18n" : "lightbox_phoneFunctions_content_listEntry_1"},
						{"i18n" : "lightbox_phoneFunctions_content_listEntry_2"},
						{"i18n" : "lightbox_phoneFunctions_content_listEntry_3"},
						{"i18n" : "lightbox_phoneFunctions_content_listEntry_4"},
						{"i18n" : "lightbox_phoneFunctions_content_listEntry_5"}
					]
				},
				"txtContent2" :
				{
					"type"    : "tlabs/howto/txt",
					"content" :
					[
						{"i18n" : "lightbox_phoneFunctions_content_3"},
						{
							"href" : "http://www.t-online.de/telefoniecenter", 
							"i18n" : "key_customerCenter"
						},
						{
							"i18n" : "lightbox_phoneFunctions_content_4",
							"br"   : true
						},
						{"i18n" : "lightbox_phoneFunctions_content_5"}
					]
				}
			}
		}
	}
}
