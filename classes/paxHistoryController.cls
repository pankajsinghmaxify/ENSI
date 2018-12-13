public class paxHistoryController {
    
    public paxHistoryController(ApexPages.StandardController stdController) {
    }
    
    //public static map<Job__c, Job_Role__c> jobMap {get;set;}
    
    public static map<Job__c, Job_Role__c> getjobMap() {
        
        map<Job__c, Job_Role__c> myMap = new map<Job__c, Job_Role__c>();
        
        Participant__c pax = [SELECT Id, Contact__c 
                              FROM Participant__c
                              WHERE Id = :apexPages.currentPage().getParameters().get('id')
                              LIMIT 1
                             ];
        
        for(Participant__c p : [SELECT Id, Job__c, Job__r.Name, Job__r.Job_First_Date__c, Job__r.Job_Last_Date__c 
                                FROM Participant__c 
                                WHERE Contact__c = :pax.Contact__c 
                                AND Id != :pax.Id 
                                order by Job__r.Job_First_Date__c DESC NULLS LAST]){
                                    
                                    Job__c[] job = [SELECT Id, Name, Job_First_Date__c, Job_Last_Date__c, Public_Program_Name__c, Certificate_Date_Text__c, Comments__c
                                                    FROM Job__c 
                                                    WHERE Id = :p.Job__c
                                                    LIMIT 1]; 
                                    
                                    Job_Role__c[] presenter = [SELECT Id, Contact__r.FirstName, Contact__r.LastName
                                                               FROM Job_Role__c 
                                                               WHERE Job__c = :p.Job__c
                                                               AND Role__c = 'Presenter' limit 1];
                                    
                                    
                                    if(presenter.size() != 0){
                                        myMap.put(job[0], presenter[0]);
                                    }
                                    
                                }
        
        return myMap;
        
    }
    
}