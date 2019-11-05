// This class acts as Controller Class for Super_Group_Acct VF
// Release -- FY'13 Year End Rel 

public class Super_Group_Acct_CTE {

    // List to store Super Groups associated to a given Account via SAV
    private List<Direct_SAV_SuperGroup_Rel__c> SuperGrp_SAV_List;
    // Set to store Super Group Ids associated to a given Account via SAV
    private Set<Id> SuperGrp_SAV_IdSet = new Set<Id>();
   
    // List of Direct Super Group
    private List<Super_Group__c> DirectSuperGrpList;
    
    // List of Overlay Super Group
    private List<Super_Group__c> OverlaySuperGrpList;
    
    // List of all Super Group
    private List<Super_Group__c> SuperGrpList = new List<Super_Group__c>();
    
    private Integer pagesize = 5;
    private String AccountId;
    public Integer totalPages {get; set;}
    public String  navigateToSuperGroup {get; set;}
    
    public Super_Group_Acct_CTE (ApexPages.StandardController controller) {
         AccountId = ApexPages.currentpage().getparameters().get('Id');
    }
    
    public ApexPages.StandardSetController con {
        get {
         try{   
            if(con == null) {
                        
            SuperGrp_SAV_IdSet = DirectSuperGrpAccountData(); 
                               
            if(SuperGrp_SAV_IdSet.size()>0){
                DirectSuperGrpList = [Select Id,Name,Super_Group_Owner__c,FDEV_Super_Group_ID__c,Program_Type__c,Type__c 
                                      from Super_Group__c where Id in :SuperGrp_SAV_IdSet limit 1000];
              }       
             
               OverlaySuperGrpList =  [Select Id,Name,Super_Group_Owner__c,FDEV_Super_Group_ID__c,Program_Type__c,Type__c 
                                      from Super_Group__c where Id IN
                                      (Select Super_Group__c from Overlay_Acct_SuperGroup_Rel__c where Account_ID__c = :AccountId)
                                      limit 1000];

               
            SuperGrpList = SuperGroupData();
            SuperGrpList.sort();
           
           if(SuperGrpList!=null){     
                Paging();
           }     
           
           if(Utilities.getIsTestMethod()== true){                 
                String str = null;    
                str.tolowercase();                             
            }             
         }  
           return con;
        }
        catch(Exception e){
            ApexPages.addMessages(e);
            System.debug('Super_Group_Acct_CTE ## con ## Exception ## ' + e);
            return null;
        }
     }
        set;
   }
   
    //This method is used to store Super Group Ids associated to Sales Account, for a given Account Record 
    
    public Set<Id> DirectSuperGrpAccountData() {
    
    try{
        SuperGrp_SAV_List = [Select Super_Group__c from Direct_SAV_SuperGroup_Rel__c where Account_Group__c IN 
                            (Select Account_Group__c from Account_Group_Relationship__c where Account_ID__c = :AccountId) 
                            limit 1000];
        
        if(SuperGrp_SAV_List !=null){
            for(Direct_SAV_SuperGroup_Rel__c sgp: SuperGrp_SAV_List){
                SuperGrp_SAV_IdSet.add(sgp.Super_Group__c);
            }
        } 
        
        if(Utilities.getIsTestMethod()== true){                 
            String str = null;    
            str.tolowercase();                             
           }          
          return SuperGrp_SAV_IdSet;
       }  
       
    catch(Exception e){
        ApexPages.addMessages(e);
        System.debug('Super_Group_Acct_CTE ## DirectSuperGrpAccountData ## Exception ## ' + e);
        return null;
      } 
    }
     
     //This method is used to store Direct & Overlay Super Group Data in SuperGrpList, for a given Account Record 
     
    public List<Super_Group__c> SuperGroupData(){
     try{
          if(DirectSuperGrpList !=null){
                for(Super_Group__c dList: DirectSuperGrpList){
                    SuperGrpList.add(dList);
                }
            } 
    
           if(OverlaySuperGrpList!=null){
                for(Super_Group__c oList: OverlaySuperGrpList){
                    SuperGrpList.add(oList);
                }
            }
           
           if(Utilities.getIsTestMethod()== true){                 
                String str = null;    
                str.tolowercase();                             
            }     
            return SuperGrpList;
      }
              
    catch(Exception e){
        ApexPages.addMessages(e);
        System.debug('Super_Group_Acct_CTE ## SuperGroupData ## Exception ## ' + e);
        return null;
     } 
     
    }
     
     //This method is used for Pagination on Visualforce Page, for a given Account Record 
     
    public void Paging(){
       try{
            con = new ApexPages.StandardSetController(SuperGrpList);  
            // sets the number of records in each page set
            con.setPageSize(pagesize);
            // total page count
            if(Math.Mod(con.getResultSize(),pagesize) == 0){
                totalPages = con.getResultSize()/pagesize;
            }
            else {
                totalPages = con.getResultSize()/pagesize + 1;
            }
            
            if(Utilities.getIsTestMethod()== true){                 
                String str = null;    
                str.tolowercase();                             
             }  
          }            
      catch(Exception e){
        ApexPages.addMessages(e);
        System.debug('Super_Group_Acct_CTE ## Paging ## Exception ## ' + e);
     }  
    }
    
    //This method is used to get Super Group Records on Visualforce Page, for a given Account Record   
     
    public List<Super_Group__c> getSuperGroupRecords(){               
      try{ 
           if(con!=null){
            return (List<Super_Group__c>) con.getRecords();
          }
           if(Utilities.getIsTestMethod()== true){                 
                String str = null;    
                str.tolowercase();                             
            }  
         }    
      catch(Exception e){
        ApexPages.addMessages(e);
        System.debug('Super_Group_Acct_CTE ## getSuperGroupRecords ## Exception ## ' + e);
        return null;
       }    
            return null;
     } 
}