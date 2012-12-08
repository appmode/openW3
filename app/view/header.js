//----------------------------------------------------------------------------//
/*  
 * Contributed by T-Labs, Deutsche Telekom Innovation Laboratories
 * 
 * author    : Flame Herbohn
 * 
 */
//----------------------------------------------------------------------------//

// onload
ui.header.onload = function($objEvent)
{
	// translate the view in to the current language
//	w3.i18n.translate(this);
}

// ontranslate
ui.header.ontranslate = function($objEvent)
{
	this.style('visible', true);
}

// nav button click
ui.header.nav.onclick = function($objEvant)
{
	// get current button
	var $objButton = this.getCurrentButton();
	
	// update menu
	this.w3.app.updateMenu($objButton.i18n, $objButton.menu);
	
	// show content
	this.w3.app.showContent();
}

// nav button deselect
ui.header.nav.ondeselect = function($objEvant)
{
	// unload menu
	this.w3.app.unloadMenu();
}
