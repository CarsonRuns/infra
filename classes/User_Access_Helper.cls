/*
This class captures the logic for User Access Request provisioning. Requests are made through User Access Provisioning Tool
at: http://sfdcuseraccess.cloudapps.cisco.com/SFDCUserAccess/. Inactive users are reactivated and new users are created
following the rules defined in User Access Rules custom object.

#Author: Akeem Shirley
*/
public with sharing class User_Access_Helper {

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

    /*@method Main user provisioning logic. After user is created permission sets and public groups are assigned */
    public static void newUser(User_Access_Requests__c[] requests) {


       String CONTACT_GSTS_MSG = 'Provisioning Failed. Please have GSTS verify the request details map to a corresponding active Access Rule';

        User_Access_Rules__c userRule = new User_Access_Rules__c();                                       //Rule used to provision the user
          if(requests.size() == 1) 
          {  
          system.debug(requests+'requests');
           //To ensure only a single request is processed at a time
              if(requests[0].Request_Type__c == 'Update') 
              {                                                
              //Logic to handle Update Requests
                  if(requests[0].Request_Status__c == 'Submitted') return;
                  if(requests[0].Request_Status__c == 'Level 1 Approval Pending') return;
                  if(requests[0].Request_Status__c == 'Level 2 Approval Pending') return;
                  if(requests[0].Request_Status__c == 'Duplicate Request') return;
                  if(requests[0].Request_Status__c == 'Access Granted') return;
                  if(requests[0].Request_Status__c == 'Request Failed') return;
                  if(requests[0].Request_Status__c == 'Rejected') return;
                  if(requests[0].Request_Status__c == 'Cancelled') return;

                  User_Access_Requests__c updateRequest = requests[0];                                       //User access request to be provisioned
                  String accessType = updateRequest.Access_Type__c;                                          //Request access type
                  String accessSubType = updateRequest.Access_Sub_Type__c;                                   //Request access sub-type if applicable
                  String territoryID = updateRequest.Requested_Territory_ID__c;                              //Requested territory ID

                  userRule = null;
                  List<User_Access_Rules__c> rules = [SELECT Id, Access_Level__c, Access_Level_Territory_ID__c, UAA_2nd_Lvl_Approval_User_IDs__c,
                                    Access_Sub_Type__c, Access_Type__c, Marketing_Call_Centre__c, UAA_Customer_Permission__c,
                                    UAA_Director_Approval_Required__c, UAA_Permission_Sets_IDs__c, UAA_Profile_ID__c,
                                    UAA_Public_Group_IDs__c, UAA_Role_ID__c, UAA_Service_Cloud_User__c, UAA_Theatre_Name__c
                                    FROM User_Access_Rules__c
                                    WHERE Access_Type__c =:accessType AND Access_Sub_Type__c =:accessSubType AND Access_Level_Territory_ID__c =:territoryID];

                  //Check if rule is valid
                  if(!rules.isEmpty()){
                      userRule = rules[0];
                  }

                  //Requests in provisioning in progress status signify the user's access is ready to be provisioned.
                  if(requests[0].Request_Status__c == 'Provisioning in Progress' && userRule != null) {
                        User updatedUser = [SELECT Id, Alias, Email, EmailEncodingKey, LastName, FirstName, LanguageLocaleKey, LocaleSidKey, ProfileId, DefaultCurrencyIsoCode, Hierarchy_Assignment__c, TimeZoneSidKey, UserName, Theatre__c, isActive FROM User WHERE Username =:requests[0].Email__c];
                        //Oct 1st: SCAVA fix  
                        if(flsUpdateGet(User.Theatre__c)){
                        updatedUser.Theatre__c = userRule.UAA_Theatre_Name__c;
                        }
                       
                        if(userRule.Marketing_Call_Centre__c != '') {
                        //Oct 1st: SCAVA fix  
                        if(flsUpdateGet(User.Marketing_Call_Center__c)){
                              updatedUser.Marketing_Call_Center__c = userRule.Marketing_Call_Centre__c;
                              }
                          }

                          if(userRule.UAA_Service_Cloud_User__c == true) {
                          //Oct 1st: SCAVA fix  
                          if(flsUpdateGet(User.userPermissionsSupportUser)){
                              updatedUser.userPermissionsSupportUser = true;
                              }
                          }

                      //Insert the new user and assign additional permissions if successful
                      Database.SaveResult ur = Database.update(updatedUser, false);
                      if(ur.isSuccess()) {

                          Utilities.setskipFuture(true);
                          User_Access_Helper.additionalPermissions(updatedUser.Id, userRule.Id);
                          User_Access_Helper.updatePermissions(updatedUser.Id, userRule.Id);
                          requests[0].Request_Status__c = 'Access Granted';
                          requests[0].User_Created__c = true;
                          requests[0].Notes__c = 'User has been reactivated';

                      } else {
                          //Catching errors in user creation
                          for(Database.Error err : ur.getErrors()) {
                              if(err.getMessage().startsWith('Duplicate Username.')) {

                                  Utilities.setskipFuture(true);
                                  User_Access_Helper.updateUserAccessRecord(requests[0].Id,'Duplicate Request','Request is a duplicate request.');
                              } else {
                                  Utilities.setskipFuture(true);
                                  User_Access_Helper.updateUserAccessRecord(requests[0].Id,'Request Failed', 'Request failed to update the user, please ensure request maps to an active user access rule.');

                              }
                          }
                      }

                  } else if(!(requests[0].Request_Status__c == null)) {
                          System.debug('In 2'+requests[0].Request_Status__c);
                          requests[0].Request_Status__c = 'Request Failed';
                          requests[0].Notes__c = 'Request Status was null. Please ensure request maps to an active user access rule';
                  }

                  return;
              } else {
                  if(requests[0].Request_Status__c == 'Submitted') return;
                  if(requests[0].Request_Status__c == 'Level 1 Approval Pending') return;
                  if(requests[0].Request_Status__c == 'Level 2 Approval Pending') return;
                  if(requests[0].Request_Status__c == 'Duplicate Request') return;
                  if(requests[0].Request_Status__c == 'Access Granted') return;
                  if(requests[0].Request_Status__c == 'Request Failed') return;
                  if(requests[0].Request_Status__c == 'Rejected') return;
                  if(requests[0].Request_Status__c == 'Cancelled') return;

                  User_Access_Requests__c userRequest = requests[0];                                       //User access request to be provisioned
                  String accessType = userRequest.Access_Type__c;                                          //Request access type
                  String accessSubType = userRequest.Access_Sub_Type__c;                                   //Request access sub-type if applicable
                  String territoryID = userRequest.Requested_Territory_ID__c;                              //Requested territory ID

                  userRule = null;
                  List<User_Access_Rules__c> rules = [SELECT Id, Access_Level__c, Access_Level_Territory_ID__c, UAA_2nd_Lvl_Approval_User_IDs__c,
                                    Access_Sub_Type__c, Access_Type__c, Marketing_Call_Centre__c, UAA_Customer_Permission__c,
                                    UAA_Director_Approval_Required__c, UAA_Permission_Sets_IDs__c, UAA_Profile_ID__c,
                                    UAA_Public_Group_IDs__c, UAA_Role_ID__c, UAA_Service_Cloud_User__c, UAA_Theatre_Name__c
                                    FROM User_Access_Rules__c
                                    WHERE Access_Type__c =:accessType AND Access_Sub_Type__c =:accessSubType AND Access_Level_Territory_ID__c =:territoryID];

                  //Check if rule is valid
                  if(!rules.isEmpty()){
                      userRule = rules[0];
                  }

                  //Requests in provisioning in progress status signify the user's access is ready to be provisioned.
                  if(requests[0].Request_Status__c == 'Provisioning in Progress' && userRule != null) {
                            User newUser = new User();
                            //Oct 1st: SCAVA fix  
                            if(flsGet(User.Alias)){
                            newUser.Alias = userRequest.Email__c.substringBefore('@');
                            }
                             //Oct 1st: SCAVA fix  
                            if(flsGet(User.Email)){
                            newUser.Email=userRequest.Email__c;
                            }
                            //Oct 1st: SCAVA fix 
                            if(flsGet(User.EmailEncodingKey)){
                            newUser.EmailEncodingKey='UTF-8';
                            }
                            //Oct 1st: SCAVA fix 
                            if(flsGet(User.LastName)){
                            newUser.LastName=userRequest.Last_Name__c;
                            }
                            //Oct 1st: SCAVA fix 
                            if(flsGet(User.FirstName)){
                            newUser.FirstName = userRequest.First_Name__c;
                            }
                            //Oct 1st: SCAVA fix  
                            if(flsGet(User.LanguageLocaleKey)){
                            newUser.LanguageLocaleKey='en_US';
                            }
                            //Oct 1st: SCAVA fix 
                            if(flsGet(User.LocaleSidKey)){
                            newUser.LocaleSidKey='en_US';
                            }
                              
                            newUser.ProfileId = userRule.UAA_Profile_ID__c;
                            //Oct 1st: SCAVA fix  
                            if(flsGet(User.DefaultCurrencyIsoCode)){
                            newUser.DefaultCurrencyIsoCode='USD'; 
                            }
                            //Oct 1st: SCAVA fix 
                            if(flsGet(User.Hierarchy_Assignment__c)){
                            newUser.Hierarchy_Assignment__c='TH'; 
                            }
                            //Oct 1st: SCAVA fix 
                            if(flsGet(User.TimeZoneSidKey)){
                            newUser.TimeZoneSidKey='America/Los_Angeles';
                            }
                            //Oct 1st: SCAVA fix 
                            if(flsGet(User.UserName)){ 
                            newUser.UserName=userRequest.Email__c;
                            }
                            //Oct 1st: SCAVA fix  
                             if(flsGet(User.Theatre__c)){ 
                            newUser.Theatre__c=userRule.UAA_Theatre_Name__c;
                            }

                      //Insert the new user and assign additional permissions if successful
                      Database.SaveResult sr = Database.insert(newUser, false);
                      if(sr.isSuccess()) {

                          Utilities.setskipFuture(true);
                          User updateUser = new User();
                          updateUser.id = sr.getId();



                          if(userRule.Marketing_Call_Centre__c != '') {
                          //Oct 1st: SCAVA fix
                          if(flsUpdateGet(User.Marketing_Call_Center__c)){
                              updateUser.Marketing_Call_Center__c = userRule.Marketing_Call_Centre__c;
                          }
                          }
                          
                          if(userRule.UAA_Service_Cloud_User__c == true) {
                          //Oct 1st: SCAVA fix 
                          if(flsUpdateGet(User.userPermissionsSupportUser)){
                              updateUser.userPermissionsSupportUser = true;
                          }
                          }


                          update updateUser;

                         // if(!Test.isRunningTest()) {
                              User_Access_Helper.additionalPermissions(updateUser.Id, userRule.Id);
                           //Oct 1st: SCAVA fix  
                           if(flsUpdateGet(User_Access_Requests__c.Request_Status__c )){
                          requests[0].Request_Status__c = 'Access Granted';
                          }
                          //Oct 1st: SCAVA fix
                          if(flsUpdateGet(User_Access_Requests__c.User_Created__c)){  
                          requests[0].User_Created__c = true;
                          }
                           //Oct 1st: SCAVA fix
                          if(flsUpdateGet(User_Access_Requests__c.Notes__c)){  
                          requests[0].Notes__c = 'Access has been granted.';
                          }

                      } else {
                          //Catching errors in user creation
                          for(Database.Error err : sr.getErrors()) {
                              if(err.getMessage().startsWith('Duplicate Username.')) {

                                  Utilities.setskipFuture(true);
                                  User_Access_Helper.updateUserAccessRecord(requests[0].Id,'Duplicate Request','Request is a duplicate request.');
                              } else {
                                  Utilities.setskipFuture(true);
                                  User_Access_Helper.updateUserAccessRecord(requests[0].Id,'Request Failed',CONTACT_GSTS_MSG);

                              }
                          }
                      }

                  } else if(!(requests[0].Request_Status__c == null)) {
                          System.debug('In 2'+requests[0].Request_Status__c);
                          requests[0].Request_Status__c = 'Request Failed';
                          requests[0].Notes__c = 'Please contact GSTS. Request status is null.';
                  }
              }
          }
      }

      /* @method This method handles configuring additional user settings such as Permission Sets, Groups, and Role based on the User Access
      rule that was used to configure them. */
      @future
      public static void additionalPermissions(String createdUser, String appliedRule) {


          User_Access_Rules__c rule = [SELECT Id, UAA_Permission_Sets_IDs__c, UAA_Role_ID__c, UAA_Public_Group_IDs__c FROM User_Access_Rules__c WHERE Id =:appliedRule];
          User u = [SELECT Id FROM User WHERE Id =:createdUser];

          //Assign permission sets to the newly created User if specified in User Access Rule
          if(rule.UAA_Permission_Sets_IDs__c!= null) {

            String[] permSets = new List<String>();
            permSets = rule.UAA_Permission_Sets_IDs__c.split('; ', 0);

              if(permSets.size() > 0 && permSets[0] != 'N/A') {
                  List<PermissionSetAssignment> lstPermissions = new List<PermissionSetAssignment>();

                  for(String permissionSet : permSets) {
                      PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = permissionSet, AssigneeId = u.Id);
                      lstPermissions.add(psa);
                  }

                 try{
                      insert lstPermissions;
                 } catch (Exception e) {
                     //do nothing
                 }

              }
          }

          //Update Created User's Role
          if(rule.UAA_Role_ID__c != '') {

              u.UserRoleId = rule.UAA_Role_ID__c;
              try {
                update u;
              } catch (Exception e) {
                //do nothing
              }
          }

          //Assign Created User to Public Groups
          if(rule.UAA_Public_Group_IDs__c != '') {

              GroupMember gm = new GroupMember();
              GM.GroupId = rule.UAA_Public_Group_IDs__c;
              GM.UserOrGroupId = createdUser;
              try {
                insert gm;
              } catch (Exception e) {
                //do nothing
              }
          }

      }

          /* @method This method handles configuring additional user settings after a user has been updated to avoid Mixed DML Errors. */
          @future
          public static void updatePermissions(String updatedUser, String appliedRule) {
              User u = [SELECT Id, UserRoleId, ProfileId FROM User WHERE Id =:updatedUser];
              User_Access_Rules__c rule = [SELECT Id, UAA_Role_ID__c, UAA_Profile_ID__c FROM User_Access_Rules__c WHERE Id =:appliedRule];

              u.ProfileId = rule.UAA_Profile_ID__c;
              //Oct 1st: SCAVA fix
              if(flsUpdateGet(User.IsActive )){
              u.IsActive = true;
              }

              try {
                    update u;
                  } catch (Exception e) {
                    //do nothing
                }



          }

    /* @method This method handles submission of requests into Approval process for requests requiring 2nd Level Approval, based on User Access Rules. */
      public static void submitForApproval(User_Access_Requests__c  request)
      {
          if(request.Request_Status__c != 'Level 2 Approval Pending' || Utilities.getSkipFuture() || !([Select Id From ProcessInstance WHERE TargetObjectId =: request.Id AND Status = 'Pending'].isEmpty())) return;

                  String accessType = request.Access_Type__c;                                       //Request access type
                  String accessSubType = request.Access_Sub_Type__c;                                //Request access sub-type if applicable
                  String territoryID = request.Requested_Territory_ID__c;                           //Requested territory ID

                  User_Access_Rules__c userRule = null;
                  List<User_Access_Rules__c> rules = [SELECT Id, Access_Level__c, Access_Level_Territory_ID__c,
                                                       UAA_2nd_Lvl_Approval_User_IDs__c, Access_Sub_Type__c, Access_Type__c,
                                                       Marketing_Call_Centre__c, UAA_Customer_Permission__c,
                                                       UAA_Director_Approval_Required__c, UAA_Permission_Sets_IDs__c,
                                                       UAA_Profile_ID__c, UAA_Public_Group_IDs__c, UAA_Role_ID__c,
                                                       UAA_Service_Cloud_User__c, UAA_Theatre_Name__c
                                                       FROM User_Access_Rules__c
                                                       WHERE Access_Type__c =:accessType AND Access_Sub_Type__c =:accessSubType AND Access_Level_Territory_ID__c =:territoryID];
                  if(!rules.isEmpty()){
                      userRule = rules[0];
                  }

                      //List of approvers based on User Access Rule definition
                      List<Id> approverIDs = new List<Id>();
                      Set<String> approvers = new Set<String>();

                      for(String s : userRule.UAA_2nd_Lvl_Approval_User_IDs__c.split(';', 0)) {
                          approvers.add(s.trim());
                      }


                      if(approvers.size() >0) {
                          for(User u : [SELECT ID FROM User WHERE ID IN :approvers]) {
                              approverIDs.add(u.ID);
                          }
                      }

                      Utilities.setskipFuture(true);
                      //Submit request to approval process
                      Approval.ProcessSubmitRequest approve = new Approval.ProcessSubmitRequest();
                      approve.setComments('Submitting request for approval.');
                      approve.setObjectId(request.Id);
                      approve.setProcessDefinitionNameOrId('SFDC_User_Access_2nd_Level_Approval');
                      approve.setSkipEntryCriteria(true);
                      approve.setNextApproverIds(approverIDs);

                      Approval.ProcessResult result = Approval.process(approve);

      }

      /* @method This method handles updating request status when the request is a duplicate. */
      @future
      public static void updateUserAccessRecord(String requestID,String status,String notes) {

          User_Access_Requests__c request = [SELECT ID, Request_Status__c, User_Created__c FROM User_Access_Requests__c WHERE ID =: requestID];

          request.Request_Status__c = status;
          request.Notes__c = notes;
          Utilities.setskipFuture(true);
          update request;
      }
}