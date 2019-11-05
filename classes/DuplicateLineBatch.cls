global class DuplicateLineBatch implements Database.Batchable<SObject>, Database.Stateful {
    
    //On Exception save Error for each record to DuplicateLine__c
    //Batch Id  
    
    Public String query;
    Public String email;
    Public String BatchId;
    Public Final String Technology = 'Technology';         
    Public Final String Service = 'Service';
    Public Final String delim = ';';
    Public String body;
    Public Static boolean debug = false;
    Public Integer totalOpptysUpdated;
    
    global DuplicateLineBatch() {
        body = System.now()+' Start';
        totalOpptysUpdated = 0;
    }    

    
    global database.Querylocator start(Database.BatchableContext BC){return Database.getQueryLocator(query);}

    global void execute(Database.BatchableContext BC,Sobject[] scope){
   //which lis to select, need to update after. 
        logInfo('\n\nbeginExecuteBatch ..........');
        BatchId = String.valueof( BC.getJobId() );
        Set<Id> optyIds = new Set<Id>();

        for(sobject s : scope){
            //OpportunityLineItem oli = (OpportunityLineItem)s;
            //optyIds.add(oli.OpportunityId);
            DuplicateLine__c dli = (DuplicateLine__c)s;
            optyIds.add(dli.OpptyEx__c);
        }
        Map<Id, String[]> liDetail = getLineDetails( optyIds ); 
        logInfo('optyCount =>'+ liDetail.size());
        updateOptys(liDetail);
        liDetail = null;
        logInfo('endExecuteBatch');        
    }    
    
    global Map<id,String[]> getLineDetails( Set<Id> optys ){
        logInfo('begin getLineDetails');// optys.size=>'+optys.size());
        Map<Id, String[]> liDetail = new Map<Id, String[]>();
        
        String tmpString;
        String tmpMix;
        for ( OpportunityLineItem oli : [ Select OpportunityId, Mix__c, PriceBookEntry.Name ,PriceBookEntry.ProductCode 
                                            from OpportunityLineItem where OpportunityId in :optys order by OpportunityId] ){
                String[] tmpValueList = new String[]{};
            if ( liDetail.containsKey( oli.OpportunityId ) ){
                tmpValueList = liDetail.get( oli.OpportunityId );
            }
            tmpMix = ( (oli.Mix__c != null) ? oli.Mix__c.format() : 'NA' );
            tmpString = oli.PriceBookEntry.ProductCode + delim + oli.PriceBookEntry.Name + ' ('+ tmpMix +')';
            tmpValueList.add(tmpString);
            liDetail.put(oli.OpportunityId, tmpValueList);
          
        }
        //tmpValueList = null;
        logInfo('end getLineDetails');
        return liDetail;
    }
    
    global void updateOptys(Map<Id, String[]> liDetail){
        logInfo('beginUpdateOptys');
        Map<Id, Opportunity> optyMap = new Map<Id, Opportunity>();
        Map<Id,DuplicateLine__c> dliMap = new Map<Id,DuplicateLine__c>();        
        String[] tmpDetailList = new String[]{};
        String[] tmpDetail = new String[]{};        
        Integer tech = 0;
        Integer svc = 0;
        String techDetail;
        String svcDetail;
        
        for (Id o : liDetail.keySet() ){
            techDetail = null;
            svcDetail = null;
            tmpDetailList = liDetail.get(o);
            tech=0; svc=0;
            for (Integer i = 0; i < tmpDetailList.size(); i++ ){
                tmpDetail = tmpDetailList.get(i).split(delim);
                if ( tmpDetail[0] == Technology ){
                    if ( tech++ == 0 ) techDetail = tmpDetail[1];
                    else techDetail = techDetail +';'+ tmpDetail[1];
                }
                else if ( tmpDetail[0] == Service ){
                    if ( svc++ == 0 ) svcDetail = tmpDetail[1];
                    else svcDetail = svcDetail +';'+ tmpDetail[1];
                }
            }
            Opportunity oTmp = new Opportunity( id=o, TECHNOLOGY_MERGE_FIELD__C=techDetail, SERVICE_MERGE_FIELD__C=svcDetail );
            optyMap.put(o, oTmp);
            DuplicateLine__c dliTmp = new DuplicateLine__c(OpptyEx__c=o, Status__c='Updated', BatchId__c = BatchId );
            dliMap.put(o, dliTmp);            
        }
        liDetail = null;
        tmpDetailList = null;
        tmpDetail = null;        

        
        Utilities.setSkip(true);
        Utilities.setValidationSkip(true);
        Utilities.setSkipFuture(true);
        logInfo('beforeupdate optys, \toptys to update -->' + optyMap.size());
        try {    
            updOpptys(optyMap, dliMap);            
            logInfo('afterupdate optys');        
        } catch (System.DmlException e) {                
            logInfo( 'updateoptys Exception count =>' + e.getNumDml() );
            for (Integer i = 0; i < e.getNumDml(); i++) {
                logInfo(  i +') [ ' + e.getDmlId(i) +' ] '+ e.getDmlMessage(i) );
                optyMap.remove( e.getDmlId(i) );
                dliMap.get( e.getDmlId(i) ).Status__c = 'Error';
                String tmpE = e.getDmlMessage(i);
                if (tmpE.length() > 255){ tmpE = tmpE.substring(0,255);}
                dliMap.get( e.getDmlId(i) ).message__c = tmpE ;
            }
            updOpptys(optyMap, dliMap);                            
        }
/*        Database.SaveResult[] lsr = database.update(optyMap.values(),false);
        for(Database.SaveResult sr : lsr){
            if(!sr.isSuccess()){
                Database.Error err = sr.getErrors()[0];
                logInfo('ex-'+ sr.getId() +':'+err);
            }                                
        }*/
       
        optyMap = null;
        logInfo('endUpdateOptys');
    }
    
    private void updOpptys(Map<Id,Opportunity> optyMap, Map<Id,DuplicateLine__c> dliMap){
        update optyMap.values();
        upsert dliMap.values() OpptyEx__c;
        totalOpptysUpdated = totalOpptysUpdated + optyMap.size();
    }        

    
    private void logInfo(String inString){
        System.debug('@@@ ' + inString);
//        System.debug('getHeapSize =>' + Limits.getHeapSize());
//        System.debug('ss =>' + Limits.getScriptStatements() +' total:'+ Limits.getLimitScriptStatements());
        body = body+'\n'+inString;
    }    
    
    global void finish(Database.BatchableContext BC){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {email});
        mail.setReplyTo('sfdc-integration-apex-exceptions@external.cisco.com');
        mail.setSubject('Duplicate Line Batch: Org=>'+ UserInfo.getOrganizationId()+', BatchId=>'+BatchId );
        mail.setPlainTextBody('total opptys updated=>' + totalOpptysUpdated + '\n\n'+System.now() +' Finish\n\n'+ body );
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}
    
/*
dameyer_dl recalculate = new dameyer_dl();
//recalculate.query='SELECT Id, OpportunityId FROM OpportunityLineItem limit 1000';
recalculate.query='SELECT OpptyEx__c from DuplicateLine__c where Status__c = \'ToUpdate\'';
recalculate.email='dameyer@cisco.com';
ID batchprocessid = Database.executeBatch(recalculate,100);
System.debug(batchprocessid);
*/