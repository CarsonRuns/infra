global without sharing class EZProtectPrivilegedUtilities {
    /*global static Boolean shouldTriggerDeletions() {
        EZProtectConfig__c config = EZProtectConfig__c.getOrgDefaults();
        return ( config != null && config.Trigger_File_Deletions__c != null && config.Trigger_File_Deletions__c );
    }
    */
    global static void deleteFiles( List<EZProtectLog__c> files ) {
        // if (!shouldTriggerDeletions()) {return;}
        Map<String,Set<Id>> dirtyFiles = mapOfDirtyFilesByType( files );
        for ( String targetType : dirtyFiles.keySet() ) {
            findAndDeleteFiles( targetType, dirtyFiles.get( targetType ));
        }
    }
    
    global static Map<String,Set<Id>> mapOfDirtyFilesByType( List<EZProtectLog__c> files ) {
        Map<String,Set<Id>> result = new Map<String,Set<Id>> { 'Attachment' => new Set<Id>(), 'ContentVersion' => new Set<Id>(), 'ContentDocument' => new Set<Id>(), 'Document' => new Set<Id>(), 'StaticResource' => new Set<Id>() };
            for ( EZProtectLog__c record : files ) {
                if ( record.Status__c=='Dirty' ) {
                    result.get( record.Target_Type__c ).add( Id.valueOf( record.Target_Id__c ));
                }
            }
        return result;
    }
    
    @future
    global static void findAndDeleteFiles( String targetType, Set<Id> targetIds ) {
        delete findTargetRecords( targetType, confirmedTargets( targetIds ));
    }
    
    global static Set<String> confirmedTargets( Set<Id> targetIds ) {
        Set<String> results = new Set<String>();
        for ( EZProtectLog__c log : [ Select Target_Id__c from EZProtectLog__c where Target_id__c in :targetIds ]) {
            results.add( log.Target_id__c );
        }
        return results;
    }
    
    global static SObject[] findTargetRecords(String targetType, Set<String> targetIds) {
        SObject[] results = new SObject[] {};
            if ( targetType == 'ContentDocument' ) {
                results = [Select id from ContentDocument where Id in :targetIds];
            } else if ( targetType == 'ContentVersion' ) {
                results = [select id from ContentDocument where id in (select contentDocumentId from ContentVersion where id in :targetIds)];
            } else if ( targetType == 'Document' ) {
                results = [Select id from Document where Id in :targetIds];
            } else if ( targetType == 'Attachment' ) {
                results = [Select id from Attachment where Id in :targetIds];
            } else if ( targetType == 'StaticResource' ) {
                results = [Select id from StaticResource where Id in :targetIds];
            }
        return results;
    }
    
    // Handling the scan results
    global static void scanHandler(List<EZProtectLog__c> files ){
        System.debug('File size..'+ files.size());
        EZProtectConfig__c config = EZProtectConfig__c.getOrgDefaults();
        if(config == null)
            return;
        
        System.debug('config.'+ config);
        if(config.Replace_with_Text_File_Enabled__c != NULL && config.Replace_with_Text_File_Enabled__c){
            // Replacing the file with text file  
            repalceDirtyFilesWithText(files);
        }else if(config.Trigger_File_Deletions__c != null && config.Trigger_File_Deletions__c){
            // Deleting the files
            deleteFiles(files);
        }
    }
    
    //Replacing the dirty files with text excepts contentVersion.
    global static void repalceDirtyFilesWithText(List<EZProtectLog__c> files ){
        System.debug('Replace...'+ files);
        Map<String,Set<Id>> dirtyFiles = mapOfDirtyFilesByType( files );
        System.debug('dirtyFiles...'+dirtyFiles);
        for ( String targetType : dirtyFiles.keySet() ) {
            System.debug('targetType..'+targetType);
            if(targetType == 'Document' || targetType == 'Attachment'){
                Set<Id> targetIds = dirtyFiles.get( targetType );
                System.debug('...targetIds..'+targetIds);
                if(targetIds.size() == 0)
                    continue;
                
                findAndUpdateFiles( targetType, targetIds);    
            }
        }
    }
    
    // Updating th files by text files
    @future
    global static void findAndUpdateFiles( String targetType, Set<Id> targetIds ) {
        System.debug('target ids..'+ targetIds);
        findTargetAndReplaceFiles( targetType, confirmedTargets( targetIds ));
    }
    
    // Replace the file with text file
    global static void findTargetAndReplaceFiles(String targetType, Set<String> targetIds) {
        
        System.debug('targetType....'+ targetType);
        Document[] docResults = new Document[] {};
        Attachment[] attResults = new Attachment[]{};
        Attachment[] attDeleteResults = new Attachment[]{};
        Document[] deleteResults = new Document[]{};

            if ( targetType == 'Document' ) {
                List<Document> documents = [SELECT Id, Name, Body, ContentType, AuthorId,FolderId, DeveloperName,Type FROM Document WHERE Id  IN :targetIds];
                System.debug('Documents Returned:' + documents);
                for(Document document : documents){

                    if(document.FolderId == document.AuthorId)
                    {
                        Document document2 = new Document();
                        document2.Body = Blob.valueOf(Label.EZProtect_Text_File_Content);
                        document2.Type = 'txt';
                        document2.Name = document.Name + '_REPLACED';
                        document2.ContentType = 'text/plain';
                        document2.AuthorId = document.AuthorId;
                        document2.FolderId = document.FolderId;
                        document2.DeveloperName = document.DeveloperName + '_REPLACED';
                        Docresults.add(document2);
                        deleteResults.add(document);
                    }
                    else 
                    {
                        document.Body = Blob.valueOf(Label.EZProtect_Text_File_Content);
                        document.ContentType = 'text/plain';
                        document.Type = 'txt';
                        document.Name = document.Name + '_REPLACED'; 
                        document.DeveloperName = document.DeveloperName + '_REPLACED';
                        docResults.add(document); 

                    }
                      
                       
                     
                }
            } else if ( targetType == 'Attachment' ) {
                List<Attachment> attachments = [Select Id, Name, Body, ContentType,Description,OwnerId,ParentId from Attachment where Id in :targetIds];
                
                for(Attachment attachment : attachments)
                {
                    Attachment newattachment = new Attachment();
                    
                    newattachment.Body = Blob.valueOf(Label.EZProtect_Text_File_Content);
                    newattachment.Description = attachment.description;
                    newattachment.ownerid = attachment.ownerid;
                    newattachment.ContentType = 'text/plain';
                    newattachment.Name = 'REPLACED_' + attachment.Name;  
                    newattachment.ownerid = attachment.ownerid;
                    newattachment.parentid = attachment.parentid; 
                    attResults.add(newattachment);    
                    attDeleteResults.add(attachment); 
                }                                
            }
        if(deleteResults.size() > 0) delete deleteResults;
        if(docResults.size() > 0) upsert docResults;
        if(attResults.size() > 0) insert attResults;
        if(attDeleteResults.size() > 0) delete attDeleteResults;
        
    }
    
}