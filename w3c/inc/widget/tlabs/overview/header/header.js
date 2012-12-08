// Contributed by T-Labs, Deutsche Telekom Innovation Laboratories

this._setPropertyValue = function($bolValue)
{
	var $strDisplay = 'none';
	if ($bolValue)
	{
		$strDisplay = 'block';
	}
	this.getElement('_value').style.display = $strDisplay;
}
