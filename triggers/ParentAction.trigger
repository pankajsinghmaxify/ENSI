trigger ParentAction on Job_Item__c (after insert, after update, after delete) {
    if(Trigger.isInsert) {
    	JobAction.updateJobRolesFromJobItems(Trigger.new);
        JobAction.updateJobFromJobItems(Trigger.new);
    }
   
    if(Trigger.isUpdate) {
    	
        JobAction.updateJobRolesFromJobItems(Trigger.new);
        JobAction.updateJobRolesFromJobItems(Trigger.old);
       //JobAction.updateJobFromJobItems(Trigger.new);
       //JobAction.updateJobFromJobItems(Trigger.old);
    }
    if(Trigger.isDelete) {
    	JobAction.updateJobRolesFromJobItems(Trigger.old);
        JobAction.updateJobFromJobItems(Trigger.old);
    }
}