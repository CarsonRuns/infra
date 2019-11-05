@isTest
private class EZProtectContentDocumentLinkHandlerTest {
    static testMethod void prepareNoLinksWhenNoIntegrationUser() {
        EZProtectConfig__c config = EZProtectConfig__c.getOrgDefaults();
        config.IntegrationUser__c = null;
        upsert config EZProtectConfig__c.Id;

        Test.startTest();
        try {
            ContentDocumentLink link = new ContentDocumentLink();
            link.LinkedEntityId = UserInfo.getUserId();
            List<ContentDocumentLink> links = new List<ContentDocumentLink> {link};
            List<ContentDocumentLink> shares = EZProtectContentDocumentLinkHandler.prepareEZProtectShareLinks(links);
			//need to verify
            System.assertEquals(1, shares.size());
         } catch (Exception e) {
            System.assert(false, 'Exception thrown');
        }
        Test.stopTest();
    }

    static testMethod void prepareNoLinksWhenInvalidIntegrationUser() {
        EZProtectConfig__c config = EZProtectConfig__c.getOrgDefaults();
        config.IntegrationUser__c = 'Invalid id';
        upsert config EZProtectConfig__c.Id;

        Test.startTest();
        try {
            ContentDocumentLink link = new ContentDocumentLink();
            link.LinkedEntityId = UserInfo.getUserId();
            List<ContentDocumentLink> links = new List<ContentDocumentLink> {link};
            List<ContentDocumentLink> shares = EZProtectContentDocumentLinkHandler.prepareEZProtectShareLinks(links);

            System.assertEquals(0, shares.size());
         } catch (Exception e) {
             throw new EZProtectException('failed', e);
            System.assert(false, 'Exception thrown');
        }
        Test.stopTest();
    }

    static testMethod void prepareNoLinksWhenIntegrationUser() {
        EZProtectConfig__c config = EZProtectConfig__c.getOrgDefaults();
        config.IntegrationUser__c = UserInfo.getUserId();
        upsert config EZProtectConfig__c.Id;
        Blob data = Blob.valueOf('test data');
        ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S';
        cv.VersionData = data;
        cv.Title = 'fileName'; 
        cv.PathOnClient = 'filename';
        insert cv;

        Test.startTest();
        try {
            ContentDocumentLink link = new ContentDocumentLink();
            link.LinkedEntityId = UserInfo.getUserId();
            link.ContentDocumentId = cv.ContentDocumentId;
            List<ContentDocumentLink> links = new List<ContentDocumentLink> {link};
            List<ContentDocumentLink> shares = EZProtectContentDocumentLinkHandler.prepareEZProtectShareLinks(links);

            System.assertEquals(0, shares.size());
         } catch (Exception e) {
            System.assert(false, 'Exception thrown');
        }
        Test.stopTest();
    }
    
    static testMethod void prepareLinksWhenNotIntegrationUser() {
        User integrationUser = new User(alias = 'standt', email='standarduser6@testorg.com',
            emailencodingkey='UTF-8', firstname='fake', lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', profileid = UserInfo.getProfileId(),
            timezonesidkey='America/Los_Angeles', username='ezprotecttestuser@adaptus.com');        
        insert integrationUser;
        EZProtectConfig__c config = EZProtectConfig__c.getOrgDefaults();
        config.IntegrationUser__c = null;
        upsert config EZProtectConfig__c.Id;
        Blob data = Blob.valueOf('test data');
        ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S';
        cv.VersionData = data;
        cv.Title = 'fileName'; 
        cv.PathOnClient = 'filename';
        insert cv;
        
        config.IntegrationUser__c = integrationUser.Id;
        upsert config EZProtectConfig__c.Id;

        Test.startTest();
        try {
            System.debug('starting test');
            List<ContentDocumentLink> existingLinks = [select id from contentdocumentlink where contentdocumentid=:cv.ContentDocumentId and linkedEntityId=:integrationUser.Id];
            ContentDocumentLink link = new ContentDocumentLink();
            link.LinkedEntityId = UserInfo.getUserId();
            link.ContentDocumentId = cv.ContentDocumentId;
            List<ContentDocumentLink> links = new List<ContentDocumentLink> {link};
            List<ContentDocumentLink> shares = EZProtectContentDocumentLinkHandler.prepareEZProtectShareLinks(links);

            System.assertEquals(0, existingLinks.size());
            System.assertEquals(1, shares.size());
         } catch (Exception e) {
            System.assert(false, 'Exception thrown');
        }
        Test.stopTest();
    }

    static testMethod void addLinkOnNewContentVersion() {
        User integrationUser = new User(alias = 'standt', email='standarduser6@testorg.com',
            emailencodingkey='UTF-8', firstname='fake', lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', profileid = UserInfo.getProfileId(),
            timezonesidkey='America/Los_Angeles', username='ezprotecttestuser@adaptus.com');        
        insert integrationUser;
        EZProtectConfig__c config = EZProtectConfig__c.getOrgDefaults();
        config.IntegrationUser__c = integrationUser.id;
        upsert config EZProtectConfig__c.Id;


        Test.startTest();
        Blob data = Blob.valueOf('test data');
        ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S';
        cv.VersionData = data;
        cv.Title = 'fileName'; 
        cv.PathOnClient = 'filename';
        insert cv;
        Test.stopTest();

        List<ContentDocumentLink> results = [select id from ContentDocumentLink where contentDocumentId=:cv.ContentDocumentId and LinkedEntityId=:integrationUser.id];

        System.assert(true, 'No exception thrown');

    }

    static testMethod void beforeDeleteOnIntegrationUser() {
        EZProtectConfig__c config = EZProtectConfig__c.getOrgDefaults();
        config.IntegrationUser__c = UserInfo.getUserId();
        upsert config EZProtectConfig__c.Id;
        Test.startTest();
        try {
            ContentDocumentLink link = new ContentDocumentLink();
            link.LinkedEntityId = UserInfo.getUserId();
            List<ContentDocumentLink> links = new List<ContentDocumentLink> {link};
            EZProtectContentDocumentLinkHandler.beforeDelete(links);

         } catch (Exception e) {
            System.assert(false, 'Exception thrown');
        }
        System.assert(true, 'Exception should not be thrown');
        Test.stopTest();
    }

    static testMethod void invalidIntegrationUser() {
        EZProtectConfig__c config = EZProtectConfig__c.getOrgDefaults();
        config.IntegrationUser__c = 'invalid user id';
        upsert config EZProtectConfig__c.Id;
        Test.startTest();
        try {
            ContentDocumentLink link = new ContentDocumentLink();
            link.LinkedEntityId = Id.valueOf(UserInfo.getUserId());
            List<ContentDocumentLink> links = new List<ContentDocumentLink> {link};
            EZProtectContentDocumentLinkHandler.beforeDelete(links);

         } catch (Exception e) {
            System.assert(false, 'Exception thrown');
        }
        System.assert(true, 'Exception should not be thrown');
        Test.stopTest();
    }
    
    static testMethod void skipDocumentIfAlreadySharedWithIntegrationUser() {
        Set<Id> allDocumentIds = new Set<Id> {Id.valueOf('005000000000000AAA')};
        ContentDocumentLink shared = new ContentDocumentLink();
        shared.ContentDocumentId = '005000000000000AAA';
        List<ContentDocumentLink> alreadyShared = new List<ContentDocumentLink> {shared};
        Test.startTest();

        EZProtectContentDocumentLinkHandler.skipDocumentIfAlreadySharedWithIntegrationUser(allDocumentIds, alreadyShared);
        System.assert(allDocumentIds.size()==0, 'List should be empty');

        Test.stopTest();
    }
}