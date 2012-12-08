//----------------------------------------------------------------------------//
/*  
 * Contributed by T-Labs, Deutsche Telekom Innovation Laboratories
 * 
 * author    : Flame Herbohn
 * 
 */
//----------------------------------------------------------------------------//

ui.wan.btnDisconnect.onclick = function($objEvent)
{
	// make sure the access data frame is open
	this.parentView.fraAccess.open();
	
	// disable button
	this.disable();
	
	// perform action
	switch (this.property('value'))
	{
		case 0:
			// connect : submit data
			this.parentView.fraAccess.btnSave.click('save');
			break
		default:
			// disconnect : set wait status (disconnect method has already been called)
			this.parentView.fraAccess.btnSave.setStatus('wait');
	}
}

ui.wan.fraAccess.btnSave.ondatasourceset = function($objEvent)
{
	// if up = 0 & pending = 1
	if (this.parentView.evtPending.property('value') == 1 
		&& this.parentView.btnDisconnect.property('value') == 0)
	{
		// connect button disabled
		this.parentView.btnDisconnect.disable();
		
		// set status to waiting
		this.setStatus('wait');

		// start polling for status
		//TODO!!!!
	}
	// otherwise
	else
	{
		// connect button enabled
		this.parentView.btnDisconnect.enable();
		
		// stop polling for status
		//TODO!!!!
	}
}

