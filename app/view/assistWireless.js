ui.assistWireless.btnSave.onclick = function($objEvent)
{
	switch ($objEvent.target.getAttribute('data-action'))
	{
		case 'next':
			if (!this.parentView.radWifi.property('value'))
			{
				var $strNext = 'assistWirelessDone';
			}
			else
			{
				var $strNext = 'assistWirelessData';
			}
			// show the next assisant
			this.w3.app.showNextAssistant(this.parentView, $strNext);
			break;
	}
};

ui.assistWireless.onload = function($objEvent)
{
	// hide coins in progress widget
    this.headerWireless.getElement('subpart1').style.visibility = "hidden";
};

ui.assistWireless.radWifi.onclick = function($objEvent)
{
    if (!this.property('value'))
    {
        this.parentView.headerWireless.getElement('subpart1').style.visibility = "hidden";
    }
    else
    {
        this.parentView.headerWireless.getElement('subpart1').style.visibility = "visible";
    }
};

/*
ui.assistWireless.activeWifiListItem1.ondatasourceset = function($objEvent) {

    //console.debug("activeWifiListItem1 $objEvent : ", $objEvent);

    var $objValue = this.property('value');

    console.debug("activeWifiListItem1 $objValue : ", $objValue);

    // ignore empty result set
    if ($objValue == null) {
        return false;
    }

    // check for errors
    if ($objValue.error === true) {
        //TODO!!!! : handle error
        console.log('there was an error');
        return false;
    }

    // fill target element
    var $strWifiName;
    for ($strWifiName in $objValue) {
        break;
    }

    var $elmTarget = this.getElement('Value');
    $elmTarget.innerHTML = $strWifiName;

};*/
