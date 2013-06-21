ui.assistWirelessDone.btnSave.onclick = function($objEvent)
{
	switch ($objEvent.target.getAttribute('data-action'))
	{
		case 'done':
			this.w3.app.navigateTo("overview", "overview");
			break;
	}
}

ui.assistWirelessDone.txtWifiActive.ondatasourceset = function($objEvent)
{
    if (!this.property('value'))
    {
        document.getElementById(this.id).style.display = "none";
    }
    else
    {
        document.getElementById(this.id).style.display = "block";
    }
};
ui.assistWirelessDone.txtWifiInactive1.ondatasourceset = function($objEvent)
{
    if (this.property('value'))
    {
        document.getElementById(this.id).style.display = "none";
    }
    else
    {
        document.getElementById(this.id).style.display = "block";
    }
};
ui.assistWirelessDone.txtWifiInactive2.ondatasourceset = function($objEvent)
{
    if (this.property('value'))
    {
        document.getElementById(this.id).style.display = "none";
    }
    else
    {
        document.getElementById(this.id).style.display = "block";
    }
};
