// Contributed by T-Labs, Deutsche Telekom Innovation Laboratories

this._objCache = {};

this.cacheValue = function($objValue)
{
	this._objCache._objValue  = $objValue;
	
	// empty LUA objects are converted to empty JSON arrays, so we need to convert them back
	var n;
	for (n in $objValue)
	{
		if ($objValue[n] instanceof Array || !$objValue[n])
		{
			$objValue[n] = {};
		}
	}
}

this.updateCachedValue = function($objValue)
{
	var n;
	var i;
	var k;
	for (n in $objValue)
	{
		this._objCache._objValue[n] = this._objCache._objValue[n] || {};
		for (i in $objValue[n])
		{
			this._objCache._objValue[n][i] = this._objCache._objValue[n][i] || {};
			for (k in $objValue[n][i])
			{
				this._objCache._objValue[n][i][k] = $objValue[n][i][k];
			}
		}
	}
	return this._objCache._objValue;
}

this.getCachedValue = function()
{
	return this._objCache._objValue;
}

this.getSocketNumber = function($strId)
{
	return parseInt(this._objCache._objValue.ext[$strId].target.split('/')[1]);
}

this.updateCachedNumbers = function($arrNumbers)
{
	var i = 0;
	var $strNumber;
	var $objNumbers = {};
	// add numbers
	for ( ; $strNumber = $arrNumbers[i++] ; )
	{
		this.touchCachedNumber($strNumber);
		$objNumbers[$strNumber] = true;
	}
	// remove numbers
	for ($strNumber in this._objCache._objValue.line)
	{
		if (!($strNumber in $objNumbers))
		{
			delete(this._objCache._objValue.line[$strNumber]);
		}
	}
	this.removeOrphanCid();
}

this.removeOrphanCid = function()
{
	// remove orphan cid from ext
	for (i in this._objCache._objValue.ext)
	{
		var $strCid = this._objCache._objValue.ext.cid;
		if ($strCid && !($strCid in this._objCache._objValue.line))
		{
			this._objCache._objValue.ext.cid = 0;
		}
	}
}

this.touchCachedNumber = function($strNumber)
{
	if (!($strNumber in this._objCache._objValue.line))
	{
		// add number
		this._objCache._objValue.line[$strNumber] = {};
		
		// add default ring setting
		var $arrRing = [];
		var $strExt;
		for ($strExt in this._objCache._objValue.ext)
		{
			$arrRing.push($strExt);
		}
		this._objCache._objValue.line[$strNumber].ring = $arrRing;
	}
	return this._objCache._objValue.line[$strNumber];
}

this.cancelInput = function()
{
	// set internal value to null
	this._objProperty.value = null;
	
	// reset value
	this.property('value', this._objCache._objValue);
}

this.removeCachedNumber = function($strNumber)
{
	delete(this._objCache._objValue.line[$strNumber]);
	this.removeOrphanCid();
}

this.getCachedNumber = function($strNumber)
{
	return this._objCache._objValue.line[$strNumber];
}

