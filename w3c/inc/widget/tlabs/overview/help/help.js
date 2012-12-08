// Contributed by T-Labs, Deutsche Telekom Innovation Laboratories

this._onclick = function($objEvent)
{
	var $strView = $objEvent.target.getAttribute('data-target');
	if ($strView)
	{
		if ('showLightbox' in this.w3.app)
		{
			this.w3.app.showLightbox($strView);
		}
	}
}
