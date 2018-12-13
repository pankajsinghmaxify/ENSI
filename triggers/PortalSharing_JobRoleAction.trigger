trigger PortalSharing_JobRoleAction on Job_Role__c (After insert, Before delete) {

    if(Trigger.isInsert) {

        //Collect all partner as map
        List <User> PartnerUsersList = [SELECT ContactId, id FROM User WHERE Profile.UserLicense.Name =: 'Partner Community' AND IsActive =: TRUE];
        Map<Id, Id> ContactUserMap = new Map<Id, Id>();
        for(User thisUser : PartnerUsersList){
            ContactUserMap.put(thisUser.ContactId, thisUser.Id);
        }
        
        //Initialised Insertlists
        List<job__share> JobShareInsertList = new List<job__share>();
        List<AccountShare> AccountShareInsertList = new List<AccountShare>();

        for(Job_Role__c thisJobRole : trigger.new) {    
            if (thisJobRole.Role__c == 'Sell' && ContactUserMap.containsKey(thisJobRole.contact__c)) {
                
                //add new jobshare
                job__share newJobShare     = new job__share();
                newJobShare.ParentId       = thisJobRole.Job__c;
                newJobShare.UserOrGroupId  = ContactUserMap.get(thisJobRole.contact__c);
                newJobShare.AccessLevel    = 'Read';
            
                JobShareInsertList.add(newJobShare);
                
                //add new accountshare
                AccountShare newAccountShare            = new AccountShare();
                newAccountShare.UserOrGroupId           = ContactUserMap.get(thisJobRole.contact__c);
                newAccountShare.AccountId               = thisJobRole.Job_Account_Id__c;
                newAccountShare.AccountAccessLevel      = 'Edit';
                newAccountShare.OpportunityAccessLevel  = 'None';
                newAccountShare.CaseAccessLevel         = 'None';

                AccountShareInsertList.add(newAccountshare);
            }
        }
        //execute dml
        insert JobShareInsertList;
        insert AccountShareInsertList;
    }

    if(Trigger.isDelete) {
        
        //Initialise Delete list
        List<job__share> JobShareDeleteList = new List<job__share>();
        List<AccountShare> AccountShareDeleteList = new List<AccountShare>();

        //Collect all partner as map
        List <User> PartnerUsersList = [SELECT id, ContactId FROM User WHERE Profile.UserLicense.Name =: 'Partner Community' AND IsActive =: TRUE];
        Map<Id, Id> UserContactMap = new Map<Id, Id>();
        for(User thisUser : PartnerUsersList){
            UserContactMap.put(thisUser.Id, thisUser.ContactId);
        }

        //Collect all Job Id as Set
        Set<Id> JobIdSet = new Set<Id>();
        for(Job_Role__c thisJobRole : trigger.old) {
            JobIdSet.add(thisJobRole.job__c);
        }
        //Collect all Account Id as Set
        Set<Id> AccountIdSet = new Set<Id>();
        for(Job_Role__c thisJobRole : trigger.old) {
            AccountIdSet.add(thisJobRole.Job_Account_Id__c);
        }

        //Populate JobShareList & JobShareMap
        List <job__share> jobShareList = [SELECT id, UserOrGroupId, ParentId FROM job__share WHERE ParentId IN: JobIdSet];
        Map<String, job__share> JobShareMap = new Map<String, job__share>();
        for(Job__Share thisJobShare : jobShareList) {
            JobShareMap.put(thisJobShare.ParentId + '|' + UserContactMap.get(thisJobShare.UserOrGroupId), thisJobShare);
        }

        //Populate AccountShareList & AccountShareMap
        List <AccountShare> AccountShareList = [SELECT id, UserOrGroupId, AccountId FROM AccountShare WHERE AccountId IN: AccountIdSet];
        Map<String, AccountShare> AccountShareMap = new Map<String, AccountShare>();
        for(AccountShare thisAccountShare : AccountShareList) {
            AccountShareMap.put(thisAccountShare.AccountId + '|' + UserContactMap.get(thisAccountShare.UserOrGroupId), thisAccountShare);
        }

        //Populate DeleteLists
        for(Job_Role__c thisJobRole : Trigger.old){
            if (thisJobRole.Role__c == 'Sell'){

                String strJobShareUniqueKey = thisJobRole.Job__c + '|' + thisJobRole.Contact__c;
                String strAccountShareUniqueKey = thisJobRole.Job_Account_Id__c + '|' + thisJobRole.Contact__c; //thisJobRole.Job_Account_Id__c

                If(JobShareMap.containsKey(strJobShareUniqueKey)) {
                    JobShareDeleteList.add(JobShareMap.get(strJobShareUniqueKey));
                }

                If(AccountShareMap.containsKey(strAccountShareUniqueKey)) {
                    AccountShareDeleteList.add(AccountShareMap.get(strAccountShareUniqueKey));
                }
            }
        }
        //execute dml
        delete JobShareDeleteList;
        delete AccountShareDeleteList;
    }

}