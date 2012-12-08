// Contributed by T-Labs, Deutsche Telekom Innovation Laboratories

//#EXTENDS tlabs/base/label

this._onclick = function($objEvent)
{
	if (this._bolDisabled === true)
	{
		return false;
	}
	
	var $arrTarget = this.property('target');
	if ($arrTarget)
	{
		this.w3.app.navigateTo($arrTarget[0], $arrTarget[1]);
	}
	var $objOptions = this.property('options');
	if ($objOptions)
	{
		var $objValue = this.property('options')[this._objProperty.value];
		if ($objValue && 'rpc' in $objValue)
		{
			this.w3.luciRpc.rpcMethod($objValue.rpc, $objValue.rpcParam);
		}
	}
	if (this.property('rpc'))
	{
		this.w3.luciRpc.rpcMethod(this.property('rpc'), this.property('rpcParam'));
	}
}

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
