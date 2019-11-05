/*Name    : VFCntrl_PVT_TR_TSR_PEPE_Test
Author  : Sathish Selvaraj
Purpose :   
Created Date: Mar 26 2015

Modification History:
Version  Date            Modified By     Description
--------------------------------------------------------------------------------------
 
*/

@isTest(SeeAllData=true)
private class  VFCntrl_PVT_TR_TSR_PEPE_Test {

    public static PEPE_Training_Request__c testTRObj;
    public static PEPE_Training_Event__c testTEObj;
    public static RecordType testRTObj;
    public static RecordType testRTObjTR;
    public static RecordType testRTPPObjTR;
    public static list<PEPE_Training_Sessions_Requested__c> testLstTSR = new list<PEPE_Training_Sessions_Requested__c>();
        
    static testMethod void myUnitTest(){
        Test.startTest();                
 
        createData();
        PageReference  pr=new PageReference('/apex/PVT_TR_TSR_PEPE?RecordType='+testRTObjTR.Id+'&Id='+testTRObj.Id+'&index=2');
        Test.setCurrentPage(pr);
        VFCntrl_PVT_TR_TSR_PEPE controller = new  VFCntrl_PVT_TR_TSR_PEPE(new ApexPages.StandardController(testTRObj));
        controller.TR_Id = testTRObj.Id;
        controller.RecTypeIdFromURL = testRTObjTR.Id;
        controller.redirectToPage();
        controller.showTSRRecInViewPage();
        controller.cancel();
        controller.saveTR(testTRObj);
        controller.saveTSR(testLstTSR);
        controller.removingRow();
        controller.saveTRAndTSR();
        testTRObj.Status__c = null;
        testTRObj.Geography__c = null;
        testTRObj.Cisco_Location__c = null;
        testTRObj.Address_1__c = null;
        testTRObj.City__c = null;
        controller.TRObj = testTRObj;
        controller.saveTRAndTSR();
        controller.TR_Id = null;
        controller.RecTypeNameFromURL = 'PVT';
        controller.initialize();
        PageReference  pr1=new PageReference('/apex/PVT_TR_TSR_PEPE?CF00N80000004wuJh='+testTEObj.Name+'&RecordType='+testRTObjTR.Id+'&index=2&RecordTypeName=PVT');
        Test.setCurrentPage(pr1);
        controller.initialize();
        PageReference  pr2=new PageReference('/apex/PVT_TR_TSR_PEPE?CF00N80000004wuJh='+testTEObj.Name+'&RecordType='+testRTPPObjTR.Id+'&index=2&RecordTypeName=Partner Plus');
        Test.setCurrentPage(pr2);
        controller.redirectToPage();
       Test.stopTest(); 
    }
    
    public static void createData(){
        
        
        list<PEPE_Event_Day__c> lstEDToInsert = new list<PEPE_Event_Day__c>();
        
        
        testRTObj = [select Id, Name from RecordType where Name = 'PVT' and SobjectType = 'PEPE_Training_Event__c' limit 1];
        RecordType TECalPubRTDtls = [select Id, Name from RecordType where Name = 'Calendar Published RT' and SobjectType = 'PEPE_Training_Event__c' limit 1];
        
        testTEObj = new PEPE_Training_Event__c(Status__c = 'Created',Internal_or_Partners__c='Internal Only',CLP_flag__c='No',PTP_flag__c='No',Report_Sent_Y_N__c='Country Enablement', Platform__c = 'PVT', Publish_to_Calendar__c='Yes', Training_Event_Name__c = 'Test PVT Event'
                     ,Event_Time_Zone__c = '(GMT-12:00) Dateline', Primary_Focus__c = 'Operations', Program__c = 'Partner Updates', Language_Coverage__c = 'Arabic'
                     ,Send_Notification__c = 'No', Start_Date_Time__c = system.Today(), End_Date_Time__c = system.Today()+5, Location_Name__c = 'Test Location'
                     ,Address_1__c = 'Test Address', Zip_Postal_Code__c = '0000000', RecordTypeId =testRTObj.Id);
        insert testTEObj;
        system.debug('--->>>>>>>>>>>>     CREATE  DATA HERE TC   '+testTEObj);
        
        testTEObj.RecordTypeId = TECalPubRTDtls.Id;
        
        update testTEObj;
        testTEObj = [Select Id, Name,Internal_or_Partners__c,CLP_flag__c,PTP_flag__c,Report_Sent_Y_N__c, Status__c, Platform__c, Publish_to_Calendar__c, Training_Event_Name__c, Event_Time_Zone__c, Primary_Focus__c, 
        Program__c, Language_Coverage__c, Send_Notification__c, Start_Date_Time__c, End_Date_Time__c, Location_Name__c, Address_1__c, Zip_Postal_Code__c, RecordTypeId 
        from PEPE_Training_Event__c where Id=:testTEObj.Id];
        
        testRTObjTR = [select Id, Name from RecordType where Name = 'PVT' and SobjectType = 'PEPE_Training_Request__c' limit 1];
        
        testRTPPObjTR = [select Id, Name from RecordType where Name = 'Partner Plus' and SobjectType = 'PEPE_Training_Request__c' limit 1];
                     
        testTRObj = new PEPE_Training_Request__c(RecordTypeId = testRTObjTR.Id,Status__c = 'Added into cart',CI_CVENT_Session_Name__c='Test Cvent Session Name', Cisco_Location__c = 'Test Location', Address_1__c = 'Test Address', City__c = 'Test City', Training_Offering_Id__c = testTEObj.Id);
                     
        insert testTRObj;
       
        for(Integer i=0;i<2;i++) {
            PEPE_Event_Day__c ed = new PEPE_Event_Day__c(Name = 'Test Event Day'+i, Training_Event__c = testTEObj.Id);
            lstEDToInsert.add(ed);
        }
        insert lstEDToInsert;
        system.debug('--->>>>>>>>>>>>     CREATE  DATA HERE TTR List   '+lstEDToInsert);
        
        RecordType tsrPVTRTDtls = [select Id from RecordType where Name='PVT' and SobjectType ='PEPE_Training_Sessions_Requested__c'];
        if(lstEDToInsert != null && lstEDToInsert.size() > 0) {
          
            for(PEPE_Event_Day__c edObj: lstEDToInsert) {
                PEPE_Training_Sessions_Requested__c tsrObj = new PEPE_Training_Sessions_Requested__c();
                tsrObj.Event_Day__c = edObj.Id;
                tsrObj.Training_Request__c = testTRObj.Id;
                tsrObj.TP_Room_Name__c = 'Test TP Room';
                tsrObj.Room_Capacity__c = 100;
                tsrObj.Host_Name__c = 'Test Host Name';
                tsrObj.Host_Email__c = 'test@test.com';
                tsrObj.RecordTypeId = tsrPVTRTDtls.Id;
                testLstTSR.add(tsrObj);
            }
            if(testLstTSR != null && testLstTSR.size() > 0) {
                insert testLstTSR;
             system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ MAHESH @@@@@@@@@@@@@@@@@@lstEDToInsert###' + lstEDToInsert.size());  
            }
        }      
         
    
    }
}