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
			"i18n"  : "title_vpn"
		},
		"txtVpn":
		{
			"type"  : "tlabs/content/text",
			"dataField" : "up",
			"options"	:
			[
				{"i18n" : "content_vpn_disconnected"},
				{"i18n" : "content_vpn_connected"}
			]
		},
		"btnDisconnect":
		{
			"type"  : "tlabs/content/button",
			"dataField" : "up",
			"options"	:
			[
				{
					"i18n" : "button_connect",
					"rpc"  : "start_vpn"
				},
				{
					"i18n" : "button_disconnect",
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
			"i18n"	     : "label_vpnMode",
			"dataField"  : "vpnmode",
			"buttons":
			[
				{
					"i18n"  : "info_vpnMode_none",
					"value" : 0
				},
				{
					"i18n" : "info_vpnMode_server",
					"value" : 1
				},
				{
					"i18n" : "info_vpnMode_client",
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
			"i18n"	: "subtitle_vpn_serverConfig",
			"style" :
			{
				"display" : "none"
			},
			"Children"	:
			{
                "inpVpn_ca":
                {
                    "type"       : "tlabs/content/textinput",
                    "i18n"       : "label_sslCaCert",
                    "i18nError"  : "error_sslCaCert_invalid",
                    "dataField"  : "openrouterserver.ca",
                    "style" :
                    {
                        "width" : "442px"
                    }
                },
                "inpVpn_cert":
                {
                    "type"       : "tlabs/content/textinput",
                    "i18n"       : "label_sslCert",
                    "i18nError"  : "error_sslCert_invalid",
                    "dataField"  : "openrouterserver.cert",
                    "style" :
                    {
                        "width" : "442px"
                    }
                },
                "inpVpn_key":
                {
                    "type"       : "tlabs/content/textinput",
                    "i18n"       : "label_keyFile",
                    "i18nError"  : "error_keyFile_invalid",
                    "dataField"  : "openrouterserver.key",
                    "style" :
                    {
                        "width" : "442px"
                    }
                },
                "inpVpn_dh":
                {
                    "type"       : "tlabs/content/textinput",
                    "i18n"       : "label_dhFile",
                    "i18nError"  : "error_dhFile_invalid",
                    "dataField"  : "openrouterserver.dh",
                    "style" :
                    {
                        "width" : "442px"
                    }
                },
                "inpVpn_clientnet":
                {
                    "type"       : "tlabs/content/textinput",
                    "i18n"       : "label_clientNetwork",
                    "i18nError"  : "error_clientNetwork_invalid",
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
			"i18n"	: "subtitle_vpn_clientConfig",
			"style" :
			{
				"display" : "none"
			},
			"Children"	:
			{
                "inpVpn_ca":
                {
                    "type"       : "tlabs/content/textinput",
                    "i18n"       : "label_sslCaCert",
                    "i18nError"  : "error_sslCaCert_invalid",
                    "dataField"  : "openrouterclient.ca",
                    "style" :
                    {
                        "width" : "442px"
                    }
                },
                "inpVpn_cert":
                {
                    "type"       : "tlabs/content/textinput",
                    "i18n"       : "label_sslCert",
                    "i18nError"  : "error_sslCert_invalid",
                    "dataField"  : "openrouterclient.cert",
                    "style" :
                    {
                        "width" : "442px"
                    }
                },
                "inpVpn_key":
                {
                    "type"       : "tlabs/content/textinput",
                    "i18n"       : "label_keyFile",
                    "i18nError"  : "error_keyFile_invalid",
                    "dataField"  : "openrouterclient.key",
                    "style" :
                    {
                        "width" : "442px"
                    }
                },
                "inpVpn_dh":
                {
                    "type"       : "tlabs/content/textinput",
                    "i18n"       : "label_dhFile",
                    "i18nError"  : "error_dhFile_invalid",
                    "dataField"  : "openrouterclient.dh",
                    "style" :
                    {
                        "width" : "442px"
                    }
                },
                "inpVpn_clientnet":
                {
                    "type"       : "tlabs/content/textinput",
                    "i18n"       : "label_remoteIp",
                    "i18nError"  : "error_remoteIp_invalid",
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
			"i18n"	: "subtitle_vpn_info",
			"style" :
			{
				"display" : "none"
			},
			"Children"	:
			{
				"ttlIpV4":
				{
					"type"  : "tlabs/content/title",
					"i18n"  : "title_vpn_clientInfo"
				},
                "lblVpnClientCN":
                {
                    "type"       : "tlabs/content/labelinput",
                    "i18n"       : "label_clientCn",
                    "dataField"  : "openrouterserver.clientcn",
                    "style" :
                    {
                        "width" : "442px"
                    }
                },
                "lblVpnClientIP":
                {
                    "type"       : "tlabs/content/labelinput",
                    "i18n"       : "label_clientIp",
                    "dataField"  : "openrouterserver.clientip",
                    "style" :
                    {
                        "width" : "442px"
                    }
                },
                "lblVpnClientRX":
                {
                    "type"       : "tlabs/content/labelinput",
                    "i18n"       : "label_bytesRx",
                    "dataField"  : "openrouterserver.clientrx",
                    "style" :
                    {
                        "width" : "442px"
                    }
                },
                "lblVpnClientTX":
                {
                    "type"       : "tlabs/content/labelinput",
                    "i18n"       : "label_bytesTx",
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
