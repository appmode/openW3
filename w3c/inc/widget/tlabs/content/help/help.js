// Contributed by T-Labs, Deutsche Telekom Innovation Laboratories

this._onclick = function($objEvent)
{
	// get the action from the target
	this.showHelp($objEvent.target.getAttribute('data-action'));
}

this.showHelp = function($strAction)
{
	switch ($strAction)
	{
		case 'show':
			this._bolShow = true;
			this.getElement('_hidden').className = this.property('className') + '_show';
			break;
		case 'swap':
			if (!this._bolShow)
			{
				this.showHelp('show');
				break;
			}
		case 'hide':
			this._bolShow = false;
			this.getElement('_hidden').className = this.property('className') + '_hide';
			break;
		// any other action is ignored
	}
}
