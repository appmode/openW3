ui.vpn.radVpnMode.onclick = function($objEvent)
{
	return this.updateStuff();
}

ui.vpn.radVpnMode.updateStuff = function()
{
	// perform action
	switch (this.property('value'))
	{
		case 1:
			// server mode 
			this.parentView.fraServerData.style('display', 'block');
			//this.parentView.fraServerData.open();
			this.parentView.fraServerClientInfo.style('display', 'block');
			this.parentView.fraClientData.style('display', 'none');
			//this.parentView.fraServerData.btnSave.click('save');
			break
		case 2:
			// client mode 
			this.parentView.fraClientData.style('display', 'block');
			//this.parentView.fraClientData.open();
			this.parentView.fraServerData.style('display', 'none');
			this.parentView.fraServerClientInfo.style('display', 'none');
			//this.parentView.fraClientData.btnSave.click('save');
			break
		default:
			this.parentView.fraClientData.style('display', 'none');
			this.parentView.fraServerData.style('display', 'none');
			this.parentView.fraServerClientInfo.style('display', 'none');
	}
}

ui.vpn.radVpnMode.ondatasourceset = function($objEvent)
{
	return this.updateStuff();
}
