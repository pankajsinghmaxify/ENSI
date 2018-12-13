public class JobActivityRelatedList { 
 String Id;
String char15 ;
   String char18 ;
   String bin15 ;
   String testString= 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';


        // Grab ID from query string and store
 public JobActivityRelatedList(ApexPages.StandardController JobController) {
      //Id = ApexPages.currentPage().getParameters().get('Id');
      Id=JobController.getId();
    }
    
     public String StartConvert(String theid){
        
        if(theid.length()==15){
            bin15 = '';
            char15 = theid;
                char18 = '';
                
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
            
        }
        else{
            char18=char15;
        }
                   
                
                return char18;

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
    
    
public List<Task> getAllTasks(){
    
      List<Task> aTaskList;

    String Long18ID =StartConvert(ID);

      aTaskList =[Select Id,Subject,WhoId,Who.Name,WhatId,What.Name,Status,Priority,OwnerId,Owner.Name,CreatedDate From Task where job_no__c=:Long18ID order by CreatedDate desc];
      
       return aTaskList;
    }
 
 public PageReference ShowTasks(){
    return null; 
 }
 
 
}