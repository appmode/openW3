//----------------------------------------------------------------------------//
/*  
 * Contributed by T-Labs, Deutsche Telekom Innovation Laboratories
 * 
 * author    : Flame Herbohn
 * 
 */
//----------------------------------------------------------------------------//

ui.alert.fraInfo.onclick = function($objEvent)
{
	var $strAction = $objEvent.target.getAttribute('data-action');
	if($strAction)
	{
		if (this.parentView._wgtTarget && this.parentView._wgtTarget.alertAction)
		{
			this.parentView._wgtTarget.alertAction($strAction);
		}
	}
}

ui.alert.sudoShow = ui.alert.show;

ui.alert.show = function($wgtTarget, $strTitle, $strContent)
{
	// cache target widget
	this._wgtTarget = $wgtTarget;
	
	// update title
	this.fraInfo.property('title', $strTitle);
	
	// update content
	this.fraInfo.property('value', $strContent);
	
	// show view
	ui.alert.sudoShow();
}

// prevent normal lightbox hide functionality
ui.alert.sudoHide = ui.alert.hide;
ui.alert.hide = function($bolForce)
{
	if ($bolForce === true)
	{
		this.sudoHide();
	}
}
