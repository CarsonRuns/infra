/*
    Name            : SourceFireInsertFieldsandNotifications 
    Author          : gbarai
    Release         : 1.1
    Functionality   : Send Notifications - If the CECID is not valid then Send a Notification to SourceFireLead Admin.
    Created         : Unknown
    
    Modification History:
    Date        Author          Change 
    Aug 24 2015 epesch          1.1 - Added exception for the connection_user clause for TAC Generated Lead (to review later with Config team)
                                -Redone the class to not break on multiple Connections
                                -Redone the format of the class to fit SFDC Standard Conventions vs. Java Conventions
*/
public class SourceFireInsertFieldsandNotifications {
    
    // SCAVA Helper Method to validate Create Access at field level
     public static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }
    
    public static boolean isSFire = false; 
    private static final String TAG = '[SourceFireInsertFieldsandNotifications] - ';

    /*
     * @description Validate the CECID received from Sourcefire if the CECID is invalid then send email to SourceFireLead Admin
     *
     * @param leadsLst List of Leads to Validate
     */     
    public static void validateCECID(List<Lead> leadsLst) {    
        // Below code is use to map the Lead owner when lead is shared from SourceFire based on CSE ID.
        Set<String> lstCses = new Set<String>();
        Map<String, Id> mpUserId = new Map<String, Id>();
        Id connectionId = ConnectionUtilities.getConnectionId(Utilities.getConstant_CS('Lead SourceFire Connection Name'));
        
        for(Lead l : leadsLst) {
            if(l.LeadSource == System.label.Lead_SourceFire_Name || (l.ConnectionReceivedId != null
                    && l.ConnectionReceivedId == connectionId)) {
                System.debug(TAG + 'Source fire or defaulting to source fire lead - ' + l.LeadSource);
                
                String cseEmail = (l.CEC_ID__c == null ) ? null : l.CEC_ID__c + '@cisco.com';
                lstCses.add(cseEmail);
                l.Lead_Type__c = System.label.Lead_SourceFire_Name;
                l.LeadSource = System.label.Lead_SourceFire_Name;
                l.Status = System.label.Lead_SourceFire_Default_Status;
            }
        }
        
        if(!lstCses.isEmpty()) {    
            Group grName = [select Id, Name from Group where type=: 'Queue' and Name =: System.label.Lead_SourceFire_Unallocated limit 1];
            List<user> users = [select Id, Email from User where email IN:lstCses and  Isactive =: true ];           
            
            for(User u: users) {
                mpUserId.put(u.Email,u.Id);
            }
            
            for(Lead ld : leadsLst) {
                if(ld.LeadSource == System.label.Lead_SourceFire_Name) {         
                    String cseEmail = (ld.CEC_ID__c == null ) ? null : ld.CEC_ID__c + '@cisco.com';
                    Id UserId = mpUserId.get(cseEmail); 
                    
                    if(UserId == null) {
                        ld.OwnerId = (grName == null) ? null : grName.Id;
                        ld.SourceFire_Hidden_Valid_CECID__c = System.label.Lead_SourceFire_Invalid;
                    } else {
                        ld.OwnerId = UserId;
                        ld.SourceFire_Hidden_Valid_CECID__c = System.label.Lead_SourceFire_Valid;
                    } 
                }       
            }
        }
    }

    /*
     * @description Method to flow back the Lead data mapped to sourcefire
     * 
     * @param leadsList List of Leads to update Sourcefire Status
     */ 
    public static void updateStataustoSourceFire(List<Lead> leadsList) {
        Id connectionId = ConnectionUtilities.getConnectionId(Utilities.getConstant_CS('Lead SourceFire Connection Name'));
        List<PartnerNetworkRecordConnection> lstInsertConn = new List<PartnerNetworkRecordConnection>();  
        
        for(Lead l : leadsList) {            
            if(l.SourceFire_Lead_source__c ==  System.label.Lead_SourceFire_Name || l.LeadSource ==  System.label.Lead_SourceFire_Name) {   
                PartnerNetworkRecordConnection newrecord = new PartnerNetworkRecordConnection();
                //SCAVA FIX
                if(flsGet(PartnerNetworkRecordConnection.ConnectionId))
                {
                newrecord.ConnectionId = connectionId;
                }
                if(flsGet(PartnerNetworkRecordConnection.LocalRecordId))
                {
                newrecord.LocalRecordId = l.Id;  
                }
                if(flsGet(PartnerNetworkRecordConnection.SendClosedTasks))
                {
                newrecord.SendClosedTasks = true;
                }
                if(flsGet(PartnerNetworkRecordConnection.SendOpenTasks))
                {
                newrecord.SendOpenTasks = true;
                }
                if(flsGet(PartnerNetworkRecordConnection.SendEmails))
                {
                newrecord.SendEmails = true;   
                }
                lstInsertConn.add(newrecord); 
            }             
        }
        
        if(!lstInsertConn.isEmpty()) {
            Database.saveresult[] result = Database.insert(lstInsertConn); 
            isSFire = true;     
        }
    }
}