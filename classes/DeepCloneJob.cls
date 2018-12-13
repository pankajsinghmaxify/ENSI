public class DeepCloneJob {
    
    public String JobID;
    
    public DeepCloneJob(ApexPages.StandardController JobController){
        JobID=JobController.getId();
    }

    public PageReference StartDeepClone(){
    
        List<Job__c> aJob =[select tmp_Total__c, tmp_Total_AUD__c, tmp_GTotal__c, tmp_GTotal_AUD__c, Workshop_Hrs__c, 
        Venue_State__c, Venue_Postcode__c, Venue_Phone__c, Venue_Name__c, Venue_Country__c, Venue_Contact__c, Venue_City__c, 
        Venue_Address__c, Training_Type__c, TrainingDays__c, Total_Job_Value_AUD__c, Total_Job_Item_Hours__c, 
        Total_Job_Item_Days__c, TotalJobItemHours__c, Survey__c, Start_Finish_Time__c, 
        Revised_Old_Job_ID__c, Retainer__c, Retainer_Remaining__c, Retainer_Hrs__c, Retainer_Hrs_Remaining__c, 
        Reconciliation_Flag__c, Recon_Unmatched_PS_FX__c, Recon_Total_PS_AUD__c, Recon_Total_Materials_FX__c, 
        Recon_Total_Materials_AUD__c, Recon_Total_JobValue_FX__c, Recon_Total_JobValue_AUD__c, Proposal_Rejected_Date__c, 
        Proposal_Date__c, Program_Duration__c, Presenters__c, Postponed_Date__c, PFQ_Due_Date__c, OwnerId, 
        Old_Org_ID__c, Old_NAM_ID__c, Old_Job_Org_Name__c, Old_Job_ID__c, Old_CSC_ID__c, Old_CDC_Name__c, NIP_Due_Date__c, 
        NAM_Name__c, Materials_Amount__c, Last_Participants_Update_On__c, LastModifiedDate, LastModifiedById, 
        LastActivityDate, Job_Type__c, Job_Title__c, Job_This_Qtr_AUD_S__c, Job_This_Month_AUD_S__c, 
        Job_This_Fyear_AUD_S__c, Job_This_Cyear_AUD_S__c, Job_QTD_AUD_S__c, Job_Next_Qtr_AUD_S__c, 
        Job_Next_Month_AUD_S__c, Job_Next_Fyear_AUD_S__c, Job_Next_Cyear_AUD_S__c, Job_Name__c, Job_MTD_AUD_S__c,
         Job_Last_Qtr_AUD_S__c, Job_Last_Month_AUD_S__c, Job_Last_Fyear_AUD_S__c, Job_Last_Date__c, Job_Last_Cyear_AUD_S__c, 
         Job_First_Date__c, Job_F_YTD_AUD_S__c, Job_Days__c, Job_Class__c, Job_C_YTD_AUD_S__c, Final_Outcome_Briefing__c, 
         FX_Value__c, FX_Type__c, FX_Total__c, FX_Prof_Serv_Total__c, FX_Materials_Total__c, FX_Conv__c, 
         FXProfServTotal__c, FXMaterialTotal__c, Expenses_Agreed__c, Email_Comments__c, Difference_to_Allocation_FX__c, 
         Comments__c, Client_Address__c, Certificate_Type__c, 
         CSM_Name__c, Breifing_on_Negotiation__c, Billing_X_Rate__c, Billing_Currency__c, Aust_Int__c, 
         Admin_Contact__c, Admin_Contact_Name__c, Admin_Contact_Details__c, Account__c, Account_Sell__c, Account_Description__c, 
         Account_Comments__c, AUD_Prof_Serv_Total__c, AUD_Materials_Total__c, Program_Name__c,  Public_Program_Name__c, Learning_Outcomes__c, 
         Public_Program_Materials__c, Public_Program_Timetable__c, Additional_Comments__c, Case_Studies__c, Welcome_Pack_Template__c, Materials__c
          from Job__c where id=:JobID];
        
        //list<participant__c> Participants=[select Id,Contact__c from Participant__c where Job__c=:JobID];
        List<Job_Item__c> anItemList=[select Work_Start_Date__c, Value_Share_Pcnt__c, Value_Share_FX_Total__c, 
        Value_Share_AUD_Total__c, UOM__c, SysAd_Comments__c, RecordTypeId, Recon_Value_Share_FX__c, 
        Recon_FX_Prof_Fee__c, Recon_Alloc_To_Percentage__c, Recon_AUD_Prof_Fee__c, Quantity__c, Price_FX__c, 
        Price_AUD__c, Presenter__c, Old_Price__c, Old_Job_Role__c, Old_Job_Item_ID__c, Old_Job_ID__c, 
        OLD_Role_Name__c, Notes__c, Last_Year_AUD__c, Job_Item_Service_AUD__c, Job_Item_Revenue_Date__c, 
        Job_Item_Material_AUD__c, Job_Item_Days__c, Job_Class__c, Job_Billing_X_Rate__c, JI_This_Qtr_AUD_S__c, 
        JI_This_Month_AUD_S__c, JI_This_Fyear_AUD_S__c, JI_This_Cyear_AUD_S__c, JI_QTD_AUD_S__c, 
        JI_Next_Qtr_AUD_S__c, JI_Next_Month_AUD_S__c, JI_Next_Fyear_AUD_S__c, JI_Next_Cyear_AUD_S__c, 
        JI_MTD_AUD_S__c, JI_Last_Qtr_AUD_S__c, JI_Last_Month_AUD_S__c, JI_Last_Fyear_AUD_S__c, JI_Last_Cyear_AUD_S__c, 
        JI_F_YTD_AUD_S__c, JI_C_YTD_AUD_S__c, Item_Value_FX__c, Item_Value_AUD__c, ENSProduct__c, Deliverable__c, 
        Current_Year_AUD__c, Current_Month_AUD__c, Amount__c,Job_Role__r.id from Job_Item__c where Job__c=:JobID];
        
        List< Job_Role__c> aRoleList=[select Temp__c, SysAd_Comments__c, Role__c, RecordTypeId, Recon_PS_Fee_FX__c, 
        Prof_Serv_Share__c, Prof_Serv_Share_FX_Total__c, Prof_Serv_Share_AUD__c, Presenter_No__c, Presenter_Fee__c, 
        Presenter_Fee_FX__c, Old_Person_Role_ID__c, Old_Person_Name__c, Old_Person_ID_on_Job_Role__c, Old_Person_ID__c, 
        Old_Job_Person_Role__c, Old_Job_ID_on_Job_Role__c, Old_Job_ID__c, NAM__c, Materials_Share__c, 
        Materials_Share_FX_Total__c, Materials_Share_AUD_Total__c, Job_Number__c, Job_FX_Prof_Serv_Total__c, 
        Job_FX_Materials_Total__c, Job_Days__c, Contact__c, Contact_Email__c, Contact_Account_Name__c, 
        Account_Name__c from  Job_Role__c where Job__c=:JobID];
        
        //create job
        List<Job__c> ClonedJob=aJob.deepClone(false);
        Insert ClonedJob;
        
        //create part
        //List<participant__c> ClonedParticipants=Participants.deepClone(false);
        //for(participant__c aPart:ClonedParticipants){
            //aPart.Job__c=ClonedJob[0].id;
        //}
        //Insert ClonedParticipants;
        
        //create job role
        
        Map <String,String> OldNewRoleList=new Map<String, String> {};
        
        List< Job_Role__c> ClonedRoleList=aRoleList.deepClone(false);
        

                for(Integer i = 0;i < ClonedRoleList.size(); i++){
            ClonedRoleList[i].Job__c=ClonedJob[0].id;
        }
        
        
        Insert ClonedRoleList;
        
        for(Integer i = 0;i < ClonedRoleList.size(); i++){

            OldNewRoleList.put(aRoleList[i].id,ClonedRoleList[i].id);
        }
        
        update ClonedRoleList;
                
        //create job items
        
                    RecordType Materialrt = [Select Id From RecordType Where SobjectType='Job_Item__c' and Name='Material'];
            RecordType Servicert = [Select Id From RecordType Where SobjectType='Job_Item__c' and Name='Service'];


                                   
        List<Job_Item__c> ClonedItemList=anItemList.deepClone(false);

        for(Integer i = 0;i < ClonedItemList.size(); i++){
            ClonedItemList[i].Job__c=ClonedJob[0].id;
            if(anItemList[i].RecordTypeID==Servicert.id){
             
                Job_Role__c aNewRole=[select id from Job_Role__c where id=:OldNewRoleList.get(anItemList[i].Job_Role__r.id)];
               ClonedItemList[i].Job_Role__c=aNewRole.id;
                 ClonedItemList[i].RecordTypeId=Servicert.id;
             }
             //null job roll
            //assign 'Material' recordtype
            else{
                ClonedItemList[i].RecordTypeId=Materialrt.id;
            }
            
        }
        
        Insert ClonedItemList;
        
        
        
            String newPageUrl='/'+ClonedJob[0].id;

        PageReference newPage = new PageReference(newPageUrl);
        newPage = new PageReference(newPageUrl);
          newPage.setRedirect(true);
          return newPage;
        
    }
}