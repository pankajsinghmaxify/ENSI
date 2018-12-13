trigger JobRoleAction on Job_Role__c (after insert, after update, after undelete, after delete) {
    if(Trigger.isInsert) {
        JobAction.updateJobRoles(Trigger.new);
    }
    if(Trigger.isUpdate) {
       JobAction.updateJobRoles(Trigger.new);
       JobAction.updateJobRoles(Trigger.old);
    }
    if(Trigger.isDelete) {
        JobAction.updateJobRoles(Trigger.old);        
    }
    if(Trigger.isUnDelete) {
        JobAction.updateJobRoles(Trigger.new);        
    }    
}