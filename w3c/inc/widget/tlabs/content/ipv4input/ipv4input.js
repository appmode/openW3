// Contributed by T-Labs, Deutsche Telekom Innovation Laboratories

//#EXTENDS tlabs/base/rpc

this._getPropertyValue = function()
{
	this._objProperty.value = this._objProperty.prefix;
	for (var n = 2; n < 4; n++)
	{
		this._objProperty.value += '.' + this.getElement('value' + n).value;
	}
	return this._objProperty.value;
}

this._setPropertyValue = function($strValue)
{
	if (this._objProperty.value !== $strValue)
	{	
		var $arrValue = $strValue.split('.');
		// value
		this._objProperty.value  = $strValue;
		for (var n = 2; n < 4; n++)
		{
			this.getElement('value' + n).value = $arrValue[n];
		}
		// prefix
		this._objProperty.prefix = $arrValue[0] + '.' + $arrValue[1];
		this._setNodeText(this.getElement('prefix'), this._objProperty.prefix);
	}
}
