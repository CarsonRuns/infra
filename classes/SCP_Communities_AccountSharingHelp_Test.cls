@isTest(SeeAllData = true)
private class SCP_Communities_AccountSharingHelp_Test {
	static testMethod void testforDistiPartnerMapping(){
		//Account parentAccount = GenericStaticTestData.getTestPartnerCompanyAccountRecord();
		
		
		Account a12 = new Account(name='Test Partner Company Account',RECORDTYPEID='01280000000G6tsAAC',Country__c='UNITED STATES');
       	insert a12;
       	Partner_Program_Enrollment__c PPE = new Partner_Program_Enrollment__c(Name='Cisco Sales Collaboration Platform',PROGRAM_ENROLLMENT_STATUS__C='Active');
        PPE.PARTNER_COMPANY__C = a12.id;
        insert PPE;
       	
        Account partnerAccount = new Account(name='Test Channel Account',PDB_BE_GEO_ID__c = '2345',parentid=a12.Id, RECORDTYPEID='0123000000004aVAAQ',Country__c='UNITED STATES',ownerid ='00530000000fb2q');
        insert partnerAccount;              
        
		
		Account a1 = new Account(name='Test distributor Company Account',RECORDTYPEID='01280000000G6tsAAC',Country__c='UNITED STATES');
        insert a1;
        Partner_Program_Enrollment__c PPE1 = new Partner_Program_Enrollment__c(Name='Cisco Sales Collaboration Platform',PROGRAM_ENROLLMENT_STATUS__C='Active');
        PPE1.PARTNER_COMPANY__C = a1.id;
        insert PPE1;
        
        Account a21 = new Account(name='Test Disti Account',RECORDTYPEID='0123000000004aVAAQ',PDB_BE_GEO_ID__c ='4566',Type='Distributor',Country__c='UNITED STATES',ownerid ='00530000000fb2q');
        insert a21;
        
        a21.parentid = a1.id;
        update a21;
        
        Disti_to_Partner_Mapping__c testRecord = new Disti_to_Partner_Mapping__c(Distributor_BEGEO_ID__c='4566',Partner_BEGEO_ID__c='2345');
        insert testRecord;
        
        //delete testRecord;
	}
		
}