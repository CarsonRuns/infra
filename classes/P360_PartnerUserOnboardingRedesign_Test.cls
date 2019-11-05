//** Create or Update users for channel Contact for partner portal**/
//** Author:     Mukesh JSC Team
//** Date:       01/07/2013

@isTest(SeeAllData=true) 
public class P360_PartnerUserOnboardingRedesign_Test{
    public static testMethod void PartnerPortalUserOnboarding_v3_Test_Positive() 
    {
        Account a1 = new Account(name='Test Partner Company Account',RECORDTYPEID='01280000000G6tsAAC',Country__c='UNITED STATES');
        insert a1;
        
        List<Account> accounts = new List<Account>();     
        
        Account a21 = new Account(name='Test Channel Account',RECORDTYPEID='0123000000004aVAAQ',Country__c='UNITED STATES',ownerid ='00530000000fb2q',ParentId=a1.Id,Geographic_Region__c='APJC');
        accounts.add(a21);
        Account a22 = new Account(name='Test Channel Account',RECORDTYPEID='0123000000004aVAAQ',Country__c='UNITED STATES',ownerid ='00530000000fb2q',ParentId=a1.Id,Geographic_Region__c='EMEAR');
        accounts.add(a22);
        insert(accounts);
        System.Debug('Accounts Inserted'+accounts);
        
        Accounts[0].IsPartner=true;
        Accounts[1].IsPartner=true;
        update accounts;
        
        List<Contact> contacts = new List<contact>();
        contact c1 = new contact(firstName='Test',LastName ='PA Contact',AccountId=accounts[0].Id, RECORDTYPEID='01280000000G6tnAAC',email='testpa@test.com.test',CCO_ID__c='testpa@test.com.test',Partner_Admin_Roles__c='PARTNER_LED_APP_ADMIN',PA_Role__c='Executive',PreferredLanguage__c='English',Partner_Program_Enrollment_Updated_Date__c =System.today());
        contacts.add(c1);
        contact c11 = new contact(firstName='Test',LastName ='PSR Contact',AccountId=accounts[0].Id, RECORDTYPEID='01280000000G6tnAAC',email='testpsr@test.com.test',CCO_ID__c='testpsr@test.com.test',Partner_Admin_Roles__c='PARTNER_LED_APP_USER',PA_Role__c='User',PreferredLanguage__c='Korean',Partner_Program_Enrollment_Updated_Date__c =System.today());
        contacts.add(c11);
        
        contact c2 = new contact(firstName='Test2',LastName ='PA Contact',AccountId=accounts[1].Id, RECORDTYPEID='01280000000G6tnAAC',email='testpa2@test.com.test',CCO_ID__c='testpa2@test.com.test',Partner_Admin_Roles__c='PARTNER_LED_APP_ADMIN',PreferredLanguage__c='German',PA_Role__c='Executive',Partner_Program_Enrollment_Updated_Date__c =System.today());
        contacts.add(c2);
        contact c22 = new contact(firstName='Test2',LastName ='Normal Contact',AccountId=accounts[1].Id, RECORDTYPEID='01280000000G6tnAAC',email='testnormal2@test.com.test',CCO_ID__c='testnormal2@test.com.test',Partner_Admin_Roles__c='PARTNER_LED_APP_ADMIN',PreferredLanguage__c='Spanish',PA_Role__c='Executive',Partner_Program_Enrollment_Updated_Date__c =System.today());
        contacts.add(c22);
        
        insert(contacts);


     
        System.debug('Contacts Inserted'+contacts);


        Partner_Program_Enrollment__c PPE = new Partner_Program_Enrollment__c(Name='Cisco Sales Collaboration Platform',PROGRAM_ENROLLMENT_STATUS__C='Active');
        PPE.PARTNER_COMPANY__C = a1.id;
        insert PPE;        
        //User thisUser= GenericStaticTestData.gettestAMUserRecord(); 
        //User thisUser = [select Id,UserRoleId,Username from User where UserType='Standard' and UserRoleId != null and IsActive=True Limit 1];
        User thisUser = [Select id from user where username like 'sfdc_apex_user@cisco.com%'];
        System.debug('thisUser'+thisUser);
        System.runAs ( thisUser ) 
         {
        
        List<User> users = new List<user>();
        user u1 = new user(firstName='Test',LastName ='PA Contact', USERNAME='testpa@cisco.com.test',email='testpa@cisco.com.test',ALIAS='testpa',COMMUNITYNICKNAME='testpa',ISACTIVE=True,
                            TIMEZONESIDKEY='America/Los_Angeles',PROFILEID = '00e800000011h7J',LANGUAGELOCALEKEY ='en_US',THEATRE__C='APJC-APAC',
                            LOCALESIDKEY ='en_US',EMAILENCODINGKEY='UTF-8',ContactId=contacts[0].id);
        users.add(u1);
        System.debug('Users Inserted'+users);
        
        user u2 = new user(firstName='Test2',LastName ='PA Contact', USERNAME='testpa2@test.com.test',email='testpa2@test.com.test',ALIAS='testpa2',COMMUNITYNICKNAME='testpa2',ISACTIVE=True,
                            TIMEZONESIDKEY='America/Los_Angeles',PROFILEID = '00e800000011h7J',LANGUAGELOCALEKEY ='en_US',THEATRE__C='APJC-APAC',
                            LOCALESIDKEY ='en_US',EMAILENCODINGKEY='UTF-8',ContactId=contacts[2].id);
        users.add(u2);
        
        insert(users);
        
        
        test.startTest();
        
        
        
        contacts[0].Partner_Admin_Roles__c='PARTNER_LED_APP_ADMIN';
        contacts[0].Email=contacts[0].Email+'.com';
        
        contacts[1].Partner_Admin_Roles__c='PARTNER_LED_APP_ADMIN';
        contacts[1].CCO_ID__c=contacts[1].Email+'.com';
        
        contacts[2].Partner_Admin_Roles__c='TEST';        
        
        Update contacts;
        
        Set<String> setOfCon = new Set<String>();
        System.debug('Updated Record'+contacts);
        for(Contact c: contacts){
            setOfCon.add(c.Id);
        }

         P360_PartnerPortalUserOnboardingRedesign newPPUO=new P360_PartnerPortalUserOnboardingRedesign();
         newPPUO.setOfContact.addAll(setOfCon);
         newPPUO.runFromTest=true;
                 
         Id batchinstanceContactid;
         batchinstanceContactid = database.executeBatch(newPPUO,10);    
          
        }
    }
    
            
        
}