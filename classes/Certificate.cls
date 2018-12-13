public class Certificate {
//GE 7/2/2013
//Controller for the Certificate Visualforce page that is fired from the View Certificates button on job.
//Builds a one-page certificate for each participant on the job, all rendered in one PDF that ENS prints on headed paper.
//It relies on Certificate Type object (a lookup from Job), which stores pro-forma text to print on the certficates. Pseudo-merge fields
//are included in the paragraph text area fields on Certificate Type, which are then captured in the controller and replaced with values from Job fields.
//If new merge fields need to be included in future, we need to update the Job query to retrieve the fields and update getCtext() to substitute the
//pseudo merge field for the actual field's value.

   String Id = ApexPages.currentPage().getParameters().get('id');
   // Get the job that we are creating certificates for
   public Job__c job = [select Account__r.Name, Program_Duration__c, Venue_Name__c, Certificate_Date_Text__c, Certificate_type__c, Accreditation_Date__c from Job__c where id =:ApexPages.currentPage().getParameters().get('id')];
   // an empty list to hold all of the participants related to a job
   public List<Participant__c> participants = new List<Participant__c>();
   // list of presenters signature id's
   public List<Document> Sigs;
      
   // initialise a certificate type object
   public Certificate_Type__c cert;
   
   // Get variables for text on the Certificate from the Certificate Type object
   public Certificate_Type__c getCtext(){
    cert = [select First_Para_Text__c, Stream__c, Second_Para_Text__c, Program_Title__c, Third_Para_Text__c from Certificate_Type__c where Id =:job.Certificate_Type__c];
    if(job.Program_Duration__c !=null){
        cert.Second_Para_Text__c = cert.Second_Para_Text__c.Replace('{!Job__c.Program_Duration__c}', job.Program_Duration__c);
        cert.Third_Para_Text__c = cert.Third_Para_Text__c.Replace('{!Job__c.Program_Duration__c}', job.Program_Duration__c);
    }
    if(job.Venue_Name__c !=null){
        cert.Second_Para_Text__c = cert.Second_Para_Text__c.Replace('{!Job__c.Venue_Name__c}', job.Venue_Name__c);
        cert.Third_Para_Text__c = cert.Third_Para_Text__c.Replace('{!Job__c.Venue_Name__c}', job.Venue_Name__c);
    }
    if(job.Account__r.Name !=null){
        cert.Second_Para_Text__c = cert.Second_Para_Text__c.Replace('{!Job__c.Account__c}', job.Account__r.Name);  
        cert.Third_Para_Text__c = cert.Third_Para_Text__c.Replace('{!Job__c.Account__c}', job.Account__r.Name);
    }  
    if(job.Certificate_Date_Text__c !=null){
        cert.Second_Para_Text__c = cert.Second_Para_Text__c.Replace('{!Job__c.Certficate_Date_Text__c}', job.Certificate_Date_Text__c); 
        cert.Third_Para_Text__c = cert.Third_Para_Text__c.Replace('{!Job__c.Certficate_Date_Text__c}', job.Certificate_Date_Text__c);
    }   
    if(job.Accreditation_Date__c !=null){
        cert.Second_Para_Text__c = cert.Second_Para_Text__c.Replace('{!Job__c.Accreditation_Date__c}', job.Accreditation_Date__c); 
        cert.Third_Para_Text__c = cert.Third_Para_Text__c.Replace('{!Job__c.Accreditation_Date__c}', job.Accreditation_Date__c); 
    }          
    return cert;
   }
   
   // return the job to display job fields on the certificate
   public Job__c getJob(){
    return job;
   }
   
   // return the participants list to loop through and create a certificate for each participant
   public List<Participant__c> getParticipants(){
     participants = [select Contact__r.FirstName, Contact__r.LastName, tmp_Counter__c from Participant__c where Job__c =:job.Id];
     participants[participants.size()-1].tmp_Counter__c = 'last';
     getSigs();
     return participants;
   }
   
   // returns the signature images (stored as documents) for each presenter on the job. Document images are stored with their name
   // set to be the same as the ID of the presenter's contact record.
   public List<Document> getSigs(){
     List<Job_Role__c> Pres = [select Role__c, Contact__c, Contact__r.FirstName, Contact__r.LastName from Job_Role__c where Job__c =: Id and Role__c = 'Presenter'];
     Set<String> myContacts = new Set<String>();
     for (Job_Role__c thisJobRole:Pres){
       if(myContacts.contains(String.ValueOf(thisJobRole.Contact__c).substring(0,15))){continue;}
       else{myContacts.add(String.ValueOf(thisJobRole.Contact__c).substring(0,15));}
     }
     sigs = [select Id, Description from Document where Name IN: myContacts];
     system.debug(sigs.size());
     return sigs;
   }
}