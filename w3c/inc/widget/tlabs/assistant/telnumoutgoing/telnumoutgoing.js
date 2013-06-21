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
    
    for (var i = 1; i < 3; i++) {

        // get target element
        var $elmTarget = this.getElement('selectPlug' + i);
    
        // get template element
        var $elmTemplate = this.getElement('templateRow');
    
        // clear target element
        $elmTarget.innerHTML = "";
    
        // fill target element
        var $strNumber;
        var $strSocket;
        var $objSocket;
        var $elmTemp;
    
        // first add auto 'automatic' selection
        $elmTemp = $elmTarget.appendChild(this.getElement('templateAuto').cloneNode(true));
        $elmTemp.id = this.id + "_AutoPlug" + i;
        $elmTemp.setAttribute('data-name', "auto");

        for ($strNumber in $objValue.line) {
    
            // add row template
            $elmTemp = $elmTarget.appendChild($elmTemplate.cloneNode(true));
            $elmTemp.id = "";
    
            $elmTemp.innerHTML = $strNumber;
    
            $elmTemp.setAttribute('data-name', $strNumber);
    
            for ($strSocket in $objValue.ext) {
                $objSocket = $objValue.ext[$strSocket];
                if ('cid' in $objSocket && $objSocket.cid === $strNumber) {
                    if (this.getSocketNumber($strSocket) === i) {
                        $elmTemp.selected = "selected";
                    }
                }
            }
        }
    
        // select radio button (auto)
        var $objAuto = this.getElement('AutoPlug' + i);
        var $boolNothingSelected = true;
        for ($strSocket in $objValue.ext) {
            $objSocket = $objValue.ext[$strSocket];
            if (('cid' in $objSocket) && $objSocket.cid !== '0') {
                $boolNothingSelected = false;
                break;
            }
        }
        if ($boolNothingSelected) {
            $objAuto.selected = "selected";
        }
    
    }
}

this._getPropertyValue = function() {
    var $strNumber;
    var $strExt;
    var $objValue = {};
    var $objExt = this.getCachedValue().ext;
    var $arrExt;
    var $arrTapi = [];

    for ($strExt in $objExt) {
        // by default all sockets are set to auto
        $objValue[$strExt] = {
            'cid' : 0
        };
        // get tapi no. for ext
        $arrTapi[this.getSocketNumber($strExt)] = $strExt;
    }

    for (var i = 1; i < 3; i++) {

        // get target element
        var $elmTemp = this.getElement('selectPlug' + i).firstChild;

        // check each number
        while ($elmTemp) {
            $strNumber = $elmTemp.getAttribute('data-name');
            $strNumber = $strNumber === "auto" ? 0 : $strNumber
            if ($elmTemp.selected) {
                $objValue[$arrTapi[i]] = {
                    'cid' : $strNumber
                };
            }
            $elmTemp = $elmTemp.nextSibling;
        }

    }

    console.debug("set voip outgoing $objValue : ", $objValue);

    // update cached value
    var $objReturn = {
        'ext' : $objValue
    }
    this.updateCachedValue($objReturn);

    return $objReturn;
}
