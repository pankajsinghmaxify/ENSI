public class SendBriefSheet {
     /*
       Allows user to email a brief sheet to multiple
       "Job Roles" from a related list button controller
     */
     
     public String Id;
     
     // Create a blank list to add selected Job Roles
     public List<Job_Role__c> selectedJR = new List<Job_Role__c>();
    
     // Grab the Job ID from the query string
     // Find which Job Roles were actually selected via the list button controller
     public SendBriefSheet(ApexPages.StandardSetController controller) {
       Id = ApexPages.currentPage().getParameters().get('Id');
       this.selectedJR = (list<Job_Role__c>)controller.getSelected();
     }
        
     // Make list unique list of Job Role ID's and return their corresponding "Contact" records   
     public List<Job_Role__c> getSelectedJR(){
       Set<String> myRoles = new Set<String>();
         for (Job_Role__c thisJobRole:selectedJR){
           if(myRoles.contains(thisJobRole.Id)){continue;}
           else{myRoles.add(thisJobRole.Id);}
         }
       return [select Contact__c, Contact__r.Email from Job_Role__c where Id IN: myRoles];
     }   
    
     // Cancel button controller to return to Job Page.
     public PageReference cancel(){
       PageReference pageRef = new PageReference('/'+Id);
       pageRef.setRedirect(true);
       return pageRef;
     }
    
     // Load the brief sheet page and save it.
     // Then send an email to each Job Role Contact with the brief sheet attached.
     public PageReference getDeliverAsPDF() {       
         // Reference the page, pass in a parameter to force PDF
         PageReference pdf =  Page.briefsheet;
         pdf.getParameters().put('id',Id); 
         pdf.setRedirect(true);
         // Grab it! 
         Blob b = pdf.getContent();
         // Create an email looping through all Job Role Contacts
         for(Job_Role__c thisJR:getSelectedJR()){
         Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
         email.setTemplateId([select Id from EmailTemplate where Name =: 'BriefSheet'].Id);
         String [] toAddress = new String[] {};
         email.setTargetObjectId(thisJR.Contact__c);
         email.setWhatId(Id);
         // Create an email attachment
         Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
         efa.setFileName('BriefSheet.pdf'); // neat - set name of PDF
         efa.setBody(b); //attach the PDF
         email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
         // send it, ignoring any errors (bad!)
         Messaging.SendEmailResult [] r = 
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});   
         }
         PageReference pageRef = new PageReference('/'+Id);
         pageRef.setRedirect(true);
         return pageRef;
     }
}