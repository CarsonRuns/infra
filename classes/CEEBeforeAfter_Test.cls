/***************************************************************************************************
Name    : CEEBeforeAfter_Test 
Author  : Eric Pesch
Purpose : Trigger Tests for the CEE__c object  
Created Date: Dec 1 2014
Modification History: 
Eric Pesch - Jan 5 2015: Added Comments, cleanup
Jay Dash - Aug 8 2015 : code cleanup and added getOpty()                     
*****************************************************************************************************/

@isTest
private class CEEBeforeAfter_Test {

    /*@method: Insert Update Briefing test*/
    private static testMethod void ceeInsertUpdate() {
        //Setup Account
        User admin = CEE_TestUtility.getUser('admin', true);
        Account acct = null;
        Opportunity oppty = null;
        Account_Executive_Sponsor__c exec = CEE_TestUtility.getAccountExecutiveSponsor('cee', true);
        
        System.runAs(admin){
            CEE_TestUtility.loadCustomSettings();
            acct = CEE_TestUtility.getAccount('cee', true);
        }
        
        //Setup location
        CEE_Location__c loc = CEE_TestUtility.getLocation('cee', true, 'EBC/EC');
        CEE_Room__c room = CEE_TestUtility.getRoom('cee', true, loc, false, 6);
        CEE_Location__c loc1 = [select Id from CEE_Location__c where id =: loc.id];
        CEE_Location_Holiday__c ceeHol = new CEE_Location_Holiday__c();     
        ceeHol.CEE_Location__c = loc1.Id;
        ceeHol.Holiday_Date__c = system.today();
        ceeHol.Year__c = '2016';
        insert ceeHol;
        CEE_Location_Holiday__c ceeHol1 = new CEE_Location_Holiday__c();        
        ceeHol1.CEE_Location__c = loc1.Id;
        ceeHol1.Holiday_Date__c = system.today() + 1;
        ceeHol1.Year__c = '2016';
        insert ceeHol1;
        CEE_Location_Holiday__c ceeHol2 = new CEE_Location_Holiday__c();        
        ceeHol2.CEE_Location__c = loc1.Id;
        ceeHol2.Holiday_Date__c = system.today() + 2;
        ceeHol2.Year__c = '2016';
        insert ceeHol2;
        
        Test.startTest();
        
        //Setup briefing
        Opportunity opppt =  CEE_TestUtility.getOpty();
        CEE__c briefing = CEE_TestUtility.getBriefing('cee', true, 'OBX', acct, opppt, loc);
        
        //Setup ITCE briefing
        CEE__c itceBriefing = CEE_TestUtility.getBriefing('cee2', false, 'Upcoming IT Customer Engagement Briefing', acct, opppt, loc);
        itceBriefing.Primary_FSO__c = null;
        itceBriefing.Timezone__c = 'UTC-05:00';
        insert itceBriefing;        
        
        //Exception - fail updating first briefing to final step
        briefing.Final_Approval_Flag__c = true;
        briefing.Legal__c = 'Yes'; 
        briefing.Request_Status__c = 'Cancelled (all resources released)';
        briefing.Primary_FSO__c = loc.id;       
        
        
        try{
            update briefing;
        } catch(Exception e){
            System.debug('CEEBeforeAfter_Test - succesful exception - ' + e.getStackTraceString());
        }
        
        Test.stopTest();
        
    }
     /*@method: Insert Update Briefing test*/
    private static testMethod void ceeInsertUpdate1() {
        //Setup Account
        User admin = CEE_TestUtility.getUser('admin', true);
        Account acct = null;
        Opportunity oppty = null;
        Account_Executive_Sponsor__c exec = CEE_TestUtility.getAccountExecutiveSponsor('cee', true);
        
        System.runAs(admin){
            CEE_TestUtility.loadCustomSettings();
            acct = CEE_TestUtility.getAccount('cee', true);
        }
        
        //Setup location
        CEE_Location__c loc = CEE_TestUtility.getLocation('cee', true, 'EBC/EC');
        CEE_Room__c room = CEE_TestUtility.getRoom('cee', true, loc, false, 6);
        CEE_Location__c loc1 = [select Id from CEE_Location__c where id =: loc.id];
        CEE_Location_Holiday__c ceeHol = new CEE_Location_Holiday__c();     
        ceeHol.CEE_Location__c = loc1.Id;
        ceeHol.Holiday_Date__c = system.today();
        ceeHol.Year__c = '2016';
        insert ceeHol;
        CEE_Location_Holiday__c ceeHol1 = new CEE_Location_Holiday__c();        
        ceeHol1.CEE_Location__c = loc1.Id;
        ceeHol1.Holiday_Date__c = system.today() + 1;
        ceeHol1.Year__c = '2016';
        insert ceeHol1;
        CEE_Location_Holiday__c ceeHol2 = new CEE_Location_Holiday__c();        
        ceeHol2.CEE_Location__c = loc1.Id;
        ceeHol2.Holiday_Date__c = system.today() + 2;
        ceeHol2.Year__c = '2016';
        insert ceeHol2;
        
        Test.startTest();
        
        //Setup briefing
        Opportunity opppt =  CEE_TestUtility.getOpty();
        CEE__c briefing = CEE_TestUtility.getBriefing('cee', true, 'OBX', acct, opppt, loc);
        
        
        
        //Exception - fail updating first briefing to final step
        briefing.Final_Approval_Flag__c = true;
        briefing.Post_Engagement_Message_Sent__c =true;
        briefing.emailHasNotBeenSent__c = true;
        briefing.Legal__c = 'Yes'; 
        briefing.Request_Status__c = 'Confirmed';
        briefing.Primary_FSO__c = loc.id;       
        
        
        try{
            update briefing;
        } catch(Exception e){
            System.debug('CEEBeforeAfter_Test - succesful exception - ' + e.getStackTraceString());
        }
        
        Test.stopTest();
        
    }
    /*@method: Insert Update Briefing test*/
    private static testMethod void ceeInsertUpdate2() {
        User admin = CEE_TestUtility.getUser('admin', true);
        Account acct = null;
        Opportunity oppty = null;
        
        System.runAs(admin){
            CEE_TestUtility.loadCustomSettings();
            acct = CEE_TestUtility.getAccount('brief', true);
        }
        
        //Setup location
        CEE_Location__c loc = CEE_TestUtility.getLocation('brief', true, 'EBC/EC');
        loc.Location_Type__c = 'EBC/EC';
        loc.Scheduler_Mailer_Alias__c = 'test@cisco1.com';
        loc.Additional_Secondary_Scheduler__c = admin.id;
        loc.Additional_Secondary_Scheduler2__c = admin.id;
        loc.Additional_Secondary_Scheduler_3__c = admin.id;
        update loc ;
        
        
        CEE_Room__c room = CEE_TestUtility.getRoom('brief', true, loc, false, 6);
        
         
        //Setup briefing
        Opportunity opppt =  CEE_TestUtility.getOpty();
        CEE__c briefing = CEE_TestUtility.getBriefing('brief', true, 'OBX', acct, opppt, loc);
        
        Schema.DescribeSObjectResult cfrSchema1 = Schema.SObjectType.CEE__c; 
        Map<String,Schema.RecordTypeInfo> CEERecordTypeInfo1 = cfrSchema1.getRecordTypeInfosByName();
        id rid1 = CEERecordTypeInfo1.get('Customer Proof Of Concept(CPOC)').getRecordTypeId();
        
        CEE__c briefing2 = new CEE__c();
        briefing2.recordtypeid = rid1; 
        briefing2.Primary_Account__c =  acct.id;
        briefing2.Opportunity__c =   opppt.id;
        briefing2.CPOC_Location__c = loc.id;
        briefing2.CPOC_Lab_Mailer__c = 'test@cisco1.com' ;
       // briefing2.Additional_Secondary_Scheduler__c = loc.id ;
       // briefing2.Additional_Secondary_Scheduler2__c = 'test@cisco3.com';
       // briefing2.Additional_Secondary_Scheduler_3__c = 'test@cisco4.com';
        briefing2.Preferred_Lab__c = 'San Jose Customer Experience Center';
       // briefing2.Primary_FSO__c =  loc.id;
        insert briefing2;
        
        CEE_Location_Holiday__c holiday = new CEE_Location_Holiday__c();
        holiday.Holiday_Date__c = system.today()+1;
        holiday.Year__c= '2018';
        holiday.CEE_Location__c = loc.id;
        insert holiday ;
       
        Topic__c topic = CEE_TestUtility.getTopic('brief', true, false);
        Agenda_Room__c agendaRoom = CEE_TestUtility.getAgendaRoom('brief', true, briefing, room);
        
        SObject so;
        SObject oldSo;
        CeeHandler ceeHandlerCls = new CeeHandler();
        CPOC_TriggerImpl ceetriggerimpl = new CPOC_TriggerImpl();
        CEEHandlercls.beforeDelete(so);
        CEEHandlercls.afterDelete(so);
         Test.startTest();
        //Setup agenda item
        Agenda_Item__c agenda = CEE_TestUtility.getAgendaItem('brief', true, briefing, loc, agendaRoom, topic);
        
        //Setup Presenter
        CEE_Attendee__c presenter = CEE_TestUtility.getAttendee('brief', false, briefing, agenda, true);
        CEE_Attendee__c ceeAtt = new CEE_Attendee__c(); 
        user us = [select id,name, email from user where id =:userinfo.getuserid()];
        ceeAtt.Name = us.Name;
        ceeAtt.Salesforce_User__c = userinfo.getuserid();
        ceeAtt.Type__c = 'Presenter';
        ceeAtt.Email__c = us.Email; 
        ceeAtt.Customer_Engagement_Events__c = briefing.id;
        insert ceeAtt;
        try{
            briefing.Final_Approval_Flag__c = true;
            briefing.Post_Engagement_Message_Sent__c =true;
            briefing.emailHasNotBeenSent__c = true;
            briefing.Legal__c = 'Yes'; 
            briefing.Request_Status__c = 'Confirmed';
            briefing.Primary_FSO__c = loc.id;
            
            update briefing;
        }       
        catch(Exception e){
            System.debug('CEEBeforeAfter_Test - succesful exception - ' + e.getStackTraceString());
        }
        Test.stopTest();
        
    }
    private static testmethod void ceeInsertUpdate3()
    {
       
         SObject so;
        SObject oldSo; 
         Account acct = null;   
         opportunity oppty = null;
         String cecid;
         
         User admin = CEE_TestUtility.getUser('admin', true);
           System.runAs(admin){
            CEE_TestUtility.loadCustomSettings();
            acct = CEE_TestUtility.getAccount('cee', true);
        }
       
         Opportunity opppt =  CEE_TestUtility.getOpty();
         
        User newUser = new User();     
        newUser.Email = cecid + '@cisco.com.test';
        newUser.EmailEncodingKey = 'UTF-8';
        newUser.LastName = 'Test';
        newUser.FirstName = 'cecid';
        newUser.Alias = 'Tcec';
        newUser.Organization__c = 'Test';
        newUser.LanguageLocaleKey = 'en_US';
        newuser.isactive = false;
        newUser.LocaleSidKey = 'en_US';
        newUser.ProfileId = UserInfo.getProfileId();
        newUser.CommunityNickname = cecid;
        newUser.TimeZoneSidKey = 'America/Los_Angeles';
        newUser.UserName = cecid + '@cisco.com.test';
        newUser.Theatre__c = 'Americas-Canada';
        newUser.Additional_User_Permissions__c = 'Enable EndUser ACCTCreation';
        insert newUser;
      
        CEE_Location__c location = new CEE_Location__c();     
        location.Name = 'Songdo Innovation Center';    
        location.Address_Line_1__c = 'addr line 1';
        location.Address_Line_2__c = 'addr line 2';
        location.City__c = 'loc city';
        location.Country__c = 'loc country';
        location.Department_Code__c = 'ebc_code';
        location.ITCE_Scheduler__c = 'itce@email.com';
        location.Languages__c = 'English';
        location.Location_Type__c = 'EBC/EC';
        location.Postal_Code__c = '11111-2222';
        location.Site_Close_Time__c = '17:00';
        location.Additional_Secondary_Scheduler__c=newUser.id;
        location.Secondary_Scheduler__c = newUser.id;
        location.Site_Open_Time__c = '8:00';
        location.Site_Time_Zone__c = 'America/Los_Angeles';
        location.State_Province__c = 'loc state';
        location.Primary_Scheduler_Email__c = newuser.email;
        location.Primary_Scheduler__c = newUser.id;
        location.Is_Location_Active__c = 'Yes';
        insert location;
        
        CEE__c briefing = new CEE__c();
        briefing.recordtypeid = Schema.SObjectType.CEE__c.getRecordTypeInfosByName().get('IT Customer Engagement Briefing').getRecordTypeId(); 
        briefing.Primary_Account__c =  acct.id;
        briefing.Opportunity__c =   opppt.id;
        briefing.Primary_FSO__c= location.id;
        briefing.Program_Manager__c = newuser.id;
        briefing.Backup_PM__c = newuser.id;
        briefing.Event_Type__c = 'Good Will Visit';
        briefing.Primary_Scheduler__c = newuser.id;
        briefing.EBC_CBC_Location__c = 'Songdo Innovation Center';
        briefing.Meeting_Delivery_Type__c = 'TelePresence';
        briefing.Preferred_Lab__c = 'San Jose Customer Experience Center';
        insert briefing; 
        
        
        Test.startTest();
         CeeHandler ceeHandlerCls = new CeeHandler();
        CPOC_TriggerImpl ceetriggerimpl = new CPOC_TriggerImpl();
        CEEHandlercls.beforeDelete(so);
        CEEHandlercls.afterDelete(so);
        Test.stopTest();
        }
    
    
    
    
}