{
	"type"    : "tlabs/or/lightbox",
	"name"    : "infoReboot",
	"preload" : true,
	"style"   :
	{
		"visible"  : false
	},
	"Children":
	{
		"fraInfo" : 
		{
			"type" : "tlabs/info/frame",
			"i18n" : "lightbox_reboot_state_caption",
			"content" :
			[
				[
					{"i18n" : "lightbox_reboot_state_content_1"}
				],
				[
					{"i18n" : "lightbox_reboot_state_content_2_1"},
					{"id"   : "timer"},
					{"i18n" : "lightbox_reboot_state_content_2_2"}
				]
			],
			"buttons" : []
		}
	}
}
