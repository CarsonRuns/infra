// This trigger is used for storing the posted content information into TxLog object
// Release -- FY'14 R3 Rel
trigger AttachedContent on FeedItem (after insert) {    
    List <Tx_log__c> txList = new List<Tx_log__c>();
    List<ContentVersion> cv = new List<ContentVersion>();
    List<Id> cvID = new List<Id>();   
    Map<Id,String> cvID_title = new Map<Id,String>(); 
    Map<Id,String> cvID_docId = new Map<Id,String>();       
    for(FeedItem  fi : trigger.new) {  
        cvID.add(fi.RelatedRecordId);     
    } 
    for(ContentVersion c : [Select Id, fileType, title, contentUrl,ContentDocumentid from ContentVersion where id=:cvID]){             
        cvID_title.put(c.Id, c.title);
        cvID_docId.put(c.Id, c.ContentDocumentid);
    } 
    for(FeedItem  at : trigger.new) {                       
        if (String.valueOf(at.parentId).startsWith(Opportunity.sObjectType.getDescribe().getKeyPrefix())){   
            if(at.RelatedRecordId != null){
                Tx_log__c tl = new Tx_log__c();
                tl.originated__c = 'SE-Suggested Content';            
                tl.object_ID__c = cvID_docId.get(at.RelatedRecordId);            
                tl.opportunity__c = at.parentId;            
                tl.user__c = UserInfo.getUserId();            
                tl.message__c = cvID_title.get(at.RelatedRecordId);            
                tl.type__c = 'posted';                         
                txList.add(tl); 
            }                           
         }else{
            if(at.RelatedRecordId != null){ 
                Tx_log__c t2 = new Tx_log__c();            
                t2.originated__c = 'Chatter Content';            
                t2.object_ID__c = cvID_docId.get(at.RelatedRecordId);
              //  t2.opportunity__c = at.parentId;            
                t2.user__c = UserInfo.getUserId();            
                t2.message__c = cvID_title.get(at.RelatedRecordId);            
                t2.type__c = 'posted';                         
                txList.add(t2);
            } 
         }        
     } if(txList.size() > 0){              
         insert txList;     
     }
}