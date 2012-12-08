// Contributed by T-Labs, Deutsche Telekom Innovation Laboratories

this._onclick = function($objEvent)
{
	// get the action from the target
	switch ($objEvent.target.getAttribute('data-action'))
	{
		case 'toggle':
			this.toggle();
			break;
	}
}

this.open = function()
{
	// show content
	this.getElement('_Content').className = this.property('className') + '_show';
	// change arrow
	this.getElement('_toggle').className = this.property('className')+ '_up';
}

this.close = function()
{
	// hide content
	this.getElement('_Content').className = this.property('className') + '_hide';
	// change arrow
	this.getElement('_toggle').className = this.property('className')+ '_down';
}

this.toggle = function()
{
	// if content is visible
	if(this.getElement('_Content').className == this.property('className') + '_show')
	{
		this.close();
	}
	else
	{
		this.open();
	}
}
