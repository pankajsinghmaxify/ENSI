public class TestUpdateContactFromJob {
   
    static testMethod void TestUpdateContactFromJob(){
        
        Job__c j = new Job__c();
        insert j;
        
        PageReference pageRef = new PageReference('Page.UpdateContactsFromJob');
            test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('ID', j.Id);
        //ApexPages.currentPage().getParameters().put('ID', 'a0620000009YFrk');
        //ApexPages.currentPage().getParameters().put('Id', 'a06R0000004GUXW');
        
        //Job__c aj= [select id from Job__c where id='a0620000009YFrk'];
        ApexPages.StandardController ctrl = new ApexPages.StandardController(j);
        UpdateContactFromJob aGen = new UpdateContactFromJob(ctrl);
        //aGen.UpdateContacts();
    }
}