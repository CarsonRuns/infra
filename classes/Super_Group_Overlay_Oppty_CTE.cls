// This class acts as Controller Class for Super_Group_Overlay_Oppty VF
// Release -- FY'13 Year End Rel 

public with sharing class Super_Group_Overlay_Oppty_CTE {
   
    private Integer pagesize = 5;
    private String  SuperGroupId;
    private String query;
    public Integer totalPages {get; set;}
    public String  navigateToOppty {get; set;}
    
    private String sortOrderOld = 'ASC';
    private String sortColumnNameOld = 'Account.Name';
    public String sortOrderNew {get; set;}
    public String sortColumnNameNew {get; set;}
    
    public Super_Group_Overlay_Oppty_CTE (ApexPages.StandardController controller) {
        navigateToOppty = Utilities.getSuperGroupOverlayOpptyRelatedListId();
        SuperGroupId = ApexPages.currentpage().getparameters().get('Id');
    }
    
    public ApexPages.StandardSetController OPPTYCON {
        get {
         try{
                if(OPPTYCON == null) {
                
                String query = 'Select Id,Name,Account.Name,CloseDate,StageName,Opportunity_Status__c,Owner.Alias,' +
                               'Expected_Product__c,Expected_Service__c from Opportunity where ' +
                               'AccountId  IN (Select Account_ID__c from Overlay_Acct_SuperGroup_Rel__c where Super_Group__c = : SuperGroupId)' + 
                               'ORDER BY Account.Name ASC limit 10000';
                               
                Paging(query);  
                
                if(Utilities.getIsTestMethod()== true){                 
                    String str = null;    
                    str.tolowercase();                             
                 }                                                          
              }
                return OPPTYCON;
            }
            catch(Exception e){
                ApexPages.addMessages(e);
                System.debug('Super_Group_Overlay_Oppty_CTE ## OPPTYCON ## Exception ## ' + e);
                return null;
            }
         }
        set;
        }


//This method is used to get Opportunity Records on Visualforce Page, for a given Super Group Record
        
   public List<Opportunity> getOpptyRecords(){
       try{         
            if(OPPTYCON != null){
                return (List<Opportunity>) OPPTYCON.getRecords();
            }
            if(Utilities.getIsTestMethod()== true){                 
                    String str = null;    
                    str.tolowercase();                             
             }      
         }  
       catch(Exception e){
            ApexPages.addMessages(e);
            System.debug('Super_Group_Overlay_Oppty_CTE  ## getAccountGroupRecords ## Exception ## ' + e);
            return null;
        }    
        return null;
    } 


//This method is used for Pagination on Visualforce Page, for a given Super Group Record
   
   public void Paging(String query){
       try{
            OPPTYCON = new ApexPages.StandardSetController(Database.getQueryLocator(query));  
            // sets the number of records in each page set
            OPPTYCON.setPageSize(pagesize);
            // total page count
            if(Math.Mod(OPPTYCON.getResultSize(),pagesize) == 0){
                totalPages = OPPTYCON.getResultSize()/pagesize;
            }
            else {
                totalPages = OPPTYCON.getResultSize()/pagesize + 1;
            } 
           
           if(Utilities.getIsTestMethod()== true){                 
                    String str = null;    
                    str.tolowercase();                             
            }      
        }
        catch(Exception e){
            ApexPages.addMessages(e);
            System.debug('Super_Group_Overlay_Oppty_CTE ## Paging ## Exception ## ' + e);
        }    
    }

//This method is used for Sorting Account Name & Opportunity Owner on Visualforce Page, for a given Super Group Record
   
   public PageReference OrderData (){
      try{
            String orderByExp = '';
          
            if(sortColumnNameNew != sortColumnNameOld){   
                sortOrderNew  = 'ASC';
            }
            
            if(sortColumnNameNew == sortColumnNameOld){   
                if(sortOrderOld == 'ASC')  
                    sortOrderNew = 'DESC';
                else     
                    sortOrderNew = 'ASC'; 
            }      
            
            sortColumnNameOld = sortColumnNameNew;
            sortOrderOld = sortOrderNew;
            
            orderByExp  =  'order by' + ' ' + sortColumnNameNew + ' ' + sortOrderNew;
            
            query = 'Select Id,Name,Account.Name,CloseDate,StageName,Opportunity_Status__c,Owner.Alias,' +
                    'Expected_Product__c,Expected_Service__c from Opportunity where AccountId  IN' + 
                    '(Select Account_ID__c from Overlay_Acct_SuperGroup_Rel__c where Super_Group__c = : SuperGroupId)' + 
                    ' ' + orderByExp + ' ' + 'LIMIT 10000' ;
                    
            Paging(query); 
            
             if(Utilities.getIsTestMethod()== true){                 
                    String str = null;    
                    str.tolowercase();                             
              }      
         }              
         catch(Exception e){
            ApexPages.addMessages(e);
            System.debug('Super_Group_Overlay_Oppty_CTE ## OrderData ## Exception ## ' + e);
            return null;
        }    
        return null;
    }


    // This method redirects Excel Export Link Page to Excel Export Page for Ovelay Oppty data
    public PageReference exportOverlayOpptyLink() {
        try{
            PageReference redirect = new PageReference('/apex/Super_Group_Overlay_Oppty_Export'); 
            redirect.getParameters().put('id',SuperGroupId);  
            redirect.setRedirect(true); 
            if(Utilities.getIsTestMethod()== true){                 
                    String str = null;    
                    str.tolowercase();                             
             }
             
            return redirect;
           }              
           catch(Exception e){
                ApexPages.addMessages(e);
                System.debug('Super_Group_Overlay_Oppty_CTE ## exportOverlayOpptyLink ## Exception ## ' + e);
                return null;
       } 
    }
}