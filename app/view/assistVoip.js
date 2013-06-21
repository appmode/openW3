ui.assistVoip.btnSave.ondatasourceset = function($objEvent) {
    // if data was saved
    if (this.getStatus() == 'save') {
        // show the next assistant
        this.w3.app.showNextAssistant(this.parentView, 'assistVoipAssignDefault');
    }
};
