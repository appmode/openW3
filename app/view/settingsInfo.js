//----------------------------------------------------------------------------//
/*  
 * Contributed by T-Labs, Deutsche Telekom Innovation Laboratories
 * 
 * author    : Flame Herbohn
 * 
 */
//----------------------------------------------------------------------------//

// event triggered when the value of the widget is set from a dataSouce
ui.settingsInfo.fraInfo.lblDate.ondatasourceset = function($objEvent)
{
	// convert timestamp to a friendly date
	var $objDate = this.w3.app.ts2dateString(this.property('value'))
	this.property('value', $objDate.date + " " + $objDate.time);
}

ui.settingsInfo.fraInfo.lblPackages.ondatasourceset = function($objEvent)
{
	var $objValue  = this.property('value');
console.log($objValue);
	var $elmTarget = this.getElement('Value');
	
	// clear current content
	$elmTarget.innerHTML = '';
	
	// add new content
	var $elmTemp;
	var $strValue;
	for ($strValue in $objValue)
	{
		if ($strValue.startsWith('.'))
		{
			// skip .meta
			continue;
		}
		$elmTemp = document.createElement('SPAN');
		this._setNodeText($elmTemp, $strValue);
		$elmTarget.appendChild($elmTemp);
		
		$elmTemp = document.createElement('SPAN');
		this._setNodeText($elmTemp, " : " + $objValue[$strValue]);
		$elmTarget.appendChild($elmTemp);
		
		$elmTemp = document.createElement('BR');
		$elmTarget.appendChild($elmTemp);
	}

}
