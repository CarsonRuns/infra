/**
 * Class prmUtils
 *
 * Utility class used for Partner related logic on Sales Collaboration Platform
 */
public without sharing class prmUtils {
    /**
     * @description Return a list of partner user records from a passed in set of user ids
     * 
     * @param userIds Uniques set of user ids to check if they are partner users
     * 
     * @return List of user records who are partners
     */
    public static Set<Id> getPartnerUsers(Set<ID> userIds){
        ProfileID__c p = ProfileID__c.getOrgDefaults();
        //get list of partner users from note owners and make a set a partner user ids
        System.debug(userIds);
        List<User> partnerUsers = [select id from User where id in :userIds and profileId in(:p.Partner360_Portal_Profile__c,'00en0000000Hg4k')];
        
        return (new Map<Id,User>(partnerUsers)).keySet();
    }

    /**
     * @description Allows to filter a list of lead records based on statuses 
     * 
     * @param leadIds List of lead records ids to query against 
     * @param statuses List of status values to query against the field lead.Partner_Lead_Status__c
     * 
     * @return Lead data whose status and id matches the input parameters
     */
    public static List<Lead> getLeadsByStatus(Set<Id> leadIds, Set<String> statuses){
        System.debug(leadIds);
        return [Select Id, Partner_Lead_Status__c, PSR_1__c, PSR_2__c, PSR_3__c from Lead where Partner_Lead_Status__c in :statuses and id in :leadIds];
    }

    /**
     * @description Allows to filter a list of target prospect records based on statuses 
     * 
     * @param tpIds List of target prospect records ids to query against 
     * @param statuses List of status values to query against the field Assigned_Partner__c.Partner_Status__c
     * 
     * @return target prospect data whose status and id matches the input parameters
     */
    public static List<Assigned_Partner__c> getTpByStatus(Set<Id> tpIds, Set<String> statuses){
        System.debug(tpIds);
        return [Select Id, Partner_Status__c, Assigned_Partner_Sales_Rep__c, Assigned_Partner_Sales_Rep_2__c, Assigned_Partner_Sales_Rep_3__c from Assigned_Partner__c where Partner_Status__c in :statuses and id in :tpIds];
    }

    /**
     * @description process notes & attachments inserted or updated by partner users and update status of
     * lead/tp associated to note
     * 
     * @param notes List of Note/Attachments inserted/updated
     */
    public static void processPrmNoteAttachments(List<SObject> noteAttachments){
        Set<Id> noteAttachmentOwnerSet = new Set<Id>();
        Set<ID> partnerUserIds = new Set<Id>();
        Map<Id,Id> leadNoteAttachmentOwnerMap = new Map<Id,Id>();
        Map<Id,Id> tpNoteAttachmentOwnerMap = new Map<Id,Id>();
        
        //Get inserted/updated attachments owner ids
        for(SObject o:noteAttachments){
            noteAttachmentOwnerSet.add((Id)o.get('OwnerId'));
            noteAttachmentOwnerSet.add((Id)o.get('LastModifiedById'));
        }

        //Check if inserted/updated attachments were made by partner user
        partnerUserIds = getPartnerUsers(noteAttachmentOwnerSet);
        if(partnerUserIds.size()>0){
            //System.debug(partnerUsers);
            //Update Partner Lead Note map, and Partner TP Note map.
            for(SObject o:noteAttachments){
                System.debug(o);
                Id noteAttachmentsOwnerId = (Id)o.get('OwnerId');
                Id noteAttachmentsLastModifiedById = (Id)o.get('LastModifiedById');
                Id noteAttachmentsParentId = (Id)o.get('ParentId');
                Id potentialPsr = partnerUserIds.contains(noteAttachmentsOwnerId)?noteAttachmentsOwnerId:partnerUserIds.contains(noteAttachmentsLastModifiedById)?noteAttachmentsLastModifiedById:null;
                System.debug('(Id)partnerUserIds.contains(noteAttachmentsOwnerId)?noteAttachmentsOwnerId:partnerUserIds.contains(noteAttachmentsLastModifiedById)?noteAttachmentsLastModifiedById:null;)');
                System.debug(potentialPsr);
                System.debug('Boolean Condition ' + noteAttachmentsLastModifiedById.getSObjectType() + '|' + Lead.sObjectType);
                if(noteAttachmentsParentId.getSObjectType() == Lead.sObjectType && potentialPsr != null){
                    //System.debug('Is a lead:' + a.ParentId);
                    leadNoteAttachmentOwnerMap.put(noteAttachmentsParentId,potentialPsr);
                }
                if(noteAttachmentsParentId.getSObjectType() == Assigned_Partner__c.sObjectType  && potentialPsr != null){
                    tpNoteAttachmentOwnerMap.put(noteAttachmentsParentId,potentialPsr);
                }
            }

            Set<String> statuses = new Set<String>();
            statuses.add('Partner Assigned');
            statuses.add('Assigned to PSR');
            List<Lead> leadsToUpdate = getLeadsByStatus(leadNoteAttachmentOwnerMap.keySet(),statuses);
            List<Assigned_Partner__c> tpToUpdate = getTpByStatus(tpNoteAttachmentOwnerMap.keySet(),statuses);
            if(leadsToUpdate.size()>0){
                System.debug(leadsToUpdate);
                for(Lead l:leadsToUpdate){
                    if('Partner Assigned'.equals(l.Partner_Lead_Status__c) &&
                       l.PSR_1__c == null && l.PSR_2__c == null && l.PSR_3__c == null)
                    {
                       l.PSR_1__c = leadNoteAttachmentOwnerMap.get(l.Id);
                    }
                    l.prm_Non_Lead_Edit__c = true;
                    l.Partner_Lead_Status__c = 'Actively Working';
                }
                System.debug(leadsToUpdate);
                try{
                    System.debug('prmUtils.processPrmNoteAttachments(): Attempting to update leads status after adding attachments');
                    update leadsToUpdate;
                } catch(DmlException e) {
                    System.debug('The following exception has occurred: ' + e.getMessage());
                }
            }
    
            if(tpToUpdate.size() > 0){
                System.debug(tpToUpdate);
                for(Assigned_Partner__c tp:tpToUpdate){
                    if('Partner Assigned'.equals(tp.Partner_Status__c) &&
                       tp.Assigned_Partner_Sales_Rep__c == null && tp.Assigned_Partner_Sales_Rep_2__c == null && tp.Assigned_Partner_Sales_Rep_3__c == null)
                    {
                       tp.Assigned_Partner_Sales_Rep__c = tpNoteAttachmentOwnerMap.get(tp.Id);
                    }
                    tp.Partner_Status__c = 'Actively Working';
                }
                System.debug(tpToUpdate);
                try{
                    System.debug('prmUtils.processPrmNoteAttachments(): Attempting to update TP status after adding attachments');
                    update tpToUpdate;
                } catch(DmlException e) {
                    System.debug('The following exception has occurred: ' + e.getMessage());
                }
            }
        }
    }
	 /**
     * @description allows to get partner admin user ids based on account id
     * 
     * @param accountIds List of Accound Ids to query against      
     * 
     * @return the map of account Ids and user list with ; seperated string
     */
	public static map<Id,string> getSCPUserList(set<Id> accountIds){
		map<Id,String> mpReturn = new map<Id,String>();
		map<Id,string> mapUsers = new map<Id,string>();
		map<string,string> mapContactUser = new map<string,string>();			
		for(User u : [select UserName,contact.account.Id,contact.Partner_Admin_Roles__c,contactId from User where contact.account.Id in: accountIds]){
			 Boolean isContactPSR = Partner360Utils.isPSR(u.contact.Partner_Admin_Roles__c);
             Boolean isContactPartnerAdmin = Partner360Utils.isPartnerAdmin(u.contact.Partner_Admin_Roles__c);
             if(isContactPSR && isContactPartnerAdmin){
             	string[] strArry = u.UserName.split('@');
				string UserId = (strArry.size() > 0) ? strArry[0]:'';
             	mapUsers.put(u.contactId,UserId);
             }
		}	
		for(Account acc : [Select a.Name, (Select Id From Contacts where Id in: mapUsers.keySet()) From Account a  where Id in:accountIds])	{
			string userList ='';
			for(contact con : acc.Contacts){
				userList += mapUsers.get(con.Id) +';';	
			}
			mpReturn.put(acc.Id,userList);
		}	
		
		return mpReturn;
	}
    /**
     * @description process events/tasks inserted or updated by partner users and update status of
     * lead/tp associated to note
     * 
     * @param eventTask List of Event/Task inserted/updated
     */
    public static void processPrmEventTask(List<SObject> eventTasks){
        Set<Id> eventTaskOwnerSet = new Set<Id>();
        Set<Id> partnerUserIds = new Set<Id>();
        Map<Id,Id> leadEventTaskOwnerMap = new Map<Id,Id>();
        Map<Id,Id> tpEventTaskOwnerMap = new Map<Id,Id>();
        
        //Get inserted/updated attachments owner ids
        for(Sobject o:eventTasks){
            eventTaskOwnerSet.add((Id)o.get('OwnerId'));
            eventTaskOwnerSet.add((Id)o.get('LastModifiedById'));
        }

        //Check if inserted/updated attachments were made by partner user
        partnerUserIds = getPartnerUsers(eventTaskOwnerSet);
        if(partnerUserIds.size()>0){
            //System.debug(partnerUsers);
            //Update Partner Lead Note map, and Partner TP Note map.
            for(Sobject o:eventTasks){
                Id eventTaskOwnerId = (Id)o.get('OwnerId');
                Id eventTaskLastModifiedById = (Id)o.get('LastModifiedById');
                Id eventTaskWhoId = (Id)o.get('WhoId');
                Id eventTaskWhatId = (Id)o.get('WhatId');
                Id potentialPsr = partnerUserIds.contains(eventTaskOwnerId)?eventTaskOwnerId:partnerUserIds.contains(eventTaskLastModifiedById)?eventTaskLastModifiedById:null;
                System.debug(eventTaskWhoId + '|' + eventTaskWhatId + '|' + potentialPsr);
                if(eventTaskWhoId!=null && eventTaskWhoId.getSObjectType() == Lead.sObjectType && potentialPsr != null){
                    //System.debug('Is a lead:' + a.ParentId);
                    leadEventTaskOwnerMap.put(eventTaskWhoId,potentialPsr);
                }
                if(eventTaskWhatId!=null && eventTaskWhatId.getSObjectType() == Assigned_Partner__c.sObjectType  && potentialPsr != null){
                    tpEventTaskOwnerMap.put(eventTaskWhatId,potentialPsr);
                }
            }

            Set<String> statuses = new Set<String>();
            statuses.add('Partner Assigned');
            statuses.add('Assigned to PSR');
            List<Lead> leadsToUpdate = getLeadsByStatus(leadEventTaskOwnerMap.keySet(),statuses);
            List<Assigned_Partner__c> tpToUpdate = getTpByStatus(tpEventTaskOwnerMap.keySet(),statuses);
            if(leadsToUpdate.size()>0){
                System.debug(leadsToUpdate);
                for(Lead l:leadsToUpdate){
                    if('Partner Assigned'.equals(l.Partner_Lead_Status__c) &&
                       l.PSR_1__c == null && l.PSR_2__c == null && l.PSR_3__c == null)
                    {
                       l.PSR_1__c = leadEventTaskOwnerMap.get(l.Id);
                    }
                    l.prm_Non_Lead_Edit__c = true;
                    l.Partner_Lead_Status__c = 'Actively Working';
                }
                System.debug(leadsToUpdate);
                try{
                    System.debug('prmUtils.processPrmattachments(): Attempting to update leads status after adding attachments');
                    update leadsToUpdate;
                } catch(DmlException e) {
                    System.debug('The following exception has occurred: ' + e.getMessage());
                }
            }
    
            if(tpToUpdate.size() > 0){
                System.debug(tpToUpdate);
                for(Assigned_Partner__c tp:tpToUpdate){
                    if('Partner Assigned'.equals(tp.Partner_Status__c) &&
                       tp.Assigned_Partner_Sales_Rep__c == null && tp.Assigned_Partner_Sales_Rep_2__c == null && tp.Assigned_Partner_Sales_Rep_3__c == null)
                    {
                       tp.Assigned_Partner_Sales_Rep__c = tpEventTaskOwnerMap.get(tp.Id);
                    }
                    tp.Partner_Status__c = 'Actively Working';
                }
                System.debug(tpToUpdate);
                try{
                    System.debug('prmUtils.processPrmattachments(): Attempting to update TP status after adding attachments');
                    update tpToUpdate;
                } catch(DmlException e) {
                    System.debug('The following exception has occurred: ' + e.getMessage());
                }
            }
        }
    }
}