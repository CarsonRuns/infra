trigger EZProtectContentDocumentLinkTrigger on ContentDocumentLink ( after insert, before delete ) {
    if ( Trigger.isAfter && Trigger.isInsert ) {
        /*Set<Id> ids = new Set<Id>();
        for (ContentDocumentLink link : Trigger.new) {
            ids.add(link.ContentDocumentId);
        }
        //EZProtectContentDocumentLinkHandler.handleInsert( ids );
        */
//        insert EZProtectContentDocumentLinkHandler.afterInsert( trigger.new );
        
        ID jobID = System.enqueueJob( new EZProtectContentDocumentLinkHandler( trigger.new ));
        
       
    } else if ( Trigger.isBefore && Trigger.isDelete ) {
        EZProtectContentDocumentLinkHandler.beforeDelete( trigger.old );
    }
}