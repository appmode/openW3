
ui.assistVoipAssignDefault.onload = function($objEvent)
{    
    // hide coins in progress widget
    ui.assistVoipAssignDefault.headerAssignDefault.getElement('subpart2').style.visibility = "hidden";
};

ui.assistVoipAssignDefault.radStandard.onclick = function($objEvent)
{
    if (!this.property('value'))
    {
        this.parentView.headerAssignDefault.getElement('subpart2').style.visibility = "hidden";
    }
    else
    {
        this.parentView.headerAssignDefault.getElement('subpart2').style.visibility = "visible";
    }
};

ui.assistVoipAssignDefault.btnSave.onclick = function($objEvent)
{
    switch ($objEvent.target.getAttribute('data-action'))
	{
		case 'next':
			if (!this.parentView.radStandard.property('value'))
			{
				var $strNext = 'assistVoipDone';
			}
			else
			{
				var $strNext = 'assistVoipAssignIn';
			}
			// show the next assisant
			this.w3.app.showNextAssistant(this.parentView, $strNext);
			break;
	}
};
