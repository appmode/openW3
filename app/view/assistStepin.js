ui.assistStepin.btnSave.onclick = function($objEvent)
{
	switch ($objEvent.target.getAttribute('data-action'))
	{
		case 'start':
			this.w3.app.showNextAssistant(this.parentView, 'assistWan');
			break;
	}
}
