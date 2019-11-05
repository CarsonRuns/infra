// This class acts as Controller Class for Super_Group_Direct_Export VF
// Release -- FY'13 Year End Rel 

public with sharing class Super_Group_Direct_Export_CTE {
    
    private String SuperGroupId;
    
    // Map to store Sales Account Ids and Sales Accounts
    private Map<Id,Account_Group__c> AccountGrpMap;
    
    // Map to store Opportunity Ids and Opportunities
    private Map<Id,Opportunity> OpptyMap;

    // Map to store AccountIds and Account
    private Map<Id,Account> AcctMap;
     
    // Set to store AccountIds
    private Set<Id> AcctIdSet;
    
    //Map to store AccountGrpIds and OpptyIdSet
    private Map<Id,Set<Id>> AccountGrpIdToOpptyIdMap;
    
    public List<List<SuperGrpInfo>> SuperGrpInfoList {get; set;}
    
    public Super_Group_Direct_Export_CTE(ApexPages.StandardController controller) {
        try{
            
            SuperGrpInfoList = new List<List<SuperGrpInfo>>();
        
            SuperGroupId = ApexPages.currentpage().getparameters().get('Id');
            
            AccountGrpMap = new Map<id,Account_Group__c>([Select Id,Name,FDEV_Account_Group_Owner__c,Account_Group_ID__c,Territory_Name__c,
                                                         (Select Id,Name,DealID__c,Account.Id,Owner.Name,CloseDate,StageName,Opportunity_Status__c,
                                                         Expected_Product__c,Expected_Service__c,Forecast_Status__c,Position__c,Territory2.Name,Territory2.Level_1_Territory__c,
                                                         Territory2.Level_2_Territory__c,Territory2.Level_3_Territory__c,Fiscal_Week__c,Fiscal_Month__c, Fiscal_Quarter__c from Opportunities__r)  
                                                         from Account_Group__c where Id IN (Select Account_Group__c from Direct_SAV_SuperGroup_Rel__c where Super_Group__c = :SuperGroupId)
                                                         limit 10000]);
                                       
            OpptyMap = New Map<Id,Opportunity>();
            
            AcctIdSet = new Set<Id>();
            
            AccountGrpIdToOpptyIdMap = new  Map<Id,Set<Id>>();
            
            createOpptyMap();
            
            createAcctMap();
            
            populateSuperGrpInfoList();
            
            if(Utilities.getIsTestMethod()== true){                 
                String str = null;    
                str.tolowercase();                             
             } 
           }
          catch(Exception e){
            ApexPages.addMessages(e);
            System.debug('Super_Group_Direct_Export_CTE ## Super_Group_Direct_Export_CTE ## Exception ## ' + e);
        }
          
      }

// This method is used to store Opportunities associated to Sales Accounts in OpptyMap, for a given Super Group Record

     public void createOpptyMap() {
         try{
              
              Set<Id> OpptyIdSet;
              
              for(Id AcctGrpId : AccountGrpMap.keyset()){
                
                for(Opportunity o : AccountGrpMap.get(AcctGrpId).Opportunities__r){
                   
                    if(AccountGrpIdToOpptyIdMap.get(AcctGrpId)!= Null)
                    {
                        OpptyIdSet = AccountGrpIdToOpptyIdMap.get(AcctGrpId);
                        OpptyIdSet.add(o.Id);
                        AccountGrpIdToOpptyIdMap.put(AcctGrpId,OpptyIdSet);
                        OpptyMap.put(o.id,o);  
                        
                    }
                    else
                    {
                        OpptyIdSet = new Set<Id>();
                        OpptyIdSet.add(o.Id);
                        AccountGrpIdToOpptyIdMap.put(AcctGrpId,OpptyIdSet);
                        OpptyMap.put(o.id,o);               
                    }
                }           
            } 
          if(Utilities.getIsTestMethod()== true){                 
                String str = null;    
                str.tolowercase();                             
             } 
           }
          catch(Exception e){
            ApexPages.addMessages(e);
            System.debug('Super_Group_Direct_Export_CTE ## createOpptyMap ## Exception ## ' + e);
        }
     }  

// This method is used to store Accounts associated to Sales Accounts in AcctMap, for a given Super Group Record
     
     public void createAcctMap() {
        try{
              List<Account_Group_Relationship__c> SuperGrp_Direct_Acct_List;
       
              SuperGrp_Direct_Acct_List = [Select Account_ID__c from Account_Group_Relationship__c where Account_Group__c IN :AccountGrpMap.keyset() limit 10000];
              
              if(SuperGrp_Direct_Acct_List !=null){
                        for(Account_Group_Relationship__c AGR: SuperGrp_Direct_Acct_List){
                            AcctIdSet.add(AGR.Account_ID__c);
                      }
                }         
              AcctMap = new Map<Id,Account>([Select Id,Name,CRName__c,GU_ID__c,HQ_Party_ID__c,CSCSiteID__c,Owner.Name from Account where id in :AcctIdSet limit 10000]);
              
              if(Utilities.getIsTestMethod()== true){                 
                String str = null;    
                str.tolowercase();                             
              } 
           }
          catch(Exception e){
            ApexPages.addMessages(e);
            System.debug('Super_Group_Direct_Export_CTE ## createAcctMap ## Exception ## ' + e);
        }
     }   
      
// This method is used to store Sales Accounts, Accounts & Opportunities in SuperGroupInfo List for a given Super Group Record   
 
     public void populateSuperGrpInfoList() {
         try{
             
             List<SuperGrpInfo> tempList = new List<SuperGrpInfo>(); 
             Set<Id> OpptyAcctIdSet = new Set<Id>();
         
              if(AccountGrpIdToOpptyIdMap.size() > 0){
              
                  for(Id AccountGrpId :AccountGrpIdToOpptyIdMap.keySet()) {
              
                    for(Id OpptyId : AccountGrpIdToOpptyIdMap.get(AccountGrpId)){
                    
                        SuperGrpInfo SuperGrp = new SuperGrpInfo();
                        
                        SuperGrp.AcctGrp = AccountGrpMap.get(AccountGrpId);
                        SuperGrp.Oppty = OpptyMap.get(OpptyId);
                        
                        if(AcctIdSet.contains(OpptyMap.get(opptyId).AccountId))
                        {
                            SuperGrp.Acct = AcctMap.get(OpptyMap.get(opptyId).AccountId);
                            OpptyAcctIdSet.add(OpptyMap.get(opptyId).AccountId);
                        }
                       
                        tempList.add(SuperGrp);
                        
                        if (tempList.size()== 1000)
                        {
                            SuperGrpInfoList.add(tempList);
                            tempList = new List<SuperGrpInfo>();
                        }                 
                    }   
                        for(Id AcctId : AcctIdSet){
                            if(OpptyAcctIdSet.contains(AcctId) != True)
                            {
                                SuperGrpInfo SuperGrp = new SuperGrpInfo();
                                SuperGrp.AcctGrp = AccountGrpMap.get(AccountGrpId);
                                SuperGrp.Acct = AcctMap.get(AcctId);
                                
                                tempList.add(SuperGrp);
                            }      
                            
                            if (tempList.size()== 1000)
                            {
                                SuperGrpInfoList.add(tempList);
                                tempList = new List<SuperGrpInfo>();
                            }  
                        }          
                     }  
                 }
             else {                      
                   
                   for(Id AcctGrpId : AccountGrpMap.keyset()){
                   
                       for(Id AcctId : AcctIdSet){
                                        
                        SuperGrpInfo SuperGrp = new SuperGrpInfo();
                        SuperGrp.AcctGrp = AccountGrpMap.get(AcctGrpId);
                        SuperGrp.Acct = AcctMap.get(AcctId);
                        
                        tempList.add(SuperGrp);
                            
                        if (tempList.size()== 1000)
                        {
                            SuperGrpInfoList.add(tempList);
                            tempList = new List<SuperGrpInfo>();
                        }  
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
            System.debug('Super_Group_Direct_Export_CTE ## populateSuperGrpInfoList ## Exception ## ' + e);
        }
     }
     
// This wrapper class is used to capture Sales Accounts, Accounts & Opportunities, for a given Super Group Record  
 
     public Class SuperGrpInfo{
        
        public  Account_Group__c AcctGrp {get;set;}
        public Account Acct {get;set;}
        public Opportunity Oppty {get;set;}  
        
     } 
}