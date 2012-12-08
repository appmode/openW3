// Contributed by T-Labs, Deutsche Telekom Innovation Laboratories

this._objButton  = false;
this._bolEnabled = false;

this._onclick = function($objEvent)
{
	if (this._bolEnabled != true)
	{
		return false;
	}
	
	// check if click is on a button
	var $intButton = $objEvent.targetWithId.getAttribute('data-button');
	if ($intButton)
	{
		// check if button has a definition (ignore blank buttons)
		var $objButton = this.property('buttons')[$intButton -1];
		if ($objButton)
		{
			// select button
			this._selectElement($objEvent.targetWithId);
			// cache button definition
			this._objButton = $objButton;
			// trigger user event handler
			return true;
		}
	}
	// do not trigger user event handler for non-button clicks
	return false;
}

this.getCurrentButton = function()
{
	if (this._objButton)
	{
		return this._objButton;
	}
	return false;
}

// navigate to a button
this.navigateTo = function($strButton)
{
	if (this._bolEnabled != true)
	{
		return false;
	}
	
	if (!$strButton)
	{
		this._objButton = false;
		this._deselectElement();
		// trigger deselect event handler
		this.trigger('deselect');
		return true;
	}
	var $arrButtons = this.property('buttons');
	var $objButton;
	var i = 0;
	for ( ; $objButton = $arrButtons[i++] ;)
	{
		if ($objButton.name == $strButton)
		{
			// trigger onclick event handler
			var $objEvent = {};
			$objEvent.target = this.getElement('button' + i);
			this.trigger('click', $objEvent);
			return true;
		}
	}
	return false;
}

this.disable = function()
{
	this._objButton = false;
	this._deselectElement();
	this._bolEnabled = false;
}

this.enable = function()
{
	this._bolEnabled = true;
}
