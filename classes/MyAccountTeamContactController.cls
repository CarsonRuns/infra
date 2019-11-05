/************************************************************************************************************************************
Name    : MyAccountTeamContactController[QTR]
Author  : C360 Dev team
Purpose : Contains logic to execute on fetching and returing End-User Account Team Members on MyAccountTeamContact and AccountTeamChild components
Date    : 24/01/2019
Change History : none
*************************************************************************************************************************************/

public class MyAccountTeamContactController {
    //fetch total count of team members from End-user record related to offer and account(business and customer).
    @AuraEnabled
    public static Integer TotalTeamMembers(String sObjectId){
        Boolean isCustomerRT = false;
        List<AccountTeamMember> accTeamMember = new List<AccountTeamMember>();
        List<AggregateResult> lstTeamMem = new List<AggregateResult>();
        String keyPrefix = Account.sobjecttype.getDescribe().getKeyPrefix();
        if(sObjectId.startsWith(keyPrefix)){
            Id accountRecordtypeId = [SELECT Id, RecordtypeId FROM Account where Id =:sObjectId].RecordtypeId;
            ObjectRecordTypeIds__c accRTId = ObjectRecordTypeIds__c.getOrgDefaults();
            if(accountRecordtypeId == accRTId.Account_Customer_RecordTypeId__c){
                isCustomerRT = true;
            }
             lstTeamMem = Database.query('SELECT Count(Id),UserId,User.Name '+
                                        +' FROM AccountTeamMember '+
                                        +' WHERE ' + ((isCustomerRT) ? 'Account.Parent.ParentId=:sObjectId' : 'Account.ParentId=:sObjectId')
                                        + ' group by UserId,User.Name order by COUNT(Id) DESC,User.Name asc'
                                                          );
            Integer totalTeamMemCount = lstTeamMem.size();
            return totalTeamMemCount;
        }
        else {
            List<string> offerBUId = new List<string>();
            for(Offer__c off :[Select Id,name,Customer_BU_Name__c from offer__c where Id =:sObjectId]){
                offerBUId.add(off.Customer_BU_Name__c);
            }
             lstTeamMem = Database.query('SELECT Count(Id),UserId,User.Name '+
                                        +' FROM AccountTeamMember '+
                                        +' WHERE ' + ((isCustomerRT) ? 'Account.Parent.ParentId=:sObjectId' : 'Account.ParentId=:sObjectId')
                                        + ' group by UserId,User.Name order by COUNT(Id) DESC,User.Name asc'
                                                          );
            Integer totalTeamMemCount = lstTeamMem.size();
            return totalTeamMemCount;
        }  
    } 
    
    //fetch list of team membersto display in offer level and account(customer and business unit) level from End-User account record. 
    @AuraEnabled
    public static List<AccountTeamMember> getTeamLists(String sObjectId ) {
        Boolean isCustomerRT = false;
        List<AccountTeamMember> accTeamMember = new List<AccountTeamMember>();
        String keyPrefix = Account.sobjecttype.getDescribe().getKeyPrefix();
        if(sObjectId.startsWith(keyPrefix)){
            Id accountRecordtypeId = [SELECT Id, RecordtypeId FROM Account where Id =:sObjectId].RecordtypeId;
            ObjectRecordTypeIds__c accRTId = ObjectRecordTypeIds__c.getOrgDefaults();
            if(accountRecordtypeId == accRTId.Account_Customer_RecordTypeId__c){
                isCustomerRT = true;
            }
            /*List<AccountTeamMember> accTeamMem = Database.query('SELECT Id,AccountId,Account.Name,TeamMemberRole,UserId,User.Username,User.Name,User.SmallPhotoUrl,User.Alias '+
+' FROM AccountTeamMember '+
+' WHERE ' + ((isCustomerRT) ? 'Account.Parent.ParentId=:sObjectId' : 'Account.ParentId=:sObjectId')
);
if(accTeamMem.size()>0)  {return accTeamMem;}
else{return null;}*/
            Map<Id,AccountTeamMember> finalAccountTeamMember = new Map<Id,AccountTeamMember>();
            List<AggregateResult > lstTeamMem = new List<AggregateResult>();
            List<Id> setUserID = new List<Id>();
            lstTeamMem = Database.query('SELECT Count(Id),UserId,User.Name '+
                                        +' FROM AccountTeamMember '+
                                        +' WHERE ' + ((isCustomerRT) ? 'Account.Parent.ParentId=:sObjectId' : 'Account.ParentId=:sObjectId')
                                        + ' group by UserId,User.Name order by COUNT(Id) DESC,User.Name asc');
            
            if(lstTeamMem.size()>0){
                for (AggregateResult ar : lstTeamMem)  {
                    setUserID.add((Id)ar.get('UserId'));
                }
            }
            system.debug('=== user id count'+setUserID);
            List<AccountTeamMember> accTeamMemList = Database.query('SELECT Id,AccountId,Account.Name,TeamMemberRole,UserId,User.Username,User.Name,User.SmallPhotoUrl,User.Alias '+
                                                                    +' FROM AccountTeamMember '+
                                                                    +' WHERE ' + ((isCustomerRT) ? 'Account.Parent.ParentId=:sObjectId' : 'Account.ParentId=:sObjectId')
                                                                    
                                                                   );
            for(Id userIdRec: setUserID){
                for(AccountTeamMember accMem : accTeamMemList){
                    if(accMem.UserId == userIdRec){
                        finalAccountTeamMember.put(userIdRec,accMem);
                    }
                }
            }
            List<AccountTeamMember> finalList = new List<AccountTeamMember>();
            finalList.addAll(finalAccountTeamMember.values());
            if(finalList.size()>0)  {return finalList;}
            else{return null;}            
            
        }
        else {
            List<string> offerBUId = new List<string>();
            for(Offer__c off :[Select Id,name,Customer_BU_Name__c from offer__c where Id =:sObjectId]){
                offerBUId.add(off.Customer_BU_Name__c);
            }
            
            /*List<AccountTeamMember> accTeamMem = Database.query('SELECT Id,AccountId,Account.Name,TeamMemberRole,UserId,User.Username,User.Name,User.SmallPhotoUrl,User.Alias '+
+' FROM AccountTeamMember '+
+' WHERE ' + 'Account.ParentId in: offerBUId'
);  
if(accTeamMem.size()>0)  {return accTeamMem;}
else{return null;}*/
            Map<Id,AccountTeamMember> finalAccountTeamMember = new Map<Id,AccountTeamMember>();
            List<AggregateResult > lstTeamMem = new List<AggregateResult>();
            List<Id> setUserID = new List<Id>();
            lstTeamMem = Database.query('SELECT Count(Id),UserId,User.Name '+
                                        +' FROM AccountTeamMember '+
                                        +' WHERE ' + 'Account.ParentId in: offerBUId'
                                        + ' group by UserId,User.Name order by COUNT(Id) DESC,User.Name asc');
            
            if(lstTeamMem.size()>0){
                for (AggregateResult ar : lstTeamMem)  {
                    setUserID.add((Id)ar.get('UserId'));
                }
            }
            system.debug('=== user id count'+setUserID);
            List<AccountTeamMember> accTeamMemList = Database.query('SELECT Id,AccountId,Account.Name,TeamMemberRole,UserId,User.Username,User.Name,User.SmallPhotoUrl,User.Alias '+
                                                                    +' FROM AccountTeamMember '+
                                                                     +' WHERE ' + 'Account.ParentId in: offerBUId'
                                                                   
                                                                   );
            for(Id userIdRec: setUserID){
                for(AccountTeamMember accMem : accTeamMemList){
                    if(accMem.UserId == userIdRec){
                        finalAccountTeamMember.put(userIdRec,accMem);
                    }
                }
            }
            List<AccountTeamMember> finalList = new List<AccountTeamMember>();
            finalList.addAll(finalAccountTeamMember.values());
            if(finalList.size()>0)  {return finalList;}
            else{return null;}    
        }   
    } 
    //fetch list of team membersto display in offer level and account(customer and business unit) level from End-User account record on lazy load. 
    public static string ciscoBlog='https://directory.cisco.com/dir/reports/';
    @AuraEnabled
    public Static list<AccountTeamMemberWrapper> getAccountTeamMemberListLazy(Integer Limits,String sObjectId){ 
        Boolean isCustomerRT = false;
        List<AccountTeamMember> accTeamMember = new List<AccountTeamMember>();
        String keyPrefix = Account.sobjecttype.getDescribe().getKeyPrefix();
        if(sObjectId.startsWith(keyPrefix))
        {
            Id accountRecordtypeId = [SELECT Id, RecordtypeId FROM Account where Id =:sObjectId].RecordtypeId;
            ObjectRecordTypeIds__c accRTId = ObjectRecordTypeIds__c.getOrgDefaults();
            if(accountRecordtypeId == accRTId.Account_Customer_RecordTypeId__c){
                isCustomerRT = true;
            }
            /*List<AccountTeamMember> accTeamMem = Database.query('SELECT Id,AccountId,Account.Name,TeamMemberRole,UserId,User.Username,User.Name,User.SmallPhotoUrl,User.Alias '+
                +' FROM AccountTeamMember '+
                +' WHERE ' + ((isCustomerRT) ? 'Account.Parent.ParentId=:sObjectId' : 'Account.ParentId=:sObjectId')
                +' LIMIT ' + Integer.valueof(Limits)
                );
                system.debug('teammember'+accTeamMem.size());*/
            Map<Id,AccountTeamMember> finalAccountTeamMember = new Map<Id,AccountTeamMember>();
            List<AggregateResult > lstTeamMem = new List<AggregateResult>();
            List<Id> setUserID = new List<Id>();
            lstTeamMem = Database.query('SELECT Count(Id),UserId,User.Name '+
                                        +' FROM AccountTeamMember '+
                                        +' WHERE ' + ((isCustomerRT) ? 'Account.Parent.ParentId=:sObjectId' : 'Account.ParentId=:sObjectId')
                                        + ' group by UserId,User.Name order by COUNT(Id) DESC,User.Name asc'+
                                        + ' LIMIT ' + String.valueof(Limits));
            
            if(lstTeamMem.size()>0){
                for (AggregateResult ar : lstTeamMem)  {
                    setUserID.add((Id)ar.get('UserId'));
                }
            }
            system.debug('=== user id count'+setUserID);
            List<AccountTeamMember> accTeamMemList = Database.query('SELECT Id,AccountId,Account.Name,TeamMemberRole,UserId,User.Username,User.Name,User.SmallPhotoUrl,User.Alias '+
                                                                    +' FROM AccountTeamMember '+
                                                                    +' WHERE ' + ((isCustomerRT) ? 'Account.Parent.ParentId=:sObjectId' : 'Account.ParentId=:sObjectId') 
                                                                     );
                                                                   
            for(Id userIdRec: setUserID){
                for(AccountTeamMember accMem : accTeamMemList){
                    if(accMem.UserId == userIdRec){
                        finalAccountTeamMember.put(userIdRec,accMem);
                    }
                }
            }
            List<AccountTeamMember> accTeamMem = new List<AccountTeamMember>();
            accTeamMem.addAll(finalAccountTeamMember.values());
            List<AccountTeamMemberWrapper> accTeamList = new List<AccountTeamMemberWrapper>();
            for(AccountTeamMember acc : accTeamMem){
                String UserID = '/'+acc.UserId;
                String CiscoURL = ciscoBlog+acc.User.Alias;
                AccountTeamMemberWrapper teammember = new AccountTeamMemberWrapper(acc.User.Name,acc.User.Alias,acc.TeamMemberRole,UserID,CiscoURL);
                accTeamList.add(teammember);
            }
            if(accTeamList.size()>0)  {return accTeamList;}
            else{return null;}
        }
        else {
            List<string> offerBUId = new List<string>();
            for(Offer__c off :[Select Id,name,Customer_BU_Name__c from offer__c where Id =:sObjectId]){
                offerBUId.add(off.Customer_BU_Name__c);
            }
            
            Map<Id,AccountTeamMember> finalAccountTeamMember = new Map<Id,AccountTeamMember>();
            List<AggregateResult > lstTeamMem = new List<AggregateResult>();
            List<Id> setUserID = new List<Id>();
            lstTeamMem = Database.query('SELECT Count(Id),UserId,User.Name '+
                                        +' FROM AccountTeamMember '+
                                        +' WHERE ' + 'Account.ParentId in: offerBUId'
                                        + ' group by UserId,User.Name order by COUNT(Id) DESC,User.Name asc' +
                                         + ' LIMIT ' + String.valueof(Limits)
                                        );
            
            if(lstTeamMem.size()>0){
                for (AggregateResult ar : lstTeamMem)  {
                    setUserID.add((Id)ar.get('UserId'));
                }
            }
            system.debug('=== user id count'+setUserID);
            List<AccountTeamMember> accTeamMemList = Database.query('SELECT Id,AccountId,Account.Name,TeamMemberRole,UserId,User.Username,User.Name,User.SmallPhotoUrl,User.Alias '+
                                                                    +' FROM AccountTeamMember '+
                                                                    +' WHERE ' + 'Account.ParentId in: offerBUId' 
                                                                    
                                                                  );
            for(Id userIdRec: setUserID){
                for(AccountTeamMember accMem : accTeamMemList){
                    if(accMem.UserId == userIdRec){
                        finalAccountTeamMember.put(userIdRec,accMem);
                    }
                }
            }
            List<AccountTeamMember> accTeamMem = new List<AccountTeamMember>();
            accTeamMem.addAll(finalAccountTeamMember.values());
            List<AccountTeamMemberWrapper> accTeamList = new List<AccountTeamMemberWrapper>();
            for(AccountTeamMember acc : accTeamMem){
                String UserID = '/'+acc.UserId;
                String CiscoURL = ciscoBlog+acc.User.Alias;
                AccountTeamMemberWrapper teammember = new AccountTeamMemberWrapper(acc.User.Name,acc.User.Alias,acc.TeamMemberRole,UserID,CiscoURL);
                accTeamList.add(teammember);
            }
            if(accTeamList.size()>0)  {return accTeamList;}
            else{return null;}
        }
    } 
    Public without sharing class AccountTeamMemberWrapper {
        @AuraEnabled public String userName { get; set; }
        @AuraEnabled public String teamMemberRole { get; set; }
        @AuraEnabled public String userAlias { get; set; }
        @AuraEnabled public String UserId {get; set;}
        @AuraEnabled public String CiscoURL {get; set;}
        public AccountTeamMemberWrapper(){}
        public AccountTeamMemberWrapper(String userName, String userAlias,String accountTeamRole,String UserId, String CiscoURL ){      
            this.userName= userName;
            this.teamMemberRole= accountTeamRole;
            this.userAlias= userAlias;
            this.CiscoURL = CiscoURL;
            this.UserId = UserId;       
        }     
    }
    
}