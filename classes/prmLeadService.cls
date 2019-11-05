public with sharing class prmLeadService {
    /**
     * @description Updates 'Partner Assigned' && 'Assigned to PSR' leads to Activley working for editted leads
     * 
     * @param leadIds List of lead records ids to query against 
     * @param statuses List of status values to query against the field lead.Partner_Lead_Status__c
     * 
     * @return Lead data whose status and id matches the input parameters
     */
    public static void processEdittedAssignedLeads(Lead oldLead, Lead udpatedLead){
        //Check Partner Assigned/Assigned to PSR leads are editted
        /*System.debug(udpatedLead.Partner_Lead_Status__c);
        System.debug(udpatedLead.ProductAmount__c + '|' + oldLead.ProductAmount__c);
        System.debug(udpatedLead.ServicesAmount__c + '|' + oldLead.ServicesAmount__c);
        System.debug(udpatedLead.Distributor_Name__c + '|' + oldLead.Distributor_Name__c);
        System.debug(udpatedLead.PO_Number__c + '|' + oldLead.PO_Number__c);
        System.debug(udpatedLead.Appointment_Type__c + '|' + oldLead.Appointment_Type__c);
        System.debug(udpatedLead.Appointment_Date_Time__c + '|' + oldLead.Appointment_Date_Time__c);
        System.debug(udpatedLead.Lead_Quality_Comments__c + '|' + oldLead.Lead_Quality_Comments__c);
        System.debug(udpatedLead.Lead_Quality_Rating__c + '|' + oldLead.Lead_Quality_Rating__c);
        System.debug(udpatedLead.PSR_1__c +  '|' + oldLead.PSR_1__c);*/
        if(Partner360Utils.PARTNER_STATUS_PARTNER_ASSIGNED.equals(udpatedLead.Partner_Lead_Status__c) ||
           'Assigned To PSR'.equals(udpatedLead.Partner_Lead_Status__c)){
            if( udpatedLead.ProductAmount__c != oldLead.ProductAmount__c ||
                udpatedLead.ServicesAmount__c != oldLead.ServicesAmount__c ||
                udpatedLead.Distributor_Name__c != oldLead.Distributor_Name__c ||
                udpatedLead.PO_Number__c != oldLead.PO_Number__c ||
                udpatedLead.Appointment_Type__c != oldLead.Appointment_Type__c ||
                udpatedLead.Appointment_Date_Time__c != oldLead.Appointment_Date_Time__c ||
                udpatedLead.Lead_Quality_Comments__c != oldLead.Lead_Quality_Comments__c ||
                udpatedLead.Lead_Quality_Rating__c != oldLead.Lead_Quality_Rating__c)
            {
                udpatedLead.Partner_Lead_Status__c = Partner360Utils.PARTNER_STATUS_ACTIVELY_WORKING;

                //Set running partner user as PSR 1 if no PSR is assigned to lead
                if( udpatedLead.PSR_1__c == null && udpatedLead.PSR_2__c == null && udpatedLead.PSR_3__c == null){
                    udpatedLead.PSR_1__c = UserInfo.getUserId();
                }
            }
        }
        System.debug(udpatedLead.Partner_Lead_Status__c);
        System.debug(udpatedLead.PSR_1__c);
    }
}