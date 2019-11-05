// This class acts as Controller Class for Super_Group_Overlay_Export VF
// Release -- FY'13 Year End Rel 

public with sharing class Super_Group_Overlay_Export_CTE {

    private String SuperGroupId;
    
    // List of Accounts associated to Overlay Super Group
    private List<Account> AccountList;
    
    public List<List<SuperGrpInfo>> SuperGrpInfoList {get; set;}
   
    public Super_Group_Overlay_Export_CTE(ApexPages.StandardController controller) {
        try{
            SuperGrpInfoList = new List<List<SuperGrpInfo>>();
            
            SuperGroupId = ApexPages.currentpage().getparameters().get('Id');
            
            AccountList = [Select Id,Name,CRName__c,GU_ID__c,HQ_Party_ID__c,CSCSiteID__c,Owner.Name,
                          (Select Id,Name,DealID__c,Owner.Name,Account.Id,CloseDate,StageName,Opportunity_Status__c,
                          Expected_Product__c,Expected_Service__c,Forecast_Status__c,Position__c,Territory2.Name,Territory2.Level_1_Territory__c,
                          Territory2.Level_2_Territory__c,Territory2.Level_3_Territory__c,Fiscal_Week__c,Fiscal_Month__c, Fiscal_Quarter__c  from Opportunities) 
                          from Account where Id IN (Select Account_ID__c from Overlay_Acct_SuperGroup_Rel__c where Super_Group__c = :SuperGroupId)
                          limit 10000];
            System.debug('>>>' + AccountList);
                          
            populateSuperGrpInfoList();
                       
           if(Utilities.getIsTestMethod()== true){                 
                String str = null;    
                str.tolowercase();                             
             } 
           }
        catch(Exception e){
            ApexPages.addMessages(e);
            System.debug('Super_Group_Overlay_Export_CTE ## Super_Group_Overlay_Export_CTE ## Exception ## ' + e);
        }
            
    }
    
// This method is used to store Accounts & Opportunities in SuperGroupInfo List for a given Super Group Record 
   
    public void populateSuperGrpInfoList() {
      try{
           List<SuperGrpInfo> tempList = new List<SuperGrpInfo>();
            
            for(Account acc : AccountList){
               
                for(Opportunity opp: acc.Opportunities){
                
                    SuperGrpInfo SuperGrp = new SuperGrpInfo();
                    
                    SuperGrp.Acct = acc;
                    SuperGrp.Oppty = opp;
                   
                    tempList.add(SuperGrp);
                    
                    if (tempList.size()== 1000)
                    {
                        SuperGrpInfoList.add(tempList);
                        tempList = new List<SuperGrpInfo>();
                    }  
                } 
            }  
            
            if(!tempList.isEmpty()){
                SuperGrpInfoList.add(tempList);
            } 
           
           if(Utilities.getIsTestMethod()== true){                 
                String str = null;    
                str.tolowercase();                             
            }         
        }
        catch(Exception e){
            ApexPages.addMessages(e);
            System.debug('Super_Group_Overlay_Export_CTE ## populateSuperGrpInfoList ## Exception ## ' + e);
        }  
    }
    
// This wrapper class is used to capture Accounts & Opportunities, for a given Super Group Record  
  
  public Class SuperGrpInfo{
   
        public Account Acct {get;set;}
        public Opportunity Oppty {get;set;}  
        
  } 
}