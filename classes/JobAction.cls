public class JobAction {
    /*
    Retrieves all the Job Items for a given Job and updates the Job with summed values.
    
    Called by triggers on Job Item.
    
    */
    
    //set up a flag for firing account trigger
    public static boolean IsUpdateAccountNeeded = true;
    //hold up all job itmes from Job item triggers(new)
    public static Job_Item__c[] JobItems;
    public static boolean IsUpdateJobRoleNeeded = true;
    
    public static void UpdateNoOfParticipantsOfJobs(Participant__c[] Participants) {
        JobAction.IsUpdateAccountNeeded=false;
         Set<String> myJobs = new Set<String>();
        for (Participant__c thisParticipant:Participants){
            if(myJobs.contains(thisparticipant.Job__c)||thisparticipant.Job__c==null){continue;}
            else{
            myJobs.add(thisparticipant.Job__c);
            }
        }//for ends
        if(myJobs.size()==0){}
        else{
             List<Participant__c> myPrticipantList=[select job__C,Id,Certificate_Status__c from participant__C where Job__c in: myJobs];
         system.debug('paricipant list size: '+myPrticipantList.size());
             Integer counter=0;
             // New counter of awarded paticipants
             Integer awardedCounter = 0;
             List<Job__c> myJobsList = new List<Job__c>();
             for(String aJob:myJobs){
                    for(Participant__c thisParticipant:myPrticipantList){
                         if(thisparticipant.Job__c==aJob){
                          counter=counter+1;
                          //system.debug('counter+1');
                          // Increment where the participant's certificate status is Awarded
                          if (thisparticipant.Certificate_Status__c != null && thisparticipant.Certificate_Status__c == 'Awarded') {
                            awardedCounter = awardedCounter + 1;    
                          }
                         }
                    }//inner loop ends
                   system.debug('job: '+ajob+' || counter: '+counter+' || Awarded: '+awardedCounter);
                   // Update both No_of_Participants__c and Job_Pax_Awarded__c fields of Job object
                    Job__c JobToUpdate = new job__c(No_of_Participants__c=counter, Job_Pax_Awarded__c=awardedCounter, id=ajob);
                    myJobsList.add(JobToUpdate);
                     counter=0;
                     awardedCounter = 0;
             }//out loop ends
             
                update myJobsList;         
        }//else ends
    }
    
 public static void updateJobRolesFromJobItems(Job_Item__c[] newJobItems) {
        //assign newjobitems to JobItems
        JobItems=newJobItems.deepclone();
        IsUpdateJobRoleNeeded=false;
        // Create a Unique Set of Job Role IDs for all Job Items in List
        //system.debug('starts updateJobRolesFromJobItems');
        Set<String> myJobRoles = new Set<String>();
        for (Job_Item__c thisJobItem:newJobItems){
          //if the Job Role is already in the set, or if the Job Role for this Job Item is null (i.e. if the Job Item is a material), then don't add to the set.
          
          if(myJobRoles.contains(thisJobItem.Job_Role__c)||thisJobItem.Job_Role__c==null){continue;}
          else{
            //system.debug('Add Job Role ID = ' + thisJobItem.Job_Role__c);
            myJobRoles.add(thisJobItem.Job_Role__c);
            }
        }
        //system.debug('myJobRoles = ' + myJobRoles.size());
        if(myJobRoles.size() == 0){
            //If there are no Job Roles in the set, then log this and end here.
            //system.debug('There were no Job Roles to update.');
            updateJobFromJobItems(newJobItems);
            }
        else{
                            
            // List of Job Roles to Update
            List<Job_Role__c> myJobRolesList = new List<Job_Role__c>();
                    
            // List of all Job Items related to the set of unique Job Roles.
            //system.debug('select job items query from updateJobRolesFromJobItems');
            List<Job_Item__c> allJobItems = [SELECT Id,Value_Share_FX_Total__c, Job_Role__c, Job__c,RecordType.Name FROM Job_Item__c WHERE Job_Role__c IN :myJobRoles  limit 1000];
           
            //system.debug('Quantity of job items :'+ allJobItems.Size());
            // for each unique Job Role
            for (String thisJobRole:myJobRoles ) {
                    // initialise variables
                    //system.debug('thisJobRole = ' + thisJobRole);
                    //decimal sumMaterial = 0.0;
                    decimal sumService = 0.0;
                    // decimal sumGSTAmount = 0.0;
                    // decimal sumManDays = 0.0;
                    decimal count = 0.0;
     
                    // loop through all the Job Items 
                    for (Job_Item__c cJobItem:allJobItems ) {
                   
                                             
                                          // if it belongs to the Job Role in question
                                          if(cJobItem.Job_Role__c == thisJobRole){
                                            // add the Job Item's amounts to variables
                                            count+=1;
                         
                                            if(cJobItem.Value_Share_FX_Total__c != null){
                                                sumService += cJobItem.Value_Share_FX_Total__c;
                                            }
                                          }
                    }//for end
                    // update the amounts for this Job Role (new Job Role for update)
                                        
                   Job_Role__c jobRoleToUpdate = new Job_Role__c(Id = thisJobRole, Presenter_Fee__c = sumService);
                   // add this Job Role to the array of Job Roles to be updated
                                        
                    myJobRolesList.add(jobRoleToUpdate);
                   //system.debug('Writing ' +Count+ ' Job Items with services worth ' + sumService + ' to Job Role ' + jobRoleToUpdate.id);
                                       
            }//else end
            //update all Jobs
            if (myJobRolesList.Size()>0) {
                update myJobRolesList;
            }
            
        }
    }
    
    
    public static void updateJobFromJobItems(Job_Item__c[] newJobItems) {
        // Create a Unique Set of Job IDs for all Job Items in List
        //system.debug('starts updateJob');
        Set<String> myJobs = new Set<String>();
        for (Job_Item__c thisJobItem:newJobItems){
            if (thisJobItem.Job__c == null ){
            //do nothing
            }
            else{
                    if(myJobs.contains(thisJobItem.Job__c)){continue;}
                    else{myJobs.add(thisJobItem.Job__c);}
            }

        }// for ends
        
        if(myJobs.size()>0){
             
        //system.debug('myJobs ID = ' + myJobs);
        //system.debug('myJobs size = ' + myJobs.size());

                     // List of Jobs to Update
                List<Job__c> myJobsList = new List<Job__c>();
                        
                // List of all Job Items related to the set of unique Jobs.
                //system.debug('select job items query from updateJobFromJobItems.');
                List<Job_Item__c> allJobItems 
                    = [SELECT 
                                Id, 
                                Item_Value_FX__c, 
                                Job__c, 
                                Quantity__c,
                                ENSProduct__r.UOM__c,
                                RecordType.Name,
                                Job_Role__r.Role__c,
                                Job_Role__r.Contact__r.FirstName,
                                Job_Role__r.Contact__r.LastName,
                                Work_Start_Date__c 
                       FROM 
                                Job_Item__c 
                       WHERE 
                                Job__c IN :myJobs  limit 1000];
               
                // for each unique Job 
                for (String thisJob:myJobs ) {
                        // initialise variables
                        //system.debug('thisJob = ' + thisJob);
                        decimal sumMaterial = 0.0;
                        decimal sumService = 0.0;
                        decimal sumHours = 0.0;
                        //***
                        //jack added on 7/10/2009 to sum up total travel time
                        decimal sumTravel=0.0;
                        //***
                         //Deb added on 10/1/2013 to sum up total fixed presenter fee
                        decimal sumFixedPresenterFee=0.0;
                        //***
                        // decimal sumGSTAmount = 0.0;
                        // decimal sumManDays = 0.0;
                        decimal count = 0.0;
                        date FirstDate = NULL; 
                        date LastDate = NULL;
                        String Presenters = '';
        
                        // loop through all the Job Items 
                        for (Job_Item__c cJobItem:allJobItems ) {
                          // if it belongs to the Job in question

                          if(cJobItem.Job__c == thisJob){
                            // add the Job Item's amounts to variables
                            count+=1;
                            //***
                        //jack added on 7/10/2009 to sum up total travel time
                        if(cJobItem.Item_Value_FX__c != null && cJobItem.RecordType.Name=='Travel Time'){
                                sumTravel += cJobItem.Item_Value_FX__c;
                            }
                        //***
                         //Deb added on 10/1/2013 to sum up total fixed presenter fee
                        if(cJobItem.Item_Value_FX__c != null && cJobItem.RecordType.Name=='Fixed_Fee'){
                                sumFixedPresenterFee += cJobItem.Item_Value_FX__c;
                            }
                        //***
                          if(cJobItem.Item_Value_FX__c != null && cJobItem.RecordType.Name=='Material'){
                                sumMaterial += cJobItem.Item_Value_FX__c;
                            }
                          if(cJobItem.Item_Value_FX__c != null && cJobItem.RecordType.Name=='Service'){
                                sumService += cJobItem.Item_Value_FX__c;    
                                if(cJobItem.ENSProduct__r.UOM__c == 'Days'){
                                  if(cJobItem.Quantity__c != null){
                                     sumHours += (cJobItem.Quantity__c * 7);
                                  }
                                }
                                else if(cJobItem.ENSProduct__r.UOM__c == 'Hours'){
                                  if(cJobItem.Quantity__c != null){
                                     sumHours += cJobItem.Quantity__c;
                                  }
                                }
                            }
                          // Put dates of first Job Item record into First & Last Dates
                          if(FirstDate == null) {
                                FirstDate = cJobItem.Work_Start_Date__c;
                                LastDate = cJobItem.Work_Start_Date__c;
                            }
                          if(cJobItem.Work_Start_Date__c < FirstDate) {
                                FirstDate = cJobItem.Work_Start_Date__c;
                            }
                          if(cJobItem.Work_Start_Date__c > LastDate) {
                                LastDate = cJobItem.Work_Start_Date__c;
                            }
                          }
                        }
                        
                        // update the amounts for this Job (new Job for update)
                        //Job__c jobToUpdate = new Job__c(Id = thisJob, FX_Materials_Total__c = sumMaterial, FX_Prof_Serv_Total__c = sumService, Total_Job_Item_Hours__c = sumHours, Job_First_Date__c = FirstDate, Job_Last_Date__c = LastDate,Presenters__c = Presenters);
                        Job__c jobToUpdate = new Job__c(Id = thisJob,FX_Travel_Time_Total__c=sumTravel, FX_Fixed_Presenter_Fee__c=sumFixedPresenterFee, FX_Materials_Total__c = sumMaterial, FX_Prof_Serv_Total__c = sumService, Total_Job_Item_Hours__c = sumHours, Job_First_Date__c = FirstDate, Job_Last_Date__c = LastDate);
                        // add this Job to the array of Jobs to be updated
                        myJobsList.add(jobToUpdate);
                        //system.debug('Writing ' +Count+ ' Job Items with materials worth ' + sumMaterial + ' and services worth ' + sumService + ' to Job ' + jobToUpdate.id);
             
                }//for ends
                //update all Jobs
                update myJobsList;
        }//if ends
        
       
    }
    
    public static void updateJobRoles(Job_Role__c[] newJobRoles) {
          // Create a Unique Set of Job IDs for all Job Items in List
       //system.debug('starts updateJobRoles');
        Set<String> myJobs = new Set<String>();
        for (Job_Role__c thisJobRole:newJobRoles){
          if(myJobs.contains(thisJobRole.Job__c)){continue;}
          else{myJobs.add(thisJobRole.Job__c);}
        }
        //system.debug('myJobs size = ' + myJobs);
        
        // List of Jobs to Update
        List<Job__c> myJobsList = new List<Job__c>();
                
        // List of all Job Items related to the set of unique Jobs.
        //system.debug('select job roles query from updateJobRoles');
        List<Job_Role__c> allJobRoles 
            = [SELECT 
                        Id, 
                        Role__c, 
                        Job__c,
                        Contact__r.FirstName,
                        Contact__r.LastName,
                        Prof_Serv_Share_AUD__c,
                        Marketing_Role__c,
                        Prof_Serv_Share__c,
                        Materials_Share__c,
                        Presenter_No__c, //GE 7/2/2013
                        (SELECT 
                                Id, 
                                Item_Value_FX__c, 
                                Job__c, 
                                Quantity__c,
                                ENSProduct__r.UOM__c,
                                RecordType.Name,
                                Job_Role__r.Role__c,
                                Job_Role__r.Contact__r.FirstName,
                                Job_Role__r.Contact__r.LastName,
                                Work_Start_Date__c 
                       FROM 
                                Jobitems__r )
               FROM 
                        Job_Role__c 
               WHERE 
                        Job__c IN :myJobs  limit 1000];
       
        // for each unique Job 
        for (String thisJob:myJobs ) {
                // initialise variables
                //system.debug('thisJob = ' + thisJob);
                String Presenters = '';
                Id Presenter1JobRoleId; //GE 7/2/2013
                Id Presenter2JobRoleId; //GE 7/2/2013
                Integer count = 0;
                decimal sumMaterial = 0.0;
                decimal sumService = 0.0;
                decimal sumHours = 0.0;
                date FirstDate = NULL; 
                date LastDate = NULL;
                Boolean IsTheFirstPresenter = true;
                //Jack added on 31/12/2009 to include the changes from 
                /*
                1.       Total Job Marketing = sum(Prof_Serv_Share) where Role = (Spot OR Sell)
                2.       Total Job Sell = sum(Prof_Serv_Share) where Role = (Sell)
                3.       Total ENS % = sum(Prof_Serv_Share) where Role = (ENS)
                */
                decimal sumSpotOrSellRole=0.0;
                decimal sumSellRole=0.0;
                decimal sumENSRole=0.0;

                // Added on 16/11/2010 to include the change request of roll up sum of share % 
                /*
                1.       Sum Prof_Serv_Share_% Marketing = sum(Prof_Serv_Share_%) where Role = (Spot OR Sell)
                2.       Sum Prof_Serv_Share_% Sell = sum(Prof_Serv_Share_%) where Role = (Sell)
                3.       Sum Materials_Share_% Marketing = sum(Materials_Share_%) where Role = (Spot OR Sell)
                */
                decimal sumSpotOrSellProf_Serv = 0.0;
                decimal sumSellProf_Serv = 0.0;
                decimal sumSpotOrSellMaterials = 0.0;                
           

                // loop through all the Job Roles 
                for (Job_Role__c cJobRole:allJobRoles ) {
                  // if it belongs to the Job
                      if(cJobRole.Job__c == thisJob){
                        // add the number of job roles for the Job
                        count+=1;
                        //system.debug('count:'+count);
                        
                        // Added on 16/11/2010 for sum of share % where Mairketing_Role is "YES" (equivalent to Job_Role__c is "Spot" or "Sell")
                        if(cJobRole.Marketing_Role__c =='YES'){
                            if (cJobRole.Prof_Serv_Share__c != null) {
                                sumSpotOrSellProf_Serv = sumSpotOrSellProf_Serv + cJobRole.Prof_Serv_Share__c;
                            }
                            if (cJobRole.Materials_Share__c != null) {
                                sumSpotOrSellMaterials = sumSpotOrSellMaterials + cJobRole.Materials_Share__c;
                            }
                        }
                        
                        if(cJobRole.Role__c=='Spot' || cJobRole.Role__c=='Sell'){
                            if (cJobRole.Prof_Serv_Share_AUD__c != null) {
                                sumSpotOrSellRole=sumSpotOrSellRole+cJobRole.Prof_Serv_Share_AUD__c;
                            }
                        }
                        if(cJobRole.Role__c=='Sell'){
                            if (cJobRole.Prof_Serv_Share_AUD__c != null) {
                                sumSellRole=sumSellRole+cJobRole.Prof_Serv_Share_AUD__c;
                            }
                            if (cJobRole.Prof_Serv_Share__c != null) {
                                sumSellProf_Serv = sumSellProf_Serv + cJobRole.Prof_Serv_Share__c;
                            }
                        }
                        if(cJobRole.Role__c=='ENS'){
                            if (cJobRole.Prof_Serv_Share_AUD__c != null) {
                                sumENSRole=sumENSRole+cJobRole.Prof_Serv_Share_AUD__c;
                            }
                        }
                        
                        
                        
                        for (Job_Item__c cJobItem : cJobRole.Jobitems__r) {
                         
                         //system.debug('current job item: '+cJobItem.Id);
                         //system.debug('current job item RecordType: '+cJobItem.RecordType.Name);
                          // if it belongs to the Job in question

                          if(cJobItem.Job__c == thisJob){
                            // add the Job Item's amounts to variables
                            
                            //***********
                            //note 1: 16/04/2009 Jack
                            //don't know what the point to have RecordType.Name=='Material' here
                            //cause material job item will not have job role
                            //these code will never be fired
                          if(cJobItem.Item_Value_FX__c != null && cJobItem.RecordType.Name=='Material'){
                                sumMaterial += cJobItem.Item_Value_FX__c;
                               // system.debug('find a material item,current sumMaterial:'+sumMaterial);
                            }
                            //************
                          if(cJobItem.Item_Value_FX__c != null && cJobItem.RecordType.Name=='Service'){
                                sumService += cJobItem.Item_Value_FX__c;    
                                if(cJobItem.ENSProduct__r.UOM__c == 'Days'){
                                  if(cJobItem.Quantity__c != null){
                                     sumHours += (cJobItem.Quantity__c * 7);
                                     
                                  }
                                }
                                else if(cJobItem.ENSProduct__r.UOM__c == 'Hours'){
                                  if(cJobItem.Quantity__c != null){
                                     sumHours += cJobItem.Quantity__c;
                                  }
                                }
                            }
                          // Put dates of first Job Item record into First & Last Dates
                          if(FirstDate == null) {
                                FirstDate = cJobItem.Work_Start_Date__c;
                                LastDate = cJobItem.Work_Start_Date__c;
                            }
                          if(cJobItem.Work_Start_Date__c < FirstDate) {
                                FirstDate = cJobItem.Work_Start_Date__c;
                            }
                          if(cJobItem.Work_Start_Date__c > LastDate) {
                                LastDate = cJobItem.Work_Start_Date__c;
                            }
                          }
                        }
                        //jack ends
                        
                      // String together presenters names
                          if(cJobRole.Role__c == 'Presenter') {
                            //if this is the last then do not add ','
                           // system.debug('count:'+count+' alljobrole size:'+allJobRoles.size());
                                
                                    if (IsTheFirstPresenter) {
                                        
                                         Presenters = cJobRole.Contact__r.FirstName + ' ' + cJobRole.Contact__r.LastName;  
                                         IsTheFirstPresenter=false;
                                    }
                                    else{
                                       Presenters += ', '+cJobRole.Contact__r.FirstName + ' ' + cJobRole.Contact__r.LastName;  
                                    }
                                    
                                    //GE 7/2/2013 To populate presenter 1 & 2 fields on Job so that they can be looked up from Response.
                                    If(cJobRole.Presenter_No__c == '1'){
                                       Presenter1JobRoleId = cJobRole.Id;
                                    }
                                    If(cJobRole.Presenter_No__c == '2'){
                                       Presenter2JobRoleId = cJobRole.Id;
                                    }  
                                    //GE end                                  
                            }
                      }
                }
                 
                // update the presenter for this Job
                // Added on 16/11/2010, also update sum % fields e.g. Total_Mkting_PS__c, Total_Mkting_Mat__c and Total_Sell_PS__c
                //system.debug('Fx material total:'+sumMaterial);
                
                //**************
                //note 2: refer to note 1
                //if sumMaterial =0, then do not update fx material total field
                if(sumMaterial==0){
                    Job__c jobToUpdate = new Job__c(Total_Job_Marketing_AUD__c=sumSpotOrSellRole,Total_Job_Sell_AUD__c=sumSellRole,Total_ENS_AUD__c=sumENSRole,Id = thisJob, Presenters__c = Presenters,FX_Prof_Serv_Total__c = sumService, Total_Job_Item_Hours__c = sumHours, Job_First_Date__c = FirstDate, Job_Last_Date__c = LastDate, Total_Mkting_PS__c = sumSpotOrSellProf_Serv, Total_Mkting_Mat__c = sumSpotOrSellMaterials, Total_Sell_PS__c = sumSellProf_Serv, Presenter_1__c = Presenter1JobRoleId, Presenter_2__c = Presenter2JobRoleId); //GE 7/2/2013 Added last two fields to populate presenter 1 & 2 fields on Job so that they can be looked up from Response.
                                    
                    // add this Job to the array of Jobs to be updated
                    myJobsList.add(jobToUpdate);
                }
                else{
                    Job__c jobToUpdate = new Job__c(Total_Job_Marketing_AUD__c=sumSpotOrSellRole,Total_Job_Sell_AUD__c=sumSellRole,Total_ENS_AUD__c=sumENSRole,Id = thisJob, Presenters__c = Presenters,FX_Materials_Total__c = sumMaterial, FX_Prof_Serv_Total__c = sumService, Total_Job_Item_Hours__c = sumHours, Job_First_Date__c = FirstDate, Job_Last_Date__c = LastDate, Total_Mkting_PS__c = sumSpotOrSellProf_Serv, Total_Mkting_Mat__c = sumSpotOrSellMaterials, Total_Sell_PS__c = sumSellProf_Serv, Presenter_1__c = Presenter1JobRoleId, Presenter_2__c = Presenter2JobRoleId); //GE 7/2/2013 As above.              
                                    
                    // add this Job to the array of Jobs to be updated
                    myJobsList.add(jobToUpdate);
                }
                //*******************

                //system.debug('Writing ' +Count+ ' Presenters: ' + Presenters + ' to Job ' + jobToUpdate.id);
     
        }
        //update all Jobs
        update myJobsList;
    }
    
    public static void updateAccounts(Job__c[] newJobs) {
        // Create a Unique Set of Account IDs for all Job Items in List
        //system.debug('starts updateAccounts');
        Set<String> myAccounts = new Set<String>();
        Set<String> myStatus = new Set<String>();
        for (Job__c thisJob:newJobs){
          if(myAccounts.contains(thisJob.Account__c)){continue;}
          else{myAccounts.add(thisJob.Account__c);}
        }
        //system.debug('myAccounts size = ' + myAccounts);
        //system.debug('myStatus size = ' + myStatus);
        
        
        // List of Accounts to Update
        List<Account> myAccountsList = new List<Account>();
                
        // List of all Job Items related to the set of unique Accounts.
        //system.debug('select jobs query from updateAccounts');
        List<Job__c> allJobs
            = [SELECT 
                        Id, 
                        Account__c,
                        status_new1__c,
                        Proposal_Date__c,
                        Confirmed_Date__c,
                        Completed_Date__c
               FROM 
                        Job__c 
               WHERE 
                        Account__c IN :myAccounts ORDER BY CreatedDate DESC limit 1000];
       
        // for each unique Account 
        for (String thisAccount:myAccounts ) {
           date FirstDate;
           decimal count = 0.0;
                // loop through all the Jobs 
                for (Job__c cJob:allJobs) {
                  // if it belongs to the Account in question
                  if(cJob.Account__c != null && cJob.Account__c == thisAccount){
                    // add the Job Item's amounts to variables
                    count+=1;
                    // Put dates of first Job Item record into First & Last Dates
                    if(count == 1){
                      if(cJob.Proposal_Date__c != null) {
                        FirstDate = cJob.Proposal_Date__c.addYears(1);
                      } 
                      if(cJob.Confirmed_Date__c != null) {
                        FirstDate = cJob.Confirmed_Date__c.addYears(1);
                      }
                      if(cJob.Completed_Date__c != null) {
                        FirstDate = cJob.Completed_Date__c.addYears(1);
                      }
                    }
                  }
                }
                count = 0.0;
                // update this Account
                if(thisAccount != null){
                  Account AccToUpdate = new Account(Id = thisAccount, Current_Claim_Expiry__c = FirstDate);
                  // add this Account to the array of Accounts to be updated
                  myAccountsList.add(AccToUpdate);
                  //system.debug('Writing ' + FirstDate + ' for Job: ' + AccToUpdate.id);
                }
     
        }
        //update all Accounts
        if(myAccountsList.size() != 0){update myAccountsList;}
    }
}