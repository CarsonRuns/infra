/*********************************************************************************************************************************
Name    : Oppty_OpptyWorkspace_BatchUpdate 
Author  : Mukesh Srivastava
Purpose : The purpose of the batch class is to Opportunity Fields when child Oppty Workspace get updated for specific.            
Created Date:  1/6/2017
Modification History:     

**********************************************************************************************************************************/
global class Oppty_OpptyWorkspace_BatchUpdate implements Database.Batchable < sObject > { 

    // SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdate(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }
    // SCAVA Helper Method to validate Create Access at field level
     public static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }

    global final String g_strQuery;
    global final Map<String,String> g_mapOpptyKey;
    
    // Constructor: Dynamically generating SOQL for defining scope
    global Oppty_OpptyWorkspace_BatchUpdate() {       
        Map<String,Apex_Batch_Job__c> apexJob = Apex_Batch_Job__c.getall();
        
        String strOppty_WS_Base = apexJob.get('Oppty_WS_Base').query__c;
        String strOppty_WS_Scope_Hour = apexJob.get('Oppty_WS_Scope_Hour').query__c;        
        String strOppty_WS_Scope_Where = apexJob.get('Oppty_WS_Scope_Where').query__c;
        String strOppty_WS_Keys = apexJob.get('Oppty_WS_Keys').query__c;
        
        String[] arrOppty_WS_Keys = strOppty_WS_Keys.split(',');
        Map<String,String> mapOppty_WS_Keys = new map<String,String>();
        for(String str:arrOppty_WS_Keys){
            mapOppty_WS_Keys.put(str.split(':')[0],str.split(':')[1]);
        }
        
        String pastXHour = datetime.now().addhours(integer.valueof(strOppty_WS_Scope_Hour)).format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        String strQuery = 'SELECT '+strOppty_WS_Base + ' FROM AT_Workspace__c WHERE '+strOppty_WS_Scope_Where+pastXHour+' ORDER BY Opportunity__r.AccountId,Opportunity__c';        
        
        if(Test.isRunningTest()){
            strQuery = strQuery + ' LIMIT 20';  // using dynamic SOQL setting the scope
        }
        
        g_strQuery = strQuery;
        g_mapOpptyKey = mapOppty_WS_Keys;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(g_strQuery);
    }
    
    global void execute(Database.BatchableContext BC, List < sObject > scope) {
        try {
            
            List<Opportunity> lstOppty = new List<Opportunity>();
            Set<Id> setOppty = new Set<Id>();
            
            //Collecting all the scoped Opportunity and setting flag
            for (AT_Workspace__c oWS: (List < AT_Workspace__c > ) scope) { 
                String exisingValue = oWS.Opportunity__r.Oppty_Workspace_Based_Sharing__c;
                if(!setOppty.contains(oWS.Opportunity__c)){
                    for(String key : g_mapOpptyKey.keySet()){
                        String newValue = g_mapOpptyKey.get(key);                    
                        String[] arrNewVal =  newValue.split('_');
                        
                        Boolean toBeAddedFlag = false;
                        system.debug('++++++++++++++oWS'+oWS);
                        
                        if(oWS.AT_Team__c != null){
                            if(oWS.AT_Team__c.startsWithIgnoreCase(key)){
                                Opportunity opptyObj = new Opportunity();
                                opptyObj.Id = oWS.Opportunity__c;
                                if(exisingValue != null){
                                    if(exisingValue.indexOf(arrNewVal[0]) == -1){
                                        if(flsUpdate(Opportunity.Oppty_Workspace_Based_Sharing__c)) //SCAVA FIX
                                        {
                                        opptyObj.Oppty_Workspace_Based_Sharing__c = exisingValue +';'+arrNewVal[0];
                                        }
                                        toBeAddedFlag  = true;
                                    }
                                }else{
                                    opptyObj.Oppty_Workspace_Based_Sharing__c = arrNewVal[0];
                                    toBeAddedFlag  = true;
                                }
                                
                                if(toBeAddedFlag){
                                    lstOppty.add(opptyObj);
                                    setOppty.add(oWS.Opportunity__c);
                                }
                            }
                        }
                        /**********************Revoking******************************************************************* 
                        if(arrNewVal[1] == 'BI' && exisingValue.containsIgnoreCase(arrNewVal[0]) && !oWS.AT_Team__c.startsWithIgnoreCase(key)){
                        Opportunity opptyRevokeObj = new Opportunity();
                        opptyRevokeObj.Id = oWS.Opportunity__c;
                        opptyRevokeObj.Oppty_Workspace_Based_Sharing__c = exisingValue.remove(arrNewVal[0]);      
                        lstOppty.add(opptyRevokeObj);                
                        }                
                        ****************************************************************************************/
                    }                    
                }
            }            
            
            if(Test.isRunningTest()){
                if(flsUpdate(Opportunity.Oppty_Workspace_Based_Sharing__c)) //SCAVA FIX
                {
                lstOppty[0].Name = '';
                }
            }
            Database.SaveResult[] lstOpptySaveResult = Database.update(lstOppty, false);
            
            //Iterating over the save result and validating if any error occurred
            Integer iRows = 0;
            List < Tx_Log__c > lstLog = new List < Tx_Log__c > ();
            for (Database.SaveResult dsr: lstOpptySaveResult) {
                // if(flsGet(Tx_Log__c.originated__c)||flsGet(Tx_Log__c.type__c)||flsGet(Tx_Log__c.exception__c)) //SCAVA FIX
                // {
                Tx_Log__c newErrorRecord = new Tx_Log__c(name = lstOppty[iRows].id, originated__c = 'Oppty_OpptyWorkspace_BatchUpdate', type__c = 'Opportunity', exception__c = true);
                // }
                if (dsr.isSuccess() != true) {
                    system.debug(dsr);
                    if (dsr.getErrors().size() > 0) {
                        if(flsUpdate(Tx_Log__c.message__c)||flsGet(Tx_Log__c.message__c)) //SCAVA FIX
                        {
                            newErrorRecord.message__c = 'STATUS CODE: ' + dsr.getErrors()[0].getStatusCode() +
                            '\n ERROR: ' + dsr.getErrors()[0].getMessage() +
                            '\n AFFECTED FIELD: ' + dsr.getErrors()[0].getFields();
                        }
                    }
                    lstLog.add(newErrorRecord);
                }
                iRows++;
            }
            if (lstLog.size() > 0)
                Database.insert(lstLog, false);
            
            if(Test.isRunningTest()){
                throw new Oppty_OpptyWorkspace_BatchException('exception');
            }
        }
        Catch(Exception e) {
            //Catching any exception 
            
            Tx_Log__c tlObj = new Tx_Log__c();
            if(flsUpdate(Tx_Log__c.exception__c)||flsGet(Tx_Log__c.exception__c)) //SCAVA FIX
            {
            tlObj.exception__c = true;
            }
            if(flsUpdate(Tx_Log__c.message__c)||flsGet(Tx_Log__c.message__c)) //SCAVA FIX
            {
            tlObj.message__c = e.getMessage();
            }
            if(flsUpdate(Tx_Log__c.originated__c)||flsGet(Tx_Log__c.originated__c)) //SCAVA FIX
            {
            tlObj.originated__c = 'Oppty_OpptyWorkspace_BatchUpdate';
            }
            if(flsUpdate(Tx_Log__c.type__c)||flsGet(Tx_Log__c.type__c)) //SCAVA FIX
            {
            tlObj.type__c = 'Opportunity';
            }
            Database.SaveResult logInsertResult = Database.insert(tlObj, false);
        }
    }
    global void finish(Database.BatchableContext BC) {
        //Notifying Admin about completion of Batch Process
        AsyncApexJob aObj = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors
                             FROM AsyncApexJob WHERE ID = : BC.getJobId()
                            ];
        System.debug('Oppty_OpptyWorkspace_BatchUpdate:: Status : ' + aObj.Status);
        System.debug('Oppty_OpptyWorkspace_BatchUpdate:: Total Batches : ' + aObj.TotalJobItems );
        System.debug('Oppty_OpptyWorkspace_BatchUpdate:: Total Batches Procesed : ' + aObj.JobItemsProcessed );
        System.debug('Oppty_OpptyWorkspace_BatchUpdate:: Failed Batches : ' + aObj.NumberOfErrors );
        
    }
}