global class Utilities{
    
    private static boolean skipFuture = false;
    
    public static boolean getskipFuture(){
        return skipFuture;
    }
    
    public static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }
    public static void setskipFuture(boolean newStatus){
        skipFuture = newStatus;
    }
    
    /* To add a single user in the oppty record */
    WebService static void addStUser(String opptyID, String userID, String accLevel, String tmRole, String rwCause ) {
        
        OpportunityTeamMember[] opptyTeamToUpdate = new OpportunityTeamMember[]{};
            OpportunityShare[] OpptyShare = new OpportunityShare[]{}; 
                
                if(flsget(opportunityTeamMember.OpportunityId) && flsget(opportunityTeamMember.UserId)
                   && flsget(opportunityTeamMember.OpportunityAccessLevel) && flsget(opportunityTeamMember.TeamMemberRole)){
                       OpportunityTeamMember otm = new opportunityTeamMember(OpportunityId=opptyID, 
                                                                             UserId=userID,
                                                                             OpportunityAccessLevel=accLevel,
                                                                             TeamMemberRole=tmRole);
                       opptyTeamToUpdate.add(otm);
                   }
        OpportunityShare os = new OpportunityShare();
        //SCAVA FIX, Oct 16th 2018
        if(flsget(OpportunityShare.OpportunityId)){
        os.OpportunityId=opptyID;
        }
        //SCAVA FIX, Oct 16th 2018
        if(flsget(OpportunityShare.UserOrGroupId)){
        os.UserOrGroupId=userID; 
        }
        //SCAVA FIX, Oct 16th 2018
        if(flsget(OpportunityShare.OpportunityAccessLevel)){
        os.OpportunityAccessLevel=accLevel; 
        }
        //SCAVA FIX, Oct 16th 2018
        if(flsget(OpportunityShare.RowCause)){
        os.RowCause=rwCause;
        }
        opptyShare.add(os);
        // Added by Naresh to fix SCAVA issue -- 08/10/18 Lightning Release                                     
        if (Schema.sObjectType.OpportunityTeamMember.isCreateable()) {
            insert opptyTeamToUpdate;
        }
        // Added by Naresh to fix SCAVA issue -- 08/10/18 Lightning Release                                     
        if (Schema.sObjectType.OpportunityShare.isCreateable())  {                       
            insert opptyShare;
        }
    }
    
    /* Copy Sales Team. This will add all the sales team members from the original oppty to the new oppty record */
    Public static boolean copySalesTeam(String origOptyId, String newOptyId) {
        boolean success = true;
        try {
            opportunityTeamMember[] ot = [Select o.UserId, o.TeamMemberRole, o.OpportunityAccessLevel 
                                          From OpportunityTeamMember o where o.OpportunityId=:origOptyId and o.User.IsActive= true and o.OpportunityAccessLevel!= 'None'  ];                    
            
            OpportunityTeamMember[] opptyTeamToUpdate = new OpportunityTeamMember[]{};
                OpportunityShare[] OpptyShare = new OpportunityShare[]{};  
                    System.debug('***ot :'+ ot);
            For (Integer l = 0; l < ot.size(); l++)
            {
                if(flsget(opportunityTeamMember.OpportunityId) && flsget(opportunityTeamMember.UserId)
                   && flsget(opportunityTeamMember.OpportunityAccessLevel) && flsget(opportunityTeamMember.TeamMemberRole)){
                       OpportunityTeamMember otm = new opportunityTeamMember ( OpportunityId=newOptyId, UserId=ot[l].UserId, TeamMemberRole=ot[l].TeamMemberRole); 
                       opptyTeamToUpdate.add(otm);
                   }
                OpportunityShare os = new OpportunityShare();
                // SCAVA FIX , Oct 16th 2019
                if(flsget(OpportunityShare.OpportunityId)){
                os.OpportunityId=newOptyId; 
                }
                // SCAVA FIX , Oct 16th 2019
                if(flsget(OpportunityShare.UserOrGroupId)){
                os.UserOrGroupId=ot[l].UserId; 
                }
                // SCAVA FIX , Oct 16th 2019
                if(flsget(OpportunityShare.OpportunityAccessLevel)){
                os.OpportunityAccessLevel=ot[l].OpportunityAccessLevel;
                }
                opptyShare.add(os);
            }
            System.debug('***'+ opptyTeamToUpdate);  System.debug('***'+ opptyShare);
            
            // Added by Naresh to fix SCAVA issue -- 08/10/18 Lightning Release                                     
            if (Schema.sObjectType.OpportunityTeamMember.isCreateable()) {
                insert opptyTeamToUpdate;
            }
            // Added by Naresh to fix SCAVA issue -- 08/10/18 Lightning Release
            if (Schema.sObjectType.OpportunityShare.isCreateable())  {                       
                insert opptyShare;
            }
        }           
        catch (QueryException qe) {
            //No Sales Team members - do nothing.
        }
        catch (Exception e) {
            success = false;
        } 
        System.debug('***End of Code');
        return success;      
    }
    
    WebService static void addOpptyPartner(String PartnerAcct, String opptyID) {
        
        Partner[] partnerToUpdate = new Partner[]{}; 
            
            Partner p = new Partner(AccountToId=PartnerAcct, OpportunityId=opptyID);
        partnerToUpdate.add(p);
        
        insert partnerToUpdate;
    }
    
    
    //  isTestMethod: used to enable testMethod code coverage for code skipped or enabled by Administrative profile
    private static boolean isTestMethod = false;
    
    public static boolean getIsTestMethod(){
        return isTestMethod;
    }
    
    public static void setIsTestMethod(boolean newStatus){
        isTestMethod = newStatus;
    }
    
    private static boolean skip = false;
    
    public static void setSkip(boolean newStatus){
        skip = newStatus;
    }
    
    
    // used to skip the validation rules          
    private static boolean validationSkip = false;
    
    public static void setValidationSkip(boolean newStatus){
        validationSkip = newStatus;
    }
    
    public static boolean getValidationSkip(){
        return validationSkip;
    }  
    
    public static Org_Constants__c oc;
    public static boolean skipUser(){
        Boolean retVal = false;
        System.debug('Hello World'+oc);
        if ( oc == null ) {
            //if(oc.size() == 0){
            oc = [Select prod_value__c From Org_Constants__c where Key__c = 'Oppty: ProfileIds to skip Triggers'  limit 1 ];    
        }
        
        if((oc.prod_value__c.contains(UserInfo.getProfileId()) && !Utilities.isTestMethod) || skip ){
            retVal = true;
        }
        System.debug('Utilities: skipUser retVal: ' + retVal + ', isTestMethod:' + Utilities.isTestMethod +' skip:' + skip);
        return retVal;
    }   
    
    //  skipUser: end
    public static String getRunRateId(){ return '5555'; }
    
    public static String getOpptyStage1(){ return '1 - Prospect'; }
    public static String getOpptyStage2(){ return '2 - Qualification'; }
    public static String getOpptyStage3(){ return '3 - Proposal'; }
    public static String getOpptyStage4(){ return '4 - Agreement'; }
    //public static String getOpptyStage5(){ return '5 - Closing'; }  Commented by Komal on 08/08 Code Review
    public static String getOpptyStage5(){ return '5 - Closed Won'; }  
    
    public static String getOpptyParentRecordTypeId(){ return '0123000000003ykAAA'; }
    
    public static String getOpptyParentMobileRecordTypeId(){
        ID opptyParentMobileRecordTypeId = ObjectRecordTypeIds__c.getInstance().Opportunity_Parent_Mobile_RecordTypeId__c;
        return opptyParentMobileRecordTypeId;
    }
    
    public static String getOpptyPartnerParentRecordTypeId(){ return '0128000000020DlAAI'; }
    
    public static String getOpptyPhaseRecordTypeId(){ return '012300000000CDLAA2'; }
    
    public static String getOpptyPartnerPhaseRecordTypeId(){ return '0128000000020DqAAI'; }      
    
    public static String getOpptySolutionPlanRecordTypeId(){ return '012300000000bfZAAQ'; }      
    
    public static String getOpptymergedoptyRecordTypeId(){ return '012800000002e0MAAQ'; }  
        
    public static String getOpptyRenewalRecordTypeId(){ 
        ID opptyRenewalRecordTypeId = ObjectRecordTypeIds__c.getInstance().Oppty_Renewal_RecordTypeId_18__c;
        return opptyRenewalRecordTypeId;
    }
    
    public static String getOpptyBookingsRecordTypeId(){ 
       ID opptyBookingsRecordTypeId = ObjectRecordTypeIds__c.getInstance().Oppty_Bookings_RecordTypeId_18__c;
       return opptyBookingsRecordTypeId;
    }   
    
    public static String OpptyParentRecordTypeIds(){
        return getOpptyParentRecordTypeId() + ',' + getOpptyPartnerParentRecordTypeId() + ',' + getOpptyParentMobileRecordTypeId();
    }    
    
    public static String OpptyMandatoryCompetitorRecordTypes(){
        return getOpptyParentRecordTypeId() + ',' + getOpptyPartnerParentRecordTypeId() + ',' + getOpptyParentMobileRecordTypeId();
    }
    
    public static String OpptyOwnerPostnChkRecordTypes(){
        return getOpptyParentRecordTypeId() + ',' + getOpptyPartnerParentRecordTypeId() + ',' + getOpptyParentMobileRecordTypeId()
                + ',' + getOpptyRenewalRecordTypeId() + ',' + getOpptyBookingsRecordTypeId() + ',' +getOpptyRenewalRecordTypeId();                
    }         
    
    public static String getPSSProfileId(){ return '00e30000000rrZwAAI'; }
    
    public static String getRecordTypeId(String obj, String recordName){
        RecordType recordID = ([Select Id From RecordType where sObjectType = :obj and Name = :recordName and isactive = true limit 1]);
        return recordID.Id;
    }
    
    
    static testMethod void opptyTeamMember() {
        
        // Test addStUser
        Opportunity opptys = GenericStaticTestData.gettestParentOpportunityRecord();
        
        User[] userArray = [select Id from User where isActive = true LIMIT 1];
        
        addStUser(opptys.id, userArray[0].id, 'Edit', 'Partner', 'Team');
        
        // Test addOpptyPartner
        Account[] acct = [select Id FROM Account LIMIT 1];
        
        addOpptyPartner(acct[0].id, opptys.id);
        
         //Added by Pradeep : To run code under Renewal Profile user
        user[] usrArray = [Select id,name,profileId from user where Profile.name ='Cisco_Renewals' and isActive = true limit 1];
        user[] nonRenewalUsers = [Select id,name,profileId from user where Profile.name !='Cisco_Renewals' and profile.name !='zzDont_USE_Cisco_PSS' and isActive = true limit 1];   
        utilities.skip = false;
        User currnetUsr =[Select id,name,Position_1__c from user where id=:userinfo.getUserId()];
       Test.startTest();
        if(usrArray.size() > 0){
            system.runAs(usrArray[0]){
                
                currnetUsr.Position_1__c = '123';
                update currnetUsr;
               
                Date vCloseDate = System.today();
                //Query for Pricebook2
                String defaultPricebookId;
                Pricebook2[] pricebook2 = [select id from Pricebook2];
                if(pricebook2 == null || pricebook2.size() == 0){
                    Pricebook2 createDefaultPB = new Pricebook2(name='default pricebook', isActive=true);
                    insert createDefaultPB;
                    defaultPricebookId = createDefaultPB.Id;
                }
                else{
                    defaultPricebookId = pricebook2[0].Id;        
                } 
                String parentRecTypeId= utilities.getOpptyParentRecordTypeId();

                Opportunity  oppty1 = new Opportunity(name='Test1',CloseDate= vCloseDate,Expected_Product__c=2,
                                                     ownerId=currnetUsr.id, skipValidations__c = true,Partner_Required__c = FALSE,StageName='1 - Prospect', Opportunity_Owner_AM__c=currnetUsr.Id, recordTypeId=parentRecTypeId,Pricebook2Id=defaultPricebookId);
                //insert oppty1; 
            }
        }
        Test.stopTest();
        
    }
    //Created by Pradeep : To cover Before update code
    static testMethod void opptyTeamMember1() {

        //Added by Pradeep : To run code under Renewal Profile user
        user[] usrArray = [Select id,name,profileId from user where Profile.name ='Cisco_Renewals' and isActive = true limit 1];
        user[] nonRenewalUsers = [Select id,name,profileId from user where Profile.name !='Cisco_Renewals' and profile.name !='zzDont_USE_Cisco_PSS' and isActive = true limit 1];
        utilities.skip = false;
        User currnetUsr =[Select id,name,Position_1__c from user where id=:userinfo.getUserId()];
       Test.startTest();
        if(usrArray.size() > 0){
            system.runAs(usrArray[0]){
                
                currnetUsr.Position_1__c = '';
                update currnetUsr;
               
                Date vCloseDate = System.today();
                //Query for Pricebook2
                String defaultPricebookId;
                Pricebook2[] pricebook2 = [select id from Pricebook2];
                if(pricebook2 == null || pricebook2.size() == 0){
                    Pricebook2 createDefaultPB = new Pricebook2(name='default pricebook', isActive=true);
                    insert createDefaultPB;
                    defaultPricebookId = createDefaultPB.Id;
                }
                else{
                    defaultPricebookId = pricebook2[0].Id;        
                } 
                String parentRecTypeId= utilities.getOpptyParentRecordTypeId();

                Opportunity  oppty1 = new Opportunity(name='Test1',StageName='1 - Prospect',CloseDate= vCloseDate,Expected_Product__c=2,
                                                     ownerId=currnetUsr.id,skipValidations__c = true,Partner_Required__c = FALSE, Opportunity_Owner_AM__c=currnetUsr.Id, recordTypeId=parentRecTypeId,Pricebook2Id=defaultPricebookId);
                //insert oppty1; 
                
                try{
                oppty1.ownerId= nonRenewalUsers[0].id;
                update oppty1; 
                }
                catch(Exception e){
                }
            }
        }
        Test.stopTest();
        
    }
    
    public static Boolean isEPSSuser(Id uid)
    {
        Boolean Flag = False;
        String per = 'Enable_ePSS';
        User[] u = [Select u.ProfileId,u.additional_user_permissions__c from User u where u.Id =:uid];
        String userprofile = u[0].ProfileId;
        String userpermission = u[0].additional_user_permissions__c;
        if(userpermission !=NULL)
        {
            if(userPermission.indexof(per)>-1 || userprofile == getPSSProfileId())
            {
                Flag = True;
            }
        }
        return Flag;
    }
    
    
    //check User Additional Permission--- for SE Assignment app
    
    public static Boolean checkAdditionalUserPermission(String up) 
    {
        Boolean permissionFlag = False;
        String uId = UserInfo.getUserId();
        User[] u = [select u.additional_user_permissions__c From User u where u.Id =:uId];
        String userPermission=u[0].additional_user_permissions__c;
        if(userpermission !=NULL){
            if(userPermission.indexOf(up) > -1){
                permissionFlag=True; 
            }
            
            
        }
        return permissionFlag;
    }
    
    // Added By Naresh for USC LX profile Check  for 10/06/08  start 
    public static Boolean checkUSCLxProfile() 
    {
        Boolean permissionFlag = False;
        string uscProfileId ;
        
        ProfileID__c profiles = ProfileID__c.getOrgDefaults();    
        string loggedinProfile = UserInfo.getProfileId();
        if(profiles != null){    
            uscProfileId = profiles.Cisco_USC_LX__c;       
        }
        if(uscProfileId != null && uscProfileId.contains(loggedinProfile.substring(0,15)))    
        {
            permissionFlag = true; 
            
        }
        
        
        return permissionFlag;
    }
    
    // Added By Naresh for USC LX profile Check  for 10/06/08  End
    // get ORG Constant--will return NULL if Key is wrong---parameters: key : Key__c; org : prod/non-prod
    public static String getOrgConstant(String key){
        String host =ApexPages.currentPage().getHeaders().get('Host');   
        string constVal=null;
        Org_Constants__c[] ocnt = [Select o.non_prod_value__c, o.prod_value__c from Org_Constants__c o  where o.Key__c =:key limit 1];
        if(ocnt.size()>0 && host != null){
            if(host.indexOf('ciscosales.my')>-1){
                constVal=ocnt[0].prod_value__c;
            }
            else{
                constVal=ocnt[0].non_prod_value__c;
            }
        }
        // for Test Method Execution
        if(host == null){
            constVal=ocnt[0].prod_value__c;
        }
        return constVal;
    }
    
    //This Method returns the index of the first occurence of the input string value in the input string list.
    public static Integer getStringListIndex (List<Id> inList, String val){
        Integer vIndex=-1;
        for( Integer i=0;i<inList.size();i++){
            if(val==inList.get(i)){
                vIndex=i;
                break;
            }
        }
        return vIndex;
    }
    
    webService static Boolean delAP(String APId) {
        
        System.debug('Hereanoteforthelog');
        
        Account_Plan__c[] todelete = [select Id from Account_Plan__c where Id =:APId];
        try {
            delete todelete;
            return true;
        } catch (DmlException e) {
            return false;
        }
        
    }
    
    webservice static String getISOCountryCode(String Country)
    {
        List<PDBCountryLookup__c> PC =  PDBCountryLookup__c.getAll().values();
        String result;
        for(PDBCountryLookup__c PCL : PC)
        {
            if(PCL.sfdc_country_desc__c == Country)
            {
                result = PCL.Name;
                break;
            }
        } 
        return result;
    }
    
    
    webservice static String getCode_Desc(String Country)
    {
        List<PDBCountryLookup__c> PC =  PDBCountryLookup__c.getAll().values();
        String result;
        for(PDBCountryLookup__c PCL : PC)
        {
            if(PCL.sfdc_country_desc__c == Country)
            {
                result = PCL.CODE_DESC__c;
                break;
            }
        } 
        return result.replaceAll(' ','%20');
    }
    
    //To determine whether the logged in user profile is a Super Profile
    public static Boolean getSuperProfile(String id){
        System.debug('user:'+id);
        if(id.contains('00e30000000dcbg') || id.contains('00e30000000qDQP') || id.contains('00e30000000dfUE') || id.contains('00e30000000r9dq') || id.contains('00e30000000eca0'))
            return true;
        else
            return false;
    }
    
    public static Boolean getCaseDeleteUserIds(String currentUserId){
        Org_Constant_CS__c ocs = Org_Constant_CS__c.getInstance('CaseDeleteUser');
        if(ocs!=null){
            Set<String> userIds=new Set<String>(); List<String> currentUserIds=new List<String>();
            if(Userinfo.getOrganizationId() == '00D300000000QUuEAM'){
                currentUserIds = ocs.Production_Value__c.split(';');
            }else{
                currentUserIds = ocs.Non_Production_Value__c.split(';');
            }
            userIds.addAll(currentUserIds);
            System.debug('RETURN### '+userIds.contains(currentUserId));
            if(userIds.contains(currentUserId.substring(0,15))){
                return true;             
            }else{
                return false;                      
            }         
        }
        return false;
    }
    public static String getIntegrationUserId(){ return '00530000000dKAp'; }
    
    public static String getTSNProfileId(){ return '00e800000014g5uAAA'; }
    
    public static String getEngageServicesResourcesRecordTypeID(){ 
        ObjectRecordTypeIds__c objRecordTypeSetting = ObjectRecordTypeIds__c.getOrgDefaults();
        String engageCaseRecordTypeId = objRecordTypeSetting.Engage_Services_Resources__c ;
        return engageCaseRecordTypeId; 
    }
    // Added by Komal for 08/10/18 Lightning Release  - Start
    public static String getCustSuccessRecordTypeID(){ 
        ObjectRecordTypeIds__c objRecordTypeSetting = ObjectRecordTypeIds__c.getOrgDefaults();
        String custSuccessCaseRecordTypeId = objRecordTypeSetting.Case_Customer_Success_Adoption_Requests__c ;
        return custSuccessCaseRecordTypeId; 
    }
    // Added by Komal for 08/10/18 Lightning Release - End
    
    //public static String getEngageServicesResourcesRecordTypeID(){ return '0124F000000078v'; }
    public static String getCasePARecordTypeId(){ return '01280000000G5lE'; }
    public static String getCasePHRecordTypeId(){ return '01280000000G5l9'; }
    public static String getCasePDIRecordTypeId(){ return '01280000000G5l4'; }
    
    //Getting Case PXS Recordtype Id
    public static String getRequestPXSRecordTypeId(){ return  '01234000000QF8w'; }
    //pxs End
    public static String getCaseTSNRecordTypeId(){ return '01280000000G78n'; }
    // Code change for PSTS RecordType
    public static String getCasePSTSRecordTypeId(){ return '01280000000GEy3'; }
    
    //Added by Pradeep to include the 'Competitive War Room' Recordtype id
    public static String getCaseWarRoomRecordTypeId(){ return '01234000000BocO'; }
    public static String getCaseGVEDraftRecordTypeId(){ return '01234000000Hqdn'; }
    
    public static String getGSPOrecordtypeId(){ return '01280000000G7GD'; }
    public static String getNBMQualificationId(){ return '012800000003c7X'; }
    
    //Global Opportunity Changes -GDM Begin
    public static  String  getOpptyGlobalRecordTypeId(){ return ObjectRecordTypeIds__c.getInstance().Opportunity_Global_RecordTypeId__c; }
    //Global Opportunity Changes - End
    
    public static String getPAGroupId(){ return '00G80000001mTFC'; }
    public static String getPHPDIGroupId(){ return '00G80000001mTFW'; }
    public static String getPHGroupId(){ return '00G80000001mTFS'; }
    public static String getPDIGroupId(){ return '00G80000001mTFM'; }
    
    
    // Super Group Related List Ids
    public static String getSuperGroupDirectSalesAccountRelatedListId(){return SuperGroupRelatedListIds__c.getInstance().SuperGroupDirectSAVRelatedListId__c; }
    public static String getSuperGroupDirectAccountRelatedListId(){return SuperGroupRelatedListIds__c.getInstance().SuperGroupDirectAccountRelatedListId__c;}
    public static String getSuperGroupDirectOpptyRelatedListId(){return SuperGroupRelatedListIds__c.getInstance().SuperGroupDirectOpptyRelatedListId__c;}
    public static String getSuperGroupOverlayAccountRelatedListId(){return SuperGroupRelatedListIds__c.getInstance().SuperGroupOverlayAccountRelatedListId__c;}
    public static String getSuperGroupOverlayOpptyRelatedListId(){return SuperGroupRelatedListIds__c.getInstance().SuperGroupOverlayOpptyRelatedListId__c;}
    
    webservice static String getPAGroupName() { return 'Partner Advisor Group';}
    webservice static String getPHPDIGroupName() {return 'PH/PDI Agents Group';} 
    webservice static String getPHGroupName() {return 'PH Agents';}
    webservice static String getPDIGroupName() {return 'PDI Engineers';}
    Public static string getCaseManagementUserId() { return '00580000003FrC4';}
    
    // Account Record Type Ids
    WebService static String getAccountPartnerCompanyRecordTypeId() {return ObjectRecordTypeIds__c.getInstance().AccountPartnerCompanyRecordTypeId__c;}
    WebService static String getAccountChannelRecordTypeId(){ return ObjectRecordTypeIds__c.getInstance().AccountChannelRecordTypeId__c; }
    WebService static String getAccountEndUserRecordTypeId() {return ObjectRecordTypeIds__c.getInstance().Account_End_User_RecordTypeId__c;}
    
    // Contact Record Type Ids
    WebService static String getContactManualPartnerRecordTypeId() {return ObjectRecordTypeIds__c.getInstance().Contact_Manual_Partner_RecordTypeId__c;}
    WebService static String getContactManualEndUserRecordTypeId() {return ObjectRecordTypeIds__c.getInstance().Contact_Manual_EndUser_RecordTypeId__c;} 
    WebService static String getContactPDBContactRecordTypeId() {return ObjectRecordTypeIds__c.getInstance().Contact_PDB_RecordTypeId__c;}
    
    public static String getRecordTypeDefault(){
        
        
        Schema.DescribeSObjectResult R = Case.SObjectType.getDescribe();
        List<Schema.RecordTypeInfo> RT = R.getRecordTypeInfos();
        
        String rtname = '';
        
        for(Schema.RecordTypeInfo rt1 : RT)
        {
            if(rt1.isDefaultRecordTypeMapping() == true)
                rtname = rt1.getRecordTypeId();
        }
        
        return rtname;
    }
    
    /* get value from org constant custom setting */
    public static string getConstant_CS(String data_set_name){
        //'Junk'
        String returnValue='NA';
        Pattern refPattern = Pattern.compile('pass');       
        
        try {
            Org_Constant_CS__c oc_cs = Org_Constant_CS__c.getInstance(data_set_name);
            
            if ( Userinfo.getOrganizationId() == '00D300000000QUuEAM' ){
                returnValue=oc_cs.Production_Value__c;
            }
            else{
                returnValue=oc_cs.Non_Production_Value__c;
            }           
        }
        catch(Exception e){
            System.debug(e);
        }               
        
        if ( !refPattern.matcher(data_set_name.toLowerCase()).find() ){//don't print passwords to debug log.
            System.debug('getConstant ->'+data_set_name+': '+returnValue);
        }           
        return returnValue;
    }
    
    // Used to dynamically store state in variables across a entire transaction
    private static Map<String, String> transactionMap = new Map<String, String> {};
        
        public static void createTransactionKey(String s, String b){
            if(!transactionMap.containsKey(s))
                transactionMap.put(s,b);
        }
    
    public static void setTransactionKeyValue(String s, String b){
        transactionMap.put(s,b);
    }
    
    public static String getTransactionKeyValue(String s){
        return transactionMap.get(s);
    }
    // ***********
    
    
    
    Public static testMethod void UtilityTestMethods()
    {
        
        Utilities.getskipFuture();
        Utilities.setskipFuture(true);
        Utilities.getISOCountryCode('india');
        Utilities.getCode_Desc('india');
        Utilities.getAccountChannelRecordTypeId();
        Utilities.getCasePARecordTypeId();
        Utilities.getCasePHRecordTypeId();
        Utilities.getCasePDIRecordTypeId();
        Utilities.getPAGroupId();    
        Utilities.getPHPDIGroupId();
        Utilities.getPHGroupId();
        Utilities.getPDIGroupId();
        Utilities.getPAGroupName();
        Utilities.getPHPDIGroupName(); 
        Utilities.getPHGroupName();
        Utilities.getPDIGroupName();
        Utilities.checkUSCLxProfile();
        Utilities.getAccountChannelRecordTypeId();
        Utilities.getAccountEndUserRecordTypeId();
        Utilities.getAccountPartnerCompanyRecordTypeId();
        Utilities.getContactManualEndUserRecordTypeId();
        Utilities.getContactManualPartnerRecordTypeId();
        Utilities.getContactPDBContactRecordTypeId();
        Utilities.getIntegrationUserId();
        Utilities.getIsTestMethod();
        Utilities.setIsTestMethod(false);
        Utilities.setSkip(true);
        Utilities.setValidationSkip(true);
        Utilities.getValidationSkip();
        Utilities.skipUser();
        Utilities.getRunRateId();
        Utilities.getOpptyStage1();
        Utilities.getOpptyStage2();
        Utilities.getOpptyStage3();
        Utilities.getOpptyStage4();
        Utilities.getOpptyStage5();
        Utilities.getOpptyParentRecordTypeId();
        Utilities.getOpptyParentMobileRecordTypeId();
        Utilities.getOpptyPartnerParentRecordTypeId();
        Utilities.getOpptyPhaseRecordTypeId();
        Utilities.getOpptyPartnerPhaseRecordTypeId();   
        Utilities.getOpptySolutionPlanRecordTypeId();
        Utilities.getOpptymergedoptyRecordTypeId();
        Utilities.OpptyParentRecordTypeIds();
        Utilities.OpptyMandatoryCompetitorRecordTypes();
        Utilities.OpptyOwnerPostnChkRecordTypes();
        Utilities.getPSSProfileId();
        Utilities.getRecordTypeId('Case','PH Case');
        Utilities.getStringListIndex(new List<Id>{'00530000000xfBY','00530000000xfBZ'},'00530000000xfBZ');
        Utilities.delAP('test');
        Utilities.getTSNProfileId();
        Id id1=Utilities.getCaseTSNRecordTypeId();
        Utilities.getTSNProfileId();
        Utilities.getGSPOrecordtypeId();
        Utilities.getNBMQualificationId();
        Utilities.getCaseManagementUserId();
        Utilities.getConstant_CS('test');
        Utilities.getConstant_CS('test');
        Utilities.createTransactionKey('test','test');
        Utilities.setTransactionKeyValue('test','test');
        Utilities.getTransactionKeyValue('test');
        Id testPSSUserId='00580000003GNIT';
        Utilities.isEPSSuser(testPSSUserId);  
        Opportunity o = new Opportunity(name='Test',StageName='2 - Qualified',CloseDate=System.today() - 50,Expected_Product__c=10.0,error_description__c='error',DealID__c='1',Opportunity_Status__c='Active',recordtypeId=utilities.getOpptyParentRecordTypeId()); 
        Opportunity o1 = new Opportunity(name='Test',StageName='2 - Qualified',CloseDate=System.today() - 50,Expected_Product__c=10.0,error_description__c='error',DealID__c='1',Opportunity_Status__c='Active',recordtypeId=utilities.getOpptyParentRecordTypeId()); 
        boolean b = Utilities.copySalesTeam(o.id,o1.Id);
        boolean b1 = Utilities.checkAdditionalUserPermission('up');
        boolean b2 = Utilities.getSuperProfile('00e30000000qDQP');
        Utilities.getSuperGroupOverlayAccountRelatedListId();
        Utilities.getSuperGroupOverlayOpptyRelatedListId();
        Utilities.getPAGroupName();
        Utilities.getPHPDIGroupName();
        Utilities.getEngageServicesResourcesRecordTypeID();
        Utilities.getCustSuccessRecordTypeID();
        String glodId =Utilities.getOpptyGlobalRecordTypeId();
        String spId = Utilities.getSuperGroupDirectSalesAccountRelatedListId();
        String getsp = Utilities.getSuperGroupDirectAccountRelatedListId();
        string spGroup =Utilities.getSuperGroupDirectOpptyRelatedListId();
        string pxs =Utilities.getRequestPXSRecordTypeId();
        string pstRt= Utilities.getCasePSTSRecordTypeId();
        string srtt = Utilities.getRecordTypeDefault();
        String constant = Utilities.getOrgConstant('VPN');
        Boolean resp = Utilities.getCaseDeleteUserIds('00e30000000qDQP');
    }
    //added by Kavya to check pssUser while create
    private static boolean isPSSUser = false;
    
    public static boolean getisPSSUser(){
        return isPSSUser;
    }
    public static void setisPSSUser(boolean newStatus){
        isPSSUser = newStatus;
    }
    //added by Kavya to check whether Trigger is run twice while create
    private static boolean isTriggerRun = false;
    
    public static boolean getisTriggerRun(){
        return isTriggerRun;
    }
    public static void setisTriggerRun(boolean newStatus){
        isTriggerRun = newStatus;
    }
    //ends here
}