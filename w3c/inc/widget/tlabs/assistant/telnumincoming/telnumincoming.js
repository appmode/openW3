//#EXTENDS tlabs/base/telnum

this._setPropertyValue = function($objValue) {
    // ignore empty result set
    if ($objValue == null) {
        return false;
    }

    // check for errors
    if ($objValue.error == true) {
        //TODO!!!! : handle error
        console.log('there was an error');
        return false;
    }

    // cache value
    this.cacheValue($objValue);

    // clear cached elements
    this._clearElement('#');
    
    for (var j = 1; j < 3; j++) {

        // get target element
        var $elmTarget = this.getElement('divPlug' + j);
    
        // get template element
        var $elmTemplate = this.getElement('templateRow');
    
        // clear target element
        $elmTarget.innerHTML = "";
    
        // fill target element
        var $strNumber;
        var $elmTemp;
        var $strSocket;
        for ($strNumber in $objValue.line) {
            // add row template
            $elmTemp = $elmTarget.appendChild($elmTemplate.cloneNode(true));
            $elmTemp.id = "";
    
            $elmTemp.innerHTML += $strNumber;
    
            $elmTemp.setAttribute('data-name', $strNumber);
            // set checkbox
            if ('ring' in $objValue.line[$strNumber]) {
                var $arrRing = $objValue.line[$strNumber].ring;
                var n = $arrRing.length;
    
                for (var i = 0; i < n; i++) {
                    if (this.getSocketNumber($arrRing[i]) === j) {
                        $elmTemp.firstChild.checked = true;
                    }
                }
            }
        }
    
    }
}

this._getPropertyValue = function() {
    var $objValue = {};
    var $strNumber;
    var $strExt;
    var $objExt = this.getCachedValue().ext;
    var $arrTapi = [];
    for ($strExt in $objExt) {
        // get tapi no. for ext
        $arrTapi[this.getSocketNumber($strExt)] = $strExt;
    }
    
    for (var i = 1; i < 3; i++) {

        // get target element
        var $elmTemp = this.getElement('divPlug' + i).firstChild;
    
        // get setting for each number
        while ($elmTemp) {
            $strNumber = $elmTemp.getAttribute('data-name');
            if (!$objValue[$strNumber]) {
                $objValue[$strNumber] = {
                    'ring' : []
                };
            }
    
            if ($elmTemp.firstChild.checked == true) {
                $objValue[$strNumber].ring.push($arrTapi[i]);
            }
            $elmTemp = $elmTemp.nextSibling;
        }
    
    }
    
    console.debug("set voip incoming $objValue ", $objValue);

    // update cached value
    var $objReturn = {
        'line' : $objValue
    }
    this.updateCachedValue($objReturn);

    return $objReturn;
}

