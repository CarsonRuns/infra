@isTest
public class BatchDeleteJobId_Test 
{
    static testMethod void testMethod1() 
    {         
         Test.startTest();             
          FF_Batch_details__c ffbd = new FF_Batch_details__c(isActive__c=false, isLineItem__c=true);
          insert ffbd;             
            BatchDeleteJobId obj = new BatchDeleteJobId();
            DataBase.executeBatch(obj,10);         
         Test.stopTest();   
    }
}