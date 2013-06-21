//#EXTENDS tlabs/content/buttonbar

this._onclick = function($objEvent) {

    switch (this._strStatus) {
        case 'wait':
            // ignore click event if we have 'wait' status
            return false;
    }

    //console.debug("this : ", this);
    //console.info("action : ", $objEvent.target.getAttribute('data-action'));

    //if (this._objProperty.dataSource) {
    switch ($objEvent.target.getAttribute('data-action')) {
        case 'back':

            w3.app.navigateAssBack();

            break;

        case 'cancel':

            // TODO needed here ?

            //this.w3.openRouter.cancelDataInput(this._objProperty.dataSource);
            //this.setStatus('none');

            w3.app.navigateTo("overview", "overview");

            break;

        case 'next':

            w3.app.navigateAssNext(function(page, targets) {             
                var result;
                if (page.name === "orAssVoipAssignDefault") {
                    result = targets[page.radStandard._mixCurrentValue === 0 ? 0 : 1];
                } else if (page.name === "orAssWireless") {
                    result = targets[page.radWifi._mixCurrentValue === 0 ? 0 : 1];
                } 
                return result;
            });

            break;

        case 'save':

            // (TODO nothing to save here (?))

            w3.app.navigateAssNext(function(page, targets) {
                var result;
                if (page.name === "orAssVoipAssignDefault") {
                    result = targets[page.radStandard._mixCurrentValue === 0 ? 0 : 1];
                } else if (page.name === "orAssWireless") {
                    result = targets[page.radWifi._mixCurrentValue === 0 ? 0 : 1];
                }
                return result;
            });

            break;
    }
    //}
}
