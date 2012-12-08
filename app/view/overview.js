//----------------------------------------------------------------------------//
/*  
 * Contributed by T-Labs, Deutsche Telekom Innovation Laboratories
 * 
 * author    : Flame Herbohn
 * 
 */
//----------------------------------------------------------------------------//

// event triggered when the value of the widget is set from a dataSouce
ui.overview.wan.lblOnlineTime.ondatasourceset = function($objEvent)
{	
	// get timestamp
	var $intUptime = parseInt(this.property('value'));
	
	// get target element
	var $elmTarget = this.getElement();
	
	// empty element
	$elmTarget.innerHTML = "";
	
	// calculate uptime 
	var $strDays = parseInt($intUptime / (3600*24)) + "";
	var $strTime = this.w3.app.ts2timeString($intUptime % (3600*24));
	
	// display uptime
	var $elmTemp;
	// no. of days
	$elmTemp = document.createElement('SPAN');
	$elmTemp.innerHTML = $strDays;
	$elmTarget.appendChild($elmTemp);
	// "day (s)"
	$elmTemp = document.createElement('SPAN');
	this.w3.i18n.setElementI18nId($elmTemp, this.property('i18n'));
	$elmTarget.appendChild($elmTemp);
	// time
	$elmTemp = document.createElement('SPAN');
	$elmTemp.innerHTML = ' , ' + $strTime;
	$elmTarget.appendChild($elmTemp);
}


// disable/enable actions

// wan connection
ui.overview.wan.actActive.onclick = function()
{
	this.disable();
}
ui.overview.wan.actActive.ondatasourceset = function()
{
	this.enable();
}

// 2.4GHz wireless
ui.overview.network.actActive2.onclick = function()
{
	this.disable();
}
ui.overview.network.actActive2.ondatasourceset = function()
{
	this.enable();
}

// 5GHz wireless
ui.overview.network.actActive5.onclick = function()
{
	this.disable();
}
ui.overview.network.actActive5.ondatasourceset = function()
{
	this.enable();
}
