/************************************************************************************************************************************
Name    : QI_RestService 
Author  : Eric Pesch (epesch)
Purpose : REST endpoint for delete/insert bulk Opportunities
Created Date: 12/09/2017 
Modification History: 
* Modified By - bodurais on 03.20.2018
* Description - Added logic to update Opportunity with BOM Integrated Quote id, Date and EA Flag.
* Modified By - suhbhara on 08.12.2018
* Description - Point release change to fix mix% > 200 error during Mulesoft integration due to failure in delete id population
***
*************************************************************************************************************************************/

@RestResource(urlMapping='/QI/Opportunities/bulk/*')
global with sharing class QI_RestService {
    private static String TAG = '[QI_RestService] - ';
    
    @HttpPost
    global static void doPost(List<String> deleteIds, List<OpportunityLineItem> opptyLines, List<Opportunity> updateOppty){
        System.debug(TAG + 'deletes - ' + deleteIds);
        System.debug(TAG + 'creates - ' + opptyLines);
        Integer statusCode = 201;
        QIRestResults results = new QIRestResults();
        results.isRollback = false;
        String integratedQuoteId = '';
        Opportunity opty = null;
        String optyId = '';
        @TestVisible Boolean csLineActive = false;
        List<OpportunityLineItem> delOptyLines = new List<OpportunityLineItem>();
        Integer delRetryCount = 0;
        
        if(!updateOppty.isEmpty()){
            opty = updateOppty.get(0);
            optyId = opty.Id;
            List<Service_Level__c> csList = [SELECT id FROM Service_Level__c where id in (SELECT Service_Level_Ref__c FROM 
                                             OpportunityLineItem WHERE ProductCode = 'Service' AND OpportunityId = :optyId) and 
                                             allocated__c > 0.0 and allocated__c < 1.0];

            if(csList != null && csList.size() > 0){
                csLineActive = true;
                System.debug('CS List size ---> ' + csList.size());
            }                      
        }
        
        System.debug(TAG + 'Retry Count - ' + delRetryCount);
        System.debug(TAG + 'Delete lines - ' + delOptyLines.isEmpty());
        
        Savepoint sp = Database.setSavepoint();
        
        if(csLineActive == true){
            delOptyLines = [select id, Lastmodifieddate, CreatedDate from OpportunityLineItem where Product2.ProductCode = 'Technology' and OpportunityId = :optyId];
        } else {
            delOptyLines = [select id, Lastmodifieddate, CreatedDate from OpportunityLineItem where OpportunityId = :optyId and isdeleted = false];
        }
        while(delRetryCount != 5 && (delOptyLines.isEmpty()) ){
            if(csLineActive == true){
                delOptyLines = [select id, Lastmodifieddate, CreatedDate from OpportunityLineItem where Product2.ProductCode = 'Technology' and OpportunityId = :optyId];
            } else {
                delOptyLines = [select id, Lastmodifieddate, CreatedDate from OpportunityLineItem where OpportunityId = :optyId and isdeleted = false];
            }
            delRetryCount++;
            System.debug(TAG + 'Retry Count - ' + delRetryCount);
            System.debug(TAG + 'Delete lines - ' + delOptyLines.isEmpty());
        }
        
        
        //Delete OpportunityLineItem if available
        if(!delOptyLines.isEmpty()){
            
            System.debug(System.now());
            
            List<Id> delLines = new List<Id>();
            for(OpportunityLineItem deleteId : delOptyLines){
                System.debug('Opty line Created date --> ' + deleteId.Lastmodifieddate);
                System.debug('Opty line Last modified date --> ' + deleteId.CreatedDate);
                delLines.add(deleteId.Id);
            }
            
            //DML OPERATION
            results.deletes = Database.delete(delLines, false);
            for(Database.DeleteResult dr : results.deletes){
                System.debug(TAG + 'Delete Result - ' + dr);
                if(!dr.isSuccess()){
                    results.isRollback = true;
                }
            }
            
            if(results.isRollback){
                statusCode = 500;
            } 
        }
        
        //Create OpportunityLineItem if available and if deletes did not fail
        if((!results.isRollback) && (!opptyLines.isEmpty())){   
            //Fetch quote id from any one of the opportunity line item
            integratedQuoteId = opptyLines[0].QuoteId__c;
            //DML OPERATION
            results.inserts = Database.insert(opptyLines, false);
            for(Database.SaveResult dr : results.inserts){
                System.debug(TAG + 'Create Result - ' + dr);
                if(!dr.isSuccess()){
                    results.isRollback = true;
                } 
            }
            
            if(results.isRollback){
                statusCode = 500;
            } 
        }

        //Update Opportunity to set BOM integrated Quote id, Date, Is product integrated and Is service integrated flag
        if((!results.isRollback) && (!updateOppty.isEmpty())){ 
            //Update Opportunity with BOM integration date and Quote id
            for(Opportunity Opp: UpdateOppty) {
                    Opp.CCW_BOM_Integrated_Date__c = System.now();
                    Opp.CCW_BOM_Integrated_Quote_Id__c = integratedQuoteId;
            }
            //DML OPERATION
            results.updates = Database.update(updateOppty, false);
            for(Database.SaveResult dr : results.updates){
                System.debug(TAG + 'Update Result - ' + dr);
                if(!dr.isSuccess()){
                    results.isRollback = true;
                } 
            }
         
            if(results.isRollback){
                statusCode = 500;
            } 
        }
                
        //Rollback if required
        if(results.isRollback){
            Database.rollback(sp);            
        }
        
        //Build output
        String jsonRes = JSON.serialize(results);
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(jsonRes);
        RestContext.response.statusCode = statusCode;
        
        System.debug(TAG + 'Final Result - ' + jsonRes);
        system.debug('REST Response:'+ RestContext.response);
    }
    
    //Holding class for the results of the DML operations
    global class QIRestResults{
        Database.SaveResult[] updates;
        Database.DeleteResult[] deletes;
        Database.SaveResult[] inserts;
        Boolean isRollback;
    }
}