{
	"type"    : "tlabs/or/lightbox",
	"name"    : "howToWanFirewall",
	"Children":
	{
		"fraHowTo" : 
		{
			"type" : "tlabs/howto/frame",
			"i18n" : "lightbox_activateGames_caption",
			"Children" :
			{
				"txtContent" :
				{
					"type"    : "tlabs/howto/txt",
					"content" :
					[
						{"i18n" : "lightbox_activateGames_content_1"},
						{
							"target" : ["wan", "wan"], 
							"i18n"   : "lightbox_activateGames_link"
						}
					]
				},
				"txtContent2" :
				{
					"type"    : "tlabs/howto/txt",
					"content" :
					[
						{"i18n" : "lightbox_activateGames_content_3"}
					]
				}
			}
		}
	}
}
