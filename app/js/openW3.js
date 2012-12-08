//----------------------------------------------------------------------------//
/*  
 * Contributed by T-Labs, Deutsche Telekom Innovation Laboratories
 * 
 * author    : Flame Herbohn
 * 
 */
//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
// openW3.js
//----------------------------------------------------------------------------//
/*
 * openW3 application module
 */
 
//----------------------------------------------------------------------------//
// NOTES
//----------------------------------------------------------------------------//
/*
 * Section/feature names are:
 *      wireless
 *      wan
 *      lan
 *      voip
 *      settings
 * 
 * These are the names used in the RPC API, so lets have some consistency and
 * use the same names everywhere (don't use names like wifi, wlan, internet,
 * connection, asterisk, phone, etc).
 * 
 */
 
// test for unsupported browsers (ie. IE) and redirect
test = document.createElement('input');
if (!('placeholder' in test))
{
	//TODO!!!! add a browser page URL
	window.location.href = "";
}

// set the language
w3.i18n.guessLanguage('en', ['en', 'de']);

W3_app_module = function()
{
	// define app version
	this.VERSION = '12.12.07';

	// module name
	this.name	= 'application';
	
	// module alias
	this.alias	= 'app';
	
	// are we logged in
	this._bolAuth = false;
	
	// the current content page
	this.wgtCurrentContent = false;
	
	// update menu
	this.updateMenu = function($strName, $arrMenu)
	{
		if (this._bolAuth == true)
		{
			// update menu
			ui.orMenu.update($strName, $arrMenu);
		}
	}
	
	// unload menu
	this.unloadMenu = function()
	{
		// update menu
		ui.orMenu.unloadMenu();
		
		// hide current content
		if (this.wgtCurrentContent)
		{
			this.wgtCurrentContent.hide();
		}
	}
	
	// show a lightbox view (loads the view if it is not already loaded)
	this.showLightbox = function($strName)
	{
		if ($strName in this.w3.ui.views)
		{
			this.w3.ui.views[$strName].show();
		}
		else
		{
			this.w3.ui.loadView($strName);
		}
	}
	
	// show the confirm view
	this.showConfirm = function($wgtTarget, $strI18nTitle, $strI18nContent)
	{
		var $strTitle = this.w3.i18n.getTranslation($strI18nTitle);
		var $strContent = this.w3.i18n.getTranslation($strI18nContent);
		ui.orConfirm.show($wgtTarget, $strTitle, $strContent);
	}
	
	// show the alert view
	this.showAlert = function($wgtTarget, $strI18nTitle, $strI18nContent)
	{
		var $strTitle = this.w3.i18n.getTranslation($strI18nTitle);
		var $strContent = this.w3.i18n.getTranslation($strI18nContent);
		ui.orAlert.show($wgtTarget, $strTitle, $strContent);
	}
	
	// show current content view
	//this.showContent = function()
	this.showContent = function($strName)
	{
		if (this._bolAuth == true)
		{
			// get view name
			//var $strName = ui.orMenu.getSelectedItem();
			if ($strName === undefined) {
			    $strName = ui.orMenu.getSelectedItem();
			}
			
			// hide current content
			if (this.wgtCurrentContent)
			{
				this.wgtCurrentContent.hide();
			}
			
			// cache new content
			this.wgtCurrentContent = ui[$strName];
			
			// refresh data
			this.refreshData(this.wgtCurrentContent.property('rpc'));
			
			// show new content
			this.wgtCurrentContent.show();
		}
		else
		{
			// navigate to nowhere
			ui.orHeader.nav.navigateTo(null);
		}
	}
	
	// refresh all data from the router
	this.refreshData = function($arrMethods)
	{
		if (this._bolAuth == true && $arrMethods !== false)
		{
			if ($arrMethods)
			{
				var i = 0;
				var $strMethod;
				for ( ; $strMethod = $arrMethods[i++] ; )
				{
					this.w3.luciRpc.rpcMethod($strMethod);
				}
			}
			else
			{
				this.w3.luciRpc.rpcMethod('get_overview');
				this.w3.luciRpc.rpcMethod('get_systeminfo');
			}
		}
	}
	
	// from sp2luci_or.js
	this.ts2dateString = function(ts)
	{

        var result = {};

        var date = new Date();
        date.setTime(parseInt(ts));

        var dateString = "";
        var timeString = "";

        var month = date.getMonth() + 1;
        if (month < 10) month = "0" + month;
        var day = date.getDate();
        if (day < 10) day = "0" + day;
        var year = date.getFullYear();

        var s = date.getSeconds();
        if (s < 10) s = "0" + s;
        var m = date.getMinutes();
        if (m < 10) m = "0" + m;
        var h = date.getHours();
        if (h < 10) h = "0" + h;

        timeString = h+":"+m+":"+s;

        if (this.w3.i18n.getLanguage() == 'en')
        {
            dateString = year + "-" + month + "-" + day;
        } else {
            dateString = day + "." + month + "." + year;
        }

        result.time = timeString;
        result.date = dateString;

        return result;

    }

	// from sp2luci_or.js
    this.ts2timeString = function(ts)
    {
        var h = parseInt(ts / 3600);
        if (h < 10) h = "0" + h;
        
        var m = parseInt((ts - h * 3600)/60);
        if (m < 10) m = "0" + m;
        
        var s = parseInt(ts - h * 3600 - m * 60);
        if (s < 10) s = "0" + s;

        return h+":"+m+":"+s;
    }
    
    // navigate to a page
    this.navigateTo = function($strSection, $strPage)
    {
		if (this._bolAuth == true)
		{
            //ui.orHeader.nav.navigateTo($strSection);
            //ui.orMenu.menu.navigateTo($strPage);
		    if ($strSection !== "assistant") {
			    ui.orHeader.nav.navigateTo($strSection);
			    ui.orMenu.menu.navigateTo($strPage);
			} else {
			    this.showContent($strPage);
			}
		}
	}
	
	// login event handler
	this.onlogin = function()
	{
		// hide login screen
		ui.orLogin.hide();
		
		// enable navigation
		ui.orHeader.nav.enable();
		
		// remember that we are logged in
		this._bolAuth = true;
		
		// forget the password
		ui.orLogin.clear();
		
		// refresh data
		this.refreshData();
		
		// show security view
		ui.orSecurity.show();
		
		// show default view (splash)
		//TODO!!!!
	}
	
	// failed login event handler
	this.onloginfail = function()
	{
//		console.log('login failed');
		ui.orLogin.onloginfail();
	}
	
	// logout event handler
	this.onlogout = function()
	{
		// navigate to nowhere
		ui.orHeader.nav.navigateTo(null);
		
		// forget that we are logged in
		this._bolAuth = false;
		
		// disable navigation
		ui.orHeader.nav.disable();
		
		// show login page
		ui.orLogin.show();
	}
}

// register module
w3.registerModule(new W3_app_module());

// Remove Class Definition
delete(W3_app_module);

