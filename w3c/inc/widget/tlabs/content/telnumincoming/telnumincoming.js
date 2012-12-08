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
	
	// get 'all' element
	var $elmAll = this.getElement('all').firstChild;
	
	// clear 'all' checkboxes
	while ($elmAll)
	{
		if ($elmAll.tagName == 'TD' && $elmAll.firstChild && $elmAll.firstChild.checked)
		{
			$elmAll.firstChild.checked = false;
		}
		$elmAll = $elmAll.nextSibling;
	}
	
	// get target element
	var $elmTarget = this.getElement('table');
	
	// get template element
	var $elmTemplate = this.getElement('templateRow');
	
	// clear target element
	$elmTarget.innerHTML = "";
	
	// fill target element
	var $strNumber;
	var $elmTemp;
	var $strSocket;
	for ($strNumber in $objValue.line)
	{
		// add row template
		$elmTemp = $elmTarget.appendChild($elmTemplate.cloneNode(true));
		$elmTemp.id = "";
		this._setNodeText($elmTemp.childNodes[0], $strNumber);
		$elmTemp.setAttribute('data-name', $strNumber);
		// set checkbox
		if ('ring' in $objValue.line[$strNumber])
		{
			var $arrRing = $objValue.line[$strNumber].ring;
			var n = $arrRing.length;
			for (var i=0; i < n ; i++)
			{
				$intSocket = this.getSocketNumber($arrRing[i]);
				$elmTemp.childNodes[$intSocket].firstChild.checked = true;
			}
		}
	}
}

this._getPropertyValue = function()
{
	var $objValue = {};
	var $strNumber;
	var $strExt;
	var $objExt   = this.getCachedValue().ext;
	var $arrTapi  = [];
	for ($strExt in $objExt)
	{
		// get tapi no. for ext
		$arrTapi[this.getSocketNumber($strExt)] = $strExt;
	}
	
	// get target element
	var $elmTemp = this.getElement('table').firstChild;
	
	// get setting for each number
	while($elmTemp)
	{
		$strNumber  = $elmTemp.getAttribute('data-name');
		$objValue[$strNumber] = {'ring' : []};
		for (var i=1; i < 3 ; i++)
		{
			if ($elmTemp.childNodes[i].firstChild.checked == true)
			{
				$objValue[$strNumber].ring.push($arrTapi[i]);
			}
		}
		$elmTemp = $elmTemp.nextSibling;
	}
	
	// update cached value
	var $objReturn = {'line' : $objValue}
	this.updateCachedValue($objReturn);
	
	return $objReturn;
}

this._onclick = function($objEvent)
{
	switch ($objEvent.target.getAttribute('data-action'))
	{
		case 'all':
			if ($objEvent.target.checked == true)
			{
				// get socket number
				var $intSocket = parseInt($objEvent.target.getAttribute('data-socket'));
				// get target element
				var $elmTemp = this.getElement('table').firstChild;
				
				// check box for each number
				while($elmTemp)
				{
					$elmTemp.childNodes[$intSocket].firstChild.checked = true;
					$elmTemp = $elmTemp.nextSibling;
				}
			}
			break;
	}
	
}
