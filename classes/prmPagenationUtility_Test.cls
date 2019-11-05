@isTest(SeeAllData = false)
private class prmPagenationUtility_Test {
    
    static testMethod void testforLeads() {
        
        String timestamp = String.valueOf(Datetime.now().getTime());
        UtilUnitTest.loadAllStaticData();
        // Get PA record
        user pauser1 = GenericStaticTestData.gettestPAUserRecord();
        string roleName = pauser1.UserRole.name;
        //System.assertEquals('Partner Executive',roleName);
       // System.assertEquals(1,[select COUNT() from userrole where portalaccountid =:GenericStaticTestData.gettestChannelAccountRecord1().id and Name like '%Partner Executive' limit 1]);
        //System.assert(roleName.endsWith('Partner Executive'));
        
        user psruser1 = GenericStaticTestData.gettestPSRUserRecord();
        
        //System.assertEquals(1, [SELECT COUNT() FROM USER WHERE username = 'testpa@cisco.com.sales.test']);
                // Create Account
        Account eca =new Account();
        eca = GenericStaticTestData.getTestEndUserAccountRecordRed();
        
        // Create Lead
        Lead leadRec = GenericStaticTestData.gettesteLeadRecord();
        leadRec.Partner_Lead_Status__c = 'Partner Assigned';
        update leadRec;
        
        // Create TP recrod
        //Assigned_Partner__c tp = GenericStaticTestData.gettestTargetProspectRecord();
        //System.runAs(pauser1) {
        	Test.startTest();	      	          	          
	        String q_select =  ' Id, Name, Company,End_Customer_Account__c, Account_Name_English__c, Lead_From_Distributor_BE_GEO_ID_PDB__c,';
			q_select += ' toLabel(Partner_Lead_Status__c), toLabel(SCP_Partner_Lead_Status__c),Cisco_Rec_PSR__c, PSR_1__c, Partner_Assigned_Date__c,';
			q_select += ' Main_Technology__c, QABudget__c, ProgramEvent__c,ProductAmount__c ,ServicesAmount__c, Distributor_Name__c, ';
			q_select += ' Address_Line_1__c, CustomCity__c, CustomState__c, CustomZip__c, Country, toLabel(CustomCountry__c), Lead_Distributor_Name__c ,';
			q_select += ' Address_Line_1_English__c, City_English__c, State_Province_English__c, Partner_Lead_Id__c, Channel_Partner_Name__c, Zip_Postal_Code_English__c, toLabel(Country_English__c) , ';
			q_select += ' Program_Event_Name__c, toLabel(Lead_Category__c), toLabel(LeadSource), toLabel(Industry), Date_Added__c, Lead_Qualified_Date__c, Deal_ID__c ';   
	        prmPagenationUtility pg1 = new prmPagenationUtility('Select '+q_select+' From Lead ', 10);
	        pg1.pg_PageSize = 10;
	        pg1.getLeadPageRecords();
	        pg1.clearPageRecords();
	        Test.stopTest();
        //}
    }
    static testMethod void testforTP() {
    	 String timestamp = String.valueOf(Datetime.now().getTime());
        UtilUnitTest.loadAllStaticData();
        
        // Get PA record
        
        user pauser1 = GenericStaticTestData.gettestPAUserRecord();
        string roleName = pauser1.UserRole.name;
        //System.assertEquals('Partner Executive',roleName);
       // System.assertEquals(1,[select COUNT() from userrole where portalaccountid =:GenericStaticTestData.gettestChannelAccountRecord1().id and Name like '%Partner Executive' limit 1]);
        //System.assert(roleName.endsWith('Partner Executive'));
        
        user psruser1 = GenericStaticTestData.gettestPSRUserRecord();
        
        //System.assertEquals(1, [SELECT COUNT() FROM USER WHERE username = 'testpa@cisco.com.sales.test']);
        

        // Create Account
        Account eca =new Account();
        eca = GenericStaticTestData.getTestEndUserAccountRecordRed();
        
        // Create Lead
        //Lead leadRec = GenericStaticTestData.gettesteLeadRecord();
        
        // Create TP recrod
        Assigned_Partner__c tp = GenericStaticTestData.gettestTargetProspectRecord();
        tp.Assigned_Partner__c = pauser1.Contact.AccountId;
        tp.Partner_Status__c = 'Partner Assigned';
       // System.runAs(pauser1) {
        	Test.startTest();
        	String q_select = ' SELECT Customer_Account__r.CRName__c,Customer_Account__r.CRCity__c, Customer_Account__r.CRAddressLine1__c,Customer_Account__r.CRState__c,';
	        q_select += ' Customer_Account__r.CRCountry__c, Customer_Account__r.AddressLine1__c, Customer_Account__r.City__c, Customer_Account__r.State__c,';
	        q_select += ' Customer_Account__r.Name, Customer_Account__r.Incumbent_Partner_Status__c, Customer_Account__r.flags__c, toLabel(Customer_Account__r.Country__c), ';
	        q_select += ' toLabel(Customer_Account__r.Industry),Industry__c ,name,Expiration_Date__c ,Customer_Account__r.Owner.Name, Prospect_Age__c ,';
	        q_select += ' toLabel(Target_Architecture__c),Assigned_Partner_Sales_Rep__c ,Target_Description__c, Partner_Assigned_Date__c,toLabel( partner_status__c),'; 
	        q_select += ' Customer_Account__r.id,Customer_Account_Name__c, Customer_Account__r.CRZipPostalCode__c, Customer_Account__r.ownerid, id,Date_Added__c,'; 
	        q_select += ' TBM_TAM_Name__c,Customer_Account__r.Incumbent_Partner_Status_Image__c,Partner_Added_Date_Time__c, Marketing_Play_Name__c,Cisco_Recomended_Partner_Sales_Rep__c ';
	        
	        String q1 = q_select + ' FRoM Assigned_Partner__c LIMIT 1 OFFSET 0';
	        String q2  = q_select + ' FROM Assigned_Partner__c LIMIT 1 OFFSET 1';
	        
	        prmPagenationUtility pg1 = new prmPagenationUtility(q1,q2,10);
	        pg1.isUnCoveredView = false;
	        pg1.getTPPageRecords();
	        pg1.clearPageRecords();
        	Test.stopTest();
        
      //  }
    }
    
    static testMethod void testForTPUncovered() {
    	 String timestamp = String.valueOf(Datetime.now().getTime());
        UtilUnitTest.loadAllStaticData();
      //  String channelAccountRecTypeId = [Select Id,Name, DeveloperName from RecordType where sobjecttype='Account' and Name = 'Channel'].Id;
        
        
        
        
        // Get PA record
        
        user pauser1 = GenericStaticTestData.gettestPAUserRecord();
        string roleName = pauser1.UserRole.name;
        //System.assertEquals('Partner Executive',roleName);
       // System.assertEquals(1,[select COUNT() from userrole where portalaccountid =:GenericStaticTestData.gettestChannelAccountRecord1().id and Name like '%Partner Executive' limit 1]);
        //System.assert(roleName.endsWith('Partner Executive'));
        
        user psruser1 = GenericStaticTestData.gettestPSRUserRecord();
        
        //System.assertEquals(1, [SELECT COUNT() FROM USER WHERE username = 'testpa@cisco.com.sales.test']);
        

        // Create Account
        Account eca =new Account();
        eca = GenericStaticTestData.getTestEndUserAccountRecordRed();
        
        // Create Lead
       // Lead leadRec = GenericStaticTestData.gettesteLeadRecord();
        
        // Create TP recrod
        //Assigned_Partner__c tp = GenericStaticTestData.gettestTargetProspectRecord();
       // System.runAs(pauser1) {
        	Test.startTest();
        	  String q_select = 'Select a.CRCity__c, a.City__c, a.CRCountry__c, a.Country__c, ';
	        q_select = q_select + ' a.CRState__c, a.State__c,a.AddressLine1__c,a.CRAddressLine1__c , a.CRZipPostalCode__c, a.Current_FY_Wallet_Total_000__c, ';
	        q_select = q_select + ' a.Id, a.Incumbent_Partner_Status__c, a.Industry, a.Name, a.CRName__c, a.Show_Account_in_Unallocated_Pool__c, a.Wallet_Switching_000__c, ';
	        q_select = q_select + ' a.Wallet_Routing_000__c, a.Wallet_Security_000__c, a.Wallet_Wireless_000__c, a.Wallet_Collab_Applications__c, a.Wallet_Services_000__c, ';
	        q_select = q_select + ' a.Wallet_Unified_Communications_000__c, a.Wallet_Data_Center_UCS_000__c, a.Wallet_Video_000__c, a.Wallet_Other_000__c, ' ;
	        q_select = q_select + ' a.Expected_Bookings_Switching_000__c, a.Expected_Bookings_Routing_000__c, a.Expected_Bookings_Security_000__c, a.Expected_Bookings_Wireless_000__c, ';
	        q_select = q_select + ' a.Expected_Bookings_Collab_Voice_000__c, a.Expected_Bookings_Data_Center_UCS_000__c, a.Expected_Bookings_Telepresence_000__c, a.Expected_Bookings_Collab_App_000__c, ';
	        q_select = q_select + ' a.Expected_Bookings_Services_000__c, a.Current_FY_RAD_Strategy__c';
	        
	        String q1 = q_select + ' FROM ACCOUNT a LIMIT 10';
	        
	        prmPagenationUtility pg1 = new prmPagenationUtility(q1,10);
	        pg1.isUnCoveredView = true;
	        pg1.getTPPageRecords();
	        pg1.clearPageRecords();
        	Test.stopTest();
       // }
    }
}