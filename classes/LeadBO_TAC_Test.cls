/*
	Name    		: LeadBO_TAC_Test 
	Author  		: Eric Pesch (epesch)
	Release 		: 1.0
	Functionality 	: Test methods for TAC de-duplication log
	Created			: Sep 14 2015
	
	Modification History:
	Date		Author			Change 
*/
@isTest
private class LeadBO_TAC_Test {
	private final static String TAG = '[LeadBO_TAC_Test] - ';
	private final static String INTEGRATION_NAME = 'myInteg';
	private final static String ADMIN_NAME = 'myAdmin';
	
	/*
	 * @description Test Factory for following test methods
	 */
    @testSetup static void setup(){
    	Id adminId = [Select Id from Profile Where Name = 'Cisco_ADMIN' Limit 1].Id;
    	Id integrationId = [Select Id from Profile Where Name = 'Cisco_Integration_Echo_Suppression' Limit 1].Id;

   		//Create Integration user
    	User u1 = new User(Alias = INTEGRATION_NAME, 
		    Email = INTEGRATION_NAME + '@cisco.com.test',
		    Emailencodingkey = 'UTF-8',
		    Lastname = 'Testing', 
		    Languagelocalekey = 'en_US',
		    Localesidkey = 'en_US',
		    ProfileId = integrationId,
		    Timezonesidkey = 'Europe/London',
		    Theatre__c = 'Americas-US Enterprise',
		    Username= INTEGRATION_NAME + '@cisco.com.test');
		insert u1;
		
		//Create Admin User
    	User u2 = new User(Alias = ADMIN_NAME, 
		    Email = ADMIN_NAME + '@cisco.com.test',
		    Emailencodingkey = 'UTF-8',
		    Lastname = 'Testing', 
		    Languagelocalekey = 'en_US',
		    Localesidkey = 'en_US',
		    ProfileId = adminId,
		    Timezonesidkey = 'Europe/London',
		    Theatre__c = 'Americas-US Enterprise',
		    Username= ADMIN_NAME + '@cisco.com.test',
		    Additional_User_Permissions__c = 'Enable EndUser ACCTCreation');
		insert u2;		
    }
    

	/*
	 * @description Check insert is good, do not flag as invalid duplicate Lead
	 */
    static testMethod void checkTACDuplication_test1() {
    	UtilUnitTest.loadAllStaticData();
    	DateTime currentDate, pastDateValid;
    	currentDate = DateTime.now();
    	pastDateValid = currentDate.addDays(-32);
    	Account endCustomerAccount;
    	
    	User adminUser = [select Id from User where Username =: ADMIN_NAME + '@cisco.com.test' limit 1];
    	
    	//Setup account data
    	System.runAs(adminUser){
	    	endCustomerAccount = new Account(name='Test End-User Account',CRName__c ='Test End-User Account',RECORDTYPEID='0123000000004aUAAQ',Country__c='UNITED STATES');
	    	insert endCustomerAccount;
    	}
    	
        Lead leadPast = new Lead(
        	LastName = 'tacTest1',
        	Company='tacTest1 account',
        	Email='email1@email.com',
        	Main_Technology__c='OTHER',
        	Status='1 Waiting',
        	Address_Line_1__c='address 1',
        	CustomCity__c = 'city 1',
        	CustomCountry__c = 'United States',
        	End_Customer_Account__c = endCustomerAccount.Id,
        	LeadSource = System.label.Lead_TAC_Generated_Source,
        	Source_System_Id__c = 'tac1-1',
        	Lead_Qualified_Date__c=pastDateValid);
        
        insert leadPast;
        leadPast.Lead_Qualified_Date__c = pastDateValid;
        update leadPast;
        
        test.startTest();
        Lead newLead = new Lead(
        	LastName = 'tacTest1_B',
        	Company='tacTest1 account',
        	Email='email1@email.com',
        	Main_Technology__c='OTHER',
        	Status='1 Waiting',
        	Address_Line_1__c='address 1',
        	CustomCity__c = 'city 1',
        	CustomCountry__c = 'United States',
        	End_Customer_Account__c = endCustomerAccount.Id,
        	LeadSource = System.label.Lead_TAC_Generated_Source,
        	Source_System_Id__c = 'tac1-2',
        	Lead_Qualified_Date__c = DateTime.now());
        
        insert newLead;
        test.stopTest();
        
        //Check if inserted
		System.assertNotEquals(null, newLead.Id);
		
		//Check status not set to duplicate value
		newLead = [select Id, Status from Lead where Id =: newLead.Id];      
		System.assertNotEquals(System.Label.Lead_TAC_Reject_Status, newLead.Status);  
    }
    
	/*
	 * @description Check insert is good, flag as invalid/rejected
	 */
    static testMethod void checkTACDuplication_test2() {
    	UtilUnitTest.loadAllStaticData();
    	DateTime currentDate, pastDateInvalid;
    	currentDate = DateTime.now();
    	pastDateInvalid = currentDate.addDays(-29);
    	
    	Account endCustomerAccount;
    	
    	User adminUser = [select Id from User where Username =: ADMIN_NAME + '@cisco.com.test' limit 1];
    	
    	//Setup account data
    	System.runAs(adminUser){
	    	endCustomerAccount = new Account(name='Test End-User Account',CRName__c ='Test End-User Account',RECORDTYPEID='0123000000004aUAAQ',Country__c='UNITED STATES');
	    	insert endCustomerAccount;
    	}
    	
        Lead leadPast = new Lead(
        	LastName = 'tacTest1',
        	Company='tacTest1 account',
        	Email='email1@email.com',
        	Main_Technology__c='OTHER',
        	Status='1 Waiting',
        	Address_Line_1__c='address 1',
        	CustomCity__c = 'city 1',
        	CustomCountry__c = 'United States',
        	End_Customer_Account__c = endCustomerAccount.Id,
        	LeadSource = System.label.Lead_TAC_Generated_Source,
        	Source_System_Id__c = 'tac1-1',
        	Lead_Qualified_Date__c=pastDateInvalid);
        
        insert leadPast;
        leadPast.Lead_Qualified_Date__c = pastDateInvalid;
        update leadPast;
        
        test.startTest();
        Lead newLead = new Lead(
        	LastName = 'tacTest1_B',
        	Company='tacTest1 account',
        	Email='email1@email.com',
        	Main_Technology__c='OTHER',
        	Status='1 Waiting',
        	Address_Line_1__c='address 1',
        	CustomCity__c = 'city 1',
        	CustomCountry__c = 'United States',
        	End_Customer_Account__c = endCustomerAccount.Id,
        	LeadSource = System.label.Lead_TAC_Generated_Source,
        	Source_System_Id__c = 'tac1-2',
        	Lead_Qualified_Date__c = DateTime.now());
        
        insert newLead;
        test.stopTest();
        
        //Check if inserted
		System.assertNotEquals(null, newLead.Id);
		
		//Check status not set to duplicate value
		newLead = [select Id, Status, System_Duplicate_Id__c from Lead where Id =: newLead.Id];      
		System.assertEquals(System.Label.Lead_TAC_Reject_Status, newLead.Status);      
		System.assertNotEquals(null, newLead.System_Duplicate_Id__c);    
    }
    
    /*
     * @description Check insert is good, flag as invalid/rejected
     */
    static testMethod void checkTACDuplication_test3() {
    	UtilUnitTest.loadAllStaticData();
    	DateTime currentDate, pastDateInvalid;
    	currentDate = DateTime.now();
    	pastDateInvalid = currentDate.addDays(-27);
    	
    	Account endCustomerAccount;
    	
    	User adminUser = [select Id from User where Username =: ADMIN_NAME + '@cisco.com.test' limit 1];
    	
    	//Setup account data
    	System.runAs(adminUser){
	    	endCustomerAccount = new Account(name='Test End-User Account',CRName__c ='Test End-User Account',RECORDTYPEID='0123000000004aUAAQ',Country__c='UNITED STATES');
	    	insert endCustomerAccount;
    	}
    	
        Lead leadPast = new Lead(
        	LastName = 'tacTest1',
        	Company='tacTest1 account',
        	Email='email1@email.com',
        	Main_Technology__c='OTHER',
        	Status='1 Waiting',
        	Address_Line_1__c='address 1',
        	CustomCity__c = 'city 1',
        	CustomCountry__c = 'United States',
        	End_Customer_Account__c = endCustomerAccount.Id,
        	LeadSource = System.label.Lead_TAC_Generated_Source,
        	Source_System_Id__c = 'tac1-1',
        	Lead_Qualified_Date__c=pastDateInvalid);
        
        insert leadPast;
        leadPast.Lead_Qualified_Date__c = pastDateInvalid;
        leadPast.Status='2 Accepted-Mine/Channel';
        update leadPast;
        
        Lead leadPastFetch = [select Id, Status, Email, Main_Technology__c, Lead_Qualified_Date__c from Lead where Id =: leadPast.Id];
        System.assertEquals('2 Accepted-Mine/Channel', leadPastFetch.Status);
        System.debug(TAG + leadPastFetch);
        
        test.startTest();
        Lead newLead = new Lead(
        	LastName = 'tacTest1_B',
        	Company='tacTest1 account',
        	Email='email1@email.com',
        	Main_Technology__c='OTHER',
        	Status='1 Waiting',
        	Address_Line_1__c='address 1',
        	CustomCity__c = 'city 1',
        	CustomCountry__c = 'United States',
        	End_Customer_Account__c = endCustomerAccount.Id,
        	LeadSource = System.label.Lead_TAC_Generated_Source,
        	Source_System_Id__c = 'tac1-2',
        	Lead_Qualified_Date__c = DateTime.now());
        
        insert newLead;
        test.stopTest();
        
        //Check if inserted
		System.assertNotEquals(null, newLead.Id);
		
		//Check status not set to duplicate value
		newLead = [select Id, Status, System_Duplicate_Id__c from Lead where Id =: newLead.Id];      
		System.assertEquals(System.Label.Lead_TAC_Reject_Status, newLead.Status);      
		System.assertNotEquals(null, newLead.System_Duplicate_Id__c);    
    }
    
    /*
     * @description Check if Channel Partner is cleared from System User Updated, TAC Leads
     */
    static testMethod void removeTACPartner() {
    	UtilUnitTest.loadAllStaticData();
    	DateTime currentDate, pastDateValid;
    	currentDate = DateTime.now();
    	pastDateValid = currentDate.addDays(-32);
    	
    	Account endCustomerAccount, channelAccount;
    	
    	User adminUser = [select Id from User where Username =: ADMIN_NAME + '@cisco.com.test' limit 1];
    	User integrationUser = [Select Id from User where Username =: INTEGRATION_NAME + '@cisco.com.test' limit 1];
    	//Setup account data
    	System.runAs(adminUser){
    		List<Account> insertList = new List<Account>();

    		Account parentAccount = new Account(name='Test Parent Account',RECORDTYPEID='01280000000G6tsAAC',Country__c='UNITED STATES',ownerid ='00530000000fb2q');
	    	endCustomerAccount = new Account(name='Test End-User Account',CRName__c ='Test End-User Account',RECORDTYPEID='0123000000004aUAAQ',Country__c='UNITED STATES');
	    	channelAccount = new Account(name='Test Channel Account',CRName__c ='Test Channel Account',RECORDTYPEID='0123000000004aVAAQ',Country__c='UNITED STATES');
	    	
	    	insertList.add(endCustomerAccount);
	    	insertList.add(channelAccount);
	    	insertList.add(parentAccount);
	    	insert insertList;
	    	
	        Partner_Program_Enrollment__c PPE = new Partner_Program_Enrollment__c(Name='Cisco Sales Collaboration Platform',PROGRAM_ENROLLMENT_STATUS__C='Active');
	        PPE.PARTNER_COMPANY__C = parentAccount.id;
	        insert PPE;
	    	
	    	channelAccount.ParentId = parentAccount.Id;
	    	channelAccount.IsPartner = true;
	    	update channelAccount;
    	}
    	
    	Org_Constant_CS__c newSetting = new Org_Constant_CS__c(
    		Name = 'Connection User 1 Id', 
    		Non_Production_Value__c = integrationUser.id, 
    		Production_Value__c = integrationUser.id);
    	insert newSetting; 
    	
        Lead leadPast = new Lead(
        	LastName = 'tacTest1',
        	Company='tacTest1 account',
        	Email='email1@email.com',
        	Main_Technology__c='OTHER',
        	Status='1 Waiting',
        	Address_Line_1__c='address 1',
        	CustomCity__c = 'city 1',
        	CustomCountry__c = 'United States',
        	End_Customer_Account__c = endCustomerAccount.Id,
        	LeadSource = System.label.Lead_TAC_Generated_Source,
        	Source_System_Id__c = 'tac1-1',
        	Lead_Qualified_Date__c=pastDateValid);
        
        insert leadPast;
        
        System.assertEquals(null, leadPast.Channel_Partner__c);
        
        test.startTest();
        
        System.runAs(integrationUser){        
        	System.debug(TAG + 'Channel Partner - ' + channelAccount);
        	
	        leadPast.Channel_Partner__c = channelAccount.Id;
	        leadPast.Partner_Lead_Status__c = 'Blank';
	        
	        System.debug(TAG + 'Channel Partner Lead Id - ' + leadPast.Channel_Partner__c);
	        update leadPast;
        }
        
        test.stopTest();
        
        //Check if Channel Partner was wiped correctly
        leadPast = [select Id, Channel_Partner__c from Lead where Id =: leadPast.Id ];
		System.assertEquals(null, leadPast.Channel_Partner__c);
    }
}