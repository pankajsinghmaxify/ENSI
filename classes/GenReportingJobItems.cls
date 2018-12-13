public class GenReportingJobItems {
    /* Generates Reporting Job Item Records for every Job_Item and Job_Role that gets
       added deleted or updated 
    */
    
    public static void genJobItem(Job_Item__c[] newJobItems) {
        // Create Blank list of Reporting Job Items
        List<Reporting_Job_Item__c> Report = new List<Reporting_Job_Item__c>();
        Set<String> UniqueJobIds = new Set<String>();   
        // Get list of Unique "Jobs" within the Batch of Job Items
        for (Job_Item__c thisJobItem: newJobItems) {
          if(UniqueJobIds.contains(thisJobItem.Job__c)){continue;}
          else{UniqueJobIds.add(thisJobItem.Job__c);}
        }
        // Query any previous reports for these job items and delete them to start fresh each time
        List<Reporting_Job_Item__c> prevReports= [select Id, Job_Item__c, Job_Role__c from Reporting_Job_Item__c where Job_Item__c in :newJobItems];
                       if (prevReports.size()>0) {
                delete prevReports; 
                }
        
        // Query Job Roles related to Unique Jobs
        List<Job_Role__c> Roles = [select Id, Role__c, RecordType.Name, Job__c from Job_Role__c where Job__c  in :UniqueJobIds];
        //system.debug(Roles.size());
        // Copy of Job Items list (apex seems to get confused when using the existing batch list)
        //List<Job_Item__c> Job_Items = [select Id, RecordType.Name, Job_Role__c, Job__c from Job_Item__c where Id in :newJobItems];
        //system.debug('new job items szie: '+newJobItems.size());
        
        //Jack added on 21/01/2010 
        //to fix the Null recordtype name problem
        RecordType PresenterRT=[select id from recordtype where name='Presenter'];
        //Jack added ends on 21/01/2010
        
        
        
        // Loop Through Job Roles and Job Items Joining them up as we go in a Reporting Job Item Object
        for(Job_Item__c JI: newJobItems){
            //system.debug('JI.Job_Role__c: '+JI.Job_Role__c);
            
            for(Job_Role__c JR: Roles){
              System.debug('JR.RecordType.Name:'+JR.RecordType.Name);
              System.debug('JR.RecordTypeId:'+JR.RecordTypeId);
              
              /*
              //Jack disabled following code on 21/01/2010
              if(JR.RecordType.Name == 'Presenter' && JR.Id == JI.Job_Role__c){
                Report.add(new Reporting_Job_Item__c(Job__c = JI.Job__c, Job_Item__c = JI.Id, Job_Role__c = JI.Job_Role__c));
              }
              else if(JR.RecordType.Name != 'Presenter' && JR.Job__c == JI.Job__c){
                Report.add(new Reporting_Job_Item__c(Job__c = JI.Job__c, Job_Item__c = JI.Id, Job_Role__c = JR.Id));
              }
              //Jack disabled ends on 21/01/2010
              */
              
              //Jack added on 21/01/2010 
              if(JR.RecordTypeId == PresenterRT.id && JR.Id == JI.Job_Role__c){
              	system.debug('JR.RecordTypeId == PresenterRT is '+(JR.RecordTypeId == PresenterRT.id));
                Report.add(new Reporting_Job_Item__c(Job__c = JI.Job__c, Job_Item__c = JI.Id, Job_Role__c = JI.Job_Role__c));
              }
              else if(JR.RecordTypeId != PresenterRT.id && JR.Job__c == JI.Job__c){
              	system.debug('JR.RecordTypeId != PresenterRT is '+(JR.RecordTypeId != PresenterRT.id));
                Report.add(new Reporting_Job_Item__c(Job__c = JI.Job__c, Job_Item__c = JI.Id, Job_Role__c = JR.Id));
              }
              //Jack added ends on 21/01/2010
            }
        }
 //system.debug('Report szie: '+Report.size());
                insert Report;          
    }
    
    public static void genJobRole(Job_Role__c[] newJobRoles) {
    	system.debug('Start debug*********************************');
        if(JobAction.IsUpdateJobRoleNeeded==true){
            // Create Blank list of Reporting Job Items
        List<Reporting_Job_Item__c> Report = new List<Reporting_Job_Item__c>();
        Set<String> UniqueJobIds = new Set<String>();   
        // Get list of Unique "Jobs" within the Batch of Job Items
        for (Job_Role__c thisJobRole: newJobRoles) {
          if(UniqueJobIds.contains(thisJobRole.Job__c)){continue;}
          else{UniqueJobIds.add(thisJobRole.Job__c);}
        }
        // Query any previous reports for these job items and delete them to start fresh each time
        // Jack disabled on 26/02/2009
        //List<Reporting_Job_Item__c> prevReports= [select Id, Job_Item__c, Job_Role__c from Reporting_Job_Item__c where Job_Role__c in :newJobRoles];
        //Jack ends
        //Jack added on 26/02/2009

        List<Reporting_Job_Item__c> prevReports= [select Id, Job_Item__c, Job_Role__c from Reporting_Job_Item__c where Job_Role__c in :newJobRoles];
        //Jack ends
       
                if (prevReports.size()>0) {
                    // System.debug('prevReports.size():'+prevReports.size());
           // System.debug('Job_Role__c:'+prevReports[0].Job_Role__c);
                //System.debug('Job_Item__c:'+prevReports[0].Job_Item__c);
                //System.debug('***************');

                delete prevReports;   
                }
        
        
        // Copy of Job Roles list (apex seems to get confused when using the existing batch list)
        //List<Job_Role__c> Roles = [select Id, Role__c, RecordType.Name, Job__c from Job_Role__c where Id in :newJobRoles];
        //system.debug(Roles.size());
        // Query Job Items related to unique Jobs
        List<Job_Item__c> Job_Items = [select Id, RecordType.Name, RecordTypeId,Job_Role__c, Job__c from Job_Item__c where Job__c in :UniqueJobIds];
        system.debug('newJobRoles.size:'+newJobRoles.size());
        
        //Jack added on 21/01/2010 
        //to fix the Null recordtype name problem
        RecordType PresenterRT=[select id from recordtype where name='Presenter'];
        //Jack added ends on 21/01/2010
        
        // Loop Through Job Roles and Job Items Joining them up as we go in a Reporting Job Item Object
        for(Job_Role__c JR: newJobRoles){
           for(Job_Item__c JI: Job_Items){
            System.debug('JR.RecordType.Name:'+JR.RecordType.Name);
            System.debug('JR.RecordTypeId:'+JR.RecordTypeId);
            
            /*
              //Jack disabled following code on 21/01/2010
              if(JR.RecordType.Name == 'Presenter' && JR.Id == JI.Job_Role__c){
                System.debug('Presenter, Job_Role__c:'+JR.Id);
                System.debug('Presenter, Job_Job__c:'+JI.Job__c);
                System.debug('Presenter, Job_Item__c:'+JI.Id);
                System.debug('***************');
                Report.add(new Reporting_Job_Item__c(Job__c = JI.Job__c, Job_Item__c = JI.Id, Job_Role__c = JI.Job_Role__c));
              }
              else if(JR.RecordType.Name != 'Presenter' && JR.Job__c == JI.Job__c){
                System.debug('Non-Presenter, Job_Role__c:'+JR.Id);
                System.debug('Non-Presenter, Job_Job__c:'+JI.Job__c);
                System.debug('Non-Presenter, Job_Item__c:'+JI.Id);
                System.debug('***************');
                Report.add(new Reporting_Job_Item__c(Job__c = JI.Job__c, Job_Item__c = JI.Id, Job_Role__c = JR.Id));
              }
              //Jack disabled ends on 21/01/2010
              */
              
              //Jack added on 21/01/2010 
              if(JR.RecordTypeId == PresenterRT.id && JR.Id == JI.Job_Role__c){
              	system.debug('JR.RecordTypeId == PresenterRT is '+(JR.RecordTypeId == PresenterRT.id));
              	System.debug('Presenter, Job_Role__c:'+JR.Id);
                System.debug('Presenter, Job_Job__c:'+JI.Job__c);
                System.debug('Presenter, Job_Item__c:'+JI.Id);
                System.debug('***************');
                Report.add(new Reporting_Job_Item__c(Job__c = JI.Job__c, Job_Item__c = JI.Id, Job_Role__c = JI.Job_Role__c));
              }
              else if(JR.RecordTypeId != PresenterRT.id && JR.Job__c == JI.Job__c){
              	system.debug('JR.RecordTypeId != PresenterRT is '+(JR.RecordTypeId != PresenterRT.id));
              	System.debug('Non-Presenter, Job_Role__c:'+JR.Id);
                System.debug('Non-Presenter, Job_Job__c:'+JI.Job__c);
                System.debug('Non-Presenter, Job_Item__c:'+JI.Id);
                System.debug('***************');
                Report.add(new Reporting_Job_Item__c(Job__c = JI.Job__c, Job_Item__c = JI.Id, Job_Role__c = JR.Id));
              }
              //Jack added ends on 21/01/2010
            }
        }
        insert Report;
        }
        
    }
}