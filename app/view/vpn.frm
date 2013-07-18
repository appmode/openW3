{
	"type"       : "tlabs/or/contentbox",
	"name"       : "vpn",
	"dataSource" : "vpn",
	"preload"    : true,
	"rpc"        :
	[
		"get_vpn"
	],
	"style"      :
	{
		"visible"  : false
	},
	"Children":
	{
		"ttlVpn":
		{
			"type"  : "tlabs/content/title",
			"i18n"  : "vpn_settings_caption"
		},
		"txtVpn":
		{
			"type"  : "tlabs/content/text",
			"dataField" : "up",
			"options"	:
			[
				{"i18n" : "vpn_settings_disconnected"},
				{"i18n" : "vpn_settings_connected"}
			]
		},
		"btnDisconnect":
		{
			"type"  : "tlabs/content/button",
			"dataField" : "up",
			"options"	:
			[
				{
					"i18n" : "btn_vpn_reconnect",
					"rpc"  : "start_vpn"
				},
				{
					"i18n" : "btn_vpn_disconnect",
					"rpc"  : "stop_vpn"
				}
			]
		},
		"evtPending":
		{
			"type"  : "tlabs/base/dataevent",
			"dataField" : "pending"
		},
		"radVpnMode":
		{
			"type"       : "tlabs/content/radioinput",
			"i18n"	     : "vpn_label_mode",
			"dataField"  : "vpnmode",
			"buttons":
			[
				{
					"i18n"  : "vpn_label_mode_none",
					"value" : 0
				},
				{
					"i18n" : "vpn_label_mode_server",
					"value" : 1
				},
				{
					"i18n" : "vpn_label_mode_client",
					"value" : 2
				}
			],
			"style"	:
			{
				"width"	: "442px"
			}
		},
		"fraServerData":
		{
			"type"  : "tlabs/content/frame",
			"i18n"	: "key_vpn_server_conf",
			"style" :
			{
				"display" : "none"
			},
			"Children"	:
			{
                "inpVpn_ca":
                {
                    "type"       : "tlabs/content/textinput",
                    "i18n"       : "vpn_label_ca",
                    "i18nError"  : "vpn_error_message_ca",
                    "dataField"  : "openrouterserver.ca",
                    "style" :
                    {
                        "width" : "442px"
                    }
                },
                "inpVpn_cert":
                {
                    "type"       : "tlabs/content/textinput",
                    "i18n"       : "vpn_label_cert",
                    "i18nError"  : "vpn_error_message_cert",
                    "dataField"  : "openrouterserver.cert",
                    "style" :
                    {
                        "width" : "442px"
                    }
                },
                "inpVpn_key":
                {
                    "type"       : "tlabs/content/textinput",
                    "i18n"       : "vpn_label_key",
                    "i18nError"  : "vpn_error_message_key",
                    "dataField"  : "openrouterserver.key",
                    "style" :
                    {
                        "width" : "442px"
                    }
                },
                "inpVpn_dh":
                {
                    "type"       : "tlabs/content/textinput",
                    "i18n"       : "vpn_label_dh",
                    "i18nError"  : "vpn_error_message_dh",
                    "dataField"  : "openrouterserver.dh",
                    "style" :
                    {
                        "width" : "442px"
                    }
                },
                "inpVpn_clientnet":
                {
                    "type"       : "tlabs/content/textinput",
                    "i18n"       : "vpn_label_clientnet",
                    "i18nError"  : "vpn_error_message_clientnet",
                    "dataField"  : "openrouterserver.route",
                    "style" :
                    {
                        "width" : "442px"
                    }
                },
				"spcPadding":
				{
					"type"  : "tlabs/content/space"
				},
				"btnSave":
				{
					"type"  : "tlabs/content/buttonbar",
					"style"	:
					{
						"width"	: "442px"
					},
					"dataSource" : "vpn",
					"status":
					{
						"pending"  :
						{
							"status" : "warn",
							"i18n"   : "????"
						}
					}
				}
			}
		},
		"fraClientData":
		{
			"type"  : "tlabs/content/frame",
			"i18n"	: "key_vpn_client_conf",
			"style" :
			{
				"display" : "none"
			},
			"Children"	:
			{
                "inpVpn_ca":
                {
                    "type"       : "tlabs/content/textinput",
                    "i18n"       : "vpn_label_ca",
                    "i18nError"  : "vpn_error_message_ca",
                    "dataField"  : "openrouterclient.ca",
                    "style" :
                    {
                        "width" : "442px"
                    }
                },
                "inpVpn_cert":
                {
                    "type"       : "tlabs/content/textinput",
                    "i18n"       : "vpn_label_cert",
                    "i18nError"  : "vpn_error_message_cert",
                    "dataField"  : "openrouterclient.cert",
                    "style" :
                    {
                        "width" : "442px"
                    }
                },
                "inpVpn_key":
                {
                    "type"       : "tlabs/content/textinput",
                    "i18n"       : "vpn_label_key",
                    "i18nError"  : "vpn_error_message_key",
                    "dataField"  : "openrouterclient.key",
                    "style" :
                    {
                        "width" : "442px"
                    }
                },
                "inpVpn_dh":
                {
                    "type"       : "tlabs/content/textinput",
                    "i18n"       : "vpn_label_dh",
                    "i18nError"  : "vpn_error_message_dh",
                    "dataField"  : "openrouterclient.dh",
                    "style" :
                    {
                        "width" : "442px"
                    }
                },
                "inpVpn_clientnet":
                {
                    "type"       : "tlabs/content/textinput",
                    "i18n"       : "vpn_label_server_wan_ip",
                    "i18nError"  : "vpn_error_message_server_wan_ip",
                    "dataField"  : "openrouterclient.remote",
                    "style" :
                    {
                        "width" : "442px"
                    }
                },
				"spcPadding":
				{
					"type"  : "tlabs/content/space"
				},
				"btnSave":
				{
					"type"  : "tlabs/content/buttonbar",
					"style"	:
					{
						"width"	: "442px"
					},
					"dataSource" : "vpn",
					"status":
					{
						"pending"  :
						{
							"status" : "warn",
							"i18n"   : "????"
						}
					}
				}
			}
		},
		"fraServerClientInfo":
		{
			"type"  : "tlabs/content/frame",
			"i18n"	: "vpn_connection_info",
			"style" :
			{
				"display" : "none"
			},
			"Children"	:
			{
				"ttlIpV4":
				{
					"type"  : "tlabs/content/title",
					"i18n"  : "vpn_connection_clientinfo"
				},
                "lblVpnClientCN":
                {
                    "type"       : "tlabs/content/labelinput",
                    "i18n"       : "vpn_label_clientcn",
                    "dataField"  : "openrouterserver.clientcn",
                    "style" :
                    {
                        "width" : "442px"
                    }
                },
                "lblVpnClientIP":
                {
                    "type"       : "tlabs/content/labelinput",
                    "i18n"       : "vpn_label_clientip",
                    "dataField"  : "openrouterserver.clientip",
                    "style" :
                    {
                        "width" : "442px"
                    }
                },
                "lblVpnClientRX":
                {
                    "type"       : "tlabs/content/labelinput",
                    "i18n"       : "vpn_label_clientrx",
                    "dataField"  : "openrouterserver.clientrx",
                    "style" :
                    {
                        "width" : "442px"
                    }
                },
                "lblVpnClientTX":
                {
                    "type"       : "tlabs/content/labelinput",
                    "i18n"       : "vpn_label_clienttx",
                    "dataField"  : "openrouterserver.clienttx",
                    "style" :
                    {
                        "width" : "442px"
                    }
				}
			}
		}
	}
}
