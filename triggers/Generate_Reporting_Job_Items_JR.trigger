trigger Generate_Reporting_Job_Items_JR on Job_Role__c (before delete, after insert, after update) {
  if(Trigger.IsInsert){
    GenReportingJobItems.genJobRole(Trigger.new);
  }
  
  // For update the same trigger is executed as on insert
  if(Trigger.IsUpdate){
    GenReportingJobItems.genJobRole(Trigger.new);
  }
  
  // Query all Reporting Item Objects containing the Old Job_Item__c KeySet and Delete them to start from scratch once again.
  if(Trigger.IsDelete){
    List<Reporting_Job_Item__c> delReports = [select Id, Job_Item__c, Job_Role__c from Reporting_Job_Item__c where Job_Role__c in :Trigger.oldMap.keySet()];
    delete delReports;
  }
}