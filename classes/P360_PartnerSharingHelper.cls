public class P360_PartnerSharingHelper
{
    
    // SCAVA Helper Method to validate Create Access at field level
     public static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }
    
   
// need to check for null parent id for channel account ---not valid scenario
     
final String LEAD_Partner_RecTypeId ;  // Partner Generated Lead RecordType Id

Public String Object_Type ;  // Used in some common methods to distinguish between Lead or Target Prospect.
public List<LeadShare> LeadShareToDelete = new List<LeadShare>();  // LeadShare Records to be deleteted
public List<LeadShare> LeadShareToInsert = new List<LeadShare>();  // LeadShare Records to be inserted.

public List<LeadShare> LeadShareDistiToDelete = new List<LeadShare>();  // LeadShare Records to be deleteted for disti

public List<AccountShare> PossibleAccountShareToDelete = new List<AccountShare>(); //Possible AccountShare records to be deleted.
public List<AccountShare> AccountShareToInsert = new List<AccountShare>(); //AccountShare Records to be inserted.

Public Map<Id,Lead> LeadsToProcess = new Map<Id,Lead>();
//Public Map<Id,Assigned_Partner__c> TPsToProcess = new Map<Id,Assigned_Partner__c>();
Public Set<Id> AllCustomerIds = new Set<Id>();

Public Map<Id,Id> MapLeadIdToPartnerAccountId = new Map<Id,Id>(); // Key -LeadId, Value -Partner Account Id of Channel Account on the lead.
// Modified By: Sudi 17 Oct 2014 
// Release : November Sprint 3
// User Story : US7053      
// Below map variable is used to store the lead Id and Distributos Ids
Public Map<Id,Id> MapLeadIdToDistributorAccountId = new Map<Id,Id>(); // Key -LeadId, Value -Disti Account Id of Channel Account on the lead.

// Key -EndUser Account Id, Value -Set<Id> of Lead Ids where the  respective EndUser account is present.
Public Map<Id,Set<Id>> MapCustomerAccountIdToLeadIds = new Map<Id,Set<Id>>();

// Key -Channel Account Id, Value -Primary Cisco Contact Id of channel account.
Public Map<Id,Id> MapChannelAccountIdToPrimaryCiscoContactId = new Map<Id,Id>(); 

// Key -Target Prospect Id, Value -Partner Account Id of Channel Account on the Target Prospect.
//Public Map<Id,Id> MapTPIdToPartnerAccountId = new Map<Id,Id>(); 

// Key -EndUser Account Id, Value -Set<Id> of Target Prospect Ids where the  respective EndUser account is present.
Public Map<Id,Set<Id>> MapCustomerAccountIdToTPIds = new Map<Id,Set<Id>>();

// Modified By: Sudi 17 Oct 2014 
// Release : November Sprint 3
// User Story : US7053      
// Below map variable is used to store Channel account ids for disti user 
Public Map<Id,Id> MapChannelAccountIdToPartnerAccountId = new Map<Id,Id>();

//Key -LeadId, Value -Set<Id> of users or groups which should have access to lead. This will be PSRs and Group of perticular PA role users.
Public Map<Id,Set<Id>> MapLeadIdToUserOrGroupIds = new Map<Id,Set<Id>>();
Public Map<Id,Set<Id>> MapLeadIdDistiToUserOrGroupIds = new Map<Id,Set<Id>>();

//Key -Target Prospect Id, Value -Set<Id> of users or groups which should have access to Target Prospect.
//This will be PSRs and Group of perticular PA role users.
Public Map<Id,Set<Id>> MapTPIdToUserOrGroupIds = new Map<Id,Set<Id>>();

//Key -EndUser Account Id, Value -Set<Id> of users or groups which should have access to account. 
//This will be PSRs and Group of perticular PA role users.
Public Map<Id,Set<Id>> MapCustomerAccountIdToUserOrGroupIds = new Map<Id,Set<Id>>();  
 
Public Set<Id> GroupIds = new Set<Id>(); // Group Ids involved in sharing, used for partner assignment email notification logic.
Public Set<Id> LeadsIdsForChannelAssignmentEmails = new Set<Id>();  // Lead Ids for partner assignment notification emails to PAs.
Public Set<Id> TPIdsForChannelAssignmentEmails = new Set<Id>(); // Target Prospect Ids for partner assignment notification emails to PAs.
Public Set<Id> PartnerGeneratedLeadIds = new Set<Id>(); // Partner Generated Leads
Public Set<Id> PartnerGeneratedTPIds = new Set<Id>(); // Partner Generated Target Prospects.

/* Constructer 1 - Called from Lead Trigger, Map<Id,Lead> LeadsToProcess as a Parameter.
 Get Required maps from LeadsToProcess Map
 MapLeadIdToPartnerAccountId,
 MapCustomerAccountIdToLeadIds,
 MapChannelAccountIdToPartnerAccountId,
 MapChannelAccountIdToPrimaryCiscoContactId
*/
public P360_PartnerSharingHelper(Map<Id,Lead> LeadsToProcess) 
{
    ObjectRecordTypeIds__c o = ObjectRecordTypeIds__c.getInstance();       
    this.LEAD_Partner_RecTypeId = o.Partner_Generated_Lead_RecordTypeId__c;
    this.LeadsToProcess = LeadsToProcess;
    this.Object_Type = 'Lead';  //Mark as trasaction for lead   
    
    for(Lead l : [Select ownerid,Id,Channel_Partner__c,Lead_From_Distributor_lookUp__c,Lead_From_Distributor_lookUp__r.ParentId,Channel_Partner__r.ParentId,Channel_Partner__r.Primary_Cisco_Contact__c,Channel_Partner__r.Primary_Cisco_Contact__r.isActive,End_Customer_Account__c,RecordTypeId,PSR_1__c,PSR_2__c,PSR_3__c from Lead where id IN :LeadsToProcess.keyset()])    
    {
         // Modified By: Sudi 17 Oct 2014 
         // Release : November Sprint 3
         // User Story : US7053     
         // Below code is added for to share the lead records to distributors
        if(l.Lead_From_Distributor_lookUp__c != null && l.Lead_From_Distributor_lookUp__r.ParentId!=null){
            MapLeadIdToDistributorAccountId.put(l.id, l.Lead_From_Distributor_lookUp__r.ParentId);
        }                       
        if(l.Channel_Partner__c != null)
        {
            MapLeadIdToPartnerAccountId.put(l.id,l.Channel_Partner__r.ParentId);
            MapChannelAccountIdToPartnerAccountId.put(l.Channel_Partner__c,l.Channel_Partner__r.ParentId);
            System.debug('Is Active** '+l.Channel_Partner__r.Primary_Cisco_Contact__r.isActive);
            // Added condition to allow only Active user
            if(l.Channel_Partner__r.Primary_Cisco_Contact__r.isActive){
                MapChannelAccountIdToPrimaryCiscoContactId.put(l.Channel_Partner__c,l.Channel_Partner__r.Primary_Cisco_Contact__c);
            }   
        }
        
        if(l.End_Customer_Account__c != null)
        {
                if(!MapCustomerAccountIdToLeadIds.containsKey(l.End_Customer_Account__c))
                {           
                    Set<Id> LeadIds= new Set<Id>();
                    LeadIds.add(l.Id);
                    MapCustomerAccountIdToLeadIds.Put(l.End_Customer_Account__c,LeadIds);
                }
                else
                {
                    Set<Id> LeadIds = MapCustomerAccountIdToLeadIds.get(l.End_Customer_Account__c);
                    LeadIds.add(l.Id);
                    MapCustomerAccountIdToLeadIds.Put(l.End_Customer_Account__c,LeadIds);
                }
        }
    }  
    System.debug('MapLeadIdToPartnerAccountId');
    System.debug(MapLeadIdToPartnerAccountId);
    System.debug('MapCustomerAccountIdToLeadIds');
    System.debug(MapCustomerAccountIdToLeadIds);
    System.debug('MapChannelAccountIdToPartnerAccountId**'+MapChannelAccountIdToPrimaryCiscoContactId);
    System.debug(MapChannelAccountIdToPartnerAccountId);

}


/* Constructer 2 - Called from Target Prospect Trigger, Map<Id,Assigned_Partner__c> TPsToProcess as a Parameter.
 Get Required maps from TPsToProcess Map
 MapTPIdToPartnerAccountId,
 MapCustomerAccountIdToTPIds,
 MapChannelAccountIdToPartnerAccountId,
 MapChannelAccountIdToPrimaryCiscoContactId
*/

public P360_PartnerSharingHelper(Map<Id,Assigned_Partner__c> TPsToProcess) 
{
    
 
}
// Modified By: Sudi 17 Oct 2014 
// Release : November Sprint 3
// User Story : US7053      
// Below Methods find out group ids related to perticular Partner Account of channel account on lead  
// UserIds  
public void getUserorGroupIDsforLeadDistributorAccounts(){
    if(object_Type == 'Lead'){
        Map<Id,Set<Id>> PartnerIdToGroupIds = getPartnerIdToGroupIds(MapLeadIdToDistributorAccountId.values()); 
        System.debug('PartnerIdToGroupIds');
        System.debug(PartnerIdToGroupIds);
        
        // find out UserOrGroupIds for perticular lead to whom access should be there with new lead values.
        for(Id LeadId :MapLeadIdToDistributorAccountId.keyset()) 
        {   
            Set<Id> UserOrGroupIds = new Set<Id>();
            if(PartnerIdToGroupIds.get(MapLeadIdToDistributorAccountId.get(LeadId)) != null)
            {
                UserOrGroupIds = PartnerIdToGroupIds.get(MapLeadIdToDistributorAccountId.get(LeadId));
            }
            Lead l = LeadsToProcess.get(LeadId);                      
            MapLeadIdDistiToUserOrGroupIds.put(LeadId,UserOrGroupIds);
        }   
    }
}

/* 
    Whenever Account is enabled as partner , system automatically creates 3 Type of Portal Roles
    1. <<Channal Account Name>> Partner Executive
    2. <<Channal Account Name>> Partner Manager
    3. <<Channal Account Name>> Partner User
    
    Partner Admins are assigned to <<Channal Account Name>> Partner Executive role.
    Partner Sales Reps are assigned to <<Channal Account Name>> Partner User role.
    
    For all 3 roles system creates record in Group Object with 'RelatedId' as Role Id.
    Sharing is given to these groups(in this case group object related to <<Channal Account Name>> Partner Executive, 
    so that all PAs get acess automatically and we don't need insert records for each user.
    
    Below Methods find out group ids related to perticular Partner Account of channel account on lead or Target Prospect + 
    UserIds of Partner Sales Reps on Lead or Target Prospect.   
*/
public void getUserOrGroupIdsForLeadsOrTPsAndAccounts() 
{
    if(Object_Type == 'Lead')
    {
        // find Partner Account to GroupIds(Group Ids of all <<Channal Account Name>> Partner Executive Role>>) map.
        Map<Id,Set<Id>> PartnerIdToGroupIds = getPartnerIdToGroupIds(MapLeadIdToPartnerAccountId.values()); 
        System.debug('PartnerIdToGroupIds');
        System.debug(PartnerIdToGroupIds);
        
        // find out UserOrGroupIds for perticular lead to whom access should be there with new lead values.
        for(Id LeadId :MapLeadIdToPartnerAccountId.keyset()) 
        {   
            Set<Id> UserOrGroupIds = new Set<Id>();
            if(PartnerIdToGroupIds.get(MapLeadIdToPartnerAccountId.get(LeadId)) != null)
            {
                UserOrGroupIds = PartnerIdToGroupIds.get(MapLeadIdToPartnerAccountId.get(LeadId));
            }
            Lead l = LeadsToProcess.get(LeadId);
             // Add Partner Sales Reps on Lead to Map
             // If he is owner of lead(Partner uploaded leads from SAP) then
             // the record will be already there in lead share as owner and we can't change that or insert record with lower access.
            if(l.PSR_1__c != null && l.PSR_1__c != l.ownerId) 
            {
                UserOrGroupIds.add(l.PSR_1__c);
            }
            if(l.PSR_2__c != null && l.PSR_2__c != l.ownerId)
            {
                UserOrGroupIds.add(l.PSR_2__c);
            }
            if(l.PSR_3__c != null && l.PSR_3__c != l.ownerId)
            {
                UserOrGroupIds.add(l.PSR_3__c);
            }
            
            //Give Access to Primary Cisco Contact of partner in case of Partner Generated Leads.
            if(l.recordtypeid == LEAD_Partner_RecTypeId && l.Channel_Partner__c != null && 
               MapChannelAccountIdToPrimaryCiscoContactId.get(l.Channel_Partner__c) != null && 
               MapChannelAccountIdToPrimaryCiscoContactId.get(l.Channel_Partner__c)!= l.ownerId)
            {
                UserOrGroupIds.add(MapChannelAccountIdToPrimaryCiscoContactId.get(l.Channel_Partner__c));
            }       
            
            MapLeadIdToUserOrGroupIds.put(LeadId,UserOrGroupIds);
        }   
        System.debug('MapLeadIdToUserOrGroupIds*');
        System.debug(MapLeadIdToUserOrGroupIds);
        
        // find out UserOrGroupIds for perticular EndUser accounts to whom access should be there with new lead values.
        for(Id AccountId :MapCustomerAccountIdToLeadIds.keyset())  
        {
            for(Id leadId :  MapCustomerAccountIdToLeadIds.get(AccountId))
            {
                    if(MapLeadIdToUserOrGroupIds.get(leadId)!=null)
                    {
                        for(Id UserOrGroupId : MapLeadIdToUserOrGroupIds.get(leadId))
                        {
                            String PrimaryCiscoContactId = MapChannelAccountIdToPrimaryCiscoContactId.get(LeadsToProcess.get(LeadId).Channel_Partner__c);
                            if(PrimaryCiscoContactId == null || UserOrGroupId != PrimaryCiscoContactId)
                            {
                                if(!MapCustomerAccountIdToUserOrGroupIds.containskey(AccountId))
                                {
                                    Set<Id> UserOrGroupIds = new Set<Id>();
                                    UserOrGroupIds.add(UserOrGroupId);
                                    MapCustomerAccountIdToUserOrGroupIds.Put(AccountId,UserOrGroupIds);
                                }
                                else
                                {
                                    Set<Id> UserOrGroupIds = MapCustomerAccountIdToUserOrGroupIds.get(AccountId);
                                    UserOrGroupIds.add(UserOrGroupId);
                                    MapCustomerAccountIdToUserOrGroupIds.Put(AccountId,UserOrGroupIds);
                                }
                            }
                        }
                    }
            }
        }
        System.debug('MapCustomerAccountIdToUserOrGroupIds');
        System.debug(MapCustomerAccountIdToUserOrGroupIds);
    }
    
   
}

/*
    This Method finds out Group Ids(Group Ids of all <<Channal Account Name>> Partner Executive roles
    of all channel accounts present for give partner account.
*/


Map<Id,Set<Id>> getPartnerIdToGroupIds (List<Id> PartnerIds)  // find Partner Account to GroupIds map 
{
    //Key -Partner Account Id, Value -Set<Id> of all Groupd Ids of <<Channal Account Name>> Partner Executive roles of all channel accounts 
    //of Partner.
    Map<Id,Set<Id>> MapPartnerIdToGroupIds = new Map<Id,Set<Id>>();
    
    //Key -Channel Account Id, Value -Groupd Id of <<Channal Account Name>> Partner Executive role.
    Map<Id,Id> MapChannelAccountIdToGroupId = new Map<Id,Id>(); 
        
    //Get <<Channal Account Name>> Partner Executive roles
        List<UserRole> UserRoleList = [Select Id, PortalAccountId, Name 
                                        from UserRole 
                                        where Name like '%Partner Executive%' 
                                        and PortalAccountId IN (select Id 
                                                                    from Account 
                                                                    where parentId != null and parentId in :PartnerIds)];
                                                                    
        System.debug('UserRoleList');       
        System.debug(UserRoleList);         
       
    //Get Group Ids of <<Channal Account Name>> Partner Executive roles.   
        List<Group> GroupList = [Select Id, RelatedId from Group where RelatedId IN: UserRoleList and Type = 'Role'];
        System.debug('GroupList');        
        System.debug(GroupList);
        for(Group groupObj: groupList)
        {    
            for(UserRole urObj: userRoleList)
            {               
                if(groupObj.RelatedId == urObj.Id){
                    MapChannelAccountIdToGroupId.put(urObj.PortalAccountId, groupObj.Id);
                }
            }
        }
        System.debug('MapChannelAccountIdToGroupId');
        System.debug(MapChannelAccountIdToGroupId);
        
    //Prepare PartnerIdToGroupIds Map.
        for(Account a : [select ownerid,Id,parentId from Account where parentId in :PartnerIds and
                            Id IN:MapChannelAccountIdToGroupId.keyset() ])
        {   
                System.debug('MapChannelAccountIdToGroupId.get(a.Id)');
                System.debug(MapChannelAccountIdToGroupId.get(a.Id));
                if(!MapPartnerIdToGroupIds.containskey(a.parentId))
                {
                    Set<Id> GroupIds = new Set<Id>();
                    GroupIds.add(MapChannelAccountIdToGroupId.get(a.Id));
                    MapPartnerIdToGroupIds.Put(a.parentId,GroupIds);
                }
                else
                {
                    Set<Id> GroupIds = MapPartnerIdToGroupIds.get(a.parentId);
                    GroupIds.add(MapChannelAccountIdToGroupId.get(a.Id));
                    MapPartnerIdToGroupIds.Put(a.parentId,GroupIds);
                }
        }
        System.debug('MapPartnerIdToGroupIds');
        System.debug(MapPartnerIdToGroupIds);
        
    
    return MapPartnerIdToGroupIds;
}


// Find out LeadShare records to deleted from existing records by checking them with required records
public void findLeadShareToDelete()  
{
    for(LeadShare ls : [Select Id, LeadId, UserOrGroupId, LeadAccessLevel, RowCause From LeadShare Where
                        LeadId IN: LeadsToProcess.keyset() AND RowCause = 'Manual'])
    {
        system.debug(MapLeadIdToUserOrGroupIds);        
        if(MapLeadIdToUserOrGroupIds.get(ls.LeadId) == null || !MapLeadIdToUserOrGroupIds.get(ls.LeadId).contains(ls.UserOrGroupId))                      
        LeadShareToDelete.add(ls);        
    }

}
// Modified By: Sudi 17 Oct 2014 
// Release : November Sprint 3
// User Story : US7053      
// Find out LeadShare records to deleted from existing records by checking them with required records
public void findLeadDistiShareToDelete()  
{
    for(LeadShare ls : [Select Id, LeadId, UserOrGroupId, LeadAccessLevel, RowCause From LeadShare Where
                        LeadId IN: LeadsToProcess.keyset() AND RowCause = 'Manual'])
    {
        system.debug(MapLeadIdToUserOrGroupIds);
        if(MapLeadIdDistiToUserOrGroupIds.get(ls.LeadId) == null || !MapLeadIdDistiToUserOrGroupIds.get(ls.LeadId).contains(ls.UserOrGroupId))
        LeadShareDistiToDelete.add(ls);
    }

}

// Find out AccountShare records to deleted from existing records by checking them with required records.
public void findPossibleAccountShareToDelete()  
{
    for(AccountShare ash : [SELECT AccountAccessLevel, AccountId, Id, RowCause, UserOrGroupId FROM AccountShare Where
                            AccountId IN: AllCustomerIds AND RowCause = 'Manual' AND AccountAccessLevel ='Read'])
    {
        System.debug('MapCustomerAccountIdToUserOrGroupIds');
        System.debug(MapCustomerAccountIdToUserOrGroupIds);
        if(MapCustomerAccountIdToUserOrGroupIds.get(ash.AccountId)== null ||
            !MapCustomerAccountIdToUserOrGroupIds.get(ash.AccountId).contains(ash.UserOrGroupId))
        PossibleAccountShareToDelete.add(ash);
    }

}
 
// find Required Lead Share records to be inserted.
public void findLeadShareToInsert() 
{ 
    for(Id LeadId :MapLeadIdToUserOrGroupIds.keyset())  
    {
                    for(Id UserOrGroupId :MapLeadIdToUserOrGroupIds.get(LeadId))
                    {
                        LeadShare ls = new LeadShare();
                        ls.LeadId = LeadId;
                        ls.UserOrGroupId = UserOrGroupId;   
                        ls.LeadAccessLevel = 'Edit';
                        LeadShareToInsert.add(ls);
                        String recId = UserOrGroupId;
                        //If it is not user then it is Group related to PA's Role.This is used in Email Notification Logic.
                        if(recId.subString(0, 3) != '005')  
                        {
                            GroupIds.add(UserOrGroupId);
                        }
                        System.debug('GroupIds');
                        System.debug(GroupIds);
                    }
                
    }
}
public void findLeadDistiShareToInsert() 
{ 
    for(Id LeadId :MapLeadIdDistiToUserOrGroupIds.keyset())  
    {
                    for(Id UserOrGroupId :MapLeadIdDistiToUserOrGroupIds.get(LeadId))
                    {
                        LeadShare ls = new LeadShare();
                        ls.LeadId = LeadId;
                        ls.UserOrGroupId = UserOrGroupId;   
                        ls.LeadAccessLevel = 'Edit';
                        LeadShareToInsert.add(ls);
                        String recId = UserOrGroupId;
                        //If it is not user then it is Group related to PA's Role.This is used in Email Notification Logic.
                        if(recId.subString(0, 3) != '005')  
                        {
                            GroupIds.add(UserOrGroupId);
                        }
                        System.debug('GroupIds');
                        System.debug(GroupIds);
                    }
                
    }
}

// find Required account Share records to be inserted.
public void findAccountShareToInsert() 
{ 
    for(Id AccountId :MapCustomerAccountIdToUserOrGroupIds.keyset()) 
    {
                for(Id UserOrGroupId :MapCustomerAccountIdToUserOrGroupIds.get(AccountId))
                {
                    AccountShare ash = new AccountShare();
                    //SCAVA FIX
                    if(flsGet(AccountShare.AccountId))
                    {
                    ash.AccountId = AccountId;
                    }
                    if(flsGet(AccountShare.UserOrGroupId))
                    {
                    ash.UserOrGroupId = UserOrGroupId;   
                    }
                    if(flsGet(AccountShare.AccountAccessLevel))
                    {
                    ash.AccountAccessLevel  = 'Read';
                    }
                    if(flsGet(AccountShare.OpportunityAccessLevel))
                    {
                    ash.OpportunityAccessLevel = 'None';
                    }
                    AccountShareToInsert.add(ash);
                }
    }

}

// Insert Lead Share or Target Prospect Share records into database + 
// Send emails to all Partner Admins if it partner assignment to lead or TP Activation.

public void LeadOrTPShareInsert() 
{
    if(LeadShareToInsert.size() >0) //  || TPShareToInsert.size() >0 
    {
        
            Map<Id,User> Users = new Map<Id,User>([Select id, Email,LanguageLocaleKey,userRoleId from user where 
                                                  IsActive =TRUE and userRoleId in (select relatedId from group where id in :GroupIds)]); 
            Map<Id,Set<Id>> MapRoleIdToUserIds = new Map<Id,Set<Id>>();
            Map<Id,Id> MapGroupIdToRoleId = new Map<Id,Id>();
            List<P360_Mail_Queue__c> EmailList = new List<P360_Mail_Queue__c>();
            for (user u : Users.values())
            {
                if(!MapRoleIdToUserIds.containsKey(u.userRoleId))
                {
                    Set<Id> UserIds = new Set<Id>();
                    UserIds.add(u.Id);
                    MapRoleIdToUserIds.put(u.userRoleId,UserIds);
                }           
                else
                {
                    Set<Id> UserIds = MapRoleIdToUserIds.get(u.userRoleId);
                    UserIds.add(u.Id);
                    MapRoleIdToUserIds.put(u.userRoleId,UserIds);
                
                }
                
            }
            
            for(group g :[Select Id, RelatedId from Group where Id IN :GroupIds and Type = 'Role'])
            {
                MapGroupIdToRoleId.put(g.Id,g.RelatedId);
            
            }
            System.debug('MapRoleIdToUserIds');
            System.debug(MapRoleIdToUserIds);
            System.debug('MapGroupIdToRoleId');
            System.debug(MapGroupIdToRoleId);
            
            if(Object_Type == 'Lead')
            {
                insert LeadShareToInsert; 
                for(LeadShare ls : LeadShareToInsert)
                {
                      if(LeadsIdsForChannelAssignmentEmails.contains(ls.LeadId) && MapRoleIdToUserIds.get(MapGroupIdToRoleId.get(ls.UserOrGroupId)) != null)
                      {
                          for(Id userId : MapRoleIdToUserIds.get(MapGroupIdToRoleId.get(ls.UserOrGroupId)))
                          {
                              P360_Mail_Queue__c o = new P360_Mail_Queue__c();
                              //SCAVA FIX
                              if(flsGet(P360_Mail_Queue__c.Recipient__c))
                              {
                                o.Recipient__c = userId;                                
                              }
                              if(flsGet(P360_Mail_Queue__c.Lead__c))
                              {
                                o.Lead__c = ls.LeadId;
                              }
                              if(flsGet(P360_Mail_Queue__c.Notification_Type__c))
                              {
                                o.Notification_Type__c = 'Lead Partner Assignment';
                              }
                              if(flsGet(P360_Mail_Queue__c.Email_Notification__c))
                              {
                                o.Email_Notification__c = true;
                              }
                                EmailList.add(o);
                          }
                      }
                }
            }
           
            System.debug('EmailList');
            System.debug(EmailList);
            
            // set allOrNone to false; duplicate notifications created (due to trigger re-run) will be silently swallowed
            //if(EmailList.size()>0) insert EmailList;            
            if (EmailList.size()>0) {
               Database.SaveResult[] insertResult = Database.insert(EmailList, false);
               system.debug('Insert Email Notification'+insertResult);
            }
 
    }   
}

// Insert AccountShare records to be Inserted in database.
public void accountShareInsert()
{
    if(AccountShareToInsert.size() >0) insert AccountShareToInsert;
}

// Delete LeadShare records to be deleted from database.
public void LeadShareDelete() 
{
    if(LeadShareToDelete.size() >0) 
    //SCAVA FIX
            if (LeadShare.sObjectType.getDescribe().isDeletable())
               {        
                    delete LeadShareToDelete;
               }
}

/*
    We can not delete the all account share records from account account share table which are not need for current lead or Target prospect
    as same End-User account may be present on other leads, target Prospects with simillar channel account,Partner sales reps.
    So we have to find out account share records from PossibleAccountShareToDelete , which are needed due other leads and target prospects.
*/
public void accountShareDelete()  
{
            Set<Id> AccountIds = new Set<Id>();
            Map<Id,Lead> LeadsToProcessD = new Map<Id,Lead>();
            Map<Id,Assigned_Partner__c> TPsToProcessD = new Map<Id,Assigned_Partner__c>();
            List<AccountShare> AccountShareToDelete = new List<AccountShare>();
            Map<Id,Set<Id>> MapCustomerAccountIdToUserOrGroupIdsFinal = new Map<Id,Set<Id>>();  
            Set<Id> AllUserOrGroupIds= new Set<Id>();
            
            //Get Required Set of Ids
            for(AccountShare ash :PossibleAccountShareToDelete) 
            {
                AccountIds.add(ash.AccountId);
                AllUserOrGroupIds.add(ash.UserOrGroupId);
                AccountShareToDelete.add(ash);
            }
            
            //Get User(Partner Sales reps) Ids from AllUserOrGroupIds
            Map<Id,User> Users = new Map<Id,User>([Select Id,UserRoleId,UserRole.Name from user where id IN:AllUserOrGroupIds]);
            
            //Get Group Ids from AllUserOrGroupIds
            Map<Id,Group> Groups = new Map<Id,group>([Select Id,Type from group where id IN:AllUserOrGroupIds]);
            
            System.debug('Users');
            System.debug(Users);
            System.debug('Groups');
            System.debug(Groups);
            
            //Find Out Leads in the system with end-user account in Account Ids of PossibleAccountShareToDelete and Partner assigned.
            for(Lead l : [Select ownerid,Id,Channel_Partner__c,Channel_Partner__r.ParentId,End_Customer_Account__c,
                            RecordTypeId,PSR_1__c,PSR_2__c,PSR_3__c from Lead where Channel_Partner__c!= Null and 
                            End_Customer_Account__c IN :AccountIds] )
            {
                LeadsToProcessD.put(l.Id,l);
            }
                     
            P360_PartnerSharingHelper PSHD ; // Instance to find out sharing from leads.
          
            if(LeadsToProcessD.size()> 0)
            {
                PSHD = new P360_PartnerSharingHelper(LeadsToProcessD);
                PSHD.getUserOrGroupIdsForLeadsOrTPsAndAccounts();                
            }
            // if both type of records are present in the system with end-user account in Account Ids of PossibleAccountShareToDelete and active.
            if(PSHD != null)   
            {
                // Take UserOrGroupIds from lead into final variable.
                MapCustomerAccountIdToUserOrGroupIdsFinal = PSHD.MapCustomerAccountIdToUserOrGroupIds;
            }
            //If Only Leads are present in the system with end-user account in Account Ids of PossibleAccountShareToDelete and active.
            // Take UserOrGroupIds from lead into final variable.
            else if(PSHD != null) 
            MapCustomerAccountIdToUserOrGroupIdsFinal = PSHD.MapCustomerAccountIdToUserOrGroupIds;
            
            
            System.debug('PossibleAccountShareToDelete');
            System.debug(PossibleAccountShareToDelete);
            System.debug('MapCustomerAccountIdToUserOrGroupIdsFinal');
            System.debug(MapCustomerAccountIdToUserOrGroupIdsFinal);
            

            // Now we have MapCustomerAccountIdToUserOrGroupIdsFinal which has accountid and corresponding UserOrGroupIds ,
            // with the end-user account still needs to be shared. So just remove this records from PossibleAccountShareToDelete
            // and delete the remaining ones from data base.
                    integer j = 0;
                    for(Integer i = 0; i < PossibleAccountShareToDelete.size(); i++)
                    {
                        system.debug(i);

                        if(((MapCustomerAccountIdToUserOrGroupIdsFinal.get(PossibleAccountShareToDelete[i].AccountId) != null) &&
                           (MapCustomerAccountIdToUserOrGroupIdsFinal.get(PossibleAccountShareToDelete[i].AccountId).contains(PossibleAccountShareToDelete[i].UserOrGroupId)) )||
                           (users.get(PossibleAccountShareToDelete[i].UserOrGroupId)!=null && (users.get(PossibleAccountShareToDelete[i].UserOrGroupId).userroleId == null || !users.get(PossibleAccountShareToDelete[i].UserOrGroupId).userrole.name.contains('Partner')))||
                           (groups.get(PossibleAccountShareToDelete[i].UserOrGroupId)!=null && (groups.get(PossibleAccountShareToDelete[i].UserOrGroupId).type == null || groups.get(PossibleAccountShareToDelete[i].UserOrGroupId).type !='Role'))
                           )
                        {
                            AccountShareToDelete.Remove(i-j);
                            j++;
                        }
                    }
     

            
            
        if(AccountShareToDelete.size() >0) 
        //SCAVA FIX
            if (AccountShare.sObjectType.getDescribe().isDeletable())
               {    
                    delete AccountShareToDelete;
               }
        
}


// Send Notification to Primary Cisco Contact of Partner upon New Partner Generated lead.
public void sendPartnerGeneratedLeadNotifications()
{
    List<P360_Mail_Queue__c>  Notifications = new List<P360_Mail_Queue__c>();
    for(Id LeadId :PartnerGeneratedLeadIds)
    {
        System.debug('Notifications for Lead: ' + LeadId);
        if(MapChannelAccountIdToPrimaryCiscoContactId.get(LeadsToProcess.get(LeadId).Channel_Partner__c) != null)
        {
            P360_Mail_Queue__c o = new P360_Mail_Queue__c();
            //SCAVA FIX
            if(flsGet(P360_Mail_Queue__c.Recipient__c   ))
            {
            o.Recipient__c = MapChannelAccountIdToPrimaryCiscoContactId.get(LeadsToProcess.get(LeadId).Channel_Partner__c);                      
            }
            if(flsGet(P360_Mail_Queue__c.Lead__c))
            {
            o.Lead__c = LeadId;
            }
            if(flsGet(P360_Mail_Queue__c.Notification_Type__c))
            {
            o.Notification_Type__c = 'New Partner Generated Lead';
            }
            if(flsGet(P360_Mail_Queue__c.Email_Notification__c))
            {
            o.Email_Notification__c = true;
            }
            Notifications.add(o);
        }
    
    }    
    // set allOrNone to false; duplicate notifications created (due to trigger re-run) will be silently swallowed
    //if(Notifications.size()>0) insert Notifications;
    if(Notifications.size()>0) {
        Database.insert(Notifications, false);
    }
}
}