/******************************************************************************
Name    : CustomerGURenewalRollupToAccount
Author  : C360 Dev team
Purpose : Batch class for Renewal rollup summary
Created Date:  31/01/2019

*******************************************************************************/
global class CustomerGURenewalRollupToAccount implements Database.Batchable<sObject>,Database.Stateful{
    
    public String query;
    Id customerRecordTypeId = ObjectRecordTypeIds__c.getInstance().Account_Customer_RecordType_18__c;
    Id CustomerBUID = ObjectRecordTypeIds__c.getInstance().Account_BU_RecordType_18__c;
    Id endcustomerRT = ObjectRecordTypeIds__c.getInstance().Account_End_User_RT_18__c;
    // SCAVA Helper Method to validate Create Access at field level
     public static Boolean flsGet(SObjectField field){
        return field.getDescribe().isCreateable() ? true : false;
    }
    global CustomerGURenewalRollupToAccount(String qry){     
         query=qry;
         system.debug('query----->'+query);
    }
   
         
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope){        
        Map<String,List<Account>> accountMap = new Map<String,List<Account>>();
        Map<String,List<Account>> parentAccountMap = new Map<String,List<Account>>();
      
      //Scope return End user accounts where RenewaloptyRollup >0 and ForecastedAttritionRollup > 0
      system.debug('scope==='+scope);
        for(Account acc:scope){
            if(acc.ParentId != null){
                if(!accountMap.containskey(acc.ParentId)){
                  List<Account> acclist = new List<Account>();
                  acclist.add(acc);
                  accountMap.put(acc.ParentId,acclist);
                } else{
                  List<Account> acList= accountMap.get(acc.ParentId);
                  acList.add(acc);
                  accountMap.put(acc.ParentId,acList);
                }
            }
         }
    system.debug('===accountMap'+accountMap);
     //Logic to iterate BU List with its Child End User accounts and setting Sum of CustomerRollups and ForecastedAttrition into i,j and setting back i,j to BU List.
           Integer i=0;
           Double j=0;
           //Integer k=0;
           Integer l=0;
           List<Account> accBUList = new List<Account>();
           List<Account> buList = new List<Account>();
           if(accountMap!=null){
                for(string parentId:accountMap.keyset()){
                      accBUList = accountMap.get(parentId);
                     if(accBUList.size() > 0){
                        for(Account accmap:accBUList){
                            i += integer.valueof(accmap.Customer_Rollup_Renewals__c);
                            j += Double.valueof(accmap.Forecasted_Attrition_Rollup__c);
                            //k += integer.valueof(accmap.Roll_up_of_Total_Prior_ATR__c);
                            l += integer.valueof(accmap.Roll_up_of_Total_Expected_ATR__c);
                            
                        }
                        system.debug('i=='+i+'j==='+j+'l==='+l);
                        Account accbu= new Account();
                            accbu.Id = parentId;
                        if(flsGet(Account.Total_Upcoming_Renewals__c)){
                            accbu.Total_Upcoming_Renewals__c=i;
                        }
                        if(flsGet(Account.Forecasted_Attrition__c)){
                            accbu.Forecasted_Attrition__c=j;
                        }
                        //if(flsGet(Account.Available_to_Renew__c)){
                        //    accbu.Available_to_Renew__c=k;
                        //}
                        if(flsGet(Account.Renewal_Forecast__c)){
                            accbu.Renewal_Forecast__c=l;
                        }
                        buList.add(accbu);
                   }
                    i = 0;
                    j = 0;
                    //k = 0;
                    l = 0;
                }  
           }
        
            system.debug('===buList'+buList);
            //Update BUList with sum of TotalUpcoming and Forecasted Attrition
            if(buList.size()>0){
                update buList;
            }
            List<Account> customerList = new List<Account>();
            
           //Querying BU list to get customer data and mapping each customer to Its BU list.
            for(Account acc:[Select Id,Parent.RecordtypeId,ParentId,Total_Upcoming_Renewals__c,Forecasted_Attrition__c,Available_to_Renew__c,Renewal_Forecast__c,Roll_up_of_Total_Prior_ATR__c,Roll_up_of_Total_Expected_ATR__c,Name from Account where Id in: buList]){
                system.debug('====acc'+customerRecordTypeId+'=='+acc+'=='+acc.ParentId+'=='+acc.Parent.RecordtypeId+'=='+acc.Total_Upcoming_Renewals__c+'=='+acc.Roll_up_of_Total_Prior_ATR__c+'=='+acc.Roll_up_of_Total_Expected_ATR__c+'===='+acc.Forecasted_Attrition__c);
                if(acc.ParentId!=null && acc.Parent.RecordtypeId == customerRecordTypeId && (acc.Total_Upcoming_Renewals__c > 0 || acc.Forecasted_Attrition__c > 0 || acc.Available_to_Renew__c > 0 || acc.Renewal_Forecast__c > 0)){
                    if(!parentAccountMap.containskey(acc.ParentId)){
                          List<Account> acclist = new List<Account>();
                          acclist.add(acc);
                          parentAccountMap.put(acc.ParentId,acclist);
                    } else{
                          List<Account> acList= parentAccountMap.get(acc.ParentId);
                          acList.add(acc);
                          parentAccountMap.put(acc.ParentId,acList);
                    }
                }
            }  
            
           //Logic to iterate customers with its Child BU Accounts and setting Sum of TotalRenewals and ForecatedAttrition into k,l and setting back k,l to Customers
           Integer m=0;
           Double n=0;
           //Integer o=0;
           Integer p=0;
           List<Account> accCustomerList = new List<Account>();
           List<Account> parentBuList = new List<Account>();
           if(parentAccountMap!=null){
                for(string topParentId:parentAccountMap.keyset()){
                    accCustomerList = parentAccountMap.get(topParentId);
                    if(accCustomerList.size()>0){
                        for(Account accmap:accCustomerList){
                            if(flsGet(Account.Total_Upcoming_Renewals__c)){
                                m = m + integer.valueof(accmap.Total_Upcoming_Renewals__c);
                            }
                            if(flsGet(Account.Forecasted_Attrition__c)){
                                n = n + Double.valueof(accmap.Forecasted_Attrition__c);
                            }
                            //if(flsGet(Account.Available_to_Renew__c)){
                            //    o = o + integer.valueof(accmap.Available_to_Renew__c);
                            //}
                            if(flsGet(Account.Renewal_Forecast__c)){
                                p = p + integer.valueof(accmap.Renewal_Forecast__c);
                            }
                        }
                        system.debug('m=='+m+'n==='+n+'p==='+p);
                        Account acc = new Account();
                        acc.Id =topParentId;
                        if(flsGet(Account.Total_Upcoming_Renewals__c)){
                            acc.Total_Upcoming_Renewals__c=m;
                        }
                        if(flsGet(Account.Forecasted_Attrition__c)){
                            acc.Forecasted_Attrition__c=n;
                        }
                        //if(flsGet(Account.Available_to_Renew__c)){
                        //    acc.Available_to_Renew__c=o;
                        //}
                        if(flsGet(Account.Renewal_Forecast__c)){
                            acc.Renewal_Forecast__c=p;
                        }
                        parentBuList.add(acc);
                    }
                    m = 0;
                    n = 0;
                    //o = 0;
                    p = 0;
                } 
            }
 
            if(parentBuList.size()>0){
                update parentBuList;
            }
    }    
    
    global void finish(Database.BatchableContext BC){
        sendEmail(BC.getJobId());
    }
        
    global void sendEmail(Id JobId){  //Email functionality after batch processing
       
    }   
}