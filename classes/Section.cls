public class Section{
  public List<Question__c> questions;
  public List<Answer__c> answers;
  public List<Response__c> responses;
  public String Section;
  public String Average;
  public String SType;
  
  public Section(String cSection, List<Question__c> cquestions, List<Answer__c> canswers, Decimal caverage, String ctype, List<Response__c> cresponses){
     questions = cquestions;
     answers = canswers;
     Section = cSection;
     Average = string.valueOf(caverage.setScale(2));
     responses = cresponses;
     SType = ctype;
  }
  
  public List<Question__c> getQuestions(){
    return questions;
  }
  
  public List<Answer__c> getAnswers(){
    return answers;
  }
  
  public List<Response__c> getResponses(){
    return responses;
  }
  
  public String getSection(){
	  	String jobid=ApexPages.currentPage().getParameters().get('Id');
	  	
	  	if (Section=='Presenter 1') {
	  		Integer counter=[select count() from job_role__c where Presenter_No__c='1' AND Job__c = :jobid];
            if (counter>0){
               Job_Role__c aJobRole= [select Contact__r.name from job_role__c where Presenter_No__c='1' AND Job__c = :jobid];
               Section='Presenter 1 '+ajobrole.Contact__r.name;
            }
            else{
                Section='Presenter 1 ';
            }

	  	}
	  	if (Section=='Presenter 2') {
	        
	        Integer counter=[select count() from job_role__c where Presenter_No__c='2' AND Job__c = :jobid];
	        if (counter>0){
	           Job_Role__c aJobRole= [select Contact__r.name from job_role__c where Presenter_No__c='2' AND Job__c = :jobid];
	           Section='Presenter 2 '+ajobrole.Contact__r.name;
	        }
	        else{
				Section='Presenter 2 ';
		    }

	    }
	   if (Section=='Presenter 3') {
	        
		    Job_Role__c aJobRole= [select Contact__r.name from job_role__c where Presenter_No__c='3' AND Job__c = :jobid];
		    Section='Presenter 3 '+ajobrole.Contact__r.name; 
	    }
	    return Section;
  }
  
  public String getType(){
    return SType;
  }
  
  public String getAverage(){


  	return string.valueOf(Average);
    
  }
}