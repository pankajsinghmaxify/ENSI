({
    init: function(component, event, helper) {
    	helper.doInit(component, event, helper);
    },
    
	createInvoice: function(component, event, helper) {
        helper.doCreateInvoice(component, event, helper);
    },
    
    setFinalize: function(component, event, helper) {
        helper.doSetFinalize(component, event, helper);
    }
})