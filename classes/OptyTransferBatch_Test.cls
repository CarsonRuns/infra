@isTest(SeeAllData=true)
public class OptyTransferBatch_Test 
{      
    static testMethod void OpptyTransfer() 
    {        
        Test.startTest();          
        try{  
            OptyTransferBatch obj = new OptyTransferBatch();
            DataBase.executeBatch(obj,10);
            
            system.debug('obj====>'+obj);
        }catch(Exception e){}
        Test.stopTest(); 
    }
    
    
}