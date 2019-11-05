@isTest
public class BatchForSageRoleUpdateTest {
    static testMethod void checkSageIntegration() {
		Test.StartTest();
        BatchForSageSERoleUpdate seRoleUpdate = new BatchForSageSERoleUpdate();
		String sch = '0 0 23 * * ?';
        system.schedule('Test Territory Check', sch, seRoleUpdate); 
        Test.stopTest(); 
    }
}