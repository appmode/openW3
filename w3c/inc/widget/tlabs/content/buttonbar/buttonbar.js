// Contributed by T-Labs, Deutsche Telekom Innovation Laboratories

this._onclick = function($objEvent)
{
	switch (this._strStatus)
	{
		case 'wait':
			// ignore click event if we have 'wait' status
			return false;
	}
	
	if (this._objProperty.dataSource)
	{
		switch ($objEvent.target.getAttribute('data-action'))
		{
			case 'cancel':
				this.w3.luciRpc.cancelDataInput(this._objProperty.dataSource);
				this.setStatus('none');
				break;
			case 'save':
				if (this._objProperty.confirm && this.w3.app.showConfirm)
				{
					this.w3.app.showConfirm(this, this._objProperty.confirm.i18nTitle, this._objProperty.confirm.i18nContent);
				}
				else
				{
					this.w3.luciRpc.submitDataSource(this._objProperty.dataSource);
					this.setStatus('wait');
					if (this._objProperty.alert && this.w3.app.showAlert)
					{
						this.w3.app.showAlert(this, this._objProperty.alert.i18nTitle, this._objProperty.alert.i18nContent);
					}
				}
				break;
		}
	}
}

this.click = function($strAction)
{
	var arrButtons = this.getElement().getElementsByTagName('button');
	var i = 0;
	var $elmButton;
	for ( ; $elmButton = arrButtons[i++] ; )
	{
		if ($elmButton.getAttribute('data-action') == $strAction)
		{
			return this.trigger('click', {'target':$elmButton});
		}
	}
}

this.confirmAction = function($strAction)
{
	switch ($strAction)
	{
		case 'ok':
			if (this._objProperty.dataSource)
			{
				this.w3.luciRpc.submitDataSource(this._objProperty.dataSource);
				this.setStatus('wait');
			}
			break;
		case 'cancel':
			break;
	}
}

this.getStatus = function()
{
	return this._strStatus;
}

this.setStatus = function($strStatus, $intTimeout)
{
	// remove current status class
	if (this._strClass)
	{
		this.removeClass('w3_status_' + this._strClass);
	}
	// clear timeout
	if (this._refStatusTimer)
	{
		clearTimeout(this._refStatusTimer);
		delete(this._refStatusTimer);
	}
	
	// get status object
	var $objStatus = this.property('status')[$strStatus];
	var $strI18n;
	var $strClass = $strStatus;
	if ($objStatus)
	{
		$strClass = $objStatus['status'] || $strStatus;
		$strI18n   = $objStatus['i18n'];
	}
	
	// cache new status
	this._strStatus = $strStatus;
	this._strClass  = $strClass;
	
	// set new status class
	this.addClass('w3_status_' + $strClass);
	
	// set status text
	var $elmStatus = this.getElement('status');
	this.w3.i18n.setElementI18nId($elmStatus, $strI18n);
	
	// set timeout
	if ($intTimeout)
	{
		var $strCommand = this.w3.ui.id2js(this.id) + ".setStatus('none')";
		this._refStatusTimer = setTimeout($strCommand , $intTimeout);
	}
}

/*
this.setStatusI18n = function($strI18n)
{
	// set status text
	var $elmStatus = this.getElement('status');
	this.w3.i18n.setElementI18nId($elmStatus, $strI18n);
}
*/

this._setPropertyValue = function($objValue)
{
	if (typeof($objValue) != 'object')
	{
		// invalid value
		this.setStatus('none');
	}
	else if ('error' in $objValue && $objValue.error === true)
	{
		// there was an error
		this.setStatus('error');
	}
	else if ('.meta' in $objValue && $objValue['.meta'].method && $objValue['.meta'].method.startsWith('set_'))
	{
		// result of a set_ method wihout an error
		this.setStatus('save', 3000);
	}
	else
	{
		// by default, clear status
		this.setStatus('none');
	}
}

/*
this.disable = function()
{
	this._bolDisabled = true;
	this.addClass('w3_disabled');
}

this.enable = function()
{
	this._bolDisabled = false;
	this.removeClass('w3_disabled');
}
*/
