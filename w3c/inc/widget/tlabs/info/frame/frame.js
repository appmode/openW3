// Contributed by T-Labs, Deutsche Telekom Innovation Laboratories

this._onclick = function($objEvent)
{
	if($objEvent.target.getAttribute('data-action'))
	{
		this.parentView.hide(true);
	}
}
