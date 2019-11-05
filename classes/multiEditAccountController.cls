public class multiEditAccountController {
    
    @AuraEnabled
    public static boolean saveAssignments(String records,String lstUserIds,Boolean isManager) {
        List <AccountTeamMember> lstToInsert=new List<AccountTeamMember>();
        List <AccountTeamMember> lstToUpdate=new List<AccountTeamMember>();
        List <AccountTeamMember> lstToUpsert=new List<AccountTeamMember>();
        Boolean isSaved=false;
        List <String> lstToDelete=new List<String>();
        List <Id> idsToInsert=new List<Id>();
        if(isManager==false){
            idsToInsert.add(userInfo.getUserId());
        }
        else{
            System.debug('>>'+lstUserIds);
            List<JSON2Apex> usrIdLst =JSON2Apex.parse(lstUserIds);
            for(JSON2Apex wL:usrIdLst){
                idsToInsert.add(wl.id);
            }
        }
        System.debug(records);
        List<JSON2Apex> wrapList =JSON2Apex.parse(records);
        List<Id> accountIds = new List<Id>();
        
        for(JSON2Apex wl : wrapList){
            accountIds.add(wl.accId);
        }
               
        for(JSON2Apex wL:wrapList){
            
                for(Id idIns:idsToInsert){
                    System.debug('id Kavya'+idIns);
                    if(idIns!=wL.memberId){
                        
                        AccountTeamMember atm=new AccountTeamMember();
                        atm.UserId=idIns;//userInfo.getUserId();
                        atm.AccountId=wl.accId;
                        atm.TeamMemberRole='Systems Engineer (Assigned Account)';
                        atm.CaseAccessLevel='Edit';
                        atm.AccountAccessLevel='All';
                        atm.OpportunityAccessLevel='Edit';
                        lstToInsert.add(atm);
                    }
                   else{
                        AccountTeamMember atm=new AccountTeamMember();
                        atm.id=wl.atmId;
                        atm.TeamMemberRole='Systems Engineer (Assigned Account)';
                        atm.CaseAccessLevel='Edit';
                        atm.AccountAccessLevel='All';
                        atm.OpportunityAccessLevel='Edit';
                        lstToUpdate.add(atm);
                    }
                }
            }
     
        lstToUpsert.addAll(lstToInsert);
        lstToUpsert.addAll(lstToUpdate);
        Upsert lstToUpsert;
        
        return true;
        
    }
    //This is to ReAssign the users to ATM
    @AuraEnabled
    public static boolean removeAssignments(String records,String lstUserIds) {
        List <Id> lstToquery=new List<Id>();
        List <AccountTeamMember> lstToInsert=new List<AccountTeamMember>();
        
        System.debug(records);
        List<JSON2Apex> wrapList =JSON2Apex.parse(records);
        System.debug('wrapList'+wrapList);
        for(JSON2Apex wL:wrapList){
            System.debug('wL>>'+wL);
            if(String.valueOf(wL.atmId)!=''||String.valueOf(wL.atmId)!=null){
                lstToquery.add(wL.atmId);
            }
        }
        List<Id> accountIds = new List<Id>();
        
        for(JSON2Apex wl : wrapList){
            accountIds.add(wl.accId);
        }
              
        if(!String.isBlank(lstUserIds)){
            List <Id> idsToInsert=new List<Id>();
            List<JSON2Apex> usrIdLst =JSON2Apex.parse(lstUserIds);
            for(JSON2Apex wL:usrIdLst){
                idsToInsert.add(wl.id);
            }
             List<AccountTeamMember> lstToDelete=[Select id from AccountTeamMember where Id IN:lstToquery];
        Delete lstToDelete;
            for(JSON2Apex wL:wrapList){
                //added by Kavya
                     for(Id idIns:idsToInsert){
                        System.debug('>>Shivi'+wl.accId);
                        AccountTeamMember atm=new AccountTeamMember();
                        atm.UserId=idIns;//userInfo.getUserId();
                        atm.AccountId=wl.accId;
                        atm.TeamMemberRole='Systems Engineer (Assigned Account)';
                        atm.CaseAccessLevel='Edit';
                        atm.AccountAccessLevel='All';
                        atm.OpportunityAccessLevel='Edit';
                        lstToInsert.add(atm);
                    }
            }
            Insert lstToInsert;
        }
        return true;
    }
    @AuraEnabled
    public static boolean deleteAssignments(String records,String lstUserIds) {
        List <Id> lstToquery=new List<Id>();
        List <AccountTeamMember> lstToInsert=new List<AccountTeamMember>();
                
        System.debug(records);
        List<JSON2Apex> wrapList =JSON2Apex.parse(records);
        System.debug('wrapList'+wrapList);
        for(JSON2Apex wL:wrapList){
            System.debug('wL>>'+wL);
            if(String.valueOf(wL.atmId)!=''||String.valueOf(wL.atmId)!=null){
                lstToquery.add(wL.atmId);
            }
        }
        
        List<AccountTeamMember> lstToDelete=[Select id from AccountTeamMember where Id IN:lstToquery];
        Delete lstToDelete;
    return true;    
    }
    //Check logged in User Permission
    @AuraEnabled
    public static boolean checkSEUserPermission(){
        User usr = [select id,Additional_User_Permissions__c from user where id=: UserInfo.getUserId()];
        if(usr.Additional_User_Permissions__c!=null){
            List<String> additionalPermissionList = usr.Additional_User_Permissions__c.split(';');
            if(additionalPermissionList.contains('SE User')){
                return true;
            }
        }
        return false;
    }
    //Parsing the parameters
    public class JSON2Apex {
        
        public Id accId;
        public String id;
        public id memberId;
        public Id atmId;
        
    }
    public static List<JSON2Apex> parse(String json) {
        return (List<JSON2Apex>) System.JSON.deserialize(json, List<JSON2Apex>.class);
    }
}