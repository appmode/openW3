//----------------------------------------------------------------------------//
/*  
 * Contributed by T-Labs, Deutsche Telekom Innovation Laboratories
 * 
 * author    : Flame Herbohn
 * 
 */
//----------------------------------------------------------------------------//

ui.login.btnLogin.onclick = function($objEvent)
{
	this.parentView.login();
}

ui.login.onload = function($objEvent)
{
	this.show();
	
	// hide splash
	var $elmSplash = document.getElementById('or-splash');
	$elmSplash.style.visibility = 'hidden';
	$elmSplash.style.opacity = 0;
}

ui.login.inpPwd.onkeypress = function($objEvent)
{
	if ($objEvent.which == 13)
	{
		this.parentView.login();
	}
}

ui.login.clear = function()
{
	this.inpPwd.property('value');
	this.inpPwd.property('value', '');
	this.btnLogin.setStatus('none');
}

ui.login.login = function()
{
	this.btnLogin.setStatus('wait');
	this.w3.luciRpc.rpcLogin(this.inpPwd.property('value'));
}

ui.login.onloginfail = function()
{
	this.btnLogin.setStatus('error');
}
