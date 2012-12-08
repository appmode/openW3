// Contributed by T-Labs, Deutsche Telekom Innovation Laboratories

//#EXTENDS tlabs/base/rpc

this._onclick = function($objEvent)
{
	// ignore label clicks (there will be a second click registered on the input)
	if($objEvent.target.tagName == 'LABEL')
	{
		return false;
	}
	
	if (this.property('rpc'))
	{
		this.w3.luciRpc.rpcMethod(this.property('rpc'), [this.property('value')]);
	}
}
