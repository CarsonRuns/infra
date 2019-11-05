public without sharing class EZProtectContentVersionHandler {
    public class EZProtectException extends Exception {}
    
    public static void afterInsert( List<ContentVersion> newRecords ) {
        insertWithRetry(contentDocumentLinks(newRecords));
    }
    
    public static void insertWithRetry( List<ContentDocumentLink> links ) {
        Integer count;
        for (ContentDocumentLink link : links) {
            count = 0;
            while (count < 2) {
                try {
                    insert link;
                    System.debug('Insert succeeded ' + link.contentdocumentId);
                    break;
                } catch (Exception e) {
                    if (count==0) {
                        System.debug('First insert failed '  + link.contentdocumentId);
                    } else {
                        System.debug('Retry insert failed ' + link.contentdocumentId);
                        break;
                    }
                }
                count++;
            }
        }
    }
    
    public static List<ContentDocumentLink> contentDocumentLinks( List<ContentVersion> newRecords ) {
        List<ContentDocumentLink> links = new List<ContentDocumentLink>();
        ContentDocumentLink link;
        Id integrationUserId = integrationUserId();
        
        for (ContentVersion record : newRecords) {
            link = new ContentDocumentLink();
            link.ContentDocumentId = record.ContentDocumentId;
            link.ShareType = 'C';
            link.Visibility = 'AllUsers';
            link.LinkedEntityId = integrationUserId;
            
            links.add(link);            
        }
        return links;
    }
    
    public static Id integrationUserID() {
        List<EZProtect_Setting__mdt> settings = [select IntegrationUserID__c from EZProtect_Setting__mdt limit 1];
        Id result = null;
        if (settings.size()==1) {
            result = settings.get(0).IntegrationUserID__c;
        }
        return result;
    }
    
}