//----------------------------------------------------------------------------//
/*  
 * Contributed by T-Labs, Deutsche Telekom Innovation Laboratories
 * 
 * author    : Flame Herbohn
 * 
 */
//----------------------------------------------------------------------------//

// event triggered when the value of the widget is set from a dataSouce
ui.settingsProblems.fraRestart.txtLastRestart.ondatasourceset = function($objEvent)
{	
	this.parentView.refreshRebootTime();
}

// refresh the date & time since last reboot
ui.settingsProblems.refreshRebootTime = function()
{
	var $wgtTarget = this.fraRestart.txtLastRestart;
	if ($wgtTarget.property('value'))
	{
		// cache the elements into an array
		if (!$wgtTarget._arrDateElements)
		{
			$wgtTarget._arrDateElements = [];
			var $elmTemp = $wgtTarget.getElement('value').firstChild;
			while ($elmTemp)
			{
				if ($elmTemp.tagName == 'SPAN')
				{
					$wgtTarget._arrDateElements.push($elmTemp);
				}
				$elmTemp = $elmTemp.nextSibling;
			}
		}
		
		// get current time & uptime
		var $intUptime = parseInt($wgtTarget.property('value'))*1000;
		var $intTime   = new Date().getTime();
		
		// convert the uptime to nice format for display
		var $objDate = this.w3.app.ts2dateString($intTime - $intUptime);
		
		// display date & time
		this._setNodeText($wgtTarget._arrDateElements[1], $objDate.date);
		this._setNodeText($wgtTarget._arrDateElements[3], $objDate.time);
	}
}

// reboot
ui.settingsProblems.fraRestart.btnRestart.onclick = function($objEvent)
{
	//display something interesting for 90 seconds
	ui.infoReboot.start();
}
