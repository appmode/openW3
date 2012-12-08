// Contributed by T-Labs, Deutsche Telekom Innovation Laboratories

// set property
this._setProperty = function($strName, $mixValue)
{
	// check for an error state
	if ($strName == 'value')
	{
		$mixValue = this._setErrorValue($mixValue);
		if ($mixValue == undefined)
		{
			// value was an error object (but may not have been an error)
			// and there was no value set in the error object
			return false;
		}
	}
	
	// look for a property specific method
	var $strMethod = "_setProperty" + $strName.ucFirst();
	if ($strMethod in this)
	{
		return this[$strMethod]($mixValue);
	}
		
	if (this._objProperty[$strName] !== $mixValue)
	{	
		// set widget property
		this._objProperty[$strName] = $mixValue;
		
		// set node property
		return this._setNodeProperty($strName, $mixValue);
	}
	return false;
}

// get property
this._getProperty = function($strName)
{
	// remove error class
	this.removeClass('w3_error');
	
	// look for a property specific method
	var $strMethod = "_getProperty" + $strName.ucFirst();
	if ($strMethod in this)
	{
		return this[$strMethod]();
	}
	return this._objProperty[$strName];
}

// set an error state
/*
 * {"error":false}
 * error class removed
 * returns undefined (value will not be set)
 * 
 * {"error":false, "value":"someValue"}
 * error class removed
 * returns "someValue" (value will be set to "someValue")
 * 
 * {"error":true}
 * error class added
 * returns undefined (value will not be set)
 * 
 * {"error":true, "value":"someValue"}
 * error class added
 * returns "someValue" (value will be set to "someValue")
 * 
 */
this._setErrorValue = function($mixValue)
{
	// remove error class
	this.removeClass('w3_error');
	
	if (typeof($mixValue) == 'object' && $mixValue != null)
	{
		if ('error' in $mixValue)
		{
			if ($mixValue.error != true)
			{
				// error object but no error
				return $mixValue.value;
			}
			// there is an error
			
			// make it look like we have an error
			this.addClass('w3_error');
			return $mixValue.value;
		}
	}
	return $mixValue;
}

// cancel changes to an input
// the internal value property is not updated when the value is changed in the
// browser. It only updates when the value is requested via a call to the 
// .property('value') method, this allows us to reset the value of a widget that
// has been changed but not submited to an RPC call.
this.cancelInput = function()
{
	// cache current internal value
	var $mixValue = this._objProperty.value;
	
	// set internal value to null
	this._objProperty.value = null;
	
	// reset value
	this.property('value', $mixValue);
}

