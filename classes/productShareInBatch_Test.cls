@isTest
Public class productShareInBatch_Test{
    Public static testMethod void shareProducts(){
        Product2 prod = new Product2(Name = 'Laptop X200', Family = 'Hardware',isActive=true,ProductCode='AS-200');
        insert prod;
            
        Test.StartTest();
         productShareInBatch psb = new productShareInBatch();
                 DataBase.executeBatch(psb,20);   
         Test.StopTest();        
    }
}