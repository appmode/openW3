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
   
    if ($objValue.radio0.up || $objValue.radio1.up) {
        document.getElementById(this.id).style.display = 'none';
    } else {
        document.getElementById(this.id).style.display = 'block';
    }

};