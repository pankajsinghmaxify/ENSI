public class JobExt {
    /*
      Brief Sheet Extender Class, displays brief sheet fields
      in a PDF page
    */

    // Initialise variables
    String Id;
    public Decimal Total = 0.00;
    public Decimal Total_AUD = 0.00;
    public Decimal GTotal = 0.00;
    public Decimal GTotal_AUD = 0.00;
    Public Decimal Materials_Total=0.00;
    Public String Materials_Total_AUD;
    
    // Grab ID from query string and store
    public JobExt(ApexPages.StandardController controller) {
      Id = ApexPages.currentPage().getParameters().get('Id');
    }
    
    public Decimal getMaterials_Total(){
      return Materials_Total;
    }
    
   public String getMaterials_Total_AUD(){
      return Materials_Total_AUD;
    }
    
    // Return all Job Roles pertaining to this Job
    public List<Job_Role__c> getJR(){
      return [select Role__c, Contact__r.FirstName, Prof_Serv_Share__c, Contact__r.LastName,Job_FX_Prof_Serv_Total__c, Prof_Serv_Share_FX_Total__c, Materials_Share__c,Materials_Share_FX_Total__c, Materials_Share_AUD_Total__c, Prof_Serv_Share_AUD__c, Job_FX_Materials_Total__c from Job_Role__c where Job__c =:Id];
    }
    
    // Return all Job Items pertaining to this Job
    public List<Job_Item__c> getJI(){
      return [select Work_Start_Date__c, Quantity__c, ENSProduct__r.Name, Price_FX__c, RecordType.Name, Item_Value_FX__c, Item_Value_AUD__c from Job_Item__c where RecordType.Name = 'Material' and Job__c =:Id];
    }
    
    // Return list of participants
    //public Integer getParticipants(){
      //return [select count() from Participant__c where Job__c =: Id];
    //}
    
    // Calculate temporary Totals to use for Brief sheet display
    // this is done on tmp fields on the Job to display currency formatting correctly
    public PageReference Totals(){
    	Decimal MTAUD=0.00;
      for(Job_Role__c thisJR:getJR()){
        Total += thisJR.Prof_Serv_Share_FX_Total__c;
        Total_AUD += thisJR.Prof_Serv_Share_AUD__c;
        Materials_Total+=thisJR.Materials_Share_FX_Total__c;
        MTAUD+=thisJR.Materials_Share_AUD_Total__c;
      }
      Materials_Total_AUD ='$'+string.valueOf(MTAUD);
      for(Job_Item__c thisJI:getJI()){
        GTotal += thisJI.Item_Value_FX__c;
        GTotal_AUD += thisJI.Item_Value_AUD__c;
      }
      Job__c thisJob = new Job__c(Id = Id, tmp_Total__c = Total, tmp_Total_AUD__c = Total_AUD, tmp_GTotal__c = GTotal, tmp_GTotal_AUD__c = GTotal_AUD);
      update thisJob;
      return null; 
    }
}