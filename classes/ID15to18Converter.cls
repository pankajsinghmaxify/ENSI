public class ID15to18Converter {

    //String char15 = '500x000000003TR';
    public String char15 {get;set;}
    public String char18 {get;set;}
    public String bin15 {get;set;}
    String testString= 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    
    public ID15to18Converter(){}

    
    public void StartConvert(){
    	
    	List<Task> TaskList = NEW List<Task>();
    	
    	for(Task aTask : [select job_no__c from task where job_no__c<>null]){
    	   
	    	   if(aTask.job_no__c.length()==15){

		                char15 = aTask.job_no__c;
		                char18 = '';
		                bin15 = '';
				                
		                for (Integer j =0;j<15;j++){
		                
			                    if(testString.contains(char15.substring(j,j+1))){
			                        bin15='1'+bin15;
			                    }
			                    else{
			                        bin15='0'+bin15;
			                    }
					                
					    }
					        
		               char18 = char15;
		                char18 += convertBin(bin15.substring(10,15));
		                char18 += convertBin(bin15.substring(5,10));
		                char18 += convertBin(bin15.substring(0,5));
		                
		                aTask.job_no__c=char18;
		                
		                TaskList.add(aTask);
		                
		                if(TaskList.size()==99){
		                   update TaskList;
		                   TaskList.clear();
		                }
					        
			    }
			        

    	   
             }//for ends
             
                            if(TaskList.size()>=1){
                      update TaskList;
                      TaskList.clear();
                }

    }
    
    public String convertBin(String s){
    
        String codeResult = '';
        
        Map<String,String> codeKey = new Map<String,String>{
            '00000' => 'A',
            '00001' => 'B',
            '00010' => 'C',
            '00011' => 'D',
            '00100' => 'E',
            '00101' => 'F',
            '00110' => 'G',
            '00111' => 'H',
            '01000' => 'I',
            '01001' => 'J',
            '01010' => 'K',
            '01011' => 'L',
            '01100' => 'M',
            '01101' => 'N',
            '01110' => 'O',
            '01111' => 'P',
            '10000' => 'Q',
            '10001' => 'R',
            '10010' => 'S',
            '10011' => 'T',
            '10100' => 'U',
            '10101' => 'V',
            '10110' => 'W',
            '10111' => 'X',
            '11000' => 'Y',
            '11001' => 'Z',
            '11010' => '0',
            '11011' => '1',
            '11100' => '2',
            '11101' => '3',
            '11110' => '4',
            '11111' => '5'
        };
        
        codeResult =  codeKey.get(s);
        return codeResult;
        
    }

    public static testMethod void testID15to18Converter() {
      PageReference pageRef = new PageReference('Page.ID15to18Converter');
      Test.setCurrentPage(pageRef);
        
        ID15to18Converter controller = new ID15to18Converter();
        controller.StartConvert();
        
        }

}