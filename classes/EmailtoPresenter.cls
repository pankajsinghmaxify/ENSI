public class EmailtoPresenter {
    // DK 11 Feb 2015
    // Called from the Emailtopresenter Visualforce page, which is called from the Email to Pax buttons on Job. 
    // Button on job Email to Presenter
    // coding includes participants and presenter
    // 
    // SystemLabs (7/4/15)
    // Mods to only retrieve and update the Contact with Job Role of Presenter
    // Also created new Mass Email List View. Created new Custom Setting field to
    // hold List View Id. This is used in the final URL string at line 61 (newPageUrl)
    
    String Id;
    
    public EmailtoPresenter(ApexPages.StandardController JobController){
        Id = JobController.getId();
    }
    
    public PageReference UpdateContacts(){
        //Get the Job ID and the status filter from the URL.
        Id = ApexPages.currentPage().getParameters().get('Id');
        string statusFilter = ApexPages.currentPage().getParameters().get('statusFilter');
        
        //Get the other relevant fields from Job.
        Job__c j = [SELECT Id, Name, Survey__c FROM Job__c WHERE Id = :Id LIMIT 1];
        String theJobName;
        Id theSurveyId;
        If (j != null){            
            theJobName = j.Name;
            theSurveyId = j.Survey__c;
            System.debug('Job details: ID=' + Id + ', statusFilter=' + statusFilter + ', Name=' + theJobName + ', SurveyID=' + theSurveyId); 
        }
        
        // Create a map of the Contacts IDs and Participant IDs of the Participants.
        // DK added to include presenter where job role is presenter
        // SystemLabs (7/4/15) - Only get the Job Role where Role equals Presenter
        
        Job_Role__c presenter = [SELECT Id, Contact__c, Role__c FROM Job_Role__c WHERE Job__c = :Id AND Role__c = 'Presenter'][0];
        
        // Get the Contacts based on the set of Contact IDs.
        // SystemLabs (7/4/15) - Get the Presenter Contact
        Contact c = [SELECT Id, Last_Job_Id__c, Last_Job_Name__c, Last_Survey_Id__c, Last_Participant_Id__c 
                     FROM Contact 
                     WHERE Id = :presenter.Contact__c]; 
     
        // SystemLabs (7/4/15) - Set the presenter Contact values
                c.Last_Job_Id__c = Id;
                c.Last_Job_Name__c = theJobName;
                c.Last_Survey_Id__c = theSurveyId;
        		c.Last_Job_Role_Id__c = presenter.id;
        
        //Update the Contact record.
        update c;
        
        //Get the Id of the relevant mass email list for this user from the custom setting.
        try{
            Email_Pax_Mass_Email_List__c EL = Email_Pax_Mass_Email_List__c.getValues(UserInfo.getUserId());
            String theListId = EL.Presenter_List_View_ID__c;
            System.debug('Mass email list from custom setting = ' + theListId);              
            
            //Redirect the user to the mass email list view with the filter set to this Job. User then clicks Save
            //and the list and its matching records are displayed (hence the long RetURL).
            String newPageUrl='/ui/list/FilterEditPage?fval1='+  string.valueOf(c.Id).left(15) +'&id=' + theListId +
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