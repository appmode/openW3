//#EXTENDS tlabs/content/help

this._setPropertyValue = function($objValue)
{
    // ignore empty result set
    if ($objValue == null)
    {
        console.warn('$objValue is null');
        return false;
    }
    
    // check for errors
    if ($objValue.error === true)
    {
        //TODO!!!! : handle error
        console.log('there was an error');
        return false;
    }
    
    console.debug("$objValue : ", $objValue);
    
    // fill target element
    var $strNumber;
    for ($strNumber in $objValue.line)
    {
        break;
    }
    
    var $elm = this.getElement('Value');
    $elm.innerHTML = $strNumber + " (IP) ";

}
