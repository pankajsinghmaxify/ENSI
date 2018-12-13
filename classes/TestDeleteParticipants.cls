public class TestDeleteParticipants {
    public static testMethod void testDeleteParticipants() { 
    	
    	//Job__c aJob=new Job__c();
    	//Contact__c aContact=new Contact__c();
        //List<Participant__c> aPartList = [select id from Participant__c where job__c <> null and Contact__r.Last_Job_ID__c<> null limit 1 ];
        Participant__c aPartList = [select id from Participant__c where job__c <> null and Contact__r.Last_Job_ID__c<> null limit 1 ];
        delete aPartList;
        
         
    	
    }
}