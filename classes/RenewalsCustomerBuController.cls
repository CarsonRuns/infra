public class RenewalsCustomerBuController {
    
    /*
@ Created /Modified : Apr 04,2019
* @description : Method to get Customer Details in side component of Renewal Opportunity
* @param : Oppty Id 
* @return : ResultWrapper
*/ 
    @auraEnabled
    public static ResultWrapper getCustomerDetail(id opp){
        
        Map<String,String> labelAccountMap = new Map<String,String>();
        
        // Fetch recordType details from Custom setting
        String opptyRenewalRecordTypeId = Utilities.getOpptyRenewalRecordTypeId();
        ObjectRecordTypeIds__c objRecordTypeSettingBu = ObjectRecordTypeIds__c.getOrgDefaults();
        String AccountBURecordTypeId = objRecordTypeSettingBu.Account_BU_RecordType_18__c;
        String AccountCustomerRecordTypeId = objRecordTypeSettingBu.Account_Customer_RecordType_18__c;
        list<sobject> custList = new list<sobject>();
        try{
            custList=[SELECT account.parent.parent.name,convertCurrency(account.parent.Parent.Annual_Recurring_Revenue_ARR__c),convertCurrency(account.parent.parent.Available_to_Renew__c) ,account.parent.parent.Renewal_Rate__c,convertCurrency(account.parent.parent.Total_Customer_Value__c),convertCurrency(account.parent.parent.Increment_Annual_Recurring_Revenue__c),account.parent.parent.Total_Upcoming_Renewals__c,account.parent.parent.Assigned_CSE__r.Name
                      FROM opportunity WHERE id=:opp AND  recordtype.id=:opptyRenewalRecordTypeId AND (account.parent.recordtype.id=:AccountBURecordTypeId OR account.parent.parent.recordtype.id=:AccountCustomerRecordTypeId)];
        }
        catch(Exception e){
            
        }
        labelAccountMap = RenewalsUtilities.getAccountLabelNames();
        ResultWrapper rw = new ResultWrapper();
        rw.customerbuList = custList;
        rw.labelNameMap = labelAccountMap;
        
        return rw;
    }  
    
    /*
@ Created /Modified : Apr 04,2019
* @description : Method to get BU Details in side component of Renewal Opportunity
* @param : Oppty Id 
* @return : ResultWrapper
*/  @auraEnabled
    public static ResultWrapper getCustomerBuDetails(id opp){
        
        Map<String,String> labelAccountMap = new Map<String,String>();
        
        // Fetch recordType details from Custom setting
        String opptyRenewalRecordTypeId = Utilities.getOpptyRenewalRecordTypeId();
        ObjectRecordTypeIds__c objRecordTypeSettingBu = ObjectRecordTypeIds__c.getOrgDefaults();
        String AccountBURecordTypeId = objRecordTypeSettingBu.Account_BU_RecordType_18__c;
        String AccountCustomerRecordTypeId = objRecordTypeSettingBu.Account_Customer_RecordType_18__c;
        list<sobject> custBuList = new list<sobject>();
        try{
            custBuList=[SELECT Account.Parent.Parent.Name,Account.Parent.Name,convertCurrency(Account.Parent.Annual_Recurring_Revenue_ARR__c),convertCurrency(Account.Parent.Available_to_Renew__c),Account.Parent.Renewal_Rate__c,convertCurrency(account.parent.Total_Customer_Value__c),convertCurrency(account.parent.Increment_Annual_Recurring_Revenue__c),account.parent.Total_Upcoming_Renewals__c,account.parent.Assigned_CSE__r.Name
                        FROM opportunity WHERE id=:opp AND recordtype.id=:opptyRenewalRecordTypeId AND (account.parent.recordtype.id=:AccountBURecordTypeId OR account.parent.parent.recordtype.id=:AccountCustomerRecordTypeId)];
        }
        catch(Exception e){
            
        }
        labelAccountMap = RenewalsUtilities.getAccountLabelNames();
        
        ResultWrapper rw = new ResultWrapper();
        rw.customerbuList = custBuList;
        rw.labelNameMap = labelAccountMap;
        return rw;
    }
    
    /*
@ Created /Modified : Apr 04,2019
* @description : Method to get Customer , BU and Account details for breadcrumb component for renewal opportunities
* @param : Oppty Id 
* @return : list
*/ 
    @AuraEnabled
    public static ResultWrapper getbn(Id opppid){
        
        
        // Fetch recordType details from Custom setting
        String opptyRenewalRecordTypeId = Utilities.getOpptyRenewalRecordTypeId();
        ObjectRecordTypeIds__c objRecordTypeSettingBu = ObjectRecordTypeIds__c.getOrgDefaults();
        String AccountBURecordTypeId = objRecordTypeSettingBu.Account_BU_RecordType_18__c;
        String AccountCustomerRecordTypeId = objRecordTypeSettingBu.Account_Customer_RecordType_18__c;
        list<Opportunity> hiearchyList = new list<Opportunity>();
        //Variables to display hyperlink-sprint6
        boolean isCustomerHypervisible = false;
        boolean isBuHypervisible = false;
        boolean isAccountHypervisible = false;
        string assignedCseBU;
        string assignedCseCustomer;
        //Get user profile to display customer bu hyperlink-sprint 6
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        //Get custom setting value to display hyperlink in breadcrum-sprint 6
        Renewals_Portfolio__c renewals = Renewals_Portfolio__c.getOrgDefaults();
        boolean bnHyperlinkvisible = renewals.Bread_Crum_HyperLink_Visible__c;
        //Get profiles from org constant - start 
        Map<string,string> renewalsprofilemap = new Map<string,string>();
        String rprofileId = Userinfo.getProfileId();
        String rprofileIds  = rprofileId.substring(0,15);
        string renewalId = Utilities.getConstant_CS('RenewalManagerProfile');
        string[] renewalIds;
        if(renewalId != null){
            renewalIds = renewalId.split(';');
            for(string stIds : renewalIds){
                renewalsprofilemap.put(stIds,stIds);
            }
        }
       //Get profiles from org constant - end  
        
        try{
            hiearchyList=[SELECT id,name,Account.name,Account.parent.Assigned_CSE__r.Name,Account.parent.parent.Assigned_CSE__r.Name,Account.parent.name,Account.Parent.Parent.Name 
                          FROM Opportunity WHERE id=:opppid AND  recordtype.id=:opptyRenewalRecordTypeId AND (account.parent.recordtype.id=:AccountBURecordTypeId OR account.parent.parent.recordtype.id=:AccountCustomerRecordTypeId)];
        }
        catch(Exception e){}
        if(!hiearchyList.isEmpty()){ 
            for(Opportunity opp : hiearchyList){
                assignedCseBU = opp.Account.parent.Assigned_CSE__r.Name;
                assignedCseCustomer = opp.Account.parent.parent.Assigned_CSE__r.Name;
            }
        }
        if(renewalsprofilemap.containsKey(rprofileIds) || renewalsprofilemap.containsKey(rprofileId)){
            if(assignedCseCustomer != NULL && bnHyperlinkvisible){
                isCustomerHypervisible = true;
            }
            if(assignedCseBU != NULL && bnHyperlinkvisible){
                isBuHypervisible = true;
            }
            if(bnHyperlinkvisible){
                isAccountHypervisible = true;
            }
        }
        ResultWrapper rw = new ResultWrapper();
        rw.breadcrumhiearchyList = hiearchyList;
        rw.isCustomerHyperLinkVisible = isCustomerHypervisible;
        rw.isBuHyperLinkVisible = isBuHypervisible;
        rw.isAccountHyperLinkVisible = isAccountHypervisible;
        return rw;
    }
    
    public class  ResultWrapper{
        @AuraEnabled public List<sobject> customerbuList{get;set;}
        @AuraEnabled public Map<String,String> labelNameMap{get;set;}
        
        @AuraEnabled public List<Opportunity> breadcrumhiearchyList{get;set;}
        @AuraEnabled public boolean isCustomerHyperLinkVisible{get;set;}
        @AuraEnabled public boolean isBuHyperLinkVisible{get;set;}
        @AuraEnabled public boolean isAccountHyperLinkVisible{get;set;}
        
        
    }
    
}