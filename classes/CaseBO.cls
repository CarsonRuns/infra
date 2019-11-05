/************************************************************************************************************************************
Name    : CaseBO
Author  : Sournaga
Purpose : Contains logic for all case triggers 
Created Date:  7/6/2015
Modification History: Initial implementation.
1 DE10169 03/13/2016 - Fix the Apex.DmlException for null Opportunity value on insert for OpportunityTeamMember
2 WR-01626 03/13/2016 - Updated the BusinessHour login for 6hrs SLA value
3 US257804 - 12/19/18- mkella- To update CCW Deals Quotes Section of GVE and TSN Cases if it has Opportunity and Integrated Quote= Yes Associated to it.
4 US295185 - 4/19/19 - mkella- To Update Case Accepted Date Time field for CIC record types after insert
5 DE254003 - 8/5/2019 -Kavya - case SLA Logic needs to be checked when case is assigned to queue
*************************************************************************************************************************************/

public class CaseBO{

     // SCAVA Helper Method to validate Create Access at field level
    public static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }

       // SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdateGet(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }

    public static Map<Id,Group> groupIdToGroupObjectMap=null;
    public static BusinessHours busHours = null;
    
    /*
     *arguments: groupId
     *return : groupName (String)
     */
   @TestVisible static String getGroupName(Id groupID)
    {
        if(groupIdToGroupObjectMap != null && groupIdToGroupObjectMap.get(groupID)!=null) 
           return groupIdToGroupObjectMap.get(groupID).name;
        return null;
    }
          
    /* Method prevents closing of parent cases when they have child cases still open */  
    public static void TSN_PreventParentCloseWhenChildOpen (List<Case> cs){
        Set<String> setOfCaseIds=new Set<String>(); 
        Set<String> setOfParentIds=new Set<String>(); 
        setOfCaseIds.clear();
        for(Case c:cs)
        {
            if(c.recordtypeId ==Utilities.getCaseTSNRecordTypeId())
            {
                if(Trigger.isUpdate &&((c.status=='Closed')||(c.status=='Resolved Pending' && c.Status_Reason__c=='Resolved Successfully')))
                {
                    setOfCaseIds.add(c.id); 
                }
                if(c.parentId !=null)
                    setOfParentIds.add(c.parentId);
            }
        }
        List<Case> listOfChildCases;
        //get the list of open child cases from parent case IDs
        if(setOfCaseIds !=null && (!setOfCaseIds.isEmpty()))
        {
            listOfChildCases=[select id,parentId from case where status!='Closed' and parentId in :setOfCaseIds];
        }
        Map<Id,Case> parentIdToChildCaseMap=new Map<Id,Case>();
        //Populate a map Child cases & Parent Case Id
        if(listOfChildCases != null){
            for(Case childcase:listOfChildCases){
                parentIdToChildCaseMap.put(childcase.parentId,childcase);
            }
        }
        List<Case> listOfParentCases;
        //prevent child cases being selected as parent cases
        if(setOfParentIds!=null && (!setOfParentIds.isEmpty()))
        listOfParentCases=[select id,parentId from case where id in :setOfParentIds];
        Map<Id,Id> idToParentIdMap=new Map<Id,Id>();
        if(listOFParentCases!=null){
            for(Case parentCase:listOfParentCases){
                idToParentIdMap.put(parentCase.id,parentCase.parentId);
            }
        }
   
        for(Case c:cs)
        {   //display error when trying to close a parent case with open child cases
            if(c.recordtypeId ==Utilities.getCaseTSNRecordTypeId())
            {
                Case childCase=parentIdToChildCaseMap.get(c.id);
                //display error when trying to close a parent case with open child cases
                if(childCase != null)
                {
                    c.addError(Label.Case_Parent_Close_Error);
                }
                //display error when trying to child case is being selecte as parent case 
                Id parentId=idToParentIdMap.get(c.parentId);
                if(parentId != null)
                {
                    c.addError(Label.Case_Child_Error);
                }
            }
        }
         
    }    
    
    //update contact, account based on ccoID
    public static void UpdateAccountContactByCCOIdContactSearch (List<Case> cs){
        Set<Id> CaseIds = new Set<Id>();
        if(!cs.isEmpty() && cs.size() == 1){
                case c = cs[0];
                if(c.Web_CCO_ID__c != null && c.Web_CCO_ID__c != '' && c.Origin =='Web' &&((c.recordTypeId==Utilities.getCaseTSNRecordTypeId()&& (c.suppliedemail!= null && c.suppliedEmail !='') && !c.suppliedemail.contains('@cisco.com')) ||c.recordTypeId==Utilities.getCasePDIRecordTypeId()|| c.recordTypeId==Utilities.getCasePHRecordTypeId()))         
                {

                    String CCO_Like = '%' + c.Web_CCO_ID__c + '%';
                    Contact [] PartnerContact = [Select Id, CCO_ID__c, AccountId ,email,MailingCountry ,RecordTypeId 
                                                        From Contact 
                                                        Where CCO_ID__c like :CCO_Like 
                                                        and ContactStatus__c != 'Inactive' 
                                                        and Recordtypeid In (:Utilities.getContactManualPartnerRecordTypeId(),:Utilities.getContactPDBContactRecordTypeId())order by Recordtypeid desc Limit 25000];
                        
                    Case caseToUpdate = new Case(Id=c.Id);
                    Boolean emailValueSet=false,match = false,WebCCOIdMatch=false;

                    //Additional logic as part of TSN June Release
                    //If multiple contacts having the same cco id & same emails, then search will be based on ccoid search and then email id.And the case should populate the respective contacts on the case.
               
                    if(!PartnerContact.isEmpty())
                    {
                        for(Contact cntct:partnerContact)
                        {
                            Set<String> setOfCCOIds=new Set<String>(cntct.CCO_ID__c.split(',',-2));
                            if(setOfCCOIds.contains(c.Web_CCO_ID__c))
                            {
                                match=true;
                                if(!emailValueSet && !WebCCOIdMatch)
                                {
                                        if(cntct.RecordTypeId == Utilities.getContactPDBContactRecordTypeId()){
                                             if(flsUpdateGet(Case.Country__c)){  //SCAVA FIX                              
                                            caseToUpdate.Country__c = cntct.MailingCountry; 
                                             }
                                        }
                                        if(flsUpdateGet(Case.CCO_ID_Search_Result_Rich__c)) { //SCAVA FIX 
                                        caseToUpdate.CCO_ID_Search_Result_Rich__c='Web Entered CCO ID: <b> ' + c.Web_CCO_ID__c + '</b> and Contact identified';
                                        }
                                        if(flsUpdateGet(Case.ContactId)){  //SCAVA FIX
                                        caseToUpdate.ContactId=cntct.Id;
                                        }
                                        if(flsUpdateGet(Case.AccountId))  {//SCAVA FIX
                                        caseToUpdate.AccountId=cntct.AccountId;                             
                                        }
                                        WebCCOIdMatch = true;
                                }
                                if(c.suppliedEmail == cntct.email)
                                {
                                    System.debug('Contacts >>>>'+cntct); 
                                    if(cntct.RecordTypeId == Utilities.getContactPDBContactRecordTypeId()){                              
                                        caseToUpdate.Country__c = cntct.MailingCountry; 
                                    }
                                    caseToUpdate.CCO_ID_Search_Result_Rich__c='Web Entered CCO ID: <b> ' + c.Web_CCO_ID__c + '</b> FOUND <br/>Contact Web Email: <b> ' + c.SuppliedEmail + '</b> identified';                               
                                    emailValueSet=true;
                                    caseToUpdate.ContactId=cntct.Id;
                                    caseToUpdate.AccountId=cntct.AccountId;
                                    break;
                                }
                            }
                        }               
                    }         
                    if(!match && c.ContactID == null)
                        caseToUpdate.CCO_ID_Search_Result_Rich__c='Web Entered CCO ID: <b> ' + c.Web_CCO_ID__c + '</b> NOT FOUND <br/>Contact Web Email: <b> ' + c.SuppliedEmail + '</b> NOT FOUND';
                    else if(!match && c.ContactID != null)        
                        caseToUpdate.CCO_ID_Search_Result_Rich__c='Web Entered CCO ID: <b> ' + c.Web_CCO_ID__c + '</b> NOT FOUND <br/>Contact Web Email: <b> ' + c.SuppliedEmail + '</b> identified';
                    if(flsUpdateGet(Case.CCO_Search_Result_Updated__c)){  //SCAVA FIX
                    caseToUpdate.CCO_Search_Result_Updated__c = true;
                    }
                    Utilities.setValidationSkip(true);
                    update caseToUpdate;
                     
                }        
                else if(c.recordTypeId == Utilities.getCaseTSNRecordTypeId()&& (c.suppliedemail!= null && c.suppliedEmail !='') && (c.Web_CCO_ID__c != null && c.Web_CCO_ID__c != '')&& c.suppliedemail.contains('@cisco.com') && c.Origin =='Web')
                {      
                    CaseIds.add(c.Id);  
                }
                else if(c.OwnerId == Utilities.getCaseManagementUserId() && (c.suppliedEmail!= null && c.suppliedEmail !='') && (c.Web_CCO_Id__c== null || c.Web_CCO_Id__c =='') && !c.suppliedEmail.contains('salesforce.com')&& !c.suppliedEmail.toUpperCase().contains('MAILER-DAEMON') )
                {         
                    CaseCloseEmailBounce.sendReplyForDeletedCases(c.suppliedEmail,c.subject,c.description.replaceall('\n','<br/>'));
                }                        
              
        }
        if(!CaseIds.isEmpty()) TSNFetchCECIdSearchResult.doCECIdSearch(CaseIds);
    }
    
    public static void setCaseBusinessHours(List<case> cs, BusinessHours busHrs){
        DateTime createdTime;
        for(case c:cs){
            if(Trigger.isInsert){
                 createdTime = System.now();
            }
            if(Trigger.isUpdate){
                 createdTime = c.CreatedDate;
        
            }
            if(c.Assigned_SLA__c == '4 hr') {
                c.GREEN_SLA_Time__c = BusinessHours.addGmt(busHrs.id, createdTime , 3 * 60 * 60 * 1000L);
                c.RED_SLA_Time__c = BusinessHours.addGmt(busHrs.id, createdTime , 4 * 60 * 60 * 1000L);
                 system.debug('SLA green & red'+BusinessHours.addGmt(busHrs.id, createdTime , 3 * 60 * 60 * 1000L)+BusinessHours.addGmt(busHours.id, createdTime , 4 * 60 * 60 * 1000L));
            }
            if(c.Assigned_SLA__c == '24 hr') {
                c.GREEN_SLA_Time__c = BusinessHours.addGmt (busHrs.id, createdTime , 18 * 60 * 60 * 1000L);
                c.RED_SLA_Time__c = BusinessHours.addGmt(busHrs.id, createdTime , 24 * 60 * 60 * 1000L);
            }
            if(c.Assigned_SLA__c == '48 hr') {
                c.GREEN_SLA_Time__c = BusinessHours.addGmt (busHrs.id, createdTime , 36 * 60 * 60 * 1000L);
                c.RED_SLA_Time__c = BusinessHours.addGmt(busHrs.id, createdTime , 48 * 60 * 60 * 1000L);
            }
            //WR-01626 - Added the 6hr login. Using the min*sec instead of hr*min*sec.
            if(c.Assigned_SLA__c == '6 hr') {
                c.GREEN_SLA_Time__c = BusinessHours.addGmt (busHrs.id, createdTime , 270 * 60 * 1000L);
                c.RED_SLA_Time__c = BusinessHours.addGmt(busHrs.id, createdTime , 6 * 60 * 60 * 1000L);
           }
           //WR-0841 - Added the 1hr login. Using the min*sec instead of hr*min*sec.
            if(c.Assigned_SLA__c == '1 hr') {
                c.GREEN_SLA_Time__c = BusinessHours.addGmt (busHrs.id, createdTime , 45 * 60 * 1000L);
                c.RED_SLA_Time__c = BusinessHours.addGmt(busHrs.id, createdTime , 1 * 60 * 60 * 1000L);
            }
        } 
    }
    
    public static BusinessHours getBusinessHours(){
       return  [select ID from BusinessHours where Name = 'TSN_SLA' limit 1]; 
    }
    
    //check if the user has persmission to delete the case
    public static void caseBeforeDelete(List<case> cs){
        for(Case c: cs){
            //do not allow non super users to delete the case
            System.debug('USER ID RETURNS#### '+Utilities.getCaseDeleteUserIds(UserInfo.getuserId()));
            System.debug('USER ID RETURNS#### '+Utilities.getSuperProfile(UserInfo.getProfileId()));
            if(!(Utilities.getSuperProfile(UserInfo.getProfileId()) || Utilities.getCaseDeleteUserIds(UserInfo.getuserId())))
                c.adderror(Label.Case_Delete_Error);         
        }
    }
    
    //Route web cases
    public static void RouteWebCases(List<case> cs){
        List<case> TSNRouteCases = new List<case>();
        List<case> PDIRouteCases = new List<case>();
        List<case> PHRouteCases = new List<case>();
        
        for(case c:cs){
            if(c.Web_CCO_ID__c != null && c.Web_CCO_ID__c !='') //case created by web
            {
                if(c.recordtypeId ==Utilities.getCasePHRecordTypeId())
                {          
                    PHRouteCases.add(c);
                }       
                else if(c.recordtypeId ==Utilities.getCaseTSNRecordTypeId())
                { 
                    TSNRouteCases.add(c);
                }
                else if(c.recordTypeId==Utilities.getCasePDIRecordTypeId())
                {
                    PDIRouteCases.add(c);
                }         
            }   
        }
        
        if(!PHRouteCases.isEmpty()) RouteWebCase.updatePHCase(PHRouteCases);
        if(!TSNRouteCases.isEmpty()) RouteWebCase.updateTSNCase(TSNRouteCases);
        if(!PDIRouteCases.isEmpty())RouteWebCase.updatePDICase(PDIRouteCases);
    }
    
    //update contact and entitlement flags on case
    public static void updateCaseFlags(List<case> cs){
        List<user> usrLst = new List<user>();
        List<String> ciscoContactLst = new List<String>();
        Map<Id,Contact> contactMap;
        Set<Id> ContactIds = new Set<Id>();
        Map<Id,Account> accountMap ;   
        boolean checkBox = false;
        Set<Id> AccountIdSet = new Set<Id>();
        Map<ID, ID> ownerID_optyID_Map = new Map<ID, ID>();
        Map<Id,Id> CaseIdContactId = new Map<Id,Id>();
        Map<Id,Id> CaseIdToAccountIdMap = new Map<Id,Id>();
        Map<string,string>userContactMap = new Map<string,string>();
        boolean isCiscoTSNProfileUser=(UserInfo.getProfileId() == Utilities.getTSNProfileId());
         //disable validations
        if(Utilities.getValidationSkip()){
            checkBox = true;
        } 
        for(Case c:cs){
            Boolean ownerFlag =((String)c.OwnerId).startsWith('00G');
             c.skipValidations__c = checkBox;
            //case requestor field update
            if(c.Cisco_Contact__c!= null && c.Cisco_Contact__c !='')
            {                        
                ciscoContactLst.add(c.Cisco_Contact__c);
            }                                        
                        
            if(c.recordtypeId ==Utilities.getCaseTSNRecordTypeId())
            {   
                if(c.contactId ==null){
                    c.Partner_Entitlement_Flags__c ='';
                    c.Contact_Flags__c='';                              
                }
                if(c.AccountId ==null){
                    c.Account_Flags__c='';  
                }
            }  
            
            if(Trigger.isInsert){
                //case accepted by engineer field update
                if(c.recordTypeId==Utilities.getCaseTSNRecordTypeId()){
                    if(!(c.Case_Accepted_By_Engineer__c)&& isCiscoTSNProfileUser && c.Team__c != 'Front Line'){
                        c.Case_Accepted_By_Engineer__c=true;
                        c.Case_Accepted_Date_Time__c = Datetime.now();                              
                    }                
                            
                    //Add CaseOwner As OptyTeam owner-opp map              
                    if(!ownerFlag)
                    {        
                        //DE10169 - Added the null check to make sure map doesn't have an empty value for Opportunity.
                        if(c.Opportunity__c != null || c.Opportunity__c != '') {
                            ownerID_optyID_Map.put(c.OwnerID, c.Opportunity__c);
                        }
                    }
                    
                    //update case contact flags
                    if(c.contactId !=null)
                    {
                        CaseIdContactId.put(c.Id,c.contactId);
                        ContactIds.add(c.contactId);
                    } 
                    
                    //update account flags on case
                    if(c.AccountId !=null)
                    {
                        CaseIdToAccountIdMap.put(c.Id,c.AccountId);
                        AccountIdSet.add(c.AccountId);
                    }           
                }
                //mkella - Start changes for US295185
                 //case accepted by engineer field update for CIC type of cases
                /* else if(c.recordTypeId==ObjectRecordTypeIds__c.getInstance().Case_CIC_RecordType__c){
                     if(!(c.Case_Accepted_By_Engineer__c)){
                            c.Case_Accepted_By_Engineer__c=true;
                            c.Case_Accepted_Date_Time__c = Datetime.now();  
                     }
                		}*/
                //mkella - End changes for US295185
            }
                        
            if(Trigger.isUpdate){
                Case oldCase= (Case)Trigger.oldMap.get(c.id);
                if(c.recordTypeId==Utilities.getCaseTSNRecordTypeId()){
                    if(!c.Case_Accepted_By_Engineer__c)
                    {                        
                        boolean isOwnerChange=oldCase.ownerId!=c.ownerId;
                        boolean isOwnerIsUser=!((String)c.ownerId).startsWith('00G');
                                      
                        if(isOwnerChange && isOwnerIsUser)
                        {
                            c.Case_Accepted_By_Engineer__c=true;
                            c.Case_Accepted_Date_Time__c = Datetime.now();
                        }
                    }
                    //update contact flags on case if contact is changed
                    if(c.contactid!=null && 
                    (oldCase.contactid != c.contactId || oldCase.contact_type__c != c.contact_type__c ||oldCase.recordtypeid != c.recordtypeid))
                    {
                        CaseIdContactId.put(c.Id,c.contactId);
                        ContactIds.add(c.contactId);
                    }
                    //update account flags on case if account is changed 
                    if(c.AccountId!=null && 
                    (oldCase.Accountid != c.AccountId || oldCase.contact_type__c != c.contact_type__c ||oldCase.recordtypeid != c.recordtypeid ))
                    {
                        CaseIdToAccountIdMap.put(c.Id,c.AccountId);
                        AccountIdSet.add(c.AccountId);
                    }
                    
                }
                 //Kavya - changes for DE254003
                
                else if(c.recordTypeId==ObjectRecordTypeIds__c.getInstance().Case_CIC_RecordType__c){
                    //if owner is user (not queue) then only set Case_Accepted_Date_Time__c
                    Schema.SObjectType sobjectType = c.OwnerId.getSObjectType();
                    String sobjectName = sobjectType.getDescribe().getName();
                    system.debug('sobject name Kavya'+sobjectName);
                    boolean isOwnerChange=oldCase.ownerId!=c.ownerId;
                    if(!(c.Case_Accepted_By_Engineer__c) && sobjectName.equalsIgnoreCase('User') && isOwnerChange){
                        c.Case_Accepted_By_Engineer__c=true;
                        c.Case_Accepted_Date_Time__c = Datetime.now();
                    }
                }
                
                // ends here
            }
        }        
        
        if(!ciscoContactLst.isEmpty())
        {           
            usrLst=[Select Id,Username from User where Username IN :ciscoContactLst];           
            for(User u: usrLst)
            {               
                userContactMap.put(u.username,u.id);
            }
        }        
                
        if(!CaseIdContactId.isEmpty())
        {
            contactMap =  new Map<Id,Contact>([Select Id, Contact_Flags__c,TSN_Contact_Entitlement__c from contact where Id IN :ContactIds]);
        }
        if(!CaseIdToAccountIdMap.isEmpty())
        {
            accountMap =  new Map<Id,Account>([Select Id, Account_Flags__c from account where Id IN :AccountIdSet]);                      
        }
        if (!ownerID_optyID_Map.isEmpty())
        {  
            TSN_Add_CaseOwner_As_OptyTeam.TSN_Add_Opty_team_insert(ownerID_optyID_Map);
        } 
                
        for(Case c:cs ){
            if(!userContactMap.isEmpty() && (c.Cisco_Contact__c!= null && c.Cisco_Contact__c !='')){
                //update case requestor 
                c.Case_Requester__c=userContactMap.get(c.Cisco_Contact__c);
            }
                    
            if(CaseIdContactId.get(c.id) != null ){    
                c.Contact_Flags__c  = contactMap.get(c.contactId).Contact_Flags__c; 
                c.Partner_Entitlement_Flags__c = contactMap.get(c.contactId).TSN_Contact_Entitlement__c; 
            }
                    
            //update case account flags
            if(CaseIdToAccountIdMap.get(c.id) != null ){    
                c.Account_Flags__c  = accountMap.get(c.AccountId).Account_Flags__c;                              
            }   
        }
    }
    
    //invoke webservice for vcpdbupdate
    public static void VcPDBUpdate(List<case> cs){
        List<String> paUsedLst = new List<String>();
        Set<String> paUsedSet = new Set<String>();
        String paUsed = Utilities.getConstant_CS('PAUsed');
        Set<Id> AccountIds = new Set<Id>();
        if(VcPDBUpdateServiceInvoke.getPermission() == 1 && !Utilities.getskipFuture()){
                
            if(paUsed != null && paUsed.length() > 0 )
            {
                paUsedLst = paUsed.split(';');
                paUsedSet.addAll(paUsedLst);
            }

            for(Case c:cs ){
                if(c.RecordTypeId == Utilities.getCasePARecordTypeId() && (paUsedSet.contains(c.Interaction_Type__c)))
                {
                    AccountIds.add(c.AccountId);
                }                    
            }   
            if(!AccountIds.isEmpty())
            {
                VcPDBUpdateServiceInvoke.CallPdbUpdateService(AccountIds,System.Today());  
            }
        }
    }
    
    //update opportunity team & status change history object
    public static void CaseOwnerOptyTeamAndCaseStatusHistoryUpdate(List<case> cs){
        Utilities.createTransactionKey('StatusChanged','false');
        boolean isValidstatus = false;
        ID[]  caseId  = new ID[]{};
        List<Case_Status_History__c> csh = new List<Case_Status_History__c>();
        if(Utilities.getTransactionKeyValue('StatusChanged') == 'false'){
            Utilities.setTransactionKeyValue('StatusChanged','true');
            isValidstatus = true;
        }
    
        for(Case c :cs ) {
            String record_type =((String)c.recordtypeId).substring(0,15);              
            Boolean ownerFlag = ((String)c.OwnerId).startsWith('00G');
            Case oldCase= (Case)Trigger.oldMap.get(c.id);
            
            //Checking case recordtype is of TechnologySolutionNetworkPartnerHelpline or Proposal Expert Services and if Owner is not a Queue and if Old case owner is not equal to Current case Owner
            if(((record_type == Utilities.getCaseTSNRecordTypeId()|| record_type == Utilities.getRequestPXSRecordTypeId())
                && !ownerFlag) 
                && ((oldCase.OwnerId != c.OwnerId && c.OwnerId!=Null && c.Opportunity__c !=Null)
                || (oldCase.Opportunity__c != c.Opportunity__c && c.Opportunity__c!=Null ))){                                     
                
                    caseId.add(c.ID);
                }
            if(c.Status != oldCase.Status && oldCase.Status != null && isValidstatus){                   
                Datetime d = c.Status_Change_Date_Time__c;
                if(d  == null){
                    d  = c.CreatedDate;
                }
                Case_Status_History__c temp = new Case_Status_History__c();
                //SCAVA FIX
               if(flsGet(Case_Status_History__c.Case__c))
                {
                temp.Case__c=c.Id;
                }
                // SCAVA FIX , Oct 16th 2018
                if(flsGet(Case_Status_History__c.Name)){ 
                temp.Name=oldCase.Status + ' to ' + c.Status ;
                }
                // SCAVA FIX , Oct 16th 2018
                if(flsGet(Case_Status_History__c.New_Value__c)){ 
                temp.New_Value__c=c.Status;
                }
                // SCAVA FIX , Oct 16th 2018
                if(flsGet(Case_Status_History__c.Old_Value__c)){  
                temp.Old_Value__c=oldCase.Status;
                }
                // SCAVA FIX , Oct 16th 2018
                if(flsGet(Case_Status_History__c.Old_Value_Date_Time__c)){  
                temp.Old_Value_Date_Time__c=d;
                }
                // SCAVA FIX , Oct 16th 2018
                if(flsGet(Case_Status_History__c.User__c)){ 
                temp.User__c=UserInfo.getUserId();
                }
                csh.add(temp);                    
             }   
        }
                
        if (!caseId.isEmpty())
        {  
            TSN_Add_CaseOwner_As_OptyTeam.TSN_Add_Opty_team(caseId);
        }            
               
        if(!csh.isEmpty()){
            try{
                Insert csh;                    
            }
            catch(exception e){
                //call ExceptionUtilities to store exception in exception object
                ExceptionUtilities ex = new ExceptionUtilities();
                ex.insertException(e,'Case_Status_History__c');
                system.debug('Case History Exception :: '+e.getMessage());
            }
        }   
    }
    
    //insert case SLA business hours
    public static void insertCaseBusinessHours(List<Case> cs){        
        List<case> caseSLALst = new List<case>(); 
        if(busHours == NULL){           
                  busHours = getBusinessHours();            
        }
        for(Case c:cs){
            if((c.recordTypeId == Utilities.getCaseTSNRecordTypeId()) && busHours != NULL) {
                caseSLALst.add(c);
            }
        }
        if(!caseSLALst.isEmpty())
        {            
            setCaseBusinessHours(caseSLALst,busHours);
        }
    }
    
    //update case SLA business hours
    public static void updateCaseBusinessHours(Map<id,sobject> oldAccMap, List<Case> cs){        
        List<case> caseSLALst = new List<case>(); 
          if(busHours == NULL){         
                  busHours = getBusinessHours();            
        }
        //update SLA
        for(Case c:cs){
            Case oldCase= (Case)Trigger.oldMap.get(c.id);
            if( (c.recordTypeId == Utilities.getCaseTSNRecordTypeId())&& busHours != NULL && 
            ((oldCase.Assigned_SLA__c == null || oldCase.Assigned_SLA__c == '') && (c.Assigned_SLA__c != null || c.Assigned_SLA__c != '')))
            {
                caseSLALst.add(c);
            }
        }
        if(!caseSLALst.isEmpty())
        {           
            setCaseBusinessHours(caseSLALst,busHours);
        }
    }
    
    //update child contact from parent case owner
    public static void updateChildContactDetails(List<case> cs){
        Map<Id,Case> mapOfParentCases;
        Set<String> setOfParentCaseIds=new Set<String>();
        for(Case c:cs){
            if(c.recordtypeId ==Utilities.getCaseTSNRecordTypeId() && c.parentID!=null)
            {   
                setOfParentCaseIds.add(c.ParentId); 
            }
        }
        
        if(!setOfParentCaseIds.isEmpty())
        {
            mapOfParentCases = new Map<Id,Case>([select id,ownerId,owner.email from Case where id in :setOfParentCaseIds]);
        }
        
        for(Case c:cs){
            if(mapOfParentCases!=null && !mapOfParentCases.isEmpty()){
                if((c.recordtypeId ==Utilities.getCaseTSNRecordTypeId())&&(c.parentId!=null)){
                    Case parentCaseRecord=mapOfParentCases.get(c.parentId);
                    String email='';
                    if(parentCaseRecord != null && parentCaseRecord.ownerId != null){
                        email=((String)parentCaseRecord.ownerId).substring(0,3)!='00G'?parentCaseRecord.owner.email:'';
                    }
                    c.Cisco_Contact__c=email;
                    c.Cisco_Contact_Name__c='';
                    c.Cisco_Contact_Title__c='';
                    c.Cisco_Contact_Organization__c='';
                    c.Cisco_Contact_Work_Phone_Number__c='';
                    c.Cisco_Contact_Internal_Phone_Number__c='';       
                    c.Cisco_Contact_Mobile_Number__c='';       
                    c.Cisco_Country__c='';            
                } 
            }           
        }
    }
    
    //Generate Spark Room Message for Tracked Spark Fields
    public static void sendUpdateToSparkRoom(Map<id,sobject> oldAccMap, List<Case> cs)
    {
        if (cs.size() < = 5){
            String sparkId;
            String convoId; 
            String roomMessage = '';
            String userName    = UserInfo.getName();
    
            /* get entire list of available fields on the case */
            list<String> globalTriggers                  = new list<String>{};
            list<Spark_Conversation__c> updateTriggers   = new list<Spark_Conversation__c>();
            Set<ID> caseIds                              = new Set<ID>(); 
            
            /* Get the list of Case Id's that are changing */
            for(Case eachCase:cs)
            {
                caseIds.add(eachCase.id);
            }
            
            /* Get entire list of available fields on the Case. This will be used to
            * compare the globally configured triggers to all fields, to determine changing
            * field names. */
            Map<String, Schema.SObjectField> o = Schema.SObjectType.Case.fields.getMap();    
            Map<String, String> apiNameToLabel = new Map<String, String>();

            
            /* Assign API field label names to display pretty names in room messages. */
            for(String fieldName : o.keySet())
            {
                apiNameToLabel.put(fieldName, o.get(fieldName).getDescribe().getLabel());
            }
            
            Map<String, Spark_Conversation__c> roomList = new Map<String,Spark_Conversation__c>();
       
            for(Spark_Conversation__c  convo:[SELECT id, Spark_Id__c,TriggerFields__c,ObjectId__c from Spark_Conversation__c where ObjectId__c in :caseIds ])
            {
                roomList.put(convo.ObjectId__c,convo);
            }
            
            /* if at leat one room exists, and global triggers list is not 
             * yet populated, then run the global trigger query */
            if (!roomList.isEmpty() && globalTriggers.isEmpty())
            {
                List<Spark_Config__c> config = [SELECT TriggerFields__c FROM Spark_Config__c limit 1];
                if (!config.isEmpty() && config[0].TriggerFields__c.length() > 2)
                {
                    globalTriggers = (List<String>) JSON.deserialize(config[0].TriggerFields__c,List<String>.class); 
                }
            }
  
            for(Case mo : cs)
            {
            
           /* If a spark room exists for the current iteration of the Case
            * run the trigger.
            */
            if (roomList.get(mo.id) != NULL)
            {            
            /* get Room Conversation Object for given Opportunity */
            Spark_Conversation__c roomObj = roomList.get(mo.id);
            sparkId = roomObj.Spark_Id__c;
            convoId = roomObj.Id;
        
            Map<String,String> roomTriggers = new Map<String,String>{};
        
            if (roomObj.TriggerFields__c != NULL && roomObj.TriggerFields__c.length() > 2)
            {
              roomTriggers = (Map<String,String>) JSON.deserialize(roomObj.TriggerFields__c,MAP<String,String>.class); 
            }
            
            Case oldCase = (Case)Trigger.oldMap.get(mo.id);
            /* Loop through our globally configured trigger list */
            for (String t : globalTriggers)
            {
                /* loop through all available object fields */
                for(String field : o.keyset())
                {
                    /* prepend object name, since global triggers are stored with object */
                    String fullFieldName = 'Case.' + field;
                    /* loop through fields in our global trigger list */
                    if (t == fullFieldName)
                    {
                        /* get field label for nice room message */
                        String fieldLabel   = apiNameToLabel.get(field);
                        /* define field values */
                        String oldValue     = String.ValueOf(roomTriggers.get(t));
                        String newValue     = String.valueOf(mo.get(field));
                        String oldCaseValue = String.valueOf(oldCase.get(field));
                        /* if local trigger value is empty, set old value to old case value */
                        if (oldValue == NULL)
                        {
                            oldValue = oldCaseValue;
                        }
                        system.debug('OUR OLD VALUE ' + oldValue + ' Our NEW Value ' + newValue + ' Our Old Opp Value ' + oldCaseValue);
                        /* Insert new Value into local trigger */
                        roomTriggers.put(t,newValue);
                        
                        if (oldValue != newValue)
                        {
                         
                            /* replace null values with 'None' to improve message
                             * quality and to void dereference errors */
                            if (oldValue == NULL)
                            {
                                oldValue = 'None';
                            }
                            String fieldMessage = 'The Case Field "' + fieldLabel + '" was updated by ' + userName + ', and has changed from '; 
                            String fieldEnding  =  oldValue + ' to ' + newValue + '\r\n';
                            if (oldValue.length() == 18 && oldValue.substring(0,3) == '005'){
                                List<User> triggerUsers = getUserNamesFromId(oldValue, newValue);
                            
                                String OldName; String NewName;
                                for (User u : triggerUsers)
                                {
                                    if (u.Id == oldCaseValue){
                                        oldName = u.Name;
                                    }
                                    if (u.Id == newValue){
                                        newName = u.Name;
                                    }
                                }
                            fieldEnding = oldName + ' to ' + newName + '\r\n';  
                            } 
                            /* Construct message for given field */                             
                            roomMessage  += fieldMessage + fieldEnding;
                            /* Clear set variables */
                            oldValue = null;
                            newValue = null;
                        } 
                    }
                }
            }

            String j = JSON.serialize(roomTriggers);
            
            Spark_Conversation__c thisConvo = new Spark_Conversation__c(Id=convoId);
            if(flsUpdateGet(Spark_Conversation__c.TriggerFields__c)){  //SCAVA FIX 
            thisConvo.TriggerFields__c = j;
            }
            updateTriggers.add(thisConvo);
            
            if (!Test.isRunningTest() && sparkId != null && roomMessage != '')
            { 
                Spark_Room_Controller.setRoomMessage(sparkId, roomMessage);
            }
            roomMessage = '';
        }
               
        } // end of Case for loop
        update updateTriggers;  
        }   
   
    }

    
    /* will be replaced by org cache in near future */
   @TestVisible private static List<User> getUserNamesFromId(String id1, String id2)
    {
        List<User> u = new List<User>();
        u = [select Id,Name from User where Id in (:id1, :id2)];
        return u;
    }
    
    //Change the recordtype to "Engage Resource status and owner" when record created through connection user
    public static void updateEngageCaseValues(List<case> cs){ 
        String cntId=Utilities.getConstant_CS('ConnectionUserId');
        if(cntId!= 'NA'){           // Added By Naresh(nkalahas@cisco.com) To check the connection user while creating case from  email to case
        for(Case c:cs){
            if(c.createdbyid==cntId && c.isEngageNew__c){
                 Case oldCase= (Case)Trigger.oldMap.get(c.id) ;  
                 c.status=oldCase.status;
                 c.ownerid=oldCase.ownerid;
                 c.isEngageNew__c = false;
            }
        }
       } 
    } 
    //Validation for duplicate ER Case
    public static void ercaseValidation (List<Case> cs){
    System.debug('## Trigger.New ## '+cs);
        List<Id> OptyIdList = new List<Id>(); 
        Map<Id,Case> erCaseMap = new Map<Id,Case>();
        List<Case> erCaseList = new List<Case>();
        ObjectRecordTypeIds__c objRecordTypeSetting = ObjectRecordTypeIds__c.getOrgDefaults();
        for(Case each : cs){
            if(each.RecordTypeid==objRecordTypeSetting.Engage_Services_Resources__c){
              OptyIdList.add(each.Opportunity__c);
           }
        }
        
        if(Test.isRunningTest()){
            erCaseList = null;
        }else{
            erCaseList = [select Id, Subject,RecordTypeId,createddate,lastmodifiedDate, Opportunity__c from Case where Opportunity__c IN : OptyIdList AND RecordTypeId=:objRecordTypeSetting.Engage_Services_Resources__c];
        }
     
        if(erCaseList != null){
            for(Case each : erCaseList ){
                erCaseMap.put(each.Opportunity__c , each);
            }
            
            for(Case each : cs){
                if(erCaseMap.get(each.Opportunity__c) != null && each.RecordTypeid==objRecordTypeSetting.Engage_Services_Resources__c){
                     If(each.Id !=erCaseMap.get(each.Opportunity__c).Id ){
                        each.addError('ER Case already exists for this Opportunity. You cannot create multiple ER Case, please edit the existing Case.');
                     }
                }
            }
        }

    }
    
     public static void updateErcaseAfter(List<Case> cs){
        System.debug('## Trigger.New updatecaseNumberTxt## '+cs);
        List<Case> erCaseList = new List<Case>();
        ObjectRecordTypeIds__c objRecordTypeSetting = ObjectRecordTypeIds__c.getOrgDefaults();
        
        for(Case each : cs){
           // SCAVA fix to check fls
           if(each.AS_Created_By__c=='Connection User' &&  flsUpdateGet(Case.Description)){
                Case caux  = new Case(Id = each.Id);
                caux.Description= each.Description + '.';
                erCaseList.add(caux); 
            }
        }
        if(!erCaseList.isEmpty()){
            try{
            system.debug('erCaseList before updating'+erCaseList);
            update erCaseList;
    
            }catch(exception e){
    
            }
        }       
        
     }
    
//US257804 - Manikant Kella- Date: 12/19/18- Creating new method for updating CCW Deals Section of the GVE and CWR case types, if the case has opportunity and quotes associated to it.

    public static void updateCaseCCWDealsSection(List <case> cs){
        try{
            //create new empty case list to store case details based on 1st for loop if conditions
            List<Case> caseList= new List<Case>();
            //create new set of id's to store oppty id based on 1st for loop if conditions
            Set<Id> optyIdSt = new Set<Id>();
            // create new set of id's to store oppty id and remove from optyIdSt if CCW Deal Quote record id is present for opty
            Set<Id> optyIdSt1 = new Set<Id>();
            // create new map for opty id and case id in 2nd for loop- key opty id and value case id
            Map<Id, Id> mapOptyIDCaseID = new Map<Id,Id>();
            // create new set of id's to store case id based on 1st for loop
            Set<Id> caseIdSt = new Set<Id>();
            // get case id's for 2nd for loop
            for (Case newCase : cs){
          caseIdSt.add(newCase.id);
      }
            //System.debug('Case Id: '+ caseIdSt);
            // run through all newly inserted case lists 
        for(Case c: [SELECT id,recordTypeId,Opportunity__c,Opportunity_Deal_ID__c,CCW_Deal_or_Quote__c,Opportunity__r.Quote_Count__c,CaseNumber FROM CASE WHERE id IN: caseIdSt]){
            // check if case belongs to GVE and CWR case record types and it has oppty and Quotes under that oppty
            if((c.recordTypeId == Utilities.getCaseTSNRecordTypeId() || c.recordTypeId == Utilities.getCaseWarRoomRecordTypeId()) && c.Opportunity__c != null && c.Opportunity_Deal_ID__c != null && c.Opportunity__r.Quote_Count__c >= 1){
                //add case details to caseList
                caseList.add(c);
                // add oppty id to optyIdSt
                optyIdSt.add(c.Opportunity__c);
                //System.debug(c);
                // add opty id and case id to mapOptyIDCaseID
                mapOptyIDCaseID.put(c.Opportunity__c,c.id);
            }
        }
            //System.debug('Filtered Condition Case: '+caseList);
            if(!caseList.isEmpty()){
                Map <Id, Id> mapCaseIdCCWId = new Map<Id, Id>();
                // get CCW Deal Record Id's present and already associated with Oppty
                for (Multi_Object_Quote__c existingCCWRecordID : [SELECT id, Opportunity_Name__c FROM Multi_Object_Quote__c WHERE Opportunity_Name__c IN: optyIdSt]){
                    mapCaseIdCCWId.put(mapOptyIDCaseID.get(existingCCWRecordID.Opportunity_Name__c),existingCCWRecordID.id);
                    optyIdSt1.add(existingCCWRecordID.Opportunity_Name__c);
                }
                
                //create map variable to map oppty and quote details based on 2nd for loop conditions
                Map <Id, Quote__c> mapOptyQuoteDetails = new Map<Id, Quote__c>();
                // remove id's present in optyIdSt1 from optyIdSt as oppty records has already have ccw records with it
                optyIdSt.removeAll(optyIdSt1);
                
                //if optyIdSt is not empty after removal
                if(!optyIdSt.isEmpty()){
                    
            
            // iterate over Quote object and gather all quotes where id's are in optyIdSt and Integrated_Quote='Yes'
            for(Quote__c quoteInfo : [SELECT id,Opportunity_Name__c, Deal_ID__c, Integrated_Quote__C, DM_Quote_ID__c, Quote_Product_List_Amount__c,Quote_Service_List_Amount__c,Quote_Product_Net_Amount__c,
                                      Quote_Service_Net_Amount__c, Opportunity_Name__r.Expected_Product_List_Amount__c, Quote_Status__c, Opportunity_Name__r.ProgramName__c, Opportunity_Name__r.PromotionName__c,
                                      Opportunity_Name__r.Deal_Create_Date__c,Expiration_Date__c, Opportunity_Name__r.DD_Status__c, Opportunity_Name__r.Discount_Type__c FROM Quote__C WHERE Opportunity_Name__c IN: optyIdSt AND Integrated_Quote__c = 'Yes']){
                                             
                                             //add oppty id and quote details into mapOptyQuoteDetails
                                             mapOptyQuoteDetails.put(quoteInfo.Opportunity_Name__c, quoteInfo);
                                                 }
                }
                //System.debug('Quote Map Details: '+mapOptyQuoteDetails);
                // create new CCW Quote Object
            List<Multi_Object_Quote__c> multiCCWQuoteLst = new List<Multi_Object_Quote__c>();
            // new temperoray case list to store case details based on 3rd for loop
            List<Case> tempCaseLst = new List<Case>();
            // check if mapOptyQuoteDetails is not empty
            if(!mapOptyQuoteDetails.isEmpty()){
                //iterate over caseList
            for(Case details: caseList){
                // check if mapOptyQuoteDetails details contain relevant oppty id
                if(mapOptyQuoteDetails.containsKey(details.Opportunity__c)){
                    // check if associated quote value is not empty
                    if(mapOptyQuoteDetails.get(details.Opportunity__c)!= null){
                        // get relevant quote details of a case based on case oppty id
                      Quote__c quoteDetails = mapOptyQuoteDetails.get(details.Opportunity__c);
                     //Create new CCW Deal Quotes object record and assign newly created record id to above Case CCW_Deals_Quotes field where respective fields on Case obj are formula fields which 
                        //automatically fetches and places on case.
                        Multi_Object_Quote__c newCCWDealQuoteRecord = new Multi_Object_Quote__c();
                        //SCAVA fix to check fls
                        if(flsGet(Multi_Object_Quote__c.Deal_ID__c) && flsGet(Multi_Object_Quote__c.DM_Quote_ID__c) &&
                           flsGet(Multi_Object_Quote__c.Quote_Product_List_Amount__c) && flsGet(Multi_Object_Quote__c.Quote_Service_List_Amount__c) &&
                           flsGet(Multi_Object_Quote__c.Quote_Product_Net_Price__c) && flsGet(Multi_Object_Quote__c.Quote_Service_Net_Price__c) &&
                           flsGet(Multi_Object_Quote__c.Quote_Status__c) && flsGet(Multi_Object_Quote__c.Expected_Product_List_Amount__c) &&
                           flsGet(Multi_Object_Quote__c.Promotion_Name__c) && flsGet(Multi_Object_Quote__c.Program_Name__c) &&
                           flsGet(Multi_Object_Quote__c.Deal_Create_Date__c) && flsGet(Multi_Object_Quote__c.Deal_Expiration_Date__c) &&
                           flsGet(Multi_Object_Quote__c.Deal_Status__c) && flsGet(Multi_Object_Quote__c.Discount_Type__c)) {
                               newCCWDealQuoteRecord.Deal_ID__c = quoteDetails.Deal_ID__c;
                               newCCWDealQuoteRecord.DM_Quote_ID__c = quoteDetails.DM_Quote_ID__c;
                               newCCWDealQuoteRecord.Quote_Product_List_Amount__c = quoteDetails.Quote_Product_List_Amount__c;
                               newCCWDealQuoteRecord.Quote_Service_List_Amount__c = quoteDetails.Quote_Service_List_Amount__c;
                               newCCWDealQuoteRecord.Quote_Product_Net_Price__c = quoteDetails.Quote_Product_Net_Amount__c;
                               newCCWDealQuoteRecord.Quote_Service_Net_Price__c = quoteDetails.Quote_Service_Net_Amount__c;
                               newCCWDealQuoteRecord.Quote_Status__c = quoteDetails.Quote_Status__c;
                               newCCWDealQuoteRecord.Expected_Product_List_Amount__c = quoteDetails.Opportunity_Name__r.Expected_Product_List_Amount__c;
                               newCCWDealQuoteRecord.Promotion_Name__c = quoteDetails.Opportunity_Name__r.PromotionName__c;
                               newCCWDealQuoteRecord.Program_Name__c = quoteDetails.Opportunity_Name__r.ProgramName__c;
                               newCCWDealQuoteRecord.Deal_Create_Date__c = quoteDetails.Opportunity_Name__r.Deal_Create_Date__c;
                               newCCWDealQuoteRecord.Deal_Expiration_Date__c = quoteDetails.Expiration_Date__c;
                               newCCWDealQuoteRecord.Deal_Status__c = quoteDetails.Opportunity_Name__r.DD_Status__c;
                               newCCWDealQuoteRecord.Discount_Type__c = quoteDetails.Opportunity_Name__r.Discount_Type__c;
                           }
                        // add all info to multiCCWQuoteLst for insert DML operation
                        multiCCWQuoteLst.add(newCCWDealQuoteRecord);
                        // add relevant case details to tempCaseLst
                        tempCaseLst.add(details);
                        
                }
                }
        }
                // create new CCWDealQuote Records
          if(!multiCCWQuoteLst.isEmpty()){
          insert multiCCWQuoteLst;
                // counter to get index id of multiCCWQuoteLst
                Integer count = 0;
            for(Case caseInfo: tempCaseLst){
                // map newly created ccw deal record id to CCW_Deal_or_Quote__c of case then formula fields will pick up rest
                //caseInfo.CCW_Deal_or_Quote__c = multiCCWQuoteLst[count].id;
                //map mapCaseIdCCWId already created above - key:case id and value:ccw id
                mapCaseIdCCWId.put(caseInfo.id,multiCCWQuoteLst[count].id);
                count ++;
            }
                 
                //update tempCaseLst;
            }
            }
                // check if mapCaseIdCCWId is not empty
                if(!mapCaseIdCCWId.isEmpty()){
                    //create new temp case list for update DML operation
                    List<Case> tempCaseLst1 = new List<Case>();
                    //iterate over case with id's present in mapCaseIdCCWId where condition
                    for (Case c1 : [SELECT id,CCW_Deal_or_Quote__c FROM Case WHERE id IN: mapCaseIdCCWId.keySet()]){
                        //check ccw id value is present in map
                        //SCAVA fix to check fls
                        if(mapCaseIdCCWId.get(c1.id) != null && flsUpdateGet(Case.CCW_Deal_or_Quote__c)){
                            c1.CCW_Deal_or_Quote__c = mapCaseIdCCWId.get(c1.id);
                            //add both details to temp case lst1
                            tempCaseLst1.add(c1);
                        }
                    }
                    //update case DML operation
                    update tempCaseLst1;
                    //System.debug('Updated mapCaseIdCCWId');
                }
            }
        }catch(Exception e){
            System.debug('Error: ' + e);
        }
        
    }
//Manikant Kella
  
}