// Contributed by T-Labs, Deutsche Telekom Innovation Laboratories

this._onclick = function($objEvent)
{
	if (!this._objShow)
	{
		this._objShow = {};
	}
	var $strTarget = $objEvent.targetWithId.getAttribute('data-target');
	// get the action from the target
	switch ($objEvent.target.getAttribute('data-action'))
	{
		case 'hide':
			// hide button was clicked
			this._objShow[$strTarget] = false;
			$objEvent.targetWithId.className = this.property('className') + '_hide';
			break;
		default:
			switch ($objEvent.targetWithId.getAttribute('data-action'))
			{
				case 'show':
					// show
					if (!this._objShow[$strTarget])
					{
						this._objShow[$strTarget] = true;
						this.getElement("hidden" +  $strTarget).className = this.property('className') + '_show';
					}
					else
					{
						this._objShow[$strTarget] = false;
						this.getElement("hidden" +  $strTarget).className = this.property('className') + '_hide';
					}
					break;
				case 'navigate':
					var $strSection = $objEvent.targetWithId.getAttribute('data-menu');
					var $strView    = $objEvent.targetWithId.getAttribute('data-item');
					this.w3.app.navigateTo($strSection, $strView);
					this.parentView.hide();
					break;
				// any other click is ignored
			}
	}
}
