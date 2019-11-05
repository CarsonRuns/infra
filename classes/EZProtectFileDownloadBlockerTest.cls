@isTest
private class EZProtectFileDownloadBlockerTest {
  
    static testMethod void getHandlerTest() {
        EZProtectConfig__c settings = EZProtectConfig__c.getOrgDefaults();
        settings.integrationUser__c = UserInfo.getUserId();
        upsert settings EZProtectConfig__c.Id;

        ContentVersion record = new ContentVersion();
        record.ContentURL='http://www.google.com/'; 
        record.Title = 'Google.com';
        insert record;
        record = [ select id, ContentDocumentId from ContentVersion where Id=:record.Id limit 1 ];
        System.debug( 'record: ' + record.ContentDocumentId );
        ContentVersion item = record;
        Test.startTest();
        EZProtectFileDownloadBlocker blocker = new EZProtectFileDownloadBlocker();
        blocker.getContentDownloadHandler(new List<Id> {item.Id}, null);
        Test.stopTest();
    }
    
    static testMethod void isDownloadBlockedByNoIds() {
        EZProtectConfig__c settings = EZProtectConfig__c.getOrgDefaults();
        settings.integrationUser__c = UserInfo.getUserId();
        upsert settings EZProtectConfig__c.Id;

        ContentVersion record = new ContentVersion();
        record.ContentURL='http://www.google.com/'; 
        record.Title = 'Google.com';
        insert record;
        record = [ select id, ContentDocumentId from ContentVersion where Id=:record.Id limit 1 ];
        System.debug( 'record: ' + record.ContentDocumentId );
        ContentVersion item = record;
        Test.startTest();
        EZProtectFileDownloadBlocker blocker = new EZProtectFileDownloadBlocker();
        System.assert( ! blocker.isDownloadBlocked(true, null, null, null, null));
        Test.stopTest();
    }
    
    static testMethod void isDownloadBlockedUsingBlockingDisabled() {

        Test.startTest();
        EZProtectFileDownloadBlocker blocker = new EZProtectFileDownloadBlocker();
        System.assert( ! blocker.isDownloadBlocked(false, new List<Id>(), null, null, null));
        Test.stopTest();
    }
      
    static testMethod void isDownloadBlockedUsingIntegrationUser() {
        ContentVersion record = new ContentVersion();
        record.ContentURL='http://www.google.com/'; 
        record.Title = 'Google.com';
        insert record;
        EZProtect_Setting__mdt setting = new EZProtect_Setting__mdt();
        List<EZProtect_Setting__mdt> profileMatches = new List<EZProtect_Setting__mdt>();
        List<Id> ids = new List<Id> {record.Id};
        Test.startTest();
        EZProtectFileDownloadBlocker blocker = new EZProtectFileDownloadBlocker();
        String testId = '005000000000000AAA';
        EZProtectConfig__c config = new EZProtectConfig__c();
        config.integrationUser__c = testId;
        System.assert( ! blocker.isDownloadBlocked(true, ids, testId, config, profileMatches));
        Test.stopTest();
    }   
   
    static testMethod void isDownloadBlockedUsingUnblockedProfile() {
        ContentVersion record = new ContentVersion();
        record.ContentURL='http://www.google.com/'; 
        record.Title = 'Google.com';
        insert record;
        EZProtect_Setting__mdt setting = new EZProtect_Setting__mdt();
        List<EZProtect_Setting__mdt> profileMatches = new List<EZProtect_Setting__mdt> {setting};
        List<Id> ids = new List<Id> {record.Id};
        Test.startTest();
        EZProtectFileDownloadBlocker blocker = new EZProtectFileDownloadBlocker();
        System.assert( ! blocker.isDownloadBlocked(true, ids, '005000000000000AAA', null, profileMatches));
        Test.stopTest();
    }

        
    static testMethod void isDownloadBlockedUsingLogRecordFound() {
        Blob data = Blob.valueOf('test data');
        List<Id> ids = new List<Id>();
        ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S';
        cv.VersionData = data;
        cv.Title = 'fileName'; 
        cv.PathOnClient = 'filename';
        insert cv;
        ids.add(cv.Id);
        EZProtectLog__c log = new EZProtectLog__c();
        log.Target_Id__c = cv.Id;
        insert log;
        EZProtectConfig__c config = EZProtectConfig__c.getOrgDefaults();
        config.Block_Downloads_Until_Scanned__c = true;
        upsert config EZProtectConfig__c.Id;
        List<EZProtect_Setting__mdt> profileMatches = new List<EZProtect_Setting__mdt>();

        Test.startTest();
        EZProtectFileDownloadBlocker blocker = new EZProtectFileDownloadBlocker();
        System.assert( ! blocker.isDownloadBlocked(true, ids, '005000000000000AAA', null, profileMatches));
    	Test.stopTest();
    }
    
    static testMethod void isDownloadBlockedUsingNoLogRecord() {
        Blob data = Blob.valueOf('test data');
        List<Id> ids = new List<Id>();
        ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S';
        cv.VersionData = data;
        cv.Title = 'fileName'; 
        cv.PathOnClient = 'filename';
        insert cv;
        ids.add(cv.Id);

        EZProtectConfig__c config = EZProtectConfig__c.getOrgDefaults();
        config.Block_Downloads_Until_Scanned__c = true;
        upsert config EZProtectConfig__c.Id;
        List<EZProtect_Setting__mdt> profileMatches = new List<EZProtect_Setting__mdt>();

        Test.startTest();
        EZProtectFileDownloadBlocker blocker = new EZProtectFileDownloadBlocker();
        System.assert( blocker.isDownloadBlocked(true, ids, '005000000000000AAA', null, profileMatches));
    	Test.stopTest();
    }
    
    static testMethod void prepareHandlerWhenUnblocked() {
        Blob data = Blob.valueOf('test data');
        List<Id> ids = new List<Id>();
        ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S';
        cv.VersionData = data;
        cv.Title = 'fileName'; 
        cv.PathOnClient = 'filename';
        insert cv;
        ids.add(cv.Id);

        EZProtectFileDownloadBlocker blocker = new EZProtectFileDownloadBlocker();
        Test.startTest();
        try {
            Sfc.ContentDownloadHandler handler = blocker.prepareHandler(false, ids);
            System.assertEquals(true, handler.isDownloadAllowed);
         } catch (Exception e) {
            System.assert(false, 'Exception thrown');
        }
    	Test.stopTest();
    }
    
    static testMethod void prepareHandlerWhenBlocked() {
        Blob data = Blob.valueOf('test data');
        List<Id> ids = new List<Id>();
        ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S';
        cv.VersionData = data;
        cv.Title = 'fileName'; 
        cv.PathOnClient = 'filename';
        insert cv;
        ids.add(cv.Id);

        EZProtectFileDownloadBlocker blocker = new EZProtectFileDownloadBlocker();
        Test.startTest();
        try {
            Sfc.ContentDownloadHandler handler = blocker.prepareHandler(true, ids);
            System.assertEquals(false, handler.isDownloadAllowed);
         } catch (Exception e) {
            System.assert(false, 'Exception thrown');
        }
    	Test.stopTest();
    } 
}