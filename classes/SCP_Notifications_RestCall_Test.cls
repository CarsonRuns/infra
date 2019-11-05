@isTest 
public class SCP_Notifications_RestCall_Test{
    public static testMethod void testSCP_notification_Web()
    {
        UtilUnitTest.loadAllStaticData();
        lead l = GenericStaticTestData.gettestPartnerGereratedLeadRecord();
        SCP_Notifications_RestCall.callWSAPI('SCP-TTL-LD', '', 'SCP-LD-ASMT', 'N', 'SCP user', 'Leads Module', 'SCP', l.Id, 'test Account', 'test User', 'pec_hold_test_12');
    }
}