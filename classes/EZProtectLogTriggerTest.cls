@isTest
private class EZProtectLogTriggerTest {
    
    static testMethod void basicTest() {
        addIntegrationUser();
        ContentVersion item = addContentVersion();
        //ContentDocumentLink link = [ select id from ContentDocumentLink where ContentDocumentId=:item.ContentDocumentId ];
        
        Test.startTest();
        EZProtectLog__c log = new EZProtectLog__c( Target_id__c=item.ContentDocumentId, Target_Type__c='ContentDocument', Status__c='Dirty' );
        insert log;
        
        ContentVersion deleted = [ select id from ContentVersion where id=:item.Id ];
        System.debug( 'deleted: ' + deleted );
        Test.stopTest();
    }
    
    static testMethod void EZPAttachmentLogTest() {
        addIntegrationUserWithReplaceFlag();
        
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        
        Attachment attachment = new Attachment();
        attachment.Body = Blob.valueOf('Testing');
        attachment.ContentType = 'text/plain';
        attachment.Name = 'Test Attachment';
        attachment.ParentId = acc.Id;
        
        insert attachment;
        System.assertEquals('Test Attachment', attachment.Name);
        
        Test.startTest();
        EZProtectLog__c log = new EZProtectLog__c( Target_id__c = attachment.Id, 
                                                  Target_Type__c = 'Attachment', Status__c='Dirty' );
        insert log;
        Test.stopTest();
    }
    
    static testMethod void EZPDocumentLogTest() {
        addIntegrationUserWithReplaceFlag();
        
        Document document = new Document();
        document.Body = Blob.valueOf('Testing');
        document.ContentType = 'text/plain';
        document.Type = 'txt';
        document.Name = 'Test Doc'; 
        document.FolderId = [select id from folder where name = 'EZProtect'].id;
        insert document;
        System.assertEquals('Test Doc', document.Name);
        
        Test.startTest();
        EZProtectLog__c log = new EZProtectLog__c( Target_id__c = document.Id, 
                                                  Target_Type__c = 'Document', Status__c='Dirty' );
        insert log;
        Test.stopTest();
    }
   

/*
    static testMethod void integrationUserLinkDeletionBlockedTest() {
        addIntegrationUser();
        ContentVersion item = addContentVersion();
        Id currentUserId = UserInfo.getUserId();
        ContentDocumentLink link = [ select id from ContentDocumentLink where ContentDocumentId=:item.ContentDocumentId and LinkedEntityId=:currentUserId limit 1];
        system.debug('there is a link: ' + link);

        Test.startTest();
        Boolean deletionFailed = false;
        try {
            delete link;
            system.debug('delete succe');

        } catch ( Exception e ) {
            deletionFailed = true;
        }

        System.assertEquals( true, deletionFailed, 'deletion of integration record expected to fail' );
        Test.stopTest();
    }
    */
    
    static testMethod void deleteContentDocumentLinkTest() {
        addIntegrationUser();
        ContentVersion item = addContentVersion();
        ContentDocumentLink link = [ select id, LinkedEntityId from ContentDocumentLink where ContentDocumentId=:item.ContentDocumentId limit 1];

        Test.startTest();
        EZProtectContentDocumentLinkHandler.beforeDelete(new List<ContentDocumentLink> {link});
        Test.stopTest();
    }

    public static void addIntegrationUser() {
        EZProtectConfig__c settings = EZProtectConfig__c.getOrgDefaults();
        settings.integrationUser__c = UserInfo.getUserId();
        settings.Block_Downloads_Until_Scanned__c = true;
        //settings.Replace_with_Text_File_Enabled__c = true;
        settings.Trigger_File_Deletions__c = true;
        //upsert settings EZProtectConfig__c.Id;
        upsert settings;
    }
    
    public static void addIntegrationUserWithReplaceFlag() {
        EZProtectConfig__c settings = EZProtectConfig__c.getOrgDefaults();
        settings.integrationUser__c = UserInfo.getUserId();
        settings.Block_Downloads_Until_Scanned__c = true;
        settings.Replace_with_Text_File_Enabled__c = true;
        settings.Trigger_File_Deletions__c = true;
        //upsert settings EZProtectConfig__c.Id;
        upsert settings;
    }

    public static ContentVersion addContentVersion() {

        ContentVersion record = new ContentVersion();
        record.ContentURL='http://www.google.com/'; 
        record.Title = 'Google.com';
        insert record;
        record = [ select id, ContentDocumentId, PublishStatus from ContentVersion where Id=:record.Id limit 1 ];
        System.debug( 'record: ' + record.ContentDocumentId );

        return record;
   }
}