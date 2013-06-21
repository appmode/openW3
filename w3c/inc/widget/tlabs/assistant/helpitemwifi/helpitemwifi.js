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
        
        document.getElementById(this.id).style.display = 'block';
        
        if (this.id === "w3__orAssWireless__activeWifiListItem1") {
            
            var $elm = this.getElement('Value');
            var $ssid1 = $objValue.radio0.up ? $objValue.radio0.ssid : "";
            var $ssid2 = $objValue.radio1.up ? $objValue.radio1.ssid : "";
            var $name;
            
            if ($ssid1 === $ssid2) {
                $name = $ssid1;
            } else {
                // a) display both SSIDs
                /*if ($ssid1 !== "" && $ssid2 !== "") {
                    $name = $ssid1 + " / " + $ssid2;
                } else {
                    $name = $ssid1 + $ssid2;
                }*/
                // b) just one
                if ($ssid1 !== "") {
                    $name = $ssid1;
                } else {
                    $name = $ssid2;
                }
            }

            $elm.innerHTML = $name;
        
        } else {
        
            var encItemId;
            var enc0 = $objValue.radio0.encryption;
            var enc1 = $objValue.radio1.encryption;
            
            if (!enc0 || enc0 === "" || enc0 === "none" || !enc1 || enc1 === "" || enc1 === "none") {    
                encItemId = "w3__orAssWireless__activeWifiListItem2Insecure";
            } else {
                if (enc0 === "wep" || enc1 === "wep") {  
                    encItemId = "w3__orAssWireless__activeWifiListItem2LessSecure"; 
                } else {
                    encItemId = "w3__orAssWireless__activeWifiListItem2Secure";   
                }
            }
            if (encItemId === this.id) {
                document.getElementById(this.id).style.display = 'block';
            } else {
                document.getElementById(this.id).style.display = 'none';
            }
            
        }
   
    } else {
        document.getElementById(this.id).style.display = 'none';
    }

};