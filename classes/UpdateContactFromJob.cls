public class UpdateContactFromJob { 
        String Id;
    String SurveyId;
    String ParticipantId;
    
    public UpdateContactFromJob(ApexPages.StandardController JobController){
    Id=JobController.getId();
    //UpdateContacts();
    }
    
    public PageReference UpdateContacts(){
        
    Id = ApexPages.currentPage().getParameters().get('Id');
    
    
    list<contact> myContacts =[select last_job_id__c, last_job_name__c,last_participant_id__c from Contact where last_job_id__c<> null];
    if(myContacts.size()>0){
            for(Contact aContact: myContacts){
                aContact.last_job_id__c=null;
                aContact.last_job_name__c=null;
                aContact.last_participant_id__c=null;
        
        
          }
       update myContacts;
    }
 
    list<participant__c> Participants=[select Id,Job__c,Job__r.survey__c,Job__r.name,Contact__c from Participant__c where Job__c=:Id order by contact__c desc];

   string contactlist='';
    
     for(Integer i=0;i<=Participants.size()-1;i++)
    {
              contactlist=contactlist+'\''+String.valueOf(Participants[i].contact__c)+'\'';
              if(i<Participants.size()-1 && Participants.size()>1){
                // system.debug('last event');
                    contactlist=contactlist+',';
                
                }
    }

   String myquery='select Id,last_job_id__c,last_survey_id__c,last_participant_id__c,last_job_name__c from contact where Id in ('+contactlist+') order by id desc';

    list<contact> Contacts =database.query (myquery);

    //loop contacts,and popuplate customize fields
    for (integer i=0; i<Participants.size(); i++){
        system.debug('Contact id:'+Contacts[i].Id+' ');
    Contacts[i].last_job_id__c=Id;
    Contacts[i].Last_Survey_Id__c=Participants[i].Job__r.survey__c;
    Contacts[i].last_participant_id__c=Participants[i].id;
    Contacts[i].last_job_name__c=Participants[i].Job__r.name;
    } 
    
    //update contacts
    update Contacts;
    //update last updated time with the job
    Job__c aJob =[select id,Name from Job__c where id=:Id];
    String JobName = aJob.Name;
    //String JobId = aJob.id;
    aJob.Last_Participants_Update_On__c=datetime.now();
    update aJOb;



    
    //return to the job detail page
               //String newPageUrl = '/ui/massmail/MassMailStageManager?setupid=MassMailFilter&ftype=C&wizardRetUrl=%2F003%2Fo';
               String newPageUrl='/ui/list/FilterEditPage?fval1='+ JobName+'&id=00B20000004SX8D&fcf_prefix=id_&retURL=/003/o';
               //hard codes the view ID 00B20000004SX8D, it ONLY works in live server!!!
               //String newPageUrl = 'https://emea.salesforce.com/ui/list/FilterEditPage?fval1='+JobName+'&cancelURL=/'+ JobId +'&fcf_prefix=id_&id=00B20000004SX8D&retURL=/ui/massmail/MassMailStageManager?setupid=MassMailFilter&currentStage%3D0%26ftype%3DC%26setupid%3DMassMailFilter%26visited_0%3D1%26wizardRetUrl%3D%252F003%252Fo';
          PageReference newPage = new PageReference(newPageUrl);
           newPage = new PageReference(newPageUrl);
          newPage.setRedirect(true);
          return newPage;
  
    }



}