public class TestJobActivityRelatedList {
    static testMethod void TestJobActivityRelatedList(){
        PageReference pageRef = new PageReference('Page.JobActivityRelatedList');
            test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('ID', 'a0620000009YFrk');
        //ApexPages.currentPage().getParameters().put('Id', 'a06R0000004GUXW');
        
        Job__c aj= [select id from Job__c where id='a0620000009YFrk'];
        ApexPages.StandardController ctrl = new ApexPages.StandardController(aj);
        JobActivityRelatedList aGen = new JobActivityRelatedList(ctrl);
        //aGen.ID='a0620000009YFrk';
        aGen.getAllTasks();
        aGen.ShowTasks();
    }
}