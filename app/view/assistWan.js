ui.assistWan.btnSave.onclick = function($objEvent)
{
    //w3.app.showContent("assistWanCheck");
}

ui.assistWan.btnSave.ondatasourceset = function($objEvent)
{
	// if data was saved
	if (this.getStatus() == 'save')
	{
		// show the next assisant
		this.w3.app.showNextAssistant(this.parentView, 'assistWanDone');
	}
}
