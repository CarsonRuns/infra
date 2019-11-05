/**
* @author Roy Jones (royjon@cisco.com) & Andrew Wolder (awolder@cisco.com) 
* @date 01/29/2016
* @description: Class controls the Spark Management Visual Force View.
* @Update 06/22/2016 
    - Add AuraEnabled to make it compatible with lightning.
    - Add Unique key to Rtrack which environment it is installed in
    - Change getParticipantList Method to include existing room members and member status.Roo
    - Added datesort key to MessageObject to reverse sort messages by epoch date number.
* @Update 07/01/2016 
    - Add delete single user method, to support leave room function in GUI
    - resolved all villiage chief feedback.
* @Update 07/08/2016 
    - Change delete room function 1. rename to closeRoom and 2. get id map instead of passing from GUI.
* @Updated 7/22/2016
     - Added isUserMember2 to global variables.
     - isUserMemberCheck method added.
     - Added 3 new methods for msg & member tracking - decrementMemberCount, incrementMemberCount, incrementConversationCount
* @Updated 7/29/2016
    - Commented incrementConversationCount
    - Added incrementMemberCount to getNewRoom
    - Added new method setSparkFiles for Files
    - Added Milliseconds to Datesort in getRoomMessages to fix sorting issue.
* @Updated 8/01/2016
    - Added uniqueLocalKey to getSparkId() method to validate room existence against the Unique Key.
    - Added sObjectType to Spark_Conversation
* @Updated 8/02/2016
    - Updated setSparkFiles for Files; But room will still make Attachment - awaiting confirmation.
* @Updated 8/03/2016
    - Enabled Notes
    - Changed the profile image source from AngularResources to SparkIntegrationFramework
* @Updated 8/05/2016
    - Added streamType check for Conversation update in getRoomMessages()
* @Updated 8/10/2016
    - Manju: Commented the fileslist from archiveConversationStream and also setRoomAttachment() * getSparkAttachment() to improve the code coverage.
  @Updated 8/25/2016
    - Normalization fix - updated the conversation sort date from Integer to Long in MessageObject
  @Updated 9/7/2016
   - Normalization fix - code review comments implemented to minimize the query of User object through getUserContactList() method.
  @Updated 9/22/2016
   - Andrew: Bug fix - removed getting file metadata in get messages function as this caused an error on large files.  
             - added a check for empty message string at line 960, before adding NewMessage object to global message object.

*/
global with sharing class Spark_Room_Controller {

   // SCAVA Helper Method to validate Create Access at field level
     public static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }
    
    // SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdateGet(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }
    
    global class ContactsAndUser {
        @AuraEnabled
        public String userName      {get; set;}
        @AuraEnabled
        public String userEmail     {get; set;}
        @AuraEnabled
        public String userId        {get; set;}
        @AuraEnabled
        public String memberId      {get; set;}
        @AuraEnabled
        public String conImage      {get; set;}
        @AuraEnabled
        public String role          {get; set;}
        @AuraEnabled
        public String title         {get; set;}
        @AuraEnabled
        public String roomMember    {get; set;}
    }
    
    global class GlobalVarsObject {
        @AuraEnabled
        public String  ctrlId           {get; set;}
        @AuraEnabled
        public String  currentObj       {get; set;}
        @AuraEnabled
        public String  machineId        {get; set;}
        @AuraEnabled
        public String  roomId           {get; set;}
        @AuraEnabled
        public String  ownerId          {get; set;}
        @AuraEnabled
        public String  activeId         {get; set;}
    }
    
    global class MessageObject {
      
        @AuraEnabled
        public String messageId      {get; set;}
        @AuraEnabled
        public Long dateSort      {get; set;}
        @AuraEnabled
        public String createdDate    {get; set;}
        @AuraEnabled
        public String msgtext        {get; set;}
        @AuraEnabled
        public String displayName    {get; set;}
        @AuraEnabled
        public String avatarUrl      {get; set;}
        @AuraEnabled
        public List<Object> filesUrl {get; set;}
    }
    
    global class JSONResponse{
        @AuraEnabled
        public integer response {get; set;}
        @AuraEnabled
        public string message  {get; set;}
    }
    @AuraEnabled
    public String  ctrlId           {get; set;}
    @AuraEnabled
    public String  currentObj       {get; set;}
    @AuraEnabled
    public String  machineId        {get; set;}
    @AuraEnabled
    public String  roomId           {get; set;}
    @AuraEnabled
    public String  ownerId          {get; set;}
    @AuraEnabled
    public String  activeId         {get; set;}
    
    /* DECLARE CLASS CONSTANTS */
    static final String SUCCESSMSG   = 'Success';
    static final String PERSONID     = 'personId';
    static final String PERSONEMAIL  = 'personEmail';
    static final String ITEMS        = 'items'; 
    static final String MAXSTR       = 'max'; 

    public Spark_Room_Controller() {

    }
    
   /* @Description: This method returns the spark room id associated with the called object.
    * @Param cid - The Controller Id
    * @Return String roomId 
    */
    @RemoteAction @AuraEnabled
    global static String getSparkId(String cid){
        String roomId = 'No Spark Room Available';
        Spark_Conversation__c spark          = new Spark_Conversation__c();        
        List<Spark_Conversation__c> roomList = new List<Spark_Conversation__c>();
        String uniqueLocalKey = UserInfo.getOrganizationId().left(15)+'_'+cid.left(15);
        roomList = [SELECT id, Spark_Id__c  from Spark_Conversation__c where Unique_Key__c = :uniqueLocalKey AND ObjectId__c like :cid + '%' limit 1 ];
        if(!roomList.isEmpty()){ spark  = roomList[0]; } 
        roomId = spark.Spark_Id__c;        
        return roomId;    
    }
    
    @AuraEnabled
    public static String getCurrentUserId() {
        return UserInfo.getUserId();
    }
    
    @AuraEnabled
    public static String getObjectOwnerId(String objId) {
        return getCurrentOwnerId(objId);
    }
    
   /* @Description: This method returns queries and returns the Spark Room Name.
    * @Param cid - The Controller Id
    * @Return String roomname 
    */
    @RemoteAction @AuraEnabled
    global Static String getRoomName(String cid){
      String roomname;
      String roomId   = getSparkId(cid);
        if (roomId != NULL){
            httpResponse rd = Spark_Room_API.getRoomDetails(roomId, 'FALSE');
            system.debug('GET ROOM NAME RESPONSE: ' +  rd);
            Map<String, Object> result  = (Map<String, Object>)JSON.deserializeUntyped( rd.getBody() );
            roomname                    = (String) result.get('title');
            system.debug('!!! result: '+result);
        }
      return roomname;  

    }
    
    /* @Description: This function returns all the global variables required for the other services
     * @Param cid - The Controller Id
     * @Return Object with all global parameters needed
    */
    @RemoteAction
    global Static List<GlobalVarsObject> getGlobalVars(String cid){
        List<GlobalVarsObject> glList = new List<GlobalVarsObject>();
        GlobalVarsObject glvr = new GlobalVarsObject();
        glvr.ctrlId      = cid;
        glvr.currentObj  = findObjectNameFromRecordIdPrefix(cid);
        glvr.machineId   = getMachineUUID();
        glvr.roomId      = getSparkId(cid);
        glvr.ownerId     = getCurrentOwnerId(cid);
        glvr.activeId    = UserInfo.getUserId();
        glList.add(glvr);
        return glList;
    }
    
   /* @Description: This function returns a list of users who are in a given room.
    * @Param cid - The Controller Id
    * @Return Boolean if the current user is a member or not. 
    */
    @RemoteAction @AuraEnabled
    global static boolean isUserMemberCheck(String cid){
        List<ContactsAndUser> cuList = getParticipantList(cid);
        Map<String, String> userMemberMap = new Map<String, String>();
        //Create a map of User ID and Member statuc
        for(ContactsAndUser cu : cuList){
            userMemberMap.put(cu.userId, cu.roomMember);
        }
        //Find the memership status for the logged-in user
        if(userMemberMap.get(UserInfo.getUserId()) == 'Yes')
        {
            return true;
        }
        return false; 

    }
    
   /* @Description: This function returns a list of users who are in a given room.
    * @Param cid - The Controller Id
    * @Return List of participants of a room 
    */
    @RemoteAction @AuraEnabled
    global Static List<Object> getRoomUsers(String cid){
      String roomId = getSparkId(cid);
      if (roomId == null)
      {
          return new List<Object>{};
      }
      system.debug('GET SPARK ID ' + roomId);
      return getRoomUserList(roomId);        
    }

   /* @Description: This method sets the moderation state on the associated spark room.
    * @Param objectId - The Object Id
    * @Param isModerator - True/False to set moderator state
    * @Return String roomname 
    */
    @RemoteAction @AuraEnabled
    global Static List<Object> getChangeModeration(String objectId, boolean isModerator){
        String sparkId = getSparkId(objectId);     
        return getRoomModeration(sparkId, isModerator);
    }   
     
    @RemoteAction @AuraEnabled
    global Static List<Object> deleteSingleUser(String sfdcId, String objId){
        /* get users email address */
        User sfuser         = getUserFromId(sfdcId);
        String userEmail    = sfuser.Email;
        /*get map of current room users */
        Map<String,Map<String,Object>> roomUsers = new Map<String,Map<String,Object>>();
        roomUsers = getRoomUsersMap(objId);
        list<string> midlist     = new list<string>{};
        for (String u : roomUsers.keySet())
        {
            if (u == userEmail){
            Map<String,Object> roomUser = roomUsers.get(u);  
               String mid = (string)roomUser.get('id');
               midlist.add(mid);
            }                         
        }
    return getDeleteUserList(midlist);        
    }
    
    
    @RemoteAction @AuraEnabled
    global Static List<JsonResponse> getDeleteUser(String membershipId, String token){
        /* Here we will make an API call to spark so that we can remove users from the Room.  */
        HTTPResponse membership = Spark_Membership_API.deleteMembership(membershipId, token);
        /*Breaking down the HTTPReponse to an object*/
        
        if (membership.getStatusCode() != 204 ){
            return apiResponse(membership.getStatusCode(),membership.getStatus());               
        } 
        return apiResponse(membership.getStatusCode(),'The User was Successfully Deleted');
                 
    }

    /* Removes all users that do not have a @cisco.com email */
    @RemoteAction @AuraEnabled
    global Static list<Object> getCloseRoom(String objId){ 
       
        String apiUserId = getMachineUUID();
        /*get map of current room users */
        Map<String,Map<String,Object>> roomUsers = new Map<String,Map<String,Object>>();
        roomUsers = getRoomUsersMap(objId);

        list<string> midlist     = new list<string>{};
        for (String u : roomUsers.keySet())
        {
            Map<String,Object> roomUser = roomUsers.get(u);  
               String mid = (string)roomUser.get('id');
               String pid = (string)roomUser.get('personId');
               if (pid != apiUserId)
               {
               midlist.add(mid);
               }                      
        }
        system.debug('GET DELETE ROOM USER LIST ' + midlist);
        /* Delete all (non-api) users from room */
        List<Object> userStatusList = getDeleteUserList(midlist);
        /* Return the Status of the deleted users */
        return userStatusList;       
    }
    
    @RemoteAction @AuraEnabled
    global Static String getResetRoom(String objId){        
        /* Remote Action wrapper to remove all messages from the current room
         * associated with the object */
        removeRoomMessages(objId);
        return SUCCESSMSG;  
    }
    
    @RemoteAction @AuraEnabled
    global Static String getArchiveRoom(String objId){         
        /* Remote Action wrapper to archive the current conversation by 
         * writing to a text file, and attaching it in the Notes & Attachments
         * section of the object */
        archiveConversationStream(objId);
        return SUCCESSMSG;  
    }
    
    @RemoteAction @AuraEnabled
    global Static map<String, Object> getSparkConversation(String cid, String msgid, String max){ 
        /* Remote Action Wrapper to get a collection or room messages */
        return getRoomMessages(cid,msgid,max, 'personLookup');
    }
    
    @RemoteAction @AuraEnabled
    global Static List<Object> getDeleteUserList(list<string> roomMembers){
        
        String token = Spark_System_Config.generateBearerToken();
        system.debug('DELETE USER BEARER TOKEN ' + token);
        Object userStatus;        
        list<Object> userStatusList = new list<Object>();
        /*Delete all human users*/
        for(String s: roomMembers){
            system.debug('ROOM MEMBER STRING ' + s);
            userStatus = getDeleteUser(s,token);
            if (userStatus != NULL){
            userStatusList.add(userStatus);
            }
        }
    return userStatusList;
    }
    
    @RemoteAction @AuraEnabled
    global static List<ContactsAndUser> getParticipantList( String objId ){ 
        
        /* Get Room Users Map */
        Map<String,Map<String,Object>> roomUsers = new Map<String,Map<String,Object>>();
        roomUsers = getRoomUsersMap(objId);
        
        String objName = findObjectNameFromRecordIdPrefix(objId.substring(0,3));
        /* Create a room using the Logged In Salesforce User */
        String userName       = UserInfo.getUserName();
             
        list<String> caseContributorsList       = new List<String>();
        list<ContactsAndUser> contactList       = new list<ContactsAndUser>();      
        Map<String,String> dupMap               = new Map<String, String>();
        Map<String,String> emailSet             = new Map<String, String>();
        MAP<String,String> contributorMap       = new MAP<String, String>();
        Set<String> sparkMailSet                = new Set<String>();
        MAP<String,User> sparkMailMap           = new MAP<String,User>();
        
        if (objName == 'Case')
        {
        
        /* Populate group selection list with Below Query */       
        Case a = [select id, CaseNumber, OwnerId, Owner.Email, Case_Contributors__c, Opportunity__r.Opportunity_Owner_AM__c,
                     Opportunity__c, Cisco_Contact__c, Triage_Engineer__r.Id,Triage_Engineer__r.Email, Triage_Engineer__r.Name,
                     Triage_Engineer__r.SmallPhotoUrl,Triage_Engineer__r.Title, ContactId from case where id = :objId];
        
           
           /* Add all the linked participants that need to be in the result list */           
           if (a.Owner.Email != null)
           {
              emailSet.put(a.Owner.Email,'Case Owner');
           } 
                  
           if (a.Cisco_Contact__c != null)
           {              
              emailSet.put(a.Cisco_Contact__c,'Internal Case Requester');              
           }               
           
           if (a.Triage_Engineer__r.Email != null)
           {              
              emailSet.put(a.Triage_Engineer__r.Email,'Case Triage Engineer');    
           }
           if (a.Case_Contributors__c != null )
           {            
              caseContributorsList    = a.Case_Contributors__c.split(',');
              caseContributorsList.sort();
              List<User> userLookup = new List<User>();
                         userLookup = [select Id, Email,Name,Title,SmallPhotoUrl from User where Email != NULL and Name in :caseContributorsList ];           
              for (User u : userLookup ) 
              {                   
                  emailSet.put(u.Email,'Case Contributor');                
              }
            }
            /* Add Case Linked Opportunity Team Members */

            list<Opportunity> oppRecord = [SELECT id, Owner.Email, Owner.Id from opportunity where Owner.Email != NULL and id=:a.Opportunity__c];
            if (!oppRecord.isEmpty())
            {
                list<OpportunityTeamMember> oppTeam = [SELECT OpportunityId,TeamMemberRole,UserId, User.Email FROM OpportunityTeamMember where User.Email != null and OpportunityId = :a.Opportunity__c];
                for (Opportunity b : oppRecord) 
                {
                   emailSet.put(b.Owner.Email,'Opportunity Owner'); 
                }
                
                for (OpportunityTeamMember t : oppTeam) 
                {
                   /* Add all the linked participants that need to be in the result list */
                   emailSet.put(t.User.Email,t.TeamMemberRole);  
                }
            }
            
        } else if (objName == 'Opportunity'){
                /* Populate group selection list with Below Query */
                list<Opportunity> oppRecord         = [select Owner.Email, Owner.id from opportunity where Owner.Email != NULL and id=: objId];
                list<OpportunityTeamMember> oppTeam = [SELECT OpportunityId,TeamMemberRole,UserId, User.Email FROM OpportunityTeamMember where User.Email != NULL and OpportunityId = :objId];
        
            for (Opportunity a : oppRecord) 
            {
                emailSet.put(a.Owner.Email,'Opportunity Owner');                
            }
            for (OpportunityTeamMember b : oppTeam) 
            {
                emailSet.put(b.User.Email,b.TeamMemberRole);  
            } 
              
            /* add here any linked case users - could be multiple */
            List<Case> caseresult = [select id, CaseNumber,Owner.Email, OwnerId, Case_Contributors__c, Opportunity__r.Opportunity_Owner_AM__c,
                     Opportunity__c, Cisco_Contact__c,Triage_Engineer__r.Id, Triage_Engineer__r.Email, Triage_Engineer__r.Name,
                     Triage_Engineer__r.SmallPhotoUrl,Triage_Engineer__r.Title, ContactId from Case where Opportunity__c = : objId ];
            
            List<String> ccList = new List<String>{};
            /* lookup case contributors and assign to contributor map to avoid putting query in loop */   
            for (Case cm : caseresult)
            {
                if (cm.Case_Contributors__c != null )
                {            
                  ccList    = cm.Case_Contributors__c.split(',');
                  ccList.sort();
                  for (String e : ccList)
                  {
                  contributorMap.put(e, cm.CaseNumber);
                  }
                }
                /* Add all the linked participants that need to be in the result list */           
                if (cm.Owner.Email != null)
                {
                    emailSet.put(cm.Owner.Email, 'Case ' + cm.CaseNumber +  ' Owner');
                }

                if (cm.Triage_Engineer__r.Email != null)
                {              
                    emailSet.put(cm.Triage_Engineer__r.Email, 'Case ' + cm.CaseNumber +  ' Triage Engineer');     
                }   
            }
            
            /* generate user email from Contributorlist lookup outside of loop */
            for (User u : [select Id, Email,Name,Title,SmallPhotoUrl from User where Email != NULL and Name in :contributorMap.keySet() ] ) 
            {                                      
                emailSet.put(u.Email, 'Case ' + contributorMap.get(u.Name) +  ' Contributor');  
            }
  
        } else {
            
              List<User> ownerInfo = new List<User>();
              ownerInfo = [select Id,Email,Name,Title,SmallPhotoUrl from User where Username = :userName limit 1];
              
              if(!ownerInfo.isEmpty())
              {
                emailSet.put(ownerInfo[0].Email, 'Logged In User');                 
              }           
        }

        List<User> usersList = getUserContactList(emailSet.keySet());
        for(User user: usersList){
            ContactsAndUser newUser = new ContactsAndUser();
            newUser.userEmail    = user.Email;
            newUser.userName     = user.Name;
            newUser.userId       = user.Id;
            newUser.conImage     = user.SmallPhotoUrl; //'http://wwwin.cisco.com/dir/photo/std/'+ result[0].Email + '.jpg';
            newUser.title        = user.Title;
            newUser.roomMember   = 'No';
            if ( roomUsers.containsKey(user.Email) )
            {
                newUser.roomMember = 'Yes';
                Map<String,Object> roomUser = roomUsers.get(user.Email);
                newUser.memberId   = (string)roomUser.get('id');
            }
            newUser.role = emailSet.get(user.Email);
            if (!dupMap.containsKey(user.Email) && newUser.userEmail != NULL)
            {
                contactList.add(newUser);
                dupMap.put(user.Email,user.Email);
            }
        }
        
        for (String su : roomUsers.keySet())
        {
            if (!dupMap.containsKey(su) && su != 'dse-sfdc-spark-integration@cisco.com' && su != 'spark-cisco-it-admin-bot@cisco.com' ) 
            {
                sparkMailSet.add(su);   
            }
        }
        
        /* generate User list map of those in spark room but not in Opp/Case team and have SFDC Acct */         
        for (User suser : [select Id,Email,Name,Title,SmallPhotoUrl from User where Email = :sparkMailSet])
        {
            sparkMailMap.put(suser.Email, suser);   
        }
        
        /* find room users who are not in the team members list */
        for (String u : roomUsers.keySet())
        {
            if (!dupMap.containsKey(u) && u != 'dse-sfdc-spark-integration@cisco.com' && u != 'spark-cisco-it-admin-bot@cisco.com' ) 
            {
                Map<String,Object> roomUser = roomUsers.get(u);               
                User userInfo               = sparkMailMap.get(u);
                        ContactsAndUser newUser = new ContactsAndUser();
                            newUser.memberId     = (string)roomUser.get('id');
                            newUser.role         = 'External Team Member';
                            newUser.roomMember   = 'Yes';
                            
                            newUser.userEmail    = u;
                            newUser.userName     = (string)roomUser.get('personDisplayName');
                            newUser.userId       = null;
                            newUser.conImage     = '/resource/SparkIntegrationFramework/angular/profile_pic.png';
                            newUser.title        = 'Spark User';
                        
                        if (userInfo != NULL)
                        {
                            newUser.userEmail    = userInfo.Email;
                            newUser.userName     = userInfo.Name;
                            newUser.userId       = userInfo.Id;
                            newUser.conImage     = userInfo.SmallPhotoUrl;
                            newUser.title        = userInfo.Title;
                        } 
                        contactList.add(newUser); 
            }
        }
    return contactList;
    }
    
   
    
    /* This section will create a new spark user in the current known room */
    @RemoteAction @AuraEnabled
    global static list<Object> setGroupUsers(String sparkId, String userIdList){            
        String objName, query;
        Boolean isEmail;
        SObject thisObj;
        Object tempJsonResponse;
        list<Object> jsonResponseList   = new list<Object>();
        list<String> uniqueUsers        = userIdList.split(',');   
        map<string, string> paramOption = new map<string, string>();
         
        /*looping through the list of user Id's we are adding to thr room*/ 
        for(string u: uniqueUsers){
             
            /*clearing paramaters at end before each new request*/
            paramOption.clear();
            /*getting the email whether the individual is a contact or user*/
            objName = findObjectNameFromRecordIdPrefix(u);
            query = 'select id, email, Name from '+objName+' where Id =: u';
            thisObj = Database.query(query);
            if(thisObj != null){
                String currEmail = String.valueOf(thisObj.get('email'));
                isEmail = currEmail.contains('@cisco.com');
                    tempJsonResponse  = apiResponse(500, (String)thisObj.get('Name')); 
                if (isEmail)
                {               
                    paramOption.put(PERSONEMAIL, String.valueOf(thisObj.get('email')));                
                    HTTPResponse membership = Spark_Membership_API.createMembership(sparkId, paramOption);
                    system.debug('STATUSCODE: ' + membership.getStatusCode() + ' GET STATUSMSG ' + membership.getStatus());             
                    tempJsonResponse  = apiResponse(membership.getStatusCode(), (String)thisObj.get('Name'));
                    
                }
                    jsonResponseList.add(tempJsonResponse);
                }               
        }    
        return jsonResponseList;  
    }
    
    /* This section will create a new spark user in the current known room */
    @RemoteAction @AuraEnabled
    global static String setSingleUserByEmail(String sparkId, String setSingleEmail){
        boolean isEmail = false;        
        isEmail = setSingleEmail.contains('@cisco.com');
        if (!isEmail)
        {
          return 'Only Cisco Employees can be added using the Salesforce Integration';   
        }
        
        List<JsonResponse> addUser = addUserToRoom(sparkId, setSingleEmail, 'FALSE');
        JsonResponse au = addUser.get(0);
        if ( au.response != 200){
               return 'The user could not be added';
        } 
        return SUCCESSMSG;
        
    }

    /* send comment to the spark Room */
    @RemoteAction @AuraEnabled
    global static list<Object> setNewComment(String sparkId, String newMsg, String userId){
        User user =  getUserFromId(userId);
        String usersName      = user.Name;
        String newMsgWithUser = '<' + usersName + '> : ' + newMsg; 
        String userEmail = user.Email;
        HttpResponse res = listMembership(sparkId, userEmail);
        Integer statusCode2 = res.getStatusCode();
        Map<String, Object> result   = (Map<String, Object>)JSON.deserializeUntyped( res.getBody() );
        List<Object> listitems       = (List<Object>) result.get(ITEMS);
        Integer size = listitems.size();
        /* statusCode2 = 200 means api call succeed, size != 0 means api finds the person in the spark room */
        if(statusCode2 == 200 && size !=0 ){
            if (sparkId == NULL){
               return apiResponse(400, 'A room needs to be created before a message can be sent.'); 
            }
            Integer statusCode = postMessage(sparkId, newMsgWithUser);
            if (statusCode == 400){
                return apiResponse(StatusCode, 'An error occurred while posting your message.');
            } 
            return apiResponse(StatusCode, 'The message was successfully created.');
            
        }
        return apiResponse(statusCode2, 'Only spark room member can post comments.');
        
    }
    
    /* @Description:  Action to Create a new room with Custom Logic for Sales Cloud */
    @RemoteAction @AuraEnabled
    global static String getNewRoom(String objType, String objId){  
       String roomId; String roomTitle;
       String userId          = UserInfo.getUserId();
       List<User> activeUser  = new List<User>();
       activeUser             = [Select Id,Email,Name From User where id = :userid limit 1];
       String activeUserEmail = activeUser[0].Email;
       String uniqueKey = UserInfo.getOrganizationId().left(15)+'_'+objId.left(15);

       /* If room management is embedded in the Case Object, then run the following set of commands */
       if (objType == 'Case')
       {
            /* Get the data about the current case record */
            Case caseList = [select id, CaseNumber, Description, Subject, Owner.Name, Owner.Email, Opportunity__c from case where id = :objId ];

                String currCaseId   = caseList.id;
                roomTitle           = 'Salesforce Case: ' + caseList.CaseNumber;
                if (caseList.Description != null){
                roomTitle += ' : ' + caseList.Subject;      
                }            
                roomId = createSparkRoom(activeUserEmail, roomTitle);
                if (roomId != NULL)
                {
                    /* create a new entry with existing case id. Opp is also linked to another case. */
                    Spark_Conversation__c sparkRecord = new Spark_Conversation__c(Spark_Id__c = roomId, ObjectId__c = currCaseId, Unique_Key__c = uniqueKey, sObject_Type__c = objType);
                    insert sparkRecord;
                } 
  
        } else if (objType == 'Opportunity') {
            
                String thisOppId;
                /* Get DealId and Owner info from Opportunity.  We need at least this info to create a room. */
                Opportunity oppList = [ SELECT Id, DealID__c, Name, Owner.Name, Owner.Email, Account.Name FROM Opportunity where id = : objId ];                            

                /* Set owner and case number info to global variables */             
                roomTitle  = 'Salesforce Opportunity: ' + oppList.Name;
                if (oppList.Account.Name != null){
                roomTitle += ' for Account: ' + oppList.Account.Name;      
                }
                if (oppList.DealID__c != null){
                roomTitle += ' with DealId: ' + oppList.DealID__c;
                }
                thisOppId = oppList.Id;
             
                roomId = createSparkRoom(activeUserEmail, roomTitle);
                if (roomId != NULL){
                /* create a new entry with existing opportunity id and new case id. Opp is also linked to another case. */
                Spark_Conversation__c sparkRecord = new Spark_Conversation__c(Spark_Id__c = roomId, ObjectId__c = thisOppId, Unique_Key__c = uniqueKey, sObject_Type__c = objType);
                insert sparkRecord;          
                }  
        } 
        
        if(roomId != null){
            incrementMemberCount(objId);
        }
        
    return roomId;
    }
    
    /* @description: This method gets the file metadata the URL provided, including 
     * the file name and type.
     * @param: String url
     * @return: List filename
     */
    @RemoteAction @AuraEnabled
    global Static List<String> getSparkFileMetadata(String url){
        HTTPResponse file  = Spark_File_API.getSparkFileDetail(url);
        system.debug('FILE RESPONSE ' + file.getHeader('Content-Disposition'));
        system.debug('FILE RESPONSE ' + file.getHeader('Content-Type'));
        String contentType = file.getHeader('Content-Type');
        String contentDisp = file.getHeader('Content-Disposition');
               contentDisp = contentDisp.replace('attachment; filename="','');
               contentDisp = contentDisp.replace('"','');
    return new String[]{contentType, contentDisp, url};
    }
    
   /* @Description: Attaches a Spark Room file to SFDC attachments section.
    * @Param String cid - The Controller Id
    * @Param String url - the files unique url
    * @Param String filename - The filename to save in SFDC
    * @Param String filetype - The files content type
    * @Return String - The calls response
    */
    /* @RemoteAction @AuraEnabled
    global Static String getSparkAttachment(String cid, String url, String fileName, String fileType){
         blob fileData = getSparkFileData(url);
         Attachment n = new Attachment(); 
         n.ParentId = cid; 
         n.Name = fileName; 
         n.Body = filedata;  
         n.contentType = fileType; 
         insert n; 
    
    return SUCCESSMSG;
    } */
    
     @RemoteAction @AuraEnabled
    global Static String setSparkFiles(String cid, string roomContent, String fileName){
         System.debug('roomContent = '+roomContent);
         blob fileData = blob.valueOf(roomContent);
         System.debug('roomContent.escapeHtml4() = '+roomContent.escapeHtml4());
         System.debug('fileData = '+fileData);
         System.debug('Calling Notes class');
         Date td = Date.today();
         ContentVersion cv = new ContentVersion();
            cv.versionData = fileData;
            cv.title = fileName;
            cv.pathOnClient ='/conversation.txt';
            // Below 2 fields are mandatory, hence setting the value.
            cv.Expiration_Date__c = String.valueOf(td+365);
            cv.Alfresco_Version__c = cid+fileName+td;
            insert cv;
            System.debug('ContentID = '+cv.id);
            
            //Get the DocumentID from ContentVersion
            ContentVersion contentV = [SELECT ContentDocumentId FROM ContentVersion where ID =: cv.id];
            ContentDocumentLink cdLink = new ContentDocumentLink();
            cdLink.ContentDocumentId = contentV.ContentDocumentId;
            cdLink.LinkedEntityId = cid;
            cdLink.ShareType = 'V';
            cdLink.Visibility = 'InternalUsers';
            insert cdLink;
            
            //Insert the file in to Opportunity/Case Feed item
             /* FeedItem fItem = new FeedItem(ParentId=cid);
             fItem.RelatedRecordId = cv.id;
             fItem.Type = 'ContentPost';
             fItem.Body = 'Spark Conversations';
            insert fItem; */
        
    return 'File Attached';
    }
    
   /* @Description: Puts the messages from the room into a text file on the object.
    * @Param String cid - The Controller Id
    * @Param String roomContent - The room messages
    * @Param String filename - The filename to save in SFDC
    * @Return String - The calls response
    */
    @RemoteAction @AuraEnabled
    global Static String setSparkContentText(String cid, string roomContent, String fileName){
         
         blob fileData = blob.valueOf(roomContent);
         
         Attachment n = new Attachment();
         //SCAVA FIX , Oct 16th 2018
         if(flsGet(Attachment.ParentId)){ 
         n.ParentId = cid;
         }
         //Oct 3rd SCAVA FIX
         if(flsGet(Attachment.Name)){
         n.Name = fileName;
         }
         //Oct 3rd SCAVA FIX
         if(flsGet(Attachment.Body)){ 
         n.Body = fileData;
         }
         //Oct 3rd SCAVA FIX
         if(flsGet(Attachment.contentType)){  
         n.contentType = 'text/plain';
         } 
         insert n; 
    
    return 'File Attached';
    }
    
    
    /* @Description: Processes the calls to moderate a room to the API User based off of the boolean value, isModerator
    * @Param String roomId - The base64 Id of the room
    * @Return Object -  the Json response Object 
    */
    @RemoteAction @AuraEnabled 
    global Static List<JsonResponse> getRoomModeration(String roomId, boolean isModerator){
        String membershipId;
        
        /* First we need to get the Membership Id so that we can update it.  Requires roomId and PERSONID*/
        /* adding PERSONID to the parameters */
        map<String,String> paramOptions = new map<string,string>();
        paramOptions.put(PERSONID, getMachineUUID());    
        HTTPResponse membership = Spark_Membership_API.listMembership(roomId, paramOptions);
        if (membership.getStatusCode() != 200){
          return apiResponse(membership.getStatusCode(),'The account to be locked could not be found');
        } 
        
        /*Breaking down the HTTPReponse to an object*/
        map<String, Object> result = (map<String, Object>)JSON.deserializeUntyped(membership.getBody());
        list<Object> listitems         = (list<Object>) result.get(ITEMS);        
        /* Parse and Extract Membership Id from JSON response */
        for (Object i : listitems) {
            map<String, Object> s = (map<String, Object>) i;    
            if(s.get(PERSONID) == getMachineUUID()){
                Object mid = s.get('id');
                membershipId = (String) mid;
            }
        }
        
        /* Now we are updating the room based off of the membershipId and the boolean value that was passed */
        HTTPResponse membership1 = Spark_Membership_API.updateMembership(membershipId, isModerator);
        /* Breaking down the HTTPReponse to an object */          
            
        if(membership1.getStatusCode() != 200 ){
            return apiResponse(membership1.getStatusCode(),'The room moderation status could not be changed.');                
        }
            
        string roomStatus;
            roomStatus = 'Unlocked';
            if(isModerator){
                roomStatus = 'Locked';
            }
            return apiResponse(membership1.getStatusCode(),'The Room was successfully ' + roomStatus+ '.'); 
    }

    global static map<String, Object> getRoomMessages(String cid, String msgid, String max, String streamType){ 
        
        String accessToken = Spark_System_Config.getBearerToken();
        
        /* setup maps, sets, and lists */
        list<MessageObject> message     = new list<MessageObject>();
        list<String>        params      = new list<String>();
        MessageObject       newMessage  = new MessageObject();        
        String              sparkId     = getSparkId(cid);
        Map<String,String>  optionMap   = new Map<String,String>{};
        Set<String>         memberMail  = new Set<String>();
        
        if (msgid != null){
            optionMap.put('beforeMessage',msgid);
        }
        if (max != null){
            optionMap.put(MAXSTR,max);
        }

        /* Get Room Participants in order to create a map of person id to person display name
         * to reduce callouts within this function */
        Map<String,String> pOptions = New Map<String,String>{};
        Map<String,Object> pDetail  = New Map<String,Object>{};
        /* TODO: If there are more than 50 room members, we will need to loop through iterations of 50 users. */
        HTTPResponse pResultResponse =  Spark_Membership_API.listMembership(sparkId,pOptions);
        Map<String, Object> pResult  = (Map<String, Object>)JSON.deserializeUntyped( pResultResponse.getBody() );
        List<Object> pItems          = (List<Object>) pResult.get(ITEMS);
        
        for (Object k : pItems)
        {
            map<String, Object> ok = (map<String, Object>) k;
            memberMail.add((string)ok.get(PERSONEMAIL));  
        }
        
        Map<String, User> internalUserList = new Map<String,User>();        
        for(User iu:[select Id,Email,Name,Title,SmallPhotoUrl from User where Email in :memberMail ])
        {
            internalUserList.put(iu.Email,iu);
        }
        system.debug('INTERNAL USER LIST ' + internalUserList);
        
        for (Object p : pItems) 
        {
            map<String, Object> op = (map<String, Object>) p;
            /* create new ContactsAndUser object to store person details */
            ContactsAndUser getContact = new ContactsAndUser();
            /* assign room participant to ContactsAndUser Object */
            getContact.userName     = (string)op.get('personDisplayName');
            getContact.userEmail    = (string)op.get(PERSONEMAIL);
            getContact.userId       = (string)op.get(PERSONID);
            User intUser            = internalUserList.get((string)op.get(PERSONEMAIL));
            getContact.conImage     = '/resource/SparkIntegrationFramework/angular/profile_pic.png';
            if (intUser != null)
            {
                getContact.conImage     = intUser.SmallPhotoUrl;
            } 
            pDetail.put((string)op.get(PERSONID),getContact); 
        }
   
        HTTPResponse messageres      = Spark_Message_API.listMessages(sparkId, optionMap, accessToken);
       
        Map<String, Object> result   = (Map<String, Object>)JSON.deserializeUntyped( messageres.getBody() );
        List<Object> listitems           = (List<Object>) result.get(ITEMS);
        for (Object item : listitems) {
           Map<String, Object> m    = (Map<String, Object>) item;           
           
            String createdDt = (string) m.get('created');  
            Integer yr = Integer.valueOf(createdDt.substring(0,4));
            Integer mo = Integer.valueOf(createdDt.substring(5,7));
            Integer dy = Integer.valueOf(createdDt.substring(8,10));
            
            Integer hr = Integer.valueOf(createdDt.substring(11,13));
            Integer mi = Integer.valueOf(createdDt.substring(14,16));
            Integer se = Integer.valueOf(createdDt.substring(17,19));
            Integer ms = Integer.valueOf(createdDt.substring(20,22));
            
            Date    dp = Date.newInstance(yr,mo,dy);
            
            DateTime msgCreatedDt        = DateTime.newInstance(dp,Time.newInstance(hr,mi,se,ms));
            Datetime localmsgCreatedDt   = getLocalDateTime(msgCreatedDt);
 
            Long l                       = msgCreatedDt.getTime();
            
            system.debug('LONG DATE FORMAT ' + l);            
            
            String sdate  = String.valueOf(dp);
            system.debug('RAW API MSG DATE ' + sdate);
            
            Date mc             = date.today();
            Date myCurrDt       = date.newinstance(mc.year(), mc.month(), mc.day());
            String ndate        = String.valueOf(myCurrDt);
            
            system.debug('RAW API NOW DATE ' + ndate);

            newMessage = new MessageObject();
            newMessage.messageId     = (string) m.get('id');
            newMessage.dateSort      =  l;
            newMessage.createdDate   = localmsgCreatedDt.format(); //(String) msgCreatedDt.format();
            newMessage.msgtext       = (String) m.get('text');
            if (sdate == ndate){
                newMessage.createdDate = 'Today ' + localmsgCreatedDt.format('HH:mm'); 
            }
            /* Removing until Spark API File handling becomes more mature
             * and can support file metadata calls
            List<Object> files       = new List<Object>();
            if (m.get('files') != NULL && streamType != 'remove')
            {
                for (Object i : (List<Object>) m.get('files')) {
                     String url     = (String) i;
                     List<Object> fd = getSparkFileMetadata(url);
                     files.add(fd);
                }
           }
           newMessage.filesUrl     = files;
           */
           ContactsAndUser c = (ContactsAndUser)pDetail.get((String) m.get(PERSONID));
           
            if (streamType == 'personLookup' && pDetail.get((String) m.get(PERSONID)) != NULL)
           {           
                newMessage.displayName  = c.userName;
                newMessage.avatarUrl    = c.conImage;
           } else if (streamType != 'remove') {
                String pid                  = (String) m.get(PERSONID);                
                HTTPResponse pr             = Spark_People_API.getPersonDetails(pid,accessToken);
                Map<String, Object> pd      = (Map<String, Object>)JSON.deserializeUntyped( pr.getBody() );
                    newMessage.displayName  = (String) pd.get('displayName');
                    newMessage.avatarUrl    = (String) pd.get('avatar');
           }
           /* check and don't send empty message strings */
           if ((String) m.get('text') != null)
           message.add(newMessage);
        }
        //Update the Conversaiton object with the new message count.
        /* if (streamType != 'remove') { 
              ID objectId = cid;
              List<Spark_Conversation__c> spCList = [Select ID, ObjectId__c, Message_Count__c from Spark_Conversation__c where ObjectId__c =: objectId];
                if(!spCList.isEmpty()){
                    Spark_Conversation__c spConv = spCList[0];
                    spConv.Message_Count__c = message.size();
                    update spConv;
                }
          } */
          
        if (messageres.getHeader('Link') != null){
        String linkurl      = messageres.getHeader('Link');
        String link         = linkurl.split('\\?')[1];        
        String pd           = link.split('\\>')[0];
        params              = pd.split('\\&');
        }
        return new Map<String,Object>{'conversation' => message, 'pagelink' => params };
    }
    
   /* @@@@Section Description: The following methods are future methods, which will be 
    * executed when salesforce has the capacity to so.  
    */
  

   /* @Description: This is a wrapper function, to post a new message to a room.
    * This is needed needed to add a message from the Spark Opportunity/Case Triggers class. 
    * @Param String sparkId - the base64 room Id
    * @Param String comment - the comment to be added into the room
    * @Return void
    */
    @future(callout=true)
    public static void setRoomMessage(String sparkId,String comment)
    {
       postMessage(sparkId,comment);
    }
    
   /* @Description: This is a wrapper function, to attach a file to an object
    * @Return void
    */
    /* @future(callout=true)
    public static void setRoomAttachment(String cid, String url, String fileName, String fileType)
    {
        getSparkAttachment(cid, url,fileName,fileType);
    } */

    
   /* @@@@Section Description: The following methods are not directly called from Visual Force
    * but are used as helper methods, to be used within other methods in this class. 
    */ 
    
   /* @Description: This method returns the room membership details of a given user by email. 
    * @Param String sparkId   - the base64 room Id
    * @Param String userEmail - the user email to lookup
    * @Return Object - the API response
    */
    public static HttpResponse listMembership(String sparkId,String userEmail){
        
        Map<String,String> options = New Map<String,String>{};
            options.put(PERSONEMAIL, userEmail);
        return Spark_Membership_API.listMembership(sparkId,options);         
    }   

   /* @Description: This method allows a user to post a new comment to a Spark Room. 
    * @Param String sparkId - the base64 room Id
    * @Param String comment - the message to be added
    * @Return Integer - the Status code
    */
    public static Integer postMessage(String sparkId,String comment){
        
        Map<String,String> options = New Map<String,String>{};
            options.put('roomId', sparkId);
            options.put('text', comment);
        HTTPResponse result =  Spark_Message_API.createMessage(options);
        return result.getStatusCode();          
    }
    
    
   /* @Description: gets a file response in blob format which can be compiled into a real file
    * @Param url - the Files URL
    * @Return blob - the binary file data
    */
    public static blob getSparkFileData(String url)
    {
        HTTPResponse file  = Spark_File_API.getSparkFileDetail(url);
        return file.getBodyAsBlob();
    }
    
   /* @Description: gets a list of participants in a room based on the Spark Id
    * @Param String sparkId - the room Id
    * @Return list - a list of objects containing user data
    * TODO: in case there are more than 200 users, we need to iterate through and create a map of users
    */
    public static List<Object> getRoomUserList(String sparkId){ 
        Map<String,String> options = New Map<String,String>{};
            options.put(MAXSTR, '200');

        HTTPResponse mr            = Spark_Membership_API.listMembership(sparkId, options);
        if (mr.getStatusCode() != 200)
        {
            return apiResponse(mr.getStatusCode(),'There was an error loading the roster');
        }
        Map<String, Object> result = (Map<String, Object>)JSON.deserializeUntyped( mr.getBody() );
        return  (List<Object>) result.get(ITEMS);
    }
    @RemoteAction @AuraEnabled
    global Static Map<String,Map<String,Object>>  getRoomUsersMap(String cid){
      List<Object> roomUsersList = getRoomUsers(cid);  
      system.debug('ROOM USERS LIST ' + roomUsersList);
      Map<String,Map<String,Object>> userMap = new Map<String,Map<String,Object>>();
      
      for (Object u : roomUsersList) {
           Map<String, Object> m  = (Map<String, Object>) u;   
           userMap.put((String)m.get(PERSONEMAIL), m);
      }
      
    return userMap;
    }
   /* @Description: This method allows a user to be added to a Spark Room.
    * @Param String sparkId - the base64 encoded room id
    * @Param String email - the email address of the user being added.
    * @Param String moderator - True/False if the user is a room moderator
    * @Return String Success/Failure message
    */    
    public static List<JsonResponse> addUserToRoom(String sparkId, String email, String moderator){  
        HTTPResponse addUser = Spark_Membership_API.createMembership(sparkId, new Map<String,String>{PERSONEMAIL => email, 'isModerator' => moderator }); 
        if (addUser.getStatusCode() != 200){
          return apiResponse(addUser.getStatusCode(),'The user could not be added to the room');
        }
        return apiResponse(addUser.getStatusCode(),'The user was successfully added to the room');
    } 
    
   /* @Description:  This method created a new Spark Room, and sets the API user as the room moderator.  
    * @Param String creatorEmail - the default room user.
    * @param String title - the name of the room
    * @Return String The newly created base64 spark id (This should be saved in your app)
    */
    public static String createSparkRoom(string creatorEmail, String title )
    {
        String newSparkId;
        /* getting the body so we can find the Spark Id */
        HTTPResponse rr = Spark_Room_API.createRoom(title);
        if (rr.getStatusCode() == 200){
        Map<String, Object> result = (Map<String, Object>)JSON.deserializeUntyped(rr.getBody());
        /* getting the Id only from the string so that we can update the room later */
        newSparkId = (String)result.get('id');
        /* Lock the room to the API User */
            if (newSparkId != NULL){
            getRoomModeration(newSparkId, TRUE);
            /* Add room creator to the room */
            addUserToRoom(newSparkId, creatorEmail, 'FALSE');
            }
        }
    return newSparkId;    
    } 

   
    
   /* @Description - This is used for debugging only, and outputs how close the script is to reaching the salesforce limiters.
    * @Return log entries
    */
    public static void limiters()
    {
        System.debug('1.Number of Queries used in this apex code so far: ' + Limits.getQueries());
        System.debug('2.Number of rows queried in this apex code so far: ' + Limits.getDmlRows());
        System.debug('3. Number of script statements used so far : ' +  Limits.getDmlStatements());    
        System.debug('4.Number of Queries used in this apex code so far: ' + Limits.getQueries());
        System.debug('5.Number of rows queried in this apex code so far: ' + Limits.getDmlRows());   
    }
   /* @Description: generates a JSON Response wrapper to send back status to the VFP Page
    * @Param Integer code   - The Status Response Code
    * @Param String message - The response message
    * @Return Object -  the Json response Object 
    */
    public Static List<JsonResponse> apiResponse(Integer code, String message)
    {
      List<JsonResponse> response  = New List<JsonResponse>();
      JsonResponse newresponse     = new JsonResponse();
      newresponse.response         = code;
      newresponse.message          = message;
      response.add(newresponse);
      return response;      
    }
    
   /* @@@@Section Description: The following methods are are private helper methods which are
    * not referenced from any other class. 
    */
    
     
   /* @Description: Cycles through room messages and creates apex batches which deletes them 1 by 1 
    * @Param: String objId
    * @Return: Void
    */
    private static void removeRoomMessages(String objId){
        String msgid         = null;
        String max           = '60';
        String token         = Spark_System_Config.getBearerToken();     
        Integer pagesize     = 0;
        list<String> midlist = new list<String>();

        /* TODO:  limit of 100 callouts - 90 messages x 100 = 9000 messages. what if room is more than 9000 messages ? */
        do {
            map<String,Object>  conversation     = getRoomMessages(objId, msgid, max, 'remove');
            list<MessageObject> roomMessages = (list<MessageObject>)conversation.get('conversation');
            list<String> pagelink            = (list<String>)conversation.get('pagelink');
                if (!pagelink.isEmpty()){
                    for (String l : pagelink)
                    {
                        if (l.contains(MAXSTR)){
                            max = l.replace('max=','');
                        }
                        if (l.contains('beforeMessage')){
                            msgid = l.replace('beforeMessage=','');
                        }
                    }
                }
                pagesize = pagelink.size();
                
                for(MessageObject m: roomMessages)
                {
                  midlist.add(m.messageId);  
                }
                
        } while (pagesize > 0);
        Spark_MessageDelete_Batch r = new Spark_MessageDelete_Batch();
        r.setToken(token);
        r.setMsgIdList(midlist);
        database.executebatch(r,integer.valueOf(max));
    }
    
    
   /* @Description: Archive Messages and Attachments 
    * @Param: objId - The current Objects Unique Id
    * @Return: String
    */
    public static String archiveConversationStream(String objId){
        string fileName, fileType, fileUrl, blobTitle, blobContent;
        String msgid    = null;
        String max      = '50';        
        String roomName = getRoomName(objId);

        blobTitle = 'Spark_Room_' + roomName + '_Content';
        blobContent = 'Content for Spark Room ' + roomName + '\n\n'; 
        Integer pagesize = 0;
        // list<object> fileslist = new list<object>();
        do {
            map<String,Object>  conversation = getRoomMessages(objId, msgid, max, 'personLookup');
            list<MessageObject> roomMessages = (list<MessageObject>)conversation.get('conversation');            
            list<String> pagelink            = (list<String>)conversation.get('pagelink');
                if (!pagelink.isEmpty()){
                    for (String l : pagelink)
                    {
                        if (l.contains(MAXSTR)){
                            max = l.replace('max=','');
                        }
                        if (l.contains('beforeMessage')){
                            msgid = l.replace('beforeMessage=','');
                        }
                    }
                }
                pagesize = pagelink.size();
                
                for(MessageObject m: roomMessages)
                {
                    /*
                    if(!m.filesUrl.isEmpty())
                    {
                      ***do not include files in this release due to 
                           apex file size limitations***
                           fileslist.add(m.filesUrl);                   
                    } 
                    */
                    if ( m.msgtext != null) {
                        blobContent += m.createdDate + ' ' + m.displayName + ': ' + m.msgtext + '\r\n';
                    }
                }
        } while (pagesize > 0);
     
        //setSparkContentText(objId, blobContent, blobTitle);
        setSparkFiles(objId, blobContent, blobTitle);
        /* for (object f : fileslist)
        {
            fileUrl = string.valueOf(f);   
            fileUrl = fileUrl.remove('(');
            fileUrl = fileUrl.remove(')');
            list<String> fileObject = fileUrl.split(',');
            fileUrl  = fileObject[2].removeStart(' ');
            fileName = fileObject[1].removeStart(' ');
            fileType = fileObject[0].removeStart(' ');
            setRoomAttachment(objId, fileURL, fileName, fileType);
        } */
      
    return SUCCESSMSG;   
    }
    
    /* @Description - Gets the current objects Owner Id
     * @Param String objId   - The current Object Id
     * @Param String ObjType - The current Object Type i.e. Case, Opportunity, Lead
     * @Return String - the Owner User Id
     */
    public Static String getCurrentOwnerId(String objId){
        String objType = findObjectNameFromRecordIdPrefix(objId);
        List<sObject> objRecord = new List<sObject>();         
        sObject objResult; String ownerId;
        if (objType == 'Opportunity'){           
            objRecord = [SELECT Id,OwnerId, Opportunity_Owner_AM__c FROM Opportunity where id = :objId limit 1];   
        } else if (objType == 'Case'){ 
            objRecord = [select Id,OwnerId from Case where id = :objId limit 1];
        }
        if (!objRecord.isEmpty()){
            objResult = objRecord[0];
            ownerId = (String)objResult.get('OwnerId');
        }
       
        return ownerId; 
    }
    
   /* @Description   - Gets the current API User UUID, to exclude API from room actions
    * @Return String - the Base 64 Machine Account Id
    */
    private static String getMachineUUID()
    {
        return [SELECT MachineUid__c FROM Spark_Config__c limit 1].MachineUid__c;
    }
    
    private static User getUserFromId(String userid)
    {
        return [select Id,Email,Name,Title,SmallPhotoUrl from User where Id = :userid limit 1];
    }
    
    /* @Description: get the name of an object given either the full Record Id, 
    * or the first 3 characters of the Record Id (the prefix) 
    * @Param String recordIdOrPrefix - at least 3 characters of the object Id
    * @Return String name of the object (case,opportunity,account)   
    */
    private static String findObjectNameFromRecordIdPrefix(String recordIdOrPrefix){
        system.debug('MY RECORD ID OR PREFIX ' + recordIdOrPrefix );
        String objectName = '';
        try{
            /* Get prefix from record ID
             * This assumes that you have passed at least 3 characters */
            String myIdPrefix = String.valueOf(recordIdOrPrefix).substring(0,3);
             
            /* Get schema information */
            map<String, Schema.SObjectType> gd =  Schema.getGlobalDescribe(); 
             
            /* Loop through all the sObject types returned by Schema */
            for(Schema.SObjectType stype : gd.values()){
                Schema.DescribeSObjectResult r = stype.getDescribe();
                String prefix = r.getKeyPrefix();
                 
                /* Check if the prefix matches with requested prefix */
                if(prefix!=null && prefix.equals(myIdPrefix)){
                    objectName = r.getName();
                    System.debug('Object Name! ' + objectName);
                    break;
                }
            }
        }catch(Exception e){
            System.debug('OOPS: ID LOOKUP ERROR ' + e);
        }
        return objectName;
    }
    
    private static Datetime getLocalDateTime(Datetime z)
    {    
        Datetime l = z.Date();
        l = l.addHours(z.hour());
        l = l.addMinutes(z.minute());
        l = l.addSeconds(z.second());
        
        return l;
    }
    
    @RemoteAction @AuraEnabled
    global static boolean incrementConversationCount(String cid){
        //Convert to 18digit
        ID objectId = cid;
        String uniqueKey = UserInfo.getOrganizationId().left(15)+'_'+String.valueOf(objectId).left(15);
        List<Spark_Conversation__c> spCList = [Select ID, ObjectId__c, Message_Count__c from Spark_Conversation__c where ObjectId__c =: objectId AND Unique_Key__c =: uniqueKey];
        System.debug('incrementConversationCount = '+spCList.size());
        if(!spCList.isEmpty()){
                Spark_Conversation__c spConv = spCList[0];
                spConv.Message_Count__c = spConv.Message_Count__c + 1;
                update spConv;
            }
            return true;
        }
    
    @RemoteAction @AuraEnabled
    global static boolean incrementMemberCount(String cid){
        //Convert to 18digit
         ID objectId = cid;
        List<Spark_Conversation__c> spCList = [Select ID, ObjectId__c, Member_Count__c from Spark_Conversation__c where ObjectId__c =: objectId];
        System.debug('incrementMemberCount = '+cid+'===='+spCList.size());
        if(!spCList.isEmpty()){
                Spark_Conversation__c spConv = spCList[0];
                spConv.Member_Count__c = spConv.Member_Count__c + 1;
                update spConv;
            }
            return true;
        }
    
    @RemoteAction @AuraEnabled
    global static boolean decrementMemberCount(String cid){
        //Convert to 18digit
         ID objectId = cid;
        List<Spark_Conversation__c> spCList = [Select ID, ObjectId__c, Member_Count__c from Spark_Conversation__c where ObjectId__c =: objectId ];
        System.debug('decrementMemberCount = '+cid+'===='+spCList.size());
        if(!spCList.isEmpty()){
                Spark_Conversation__c spConv = spCList[0];
                spConv.Member_Count__c = spConv.Member_Count__c - 1;
                update spConv;
            }
            return true;
        }

    private static List<User> getUserContactList(Set<String> userEmails){

        List<User> result = [select Id,Email,Name,Title,SmallPhotoUrl from User where Email in :userEmails];
        return result;
    }
   
}