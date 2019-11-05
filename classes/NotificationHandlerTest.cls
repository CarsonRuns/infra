@isTest
public class NotificationHandlerTest {
   
    static testMethod void testNAASNotification() {      
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseNAASGenerator());
        System.Queueable job = new NotificationHandler('Opportunity');
        System.enqueueJob(job);
    }
}