@isTest
    private class P360_PPUserOnboardingSchedulerRe_Test{
        static testMethod void testSchedulerRedesign()
           {
               Test.startTest();
                   P360_PPUserOnboardingSchedulerRedesign p = new P360_PPUserOnboardingSchedulerRedesign();
                   String sch = '0 0 0/3 * * ?';
                   System.schedule('P360_PPUserOnboardingSchedulerRedesign_Test', sch, p);
               Test.stopTest();
           }   
    }