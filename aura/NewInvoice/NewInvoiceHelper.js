({
    doInit: function (cmp, e, helper) {
        helper.showSpinner(cmp);
        helper.doGetOpportunity(cmp,e,helper);
        helper.doGetLineItems(cmp,e,helper);
        helper.doGetPercentOptions(cmp,e,helper);
    },
    
    doGetOpportunity: function(cmp, e, helper) {
        var action = cmp.get('c.getOpportunity');
        
        action.setParams({
            'opportunityId': cmp.get('v.recordId')
        });
        
        action.setCallback(this, function(a) {
            let message = '';
            if(a.getState() === 'SUCCESS') {
                cmp.set('v.op', a.getReturnValue());
                console.log(cmp.get('v.op'));
            } else {
                let errors = a.getError();
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
            }
            helper.hideSpinner(cmp, message);
        });
        
        $A.enqueueAction(action);
    },
    
    doGetLineItems: function(cmp, e, helper) {
        var action = cmp.get('c.getLineItems');
        
        action.setParams({
            'opportunityId': cmp.get('v.recordId')
        });
        
        action.setCallback(this, function(a) {
            let message = '';
            if(a.getState() === 'SUCCESS') {
                let retVal = a.getReturnValue(),
                    ppAmts = cmp.get('v.partPaidOliAmt'),
                    upAmts = cmp.get('v.unPaidOliAmt'),
                    oliAmts = cmp.get('v.oliAmt'),
                    prevInvoiced = cmp.get('v.prevInvoiced');
                
                cmp.set('v.olis', retVal);
                
                for(var i = 0; i < retVal.length; i++) {
                    var oli = retVal[i];
                    if(oli.Amount_invoiced_so_far__c != null && oli.Amount_invoiced_so_far__c > 0) {
                        oliAmts += oli.Quantity*oli.UnitPrice;
                        ppAmts += oli.Quantity*oli.UnitPrice - oli.Amount_invoiced_so_far__c;
                        prevInvoiced += oli.Amount_invoiced_so_far__c;
                    } else {
                        upAmts += oli.Quantity*oli.UnitPrice;
                    }
                }
                
                cmp.set('v.partPaidOliAmt', ppAmts);
                cmp.set('v.unPaidOliAmt', upAmts);
                cmp.set('v.prevInvoiced', prevInvoiced);
                
                if(oliAmts > 0) {
                    cmp.set('v.oliAmt', oliAmts);
                } else {
                    cmp.set('v.oliAmt', upAmts);
                }
            } else {
                let errors = a.getError();
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
            }
            helper.hideSpinner(cmp, message);
        });
        
        $A.enqueueAction(action);
    },
    
    doGetPercentOptions: function(cmp,e,helper) {
        var action = cmp.get('c.getInvoicePercents');
        
        action.setCallback(this, function(a) {
            let message = '';
            if(a.getState() === 'SUCCESS') {
                console.log(a.getReturnValue());
                cmp.set('v.pctOpts', a.getReturnValue());
            } else {
                let errors = a.getError();
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
            }
            helper.hideSpinner(cmp, message);
        });
        
        $A.enqueueAction(action);
    },
    
    doSetFinalize: function(cmp,e,helper) {
        var final = cmp.get('v.finalize');
        var op = cmp.get('v.op');
        
        var prevInvoiced = cmp.get('v.prevInvoiced');
        
        var ppAmts = cmp.get('v.partPaidOliAmt');
        var upAmts = cmp.get('v.unPaidOliAmt');
        var oliAmts = cmp.get('v.oliAmt');
        
        if(final) {
            cmp.set('v.oliAmt', (ppAmts || 0) + (upAmts|| 0));
        } else {
            cmp.set('v.amt', 0);
            cmp.set('v.oliAmt', ppAmts != null & ppAmts > 0 ? ppAmts + prevInvoiced : upAmts);
        }
    },
    
	// this function automatic call by aura:waiting event
    showSpinner: function (component) {
        // hide any existing display message
        component.set('v.returnMsg', '');
        // make Spinner attribute true for display loading spinner
        component.set('v.showSpinner', true);
    },
    
    // this function automatic call by aura:doneWaiting event
    hideSpinner: function (component, return_message){
        // hide any existing display message
        component.set('v.returnMsg', return_message);
        // make Spinner attribute to false for hide loading spinner
        component.set('v.showSpinner', false);
    },
    
    doCreateInvoice : function(cmp, e, helper) {
        var action = cmp.get('c.newInvoice');
        
        action.setParams({
            'opportunityId': cmp.get('v.recordId'),
            'invoicePercent': cmp.get('v.amt'),
            'finalize': cmp.get('v.finalize')
        });
        
        action.setCallback(this, function(a) {
            let message = '';
            if(a.getState() === 'SUCCESS') {
                var editRecordEvent = $A.get("e.force:navigateToURL");
                editRecordEvent.setParams({
                    "url": '/apex/invt__CreateInvoice?id=' + a.getReturnValue()
                });
                editRecordEvent.fire();
            } else {
                let errors = a.getError();
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
            }
            helper.hideSpinner(cmp, message);
        });
        
        helper.showSpinner(cmp);
        $A.enqueueAction(action);
    }
})