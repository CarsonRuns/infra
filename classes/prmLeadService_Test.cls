@isTest
public class prmLeadService_Test {
	public static testMethod void testProcessEdittedAssignedLeads(){
        Lead oldLead = new Lead();
        Lead udpatedLead = new Lead();
        
        udpatedLead.Partner_Lead_Status__c = Partner360Utils.PARTNER_STATUS_PARTNER_ASSIGNED;
        udpatedLead.Estimated_Product_Amount_USD__c = 123.9;
        udpatedLead.Estimated_Service_Amount_USD__c = 123.9;
        udpatedLead.Expected_Product_List_Amount__c = 123.9;
        udpatedLead.Expected_Service_List_Amount__c = 123.9;
        
        prmLeadService.processEdittedAssignedLeads(oldLead, udpatedLead);     
    }
}