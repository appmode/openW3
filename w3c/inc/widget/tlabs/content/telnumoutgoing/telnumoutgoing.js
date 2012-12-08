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
	var $strSocket;
	var $objSocket;
	var $elmTemp;
	for ($strNumber in $objValue.line)
	{
		// add row template
		$elmTemp = $elmTarget.appendChild($elmTemplate.cloneNode(true));
		$elmTemp.id = "";
		this._setNodeText($elmTemp.childNodes[0], $strNumber);
		$elmTemp.setAttribute('data-name', $strNumber);
		// select radio button
		for ($strSocket in $objValue.ext)
		{
			$objSocket = $objValue.ext[$strSocket];
			if ('cid' in $objSocket && $objSocket.cid == $strNumber)
			{
				$intSocket = this.getSocketNumber($strSocket);
				$elmTemp.childNodes[$intSocket].firstChild.checked = true;
			}
		}
	}
	
	// select radio button (auto)
	$objRows = this.getElement('auto').getElementsByTagName('td');
	for ($strSocket in $objValue.ext)
	{
		$objSocket = $objValue.ext[$strSocket];
		if (!('cid' in $objSocket) || $objSocket.cid == '0')
		{
			$intSocket = this.getSocketNumber($strSocket);
			$objRows[$intSocket].firstChild.checked = true;
		}
	}
}

this._getPropertyValue = function()
{
	var $strNumber;
	var $strExt;
	var $objValue = {};
	var $objExt   = this.getCachedValue().ext;
	var $arrExt;
	var $arrTapi  = [];
	for ($strExt in $objExt)
	{
		// by default all sockets are set to auto
		$objValue[$strExt] = {'cid' : 0};
		// get tapi no. for ext
		$arrTapi[this.getSocketNumber($strExt)] = $strExt;
	}
	
	// get target element
	var $elmTemp = this.getElement('table').firstChild;
	
	// check each number
	while($elmTemp)
	{
		$strNumber  = $elmTemp.getAttribute('data-name');
		for (var i=1; i < 3 ; i++)
		{
			if ($elmTemp.childNodes[i].firstChild.checked == true)
			{
				$objValue[$arrTapi[i]] = {'cid' : $strNumber};
			}
		}
		$elmTemp = $elmTemp.nextSibling;
	}
	
	// update cached value
	var $objReturn = {'ext' : $objValue}
	this.updateCachedValue($objReturn);
	
	return $objReturn;
}
