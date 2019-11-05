/***************************************************************************************************
Name    : CEE_TestUtility 
Author  : Eric Pesch
Purpose : Test data factory for CEE  
Created Date: Dec 1 2014
Modification History: 
Eric Pesch - Jan 5 2015: Added Comments, cleanup                     
*****************************************************************************************************/

public with sharing class CEE_TestUtility {

// SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdateGet(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }

    
    /*@method: get Account record type*/
    public static RecordType getAccountRecordType(){
        RecordType channelAcct =  new RecordType();
        channelAcct.id = ObjectRecordTypeIds__c.getOrgDefaults().AccountChannelRecordTypeId__c;
        channelAcct.name = 'Channel';
        
        return channelAcct;
    }
    
    /*@method: get Account*/
    public static Account getAccount(String prefix, Boolean isInsert){
        Account acct = new Account();
        acct.name = prefix+'Test Partner Account';
        acct.RecordTypeId = CEE_TestUtility.getAccountRecordType().Id;
        acct.Country__c = 'UNITED STATES';
        
        if(isInsert){
            insert acct;
            
            //Setup super group
            Super_Group__c superGroup = new Super_Group__c();
            superGroup.FDEV_Super_Group_ID__c = '42';
            superGroup.Type__c = 'Overlay';
            insert superGroup;
            
            Overlay_Acct_SuperGroup_Rel__c acctSuper = new Overlay_Acct_SuperGroup_Rel__c();
            acctSuper.Account_ID__c = acct.Id;
            acctSuper.Super_Group__c = superGroup.Id;
            insert acctSuper;
        }
        
        return acct;
    }
    
    /*@method: get User*/
    public static User getUser(String cecid, Boolean isInsert){
        //Profile pList = [SELECT Id FROM Profile WHERE Name ='Cisco_ADMIN' limit 1];
        Id ciscoAdminProfile = '00e30000000dcbgAAA';
        
        User newUser = new User();
        newUser.Alias = cecid;
        newUser.Email = cecid + '@cisco.com.test';
        newUser.EmailEncodingKey = 'UTF-8';
        newUser.LastName = 'Test';
        newUser.FirstName = 'cecid';
        newUser.Organization__c = 'Test';
        newUser.LanguageLocaleKey = 'en_US';
        newUser.LocaleSidKey = 'en_US';
        newUser.ProfileId = ciscoAdminProfile;
        newUser.CommunityNickname = cecid;
        newUser.TimeZoneSidKey = 'America/Los_Angeles';
        newUser.UserName = cecid + '@cisco.com.test';
        newUser.Theatre__c = 'Americas-Canada';
        newUser.Additional_User_Permissions__c = 'Enable EndUser ACCTCreation';
        
        User myUser = new User();
        myUser.Id = UserInfo.getUserId(); //[ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs (myUser) {
            if(isInsert){
                insert newUser;
            }
        }
        
        return newUser;
    }
    
    /*@method: get Account Executive Sponsor*/
    public static Account_Executive_Sponsor__c getAccountExecutiveSponsor(String prefix, Boolean isInsert){
        Account_Executive_Sponsor__c sponsor = new Account_Executive_Sponsor__c();
        sponsor.Name = prefix + ' Account Sponsor';
        sponsor.Account_Leads__c = 'Account Lead Test Man';
        sponsor.Account_Leads_CEC__c = 'accttest';
        sponsor.Account_Name_External_ID__c = '42';
        sponsor.Active__c = true;
        sponsor.Country__c = 'US';
        sponsor.Geographic_Region__c = 'AMER';
        sponsor.ID__c = '42';
        sponsor.Lead_Sponsors__c = 'Lead Sponsor Test Man';
        sponsor.Lead_Sponsors_CEC__c = 'leadtest';
        sponsor.Status__c = 'Active';
        sponsor.Sub_Vertical__c = 'Sub Vertical';
        sponsor.Super_Group__c = '402';
        sponsor.Supporting_Sponsors__c = 'Support Test Man';
        sponsor.Supporting_Sponsors_CEC__c = 'supptest';
        sponsor.Vertical__c = 'Vertical';
        sponsor.VP__c = 'VP Test Man';
        sponsor.VP_CEC__c = 'vptest';
        
        //Setup Users
        User accountLead = getUser(sponsor.Account_Leads_CEC__c, true);
        User leadSponsor = getUser(sponsor.Lead_Sponsors_CEC__c, true);
        User supportSponsor = getUser(sponsor.Supporting_Sponsors_CEC__c, true);
        User vp = getUser(sponsor.VP_CEC__c, true);
        
        System.runAs(accountLead){
            if(isInsert){
                insert sponsor;
                
                sponsor = [select Id, Name, Account_Leads_CEC__c, Account_Leads__c, Account_Name_External_ID__c, Active__c, 
                            Country__c, Geographic_Region__c, ID__c, Lead_Sponsors_CEC__c, Lead_Sponsors__c, Status__c, Sub_Vertical__c, 
                            Super_Group__c, Supporting_Sponsors_CEC__c, Supporting_Sponsors__c, VP_CEC__c, VP__c, Vertical__c
                            from Account_Executive_Sponsor__c where Id =: sponsor.Id];
            }
        }
        return sponsor;
    }
    
    /*@method: get Agenda Item*/
    public static Agenda_Item__c getAgendaItem(String prefix, Boolean isInsert, CEE__c briefing, CEE_Location__c loc, Agenda_Room__c room, Topic__c topic){
        Agenda_Item__c item = new Agenda_Item__c();
        
        if(topic != null){
            item.Name = topic.Name;
            item.Topic_Name__c = topic.Name;
            item.Topic__c = topic.Id;
        } else {
            item.Name = prefix + ' Name';
        }
        
        item.Catering_Attendees__c = 4;
        item.Catering_Cost_Per_Person__c = 10;
        item.Catering_Funding__c = 'EBC Funded';
        item.Catering_Type__c = 'Lunch - Hot Food and Drinks';
        item.Customer_Engagements_Events__c = briefing.Id;
        item.Delivery_Method__c = 'In-Person';
        item.Sales_Objectives__c = 'item objective';
        
        if(room != null){
            item.Selected_Rooms_Display__c = room.Room_Name__c;
            item.Selected_Rooms__c = room.Id;
        }
        
        if(loc != null){
            item.Catering_Department_Code__c = loc.Department_Code__c;
            item.Selected_Sites__c = loc.Id;
            item.Selected_Sites_Display__c = loc.Name;
        }
        item.Start_Date_Time__c = briefing.Start_Date_Time__c;
        item.End_Date_Time__c = briefing.End_Date_Time__c;
        
        User myUser = new User();
        myUser.Id = UserInfo.getUserId();
        System.runAs (myUser) {
            if(isInsert){
                insert item;
                
                item = [select Id, Name, Account_Name__c, Briefing_Status__c, Briefing_Type__c, Catering_Attendees__c, 
                        Catering_Cost_Per_Person__c, Catering_Department_Code__c, Catering_Funding__c, Catering_Total_Cost__c, 
                        Catering_Type__c, Customer_Engagements_Events__c, Customer_Engagements_Events__r.Name, Delivery_Method__c, Duration__c, End_Date_Time__c, 
                        Sales_Objectives__c, Selected_Rooms_Display__c, Selected_Rooms__c, Selected_Sites_Display__c, Selected_Sites__c, 
                        Start_Date_Time__c, TEMP_AGENDA_ITEM_ID__c, Temp_CEE__c, Topic_Name__c, Topic__c, Topic__r.Name 
                        from Agenda_Item__c where Id =: item.Id ];
            }
        }
        return item;
    }
    
    /*@method: get Agenda Room*/
    public static Agenda_Room__c getAgendaRoom(String prefix, Boolean isInsert, CEE__c cee, CEE_Room__c ceeRoom){
        Agenda_Room__c room = new Agenda_Room__c();
        room.Customer_Engagements_Events__c = cee.Id;
        room.End_Date_Time__c = cee.End_Date_Time__c; 
        room.Room__c = ceeRoom.Id;
        room.Start_Date_Time__c = cee.Start_Date_Time__c;
        
        User myUser = new User();
        myUser.Id = UserInfo.getUserId();
        System.runAs (myUser) {
            if(isInsert){
                insert room;
                
                room = [select Id, Name, Account_Name__c, Briefing_Status__c, Briefing_Type__c, Customer_Engagements_Events__c, 
                        End_Date_Time__c, Room_Name__c, Room__c, Start_Date_Time__c from Agenda_Room__c where Id =: room.Id ];
            }
        }
        
        return room;
    }
    
    /*@method: get Briefing PM*/
    public static Briefing_PM__c getBriefingPM(String prefix, Boolean isInsert, CEE_Location__c loc){
        Briefing_PM__c briefPM = new Briefing_PM__c();
        briefPM.Site_Name__c = loc.Name;
        
        User primaryPM = getUser(prefix+'A', true);
        User secondaryPM = getUser(prefix+'B', true);
        User primaryScheduler = getUser(prefix+'C', true);
        
        briefPM.Primary_PM_Email__c = primaryPM.Email;
        briefPM.Secondary_PM_Email__c = secondaryPM.Email;
        briefPM.Primary_Scheduler_Email__c = primaryScheduler.Email;
        
        System.runAs(primaryPM){
            if(isInsert){
                insert briefPM;
                
                briefPM = [select Id, Name, Primary_PM_Email__c, Secondary_PM_Email__c, Primary_Scheduler_Email__c, 
                            Primary_PM__c, Secondary_PM__c, Primary_Scheduler__c, Site_Name__c 
                            from Briefing_PM__c where Id =: briefPM.Id ];
            }
        }
        
        return briefPM;
    }
    
    /*@method: get Briefing Site*/
    public static Briefing_Site__c getBriefingSite(String prefix, Boolean isInsert, CEE__c briefing, CEE_Location__c location){
        Briefing_Site__c site = new Briefing_Site__c();
        site.Additional_Participant_Location__c = location.Id;
        site.Customer_Engagements_Events__c = briefing.Id;
        
        User myUser = new User();
        myUser.Id = UserInfo.getUserId();
        System.runAs (myUser) {
            if(isInsert){
                insert site;
            }
        }
        
        return site;
    }
    
    /*@method: get CEE Attendee*/
    public static CEE_Attendee__c getAttendee(String prefix, Boolean isInsert, CEE__c briefing, Agenda_Item__c agenda, Boolean isPresenter){
        CEE_Attendee__c attendee = new CEE_Attendee__c();
        if(agenda != null){
            attendee.Agenda_Item__c = agenda.Id;
        }
        attendee.Customer_Engagement_Events__c = briefing.Id;
        if(isPresenter){
            User presenter = getUser(prefix + 'PR', true);
            attendee.Name = presenter.Name;
            attendee.Salesforce_User__c = presenter.Id;
            attendee.Type__c = 'Presenter';
            attendee.Email__c = presenter.Email;
            
            System.runAs(presenter){
                if(isInsert){
                    insert attendee;
                    
                    attendee = [select Id, Name, Agenda_Item__c, Salesforce_User__c, Salesforce_User__r.TimeZoneSidKey, Salesforce_User__r.Email, 
                            Type__c, Title__c, Email__c, Customer_Engagement_Events__c from CEE_Attendee__c where Id =: attendee.Id ];
                }
            }
        } else {
            attendee.Name = prefix + ' Name';
            attendee.Email__c = prefix + 'PR@cisco.com.test';
            attendee.Title__c = 'title';
            attendee.Type__c = 'Customer';
            
            if(isInsert){
                insert attendee;
                
                attendee = [select Id, Name, Agenda_Item__c, Salesforce_User__c, Salesforce_User__r.TimeZoneSidKey, Salesforce_User__r.Email, 
                            Type__c, Title__c, Email__c, Customer_Engagement_Events__c from CEE_Attendee__c where Id =: attendee.Id ];
            }
        }
        
        return attendee;
    }
    
    /*@method: get CEE Invitation*/
    public static CEE_Invite__c getInvite(String prefix, Boolean isInsert, CEE__c briefing, CEE_Attendee__c attendee, Agenda_Item__c agenda, Agenda_Room__c room){
        CEE_Invite__c invite = new CEE_Invite__c();
        if(room != null){
            invite.Start_Date_Time__c = briefing.Start_Date_Time__c;
            invite.End_Date_Time__c = briefing.End_Date_Time__c;
            invite.Room__c = room.Id;
            invite.Location__c = room.Name;
        } else {
            invite.Start_Date_Time__c = agenda.Start_Date_Time__c;
            invite.End_Date_Time__c = agenda.End_Date_Time__c;
            invite.CEE_Attendee__c = attendee.Id;
            invite.Agenda_Item__c = agenda.Id;
        }
        
        invite.Outlook_Invite_ID__c = 'null';
        invite.Outlook_Status__c = 'Not Invited';
        invite.Update_Selected__c = true;
        
        User myUser = new User();
        myUser.Id = UserInfo.getUserId();
        System.runAs (myUser) {
            if(isInsert){
                insert invite;
            }
        }
        
        return invite;
    }
    
    /*@method: get CEE Location
    Location Types: EBC/EC, Non EBC/EC, ITCE, ITCE Cisco, ITCE Non Cisco, Tradeshow*/
    public static CEE_Location__c getLocation(String prefix, Boolean isInsert, String locType){
        CEE_Location__c location = new CEE_Location__c();
        
        if(locType == 'EBC/EC'){
            location.Name = System.Label.CEE_SanJoseExperienceCenter;
        } else {
            location.Name = prefix + ' loc name';
        }
        
        location.Address_Line_1__c = 'addr line 1';
        location.Address_Line_2__c = 'addr line 2';
        location.City__c = 'loc city';
        location.Country__c = 'loc country';
        location.Department_Code__c = 'ebc_code';
        location.ITCE_Scheduler__c = 'itce@email.com';
        location.Languages__c = 'English';
        location.Location_Type__c = locType;
        location.Postal_Code__c = '11111-2222';
        location.Site_Close_Time__c = '17:00';
        location.Site_Open_Time__c = '8:00';
        location.Site_Time_Zone__c = 'America/Los_Angeles';
        location.State_Province__c = 'loc state';
        //Add setting of this parameter since a lookup filter was added to the custom field Briefing_Site__c.Additional_Participant_Location__c
        location.Is_Location_Active__c = 'Yes';
        
        //Setup Schedulers
        User primaryScheduler = getUser(prefix+'1', true);
        User secondScheduler = getUser(prefix+'2', true);
        
        location.Primary_Scheduler_Email__c = primaryScheduler.Email;
        location.Secondary_Scheduler_Email__c = secondScheduler.Email;
         
        System.runAs(primaryScheduler){
            if(isInsert){
                insert location;
                
                location = [select Id, Name, Address_Line_1__c, Address_Line_2__c, City__c, Country__c, Department_Code__c,
                            ITCE_Scheduler__c, Languages__c, Location_Type__c, Postal_code__c, Site_Close_Time__c, Site_Open_Time__c,
                            Site_Time_Zone__c, State_Province__c, Primary_Scheduler__c, Secondary_Scheduler__c, Primary_Scheduler_Email__c,
                            Secondary_Scheduler_Email__c from CEE_Location__c where Id =: location.Id];
            }
        }
        return location;
    }
    
    /*@method: get CEE Room*/
    public static CEE_Room__c getRoom(String prefix, Boolean isInsert, CEE_Location__c location, Boolean isTelepresence, Integer size){
        CEE_Room__c room = new CEE_Room__c();
        room.Name = prefix + ' name full';
        room.Active__c = true;
        room.Address_Line_1__c = 'room addr line 1';
        room.Address_Line_2__c = 'room addr line 2';
        room.Building__c = 'room bldg';
        room.CEE_Location__c = location.Id;
        room.City__c = 'room city';
        room.Country__c = 'room coutnry';
        room.Customer_Facing__c = true;
        room.Display_Name__c = prefix + ' name display';
        room.EBC_CBC_Location__c = location.Name;
        room.Email_Code__c = prefix + '@cisco.com.test';
        room.Exchange_Email_Nickname__c = room.Name;
        room.Is_Telepresence__c = isTelepresence;
        room.Postal_Code__c = '11111-2222';
        room.Priority__c = 1;
        room.Proxy_Status__c = 'Proxy';
        room.Room_Details__c = 'room details';
        room.Size__c = size;
        room.State_Province__c = 'room state';
        room.Telepresence__c = 'room telepresence unit';
        
        User myUser = new User();
        myUser.Id = UserInfo.getUserId();
        System.runAs (myUser) {
            if(isInsert){
                insert room;
            }
        }
        
        return room;
    }
    
    /*@method: get Topic*/
    public static Topic__c getTopic(String prefix, Boolean isInsert, Boolean isDemo){
        Topic__c topic = new Topic__c();
        topic.Name = prefix + ' topic';
        topic.Architecture__c = 'Collaboration';
        topic.Sub_Architecture__c = 'Collaboration Overview';
        topic.IsActive__c = true;
        if(isDemo){
            topic.Organizing_Principle__c = 'Demo';         
        } else {
            topic.Organizing_Principle__c = 'Architecture';
        }
        
        User myUser = new User();
        myUser.Id = UserInfo.getUserId();
        System.runAs (myUser) {
            if(isInsert){
                insert topic;
            }
        }
        return topic;
    }
    
    /*@method: get "Other" Topic*/
    public static void getOtherTopic(){
        Topic__c topic = new Topic__c();
        topic.Name = 'Other';
        topic.Architecture__c = 'Other';
        topic.Sub_Architecture__c = 'Other';
        topic.IsActive__c = true;
        topic.Organizing_Principle__c = 'Architecture';
        
        User myUser = new User();
        myUser.Id = UserInfo.getUserId();
        System.runAs (myUser) {
            insert topic;
        }
    }
    
    /*@method: get filled Briefing*/
    public static CEE__c getBriefing(String prefix, Boolean isInsert, String recordType, Account acct, Opportunity oppty, CEE_Location__c ceeLoc){
        CEE__c briefing = new CEE__c();
        
        //Related objects
        briefing.Primary_Account__c = acct.Id;
        if(oppty != null){
            briefing.Opportunity__c = oppty.Id;
            
        }
        
        if(ceeLoc != null){
            briefing.Primary_FSO__c = ceeLoc.Id;
            if(ceeLoc.Location_Type__c == 'EBC/EC'){
                briefing.EBC_CBC_Location__c = ceeLoc.Name;
            } else {
                briefing.EBC_CBC_Location__c = 'Other/FSO';
            }
        }
        
        //Record type
        RecordType ceeType = null;
        try{
             ceeType = [select Id from RecordType where DeveloperName =: recordType and SobjectType = 'CEE__c'];
             briefing.RecordTypeId = ceeType.Id;
        } catch (Exception e){
            System.debug('getBriefing - Error fetching record types - ' + e.getStackTraceString());
        }  
        
        //Other required fields
        briefing.Architecture__c = 'Collaboration';
        briefing.Sub_Architecture__c = 'Collaboration Overview';
        briefing.Business_Outcomes__c = 'Generate Growth';
        briefing.Decision_Maker__c = 'Chairman';
        briefing.Event_Type__c = 'Customer Briefing (1 Customer Account)';
        briefing.Number_of_Cisco_Attendees__c = 1;
        briefing.Number_of_Customer_Attendees__c = 1;
        briefing.Number_of_Customer_Executives__c = 1;
        briefing.Number_of_Partner_Attendees__c = 1;
        briefing.Legal__c = 'No';
        briefing.Segment__c = 'Enterprise';
        briefing.Vertical__c = 'Education';
        briefing.Subvertical__c = 'Other';
        if(briefing.EBC_CBC_Location__c == System.Label.CEE_SanJoseExperienceCenter ){
            briefing.Service_Charge_1K_USD_to_Engagement__c = 'Agree-One Company-1-day-$1K USD';
        }
        //Times
        briefing.Start_Date_Time__c = DateTime.now();
        briefing.End_Date_Time__c = briefing.Start_Date_Time__c.addHours(8);
        
        //PMs
        User pm = getUser(prefix+'pm1', true);
        User backupPM = getUser(prefix+'pm2', true);
        briefing.Program_Manager__c = pm.Id;
        briefing.Backup_PM__c = backupPM.Id;
        
        System.runAs(pm){
            if(isInsert){
                insert briefing;
                
                briefing = [select Id, Name, Primary_Account__c, Primary_FSO__c, Primary_FSO__r.Name, Primary_FSO__r.Site_Time_Zone__c, Opportunity__c, 
                EBC_CBC_Location__c, Architecture__c, Sub_Architecture__c, Business_Outcomes__c, Timezone__c,
                        Decision_Maker__c, Event_Type__c, Number_of_Cisco_Attendees__c, Number_of_Customer_Attendees__c, Number_of_Customer_Executives__c, 
                        Number_of_Partner_Attendees__c, Legal__c, Segment__c, Vertical__c, Subvertical__c, Start_Date_Time__c, End_Date_Time__c, 
                        Program_Manager__c, Backup_PM__c, Executive_Sponsors__c from CEE__c where Id =: briefing.Id ];
            }   
        }           
        return briefing;
    }
    
    /*@method: get Expertise object (Presenter__c)*/
    public static Presenter__c getExpertise(String prefix, Boolean isInsert){
        Presenter__c expertise = new Presenter__c();
        //expertise.Accept_for_Presenter__c =
        expertise.Active_Presenter__c = true;
        expertise.BRF_Qualified__c = true;
        expertise.Certifications_Training__c = 'expertise cert training';
        expertise.Cisco_Start_Year__c = '2013';
        expertise.Experience_Level_Presenting__c = 'expertise exp';
        //expertise.Individuals_to_CC__c =
        expertise.Load_Balancing__c = 'Tier 1';
        expertise.Member_of_ITSB__c = true;
        //expertise.My_Backup_Speakers__c =
        //expertise.My_Collaborators__c =
        expertise.Presentation_Topics__c = 'test1';
        expertise.Presenting_Languages__c = 'English';
        expertise.Segment_Experience__c = 'Enterprise';
        expertise.Speaker_Accreditation__c = 'expertise accreditation';
        expertise.Target_Audience__c = 'Business';
        expertise.Vertical_Experience__c = 'Energy/Utilities';
        
        User presenter = getUser(prefix+'pr1', true);
        expertise.User__c = presenter.Id;
        
        System.runAs (presenter) {
            if(isInsert){
                insert expertise;
            }
        }
        
        return expertise;
    }
    
    /*@method: load custom settings*/
    public static void loadCustomSettings(){
        //Object Record Type
        ObjectRecordTypeIds__c objrecType = new ObjectRecordTypeIds__c();
        objrecType.ACCOUNTCHANNELRECORDTYPEID__C='0123000000004aV';
        objrecType.ACCOUNT_END_USER_RECORDTYPEID__C='0123000000004aU';
        objrecType.ACCOUNTPARTNERCOMPANYRECORDTYPEID__C='01280000000G6ts';
        objrecType.CONTACT_MANUAL_ENDUSER_RECORDTYPEID__C='0123000000004aT';
        objrecType.CONTACT_MANUAL_PARTNER_RECORDTYPEID__C='01280000000G6ti';
        objrecType.CONTACT_PDB_RECORDTYPEID__C='01280000000G6tn';
        objrecType.CLOSED_LEAD_RECORDTYPEID__C='012300000001O02';
        objrecType.ELEADSRECORDTYPEID__C='0123000000004aR';
        objrecType.MANUAL_LEAD_RECORDTYPEID__C='0123000000004aS';
        objrecType.OPPORTUNITY_PARENT_RECORDTYPEID__C='0123000000003yk';
        objrecType.OPPORTUNITY_PARTNER_PARENT_RECORDTYPEID__C='0128000000020Dl';
        objrecType.OPPORTUNITY_PARTNER_PHASE_RECORDTYPEID__C='0128000000020Dq';
        objrecType.OPPORTUNITY_PHASE_RECORDTYPEID__C='012300000000CDL';
        objrecType.OPPORTUNITY_SOLUTION_PLAN_RECORDTYPEID__C='012300000000bfZ';
        objrecType.OPPORTUNITY_VOID_MERGED_RECORDTYPEID__C='012800000002e0M';
        objrecType.PARTNER_GENERATED_LEAD_RECORDTYPEID__C='012300000000lFW';
        objrecType.GSPO_QUALIFICATION_RECORD_TYPE__C='01280000000G7GD';
        objrecType.LCD_QUALIFICATION_RECORD_TYPE_ID__C='012800000003c7X';
        objrecType.BTX_ENGAGEMENT_ACTIVITY__C='01280000000G6LR';
        objrecType.BTX_NON_ENGAGEMENT_ACTIVITY__C='01280000000G6Lb';
        objrecType.CASE_TSN_RECORDTYPE__C='01280000000G78n';
        objrecType.MARKETING_LEAD_RECORDTYPE__C='012S00000000fSJ';
        objrecType.MARKETING_QUALIFIED_LEAD__C='012S00000000fSK';
        objrecType.CEE_OBX_Record_Type_ID__c='01280000000GFZzAAO';
        objrecType.CEE_CPOC_Record_Type_ID__c = '01234000000BmCR';
        
        //Org Constants
        List<Org_Constant_CS__c> orgConstant = new List<Org_Constant_CS__c>();
        orgConstant.add(new Org_Constant_CS__c(Name='Country Japan',Non_Production_Value__c='JAPAN',Production_Value__c='JAPAN'));
        orgConstant.add(new Org_Constant_CS__c(Name='NGCC_Items_to_Approve',Non_Production_Value__c='/00Q?fcf=00BS0000001wf2Q',Production_Value__c='/00Q?fcf=00BS0000001wf2Q'));
        orgConstant.add(new Org_Constant_CS__c(Name='NGCC_Items_to_Approve_Rejected',Non_Production_Value__c='/00Q?fcf=00BS0000001wf2L',Production_Value__c='/00Q?fcf=00BS0000001wf2L'));
        orgConstant.add(new Org_Constant_CS__c(Name='NGCC MODS Marketing History',Non_Production_Value__c='https://tools-stage.cisco.com/data/mktrs/services/Activities/getActivity',Production_Value__c='https://tools.cisco.com/data/mktrs/services/Activities/getActivity'));
        orgConstant.add(new Org_Constant_CS__c(Name='NGCC_Integration_User',Non_Production_Value__c='005S0000004TlsJ',Production_Value__c='005S0000004TlsJ'));
        orgConstant.add(new Org_Constant_CS__c(Name='NGCC_Answer_RecordType_Id',Non_Production_Value__c='012S00000000fSH',Production_Value__c='012S00000000fSH'));
        orgConstant.add(new Org_Constant_CS__c(Name='NGCC_Answer_Option_Id',Non_Production_Value__c='00NS0000001Nqj5_ileinner',Production_Value__c='00NS0000001Nqj5_ileinner'));
        orgConstant.add(new Org_Constant_CS__c(Name='NGCC_LeadScreenMashup',Non_Production_Value__c='/servlet/servlet.FileDownload?file=015S0000000cCm9',Production_Value__c='/servlet/servlet.FileDownload?file=015S0000000cCm9'));
        orgConstant.add(new Org_Constant_CS__c(Name='NGCC MODS Contact Service',Non_Production_Value__c='https://tools-stage.cisco.com/data/mktcs/services/ContactService/contactLookup',Production_Value__c='https://tools.cisco.com/data/mktcs/services/ContactService/contactLookup'));
        orgConstant.add(new Org_Constant_CS__c(Name='Contact_Delete_ChannelPartnerAccountID',Non_Production_Value__c='0018000000skzY3',Production_Value__c='0018000000skzY3'));
        orgConstant.add(new Org_Constant_CS__c(Name='QuotesPendingFinalznViewId',Non_Production_Value__c='00B80000007vmn2',Production_Value__c='00B80000007vmn2'));
        orgConstant.add(new Org_Constant_CS__c(Name='QuoteDeleteDummyOppty',Non_Production_Value__c='0068000000nrcFd',Production_Value__c='0068000000nrcFd'));
        orgConstant.add(new Org_Constant_CS__c(Name='PLOC_Profile_Id',Non_Production_Value__c='00e80000000sNoB',Production_Value__c='00e80000000sNoB'));
        orgConstant.add(new Org_Constant_CS__c(Name='Oppty Clone limit',Non_Production_Value__c='250',Production_Value__c='250'));
        orgConstant.add(new Org_Constant_CS__c(Name='PAUsed',Non_Production_Value__c='Incoming;Outgoing-Made Contact',Production_Value__c='Incoming;Outgoing-Made Contact'));
        orgConstant.add(new Org_Constant_CS__c(Name='P360_Portal_Profile',Non_Production_Value__c='00e800000011h7J',Production_Value__c='00e800000011h7J'));
        orgConstant.add(new Org_Constant_CS__c(Name='Partner_Admin_Role',Non_Production_Value__c='PARTNER_LED_APP_ADMIN',Production_Value__c='PARTNER_LED_APP_ADMIN'));
        orgConstant.add(new Org_Constant_CS__c(Name='Partner_Led_Program_Name',Non_Production_Value__c='Cisco Sales Collaboration Platform',Production_Value__c='Cisco Sales Collaboration Platform'));
        orgConstant.add(new Org_Constant_CS__c(Name='Partner_Sales_Rep_Role',Non_Production_Value__c='PARTNER_LED_APP_USER',Production_Value__c='PARTNER_LED_APP_USER'));
        orgConstant.add(new Org_Constant_CS__c(Name='Case Mgmt Email Relay',Non_Production_Value__c='0D2Q0000000CbTi:3rd_party_dummy@external.cisco.com:Cisco Case Management',Production_Value__c='0D2800000004DKj:cisco_sales_case_management@external.cisco.com:Cisco Case Management'));
        orgConstant.add(new Org_Constant_CS__c(Name='CCW_Deal_Creation_URL',Non_Production_Value__c='https://papps-stage.cisco.com/cisco/psn/commerce-tc-2',Production_Value__c='https://cisco-apps.cisco.com/cisco/psn/commerce'));
        orgConstant.add(new Org_Constant_CS__c(Name='OverDuePartnerOpportunityViewID',Non_Production_Value__c='00B80000008Pkif',Production_Value__c='00B80000008Pkif'));
        orgConstant.add(new Org_Constant_CS__c(Name='P360_AccountLimit_ForPartner',Non_Production_Value__c='600',Production_Value__c='600'));
        orgConstant.add(new Org_Constant_CS__c(Name='P360_UnknownTxM_UserId',Non_Production_Value__c='005800000047uXWAAY',Production_Value__c='005800000047uXWAAY'));
        orgConstant.add(new Org_Constant_CS__c(Name='P360_DefaultProspectExtnForPartner',Non_Production_Value__c='60 Days',Production_Value__c='60 Days'));
        orgConstant.add(new Org_Constant_CS__c(Name='P360_ProspectExpiringToday_ViewId',Non_Production_Value__c='00B80000008OK4Q',Production_Value__c='00B80000008OK4Q'));
        orgConstant.add(new Org_Constant_CS__c(Name='tools.cisco.com',Non_Production_Value__c='http://tools-stage.cisco.com/',Production_Value__c='http://tools.cisco.com/'));
        orgConstant.add(new Org_Constant_CS__c(Name='P360_TargetBulkAssignmentListView',Non_Production_Value__c='00B80000008Oct9',Production_Value__c='00B80000008Oct9'));
        orgConstant.add(new Org_Constant_CS__c(Name='Lead_RType_Closed',Non_Production_Value__c='012300000001O02',Production_Value__c='012300000001O02'));
        orgConstant.add(new Org_Constant_CS__c(Name='Lead_RType_PG_Lead',Non_Production_Value__c='012300000000lFW',Production_Value__c='012300000000lFW'));
        orgConstant.add(new Org_Constant_CS__c(Name='ProfileIds_for_Delete',Non_Production_Value__c='00e30000000dcbg;00e30000000dfUE;00e30000000eca0',Production_Value__c='00e30000000dcbg;00e30000000dfUE;00e30000000eca0'));
        orgConstant.add(new Org_Constant_CS__c(Name='P360 Assigned to PSR',Non_Production_Value__c='Assigned to PSR',Production_Value__c='Assigned to PSR'));
        orgConstant.add(new Org_Constant_CS__c(Name='P360 Marketing Play Name',Non_Production_Value__c='Customer Intelligence',Production_Value__c='Customer Intelligence'));
        orgConstant.add(new Org_Constant_CS__c(Name='P360 Partner',Non_Production_Value__c='Partner',Production_Value__c='Partner'));
        orgConstant.add(new Org_Constant_CS__c(Name='P360 Partner Assigned',Non_Production_Value__c='Partner Assigned',Production_Value__c='Partner Assigned'));
        orgConstant.add(new Org_Constant_CS__c(Name='P360 Actively working',Non_Production_Value__c='Actively working',Production_Value__c='Actively working'));
        orgConstant.add(new Org_Constant_CS__c(Name='P360 Target Architecture',Non_Production_Value__c='Any/All Technologies',Production_Value__c='Any/All Technologies'));
        orgConstant.add(new Org_Constant_CS__c(Name='P360 Target Prospects Source',Non_Production_Value__c='Cisco',Production_Value__c='Cisco'));
        orgConstant.add(new Org_Constant_CS__c(Name='P360 Lead Aging',Non_Production_Value__c='4',Production_Value__c='4'));
        orgConstant.add(new Org_Constant_CS__c(Name='Country China',Non_Production_Value__c='CHINA',Production_Value__c='CHINA'));
        orgConstant.add(new Org_Constant_CS__c(Name='Country Korea',Non_Production_Value__c='KOREA',Production_Value__c='KOREA'));
        orgConstant.add(new Org_Constant_CS__c(Name='PDR URL',Non_Production_Value__c='https://tools-stage.cisco.com/YS4PDD/ControllerNoAuth',Production_Value__c='https://apps.cisco.com/PDR/ControllerNoAuth'));
        orgConstant.add(new Org_Constant_CS__c(Name='DealIdService',Non_Production_Value__c='https://wsgx-test.cisco.com:443/quotecollab/oppty/services/DealIdService',Production_Value__c='https://wsgx.cisco.com:443/quotecollab/oppty/services/DealIdService'));
        orgConstant.add(new Org_Constant_CS__c(Name='wwwin-tools',Non_Production_Value__c='https://wwwin-tools-stage.cisco.com/',Production_Value__c='https://wwwin-tools.cisco.com/'));
        orgConstant.add(new Org_Constant_CS__c(Name='iwe',Non_Production_Value__c='http://iwe-test-stage.cisco.com/web/',Production_Value__c='http://iwe.cisco.com/web/'));
        orgConstant.add(new Org_Constant_CS__c(Name='VC Eligible Svc Url',Non_Production_Value__c='http://tools.cisco.com/GPSS/pvc/services/VCSFDCService/getVCEligible',Production_Value__c='http://tools.cisco.com/GPSS/pvc/services/VCSFDCService/getVCEligible'));
        orgConstant.add(new Org_Constant_CS__c(Name='VC user:pass',Non_Production_Value__c='salessfdc.gen:winter1998',Production_Value__c='salessfdc.gen:winter1998'));
        orgConstant.add(new Org_Constant_CS__c(Name='CCOSearch user:pass',Non_Production_Value__c='david.gen:winter2011',Production_Value__c='david.gen:winter2011'));
        orgConstant.add(new Org_Constant_CS__c(Name='CCO Search Svc Url',Non_Production_Value__c='http://wsgx-test1.cisco.com:80/mdm/party-wxys3/person/search',Production_Value__c='http://wsgx.cisco.com:80/mdm/party/person/search'));
        orgConstant.add(new Org_Constant_CS__c(Name='VC Update Svc Url',Non_Production_Value__c='http://tools.cisco.com/GPSS/pvc/services/VCSFDCService/updateVCEligible',Production_Value__c='http://tools.cisco.com/GPSS/pvc/services/VCSFDCService/updateVCEligible'));
        orgConstant.add(new Org_Constant_CS__c(Name='SE User',Non_Production_Value__c='SE User',Production_Value__c='SE User'));
        orgConstant.add(new Org_Constant_CS__c(Name='CreateDemoLoanOrderUrl',Non_Production_Value__c='http://tools-stage.cisco.com/GPSS/dlp/jsp/dlphome.jsp',Production_Value__c='http://tools.cisco.com/GPSS/dlp/jsp/dlphome.jsp'));
        orgConstant.add(new Org_Constant_CS__c(Name='Contact_Delete_EndUserAccountID',Non_Production_Value__c='0013000000GAJNf',Production_Value__c='0013000000GAJNf'));
        orgConstant.add(new Org_Constant_CS__c(Name='CEE Environment',Non_Production_Value__c='int',Production_Value__c=''));
        orgConstant.add(new Org_Constant_CS__c(Name='CEE RecordType',Non_Production_Value__c='012S00000000gTV',Production_Value__c='012S00000000gTV'));
        orgConstant.add(new Org_Constant_CS__c(Name='CEE Outlook URL',Non_Production_Value__c='https://wwwin-tools-stage.cisco.com',Production_Value__c='https://wwwin-tools.cisco.com'));
        orgConstant.add(new Org_Constant_CS__c(Name='CEE Field Prefix',Non_Production_Value__c='CF00NS',Production_Value__c=''));
        //NA6 Split changes
        orgConstant.add(new Org_Constant_CS__c(Name='Current Instance',Non_Production_Value__c=URL.getSalesforceBaseUrl().getHost(),Production_Value__c=URL.getSalesforceBaseUrl().getHost()));
        orgConstant.add(new Org_Constant_CS__c(Name='CEE OBX Reports Email',Non_Production_Value__c='test@cisco.com',Production_Value__c='test@cisco.com'));
        orgConstant.add(new Org_Constant_CS__c(Name='ConnectionUserId',Non_Production_Value__c='00580000006HZb9AAG',Production_Value__c='00580000006HZb9AAG'));
        
        User myUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs (myUser) {
            insert objrecType;
            insert orgConstant;
        }
        
    }
    
    /*@method: Simulate a room being invited*/
    public static void simulateRoomInvite(CEE_Invite__c invite, Boolean isTelepresence, Boolean isEBC){
    if(flsUpdateGet(CEE_Invite__c.Outlook_Invite_ID__c)) //SCAVA FIX
    {
        invite.Outlook_Invite_ID__c = '12345678910';
    }
        if(isEBC){
        if(flsUpdateGet(CEE_Invite__c.Outlook_Status__c)) //SCAVA FIX
        {
            invite.Outlook_Status__c = 'Accepted';
        }
        } else {
            invite.Outlook_Status__c = 'Invited';
        }
        if(flsUpdateGet(CEE_Invite__c.Telepresence_Enabled__c)) //SCAVA FIX
        {
        invite.Telepresence_Enabled__c = isTelepresence;
        }
        User myUser = new User();
        myUser.Id = UserInfo.getUserId();
        System.runAs (myUser) {
            update invite;
        }
    }
    
    /*@method: simulate a presenter being invited*/
    public static void simulatePresenterInvite(CEE_Invite__c invite){
     if(flsUpdateGet(CEE_Invite__c.Outlook_Invite_ID__c))  //SCAVA FIX
        invite.Outlook_Invite_ID__c = '12345678910';
        if(flsUpdateGet(CEE_Invite__c.Outlook_Status__c))  //SCAVA FIX
        invite.Outlook_Status__c = 'Invited';
        
        User myUser = new User();
        myUser.Id = UserInfo.getUserId();
        System.runAs (myUser) {
            update invite;
        }
    }
   
    /*@method: simulate the inbox reader running*/
    public static void simulateInboxReader(CEE_Invite__c invite){
    
    
    if(flsUpdateGet(CEE_Invite__c.Outlook_Invite_ID__c))  //SCAVA FIX
       { 
       invite.Outlook_Invite_ID__c = '12345678910';
       }
    if(flsUpdateGet(CEE_Invite__c.Outlook_Status__c)) //SCAVA FIX
        {
        invite.Outlook_Status__c = 'Accepted';
       }
        
        User myUser = new User();
        myUser.Id = UserInfo.getUserId();
        System.runAs (myUser) {
            update invite;
        }
    }
    
    public static Opportunity getOpty(){
        Org_Constants__c os =new Org_Constants__c();
        os.Key__c = 'Oppty: ProfileIds to skip Triggers';
        os.non_prod_value__c = '00e30000000dcbfAAA,00e30000000dfUEAAY,00e30000000eca0AAA,00e30000000qiJjAAI,00e30000000dcbgAAA,00e30000000rrZwAAI';
        os.Prod_LT__c = 'GSTS,Data_Migration,Integration_Echo_Suppression,GSTS_Analyst,ADMIN, PSS';
        os.prod_value__c = '00e30000000dcbfAAA,00e30000000dfUEAAY,00e30000000eca0AAA,00e30000000qiJjAAI,00e30000000dcbgAAA,00e30000000rrZwAAI';
        os.Type__c = 'URL';
        insert os;
        
        ProfileID__c  pd1 = new ProfileID__c ();
        pd1.Cisco_Renewals__c = '00e34000001CQnp';
        pd1.Cisco_PSS__c='00e30000000rrZw';
        insert pd1;
        
        Account act = GenericStaticTestData.gettestChannelAccountRecord1();
        Date vCloseDate = System.today();
        User currentUser = [select defaultCurrencyIsoCode from User where Id = :UserInfo.getUserId()];      
         
           Opportunity oppr  = GenericStaticTestData.gettestParentOpportunityRecord(); 
        List<Opportunity> oppty= new List<Opportunity>(); 
      /*  Opportunity  opppt = new Opportunity(name='Test1',StageName='1 - Identify',CloseDate= vCloseDate,Expected_Product__c=0,DealID__c ='122',
                                         CurrencyIsoCode=currentUser.defaultCurrencyIsoCode,Forecast_Discount__c=10,Primary_Partner__c=act.id,Opportunity_Status__c ='Active');*/
        
         Opportunity opppt = new Opportunity (Name ='Test',
            StageName ='1 - Identify',
            Primary_Partner__c = act.id,
            CloseDate =System.today() + 5, 
            Expected_Product__c = 10.0, 
            Expected_Service__c = 10.0, 
            DealID__c = '1',
            Opportunity_Status__c = 'Active',
            RecordTypeId = Utilities.getOpptyParentRecordTypeId(),
            ForecastCategoryName = 'Commit');                                  
                                         
        oppty.add(opppt);
        insert oppty;
       // List<Opportunity> Opptylist1 = [Select id,name,StageName,CloseDate,Expected_Product__c,CurrencyIsoCode,Forecast_Discount__c,Primary_Partner__c from opportunity where id=:opppt.id];
        
        return oppty[0];
    }
    
    
    
    /* Unused/not created currently based on testing requirements (shell objects included for future reference on what was not created)
    public static CEE_Calendar__c getCalendar(String prefix, Boolean isInsert){
        CEE_Calendar__c calendar = new CEE_Calendar__c();
        
        User myUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs (myUser) {
            if(isInsert){
                insert calendar;
            }
        }
        
        return calendar;
    }
    
    public static CEE_Demo__c getDemo(String prefix, Boolean isInsert){
        CEE_Demo__c demo = new CEE_Demo__c();
        
        User myUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs (myUser) {
            if(isInsert){
                insert demo;
            }
        }
        
        return demo;
    }
    
    public static Multi_Account_Engagement__c getMultiAccount(String prefix, Boolean isInsert){
        Multi_Account_Engagement__c account = new Multi_Account_Engagement__c();
        
        User myUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs (myUser) {
            if(isInsert){
                insert account;
            }
        }
        
        return account;
    }
    
    public static Opportunity getOpportunity(String prefix, Account acct){
        Opportunity oppty = new Opportunity();
        
        
        insert oppty;
        
        return oppty;
    }*/
}