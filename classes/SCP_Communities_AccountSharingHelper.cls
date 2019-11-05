/*
This helper class to impliment the trigger logic.
create account sharing records for partners in communities.
Delete the Account sharing when record is deleted and updated the distributor & partner names
Population the Distributor & Partner Name lookups insert the records

*/
public class SCP_Communities_AccountSharingHelper {
    
    // SCAVA Helper Method to validate Create Access at field level
     public static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }

public SCP_Communities_AccountSharingHelper(){}
public void insertAccountShareRecords(map<Id,set<Id>> mpDistiPartners, map<Id,Id> distiToParentId){
    map<Id,set<Id>> mpNewGroupAccountMap = getPartnerIdToGroupIds(mpDistiPartners,distiToParentId);
    list<AccountShare> insertAccountShareList = new list<AccountShare>();
     for(id gId : mpNewGroupAccountMap.keyset()){
        AccountShare ash = new AccountShare();      
        for(id partnId : mpNewGroupAccountMap.get(gId)){
             ash = new AccountShare();
             //SCAVA FIX
            if(flsGet(AccountShare.AccountId))
            {
             ash.AccountId = partnId;
            }
             if(flsGet(AccountShare.UserOrGroupId))
            {
             ash.UserOrGroupId = gId;   
            }
            if(flsGet(AccountShare.AccountAccessLevel))
            {
             ash.AccountAccessLevel  = 'Read';
            }
            if(flsGet(AccountShare.OpportunityAccessLevel))
            {
             ash.OpportunityAccessLevel = 'None';
            }
             insertAccountShareList.add(ash);
        }
    }
    if(!insertAccountShareList.isEmpty()){
        insert insertAccountShareList;
    }
}
public void deleteAccountShareRecords(map<Id,set<Id>> mpDistiPartners, map<Id,Id> distiToParentId){
    list<AccountShare> lstDeleteAccShare = new list<AccountShare>(); 
    set<Id> prtnerIds = new set<Id>();
    for(set<Id> setId : mpDistiPartners.values()) {
        for(Id ptId : setId){
            prtnerIds.add(ptId);
        }
    }      
    list<AccountShare> lstAccShare = [SELECT AccountAccessLevel, AccountId, Id, RowCause, UserOrGroupId FROM AccountShare Where
                                      AccountId IN: prtnerIds AND RowCause = 'Manual' AND AccountAccessLevel ='Read' ]; 
    map<Id,set<id>> mpDistiGroupIdNew = getPartnerIdToGroupIds(mpDistiPartners,distiToParentId);    
    for(AccountShare accSh:lstAccShare){        
        if(mpDistiGroupIdNew.get(accsh.UserOrGroupId) != null){
            lstDeleteAccShare.add(accSh);
        }
    }
    if(!lstDeleteAccShare.isEmpty()){
        //SCAVA FIX
            if (AccountShare.sObjectType.getDescribe().isDeletable())
               {
                delete lstDeleteAccShare;   
               }
    }
}

public void mapDistiPartnerAccountlookup(list<Disti_to_Partner_Mapping__c> lstInsert){
    set<string> lstAccBEGEOID = new set<string>();
    map<string,id> mpAccID = new map<string,id>();
    for(Disti_to_Partner_Mapping__c DP:lstInsert){
        if(DP.Partner_BEGEO_ID__c != null && DP.Distributor_BEGEO_ID__c != null){
            lstAccBEGEOID.add(DP.Partner_BEGEO_ID__c);
            lstAccBEGEOID.add(DP.Distributor_BEGEO_ID__c);
        }
    }   
    if(!lstAccBEGEOID.isEmpty()){
        for(Account acc:[select Id,PDB_BE_GEO_ID__c,Type from Account where PDB_BE_GEO_ID__c IN :lstAccBEGEOID and parentId != null]){
            mpAccID.put(acc.PDB_BE_GEO_ID__c,acc.Id);
        }
    }   
    for(Disti_to_Partner_Mapping__c DP:lstInsert){
        if(DP.Partner_BEGEO_ID__c != null && DP.Distributor_BEGEO_ID__c != null){
            DP.Distributor__c = mpAccID.get(DP.Distributor_BEGEO_ID__c);
            DP.Partner__c = mpAccID.get(DP.Partner_BEGEO_ID__c);
        }
    }
}
public map<Id,set<Id>> getPartnerIdToGroupIds (map<Id,set<Id>> mpDistiPartners, map<Id,Id> mpDistiToParentMap){
    map<Id,set<id>> mapGroupAccount = new map<Id,set<Id>>(); 
    map<Id,Id> MapChannelAccountIdToGroupId = new map<Id,Id>();
    List<UserRole> UserRoleList = [Select Id, PortalAccountId, Name 
                                        from UserRole 
                                        where Name like '%Partner Executive%' 
                                        and PortalAccountId IN (select Id 
                                                                    from Account 
                                                                    where parentId != null and parentId in :mpDistiPartners.Keyset())];
        List<Group> GroupList = [Select Id, RelatedId from Group where RelatedId IN: UserRoleList and Type = 'Role'];       
        for(Group groupObj: groupList)
        {    
            for(UserRole urObj: userRoleList)
            {               
                if(groupObj.RelatedId == urObj.Id){
                    MapChannelAccountIdToGroupId.put(urObj.PortalAccountId, groupObj.Id);
                }
            }
        }
        for(Id accId : MapChannelAccountIdToGroupId.keyset()){
            mapGroupAccount.put(MapChannelAccountIdToGroupId.get(accId),mpDistiPartners.get(mpDistiToParentMap.get(accId)));
        }   
        return mapGroupAccount;
}
}