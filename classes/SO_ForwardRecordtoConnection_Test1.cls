@isTest(seealldata=true)
private class SO_ForwardRecordtoConnection_Test1 {

    public static testMethod void testSecdule()
    {
        Test.startTest();           
        Datetime dt = Datetime.now().addMinutes(1);
        String sch = '20 30 8 10 2 ?';
        System.schedule('Sample_Heading_2', sch, new ScheduleOpptyShareSOneBatchApex() );   
        Test.stopTest();
    }
    
    public static testMethod void testDataToLoad(){
         Test.StartTest();
                OpptyShareSOneBatchApex ops = new OpptyShareSOneBatchApex(); 
                Database.executeBatch(ops,2000);  
            Test.StopTest();
    
    }
}