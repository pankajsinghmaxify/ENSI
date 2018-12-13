trigger RemoveContactJobReference on Participant__c (after delete) {
    List<Contact> aContactList=new List<Contact>();
    for(Participant__c aPart:trigger.old){
    
            Integer counter =[select count() from Contact where id=:aPart.Contact__c and last_job_id__c=:aPart.Job__c];
            if(counter>0){
            
                    
	            Contact aContact=[select id,last_job_id__c from Contact where id=:aPart.Contact__c and last_job_id__c=:aPart.Job__c];
	            aContact.last_job_id__c=null;
	            aContact.last_job_name__c=null;
	            aContact.last_participant_id__c=null;
	            aContactList.add(aContact);
            
            }

            
                if(aContactList.size()==99){
                    update aContactList;
                    aContactList.clear();
                }
    
    }
    if(aContactList.size()>0){
        update aContactList;
    }
}