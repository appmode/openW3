// Contributed by T-Labs, Deutsche Telekom Innovation Laboratories

//#EXTENDS tlabs/base/telnum

/*
this.setStatus = function($strStatus)
{
	// remove current status class
	if (this._strStatus)
	{
		this.removeClass('w3_status_' + this._strStatus);
	}
	
	// cache new status
	this._strStatus = $strStatus;
	
	// set new status class
	this.addClass('w3_status_' + $strStatus);
}
*/

this._intUid = 1;

this._setPropertyMode = function($strMode)
{
	this._selectElement($strMode);
	this._objProperty.mode = $strMode;
	this.trigger('setmode');
}

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
	
	// change to view mode
	this.property('mode', 'view');

	// clear cached elements
	this._clearElement('#');
	
	// get target elements
	var $elmView = this.getElement('view').firstChild;
	var $elmEdit = this.getElement('edit').firstChild;
	
	// get template elements
	var $elmTemplateView = this.getElement('templateView');
	var $elmTemplateEdit = this.getElement('templateEdit');
	
	// clear target elements
	$elmView.innerHTML = "";
	$elmEdit.innerHTML = "";
	
	// fill target element
	var $strNumber;
	var $elmTemp;
	var $objNumber;
	var $intNumber = 0;
	for ($strNumber in $objValue.line)
	{
		$intNumber++;
		$objNumber = $objValue.line[$strNumber];
		
		// add view template
		$elmTemp = $elmView.appendChild($elmTemplateView.cloneNode(true));
		$elmTemp.id = "";
		this._setNodeText($elmTemp.childNodes[1], $strNumber);
		$elmTemp.setAttribute('data-name', $strNumber);
		
		// add edit template
		$elmTemp.elmEdit = $elmEdit.appendChild($elmTemplateEdit.cloneNode(true));
		
		// set class (disabled/error)
		if ('disabled' in $objNumber && $objNumber.disabled == '1')
		{
			$elmTemp.className = 'w3_inactive';
			$elmTemp.elmEdit.setAttribute('data-disabled', '1');
		}
		else
		{
			$elmTemp.className = 'w3_active';
			//$elmTemp.elmEdit.setAttribute('data-disabled', '0');
		}
		if ('sip_error' in $objNumber && $objNumber.sip_error == 1)
		{
			$elmTemp.className += ' w3_error';
			$elmTemp.elmEdit.className = ' w3_error';
		}
		
		// add edit template
		$elmTemp = $elmTemp.elmEdit;
		$elmTemp.id = "";
		$elmTemp.childNodes[0].value = $strNumber;
		$elmTemp.childNodes[0].id    = this.id + '_input' + $strNumber;
		$elmTemp.childNodes[1].for   = $elmTemp.childNodes[0].id;
	}
	// display edit mode if we have no numbers
	if ($intNumber == 0)
	{
		this.property('mode', 'edit');
	}
	// make sure there are min of 3 inputs
	while ($intNumber < 3)
	{
		this._addNumber();
		$intNumber++;
	}
}

this._getPropertyValue = function()
{
	var $arrNumbers   = [];
	
	// get target elements
	var $elmNumber = this.getElement('edit').firstChild.firstChild;
	var $elmView = this.getElement('view').firstChild;
	
	// get template element
	var $elmTemplateView = this.getElement('templateView');
	
	// clear view target element
	$elmView.innerHTML = "";
	
	var $strNumber;
	var $elmTemp;
	var $objNumber;
	while ($elmNumber)
	{
		// get number
		$strNumber = $elmNumber.firstChild.value;
		if (!$strNumber)
		{
			// remove any blank numbers
			$elmTemp   = $elmNumber;
			$elmNumber = $elmNumber.nextSibling;
			$elmTemp.parentNode.removeChild($elmTemp);
			continue
		}
		$objNumber = this.touchCachedNumber($strNumber);
		$arrNumbers.push($strNumber);
		
		// remove any error
		$elmNumber.className = '';
		
		// add view template
		$elmTemp = $elmView.appendChild($elmTemplateView.cloneNode(true));
		$elmTemp.id = "";
		this._setNodeText($elmTemp.childNodes[1], $strNumber);
		$elmTemp.setAttribute('data-name', $strNumber);
		$elmTemp.elmEdit = $elmNumber;
		if ($elmNumber.getAttribute('data-disabled') == '1')
		{
			$objNumber.disabled = '1';
			$elmTemp.className  = 'w3_inactive';
			$elmTemp.elmEdit.setAttribute('data-disabled', '1');
		}
		else
		{
			$objNumber.disabled = '0';
			$elmTemp.className  = 'w3_active';
			//$elmTemp.elmEdit.setAttribute('data-disabled', '0');
		}
		
		$elmNumber = $elmNumber.nextSibling;
	}
	
	// update the cached values
	this.updateCachedNumbers($arrNumbers);
	
	return this.getCachedValue();
}

this._addNumber = function()
{
	// get target element
	var $elmEdit = this.getElement('edit').firstChild;
	
	// get template element
	var $elmTemplateEdit = this.getElement('templateEdit');
	
	// add number element
	var $elmTemp = $elmEdit.appendChild($elmTemplateEdit.cloneNode(true));
	$elmTemp.id = "";
	$elmTemp.childNodes[0].id    = this.id + '_inputNew' + this._intUid++;
	$elmTemp.childNodes[1].for   = $elmTemp.childNodes[0].id;
}

this._deleteNumber = function($elmView)
{
	var $strNumber = $elmView.getAttribute('data-name');
	var $elmEdit   = $elmView.elmEdit;
	$elmEdit.parentNode.removeChild($elmEdit);
	$elmView.parentNode.removeChild($elmView);
}

this._activateNumber = function($elmView)
{
	var $strNumber = $elmView.getAttribute('data-name');
	$elmView.className = 'w3_active';
	$elmView.elmEdit.setAttribute('data-disabled', '0');
}

this._deactivateNumber = function($elmView)
{
	var $strNumber = $elmView.getAttribute('data-name');
	$elmView.className = 'w3_inactive';
	$elmView.elmEdit.setAttribute('data-disabled', '1');
}


this._onclick = function($objEvent)
{
	switch ($objEvent.target.getAttribute('data-action'))
	{
		// change to edit mode
		case 'change':
			this.property('mode', 'edit');
			break;
		// add number
		case 'add':
			this._addNumber();
			break;
		// activate
		case 'activate':
			this._activateNumber($objEvent.target.parentNode);
			break;
		// deactivate
		case 'deactivate':
			this._deactivateNumber($objEvent.target.parentNode);
			break;
		// delete
		case 'delete':
			this._deleteNumber($objEvent.target.parentNode);
			break;
	}
}
