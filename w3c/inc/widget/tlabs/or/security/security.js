// Contributed by T-Labs, Deutsche Telekom Innovation Laboratories

this._setPropertyValue = function($strValue)
{
	// remove security class (set icon to 'none' level)
	this.removeClass('w3_low');
	this.removeClass('w3_high');
	
	// check security level
	var $strLevel;
	switch (this.property('securityLevels')[$strValue])
	{
		case 2:
			// high
			this.addClass('w3_high');
			$strLevel = 'i18nHigh';
			break;
		case 1:
			// low
			this.addClass('w3_low');
			$strLevel = 'i18nLow';
			break;
		default:
			// none
			$strLevel = 'i18nNone';
	}
	
	// set text (i18n)
	this.w3.i18n.setElementI18nId(this.getElement('_value'), this.property($strLevel));
}

this._onclick = function($objEvent)
{
	var $arrTarget = this.property('target');
	if ($arrTarget)
	{
		this.w3.app.navigateTo($arrTarget[0], $arrTarget[1]);
	}
}
