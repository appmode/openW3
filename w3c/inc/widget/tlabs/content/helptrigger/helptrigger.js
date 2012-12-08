// Contributed by T-Labs, Deutsche Telekom Innovation Laboratories

this._onclick = function($objEvent)
{
	// get the action from the target
	var $strAction = $objEvent.target.getAttribute('data-action');
	var $strTarget = this.property('target');
	if ($strAction && $strTarget)
	{
		// look for the target widget (by name) in any ancestor widget (back down to the view)
		var $wgtParent = this;
		while ($wgtParent.id != $wgtParent.parentWidget.id)
		{
			$wgtParent = $wgtParent.parentWidget;
			if ($strTarget in $wgtParent)
			{
				if ($wgtParent[$strTarget].showHelp)
				{
					$wgtParent[$strTarget].showHelp($strAction);
				}
				return;
			}
		}
	}
}
