/*********************************************************************************************************************************
Name    : NGCC_Lead_Management_Cls
Author  : Mukesh Srivastava
Purpose : This class is to handle all Lead related activity for NGCC project
It helps for routing to lead to CCM for approval
Lead ReQualification Process:Based on the rejection reason the lead will be updated with the owner

Created Date:  1/17/2014 
Modification History: 
May 13,2014- by Bapu 
Description: To update Partner_Email_id with Cisco_Rec_PSR__c and AM_Email_Id with Route_to_AM user email id
Fazurulla  : Added new logic for NGCC Integration user to prevent before update the fileds like 
Third_Party_Data_Permission__c,Email_Permission__c,Call_Permission__c whenever updates coming from MODS system # PBI000000051833    
Fazurulla  : Added new logic for Campaign priority field - INC000033825132        
***************************************************************************
Name: zakeahme
Modification History: May-28-2019
Description: To update Program_Event_Name__c field for VDC recordType Leads. (Line#: 41 && 99)            
**********************************************************************************************************************************/
public class NGCC_Lead_Management_Cls {
    
    Static Set < Id > setContId = new Set < Id > ();
    Static Set < Id > setCampId = new Set < Id > ();
    Static List < Lead > lstLeadToProcess = new List < Lead > ();
    Static List < Lead > lstELeadRej = new List < Lead > ();
    Static Set < Id > setRouteAMPSR = new Set < Id > ();
    Static Set < Id > setPreferredPartner = new Set < Id > ();
    Static Set <String> setCountries = new Set<String>();
    Static Set <String> setCallCenter = new Set<String>();
    
    /* method: Process all the new lead created for Marketing for populating Theater,Permission,CCMs */
    public static void NGCC_New_Lead_Additional_Update(List < Lead > newLstLead, Map < Id, Lead > mapNewLead) {
        String mktgLeadRecType;
        Id eLeadRecType;
        ObjectRecordTypeIds__c orgConstant = ObjectRecordTypeIds__c.getInstance(); // initiate custom setting contain object record type
        mktgLeadRecType = orgConstant.Marketing_Lead_RecordType__c; // assign marketing lead recordtype to variable
        eLeadRecType = orgConstant.eLeadsRecordTypeId__c;
        Id recordTypeIdVDC = Schema.getGlobalDescribe().get('Lead').getDescribe().getRecordTypeInfosByName().get('VDC').getRecordTypeId();
        // Map < String, NGCC_Mapping_Object__c > mapMPObj = mappingObject();
        for (Lead l: newLstLead) {    
            if (l.RecordTypeId == mktgLeadRecType || l.RecordTypeId == recordTypeIdVDC) {
                if (l.Cisco_Rec_PSR__c != NULL) {
                    setRouteAMPSR.add(l.Cisco_Rec_PSR__c);
                    lstLeadToProcess.add(l);
                }
                
                if (l.Route_to_AM__c != NULL) {
                    setRouteAMPSR.add(l.Route_to_AM__c);
                    lstLeadToProcess.add(l);
                }
                
                if (l.Preferred_Partner__c != NULL) {
                    setPreferredPartner.add(l.Preferred_Partner__c);
                    lstLeadToProcess.add(l);
                }
                
                if (l.Channel_Partner__c != NULL) {
                    l.Route_To_Partner_Account_Name__c = l.Channel_Partner_Name__c;
                    l.Route_To_Partner_Account_BEC_ID__c = l.Partner_BEC_ID_PGTMV__c;
                    l.Partner_Account_BEC_ID__c = l.Partner_BEC_ID_PGTMV__c;
                }
                
                if (l.Campaign_Name__c != NULL) {
                    setCampId.add(l.Campaign_Name__c);
                    lstLeadToProcess.add(l);
                }
                
                if (l.customCountry__c != NULL){
                    setCountries.add(l.customCountry__c);
                    lstLeadToProcess.add(l);
                }
                
                if (l.Lead_Owner_Call_Center__c != NULL){
                    setCallCenter.add(l.Lead_Owner_Call_Center__c);
                    lstLeadToProcess.add(l);
                }
            }
        }
        
        if (!lstLeadToProcess.isEmpty()) {
            NGCC_Process_Lead();
        }
    }
    
    /*@ method: Process all the updated lead modified for Marketing for populating campaign detail,Theater,Permission,CCMs */
    public static void NGCC_Updated_Lead_Additional_Update(List < Lead > newLstLead, Map < Id, Lead > mapOldLead) {
        String mktgLeadRecType;
        Id eLeadRecType;
        Id manualLeadRecType;
        ObjectRecordTypeIds__c orgConstant = ObjectRecordTypeIds__c.getInstance(); // initiate custom setting contain object record type
        mktgLeadRecType = orgConstant.Marketing_Lead_RecordType__c; // assign marketing lead recordtype to variable
        eLeadRecType = orgConstant.eLeadsRecordTypeId__c;
        manualLeadRecType = orgConstant.Manual_Lead_RecordTypeId__c;
       Id recordTypeIdVDC = Schema.getGlobalDescribe().get('Lead').getDescribe().getRecordTypeInfosByName().get('VDC').getRecordTypeId();
        
        for (Lead l: newLstLead) {
            ValidateApproval(l);
           
            if (l.RecordTypeId == mktgLeadRecType || l.RecordTypeId == recordTypeIdVDC) {
                if ((l.OwnerId != mapOldLead.get(l.Id).OwnerId)) {
                    if (l.Lead_Owner_Call_Center__c != NULL){
                        setCallCenter.add(l.Lead_Owner_Call_Center__c);
                        lstLeadToProcess.add(l);
                    }
                } else {
                    if ((l.Status.contains('Invalid Contact') || l.Status.contains('No Valid Project') || l.Status.contains('No Customer Response')) && l.Lead_Qualifier__c != null) {
                        l.OwnerId = l.Lead_Qualifier__c;
                    }
                }
                //  Update Theater,LDR Lead Owner and Alias if the country Change
                if (l.customCountry__c != mapOldLead.get(l.Id).customCountry__c) {
                    if (l.customCountry__c != NULL){
                        setCountries.add(l.customCountry__c);
                        lstLeadToProcess.add(l);
                    }
                }
                // Update the Campaign Fields where association of Campaign to the lead
                if (l.Campaign_Name__c != mapOldLead.get(l.Id).Campaign_Name__c) {
                    if (l.Campaign_Name__c == NULL) {
                        l.Program_Event_Name__c = '';
                        l.ProgramEvent__c = '';
                        l.Offer_Description__c = '';
                        l.Offer_URL__c = '';
                        l.Primary_Technology__c = '';
                        l.Campaign_Code__c = '';
                        l.Campaign_Description__c = '';
                        l.Program_Event_Description__c = '';
                        l.Offer_Name__c = '';
                        l.Offer_Architecture__c = '';
                        //added by fazu
                        l.Campaign_Priority__c='';
                    } else {
                        setCampId.add(l.Campaign_Name__c);
                        lstLeadToProcess.add(l);
                    }
                }
                // Update the Route to partner when Channel Partner change and update BEC Id PGTMV 
                if ((l.Channel_Partner__c != mapOldLead.get(l.Id).Channel_Partner__c)) {
                    if (l.Channel_Partner__c != NULL) {
                        l.Route_To_Partner_Account_Name__c = l.Channel_Partner_Name__c;
                        l.Route_To_Partner_Account_BEC_ID__c = l.Partner_BEC_ID_PGTMV__c;
                        l.Partner_Account_BEC_ID__c = l.Partner_BEC_ID_PGTMV__c;
                    } else {
                        l.Route_To_Partner_Account_Name__c = '';
                        l.Route_To_Partner_Account_BEC_ID__c = '';
                        l.Partner_Account_BEC_ID__c = '';
                    }
                }
                
                // Update the Preferred Partner Details when Preferred Partner change                 
                if ((l.Preferred_Partner__c != mapOldLead.get(l.Id).Preferred_Partner__c)) {
                    if (l.Preferred_Partner__c != NULL) {
                        setPreferredPartner.add(l.Preferred_Partner__c);
                        lstLeadToProcess.add(l);
                    } else {
                        l.QAPartner__c = '';
                        l.Preferred_Partner_Id__c = '';
                        l.Preferred_Partner_BEC_Id__c = '';
                    }
                }
                // Update the Route to PSR with the Cisco Recommended PSR on Change
                if ((l.Cisco_Rec_PSR__c != mapOldLead.get(l.Id).Cisco_Rec_PSR__c)) {
                    if (l.Cisco_Rec_PSR__c != NULL) {
                        l.Route_To_PSR__c = l.Cisco_Rec_PSR_Name__c;
                        setRouteAMPSR.add(l.Cisco_Rec_PSR__c);
                        lstLeadToProcess.add(l);
                    } else {
                        l.Partner_Email_id__c = '';
                    }
                }
                // Update the Route to AM email on Route to AM Change
                if ((l.Route_To_AM__c != mapOldLead.get(l.Id).Route_To_AM__c)) {
                    if (l.Route_To_AM__c != NULL) {
                        setRouteAMPSR.add(l.Route_To_AM__c);
                        lstLeadToProcess.add(l);
                    } else {
                        l.AM_Email_Id__c = '';
                    }
                }
                // Update the Third_Party_Data_Permission__c 
                if ((l.Third_Party_Data_Permission__c != mapOldLead.get(l.Id).Third_Party_Data_Permission__c || l.Third_Party_Data_Permission_Date__c != NULL) && !(UserInfo.getName()=='NGCC Integration' || UserInfo.getUserName()=='ngcc_integration_user@cisco.com')) {
                    if (l.Third_Party_Data_Permission__c != NULL) {
                        l.Third_Party_Data_Permission_Date__c = System.Now();
                    }  else {
                        l.Third_Party_Data_Permission_Date__c = NULL;
                    }
                }
                
                // Update the Email_Permission__c 
                if ((l.Email_Permission__c != mapOldLead.get(l.Id).Email_Permission__c || l.Email_Permission__c != NULL) && !(UserInfo.getName()=='NGCC Integration' || UserInfo.getUserName()=='ngcc_integration_user@cisco.com')) {
                    if (l.Email_Permission__c != NULL) {
                        l.Email_Permission_Date__c = System.Now();
                    }  else {
                        l.Email_Permission_Date__c = NULL;
                    }
                }
                // Update the Call_Permission__c  
                if ((l.Call_Permission__c != mapOldLead.get(l.Id).Call_Permission__c || l.Call_Permission__c != NULL) && !(UserInfo.getName()=='NGCC Integration' || UserInfo.getUserName()=='ngcc_integration_user@cisco.com')) {
                    if (l.Call_Permission__c != NULL) {
                        l.Call_Permission_Date__c = System.Now();
                    }  else {
                        l.Call_Permission_Date__c = NULL;
                    }
                }    
                // Update permission field when disassociation with Sale Contact
                if (l.Lead_Contact__c == NULL && (l.Lead_Contact__c != mapOldLead.get(l.Id).Lead_Contact__c)) {
                    l.End_Customer_Account__c = null;
                    l.Account_Owner__c = null;
                    l.Email_Permission__c = null;
                    l.Email_Permission_Date__c = null;
                    l.Call_Permission__c = '';
                    l.Call_Permission_Date__c = null;
                }
            }
            //Get the all eLead rejected by Sales for Lead Requalification
            else if (l.Status.contains('Rejected') && (l.RecordTypeId == eLeadRecType || l.RecordTypeId == manualLeadRecType) && mapOldLead.get(l.Id).Status != l.Status) {
                lstELeadRej.add(l);
            }
        }
        // Initiate Lead Requalification or P360 Closing Processing
        if (!lstELeadRej.isEmpty()) {
            NGCC_Lead_Management_Extended_Cls.NGCC_Lead_Mmgt_Extended_Update(lstELeadRej);
        }
        
        if (!lstLeadToProcess.isEmpty()) {
            NGCC_Process_Lead();
        }
    }
    
    /* @ method: Get the mapping object loaded show that we can map record with Theater and CCMs */
    public static Map < String, NGCC_Mapping_Object__c > mappingObject(Set<String> setStrCCCountries) {
        Map < String, NGCC_Mapping_Object__c > mapMPObj = new Map < String, NGCC_Mapping_Object__c > ();
        
        for (NGCC_Mapping_Object__c mObj: [Select Name, Id, LDR_User__c, Theater__c, Sub_Theater__c, Cisco_Contact_Center_Manager1__c,
                                           Cisco_Contact_Center_Manager2__c, Alias_Country_Email_Id__c,
                                           Lead_Admin_Email__c, Lead_Admin__r.Email from NGCC_Mapping_Object__c WHERE Name IN :setStrCCCountries
                                          ]) {
                                              mapMPObj.put(mObj.Name, mObj);
                                          }
        return mapMPObj;
    }
    
    /* @ method: Process the leads for populating Theater,Permission,CCMs */
    public static void NGCC_Process_Lead() {
        Map < Id, User > mapUser;
        Map < Id, Campaign > mapCampaign;
        Map < Id, Account > mapPreferredPartner;
        Set < String > setCCCountries = new Set<String>();
        Map < String, NGCC_Mapping_Object__c > mapMPObj = new Map < String, NGCC_Mapping_Object__c >() ;
        
        if(!setCallCenter.isEmpty()){
            setCCCountries.addAll(setCallCenter);
        }
        
        if(!setCountries.isEmpty()){
            setCCCountries.addAll(setCountries);
        }
        
        if(!setCCCountries.isEmpty()){
            mapMPObj = mappingObject(setCCCountries);
        }
        
        // Query campaign related detail when Campaign association has been changed
        if (!setCampId.isEmpty()) {
            mapCampaign = new map < Id, Campaign > ([SELECT id, name, Program_Event_Name__c, Program_Event_Code__c, Offer_Description__c,
                                                     Campaign_Code__c, Description, Program_Event_Description__c, Offer_Name__c, Offer_Architecture__c,
                                                     Offer_URL__c, Maximum_No_Attempts__c, Primary_Technology__c,Priority__c from Campaign where Id IN: setCampId
                                                    ]);
        }
        
        // Query User Detail for Updating AM PSR email
        if (!setRouteAMPSR.isEmpty()) {
            mapUser = new map < Id, User > ([SELECT id, name, Email from User where Id IN: setRouteAMPSR]);
        }
        
        // Query Account Detail for Preferred Partner
        if (!setPreferredPartner.isEmpty()) {
            mapPreferredPartner = new map < Id, Account > ([SELECT Id, BEC_ID__c, Name from Account where Id IN: setPreferredPartner]);
        }
        
        // Update the Lead Permission fields and campaign field using data fetched associated to association
        if (!lstLeadToProcess.isEmpty()) {
            for (Lead lObj: lstLeadToProcess) {
                
                if(!mapMPObj.isEmpty()){
                    if (mapMPObj.containsKey(lObj.customCountry__c)) {
                        lObj.Theater__c = mapMPObj.get(lObj.customCountry__c).Theater__c;
                        lObj.Sub_Theater__c = mapMPObj.get(lObj.CustomCountry__c).Sub_Theater__c;
                        lObj.LDR_Lead_Owner__c = mapMPObj.get(lObj.CustomCountry__c).LDR_User__c;
                        lObj.Lead_Admin_Alias_Email__c = mapMPObj.get(lObj.CustomCountry__c).Lead_Admin_Email__c;
                        lObj.Alias_Country_Email_Id__c = mapMPObj.get(lObj.CustomCountry__c).Alias_Country_Email_Id__c;
                    }
                    
                    if (mapMPObj.containsKey(lObj.Lead_Owner_Call_Center__c)) {
                        lObj.Cisco_Contact_Center_Manager1__c = mapMPObj.get(lObj.Lead_Owner_Call_Center__c).Cisco_Contact_Center_Manager1__c;
                        lObj.Cisco_Contact_Center_Manager2__c = mapMPObj.get(lObj.Lead_Owner_Call_Center__c).Cisco_Contact_Center_Manager2__c;
                    }               
                }
                
                if (mapCampaign != Null) {
                    if (mapCampaign.containsKey(lObj.Campaign_Name__c)) {
                    System.debug('<<<*>>>>' +mapCampaign.get(lObj.Campaign_Name__c).Program_Event_Name__c);
                    System.debug('<<<*>>>>' +lObj.Campaign_Name__c);
                        lObj.Program_Event_Name__c = mapCampaign.get(lObj.Campaign_Name__c).Program_Event_Name__c;
                        System.debug('<<<*>>>>' +lObj.Program_Event_Name__c);
                        lObj.ProgramEvent__c = mapCampaign.get(lObj.Campaign_Name__c).Program_Event_Code__c;
                        // If condition Added by gchitha to check to check Null values
                        if(String.isNotBlank(mapCampaign.get(lObj.Campaign_Name__c).Offer_Description__c)){
                            lObj.Offer_Description__c = mapCampaign.get(lObj.Campaign_Name__c).Offer_Description__c;
                        }
                        // If condition Added by gchitha to check to check Null values
                        if(String.isNotBlank(mapCampaign.get(lObj.Campaign_Name__c).Offer_URL__c)){
                            lObj.Offer_URL__c = mapCampaign.get(lObj.Campaign_Name__c).Offer_URL__c;
                        }
                        lObj.Primary_Technology__c = mapCampaign.get(lObj.Campaign_Name__c).Primary_Technology__c;
                        lObj.Campaign_Code__c = mapCampaign.get(lObj.Campaign_Name__c).Campaign_Code__c;
                        lObj.Program_Event_Description__c = mapCampaign.get(lObj.Campaign_Name__c).Program_Event_Description__c;
                        lObj.Offer_Name__c = mapCampaign.get(lObj.Campaign_Name__c).Offer_Name__c;
                        lObj.Offer_Architecture__c = mapCampaign.get(lObj.Campaign_Name__c).Offer_Architecture__c;
                        //added by fazu
                        lObj.Campaign_Priority__c = String.valueOf(mapCampaign.get(lObj.Campaign_Name__c).Priority__c);
                        /* Removed the below if condition because of US#245565 by Zakeahme date: Nov-30th */
                        //if(mapCampaign.get(lObj.Campaign_Name__c).Description != NULL){
                        //  lObj.Campaign_Description__c = mapCampaign.get(lObj.Campaign_Name__c).Description.abbreviate(255);
                        //}
                    }
                }
                // Updating Email address for PSR and AM
                if (mapUser != Null) {
                    if (mapUser.containsKey(lObj.Cisco_Rec_PSR__c)) {
                        lObj.Partner_Email_id__c = mapUser.get(lObj.Cisco_Rec_PSR__c).Email;
                    }
                    
                    if (mapUser.containsKey(lObj.Route_to_AM__c)) {
                        lObj.AM_Email_Id__c = mapUser.get(lObj.Route_to_AM__c).Email;
                    }
                }
                // Updating Preferred Partner Detail
                if (mapPreferredPartner != Null) {
                    if (mapPreferredPartner.containsKey(lObj.Preferred_Partner__c)) {
                        lObj.QAPartner__c = mapPreferredPartner.get(lObj.Preferred_Partner__c).Name;
                        lObj.Preferred_Partner_Id__c = mapPreferredPartner.get(lObj.Preferred_Partner__c).Id;
                        lObj.Preferred_Partner_BEC_Id__c = mapPreferredPartner.get(lObj.Preferred_Partner__c).BEC_ID__c;
                    }
                }
            }
        }
    }
    
    //@ method: Validate if  SDR is approving the Lead
    public static void validateApproval(Lead l) {
        if (l.Lead_Approval_Role__c != Null) {
            if ((l.status == 'Approved' || l.status == 'Rejected') && l.Lead_Approval_Role__c.contains('SDR')) {
                l.adderror('You are not authorized to approve the lead.');
            }
        }
    }
}