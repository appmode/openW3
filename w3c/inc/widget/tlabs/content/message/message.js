// Contributed by T-Labs, Deutsche Telekom Innovation Laboratories

this._setPropertyValue = function($strValue)
{
	// get target element
	var $elmTarget = this.getElement('value');
	
	// empty target element
	$elmTarget.innerHTML = "";
	
	// get template element
	var $elmTemplate = this.getElement('templateItem');
	
	var $arrValue = $strValue.split("\n");
	var i = 0;
	var n;
	var $strLine;
	var $elmTemp;
	for ( ; $strLine = $arrValue[i++] ; )
	{
		n = $strLine.indexOf(' ', 10);
		$elmTemp = $elmTarget.appendChild($elmTemplate.cloneNode(true));
		$elmTemp.id = "";
		this._setNodeText($elmTemp.childNodes[0], $strLine.substr(0, n));
		this._setNodeText($elmTemp.childNodes[1], $strLine.substr(n));
	}
}
