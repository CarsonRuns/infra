public class ReAssignCase_CTE {

    public Case c { get; set; }
    public Case caseRecord ;
    public Boolean isTSNCase{get;set;}
    public String profileId;
    public String caseOwner;
    public String caseStatus;
    public String caseAssignedSLA;
    public Boolean caseOwnerGroup = false;
    public Boolean isLink{ get; set; }
    ProfileID__c pid = ProfileID__c.getOrgDefaults();
    
    
    public ReAssignCase_CTE(ApexPages.StandardController controller) {
        c = (Case) controller.getRecord();
        caseRecord = [Select Status,Assigned_SLA__c from Case where id =:ApexPages.CurrentPage().getparameters().get('id')];        
        profileId = Userinfo.getProfileId();
        caseOwner = c.OwnerId;
        caseStatus = caseRecord.Status;
        caseAssignedSLA = caseRecord.Assigned_SLA__c;
        isTSNCase=(c.recordtypeid==Utilities.getCaseTSNRecordTypeId());
        
        if(ApexPages.CurrentPage().getparameters().get('isLink')==null)
           isLink = false;
        else
           isLink = true;
        System.debug('is link >>>'+islink) ;  

    }
    
    public PageReference Save(){        
        // 11/13 Manju - US9584 - Added condition to exclude Admin profile for Owner re-assignment check
        String adminProfileID = (String) Id.valueOf(pid.Cisco_ADMIN__c);
        if((profileId != Utilities.getTSNProfileId() && profileId != adminProfileID) &&  c.recordtypeId==Utilities.getCaseTSNRecordTypeId())
        {  
          apexPages.message msg = new ApexPages.message(ApexPages.severity.ERROR,'You cannot reassign case because you do not belong to Cisco_Sales_Cases Profile');
          apexPages.addmessage(msg);            
        }
        
        else if(c.recordtypeId==Utilities.getCaseTSNRecordTypeId() && caseStatus == 'Closed')
        {
            apexPages.message msg = new ApexPages.message(ApexPages.severity.ERROR,'You cannot reassign a closed case');
            apexPages.addmessage(msg);
        } 
        else if(c.recordtypeId==Utilities.getCaseTSNRecordTypeId() && caseAssignedSLA == null)
        {
                        apexPages.message msg = new ApexPages.message(ApexPages.severity.ERROR,'Please edit the record and enter Assigned SLA.');
                        apexPages.addmessage(msg);
        }
        // Nishi -- Commented the method calling to prevent owner check for TSN cases
        /*else if(!(c != null && c.ownerId != null && ((String)c.ownerId).contains('00G'))&& ([select count() from groupMember where groupId in (select id from group where name=:c.Team__c) and userorgroupId=:c.ownerId ] == 0)&& c.recordtypeId==Utilities.getCaseTSNRecordTypeId())
        {
            apexPages.message msg = new ApexPages.message(ApexPages.severity.ERROR,'User does not belong to the selected group');
            apexPages.addmessage(msg);   
        }*/
 
        else{
            try {      
                 System.debug('skipValidation >>>>'+isLink);
                 if(!isLink){
                        Utilities.setValidationSkip(true);
                  }
                   update c;
                   return new PageReference('/' + ApexPages.CurrentPage().getparameters().get('id'));
                }
                   catch(Exception e){
                   apexPages.addMessages(e);
                   return null;
                }
            }
            return null;
    }
}