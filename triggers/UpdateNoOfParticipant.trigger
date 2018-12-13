trigger UpdateNoOfParticipant on Participant__c (after delete, after insert, after undelete, 
after update) {

    if(Trigger.isUpdate) {
        JobAction.UpdateNoOfParticipantsOfJobs(Trigger.new);
        JobAction.UpdateNoOfParticipantsOfJobs(Trigger.old);
    }
    
    if(Trigger.isInsert) {
        JobAction.UpdateNoOfParticipantsOfJobs(Trigger.new);
    }
    
    if(Trigger.isDelete) {
        JobAction.UpdateNoOfParticipantsOfJobs(Trigger.old);
    }
   
    if(Trigger.isUnDelete) {
        JobAction.UpdateNoOfParticipantsOfJobs(Trigger.new);
    }
}