//----------------------------------------------------------------------------//
/*  
 * Contributed by T-Labs, Deutsche Telekom Innovation Laboratories
 * 
 * author    : Flame Herbohn
 * 
 */
//----------------------------------------------------------------------------//

ui.voip.fraVoip.telNumber.onsetmode = function($objEvent)
{
	switch (this.property('mode'))
	{
		// change to edit mode
		case 'edit':
			//this.parentWidget.selProvider.style('display', 'block');
			this.parentWidget.hlpRegister.style('display', 'block');
			//this.parentWidget.btnSave.style('display', 'block');
			break;
		// change to view mode
		case 'view':
			//this.parentWidget.selProvider.style('display', 'none');
			this.parentWidget.hlpRegister.style('display', 'none');
			//this.parentWidget.btnSave.style('display', 'none');
			break;
	}
}
