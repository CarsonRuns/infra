public without sharing class EZProtectContentDocumentLinkHandler implements Queueable {
    public class EZProtectException extends Exception {}
    
    public static List<ContentDocumentLink> prepareEZProtectShareLinks( List<ContentDocumentLink> newRecords ) {
        String integrationUser = EZProtectConfig__c.getOrgDefaults().IntegrationUser__c;
        List<ContentDocumentLink> shares = new List<ContentDocumentLink>();
        Set<Id> excludeIds = new Set<Id>();
        Set<Id> allDocumentIds = new Set<Id>();

        System.debug('integration user is set');
        Id integrationUserId;
        try {
            integrationUser = EZProtectConfig__c.getOrgDefaults().IntegrationUser__c;
        } catch (Exception e) {
            System.debug('EZProtect detected an invalid integration user ID in the EZProtectConfig__c custom setting.');
        }
        try {
            if (integrationUser==null) {
                integrationUser = getIntegrationUserId();
            }
            integrationUserId = Id.valueOf(integrationUser);
        } catch(Exception e) {
            System.debug('EZProtect detected an invalid integration user ID in the EZProtectConfig__c custom setting. No shares were added for these referenced files: ' + newRecords);
            return shares;
        }
        if (integrationUser==null) {
            return shares;
        }
        
        for (ContentDocumentLink record : newRecords) {
            if (record.LinkedEntityId==integrationUserId) {
                excludeIds.add(record.ContentDocumentId);
            } else if (!excludeIds.contains(record.ContentDocumentId)) {
                allDocumentIds.add(record.ContentDocumentId);
            }
        }
        
        skipDocumentIfAlreadySharedWithIntegrationUser(allDocumentIds, documentsSharedWithIntegrationUser(allDocumentIds, integrationUserId));
        
        for ( Id documentId : allDocumentIds ) {
            if (!excludeIds.contains(documentId)) {
                shares.add( new ContentDocumentLink( ContentDocumentId=documentId, LinkedEntityId=integrationUser, ShareType='V', Visibility='AllUsers' ));
            }
        }
        return shares;
    }
    
    public static void skipDocumentIfAlreadySharedWithIntegrationUser(Set<Id> allDocumentIds, List<ContentDocumentLink> alreadyShared) {
        for ( ContentDocumentLink link : alreadyShared)  {
            allDocumentIds.remove( link.ContentDocumentId );        // for each unique document, remove from set if it already has a link to the integration user
        }
    }
    
    public static List<ContentDocumentLink> documentsSharedWithIntegrationUser(Set<Id> documentIds, Id integrationUserId) {
        return [ Select ContentDocumentId from ContentDocumentLink where ContentDocumentId in :documentIds and LinkedEntityId=:integrationUserId ];
    }
    
    
    public static Id integrationUserId() {
        String integrationUser = EZProtectConfig__c.getOrgDefaults().IntegrationUser__c;
        Id result;
        try {
            result = Id.valueOf(integrationUser);
        } catch(Exception e) {}
        return result;
    }
    
    public static Id getIntegrationUserID() {
        List<EZProtect_Setting__mdt> settings = [select IntegrationUserID__c from EZProtect_Setting__mdt limit 1];
        Id result = null;
        if (settings.size()==1) {
            result = settings.get(0).IntegrationUserID__c;
        }
        return result;
    }

    public static void beforeDelete( List<ContentDocumentLink> oldRecords ) {
        for ( ContentDocumentLink link : oldRecords ) {
        system.debug('before linkedentityId = ' + Id.valueOf(link.linkedEntityId));
    //    system.debug('before integrationUser = ' + Id.valueOf(integrationUserId()));
            Id integrationUser = integrationUserId();
            if (integrationUser!=null && Id.valueOf(link.linkedEntityId) == Id.valueOf(integrationUser) ) {
                    system.debug('before addError ' );

                link.addError('EZProtect Integration User share cannot be removed.');
            }
        }
    }
    
    //------
   
    private List<ContentDocumentLink> targets;
    
    public EZProtectContentDocumentLinkHandler(List<ContentDocumentLink> input) {
        targets = input;
    }
    
    public void execute(QueueableContext context) {
        try {insert prepareEZProtectShareLinks(targets);} catch(Exception e) {}    
    }
    
}