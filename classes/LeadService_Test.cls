@isTest
public class LeadService_Test{
    public static void preventClosedLeadUpdates(){
        Lead testLead = new Lead(lastName='testLead', company='testCompany');
        insert testLead;
        Test.startTest();
        TEst.stopTest();
    }
}