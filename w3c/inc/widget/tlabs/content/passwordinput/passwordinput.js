// Contributed by T-Labs, Deutsche Telekom Innovation Laboratories

//#EXTENDS tlabs/base/rpc

this._onclick = function($objEvent)
{
	if ($objEvent.targetWithId.getAttribute('data-action') == 'show')
	{
		// get elements
		var $elmValue    = this.getElement('Value');
		var $elmAltValue = this.getElement('altValue');

		// clear cached elements
		this._clearElement('#');
			
		// swap the ids
		$elmValue.id     = this.id + "_altValue";
		$elmAltValue.id  = this.id + "_Value";
		
		// update the value
		$elmAltValue.value = $elmValue.value;
		
		// swap the position
		this.getElement().insertBefore($elmAltValue, $elmValue);
	}
}

this._setPropertyValue = function($strValue)
{
	// cache value
	this._objProperty.value = $strValue;
	
	// update displayed value
	this.getElement('Value').value    = $strValue;
	this.getElement('altValue').value = $strValue;
}

