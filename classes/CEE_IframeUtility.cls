/***************************************************************************************************
Name    : CEE_IframeUtility
Author  : Eric Pesch
Purpose : Method utility class for gathering JSON parameters based on passed in records.  
Created Date: Nov 15 2014
Modification History: 
Eric Pesch - Nov 15 2014: Initial Creation
Eric Pesch - Jan 6 2015: Added Comments, cleanup  
Eric Pesch - Feb 25 2015: 'null' location value being populated on Emails when no Rooms selected   
Sudi - June 14 2016 : US10715 - Allow adding non SFDC user as a presenter and sending outlook invite to Cisco email.
Bramha - july 14 2017 added the program manger email insted created by email in from addres                
*****************************************************************************************************/ 

public class CEE_IframeUtility {
    //Debug variables
    private static final String TAG = 'CEE_IframeUtility - ';
    private static final String CURR_PREFIX = ',';
    
    /*@Class: Temporary pair for holding an <Invite, Attendee> pair*/
    private class InviteAttendee{
        public CEE_Invite__c invite { get; set; } 
        public CEE_Attendee__c attendee { get; set;}
        
        public InviteAttendee(CEE_Invite__c invite, CEE_Attendee__c attendee){
            this.invite = invite;
            this.attendee = attendee;
        }
    }
    
    /*@Class: Temporary pair for holding an <Invite, Room> pair*/
    private class InviteRoom{
        public CEE_Invite__c invite { get; set; } 
        public Agenda_Room__c room { get; set;}
        
        public InviteRoom(CEE_Invite__c invite, Agenda_Room__c room){
            this.invite = invite;
            this.room = room;
        }
    }
    
    /*@method: Add keys required - sending a Briefing - availability function*/
    public static Map<String, Object> addBriefingSearchKeys(CEE__c briefing){
        Map<String, Object> keys = new Map<String, Object>();
        String searchKeys = '', searchType = '', searchTimezone = '', searchSize = '', searchName = '', searchEBC = '', searchTP = '', searchID = '';
        String prefix = '';
        try{
            //Attendees
            List<CEE_Attendee__c> attendees = [select Id, Agenda_Item__r.Id, Salesforce_User__c, Salesforce_User__r.Email, Salesforce_User__r.TimeZoneSidKey 
                    from CEE_Attendee__c where Customer_Engagement_Events__c =: briefing.Id];
                    
            for(CEE_Attendee__c attendee : attendees){
                if(attendee.Salesforce_User__c != null){
                    String[] cec = attendee.Salesforce_User__r.Email.split('@');
                    prefix = '';
                    if(!String.isEmpty(searchKeys)){
                        prefix = CURR_PREFIX;
                    }
                    
                    searchKeys += prefix + cec[0];
                    searchType += prefix + 'PERSON';
                    searchID += prefix + attendee.Id;
                    searchSize += prefix + '1';
                    searchName += prefix + cec[0];
                    searchTimezone += prefix + attendee.Salesforce_User__r.TimeZoneSidKey;
                    
                    //nulling values
                    searchEBC += prefix + 'N';
                    searchTP += prefix + 'N';
                }
            }
            
            //Rooms
            List<Agenda_Room__c> rooms = [select Id, Room__c, Room__r.CEE_Location__c, Room__r.Email_Code__c, 
                    Room__r.CEE_Location__r.Site_Time_Zone__c, Room__r.CEE_Location__r.Location_Type__c,
                    Room__r.Display_Name__c, Room__r.Size__c, Room__r.Is_Telepresence__c
                    from Agenda_Room__c where Customer_Engagements_Events__c =: briefing.Id];
            
            for(Agenda_Room__c room : rooms){
                prefix = '';
                if(!String.isEmpty(searchKeys)){
                    prefix = CURR_PREFIX;
                }               
                
                searchKeys += prefix + room.Room__r.Email_Code__c;
                searchType += prefix + 'ROOM';
                searchID += prefix + room.Id;
                searchSize += prefix + room.Room__r.Size__c;
                searchName += prefix + room.Room__r.Display_Name__c;
                searchTimezone += prefix + room.Room__r.CEE_Location__r.Site_Time_Zone__c;
                
                if(room.Room__r.Is_Telepresence__c){
                    searchTP += prefix + 'Y';
                } else {
                    searchTP += prefix + 'N';
                }
                
                if(room.Room__r.CEE_Location__r.Location_Type__c.equalsIgnoreCase('EBC/EC')){
                    searchEBC += 'Y';
                } else {
                    searchEBC += 'N';
                }
            }
            
        } catch (Exception e){
            System.debug(TAG + 'addAgendaSearchKey exception - ' + e.getMessage());
            System.debug(TAG + e.getStackTraceString());
            
            return null;
        }
        
        //Final object output
        keys.put('searchKey', searchKeys);
        keys.put('searchType', searchType);
        keys.put('searchID', searchID);
        keys.put('searchTimezone', searchTimezone);
        keys.put('searchName', searchName);
        keys.put('searchSize', searchSize);
        keys.put('searchEBC', searchEBC);
        keys.put('searchTP', searchTP);
        
        return keys;
    }
    
    /*@method: Add keys required - sending an Agenda Item - availability function*/
    public static Map<String, Object> addAgendaSearchKeys(Agenda_Item__c agenda){
        Map<String, Object> keys = new Map<String, Object>();
        String searchKeys = '', searchType = '', searchTimezone = '', searchSize = '', searchName = '', searchEBC = '', searchTP = '', searchID = '';
        
        try{
            //Attendees
            List<CEE_Attendee__c> attendees = [select Id, Agenda_Item__r.Id, Salesforce_User__c, Salesforce_User__r.Email, Salesforce_User__r.TimeZoneSidKey 
                    from CEE_Attendee__c where Agenda_Item__r.Id =: agenda.Id];
                    
            for(CEE_Attendee__c attendee : attendees){
                if(attendee.Salesforce_User__c != null){
                    String[] cec = attendee.Salesforce_User__r.Email.split('@');
                    String prefix = '';
                    if(!String.isEmpty(searchKeys)){
                        prefix = CURR_PREFIX;
                    }
                    
                    searchKeys += prefix + cec[0];
                    searchType += prefix + 'PERSON';
                    searchID += prefix + attendee.Id;
                    searchSize += prefix + '1';
                    searchName += prefix + cec[0];
                    searchTimezone += prefix + attendee.Salesforce_User__r.TimeZoneSidKey;
                    
                    //nulling values
                    searchEBC += prefix + 'N';
                    searchTP += prefix + 'N';
                }
            }
        } catch (Exception e){
            System.debug(TAG + 'addAgendaSearchKey exception - ' + e.getMessage());
            System.debug(TAG + e.getStackTraceString());
            
            return null;
        }
        
        //Final object output
        keys.put('searchKey', searchKeys);
        keys.put('searchType', searchType);
        keys.put('searchID', searchID);
        keys.put('searchTimezone', searchTimezone);
        keys.put('searchName', searchName);
        keys.put('searchSize', searchSize);
        keys.put('searchEBC', searchEBC);
        keys.put('searchTP', searchTP);
        
        return keys;
    }
    
    /*@method: Add keys required - sending a CEE Location - availability function*/
    public static Map<String, Object> addLocationSearchKeys(CEE_Location__c location){
        Map<String, Object> keys = new Map<String, Object>();
        String prefix = '';
        
        //Timezone information
        String searchPrimaryTimezone = location.Site_Time_Zone__c;
        if(searchPrimaryTimezone == null || searchPrimaryTimezone == ''){
            searchPrimaryTimezone = 'America/Los_Angeles';
        }
        
        //CEE Location keys        
        String formatDate = DateTime.now().format('dd-MMM-yyyy', searchPrimaryTimezone);
        String formatStartTime = DateTime.now().format('HH:mm', searchPrimaryTimezone);
        String formatEndTime = DateTime.now().format('HH:mm', searchPrimaryTimezone);

        //Room specific keys
        String searchKeys = '', searchType = '', searchTimezone = '', searchSize = '', searchName = '', searchEBC = '', searchTP = '';
        
        //Generic date keys
        keys.put('searchPrimaryTimezone', searchPrimaryTimezone);   //timezone or user.TimeZoneSidKey
        keys.put('startDate', formatDate);                          //briefing/agenda date
        keys.put('endDate', formatDate);                            //briefing/agenda date in dd-MMM-yyyy format
        keys.put('startTime', formatStartTime);
        keys.put('endTime', formatEndTime);
        
        try{
            //Adding the rooms
            for(CEE_Room__c room : [select CEE_Location__c, Email_Code__c, 
                    Display_Name__c, Size__c, Is_Telepresence__c from CEE_Room__c
                    where CEE_Location__c =: location.Id]){
                prefix = '';
                if(!String.isEmpty(searchKeys)){
                    prefix = CURR_PREFIX;
                }        
                
                searchKeys += prefix + room.Email_Code__c; //CONF_1858@cisco.com or epesch
                searchType += prefix + 'ROOM';                  //ROOM or PERSON
                searchSize += prefix + room.Size__c;       //# or 1
                searchName += prefix + room.Display_Name__c;   //BOB MATHIAS or ERIC PESCH
                searchTimezone += prefix + searchPrimaryTimezone;  //timezone or user.TimeZoneSidKey
                
                if(room.Is_Telepresence__c){
                    searchTP += prefix + 'Y';
                } else {
                    searchTP += prefix + 'N';
                }
                
                if(location.Location_Type__c.equalsIgnoreCase('EBC/EC')){
                    searchEBC += prefix + 'Y';
                } else {
                    searchEBC += prefix + 'N';
                }       
            }
            
        } catch (Exception e){
            System.debug(TAG + e.getStackTraceString());
            
            return null;
        }
        
        //Final object output
        keys.put('searchKey', searchKeys);
        keys.put('searchType', searchType);
        keys.put('searchTimezone', searchTimezone);
        keys.put('searchName', searchName);
        keys.put('searchSize', searchSize);
        keys.put('searchEBC', searchEBC);   
        keys.put('searchTP', searchTP);     
        
        return keys;
    }
    
    /*@method: Add keys required - sending a CEE Attendee - availability function*/
    public static Map<String, Object> addPresenterSearchKeys(CEE_Attendee__c attendee){
        Map<String, Object> keys = new Map<String, Object>();
        String prefix = '';
        
        //Timezone information
        String searchPrimaryTimezone = attendee.Salesforce_User__r.TimeZoneSidKey;
        if(searchPrimaryTimezone == null || searchPrimaryTimezone == ''){
            searchPrimaryTimezone = 'America/Los_Angeles';
        }
        
        //CEE Location keys        
        String formatDate = DateTime.now().format('dd-MMM-yyyy', searchPrimaryTimezone);
        String formatStartTime = DateTime.now().format('HH:mm', searchPrimaryTimezone);
        String formatEndTime = DateTime.now().format('HH:mm', searchPrimaryTimezone);

        //Room specific keys
        // how to handle these?
        String searchKeys = '', searchType = '', searchTimezone = '', searchSize = '', searchName = '', searchEBC = '', searchTP = '';
        
        //Generic date keys
        keys.put('searchPrimaryTimezone', searchPrimaryTimezone);   //timezone or user.TimeZoneSidKey
        keys.put('startDate', formatDate);                          //briefing/agenda date
        keys.put('endDate', formatDate);                            //briefing/agenda date in dd-MMM-yyyy format
        keys.put('startTime', formatStartTime);
        keys.put('endTime', formatEndTime);
        
        try{
            //Add Attendee specific information
            for(CEE_Attendee__c att : [select Name, Salesforce_User__c, Salesforce_User__r.Email from CEE_Attendee__c
                    where Id =: attendee.Id]){
                String[] emailComponents = att.Salesforce_User__r.Email.split('@');
                String cecID = emailComponents[0];
                System.debug(TAG + 'CECID is: ' + cecID);
                prefix = '';
                if(!String.isEmpty(searchKeys)){
                    prefix = CURR_PREFIX;
                } 
                       
                searchKeys += prefix + cecID; //CONF_1858@cisco.com or epesch
                searchType += prefix + 'PERSON';                  //ROOM or PERSON
                searchSize += prefix + '1';
                searchName += prefix + cecID;
                searchEBC += prefix + 'N';
                searchTP += prefix + 'N';
                searchTimezone += prefix + searchPrimaryTimezone;  //timezone or user.TimeZoneSidKey
            }
        } catch (Exception e){
            System.debug(TAG + e.getStackTraceString());
            
            return null;
        }
    
        //Final object output
        keys.put('searchKey', searchKeys);
        keys.put('searchType', searchType);
        keys.put('searchTimezone', searchTimezone);
        keys.put('searchName', searchName);
        keys.put('searchSize', searchSize);
        keys.put('searchEBC', searchEBC);   //N for person
        keys.put('searchTP', searchTP);     //N for person
        
        return keys;
    }
    
    /*@method: Add keys required - sending an Agenda Item - invitation function*/
    public static Map<String, Object> addAgendaItemInviteKeys(Agenda_Item__c agenda, String timezone){
        Map<String, Object> keys = new Map<String, Object>();
        String searchKeys = '', searchType = '', searchTimezone = '', searchSize = '', searchName = '', 
            searchEBC = '', searchTP = '', searchID = '', searchInvitation = '', searchCEEInvitation = '',
            emailPMName = '', emailPMCEC = '', isTPInvite = '', emailID = '', emailLocation = '', uniqueKeyName = '', uniqueKeyType = '', uniqueKey = '',
            startTime = '', endTime = '', startDate = '', endDate = '';
        String prefix = '';
        
        //Gather old invites from previous invitations
        List<CEE_Invite__c> oldInvites = null;
        Map<Id, CEE_Invite__c> oldAttendeePair = new Map<Id, CEE_Invite__c>();
        Map<Id, User> oldOwnerPair = new Map<Id, User>();
        List<Id> oldAttendee = new List<Id>();
        List<Id> oldOwner = new List<Id>();
        
        //Get invites relating to Agenda_Item__c
        try{
            oldInvites = [select Id, OwnerId, CEE_Attendee__c, Room__c, Outlook_Invite_ID__c, Telepresence_Enabled__c  from CEE_Invite__c where Agenda_Item__c =: agenda.Id 
                            AND Update_Selected__c =: true];  
        } catch (Exception e){
            System.debug(TAG + e.getStackTraceString());
        }
        
        //Make pairings of invites to Attendee or Room
        for(CEE_Invite__c invite : oldInvites){
            if(invite.CEE_Attendee__c != null){
                oldAttendeePair.put(invite.CEE_Attendee__c, invite);
                oldAttendee.add(invite.CEE_Attendee__c);
            }
            
            oldOwner.add(invite.OwnerId);  
        }
        
        //Grab all the owners of the various invites
        try{
            List<User> owners = [select Id, Name, Email from User where Id in : (oldOwner)];
            for(User owner : owners){
                oldOwnerPair.put(owner.Id, owner);
            }
        } catch (Exception e){
            System.debug(tAG + e.getStackTraceString());
        }
        
        try{
            //Attendees
            List<CEE_Attendee__c> attendees = null;
            
            //If new, get Attendees w/o CEE_Invites
            //Sudi - 06/14/2016 : Removed the and condition Salesforce_User__c != null to allow Non SFDC user also send email invite.  
            attendees = [select Id, Agenda_Item__r.Id, Salesforce_User__c, Salesforce_User__r.Email, Salesforce_User__r.TimeZoneSidKey ,Email__c
                from CEE_Attendee__c where Agenda_Item__r.Id =: agenda.Id AND Type__c =: 'Presenter' AND id in : oldAttendee];
        
            for(CEE_Attendee__c attendee : attendees){              
                //Whether new or old, get attendee information to create/modify 
                // Adding extra condition to add non sfdc user Cisco CEC id.
                String[] cec;
                if(attendee.Salesforce_User__c != null){
                      cec = attendee.Salesforce_User__r.Email.split('@');                   
                }
                else{
                    cec = attendee.Email__c.split('@');
                }   
                prefix = '';
                if(!String.isEmpty(searchKeys)){
                    prefix = CURR_PREFIX;
                } 
                
                searchKeys += prefix + cec[0];
                searchType += prefix + 'PERSON';
                searchID += prefix + attendee.Id;
                searchSize += prefix + '1';
                searchName += prefix + cec[0];
                searchTimezone += prefix + attendee.Salesforce_User__r.TimeZoneSidKey;
                
                //Add time values
                startTime += prefix + getFormatTime(agenda.Start_Date_Time__c, timezone);
                endtime += prefix + getFormatTime(agenda.End_Date_Time__c, timezone);
                startDate += prefix + getFormatDate(agenda.Start_Date_Time__c, timezone);
                endDate += prefix + getFormatDate(agenda.End_Date_Time__c, timezone);
                
                //nulling values
                searchEBC += prefix + 'N';
                searchTP += prefix + 'N';
                
                //Invite values                
                searchInvitation += prefix + oldAttendeePair.get(attendee.Id).Outlook_Invite_ID__c;
                searchCEEInvitation += prefix + oldAttendeePair.get(attendee.Id).Id;
                isTPInvite += prefix + 'N';
                
                //Add owner PM information 
                //Adding as per the WR
                String ownerEmail = oldOwnerPair.get(oldAttendeePair.get(attendee.Id).OwnerId).Email;
                emailPMCEC += prefix + ownerEmail.substring(0, ownerEmail.indexOf('@'));
                emailPMName += prefix + oldOwnerPair.get(oldAttendeePair.get(attendee.Id).OwnerId).Name;
                emailID += prefix + agenda.Id;
                
                //FIX epesch 2/25/2015 - null email location
                if(String.isEmpty(agenda.Selected_Rooms_Display__c)){
                    emailLocation += prefix + System.label.CEE_Email_Empty_Location;
                } else {
                    emailLocation += prefix + agenda.Selected_Rooms_Display__c;
                }
                
                //Add unique identifier for emails
                uniqueKeyName += prefix + agenda.Name;
                uniqueKeyType += prefix + 'Agenda_Item__c';
                uniqueKey += prefix + agenda.Id;
            }
        } catch (Exception e){
            System.debug(TAG + 'addAgendaSearchKey exception - ' + e.getMessage());
            System.debug(TAG + e.getStackTraceString());
            
            return null;
        }
        
        //Final object output
        keys.put('searchKey', searchKeys);
        keys.put('searchType', searchType);
        keys.put('searchID', searchID);
        keys.put('searchTimezone', searchTimezone);
        keys.put('searchName', searchName);
        keys.put('searchSize', searchSize);
        keys.put('searchEBC', searchEBC);
        keys.put('searchTP', searchTP);
        keys.put('searchInvitation', searchInvitation);
        keys.put('searchCEEInvitation', searchCEEInvitation);
        keys.put('isTPInvite', isTPInvite);
        keys.put('emailPMCEC', emailPMCEC);
        keys.put('emailPMName', emailPMName);
        keys.put('emailID', emailID);
        keys.put('emailLocation', emailLocation);
        keys.put('uniqueKeyName', uniqueKeyName);
        keys.put('uniqueKeyType', uniqueKeyType);
        keys.put('uniqueKey', uniqueKey);
        keys.put('startDate', startDate);
        keys.put('endDate', endDate);
        keys.put('startTime', startTime);
        keys.put('endTime', endTime);
        
        return keys;
    }
    
    /*@method: Add keys required - sending a Briefing - invitation function*/
    public static Map<String, Object> addBriefingInviteKeys(CEE__c briefing, Boolean includeRooms, Boolean includePeople, String timezone){
        Map<String, Object> keys = new Map<String, Object>();
        String searchKeys = '', searchType = '', searchTimezone = '', searchSize = '', searchName = '', 
            searchEBC = '', searchTP = '', searchID = '', searchInvitation = '', searchCEEInvitation = '',
            emailPMName = '', emailPMCEC = '', isTPInvite = '', emailID = '', emailLocation = '', uniqueKey = '', 
            uniqueKeyName = '', uniqueKeyType = '', startTime = '', endTime = '', startDate = '', endDate = '';
        String prefix = '';           
        //Gather old invites from previous invitations
        List<CEE_Invite__c> oldInvites = null;
        
        Map<Id, CEE_Invite__c> oldAttendeePair = new Map<Id, CEE_Invite__c>();
        List<Id> oldAttendee = new List<Id>();
        
        Map<Id, CEE_Invite__c> oldRoomPair = new Map<Id, CEE_Invite__c>();
        List<Id> oldRoom = new List<Id>();
        
        Map<Id, User> oldOwnerPair = new Map<Id, User>();
        List<Id> oldOwner = new List<Id>();
        
        //Get invites relating to Agenda_Item__c
        try{
            oldInvites = [select Id, OwnerId, CEE_Attendee__c, CEE_Attendee__r.Customer_Engagement_Events__c, Room__c, Room__r.Customer_Engagements_Events__c,
                         Outlook_Invite_ID__c, Telepresence_Enabled__c from CEE_Invite__c 
                         where (CEE_Attendee__r.Customer_Engagement_Events__c =: briefing.Id OR 
                         Room__r.Customer_Engagements_Events__c =: briefing.Id) AND Update_Selected__c =: true];  
        } catch (Exception e){
            System.debug(TAG + e.getStackTraceString());
        }
        
        //Make pairings of invites to Attendee or Room
        for(CEE_Invite__c invite : oldInvites){
            prefix = '';
            if(!String.isEmpty(isTPInvite)){
                prefix = CURR_PREFIX;
            } 
            
            if(invite.CEE_Attendee__c != null){
                oldAttendeePair.put(invite.CEE_Attendee__c, invite);
                oldAttendee.add(invite.CEE_Attendee__c);
            }
            
            if(invite.Room__c != null){
                oldRoomPair.put(invite.Room__c, invite);
                oldRoom.add(invite.Room__c);
            }
            
            oldOwner.add(invite.OwnerId);          
            if(invite.Telepresence_Enabled__c){        
                isTPInvite += prefix + 'Y';
            } else {
                isTPInvite += prefix + 'N';
            }
        }
        
        //Grab all the owners of the various invites
        try{
            List<User> owners = [select Id, Name, Email from User where Id in : (oldOwner)];
            for(User owner : owners){
                oldOwnerPair.put(owner.Id, owner);
            }
        } catch (Exception e){
            System.debug(tAG + e.getStackTraceString());
        }
        
        try{
            //Attendees
            //Sudi - 06/14/2016 : Removed the and condition Salesforce_User__c != null to allow Non SFDC user also send email invite. 
            List<CEE_Attendee__c> attendees = [select Id, Agenda_Item__r.Id, Agenda_Item__r.Name, Agenda_Item__r.Start_Date_Time__c, Agenda_Item__r.End_Date_Time__c,Email__c,
                                                 Agenda_Item__r.Selected_Rooms_Display__c, Salesforce_User__c, Salesforce_User__r.Email, Salesforce_User__r.TimeZoneSidKey 
                                                from CEE_Attendee__c where Type__c =: 'Presenter' AND id in : oldAttendee];
            if (includePeople){
                for(CEE_Attendee__c attendee : attendees){   
                    // Sudi - 06/14/2016 : allowing non SFDC user ti send email ids based on their Cisco CEC id.
                    String[] cec;
                    if(attendee.Salesforce_User__c != null){
                          cec = attendee.Salesforce_User__r.Email.split('@');                   
                    }
                    else{
                        cec = attendee.Email__c.split('@');
                        
                    }                    
                    prefix = '';
                    if(!String.isEmpty(searchKeys)){
                        prefix = CURR_PREFIX;
                    } 
                    
                    searchKeys += prefix + cec[0];
                    searchType += prefix + 'PERSON';
                    searchID += prefix + attendee.Id;
                    searchSize += prefix + '1';
                    searchName += prefix + cec[0];
                    searchTimezone += prefix + attendee.Salesforce_User__r.TimeZoneSidKey;                     
                    searchInvitation += prefix + oldAttendeePair.get(attendee.Id).Outlook_Invite_ID__c;
                    searchCEEInvitation += prefix + oldAttendeePair.get(attendee.Id).Id;
                    
                    //Add time values
                    startTime += prefix + getFormatTime(attendee.Agenda_Item__r.Start_Date_Time__c, timezone);
                    endtime += prefix + getFormatTime(attendee.Agenda_Item__r.End_Date_Time__c, timezone);
                    startDate += prefix + getFormatDate(attendee.Agenda_Item__r.Start_Date_Time__c, timezone);
                    endDate += prefix + getFormatDate(attendee.Agenda_Item__r.End_Date_Time__c, timezone);
                    
                    //nulling values
                    searchEBC += prefix + 'N';
                    searchTP += prefix + 'N';
                    
                    //Add owner PM information 
                    //added as per Program manager email                    
                    String ownerEmail = briefing.Program_Manager__r.email;//UserInfo.getUserEmail();//oldOwnerPair.get(oldAttendeePair.get(attendee.Id).OwnerId).Email;                    
                    emailPMCEC += prefix + ownerEmail.substring(0, ownerEmail.indexOf('@'));
                    emailPMName += prefix + briefing.Program_Manager__r.name;//oldOwnerPair.get(oldAttendeePair.get(attendee.Id).OwnerId).Name;
                    emailID += prefix + attendee.Agenda_Item__r.Id;
                    
                    //FIX epesch 2/25/2015 - null email location
                    if(String.isEmpty(attendee.Agenda_Item__r.Selected_Rooms_Display__c)){
                        emailLocation += prefix + System.label.CEE_Email_Empty_Location;
                    } else {
                        emailLocation += prefix + attendee.Agenda_Item__r.Selected_Rooms_Display__c;
                    }
                    
                    //Add unique key for emails
                    uniqueKeyName += prefix + attendee.Agenda_Item__r.Name;
                    uniqueKeyType += prefix + 'Agenda_Item__c';
                    uniqueKey += prefix + attendee.Agenda_Item__r.Id;
                }
            }
            
            //Rooms
            if (includeRooms){
                List<Agenda_Room__c> rooms = [select Id, Room__c, Room__r.Name, Room__r.CEE_Location__c, Room__r.Email_Code__c, 
                                            Room__r.CEE_Location__r.Site_Time_Zone__c, Room__r.CEE_Location__r.Location_Type__c,
                                            Room__r.Display_Name__c, Room__r.Size__c, Room__r.Is_Telepresence__c, Start_Date_Time__c,
                                            End_Date_Time__c
                                            from Agenda_Room__c where id in : oldroom];
            
                for(Agenda_Room__c room : rooms){
                    prefix = '';
                    if(!String.isEmpty(searchKeys)){
                        prefix = CURR_PREFIX;
                    } 
                    
                    searchKeys += prefix + room.Room__r.Email_Code__c;
                    searchType += prefix + 'ROOM';
                    searchID += prefix + room.Id;
                    searchSize += prefix + room.Room__r.Size__c;
                    searchName += prefix + room.Room__r.Display_Name__c;
                    searchTimezone += prefix + room.Room__r.CEE_Location__r.Site_Time_Zone__c;
                    searchInvitation += prefix + oldRoomPair.get(room.Id).Outlook_Invite_ID__c;
                    searchCEEInvitation += prefix + oldRoomPair.get(room.Id).Id;
                    
                    startTime += prefix + getFormatTime(room.Start_Date_Time__c, timezone);
                    endtime += prefix + getFormatTime(room.End_Date_Time__c, timezone);
                    startDate += prefix + getFormatDate(room.Start_Date_Time__c, timezone);
                    endDate += prefix + getFormatDate(room.End_Date_Time__c, timezone);
                    
                    if(room.Room__r.Is_Telepresence__c){
                        searchTP += prefix + 'Y';
                    } else {
                        searchTP += prefix + 'N';
                    }
                    
                    if(room.Room__r.CEE_Location__r.Location_Type__c.equalsIgnoreCase('EBC/EC')){
                        searchEBC += prefix + 'Y';
                    } else {
                        searchEBC += prefix + 'N';
                    }
                    
                    //Add owner PM information 
                    //Adding Program manager email
                    String ownerEmail = briefing.Program_Manager__r.email;//oldOwnerPair.get(oldRoomPair.get(room.Id).OwnerId).Email;
                    emailPMCEC += prefix + ownerEmail.substring(0, ownerEmail.indexOf('@'));
                    emailPMName += prefix + briefing.Program_Manager__r.name;//oldOwnerPair.get(oldRoomPair.get(room.Id).OwnerId).Name;
                    emailID += prefix + room.Id;
                    emailLocation += prefix + room.Room__r.Name;
                    
                    //Add unique identifier for emails
                    uniqueKeyName += prefix + briefing.Name;
                    uniqueKeyType += prefix + 'Customer_Engagements_Events__c';
                    uniqueKey += prefix + briefing.Id;
                }
            }    
        } catch (Exception e){
            System.debug(TAG + 'addAgendaSearchKey exception - ' + e.getMessage());
            System.debug(TAG + e.getStackTraceString());
            
            return null;
        }
            
        //Final object output
        keys.put('searchKey', searchKeys);
        keys.put('searchType', searchType);
        keys.put('searchID', searchID);
        keys.put('searchTimezone', searchTimezone);
        keys.put('searchName', searchName);
        keys.put('searchSize', searchSize);
        keys.put('searchEBC', searchEBC);
        keys.put('searchTP', searchTP);
        keys.put('searchInvitation', searchInvitation);
        keys.put('searchCEEInvitation', searchCEEInvitation);
        keys.put('isTPInvite', isTPInvite);
        keys.put('emailPMCEC', emailPMCEC);
        keys.put('emailPMName', emailPMName);
        keys.put('emailID', emailID);
        keys.put('emailLocation', emailLocation);
        keys.put('uniqueKeyName', uniqueKeyName);
        keys.put('uniqueKeyType', uniqueKeyType);
        keys.put('uniqueKey', uniqueKey);
        keys.put('startDate', startDate);
        keys.put('endDate', endDate);
        keys.put('startTime', startTime);
        keys.put('endTime', endTime);
        return keys;
    }
    
    /*@method: Add keys required - filling an Invitation dynamically - invitation function*/
    public static Map<String, Object> addInvitations(String altCommand, String salesforceIDs, String outlookIDs, String inviteTypes){
        Map<String, Object> keys = new Map<String, Object>();
        String[] inviteSplit = null;
        String[] outlookIDSplit = null;
        String[] sfdcIDSplit = null;
        //System.debug(TAG + 'Invitation types - ' + inviteTypes);
        
        //Split various array inputs
        if (!String.isEmpty(inviteTypes)){
            inviteSplit = inviteTypes.split(',');
        }
        if(!String.isEmpty(outlookIDs)){
            outlookIDSplit = outlookIDs.split(',');
        }
        if(!String.isEmpty(salesforceIDs)){
            sfdcIDSplit = salesforceIDs.split(',');
        }
        
        //Default template information
        String emailTemplate = '';
        Messaging.SingleEmailMessage tempEmail = null; 
        
        //System.debug(TAG + 'Current Inputs ');
        //System.debug(TAG + inviteSplit);
        //System.debug(TAG + outlookIDSplit);
        //System.debug(TAG + sfdcIDSplit);
        
        //If sending a new/modification of an invitation
        if(altCommand == 'Modify'){
            for(Integer i = 0; i < inviteSplit.size(); i++){
                if(outlookIDSplit[i].length() > 10){
                    if(inviteSplit[i].equalsIgnoreCase('ROOM')){
                        emailTemplate += 'CEE_Room_Change';
                    } else if(inviteSplit[i].equalsIgnoreCase('PERSON')){
                        emailTemplate += 'CEE_Presenter_Invite';
                    } 
                } else {
                    if(inviteSplit[i].equalsIgnoreCase('ROOM')){
                        emailTemplate += 'CEE_Room_Invite';
                    } else if(inviteSplit[i].equalsIgnoreCase('PERSON')){
                        emailTemplate += 'CEE_Presenter_Invite';
                    } 
                }
                
                if(i != inviteSplit.size() - 1){
                    emailTemplate += ',';
                }
            }
        //If sending a cancellation email 
        } else if (altCommand == 'Cancel'){
            for(Integer i = 0; i < inviteSplit.size(); i++){
                if(inviteSplit[i].equalsIgnoreCase('ROOM')){
                    emailTemplate += 'CEE_Room_Cancellation';
                } else if(inviteSplit[i].equalsIgnoreCase('PERSON')){
                    emailTemplate += 'CEE_Presenter_Cancellation';
                } 
                
                if(i != inviteSplit.size() - 1){
                    emailTemplate += ',';
                }
            }
        } else {
            System.debug(TAG + 'addOldInvitations - unknown input command');
        }
        
        keys.put('emailTemplate', emailTemplate);
        
        //TODO - Will there be any CC's attached to these emails?
        //keys.put('emailCC', something here);
        
        return keys;
    }
    
    /*@method: Add keys required - adding Timezone information*/
    public static Map<String, Object> addPrimaryTimezone(CEE__c record){
        Map<String, Object> primaryTimezone = new Map<String, Object>();
        
        try{
            //EBC/EC use case
            if (record.Primary_FSO__c != null){
                primaryTimezone.put('searchPrimaryTimezone',record.Primary_FSO__r.Site_Time_Zone__c);
            //ITCE use case
            } else if (record.Timezone__c != null){
                primaryTimezone.put('searchPrimaryTimezone', CEE_Utility.convertUTCtoTZ(record.Timezone__c));
            //Default
            } else {
                primaryTimezone.put('searchPrimaryTimezone','America/Los_Angeles');
            }
        
        } catch (Exception e){
            System.debug(TAG + 'addPrimaryTimezone exception - ' + e.getMessage());
            System.debug(TAG + e.getStackTraceString());
            
            return null;
        }
        return primaryTimezone;
    }
    
    /*@method: Add keys required - adding Timezone formatted dates*/
    public static String getFormatDate(DateTime inputDate, String timezone){
        String currTimezone = timezone;
        if(currTimezone == null || currTimezone == ''){
            currTimezone = 'America/Los_Angeles';
        }
        
        return inputDate.format('dd-MMM-yyyy', currTimezone);
    }
    
    /*@method: Add keys required - adding Timezone formatted times*/
    public static String getFormatTime(DateTime inputDate, String timezone){
        String currTimezone = timezone;
        if(currTimezone == null || currTimezone == ''){
            currTimezone = 'America/Los_Angeles';
        }
        
        return inputDate.format('HH:mm', currTimezone);
    }
    
    /*@method: Add keys required - adding timezone formatted Briefing Dates*/
    public static Map<String, Object> addBriefingDates(CEE__c briefing, String timezone){
        Map<String, Object> agendaDates = new Map<String, Object>();
        
        agendaDates.put('startDate', getFormatDate(briefing.Start_Date_Time__c, timezone));
        agendaDates.put('endDate', getFormatDate(briefing.End_Date_Time__c, timezone));
        
        return agendaDates;
    }
    
    /*@method: Add keys required - adding timezone formatted Briefing Times*/
    public static Map<String, Object> addBriefingTimes(CEE__c briefing, String timezone){
        Map<String, Object> agendaTimes = new Map<String, Object>();
        
        agendaTimes.put('startTime', getFormatTime(briefing.Start_Date_Time__c, timezone));
        agendaTimes.put('endTime', getFormatTime(briefing.End_Date_Time__c, timezone));
        
        return agendaTimes;
        
    }
    
    /*@method: Add keys required - adding timezone formatted Agenda Item Dates*/
    public static Map<String, Object> addAgendaDates(Agenda_Item__c agenda, String timezone){
        Map<String, Object> agendaDates = new Map<String, Object>();
        String currTimezone = timezone;
        
        if(currTimezone == null || currTimezone == ''){
            currTimezone = 'America/Los_Angeles';
        }
        
        String formatDate = agenda.Start_Date_Time__c.format('dd-MMM-yyyy', currTimezone);
        agendaDates.put('startDate', formatDate);
        
        formatDate = agenda.End_Date_Time__c.format('dd-MMM-yyyy', currTimezone);
        agendaDates.put('endDate', formatDate);
        
        return agendaDates;
    }
    
    /*@method: Add keys required - adding timezone formatted Agenda Item times*/
    public static Map<String, Object> addAgendaTimes(Agenda_Item__c agenda, String timezone){
        Map<String, Object> agendaTimes = new Map<String, Object>();
        String currTimezone = timezone;
        
        if(currTimezone == null || currTimezone == ''){
            currTimezone = 'America/Los_Angeles';
        }
        
        String formatTime = agenda.Start_Date_Time__c.format('HH:mm', currTimezone);
        agendaTimes.put('startTime', formatTime);
        
        formatTime = agenda.End_Date_Time__c.format('HH:mm', currTimezone);
        agendaTimes.put('endTime', formatTime);
        
        return agendaTimes;
    }
    
    /*@method: Add keys required - adding environment/org specific constants*/
    public static Map<String, Object> addEnvironment(String host){
        Map<String, Object> env = new Map<String, Object>();
        String currEnv = null;
        if(host == Org_Constant_CS__c.getInstance('Current Instance').Production_Value__c){
            currEnv = Org_Constant_CS__c.getInstance('CEE Environment').Production_Value__c;
        } else {
            currEnv = Org_Constant_CS__c.getInstance('CEE Environment').Non_Production_Value__c;
        }
        
        env.put('searchENV', currEnv);
        return env;
    }
    
    /*@method: Check for AM permission set restrictions*/
    public static Map<String, Object> addPermissions(){
        Map<String, Object> permissionSet = new Map<String, Object>();
        try{
            List<PermissionSetAssignment> permissions = [select PermissionSetId from PermissionSetAssignment where AssigneeId =: UserInfo.getUserId() and PermissionSet.Name =: 'CEE_Scheduler_Program_Manager'];
            Profile profiles = [select Name from Profile where Id =: UserInfo.getProfileId()];
            if((permissions.size() == 0) && (!profiles.Name.equals('Cisco_ADMIN'))){
                permissionSet.put('isAM', true);
                System.debug(TAG + 'AM Persona found');
            } else {
                permissionSet.put('isAM', false);
                System.debug(TAG + 'non-AM Persona found');
            }
        } catch (Exception e){
            System.debug(TAG + 'addPermissions - Error retrieving permission set assignment');
        }
        
        return permissionSet;
    }
}