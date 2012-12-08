// Contributed by T-Labs, Deutsche Telekom Innovation Laboratories

this._onclick = function($objEvent)
{
	switch ($objEvent.target.getAttribute('data-action'))
	{
		case 'close':
			this.parentView.hide();
			break;
	}
}
