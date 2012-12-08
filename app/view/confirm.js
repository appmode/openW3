//----------------------------------------------------------------------------//
/*  
 * Contributed by T-Labs, Deutsche Telekom Innovation Laboratories
 * 
 * author    : Flame Herbohn
 * 
 */
//----------------------------------------------------------------------------//

ui.confirm.fraInfo.onclick = function($objEvent)
{
	var $strAction = $objEvent.target.getAttribute('data-action');
	if($strAction)
	{
		if (this.parentView._wgtTarget && this.parentView._wgtTarget.confirmAction)
		{
			this.parentView._wgtTarget.confirmAction($strAction);
		}
	}
}

ui.confirm.sudoShow = ui.confirm.show;

ui.confirm.show = function($wgtTarget, $strTitle, $strContent)
{
	// cache target widget
	this._wgtTarget = $wgtTarget;
	
	// update title
	this.fraInfo.property('title', $strTitle);
	
	// update content
	this.fraInfo.property('value', $strContent);
	
	// show view
	ui.confirm.sudoShow();
}

// prevent normal lightbox hide functionality
ui.confirm.sudoHide = ui.confirm.hide;
ui.confirm.hide = function($bolForce)
{
	if ($bolForce === true)
	{
		this.sudoHide();
	}
}
