trigger P360_UpdatePSRFields on Lead (before insert, before update) {
  
/*  1. Created as part of P360 Sep '12 Release.
    2. Update Main PSR Lookup fields with the ID in the shadow field if any.
    3. Make Shadow text fields Null when Channel Partner changes.
    4. Populate PA user in PSR 1 lookup field when PA changes the Partner Leads Status to - 'Actively Working' OR 'Deal Created'.
    5. Update Latest Lead Acceptance Date when lead status changes to '2 Accepted-Mine/Channel'
    6. Update PSR assingned date when PA acting as PSR and Partner Assigned date when Partner Assigned.
    7. Added Logic to Update Country field with End Customer Account's Country field when there is a change in End Customer Account (Added by amohiddi on 05/07/14 as part of Q4FY14 release)
    8. Added Logic to Update Country field for Japan End Customer Accounts too. (amohiddi)
*/
        
    String usrIdPrefix = '005';
    String userId;  //Sting for getting the current user ID 
    User userObj; //User object for populating user record
    Lead_Status__c ls = Lead_Status__c.getInstance();    
    String AcceptedLeadStatus = ls.Accepted__c;
    set<Id> acctIdSet = new set<Id>();
    List<Account> acctList = new List<Account>();
    map<Id,Account> mapAccIdAccount=new map<id,Account>(); 
    List<Lead> accUpdateLeadLst=new List<Lead>();
    Account validAccount = new Account();
    
        if(Trigger.isInsert){                                      
            for(Lead lObj: Trigger.new){
                if(lObj.PSR_SYS1__c != null && lObj.PSR_SYS1__c.substring(0, 3) == usrIdPrefix){
                    lObj.PSR_1__c = lObj.PSR_SYS1__c;
                }                
                if(lObj.PSR_SYS2__c != null && lObj.PSR_SYS2__c.substring(0, 3) == usrIdPrefix){
                    lObj.PSR_2__c = lObj.PSR_SYS2__c;
                }               
                if(lObj.PSR_SYS3__c != null && lObj.PSR_SYS3__c.substring(0, 3) == usrIdPrefix){
                    lObj.PSR_3__c = lObj.PSR_SYS3__c;
                }
                if(lObj.Channel_Partner__c!=Null){
                 lObj.Partner_Assigned_Date__c = System.now();
                }               
                if(lObj.End_Customer_Account__c != null) {
                    acctIdSet.add(lObj.End_Customer_Account__c);
                    accUpdateLeadLst.add(lObj);                        
                }                               
            }
            //Update Lead Record's Country Field with the Country of End Customer Account for Chinese, Japan and Korean Accounts only
            // Query all the Country Information
            //Mukesh :adding criteria
            if(!acctIdSet.isEmpty())
            {
                for(Account a: [select id, Country__c, CRCountry__c from account where Id IN: acctIdSet]){
                    mapAccIdAccount.put(a.Id,a);
                }           
                // Iterate over the accUpdateLeadLst
                for(Lead l: accUpdateLeadLst){
                    validAccount = mapAccIdAccount.get(l.End_Customer_Account__c);
                    if(validAccount != null) {
                        if(mapAccIdAccount.get(l.End_Customer_Account__c).CRCountry__c != null && (mapAccIdAccount.get(l.End_Customer_Account__c).CRCountry__c.toUpperCase() == Org_Constant_CS__c.getValues('Country China').Production_Value__c || mapAccIdAccount.get(l.End_Customer_Account__c).CRCountry__c.toUpperCase() == Org_Constant_CS__c.getValues('Country Japan').Production_Value__c || mapAccIdAccount.get(l.End_Customer_Account__c).CRCountry__c.toUpperCase().contains(Org_Constant_CS__c.getValues('Country Korea').Production_Value__c)))
                        l.CustomCountry__c = mapAccIdAccount.get(l.End_Customer_Account__c).Country__c;
                    }
                }
            } 
        } 
        else if(Trigger.isUpdate){
            for(Lead lObj: Trigger.new){                              
                Lead oldLead = System.trigger.oldMap.get(lObj.Id);
    
                //Populating userId when the Partner Lead Status value changes to - 'Actively Working' or 'Deal Created'. 
                if(oldLead.Partner_Lead_Status__c == 'Partner Assigned' && (lObj.Partner_Lead_Status__c == 'Actively Working' || lObj.Partner_Lead_Status__c == 'Deal Created')){
                    userId = UserInfo.getUserId();
                }            
                
                //This is when you change the channel partner it will make the PSR ID/Name, PSR2 ID/Name, PSR3 ID/Name value to null.
                if(OldLead.Partner_Lead_Status__c != null && OldLead.Channel_Partner__c != lObj.Channel_Partner__c){
                    lObj.PSR_SYS1__c = null;
                    lObj.PSR_SYS2__c = null;
                    lObj.PSR_SYS3__c = null;
                }
                
                if((lObj.PSR_SYS1__c != null && lObj.PSR_SYS1__c.substring(0, 3) == usrIdPrefix && OldLead.PSR_SYS1__c != lObj.PSR_SYS1__c) || (lObj.PSR_SYS1__c == null && OldLead.PSR_SYS1__c != null)){
                    lObj.PSR_1__c = lObj.PSR_SYS1__c;
                }                
                if((lObj.PSR_SYS2__c != null && lObj.PSR_SYS2__c.substring(0, 3) == usrIdPrefix && OldLead.PSR_SYS2__c != lObj.PSR_SYS2__c) || (lObj.PSR_SYS2__c == null && OldLead.PSR_SYS2__c != null)){
                    lObj.PSR_2__c = lObj.PSR_SYS2__c;
                }            
                if((lObj.PSR_SYS3__c != null && lObj.PSR_SYS3__c.substring(0, 3) == usrIdPrefix && OldLead.PSR_SYS3__c != lObj.PSR_SYS3__c) || (lObj.PSR_SYS3__c == null && OldLead.PSR_SYS3__c != null)){
                    lObj.PSR_3__c = lObj.PSR_SYS3__c;
                }
                
                // Update Latest Lead Acceptance Date when lead status changes to '2 Accepted-Mine/Channel'
                if(OldLead.Status != lObj.Status && lObj.status == AcceptedLeadStatus){
                    lObj.Latest_Lead_Acceptance_Date__c = System.now();
                }
                if((lObj.Channel_Partner__c != Trigger.OldMap.get(lObj.Id).Channel_Partner__c) && lObj.Channel_Partner__c!=Null){
                    lObj.Partner_Assigned_Date__c = System.now();
                }
                
                // Update Lead Record's Country Field to the Country of End Customer Account when there is a change in End Customer Account for Chinese, Japan and Korean Accounts only               
                if(lObj.End_Customer_Account__c != null && OldLead.End_Customer_Account__c != lObj.End_Customer_Account__c){
                    acctIdSet.add(lObj.End_Customer_Account__c);
                    accUpdateLeadLst.add(lObj);                        
                }       
            }      
            //map<Id,Account> mapAccIdAccount=new map<id,Account>();
            // Query all the Country Information
            // Mukesh: Adding Criteria 
            if(!acctIdSet.isEmpty())
            {
                for(Account a: [select id, Country__c, CRCountry__c from account where Id IN: acctIdSet]){
                    mapAccIdAccount.put(a.Id,a);
                }
                           
                // Iterate over the accUpdateLeadLst
                for(Lead l: accUpdateLeadLst){
                    validAccount = mapAccIdAccount.get(l.End_Customer_Account__c);
                    if(validAccount != null) {
                        if(mapAccIdAccount.get(l.End_Customer_Account__c).CRCountry__c != null && (mapAccIdAccount.get(l.End_Customer_Account__c).CRCountry__c.toUpperCase() == Org_Constant_CS__c.getValues('Country China').Production_Value__c || mapAccIdAccount.get(l.End_Customer_Account__c).CRCountry__c.toUpperCase() == Org_Constant_CS__c.getValues('Country Japan').Production_Value__c || mapAccIdAccount.get(l.End_Customer_Account__c).CRCountry__c.toUpperCase().contains(Org_Constant_CS__c.getValues('Country Korea').Production_Value__c)))
                        l.CustomCountry__c = mapAccIdAccount.get(l.End_Customer_Account__c).Country__c;
                    }
                }
            }
        }        
    
    //Populate PA user in PSR 1 lookup field when PA changes the Partner Leads Status to - 'Actively Working' OR 'Deal Created'.
    if(userId != null){       
        userObj =  [Select Id, Name, UserRole.Name From User Where Id =:userId];
        if(Trigger.isBefore && Trigger.isUpdate){
            for(Lead lObj: Trigger.new){
                if(userObj.UserRole!=null && userObj.UserRole.Name.contains('Partner Executive')){
                    lObj.PSR_1__c = userObj.Id;
                    lObj.PSR_Assigned_Date__c = system.now();
                }
            }
        }
    }
}