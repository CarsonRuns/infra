@isTest
public class RenewalsSyncController_Test{
    
    static testMethod void getExpectedTermApexTest(){
        id OptyId;
        String RetVal ;
        test.startTest();
        OptyId = Renewals_TestUtility.getOptyrenewals('admin2', 'test1');
        system.debug('----testt---'+OptyId);
        Renewals_TestUtility.insertLineItems(OptyId);
    
        list<Opportunitylineitem> optylines= [select id , name ,ProductCode  from Opportunitylineitem where opportunityid =:OptyId ]; 
          
        system.debug('optylines-->'+optylines);
        
        RenewalsSyncController.getExpectedTermApex(OptyId);
        RetVal = RenewalsSyncController.saveExpectedTermApex(OptyId);
        system.debug('RetVal-->'+RetVal);
        test.stopTest();
        //System.assertEquals('Success', RetVal);
        
    }
    static testMethod void getExpectedTermApexTest2(){
        
        id OptyId2;
         String RetVal ;
        OptyId2 = Renewals_TestUtility.getOptyrenewals('admin2', 'test2');
        RetVal=RenewalsSyncController.saveExpectedTermApex(OptyId2);
    }
  
    
    
    
}