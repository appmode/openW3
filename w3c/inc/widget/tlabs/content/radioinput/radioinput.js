// Contributed by T-Labs, Deutsche Telekom Innovation Laboratories

//#EXTENDS tlabs/base/rpc

this._getPropertyValue = function()
{
	if (this._bolHasValue)
	{
		this._objProperty['value'] = this._mixCurrentValue;
	}
	return this._objProperty['value'];
}

this._setPropertyValue = function($mixValue)
{
	if (this._objProperty.value !== $mixValue)
	{
		this._objProperty['value'] = $mixValue;
		var n;
		var $intLen = this._objProperty.buttons.length
		for (n = 0; n < $intLen; n++)
		{
			if (this._objProperty.buttons[n].value == $mixValue)
			{
				this.getElement('button' + n).checked = true;
				break;
			}
		}
	}
}

this._onclick = function($objEvent)
{
	if ($objEvent.target.hasAttribute('data-value'))
	{
		var n = $objEvent.target.getAttribute('data-value');
		this._bolHasValue = true;
		this._mixCurrentValue = this._objProperty.buttons[n].value;
		//TODO!!!! : fix this (internal value should not change until getProperty runs)
	}
}
