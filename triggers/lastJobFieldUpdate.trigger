trigger lastJobFieldUpdate on Participant__c (before insert, before update) {

    for(Participant__c p : trigger.new){
        
        if(p.LastJob__c == null){
        
            Participant__c[] pList = [SELECT id, Job__c 
                                      FROM Participant__c 
                                      WHERE Contact__c = :p.Contact__c 
                                      AND Id != :p.Id 
                                      ORDER BY Job__r.Job_First_Date__c DESC 
                                      NULLS LAST];
            
            if(pList.size() > 0) p.LastJob__c = pList[0].Job__c;
            
        }
        
    }
    
}