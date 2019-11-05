public without sharing class EZProtectFileDownloadBlocker implements Sfc.ContentDownloadHandlerFactory {    
    private static EZProtectConfig__c config = EZProtectConfig__c.getOrgDefaults();

    public Sfc.ContentDownloadHandler getContentDownloadHandler(List<Id> ids, Sfc.ContentDownloadContext c) {  
        return prepareHandler(isDownloadBlocked(config.Block_Downloads_Until_Scanned__c, ids, UserInfo.getUserId(), 
                                                config, profileMatches(UserInfo.getProfileId())), ids);
    }
    
    public Sfc.ContentDownloadHandler prepareHandler(Boolean isDownloadBlocked, List<Id> ids) {  
        System.debug('..'+ isDownloadBlocked + '.....'+ ids);
        Sfc.ContentDownloadHandler cdh = new Sfc.ContentDownloadHandler(); 
        cdh.isDownloadAllowed = !isDownloadBlocked;
        if (isDownloadBlocked && ids!=null) {         
           // cdh.downloadErrorMessage = 'At least one file of '+ ids +' has not yet been scanned for viruses.';
            System.debug('shortid...'+ ids);
            List<String> longIds = getLongIds(ids);
            System.debug('logid..'+ longIds);
            List<EZProtectLog__c> logs = [select status__c from EZProtectLog__c where Target_Id__c in :longIds];
            String status = 'Pending';
            
            if(logs.size() > 0){
                status = logs[0].status__c;
            }
            cdh.redirectUrl = '/apex/EZProtect_Download_Blocked?type='+ status; 
        }

        return cdh;
    }
    
    public static List<EZProtect_Setting__mdt> profileMatches(String profileId) {
        return [select developerName from EZProtect_Setting__mdt where Unblocked_Downloads_Profile_Id__c=:profileId];
    }
       
    public Boolean isDownloadBlocked(Boolean isBlockingEnabled, List<Id> ids, String userId, EZProtectConfig__c config, List<EZProtect_Setting__mdt> profileMatches) {
        Boolean isBlocked = true;
        List<String> longIds = getLongIds(ids);
        Boolean flag = true;
        List<EZProtectLog__c> log = [select status__c from EZProtectLog__c where Target_Id__c in :longIds];
        
        if(log.size() == 0 || log[0].status__c == 'Dirty' || log[0].status__c == 'Pending'){
            flag = false;
        }
        
        if (ids==null || (profileMatches!=null && profileMatches.size()>0) || !isBlockingEnabled
                || (config!=null && (Id.valueOf(config.integrationUser__c)==Id.valueOf(userId)))
                || flag) {
            isBlocked = false;
        }
        return isBlocked;
    }
    
    public List<String> getLongIds(List<Id> ids){
        List<String> longIds = new List<String>();
        if (ids != null) {
            for (Id shortId: ids) {
                String longId = Id.valueOf(shortId);
                longIds.add(longId);
            }
        }
        
        return longIds;
    }
}