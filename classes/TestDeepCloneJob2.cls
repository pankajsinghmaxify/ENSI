@isTest(seealldata=true)
public class TestDeepCloneJob2 {
    static testMethod void TestDeepCloneJob(){
        PageReference pageRef = new PageReference('Page.DeepCloneJob');
            test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('ID', 'a0620000009YFrk');
        //ApexPages.currentPage().getParameters().put('Id', 'a06R0000004GUXW');
        
        Job__c aj= [select id from Job__c where id='a0620000009YFrk'];
        ApexPages.StandardController ctrl = new ApexPages.StandardController(aj);
        DeepCloneJob aGen = new DeepCloneJob(ctrl);
        aGen.JobID='a0620000009YFrk';
        aGen.StartDeepClone();
    }
}