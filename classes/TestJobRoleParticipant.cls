/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestJobRoleParticipant {

    static testMethod void myUnitTest() {
        try {
	      	//build the needed records
	        recordtype[] RT = [Select  r.Id, r.SobjectType, r.Name From RecordType r where sobjecttype ='Job_Role__c' order by r.Name ASC];
	        Account acc = new Account(name='testJobRoleParticipantsTrigger');
	        insert acc;
	        
	        List<Contact> contactList = new List<Contact>();
	        Contact con = new Contact(AccountId = acc.id, FirstName = 'Fname1', LastName = 'Lname1');
	        contactList.add(con);
	        Contact con2 = new Contact(AccountId = acc.id, FirstName = 'Fname2', LastName = 'Lname2');
	        contactList.add(con2);
	        insert contactList;
	        
	        List<ENSProduct__c> productList = new List<ENSProduct__c>();        
	        ENSProduct__c prod1 = new ENSProduct__c(Name = 'test Material 1', Category__c = 'Materials', Type__c = 'Manual: 250 Page');
	        productList.add(prod1);
	        ENSProduct__c prod2 = new ENSProduct__c(Name = 'test Training 1', Category__c = 'Training', Type__c = 'Training Day');
	        productList.add(prod2);
	        insert productList;
	
	        Job__c job = new Job__c(Job_Type__c = 'Standard', Account__c = acc.id, Program_Duration__c = 'test', Venue_Name__c = 'test', Venue_City__c = 'testcity', Venue_Country__c = 'TestCountry');
	        insert job;
	        
	        List<Job_Role__c> jobRoleList = new List<Job_Role__c>();        
	        Job_Role__c role1 = new Job_Role__c(Job__c = job.id, RecordTypeId = RT[0].Id, Role__c = 'ENS', Prof_Serv_Share__c = 10, Materials_Share__c = 10);
	        jobRoleList.add(role1); 
	        Job_Role__c role2 = new Job_Role__c(Job__c = job.id, RecordTypeId = RT[0].Id, Role__c = 'Spot', Contact__c = con.id, Prof_Serv_Share__c = 15, Materials_Share__c = 10);
	        jobRoleList.add(role2); 
	        Job_Role__c role3 = new Job_Role__c(Job__c = job.id, RecordTypeId = RT[0].Id, Role__c = 'Sell', Contact__c = con2.id, Prof_Serv_Share__c = 10, Materials_Share__c = 15);
	        jobRoleList.add(role3);
	        Job_Role__c role4 = new Job_Role__c(Job__c = job.id, RecordTypeId = RT[0].Id, Role__c = 'Sell', Contact__c = con.id, Prof_Serv_Share__c = 10, Materials_Share__c = 10);
	        jobRoleList.add(role4);
	        insert jobRoleList;
	        	 		        
	        //create participants
	        Date myDate = Date.newInstance(2010,12,1);
	        Datetime myDatetime = Datetime.newInstance(2010,12,1,8,30,0);
	        List<Job_Item__c> jobItemList = new List<Job_Item__c>();        
	        Job_Item__c Item1 = new Job_Item__c(Job__c = job.id, Price_FX__c = 200.00, Quantity__c = 5, ENSProduct__c = prod1.id);
	        jobItemList.add(Item1);
	        Job_Item__c Item2 = new Job_Item__c(Job__c = job.id, Job_Role__c = role2.id, Price_FX__c = 5000.00, ENSProduct__c = prod2.id, Work_Start_Date__c = myDate);
	        jobItemList.add(Item2);
	        insert jobItemList;        
	                
	        List<Participant__c> participantList = new List<Participant__c>();        
	        Participant__c p1 = new Participant__c(Job__c = job.id, Contact__c = con.id, Certificate_Status__c = 'Awarded');
	        participantList.add(p1);
	        Participant__c p2 = new Participant__c(Job__c = job.id, Contact__c = con2.id, Certificate_Status__c = 'Pending');
	        participantList.add(p2);
	        Participant__c p3 = new Participant__c(Job__c = job.id, Contact__c = con.id, Certificate_Status__c = 'Awarded');
	        participantList.add(p3);
	        insert participantList;


	 		System.debug('TEST Job --> ' + job.id);
			Job__c updatedJob = [SELECT 
                        Id, 
                        Total_Mkting_PS__c,
                        Total_Mkting_Mat__c,
                        Total_Sell_PS__c,
                        Job_Pax_Awarded__c,
                        No_of_Participants__c
               FROM 
                        Job__c 
               WHERE 
                        Id = :job.Id];
                                                
	        //trigger fires on Job_Role__c so setup feilds in these 3 scenarioes
	 		System.assertEquals(updatedJob.Total_Mkting_PS__c, 35);
	 		System.assertEquals(updatedJob.Total_Mkting_Mat__c, 35);
	 		System.assertEquals(updatedJob.Total_Sell_PS__c, 20);
                        	        
	        //trigger fires on Participant__c so setup Job_Pax_Awarded__c on Job in this scenario
	 		System.assertEquals(updatedJob.Job_Pax_Awarded__c, 2);

	 		System.debug('TEST job.Job_Pax_Awarded__c --> ' + updatedJob.Job_Pax_Awarded__c);
	 		System.debug('TEST No_of_Participants__c --> ' + updatedJob.No_of_Participants__c);	 		
 		}    
    	catch (DmlException e) {
			System.assert(false);
    	}		
    }
}