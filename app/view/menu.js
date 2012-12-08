//----------------------------------------------------------------------------//
/*  
 * Contributed by T-Labs, Deutsche Telekom Innovation Laboratories
 * 
 * author    : Flame Herbohn
 * 
 */
//----------------------------------------------------------------------------//

// onload
ui.menu.onload = function($objEvent)
{
	
}

// update
ui.menu.update = function($strName, $arrMenu)
{
	return this.menu.update($strName, $arrMenu);
}

// unload
ui.menu.unloadMenu = function()
{
	return this.menu.unloadMenu();
}

// get selected view name
ui.menu.getSelectedItem = function()
{
	return this.menu.getSelectedItem();
}

// onclick
ui.menu.menu.onclick = function($objEvent)
{
	// show content
	this.w3.app.showContent();
}


