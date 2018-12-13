public class TestCertificate {
    public static testMethod void testCertificate() {
      PageReference pageRef = new PageReference('Page.certificate');
      Test.setCurrentPage(pageRef);
      
      //build the needed objects
        recordtype[] RT = [Select  r.Id, r.SobjectType, r.Name From RecordType r where sobjecttype ='Job_Role__c' order by r.Name ASC];
        Account acc = new Account(name='testCertificate');
        insert acc;
        Contact con = new Contact(AccountId = acc.id, FirstName = 'Fname1', LastName = 'Lname1');
        insert con;
        Contact con2 = new Contact(AccountId = acc.id, FirstName = 'Fname2', LastName = 'Lname2');
        insert con2;
        ENSProduct__c prod1 = new ENSProduct__c(Name = 'test Material 1', Category__c = 'Materials', Type__c = 'Manual: 250 Page');
        insert prod1;
        ENSProduct__c prod2 = new ENSProduct__c(Name = 'test Training 1', Category__c = 'Training', Type__c = 'Training Day');
        insert prod2;
        Date myDate = Date.newInstance(2008,6,1);
        Datetime myDatetime = Datetime.newInstance(2008,6,10,8,30,0);
        Certificate_Type__c c1 = new Certificate_Type__c(First_Para_Text__c = 'test', Second_Para_Text__c = 'test', Third_Para_Text__c = 'test');
        insert c1;
        Job__c job = new Job__c(Job_Type__c = 'Standard', Account__c = acc.id, Certificate_Type__c = c1.id, Program_Duration__c = 'test', Certificate_Date_Text__c = 'test', Venue_Name__c = 'test', Venue_City__c = 'testcity', Venue_Country__c = 'Test', Proposal_Date__c = date.today());
        insert job;
        
        Job_Role__c role1 = new Job_Role__c(Job__c = job.id, RecordTypeId = RT[0].Id, Role__c = 'ENS', Prof_Serv_Share__c = 10, Materials_Share__c = 10);
        insert role1; 
        Job_Role__c role2 = new Job_Role__c(Job__c = job.id, RecordTypeId = RT[1].Id, Role__c = 'Presenter', Contact__c = con.id);
        insert role2; 
        Job_Role__c role3 = new Job_Role__c(Job__c = job.id, RecordTypeId = RT[1].Id, Role__c = 'Presenter', Contact__c = con2.id);
        insert role3;
        
        //create
        Job_Item__c Item1 = new Job_Item__c(Job__c = job.id, Price_FX__c = 200.00, Quantity__c = 5, ENSProduct__c = prod1.id);
        insert Item1;
        Job_Item__c Item2 = new Job_Item__c(Job__c = job.id, Job_Role__c = role2.id, Price_FX__c = 5000.00, ENSProduct__c = prod2.id, Work_Start_Date__c = myDate);
        insert Item2;
        Participant__c p1 = new Participant__c(Job__c = job.id, Contact__c = con.id);
        insert p1;
        
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('Id', Job.Id);
        Certificate controller = new Certificate();
        controller.getCtext();
        controller.getParticipants();
        controller.getJob();
    }
}