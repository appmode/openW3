//----------------------------------------------------------------------------//
/*  
 * Contributed by T-Labs, Deutsche Telekom Innovation Laboratories
 * 
 * author    : Flame Herbohn
 * 
 */
//----------------------------------------------------------------------------//

ui.settingsModem.chkModem.onclick = function($objEvent)
{
	if (this.property('value'))
	{
		// external modem turned on
		this.w3.app.showConfirm(this, 'lightbox_activate_ext_modem_headline', 'lightbox_activate_ext_modem_content');
	}
	else
	{
		// external modem turned off
		this.w3.luciRpc.rpcMethod('set_external_modem', {"enable" : 0});
	}
}

ui.settingsModem.chkModem.confirmAction = function($strAction)
{
	switch ($strAction)
	{
		case 'ok':
			this.w3.luciRpc.rpcMethod('set_external_modem', {"enable" : 1});
			break;
		case 'cancel':
			this.property('value', false);
			break;
	}
}
