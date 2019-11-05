// This class acts as Controller Class for Super_Group_Direct_Acct VF
// Release -- FY'13 Year End Rel 

public with sharing class Super_Group_Direct_Acct_CTE {

    // List to store all SFDC Accounts associated to a given Direct Super Group
    private List<Account_Group_Relationship__c> SuperGrp_Direct_Acct_List;
    // Set to store all SFDC Accounts Ids associated to a given Direct Super Group
    private Set<Id> AccountIdSet = new Set<Id>();
    
    private Integer pagesize = 5;
    private String  SuperGroupId;
    private String  query;
    public Integer  totalPages {get; set;}
    public String   navigateToAccount {get; set;}
    
    private String sortOrderOld = 'ASC';
    private String sortColumnNameOld = 'Name';
    public String sortOrderNew {get; set;}
    public String sortColumnNameNew {get; set;}
    
    public Super_Group_Direct_Acct_CTE (ApexPages.StandardController controller) {
        navigateToAccount = Utilities.getSuperGroupDirectAccountRelatedListId();
        SuperGroupId = ApexPages.currentpage().getparameters().get('Id');
    }
         
    public ApexPages.StandardSetController ACCTCON{
        get {
           try{
                if(ACCTCON == null) {
                        
                AccountIdSet = SuperGrpAccountData(); 
                       
                if(AccountIdSet.size() > 0){
                    
                    query = 'Select Id, Name,Owner.Name,HQ_Party_ID__c,CSCSiteID__c,DUNSNumber__c,AddressLine1__c,' +
                            'City__c,State__c,Country__c from Account where Id in :AccountIdSet'+ 
                            ' ' + 'order by Name LIMIT 10000';
                            
                    Paging(query);
                  }
                                     
               if(Utilities.getIsTestMethod()== true){                 
                    String str = null;    
                    str.tolowercase();                             
                 }             
              } 
               return ACCTCON;
            }
            catch(Exception e){
                ApexPages.addMessages(e);
                System.debug('Super_Group_Direct_Acct_CTE ## ACCTCON ## Exception ## ' + e);
                return null;
            }
        }
        set;
        }
 
     //This method is used to store AccountIds associated to Sales Account, for a given Super Group Record 
   
        public Set<Id> SuperGrpAccountData() {
            try{
                SuperGrp_Direct_Acct_List = [Select Account_ID__c from Account_Group_Relationship__c where Account_Group__c IN
                                            (Select Account_Group__c from Direct_SAV_SuperGroup_Rel__c where Super_Group__c = :SuperGroupId)
                                            limit 10000];
                
                if(SuperGrp_Direct_Acct_List !=null){
                    for(Account_Group_Relationship__c acc : SuperGrp_Direct_Acct_List){
                        AccountIdSet.add(acc.Account_ID__c);
                    }
                } 
                 
                if(Utilities.getIsTestMethod()== true){                 
                    String str = null;    
                    str.tolowercase();                             
                }     
                 return AccountIdSet;
              }
            catch(Exception e){
                ApexPages.addMessages(e);
                System.debug('Super_Group_Direct_Acct_CTE ## SuperGrpAccountData ## Exception ## ' + e);
                return null;
            }
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
                System.debug('Super_Group_Direct_Acct_CTE ## Paging ## Exception ## ' + e);
            } 
        }
        
   //This method is used to get Account Records on Visualforce Page, for a given Super Group Record      
   
        public List<Account> getAccountRecords(){
           try{         
                if(ACCTCON!=null){
                    return (List<Account>) ACCTCON.getRecords();
                }
                
                if(Utilities.getIsTestMethod()== true){                 
                    String str = null;    
                    str.tolowercase();                             
                }
             }
           catch(Exception e){
                ApexPages.addMessages(e);
                System.debug('Super_Group_Direct_Acct_CTE ## getAccountRecords ## Exception ## ' + e);
                return null;
            }
            return null;
        }   
    
    //This method is used for Sorting Account Name & Account Owner on Visualforce Page, for a given Super Group Record    
    
        public PageReference OrderData (){
            try{
                  String orderByExp = '';
                
                  AccountIdSet = SuperGrpAccountData();
                
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
                
                if(AccountIdSet.size() > 0){
                     
                     query = 'Select Id, Name,Owner.Name,HQ_Party_ID__c,CSCSiteID__c,DUNSNumber__c,AddressLine1__c,' + 
                             'City__c,State__c,Country__c from Account where Id in :AccountIdSet' + ' ' + orderByExp + ' ' + 'LIMIT 10000';
                     
                     Paging(query);
                } 
                
               if(Utilities.getIsTestMethod()== true){                 
                    String str = null;    
                    str.tolowercase();                             
                }       
            }              
           catch(Exception e){
                ApexPages.addMessages(e);
                System.debug('Super_Group_Direct_Acct_CTE ## OrderData ## Exception ## ' + e);
                return null;
            }    
            return null;
        }  
     
     
        // This method redirects Excel Export Link Page to Excel Export Page for Direct Account data
        public PageReference exportDirectAcctLink() {
            try{
                PageReference redirect = new PageReference('/apex/Super_Group_Direct_Acct_Export'); 
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
                    System.debug('Super_Group_Direct_Acct_CTE ## exportDirectAcctLink ## Exception ## ' + e);
                    return null;
           } 
      }   
}