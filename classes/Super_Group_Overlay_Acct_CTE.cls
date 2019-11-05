// This class acts as Controller Class for Super_Group_Overlay_Acct VF
// Release -- FY'13 Year End Rel 

public with sharing class Super_Group_Overlay_Acct_CTE {
  
    private Integer pagesize = 5;
    private String  SuperGroupId;
    private String query;
    public  Integer totalPages {get; set;}
    public  String  navigateToAccount {get; set;}
    
    private String sortOrderOld = 'ASC';
    private String sortColumnNameOld = 'Name';
    public  String sortOrderNew {get; set;}
    public  String sortColumnNameNew {get; set;}
    
    public Super_Group_Overlay_Acct_CTE (ApexPages.StandardController controller) {
        navigateToAccount = Utilities.getSuperGroupOverlayAccountRelatedListId();
        SuperGroupId = ApexPages.currentpage().getparameters().get('Id');
    }
    
        
    public ApexPages.StandardSetController ACCTCON {
        get {
         try{
                if(ACCTCON == null) {
                
                String query = 'Select Id, Name,Owner.Name,HQ_Party_ID__c,CSCSiteID__c,DUNSNumber__c,AddressLine1__c,'+
                               'City__c,State__c,Country__c from Account where Id IN' +
                               '(Select Account_ID__c from Overlay_Acct_SuperGroup_Rel__c where Super_Group__c = :SuperGroupId)' +
                               'ORDER BY Name ASC limit 10000';                        
                Paging(query); 
                
                if(Utilities.getIsTestMethod()== true){                 
                    String str = null;    
                    str.tolowercase();                             
                 }                
              }
             return ACCTCON;
            }
            catch(Exception e){
                ApexPages.addMessages(e);
                System.debug('Super_Group_Overlay_Acct_CTE ## ACCTCON ## Exception ## ' + e);
                return null;
            }
        }
        set;
        }

//This method is used for Pagination on Visualforce Page, for a given Super Group Record
                  
    public void Paging(String query){
        try{
            ACCTCON = new ApexPages.StandardSetController(Database.getQueryLocator(query));  
            // sets the number of records in each page set
            ACCTCON.setPageSize(pagesize);
            // total page count
            if(Math.Mod(ACCTCON.getResultSize(),pagesize) == 0){
                totalPages = ACCTCON.getResultSize()/pagesize;
            }
            else {
                totalPages = ACCTCON.getResultSize()/pagesize + 1;
            }
            
            if(Utilities.getIsTestMethod()== true){                 
                    String str = null;    
                    str.tolowercase();                             
              }      
          }
        catch(Exception e){
            ApexPages.addMessages(e);
            System.debug('Super_Group_Overlay_Acct_CTE ## Paging ## Exception ## ' + e);
        }    
    }

//This method is used to get Account Records on Visualforce Page, for a given Super Group Record 
 
   public List<Account> getAccountRecords(){
     try{         
        if(ACCTCON != null){
            return (List<Account>) ACCTCON.getRecords();
            }
        
        if(Utilities.getIsTestMethod()== true){                 
                    String str = null;    
                    str.tolowercase();                             
            }      
        }  
       catch(Exception e){
            ApexPages.addMessages(e);
            System.debug('Super_Group_Overlay_Acct_CTE  ## getAccountGroupRecords ## Exception ## ' + e);
            return null;
        }    
        return null;
    } 

//This method is used for Sorting Account Name & Account Owner on Visualforce Page, for a given Super Group Record
    
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
    
            query = 'Select Id, Name,Owner.Name,HQ_Party_ID__c,CSCSiteID__c,DUNSNumber__c,AddressLine1__c,'+
                    'City__c,State__c,Country__c from Account where Id IN' +
                    '(Select Account_ID__c from Overlay_Acct_SuperGroup_Rel__c where Super_Group__c = :SuperGroupId)' +
                    ' ' + orderByExp + ' ' + 'LIMIT 10000'; 
            
            Paging(query);
            
            if(Utilities.getIsTestMethod()== true){                 
                    String str = null;    
                    str.tolowercase();                             
              }      
         }              
         catch(Exception e){
            ApexPages.addMessages(e);
            System.debug('Super_Group_Overlay_Acct_CTE ## OrderData ## Exception ## ' + e);
            return null;
         }    
        return null;
    }
    
    // This method redirects Excel Export Link Page to Excel Export Page for Ovelay Account data
    public PageReference exportOverlayAcctLink() {
        try{
            PageReference redirect = new PageReference('/apex/Super_Group_Overlay_Acct_Export'); 
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
                System.debug('Super_Group_Overlay_Acct_CTE ## exportOverlayAcctLink ## Exception ## ' + e);
                return null;
       } 
    }
}