/************************************************************************************************************************************
Name    : BatchOneTimeWorkspace
Author  : Bramha
Purpose : Contains logic for sharing the "Workspace and WorkSpace Technologies" to service one
*************************************************************************************************************************************/
global class BatchOneTimeWorkspace implements Database.Batchable<sObject>,Database.Stateful {

    global Database.QueryLocator start(Database.BatchableContext BC) {
        Date clsDate = Apex_Batch_Job__c.getInstance('closedate').Date_TimeStamp__c;
        string OpptyStatus=Utilities.getConstant_CS('OpptyStatus');
        string[] strOpptyStatus = new string[]{};
        strOpptyStatus = OpptyStatus.split(',');
        // Passing the Opportunities which are in "Active" status and closedDate after 30July'17
       if(Test.isRunningTest()){
            return Database.getQueryLocator([select Id, DealID__c, RecordTypeId, IsDeleted,AccountId,Name,CloseDate,Territory2Id,LastModifiedDate,Theater__c,Expected_Service__c,Expected_Product__c,Territory_Level_01__c,Territory_Level_02__c,Total_AS_S__c,Total_AS_T__c from Opportunity where Opportunity_Status__c IN :strOpptyStatus AND CLOSEDATE >=:clsDate limit 10]);
        }else{
            return Database.getQueryLocator([select Id, DealID__c, RecordTypeId, IsDeleted,AccountId,Name,CloseDate,Territory2Id,LastModifiedDate,Theater__c,Expected_Service__c,Expected_Product__c,Territory_Level_01__c,Territory_Level_02__c,Total_AS_S__c,Total_AS_T__c from Opportunity where Opportunity_Status__c IN :strOpptyStatus AND CLOSEDATE >=:clsDate]);
        }   
    }

    global void execute(Database.BatchableContext BC, List<opportunity> optyList) {
        set<String> optyidlist = new set<String>();
        for(opportunity bd:optyList){
          if(bd.DealID__c != null && bd.DealID__c != ''){ 
              optyidlist.add(bd.Id);
          }
        }
        //Fetching all of the Workspace records which are related to Opportunities
        List<AT_Workspace__c> optyLineItemList = [SELECT Account_Name__c,opportunity__c, Account_Opportunity_Workspace_Link__c,Account_Opportunity_Workspace__c,Account_Workspace_Link__c,Account_Workspace__c,Additional_Use_Case_Info__c,Adoption_Strategy__c,Application__c,AT_Comments__c,AT_Competitor__c,AT_Expected_Book_Date__c,AT_Expected_Product__c,AT_Expected_Service__c,AT_Flags__c,AT_Forecast_Status__c,AT_Next_Step_Date__c,AT_Next_Step__c,AT_No_of_days_Overdue__c,AT_Optional_1__c,AT_Optional_2__c,AT_Other_Competitor__c,AT_Other_Partner__c,AT_Partner__c,AT_Product__c,AT_Sub_Technology__c,AT_Team__c,AT_Technology__c,Business_Driver__c FROM AT_Workspace__c Where Opportunity__c IN: optyidlist];
        Map<Id, AT_Workspace__c> workSpaceMap = new Map<Id, AT_Workspace__c>();
        Set<Id> opset = new Set<Id>();        
        for(AT_Workspace__c lneItemList: optyLineItemList){
            workSpaceMap.put(lneItemList.id,lneItemList);
             opset.add(lneItemList.opportunity__c);  
        }
        
        List<PartnerNetworkRecordConnection> insertnetConnRecList =null;
        //Fetching OpportunityConnection records which are shared with serviceOne
        List<PartnerNetworkRecordConnection> netConnRecList = [select Id, LocalRecordId, Status from PartnerNetworkRecordConnection where LocalRecordId =: opset];
        Map<Id,String> insertnetConnRecMap2 = new Map<Id,String>();
        for(PartnerNetworkRecordConnection rec: netConnRecList){
            insertnetConnRecMap2.put(rec.LocalRecordId, rec.Status);
        } 
        //Getting the connection
        PartnerNetworkConnection networkConn =[select Id from PartnerNetworkConnection where ConnectionName = 'Services One' and ConnectionStatus = 'Accepted'];
        if(networkConn != null) {             
            if(workSpaceMap.size() > 0) {
                insertnetConnRecList = new List<PartnerNetworkRecordConnection>(); 
                for(AT_Workspace__c oplnitm:workSpaceMap.values()){
                   //Validating whether parent(Opportunity) shared or not with the Connection
                    if(insertnetConnRecMap2.get(oplnitm.Opportunity__c) == 'Sent'){
                        PartnerNetworkRecordConnection parentRec1 = new PartnerNetworkRecordConnection();
                        parentRec1.ConnectionId = networkConn.Id;
                        parentRec1.LocalRecordId = oplnitm.Id;
                        parentRec1.ParentRecordId = oplnitm.Opportunity__c;
                       if(flsCreateGet(PartnerNetworkRecordConnection.RelatedRecords ) || flsUpdateGet(PartnerNetworkRecordConnection.RelatedRecords ))          //SCAVA FIX 
                      {
                          parentRec1.RelatedRecords ='Workspace_Technology__c';
                      }
                        system.debug('connectionid ' + networkConn.Id + 'LocalRecordId ' +oplnitm.Id +'Optyid ' + oplnitm.Opportunity__c);
                        insertnetConnRecList.add(parentRec1);
                    }
                }
                //Sharing Workspaces with the Connection ServiceOne   
                if(!insertnetConnRecList.isEmpty()) {
                    createRecordsAndLog(insertnetConnRecList);
                } 

                //Fetching Workspace connections which are shared with the ServiceOne
                List<PartnerNetworkRecordConnection> OWnetConnRecList = [Select Id, LocalRecordId, Status From PartnerNetworkRecordConnection Where LocalRecordId IN:workSpaceMap.keySet()];
                Map<Id,String> OWnetConnRecMap = new Map<Id,String>();
                for(PartnerNetworkRecordConnection rec2: OWnetConnRecList){
                    OWnetConnRecMap.put(rec2.LocalRecordId, rec2.Status);
                }
                List<Workspace_Technology__c> workSpaceTechList = [select id, Workspace__c from Workspace_Technology__c where Workspace__c IN:workSpaceMap.keySet()];
                List<PartnerNetworkRecordConnection> insertWTnetConnRecList =new List<PartnerNetworkRecordConnection>(); 
                if(workSpaceTechList.size() >0) {
                    for(Workspace_Technology__c workSpaceTech: workSpaceTechList) {
                       //Validating whether parent(Workspace) shared or not with the Connection 
                        if(OWnetConnRecMap.get(workSpaceTech.Workspace__c)!=null && OWnetConnRecMap.get(workSpaceTech.Workspace__c)=='Sent'){        insertWTnetConnRecList.add(addRecordstoList(networkConn.Id,workSpaceTech.Id,workSpaceTech.Workspace__c));
                        }    
                    }
                }
                //Sharing Workspace_Techonology__c records which are related to "Opportunity Workspace".
                if(!insertWTnetConnRecList.isEmpty()) {
                    createRecordsAndLog(insertWTnetConnRecList);
                }
            }  
        }  
    }   

    global void finish(Database.BatchableContext BC) {      
    }
    
    public void createRecordsAndLog(List<PartnerNetworkRecordConnection> netConnRecList) {
        if(netConnRecList != null && netConnRecList.size() > 0) {
            Database.UpsertResult[] results;
            try{
            results = Database.upsert(netConnRecList);
            }catch(Exception e){
                system.debug('An Exception occured'+e); 
            }                  
        }
    }
    public PartnerNetworkRecordConnection addRecordstoList(string connectionId, string workTechId, string workspaceId){
        PartnerNetworkRecordConnection networkConnRecord =new PartnerNetworkRecordConnection();
        //validating Create & Update conditions for ConnectionId from PartnerNetworkRecordConnection
         if(flsCreateGet(PartnerNetworkRecordConnection.ConnectionId) || flsUpdateGet(PartnerNetworkRecordConnection.ConnectionId))          //SCAVA FIX 
        {
          networkConnRecord.ConnectionId = connectionId;
        }
        //validating Create & Update conditions for LocalRecordId from PartnerNetworkRecordConnection
        if(flsCreateGet(PartnerNetworkRecordConnection.LocalRecordId)|| flsUpdateGet(PartnerNetworkRecordConnection.LocalRecordId))           //SCAVA FIX 
        {
           networkConnRecord.LocalRecordId = workTechId;
        }
        //validating Create & Update conditions for ParentRecordId  from PartnerNetworkRecordConnection
        if(flsCreateGet(PartnerNetworkRecordConnection.ParentRecordId )|| flsUpdateGet(PartnerNetworkRecordConnection.ParentRecordId ))           //SCAVA FIX 
        {
           networkConnRecord.ParentRecordId = workspaceId;
        }
        return networkConnRecord;
    }  
    
    
     // SCAVA Helper Method to validate Create Access at field level
     public static Boolean flsCreateGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }
    
     
       // SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdateGet(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    } 
}