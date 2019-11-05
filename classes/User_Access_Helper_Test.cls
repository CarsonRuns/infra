@isTest
private Class User_Access_Helper_Test
{
     @isTest
     public static void testUserAccess(){


         Utilities.setskipFuture(false);
         List<Sobject> l3 = Test.loadData( User_Access_Rules__c.SobjectType, 'User_Access_Test_Static' );
         //Create User Access Request Test Cases
         
         List<User_Access_Requests__c> userreq = new List<User_Access_Requests__c>(); 
         
         User_Access_Requests__c success = new User_Access_Requests__c();
         success.Access_Level__c = 'N/A';
         success.Access_Sub_Type__c = 'N/A';
         success.Access_Type__c = 'Star Agents';
         success.Email__c = 'testc@cisco.com';
         success.First_Name__c = 'Jim';
         success.Recipient_ID__c = 'jtest';
         success.Last_Name__c = 'Tester';
         success.Recipient_Title__c = 'Tester';
         success.Requested_Territory_ID__c = 'N/A';
         success.Requester_ID__c = 'ashirley';
         success.Request_Status__c = 'Provisioning in Progress';
         success.Request_Type__c = 'Update';
         insert success;
         userreq.add(success);

         Utilities.setskipFuture(false);
         System.debug('**************** update *****************');
         User_Access_Requests__c updated = new User_Access_Requests__c();
         updated.Access_Level__c = 'World Wide (Corp Rev)';
         updated.Access_Sub_Type__c = 'N/A';
         updated.Access_Type__c = 'Read Only';
         updated.Email__c = 'testc@cisco.com';
         updated.First_Name__c = 'Jim';
         updated.Recipient_ID__c = 'jtest';
         updated.Last_Name__c = 'Tester';
         updated.Recipient_Title__c = 'Tester';
         updated.Requested_Territory_ID__c = '04T300000004I0JEAU';
         updated.Requester_ID__c = 'ashirley';
         updated.Request_Status__c = 'Provisioning in Progress';
         updated.Request_Type__c = 'new';
         insert updated;
          userreq.add(updated);
           
          user u1 = new user(firstName='Testuser',LastName ='PA Contact', USERNAME='testuser@cisco.com.sales.test',email='testuser@cisco.com.test',ALIAS='testpa',COMMUNITYNICKNAME='testpa123',ISACTIVE=True,
                            TIMEZONESIDKEY='America/Los_Angeles',LANGUAGELOCALEKEY ='en_US',THEATRE__C='APJC-APAC',PROFILEID ='00e340000015SW4',
                            LOCALESIDKEY ='en_US',EMAILENCODINGKEY='UTF-8');
                            insert u1;
         
         User_Access_Rules__c rule1 = new User_Access_Rules__c();
        rule1.ownerid = u1.id;
        rule1.Access_Level_Territory_ID__c = success.Requested_Territory_ID__c ;
        rule1.UAA_Theatre_Name__c = u1.THEATRE__C;
        rule1.Access_Level__c = 'GSP APJ';
        rule1.UAA_2nd_Lvl_Approval_User_IDs__c = u1.id;
        rule1.Access_Type__c = success.Access_Type__c ;
        rule1.Access_Sub_Type__c  = success.Access_Sub_Type__c;
        rule1.Marketing_Call_Centre__c ='Convergys Manila - Global';
        rule1.UAA_Role_ID__c = '00E30000000ngkeEAA';
        rule1.UAA_Service_Cloud_User__c = true; 
        rule1.UAA_Public_Group_IDs__c = '00G80000001mTFWEA2';
        rule1.UAA_Profile_ID__c = '00e340000015SW4';
        rule1.UAA_Permission_Sets_IDs__c ='N/A';
        rule1.UAA_Director_Approval_Required__c = true;
        rule1.UAA_Customer_Permission__c = 'N/A';
        insert rule1;

      
       
        PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.AssigneeId = u1.Id;
 

         Utilities.setskipFuture(false);
         System.debug('Approval Test Case');
         User_Access_Requests__c approval = new User_Access_Requests__c();
         approval.Access_Level__c = 'N/A';
         approval.Access_Sub_Type__c = 'Inhouse Japan';
         approval.Access_Type__c = 'NGCC Call Center Agent';
         approval.Level_1_Approver_Decision__c = 'Approved';
         approval.Level_1_Approver__c = 'Test';
         approval.Level_1_Approval_Required__c = true;
         approval.Level_2_Approval_Required__c = true;
         approval.Level_2_Approver_Decision__c = 'Pending';
         approval.Email__c = 'approval@cisco.com';
         approval.First_Name__c = 'Jim';
         approval.Recipient_ID__c = 'jtest';
         approval.Last_Name__c = 'Tester';
         approval.Recipient_Title__c = 'Tester';
         approval.Requested_Territory_ID__c = 'N/A';
         approval.Requester_ID__c = 'ashirley';
         approval.Request_Status__c = 'Level 2 Approval Pending';
         approval.Request_Type__c = 'New';
         insert approval;
         Test.StartTest();
         
        User_Access_Helper.additionalPermissions(userinfo.getUserId(), rule1.ID);
        User_Access_Helper.updatePermissions(u1.id,rule1.ID);
        User_Access_Helper.updateUserAccessRecord(success.id,'Provisioning in Progress','Notes');
        User_Access_Helper.flsGet(User.Theatre__c);
        User_Access_Helper.newUser(userreq);
         
         Test.StopTest();


     }

   
    
    
}