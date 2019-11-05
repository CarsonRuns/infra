@isTest(seeAllData = false)
private class DSE_Mule_Token_Test {
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';

    private static testmethod void TestMuleTokenSchedular() {
        Test.startTest();
        Org_Constant_CS__c os = new Org_Constant_CS__c();
        os.name = 'DSEMuleToken';
        os.Production_Value__c = 'https://test.cisco.com';
        os.Non_Production_Value__c = 'https://test.cisco.com';
        insert os;
        
        
        // Schedule the test job
        String jobId = System.schedule('ScheduleApexClassTest',
            CRON_EXP,
            new DSE_Token_Refresher());
            
        Test.setMock(HttpCalloutMock.class, new DSE_Http_Mule_Response_Test());           


        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,
         NextFireTime
         FROM CronTrigger WHERE id = : jobId];

        // Verify the expressions are the same
        System.assertEquals(CRON_EXP,
            ct.CronExpression);

        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);

        // Verify the next time the job will run
        System.assertEquals('2022-03-15 00:00:00',
            String.valueOf(ct.NextFireTime));

        Test.stopTest();

    }
}