// Contributed by T-Labs, Deutsche Telekom Innovation Laboratories

//#EXTENDS tlabs/base/telnum

this._setPropertyValue = function($objValue)
{
	// ignore empty result set
	if ($objValue == null)
	{
		return false;
	}
	
	// check for errors
	if ($objValue.error == true)
	{
		//TODO!!!! : handle error
console.log('there was an error');
		return false;
	}
	
	// cache value
	this.cacheValue($objValue);
	
	// clear cached elements
	this._clearElement('#');
	
	// get target element
	var $elmTarget = this.getElement('table');
	
	// get template element
	var $elmTemplate = this.getElement('templateRow');
	
	// clear target element
	$elmTarget.innerHTML = "";
	
	// fill target element
	var $strNumber;
	var $elmTemp;
	for ($strNumber in $objValue.line)
	{
		// add row template
		$elmTemp = $elmTarget.appendChild($elmTemplate.cloneNode(true));
		$elmTemp.id = "";
		this._setNodeText($elmTemp.childNodes[0], $strNumber);
		$elmTemp.setAttribute('data-name', $strNumber);
		// set checkbox
		if ('clir' in $objValue.line[$strNumber] && $objValue.line[$strNumber].clir == "1")
		{
			$elmTemp.childNodes[1].firstChild.checked = true;
		}
	}
}

this._getPropertyValue = function()
{
	var $objValue = {};
	var $strNumber;
	var $bolChecked;
	
	// get target element
	var $elmTemp = this.getElement('table').firstChild;
	
	// get clir setting for each number
	while($elmTemp)
	{
		$strNumber  = $elmTemp.getAttribute('data-name');
		$bolChecked = (($elmTemp.childNodes[1].firstChild.checked) ? 1 : 0);
		$objValue[$strNumber] = {'clir' : $bolChecked};
		$elmTemp = $elmTemp.nextSibling;
	}
	
	// update cached value
	var $objReturn = {'line' : $objValue}
	this.updateCachedValue($objReturn);
	
	return $objReturn;
}
