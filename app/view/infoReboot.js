//----------------------------------------------------------------------------//
/*  
 * Contributed by T-Labs, Deutsche Telekom Innovation Laboratories
 * 
 * author    : Flame Herbohn
 * 
 */
//----------------------------------------------------------------------------//

// clone the hide method
ui.infoReboot.sudoHide = ui.infoReboot.hide;

ui.infoReboot.hide = function()
{
	// prevent normal lightbox hide functionality
}

ui.infoReboot.start = function()
{
	// display time in view
	this._intTimer = 90;
	this.fraInfo.getElement('timer').innerHTML = this._intTimer;
	
	// set interval timer
	var $strCommand = this.w3.ui.id2js(this.id) + ".tick()";
	this._refInterval = setInterval($strCommand, 1000);
	
	// show view
	this.show();
}

ui.infoReboot.tick = function()
{
	// update time in view
	this._intTimer--;
	this.fraInfo.getElement('timer').innerHTML = this._intTimer;
	if (this._intTimer < 1)
	{
		// stop timer
		clearInterval(this._refInterval);
		
		// logout
		this.w3.luciRpc.logout();
		
		// hide view
		this.sudoHide();
	}
}

