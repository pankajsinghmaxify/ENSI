@isTest
public class testEmailToXXX {
    
    public static string jobId {get;}
    public static Job__c job {get;}
    
    public static void initData(){
        
        //insert account
        Account a = new Account(Name = 'Test Account');
        insert a;
        system.debug('Account Inserted');

        //insert contacts
        //(participant; spot; sell; presenter; NAM; Admin)
        Contact c = new Contact(LastName = 'TESTER', Email='test@test.com', AccountId = a.id);
        insert c;
        system.debug('Contact Inserted');
        
        //insert job
        Job__c j = new Job__c(Account__c = a.id, NAM_Name__c = c.id, Admin_Contact__c = c.Id);
        insert j;
        system.debug('Job Inserted');
        
        job = j;
        jobId = j.id;
        system.debug('Job ID: '+ j.id);
        
        c.Last_Job_ID__c = j.id;
        update c;
        
        //insert participants
    Participant__c p = new Participant__c(Job__c = j.id, Contact__c = c.id);
    insert p;        
        system.debug('Participant Inserted');

        //insert job roles
        Job_Role__c spot = new Job_Role__c(Job__c = j.id, Contact__c = c.id, Role__c = 'Spot', Prof_Serv_Share__c = 5, Materials_Share__c = 5);
        Job_Role__c sell = new Job_Role__c(Job__c = j.id, Contact__c = c.id, Role__c = 'Sell', Prof_Serv_Share__c = 5, Materials_Share__c = 5);
        Job_Role__c pres = new Job_Role__c(Job__c = j.id, Contact__c = c.id, Role__c = 'Presenter', Prof_Serv_Share__c = 5, Materials_Share__c = 5);
        
        insert spot;
        insert sell;
        insert pres;
        system.debug('Job Roles Inserted');

    }

    public static testmethod void testEmailToPax(){
        
        initData();
        
        PageReference paxPageRef = new PageReference('Page.MultiUserEmailToPax');
        
        test.setCurrentPage(paxPageRef); 
        ApexPages.currentPage().getParameters().put('Id', jobId);
        
        ApexPages.StandardController ctrl = new ApexPages.StandardController(job);
        
        MultiUserEmailToPax aGen = new MultiUserEmailToPax(ctrl);
        
        system.runAs([select Id from User where Profile.Name = 'System Administrator' AND isActive = true][0]){
          aGen.UpdateContacts();
        }
    }
    
    public static testmethod void testEmailToPresenter(){
        
        initData();
        
        PageReference paxPageRef = new PageReference('Page.EmailToPresenter');
        
        test.setCurrentPage(paxPageRef); 
        ApexPages.currentPage().getParameters().put('Id', jobId);
        
        ApexPages.StandardController ctrl = new ApexPages.StandardController(job);
        
        EmailToPresenter aGen = new EmailToPresenter(ctrl);
        
        system.runAs([select Id from User where Profile.Name = 'System Administrator' AND isActive = true][0]){
          aGen.UpdateContacts();
        }
        
    }
    
    public static testmethod void testEmailToPresenterSpotSell(){
        
        initData();
        
        PageReference paxPageRef = new PageReference('Page.EmailToPresenterSpotSell');
        
        test.setCurrentPage(paxPageRef); 
        ApexPages.currentPage().getParameters().put('Id', jobId);
        
        ApexPages.StandardController ctrl = new ApexPages.StandardController(job);
        
        EmailToPresenterSpotSell aGen = new EmailToPresenterSpotSell(ctrl);
        
        system.runAs([select Id from User where Profile.Name = 'System Administrator' AND isActive = true][0]){
          aGen.UpdateContacts();
        }
    }
    
    public static testmethod void testEmailToNAMAndAdmin(){
        
        initData();
        
        PageReference paxPageRef = new PageReference('Page.EmailToNAMAndAdminPage');
        
        test.setCurrentPage(paxPageRef); 
        ApexPages.currentPage().getParameters().put('Id', jobId);
        
        ApexPages.StandardController ctrl = new ApexPages.StandardController(job);
        
        EmailToNAMAndAdmin aGen = new EmailToNAMAndAdmin(ctrl);
        
        system.runAs([select Id from User where Profile.Name = 'System Administrator' AND isActive = true][0]){
          aGen.UpdateContacts();
        }
        
    }
    
}