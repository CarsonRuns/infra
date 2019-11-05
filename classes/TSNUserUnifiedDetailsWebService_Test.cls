@isTest

// This is the test class for TSNUserUnifiedDetailsWebService Apex class

private Class TSNUserUnifiedDetailsWebService_Test{
       private static testMethod void test(){
        // Use StaticResourceCalloutMock built-in class to 
    
        // specify fake response and include response body  
    
        // in a static resource. 
    
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('UserUnifiedXML_Data');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'text/plain');
        
        Test.setMock(HttpCalloutMock.class, mock);
        TSNUserUnifiedDetailsWebService.getCecVal('test');
        
       }
   }