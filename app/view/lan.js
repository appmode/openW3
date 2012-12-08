//----------------------------------------------------------------------------//
/*  
 * Contributed by T-Labs, Deutsche Telekom Innovation Laboratories
 * 
 * author    : Flame Herbohn
 * 
 */
//----------------------------------------------------------------------------//

ui.lan.fraAddress.btnSave.confirmAction = function($strAction)
{
	switch ($strAction)
	{
		case 'ok':
			this.w3.luciRpc.submitDataSource(this.property('dataSource'));
			this.setStatus('wait');
				
			//display something interesting for 90 seconds while we reboot
			ui.infoReboot.start();
			break;
		case 'cancel':
			break;
	}
}
