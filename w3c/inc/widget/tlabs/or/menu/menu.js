// Contributed by T-Labs, Deutsche Telekom Innovation Laboratories

this._objList = {};
//this._strCurrentList = false;

this.update = function($strName, $arrMenu)
{
/* Note : we keep the inactive menu lists in the 'hidden' div so that they
 * remain within the DOM and will be translated if the language is changed.
 */
	var $elmTarget = this.getElement('active');
	var $elmHidden = this.getElement('hidden');
	
	// cache list if required
	if (!($strName in this._objList))
	{
		var $elmList = document.createElement('UL');
		var $objItem;
		var $elmItem;
		var $elmTooltip;
		var $elmSpan;
		var i = 0;
		for ( ; $objItem = $arrMenu[i++] ;)
		{
			// build menu item
			$elmItem = document.createElement('LI');
			$elmSpan = document.createElement('SPAN');
			if ($objItem.title)
			{
				$elmSpan.innerHTML = $objItem.title;
			}
			if ($objItem.i18n)
			{
				this.w3.i18n.setElementI18nId($elmSpan, $objItem.i18n);
			}
			$elmItem.appendChild($elmSpan);
			
			// build menu item tooltip
			$elmTooltip = document.createElement('DIV');
			$elmSpan    = document.createElement('SPAN');
			if ($objItem.tooltip)
			{
				$elmSpan.innerHTML = $objItem.tooltip;
			}
			if ($objItem.i18nTooltip)
			{
				this.w3.i18n.setElementI18nId($elmSpan, $objItem.i18nTooltip);
			}
			$elmTooltip.appendChild($elmSpan);
			$elmItem.appendChild($elmTooltip);
			
			// attach item to list
			$elmItem.setAttribute('data-view', $objItem.view);
			$elmItem.setAttribute('data-name', $objItem.name);
			$elmList.appendChild($elmItem);
		}
		this._objList[$strName] = $elmList;
	}
	
	// remove existing list
	if ($elmTarget.lastChild)
	{
		$elmHidden.appendChild($elmTarget.lastChild);
	}
	
	// attach new list
	$elmTarget.appendChild(this._objList[$strName]);
	
	// select first item in list
	this._selectElement(this._objList[$strName].firstChild);
	
	// cache nafe of current list
//	this._strCurrentList = $strName;
}

// onclick event handler
this._onclick = function($objEvent)
{
	if ($objEvent.target.tagName == "LI")
	{
		this._selectElement($objEvent.target);
		// trigger user event handler
		return true;
	}
	if ($objEvent.target.tagName == "SPAN" && $objEvent.target.parentNode.tagName == "LI")
	{
		this._selectElement($objEvent.target.parentNode);
		// trigger user event handler
		return true;
	}
	// do not trigger user event handler for non-item clicks
	return false;
}

// get the view name of the selected menu item
this.getSelectedItem = function()
{
	var $elmSelected = this._getSelectedElement();
	if ($elmSelected)
	{
		return $elmSelected.getAttribute('data-view');
	}
	return false;
}

// navigate to an item
this.navigateTo = function($strItem)
{
	var $elmSelected = this._getSelectedElement();
	if ($elmSelected)
	{
		var $elmItem = $elmSelected.parentNode.firstChild;
		while($elmItem)
		{
			if ($elmItem.getAttribute('data-name') == $strItem)
			{
				// trigger onclick event handler
				var $objEvent = {};
				$objEvent.target = $elmItem;
				this.trigger('click', $objEvent);
				return true;
			}
			$elmItem = $elmItem.nextSibling;
		}
	}
	return false;
}

// unload the current menu
this.unloadMenu = function()
{
	// deselect item
	this._deselectElement();
	
	// get elements
	var $elmTarget = this.getElement('active');
	var $elmHidden = this.getElement('hidden');
	
	// remove existing list
	if ($elmTarget.lastChild)
	{
		$elmHidden.appendChild($elmTarget.lastChild);
	}
	
	// trigger unload event handler
	this.trigger('unload');
	
	return true;
}
