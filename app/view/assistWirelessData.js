ui.assistWirelessData.btnSave.onclick = function($objEvent)
{

}

ui.assistWirelessData.btnSave.ondatasourceset = function($objEvent)
{
	// if data was saved
	if (this.getStatus() == 'save')
	{
		// show the next assisant
		this.w3.app.showNextAssistant(this.parentView, 'assistWirelessDone');
	}
}
