//----------------------------------------------------------------------------//
/*  
 * Contributed by T-Labs, Deutsche Telekom Innovation Laboratories
 * 
 * author    : Flame Herbohn
 * 
 */
//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
// luciRpc.conf.js
//----------------------------------------------------------------------------//
/*
 * Config for luciRpc dataSources
 */

//----------------------------------------------------------------------------//
// register dataSources
//----------------------------------------------------------------------------//
// w3.luciRpc.registerDataSource($strDataSource, $strType, $strRpcSetMethod);

// wireless
w3.luciRpc.registerDataSource('wireless',           'wireless',   'set_wireless');
//w3.luciRpc.registerDataSource('wireless_assistant', 'wireless');

// lan
w3.luciRpc.registerDataSource('lan',                'lan',        'set_lan');
//w3.luciRpc.registerDataSource('lan_assistant',      'lan');

// wan
w3.luciRpc.registerDataSource('wan',                'wan',        'set_wan');
//w3.luciRpc.registerDataSource('wan_assistant',      'wan');

// voip
w3.luciRpc.registerDataSource('voip',               'voip',       'set_voip_all');
w3.luciRpc.registerDataSource('voipSettings',       'voip',       'set_voip');
w3.luciRpc.registerDataSource('voipIncoming',       'voip',       'set_voip');
w3.luciRpc.registerDataSource('voipOutgoing',       'voip',       'set_voip');

// dsl
w3.luciRpc.registerDataSource('dsl',                'dsl');
w3.luciRpc.registerDataSource('dsl',                'dsl');

// modem
w3.luciRpc.registerDataSource('modem',              'external_modem');

// packages
//TODO!!!! : need a data converter -> "modified" (see orSettingsInfo.frm)
w3.luciRpc.registerDataSource('packages',           'modified_packages');

// sys info
w3.luciRpc.registerDataSource('sysinfo',            'systeminfo');

// password
w3.luciRpc.registerDataSource('pwd',                'password',   'set_password');

//----------------------------------------------------------------------------//
// register RPC data converters
//----------------------------------------------------------------------------//

// set_wireless : duplicate radio0 -> radio1
w3.luciRpc.registerRpcConverter('set_wireless', function($objData)
{
	$objData.radio0 = $objData.radio0 || {};
	$objData.radio1 = $objData.radio1 || {};
	var i;
	for (i in $objData.radio0)
	{
		if (i != 'disabled')
		{
			$objData.radio1[i] = $objData.radio0[i];
		}
	}
	return $objData;
});
