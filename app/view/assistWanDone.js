ui.assistWanDone.btnSave.onclick = function($objEvent)
{
	switch ($objEvent.target.getAttribute('data-action'))
	{
		case 'next':
			this.w3.app.showNextAssistant(this.parentView, 'assistVoip');
			break;
	}
}
