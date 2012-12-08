// Contributed by T-Labs, Deutsche Telekom Innovation Laboratories


this._setPropertyValue = function($objValue)
{
	var i = 0;
	var $elmSpan;
	var $strDataField;
	var $objDataParent;
	var $strField;
	var $arrSpans = this.getElement().getElementsByTagName('span')
	for ( ; $elmSpan = $arrSpans[i++] ; ) 
	{
		$strDataField = $elmSpan.getAttribute('data-field');
		if ($strDataField)
		{
			$objDataParent = $objValue;
			$arrDataField  = $strDataField.split('.');
			var n = 0;
			for ( ; $strField = $arrDataField[n++] ; )
			{
				$objDataParent = $objDataParent[$strField];
			}
			this._setNodeText($elmSpan, $objDataParent);
		}	
	}
}
