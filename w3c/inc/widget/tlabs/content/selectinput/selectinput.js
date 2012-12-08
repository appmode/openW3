// Contributed by T-Labs, Deutsche Telekom Innovation Laboratories

//#EXTENDS tlabs/base/rpc

this._setPropertyValue = function($mixValue)
{
	if (this._objProperty.value !== $mixValue)
	{	
		this._objProperty['value'] = $mixValue;
		var n;
		var $intLen = this._objProperty.options.length
		for (n = 0; n < $intLen; n++)
		{
			if (this._objProperty.options[n].value == $mixValue)
			{
				this.getElement('Value').value = $mixValue;
				break;
			}
		}
	}
}
