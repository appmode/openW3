{
	"type"    : "tlabs/or/lightbox",
	"name"    : "howToWirelessAdd",
	"rpc"     :
	[
		"get_overview"
	],
	"Children":
	{
		"fraHowTo" : 
		{
			"type" : "tlabs/howto/frame",
			"i18n" : "lightbox_wlan_caption",
			"Children" :
			{
				"txtContent" :
				{
					"type"      : "tlabs/howto/txt",
					"i18nTitle" : "key_hint",
					"content"   :
					[
						{"i18n" : "lightbox_wlan_content_1_1"},
						{ 
							"i18n"     : "helpme_wlanAdapter",
							"i18nHelp" : "helpme_wlanAdapter_content"
						},
						{"i18n" : "lightbox_wlan_content_1_1"},
						{ 
							"i18n"     : "helpme_wlanUSBStick",
							"i18nHelp" : "helpme_wlanUSBStick_content"
						}
					]
				},
				"datAccess" :
				{
					"type"       : "tlabs/howto/data",
					"i18nTitle"  : "lightbox_wlan_content_2_caption",
					"dataSource" : "wireless",
					"dataField"  : "*",
					"items" : 
					[
						{
							"i18n"      : "lightbox_wlan_table_row1_col_1",
							"dataField" : "ssid.0"
						},
						{
							"i18n"      : "key_typeOfEncryption",
							"dataField" : "encryption.0"
						},
						{
							"i18n"      : "key_wlanKey",
							"dataField" : "key.0"
						}
					]
				},
				"olContent" :
				{
					"type"       : "tlabs/howto/list",
					"i18nTitle"  : "lightbox_wlan_content_3_caption",
					"dataSource" : "wireless",
					"dataField"  : "*",
					"ordered"    : true,
					"items" :
					[
						{
							"content" :
							[
								{"i18n" : "lightbox_wlan_content_3_listEntry_1_1"},
								{
									"i18n"     : "helpme_controlSoftware",
									"i18nHelp" : "helpme_controlSoftware_content"
								},
								{"i18n" : "lightbox_wlan_content_3_listEntry_1_2"},
								{"dataField" : "ssid.0"}
							]
						},
						{
							"i18nAnything" : "lightbox_wlan_content_3_listEntry_2_3",
							"content" :
							[
								{"i18n" : "lightbox_wlan_content_3_listEntry_2_1"},
								{"dataField" : "encryption.0"},
								{"i18n" : "lightbox_wlan_content_3_listEntry_2_2"},
								{"dataField" : "key.0"},
								{"i18n" : "lightbox_wlan_content_3_listEntry_2_4"}
							]
						},
						{"i18n" : "lightbox_wlan_content_3_listEntry_3"}
					]
				},
				"txtContent2" :
				{
					"type"    : "tlabs/howto/txt",
					"content" :
					[
						{"i18n" : "lightbox_wlan_content_3_content"}
					]
				},
				"txtContent3" :
				{
					"type"      : "tlabs/howto/txt",
					"i18nTitle" : "lightbox_wlan_content_4_caption",
					"content"   :
					[
						{"i18n" : "lightbox_wlan_content_4_content_1"},
						{ 
							"i18n"     : "helpme_WPS",
							"i18nHelp" : "helpme_WPS_content"
						},
						{"i18n" : "lightbox_wlan_content_4_content_2"},
						{
							"target"   : ["network", "wireless"], 
							"i18n"     :
							[
								"category_lan",
								null,
								"lightbox_wlan_content_4_content_3"
							],
							"value"    :
							[
								null,
								" -> ",
								null
							]
						}
					]
				}
			}
		}
	}
}
