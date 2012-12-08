// Contributed by T-Labs, Deutsche Telekom Innovation Laboratories

//#EXTENDS tlabs/base/rpc

this._getPropertyValue = function()
{
	var $arrValue = [];
	for (var n = 0; n < 4; n++)
	{
		$arrValue.push(this.getElement('value' + n).value);
	}
	this._objProperty.value = $arrValue;
	return $arrValue;
}

this._setPropertyValue = function($arrValue)
{
	if (typeof($arrValue) == 'object')
	{
		if (JSON.stringify(this._objProperty.value) != JSON.stringify($arrValue))
		{
			this._objProperty.value = $arrValue;
			for (var n = 0; n < 4; n++)
			{
				this.getElement('value' + n).value = $arrValue[n] || '0';
			}
		}
	}
}
