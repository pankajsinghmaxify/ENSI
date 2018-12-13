public class SendActivityReport {
     /*
       Allows user to email a Licensee Activity Report to multiple
       Licensees through a custom link
     */     
     public Report_Batch__c newRB = new Report_Batch__c();
     public String Year;
     public String Month;
          
     public Report_Batch__c getNewRB(){
       return newRB;
     }
     
     // List of all licensees
     public List<Job_Role__c> JR = new List<Job_Role__c>();
     
     public List<Job_Role__c> getJR(){
        return [select Contact__c from Job_Role__c where Contact__r.RecordType.Name = 'Licencee'];
     }
     public Set<String> CIDS(){
        // Create a Unique Set of ContactIDs
        Set<String> myContacts = new Set<String>();
        for (Job_Role__c thisContact:getJR()){
          if(myContacts.contains(thisContact.Contact__c)){continue;}
          else{myContacts.add(thisContact.Contact__c);}
        }
        return myContacts;
     }
     
     public PageReference save(){
        insert NewRB;
        Month = NewRB.Period__c.substring(0,NewRB.Period__c.indexOf('.'));
        system.debug(Month);
        Year = String.ValueOf(NewRB.Year__c);
        system.debug(Year);
        for(String thisContact:CIDS()){
          getDeliverAsPDF(thisContact.substring(0,15));
        }
        PageReference pageRef = new PageReference('/'+NewRB.Id);
        pageRef.setRedirect(true);
        return pageRef;
     }
     
    
     // Load the brief sheet page and save it.
     // Then send an email to each Job Role Contact with the brief sheet attached.
     public void getDeliverAsPDF(String thisContact) {
         system.debug(thisContact);
         PageReference pdf = Page.licenseeAct;
         pdf.getParameters().put('id', thisContact);
         pdf.getParameters().put('month', Month);
         system.debug(Month);
         pdf.getParameters().put('year', Year);
         system.debug(Year);
         pdf.getParameters().put('pdf', 'y');
         pdf.setRedirect(true);
         
         PageReference html = Page.licenseeAct;
         html.getParameters().put('id', thisContact);
         html.getParameters().put('month', Month);
         system.debug(Month);
         html.getParameters().put('year', Year);
         system.debug(Year);
         html.setRedirect(true);
         
         // Grab it!
         String html_content = html.getContent().toString();
         Blob b = pdf.getContent();
         // Create an email looping through all Job Role Contacts
         Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
         email.setHTMLbody(html_content);
         email.setSubject('ActivityReport');
         String [] toAddress = new String[] {};
         email.setTargetObjectId(thisContact);
         // Create an email attachment
         Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
         efa.setFileName('ActivityReport.pdf'); // neat - set name of PDF
         efa.setBody(b); //attach the PDF
         email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
         // send it, ignoring any errors (bad!)
         Messaging.SendEmailResult [] r = 
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});   
     }
}