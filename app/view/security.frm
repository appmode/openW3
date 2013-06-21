{
	"type"    : "tlabs/or/box",
	"name"    : "security",
	"preload" : true,
	"style":
	{
		"left"    : "247px",
		"top"     : "140px",
		"height"  : "200px",
		"width"   : "225px",
		"visible" : false,
		"backgroundColor" : "transparent"
	},
	"Children":
	{
		"security":
		{
			"type"       : "tlabs/or/security",
			"dataSource" : "wireless",
			"dataField"  : "radio0.encryption",
			"target"     : ["network", "wireless"]
		}
	}
}
