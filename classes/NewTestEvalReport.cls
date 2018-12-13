public class NewTestEvalReport {
static testMethod void myUnitTest() {
        Job__c aJob =[select id, Name, Comments__c from Job__c limit 1];
        ApexPages.StandardController stdController = new ApexPages.StandardController(aJob);
        EvalReport controller = new EvalReport(stdController);
        controller.Answers();
        Integer i = controller.getParticipants();
        List<Section> l = controller.getSections();
        
    }

        
    

}