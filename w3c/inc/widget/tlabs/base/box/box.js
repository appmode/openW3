// Contributed by T-Labs, Deutsche Telekom Innovation Laboratories

this.show = function()
{
	this.style('visible', true);
	this.style('opacity', 1);
	this.addClass('w3_show');
}

this.hide = function()
{
	this.style('visible', false);
	this.style('opacity', 0);
	this.removeClass('w3_show');
}
