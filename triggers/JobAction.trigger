trigger JobAction on Job__c (after insert, after update, after delete) {
   if(Trigger.isInsert || Trigger.isUpdate) {
        JobAction.updateAccounts(Trigger.new);
    }
    if(Trigger.isDelete) {
        JobAction.updateAccounts(Trigger.old);  
    }
}