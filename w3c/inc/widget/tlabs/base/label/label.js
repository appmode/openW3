// Contributed by T-Labs, Deutsche Telekom Innovation Laboratories

this._setPropertyValue = function($mixValue)
{
	var $mixKey = Number($mixValue);
	if (isNaN($mixKey))
	{
		$mixKey = $mixValue;
	}
	var $objOptions = this.property('options');
	if ($objOptions)
	{
		var $objValue = $objOptions[$mixKey];
		if ($objValue && 'i18n' in $objValue)
		{
			this.w3.i18n.setElementI18nId(this.getElement('_value'), $objValue.i18n);
		}
	}
	this._objProperty.value = $mixKey;
}
