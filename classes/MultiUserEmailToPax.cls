public class MultiUserEmailToPax { 
    //Sequential 31/1/2013
    //Called from the MultiUserEmailToPax Visualforce page, which is called from the Email to Pax buttons on Job. 
    //There are two buttons: one facilitates emailing all participants; the other excludes those where the certificate is withheld.
    //This distinction is driven through the "statusFilter" URL parameter.
    //
    // SystemLabs (7/4/15)
    // Mods to repair broken URL string at line 85 (newPageUrl)

    String Id;
    
    public MultiUserEmailToPax(ApexPages.StandardController JobController){
        Id = JobController.getId();
    }
    
    public PageReference UpdateContacts(){
        //Get the Job ID and the status filter from the URL.
        Id = ApexPages.currentPage().getParameters().get('Id');
        string statusFilter = ApexPages.currentPage().getParameters().get('statusFilter');
        string exPFQ = ApexPages.currentPage().getParameters().get('exPFQ');
        string exSixWK = ApexPages.currentPage().getParameters().get('exSixWK');
        string exThreeMth = ApexPages.currentPage().getParameters().get('exThreeMth');
        
        //Get the other relevant fields from Job.
        Job__c j = [SELECT Id, Name, Survey__c FROM Job__c WHERE Id = :Id LIMIT 1];
        String theJobName;
        Id theSurveyId;
        If (j != null){            
            theJobName = j.Name;
            theSurveyId = j.Survey__c;
            System.debug('Job details: ID=' + Id + ', statusFilter=' + statusFilter + ', Name=' + theJobName + ', SurveyID=' + theSurveyId); 
        }
        
        //Clear the relevant fields for contacts previously marked as participants for this job.
        List<contact> oldContacts = [SELECT Id FROM Contact WHERE last_job_id__c = :Id];
        If(oldContacts.size()>0){
            for(Contact aContact: oldContacts){
                aContact.Last_job_id__c = null;
                aContact.Last_job_name__c = null;
                aContact.Last_participant_id__c = null;    
            }
           update oldContacts;
        }
        System.debug('Number of old contacts retrieved for this job = ' + oldContacts.size());             
    
        //Create a map of the Contacts IDs and Participant IDs of the Participants.
        Map<Id,Id> ContactPaxMap = new map <Id,Id>();
        Set<Id> theContactIds = new Set<Id>(); //Also create a set to pass into the next SOQL query.
        
            string query = 'SELECT Id, Contact__c, Certificate_Status__c FROM Participant__c WHERE Job__c = \''+Id+'\'';
            
            if(exPFQ == '1') query += ' AND PFQ_Completed__c != true';
            if(exSixWk == '1') query += ' AND X6_week_case_study_Completed__c != true';
            if(exThreeMth == '1') query += ' AND X3_month_case_study_Completed__c != true';
        
        for(Participant__c p : database.query(query)){
            If(p.Certificate_Status__c == 'Withheld' && statusFilter == 'ew'){ //where withhelds are excluded ...
                System.debug('Status is Withheld for = ' + p.Contact__c);
            }Else{
                ContactPaxMap.put((Id)p.get('Contact__c'),(Id)p.get('Id'));
                theContactIds.add(p.Contact__c);
            }
        } 
        System.debug('Number of contacts from pax = ' + ContactPaxMap.size());
        
        //Get the Contacts based on the set of Contact IDs.
        List<Contact> theContacts = [SELECT Id, Last_Job_Id__c, Last_Job_Name__c, Last_Survey_Id__c, Last_Participant_Id__c 
            FROM Contact WHERE Id IN :theContactIds]; 
        
        //Loop through the Contacts and update the relevant fields.
        if (theContacts != null & theContacts.size() > 0 ){
            for(Contact c : theContacts){
                c.Last_Job_Id__c = Id;
                c.Last_Job_Name__c = theJobName;
                c.Last_Survey_Id__c = theSurveyId;
                c.Last_Participant_Id__c = ContactPaxMap.get(c.Id);
            }  
        }       

        //Update the Contact records.
        update theContacts;
        
        //Get the Id of the relevant mass email list for this user from the custom setting.
        try{
            Email_Pax_Mass_Email_List__c EL = Email_Pax_Mass_Email_List__c.getValues(UserInfo.getUserId());
            String theListId = EL.List_View_ID__c;
            System.debug('Mass email list from custom setting = ' + theListId);              
        
            //Set the last updated time on the Job.
            j.Last_Participants_Update_On__c = datetime.now();
            update j;
        
            //Redirect the user to the mass email list view with the filter set to this Job. User then clicks Save
            //and the list and its matching records are displayed (hence the long RetURL).
            String newPageUrl='/ui/list/FilterEditPage?fval1='+ theJobName + '&id=' + theListId + 
                '&fcf_prefix=id_&retURL=%2Fui%2Fmassmail%2FMassMailStageManager%3FcurrentStage%3D0%26mm_type%3DContact%26setupid'+
                '%3DMassMailFilter%26visited_0%3D1%26wizardRetUrl%3D%252F003%252Fo&cancelURL=%2Fui%2Fmassmail%2FMassMailStageManager'+
                '%3FcurrentStage%3D0%26mm_type%3DContact%26setupid%3DMassMailFilter%26visited_0%3D1%26wizardRetUrl%3D%252F003%252Fo';
            
            PageReference newPage = new PageReference(newPageUrl);
            newPage = new PageReference(newPageUrl);
            newPage.setRedirect(true);
            return newPage;  
        
        } catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,   
                                'Some very important message for the user')); 
            PageReference errorPage = new PageReference('/apex/MultiUserEmailToPax_Errors');
            errorPage.setRedirect(true);
            return errorPage;
        }              
    }
}