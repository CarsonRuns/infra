@isTest
Public class shareProductToS1_Test{
    Public static testMethod void shareProductsToS1(){
        Product2 p = new Product2();
            p.name='AS-400';
            p.isActive=true;
        insert p;
        Test.startTest();
            Datetime dt = Datetime.now().addMinutes(1);
            String sch = '20 30 8 10 2 ?';
            System.schedule('Sample_Heading_1', sch, new shareProductToS1() );   
        Test.stopTest();
    }
}