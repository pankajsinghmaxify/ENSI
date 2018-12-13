public class LicenseeActivityReport {
    public List<Reporting_Job_Item__c> Report;
    public List<Job_Role__c> Jobs;
    public integer Proposed = 0;
    public integer Postponed = 0;
    public integer Confirmed = 0;
    
    public Processed_Report__c PR2;
    
    private final Processed_Report__c PR;

    public LicenseeActivityReport(ApexPages.StandardController stdController) {
      // Get Processed Report Record In Question (for a custom object SF.com will only pass an ID)
      this.PR = (Processed_Report__c)stdController.getRecord();   
      // Get Fields of processed report record in question   
      PR2 = [select Contact__c, From_Date__c, To_Date__c FROM Processed_Report__c where Id =: PR.Id];
      
      String ID15digit = String.ValueOf(PR2.Contact__c).SubString(0,15);
      Report = [select Job_Item__r.Work_Start_Date__c, Job_Role__r.Account_Name__c, Job_Role__r.Job__r.Name, Role__c, Job_Role_Prof_Services_Pct__c, FX_Share_Amount__c from Reporting_Job_Item__c WHERE Job_Role_Contact_ID__c =: ID15digit and Job_Item__r.Work_Start_Date__c >=: PR2.From_Date__c and Job_Item__r.Work_Start_Date__c <=: PR2.To_Date__c];
      Jobs = [select job__r.status_new1__c, Contact__r.FirstName, Contact__r.LastName from Job_Role__c where Contact__c =: PR2.Contact__c];
    }    
    
    public String getContact(){
      return Jobs[0].Contact__r.FirstName + ' ' + Jobs[0].Contact__r.LastName;
    }
    
    public List<Reporting_Job_Item__c> getReport(){
      return Report;
    }
    
    public Integer getProposed(){    
      for(Job_Role__c thisJob:Jobs){
        if(thisJob.job__r.status_new1__c == 'Proposed'){Proposed++;}
      }
      return Proposed;
    }
    
    public Integer getPostponed(){
      for(Job_Role__c thisJob:Jobs){
        if(thisJob.job__r.status_new1__c == 'Postponed'){Postponed++;}
      }
      return Postponed;
    }
    
    public Integer getConfirmed(){
      for(Job_Role__c thisJob:Jobs){
        if(thisJob.job__r.status_new1__c == 'Confirmed'){Confirmed++;}
      }
      return Confirmed;
    }
    
}