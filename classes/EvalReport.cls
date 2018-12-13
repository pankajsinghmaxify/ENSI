public class EvalReport {
    public Job__c Job;
    public List<Response__c> responses;
    public List<Response__c> responses2;
    public List<Question__c> questions;
    public List<Question__c> questions2;
    public List<Answer__c> answers;
    public List<Section> sections = new List<Section>();

    public EvalReport(ApexPages.StandardController stdController) {
      this.Job = (Job__c)stdController.getRecord();
      Job = [select Survey__c from Job__c where Id =: Job.Id];
      responses = [Select Response_Text__c, Answer_Number__c, Answer_Number__r.Answer_Text__c,
                          Answer_Number__r.Answer_Value__c, Participant_Id__c, Participant_Id__r.Job__c,
                          Answer_Number__r.Question_ID__r.Question_Text__c, Answer_Number__r.Question_ID__c,
                          Answer_Number__r.Question_ID__r.Section__c
                          From Response__c Where Job__c =: Job.Id ORDER BY Answer_Number__r.Question_ID__r.question_order_number__c ASC];
      //all non-free text answers
      answers = [Select Id, Question_ID__r.Section__c, Question_ID__r.Question_Text__c, Answer_Text__c, Answer_Value__c, tmp_noparticipants__c, tmp_percentage__c, tmp_avg__c, Question_ID__c from Answer__c where Question_ID__r.Survey_Name__c =: Job.Survey__c AND Question_ID__r.Free_Text_Answer__c = false ORDER BY Answer_Value__c DESC];
      
      //all non-free text questions
      questions = [Select Id, question_number__c, question_order_number__c, Section__c, tmp_average__c, Question_Text__c from Question__c where Survey_Name__c =: Job.Survey__c AND Free_Text_Answer__c = false AND NotShowOn__c = false ORDER BY question_order_number__c ASC];
    }
    
    
    //colculate avg
    public void Answers(){
      integer Five;
      integer Four;
      integer Three;
      integer Two;
      integer One;
      for(Answer__c thisA:answers){
        Five = 0;
        Four = 0;
        Three = 0;
        Two = 0;
        One = 0;
        for(Response__c thisR:responses){
          if(thisR.Answer_Number__c == thisA.Id){
            if(thisA.Answer_Value__c == 5){Five++;}
            if(thisA.Answer_Value__c == 4){Four++;}
            if(thisA.Answer_Value__c == 3){Three++;}
            if(thisA.Answer_Value__c == 2){Two++;}
            if(thisA.Answer_Value__c == 1){One++;}             
          }
        }
        System.debug('thisA.Answer_Value__c:'+thisA.Answer_Value__c);
        System.debug('thisA.Id:'+thisA.Id);
        if(thisA.Answer_Value__c == 5){thisA.tmp_noparticipants__c = Five;}
        if(thisA.Answer_Value__c == 4){thisA.tmp_noparticipants__c = Four;}
        if(thisA.Answer_Value__c == 3){thisA.tmp_noparticipants__c = Three;}
        if(thisA.Answer_Value__c == 2){thisA.tmp_noparticipants__c = Two;} 
        if(thisA.Answer_Value__c == 1){thisA.tmp_noparticipants__c = One;} 
        System.debug('thisA.tmp_noparticipants__c:'+thisA.tmp_noparticipants__c);
      }
      double parti;
      decimal avg;
      for(Question__c thisQ:questions){
        parti = 0;
        avg = 0.00;
         System.debug('current question id is: '+thisQ.Id);
        System.debug('answer size of the current question: '+answers.size());
        for(integer i=0; i<answers.size(); i++){
          if(answers[i].Question_ID__c == thisQ.Id){
          	System.debug('Number of inner answer loop is: '+i);
            System.debug('answer id is: '+answers[i].Id);
            System.debug('tmp_noparticipants: '+answers[i].tmp_noparticipants__c);
            if (answers[i].tmp_noparticipants__c==null){
            System.debug('Find an null');
            }
            parti += answers[i].tmp_noparticipants__c;
          }
          if(i == answers.size()-1){ 
            for(integer k=0; k<answers.size(); k++){
              if(answers[k].Question_ID__c == thisQ.Id){
                if(parti != 0){
                	System.debug('answers[k].Answer_Value__c:'+answers[k].Answer_Value__c);
                	Decimal d=answers[k].tmp_noparticipants__c/parti*100;
                	d=d.round();
                	//Integer myInt = integer.valueOf(d);
                  answers[k].tmp_percentage__c = d;
                  avg += (answers[k].tmp_noparticipants__c * answers[k].Answer_Value__c)/parti;
                }
                else{
                  answers[k].tmp_percentage__c = 0;
                  avg = 0;
                }
              }
            }
            thisQ.tmp_average__c = avg;
          }
        }
      }
    }
    
    public Integer getParticipants(){
      return [select count() from Participant__c where Job__c =: Job.Id];
    }
    
    public Integer getCompletedEvals(){
      List<Response__c> Evals;
      Evals = [select Submission_ID__c from Response__c where Job__c =: Job.Id];
      Set<String> CEvals = new Set<String>();
      for(Response__c thisR:Evals){
        if(thisR.Submission_ID__c != null){
          if(CEvals.contains(thisR.Submission_ID__c)){continue;}
          else{CEvals.add(thisR.Submission_ID__c);}
        }
      }
      return CEvals.size();     
    }
    
    public List<Section> getSections(){
    	//all free text responses
      responses2 = [Select Response_Text__c,Get_Response_Text__c, Answer_Number__c, Answer_Number__r.Answer_Text__c,
                          Answer_Number__r.Answer_Value__c, Participant_Id__c, Participant_Id__r.Job__c,
                          Answer_Number__r.Question_ID__r.Question_Text__c, Answer_Number__r.Question_ID__c,
                          Answer_Number__r.Question_ID__r.Section__c, Answer_Number__r.Question_ID__r.Free_Text_Answer__c
                          From Response__c Where Job__c =: Job.Id AND Answer_Number__r.Question_ID__r.Free_Text_Answer__c = true and (Response_Text__c<>''or Answer_Number__r.Name='AN-0159')
 ORDER BY Answer_Number__r.Question_ID__r.question_order_number__c ASC];
      //all free text question
      questions2 = [Select Id, Section__c, question_number__c, question_order_number__c, tmp_average__c, Question_Text__c from Question__c where Survey_Name__c =: Job.Survey__c AND Free_Text_Answer__c = true AND NotShowOn__c = false ORDER BY question_order_number__c ASC];
      
      // get the answer records along with the percentages and averages
      Answers();
            
            //create section set for all non-free text questions
      Set<String> mySections = new Set<String>();
      List<String> myUNISections = new List<String>();
      for(Question__c thisQS:questions){
        if(mySections.contains(thisQS.Section__c)){continue;}
        else{
        	mySections.add(thisQS.Section__c);
        	myUNISections.add(thisQS.Section__c);
        	}
      }
      
      //create section set for all UNIQUE section of free text questions
      Set<String> mySections2 = new Set<String>();
      //use list to holde sections, casue Set is unordered,must use list which is ordered
      List<String> myUNISections2 = new List<String>();
      for(Question__c thisQS:questions2){
        if(mySections2.contains(thisQS.Section__c)){continue;}
        else{   	
        	system.debug('mysections2 added:'+thisQS.Section__c);
        	mySections2.add(thisQS.Section__c);
        	myUNISections2.add(thisQS.Section__c);
        	}
      }

 for(String thisS:myUNISections){
        Decimal Avg = 0.00;
        List <Question__c> q1 = new List<Question__c>();
        List <Answer__c> a1 = new List<Answer__c>();
        for(Question__c thisQ:questions){
          if(thisS == thisQ.Section__c && thisQ.tmp_average__c > 0){
            Avg += thisQ.tmp_average__c;
          }
          for(Answer__c thisA:answers){
            if(thisA.Question_ID__r.Section__c == thisQ.Section__c && thisA.Question_ID__c == thisQ.Id){
              a1.add(thisA);
            }     
          }//answer for ends 
          

          if(thisS == thisQ.Section__c){
            q1.add(thisQ);
            
          }
   if(thisQ.Id=='a0M20000000BStx'){
            system.debug('avg:'+avg);
            system.debug('q1.size:'+q1.size());
            system.debug('Avg/q1.size():'+Avg/q1.size());
            }
        }//question for ends

        if(q1.size() > 0){
            
          sections.add(new Section(thisS, q1, a1, Avg/q1.size(), 'FIVE', responses));
        }
        else{
          sections.add(new Section(thisS, q1, a1, 0, 'FIVE', responses));
        }
      }//mysections for ends
      
      
      List<Section> FreeText = new List<Section>();
      system.debug(sections);
      ////loop through free text sections
      for(String thisS:myUNISections2){
      	system.debug('mysection 2 name:'+thisS);
        List <Question__c> q1 = new List<Question__c>();
        List <Response__c> r1 = new List<Response__c>();
        for(Question__c thisQ:questions2){
          for(Response__c thisR:responses2){
            if(thisR.Answer_Number__r.Question_ID__r.Section__c == thisQ.Section__c && thisR.Answer_Number__r.Question_ID__c == thisQ.Id){
            	//catch null length response text
            	if(thisR.Response_Text__c!= null){

				            r1.add(thisR);  	   
            	}

            }     
          } 
          system.debug('this Q section name:'+thisQ.Section__c);
          
          if(thisS == thisQ.Section__c){
          	system.debug('q1 added:'+thisS);
            q1.add(thisQ);
          }       
        }
        //add free text section to the FreeText sections list
        system.debug('freetext list added:'+thisS);
        FreeText.add(new Section(thisS, q1, answers, 0, 'FREE', responses2));
      }
      
      //add up both non-free text and free text sections list into one
      List<Section> tempList = new List<Section>();
      
      //for(integer i=sections.size()-1; i>=0; i--){
        //tempList.add(sections[i]);
      //} 
      for(section s:sections){
        tempList.add(s);
      } 
      
      //for(integer i=FreeText.size()-1; i>=0; i--){
        //tempList.add(FreeText[i]);
      //}
      for(section s:FreeText){
        tempList.add(s);
      }    
      system.debug(tempList);
      return tempList;      
    }
}