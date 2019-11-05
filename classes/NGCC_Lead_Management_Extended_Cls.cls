/*********************************************************************************************************************************
Name    : NGCC_Lead_Management_Extended_Cls
Author  : Mukesh Srivastava
Purpose : This class is to handle all Lead related activity for NGCC project and some P360.
            This combine P360 LeadStatusToClosed Trigger where when a lead is rejected lead must be closed.
            This extend the functionality for NGCC project and route lead to proper user for requalification
            
Created Date:  6/26/2014 
Modification History:
            @Fazur : Added new logic to avoid as soon as Partner rejected any lead with 3.1 or 3.9 or 3.12 status, same user getting wired exception message on lead UI.                      
**********************************************************************************************************************************/
public class NGCC_Lead_Management_Extended_Cls {
    public Static List < Lead > listEleadRejectedBySales = new List < Lead > ();
    public static void NGCC_Lead_Mmgt_Extended_Update(List < Lead > newLstLead) {
        ObjectRecordTypeIds__c objLeadRec = ObjectRecordTypeIds__c.getInstance();
        Map < String, Org_Constant_CS__c > mapOCS = Org_Constant_CS__c.getAll();

        Id manualRecId = objLeadRec.Manual_Lead_RecordTypeId__c;
        Id eleadRecId = objLeadRec.eLeadsRecordTypeId__c;
        Id closeRecId = objLeadRec.Closed_Lead_RecordTypeId__c;

        
        for (Lead l: newLstLead) {
            if ((l.RecordTypeId == manualRecId && mapOCS.get('P360_Rejection_To_Close').Production_Value__c.contains(l.Status)) ||
                    (l.RecordTypeId == eleadRecId && (l.Max__c == True ||
                                                    (l.MQL_Created_Date__c == NULL && mapOCS.get('P360_Rejection_To_Close').Production_Value__c.contains(l.Status)) ||
                                                     mapOCS.get('NGCC_Rejection_To_Close').Production_Value__c.contains(l.Status)))) {
                l.RecordTypeId = closeRecId;
                l.Previous_Sales_Lead_Status__c = l.Status;
                l.Previous_Rejected_Reason_Date__c = System.now();
                l.Previous_Rejected_Reason_Details__c =l.Rejected_Reason_Details__c;
            } else if (l.RecordTypeId == eleadRecId && mapOCS.get('NGCC_Rejection_To_Requalify').Production_Value__c.contains(l.Status) &&
                        l.MQL_Created_Date__c != NULL && l.Max__c == false) {
                //NGCC_UpdateRejectedLeadOwner(l);
                listEleadRejectedBySales.add(l);                
            }
        }
        if (!listEleadRejectedBySales.isEmpty()){
             User sdrLeadOwnerDetails = [select id,isactive from user where id =:listEleadRejectedBySales[0].SDR_Lead_Owner_New__c limit 1];
             NGCC_UpdateRejectedLeadOwner(listEleadRejectedBySales,sdrLeadOwnerDetails);      
        }
    }

    /* @ method: Process the eLeads which are rejected by Sale */
    public static void NGCC_UpdateRejectedLeadOwner(List<Lead> rejectedeleadsList,User sdrLeadOwnerDetails) {
        ObjectRecordTypeIds__c objLeadRec = ObjectRecordTypeIds__c.getInstance();


         Id marketingLeadRecType = objLeadRec.Marketing_Lead_RecordType__c;         
        Map < String, NGCC_Requalification_Settings__c > fieldMapping = NGCC_Requalification_Settings__c.getAll();
        for(Lead rejectedeleads : rejectedeleadsList){
            if (rejectedeleads.Max__c == false) {

            // Creating our unique combination based on Rejected Code + Call Center Vendor
            String combination = rejectedeleads.Status.split(' ')[0] + rejectedeleads.Call_Center_Vendor__c;
            if(combination.length()>38){
                combination= combination.substring(0,38);
            }
            system.debug('combination'+combination);
            if (fieldMapping.containsKey(combination)){
                if(!sdrLeadOwnerDetails.isActive){
                    rejectedeleads.OwnerId = fieldMapping.get(combination).OwnerId__c;
                    rejectedeleads.Max__c = fieldMapping.get(combination).Max__c;
                }else{
                    if (fieldMapping.get(combination).Owner__c == 'Lead.SDR_Lead_Owner_New__c'){
                        if (rejectedeleads.SDR_Lead_Owner_New__c != null) { 
                            rejectedeleads.OwnerId = rejectedeleads.SDR_Lead_Owner_New__c;
                            rejectedeleads.Max__c = fieldMapping.get(combination).Max__c;                        
                        }
                    }else{
                        rejectedeleads.OwnerId = fieldMapping.get(combination).OwnerId__c;
                        rejectedeleads.Max__c = fieldMapping.get(combination).Max__c;
                    }
                 }                
                rejectedeleads.RecordTypeId = marketingLeadRecType;
                rejectedeleads.Previous_Sales_Lead_Status__c = rejectedeleads.Status;
                rejectedeleads.Previous_Rejected_Reason_Date__c = System.now();
                rejectedeleads.Previous_Rejected_Reason_Details__c =rejectedeleads.Rejected_Reason_Details__c;
                rejectedeleads.Status = 'Rejected by Sales';
                rejectedeleads.Call_Status__c = 'Requalification Required';
            }
          }       
        }
    }

}