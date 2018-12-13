public class NewTestTriggers {

    static testMethod void myUnitTest() {
        
        // Job Action
        Job__c aJobAction =[select id, Name, Comments__c from Job__c limit 1];
        aJobAction.Comments__c = 'test';
        update aJobAction;
        delete aJobAction;
        
        
    }
}