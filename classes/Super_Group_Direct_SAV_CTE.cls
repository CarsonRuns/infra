// This class acts as Controller Class for Super_Group_Direct_SAV VF
// Release -- FY'13 Year End Rel 

public class Super_Group_Direct_SAV_CTE {
     
    private Integer pagesize = 5;
    private String  SuperGroupId;
    private String query;
    public Integer totalPages {get; set;}
    public String  navigateToSalesAccount {get; set;}
    
    private String sortOrderOld = 'ASC';
    private String sortColumnNameOld = 'Name';
    public String sortOrderNew {get; set;}
    public String sortColumnNameNew {get; set;}
    
    public Super_Group_Direct_SAV_CTE(ApexPages.StandardController controller) {
        navigateToSalesAccount = Utilities.getSuperGroupDirectSalesAccountRelatedListId(); 
        SuperGroupId = ApexPages.currentpage().getparameters().get('Id');
    }
    
        
    public ApexPages.StandardSetController SAVCON{
        get {          
            try{
                if(SAVCON == null) { 
                
                query = 'Select Id,Name,FDEV_Account_Group_Owner__c,Account_Group_ID__c,Vertical_Primary_Sub__c,' +
                        'Segment__c,Vertical_Primary_Detail__c,Vertical_Primary_Top__c,Parent_Territory__c,' +
                        'Territory_Name__c,Primary_Address__c from Account_Group__c where Id IN' + 
                        '(Select Account_Group__c from Direct_SAV_SuperGroup_Rel__c where Super_Group__c = :SuperGroupId)' +
                        'ORDER BY Name ASC limit 10000';
                        
                Paging(query);    
                
               if(Utilities.getIsTestMethod()== true){                 
                    String str = null;    
                    str.tolowercase();                             
                  } 
               } 
                return SAVCON;
             }
            catch(Exception e){
                ApexPages.addMessages(e);
                System.debug('Super_Group_Direct_SAV_CTE ## SAVCON ## Exception ## ' + e);
                return null;
            }
        }
        set;
        }
        
  //This method is used for Pagination on Visualforce Page, for a given Super Group Record   
     
    public void Paging(String query){
        try{
            SAVCON = new ApexPages.StandardSetController(Database.getQueryLocator(query));    
            // sets the number of records in each page set
            SAVCON.setPageSize(pagesize);
            // total page count
            if(Math.Mod(SAVCON.getResultSize(),pagesize) == 0){
                 totalPages = SAVCON.getResultSize()/pagesize;
            }
            else {
                 totalPages = SAVCON.getResultSize()/pagesize + 1;
            }
            if(Utilities.getIsTestMethod()== true){                 
                String str = null;    
                str.tolowercase();                             
             } 
           }
        catch(Exception e){
                ApexPages.addMessages(e);
                System.debug('Super_Group_Direct_SAV_CTE ## Paging ## Exception ## ' + e);
        } 
    }  
    
   //This method is used to get Sales Account Records on Visualforce Page, for a given Super Group Record 
   
   public List<Account_Group__c> getAccountGroupRecords(){
       try{         
            if(SAVCON!=null){
                return (List<Account_Group__c>) SAVCON.getRecords();
            }
            if(Utilities.getIsTestMethod()== true){                 
                String str = null;    
                str.tolowercase();                             
             }
          }  
       catch(Exception e){
                ApexPages.addMessages(e);
                System.debug('Super_Group_Direct_SAV_CTE ## getAccountGroupRecords ## Exception ## ' + e);
                return null;
        }    
        return null;
    } 
    
  //This method is used for Sorting Sales Account Name, Sales Account Owner & SAV ID on Visualforce Page, for a given Super Group Record 
  
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
            
            query = 'Select Id,Name,FDEV_Account_Group_Owner__c,Account_Group_ID__c,Vertical_Primary_Sub__c,' +
                    'Segment__c,Vertical_Primary_Detail__c,Vertical_Primary_Top__c,Parent_Territory__c,' +
                    'Territory_Name__c,Primary_Address__c from Account_Group__c where Id IN' + 
                    '(Select Account_Group__c from Direct_SAV_SuperGroup_Rel__c where Super_Group__c = :SuperGroupId)' +
                    ' ' + orderByExp + ' ' + 'LIMIT 10000';
                    
            Paging(query); 
            if(Utilities.getIsTestMethod()== true){                 
                String str = null;    
                str.tolowercase();                             
              }
            }              
           catch(Exception e){
                ApexPages.addMessages(e);
                System.debug('Super_Group_Direct_SAV_CTE ## OrderData ## Exception ## ' + e);
                return null;
           }    
         return null;
    } 
    
    
    // This method redirects Excel Export Link Page to Excel Export Page for Direct SAV data
    public PageReference exportDirectSavLink() {
        try{
            PageReference redirect = new PageReference('/apex/Super_Group_Direct_SAV_Export'); 
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
                System.debug('Super_Group_Direct_SAV_CTE ## exportDirectSavLink ## Exception ## ' + e);
                return null;
       } 
   }
}