/************************************************************************************************************************************
Name    : OpptyMultiEdit_CTE
Author  : 
Purpose : Contains logic Multi Edit Select from Oppty List view- Display and Update based on User Permissions
Created Date:  
Modification History: Initial implementation.
1 US273885 - 02/21/19- mkella- Multi Edit w/o Assignment Logic for SE Users
2 US281955 - 03/14/19 - mkella- PSS/SE MultiEdit View Switch
3 US306431 - 05/08/19 - sabacha - PSS - SW Self Tag to Oppty and assign Role
4 DE262975 - 24/06/19 - shivisri - PSS Pilot - Delete Opportunity Team Member
5 US259669 - 02/07/19 - shivisri - SE Evol - Engage Resource - Mass Assign Someone Else 
6 US328604 - 08/07/19 - ratharik - SE view modification bases on SEM or SED and table with Name,role,Resr status,Assignment status
*************************************************************************************************************************************/

//  WR-0673 updated the query with description field

// Updated by Naresh to consolidate into one visual force page
public class OpptyMultiEdit_CTE
{
    Opportunity[] OpptysSelected;
    Opportunity[] Opptys;
    Opportunity[] OpptysToUpdate = new Opportunity[]{};       
        String OpptyStatusLost = 'Lost';
    String OpptyStatusCancelled = 'Cancelled';
    public String listViewId {get;set;} 
    
    public Map<Id,Opportunity> updateMuliteditMap= new Map<Id,Opportunity>();   // Added By Naresh for August 10 2018 Lightning  release 
    
    /*Lei Zhou start Lightning track March 2019*/
    public Boolean specialistPermission {get;set;}  
    public List<OpportunityTeamMember> opportunityTeamMembers{get;set;}
    public List<wrapOpportunity> wrapOpportunityList{get;set;}
    
    //Added by Hari krishna : US328604             
    public Boolean isSEMOrSED{get;set;}
  
    public class wrapOpportunity {
        public Opportunity opp {get; set;}
        public Boolean selected {get; set;}
        public String teamRole{get;set;}
        
        public wrapOpportunity(Opportunity o) {
            opp = o;
            selected = true;
            teamRole='';
        }
    }
    /*Lei Zhou end Lightning track March 2019*/
    
    /* Manikant Kella- US273885 Lightning Mar 2019- SE User Multi Edit */
    // Manikant Kella -Start US273885 Lightning Mar 2019- SE User Multi Edit
    // initiate seOpptys to use in SOQL query
    Opportunity[] seOpptys;
    //boolean values to check if user has additional permission as SE User or existing multiedit users
    //will be used in VF PageBlock section
    public Boolean seUserPermission {get;set;}
    //SE and Specialist Condition Changes Start
    public Boolean specialistSEPermission {get; set;}
    //SE and Specialist Condition Changes End
    public Boolean existingMultiEditUser {get;set;}
    // to store list of selected opptys
    //List<Opportunity> seOpptyList = new List<Opportunity>();
    // to update changed oppty values in Multi Edit
    Opportunity[] seOpptysToUpdate = new Opportunity[]{};
        public Map<Id,Opportunity> seUpdateMultiEditMap= new Map<Id,Opportunity>();
    
    /* Start Changes after wrapper  */
    // wrapper class for storing respective oppty, technology and service line items values
    public List<seOpportunity> seWrapperList {get; set;}  
    public static Boolean SaveNew;
    public static Boolean getSaveNew()
    {
        return SaveNew;
    }
    public void setSaveNew()
    {
        SaveNew = false;
    }
    public class seOpportunity {
        public Opportunity seOpp {get; set;}
        public List<seTech> tech {get; set;}
        public List<seService> service {get; set;}
        //added by Kavya to provide checkbox in multiedit page for SE users
        public Boolean selected {get; set;}
        public Boolean headerSelected {get;set;}
        public seOpportunity() {
            if(OpptyMultiEdit_CTE.getSaveNew()==false){
                
                selected = false;
                headerSelected = false;
            }
        }
    } 
    public class seTech {
        
        public String techBE {get; set;}
        public Decimal techMixPercent {get; set;}
    }
    public class seService{
        
        public String serviceBE {get; set;}
        public Decimal serviceMixPercent{get; set;}
    }
    /* End Changes after wrapper*/
    
    /* Manikant Kella- End US273885 Lightning Mar 2019- SE User Multi Edit */
    
    public string prevListviewId {                                              // Added By Naresh for August 10 2018  Lighnting release to fix previous list view issue
        get{
            prevListviewId = listViewId.substring(0,listViewId.length()-3);
            return prevListviewId ;
        }
        
        set;
    }        
    
    Boolean DynamicallyMandatory = false;    
    String Stage1 = Utilities.getOpptyStage1();
    String Stage2 = Utilities.getOpptyStage2();
    String Stage3 = Utilities.getOpptyStage3();
    String Stage4 = Utilities.getOpptyStage4();
    String Stage5 = Utilities.getOpptyStage5();    
    public String getStage1() { return Stage1;}
    public String getStage2() { return Stage2;}
    public String getStage3() { return Stage3;}
    public String getStage4() { return Stage4;}
    public String getStage5() { return Stage5;}              
    
    Set<Id> OpptyIdsSelected = new Set<Id>(); 
    //mkella - Start BAT defect for selected order
    List<Id> OpptyIdsSelectedLst = new List<Id>();
    //mkella- End BAT defect for selected order
    public OpptyMultiEdit_CTE(ApexPages.StandardSetController controller) 
    {
        listViewId = controller.getFilterId();
        OpptysSelected = (List<Opportunity>)controller.getSelected();
        loadMultiEdit((List<Opportunity>)controller.getSelected());
    }
    public void loadMultiEdit(List<Opportunity> OpptysSelected)
    {
        /*Lei Zhou start Lightning track March 2019*/
        /*mkella- start*/
        specialistPermission = false;
        
        /*Manikant Kella Start US273885 Lightning Mar 2019- SE User Multi Edit */
        // set SE User and Existing Multi Edit User permissions to false
        seUserPermission = false;
        existingMultiEditUser = false;
        //SE and Specialist Condition Changes Start
        specialistSEPermission = false;
        //SE and Specialist Condition Changes End
        /*Manikant Kella End US273885 Lightning Mar 2019- SE User Multi Edit */
        
        User[] user = [SELECT Additional_User_Permissions__c 
                       FROM User 
                       WHERE Id = : UserInfo.getUserId()];
        
        //Check if loggedIn User is SE Manager or SE Director - Added by R.Hari Krishna -  US328604
        String userCECId = (userInfo.getUserName()).substringBefore('@');
       
        String userId = userInfo.getUserId();
        checkSEMOrSED(userCECId,userId);
        string strResurcStatuses = Org_Constant_CS__c.getValues('Resource Assignement Statuses').Production_Value__c;
        List<String> resStatusesLst = new List<String>();
        if(String.isNotBlank(strResurcStatuses)) {
            resStatusesLst = strResurcStatuses.split(',');
        }
        String additionalPermissions  = user[0].Additional_User_Permissions__c;
        
        List<String> additionalPermissionList = new List<string>();
        
        
        /* Manikant Kella -Start US273885 Lightning Mar 2019- SE User Multi Edit*/
        //if user has no additional permissions then, set multiEditUser = true
        if(additionalPermissions == null || String.isBlank(additionalPermissions)){
            existingMultiEditUser = true;
        }
        /* Manikant Kella -End US273885 Lightning Mar 2019- SE User Multi Edit */
        
        if (additionalPermissions != null && additionalPermissions != 'NA') {
            additionalPermissionList = additionalPermissions.split(';');  
        }
        //SE and Specialist Condition Changes Start
        /* mkella- Start logic change to accomodate pss/vss and se permissions */
        Boolean seFlag = additionalPermissionList.contains('SE User');
        Boolean pssFlag = additionalPermissionList.contains('Enable_ePSS');
        Boolean vssFlag = additionalPermissionList.contains('Enable_VSS');
        if (additionalPermissionList.size() > 0) {
            // if user has only SE User permission
            if (seFlag== true && pssFlag == false && vssFlag == false){
                seUserPermission = true;
                existingMultiEditUser = false;
            }
            // if user has only either pss or vss permission
            else if (seFlag == false && (pssFlag == true || vssFlag == true)){
                specialistPermission = true;
                existingMultiEditUser = false;
            }
            // if user has both SE and PSS/VSS permission
            else if (seFlag == true && (pssFlag == true || vssFlag == true)){
                specialistSEPermission = true;
                specialistPermission = true;
                //seUserPermission = true;
                existingMultiEditUser = false;
            }
            // else existing multi edit user
            else{
                existingMultiEditUser = true;
            }
        }
        /* mkella- End logic change to accomodate pss/vss and se permissions */
        //SE and Specialist Condition Changes End
        
        /*Lei Zhou End Lightning track March 2019*/
        
        //listViewId = controller.getFilterId();     // Added By Naresh for August 10 2018  release to fix previous list view issue
        // OpptysSelected = (List<Opportunity>)controller.getSelected();
        for (Opportunity o: OpptysSelected)
        { 
            OpptyIdsSelected.add(o.Id);
            //mkella- Start for BAT defect
            OpptyIdsSelectedLst.add(o.Id);
            //mkella- End for BAT defect
        }
        Opptys = [SELECT Id, name, DealID__c, AccountId, stageName, Description, Opportunity_Status__c, Lost_Cancelled_Reason__c,
                  Forecast_Status__c, Start_Date__c, End_Date__c, closedate, Expected_Product__c, Expected_Service__c, currencyisocode, 
                  Account.CSCSiteID__c, Account.CSCID__c, Account.Name, Account.RecordType.Name,
                  Forecast_Discount__c,Competitors__c,Other_Competitor__c,
                  Primary_Partner__c,
                  Partner_2__c,
                  Partner_3__c,
                  Partner_4__c,
                  Partner_5__c,
                  Partner_Required__c,
                  Win_Loss_Comments__c,
                  Budget_Approved__c,Compelling_Event__c,
                  Cisco_Product_of_Choice__c,
                  SE_Status__c,
                  SE_Architecture_Mode__c,
                  Technology_Merge_Field__c,
                  Service_Merge_Field__c,
                  RecordType.Name
                  FROM Opportunity 
                  where id in :OpptyIdsSelected and
                  Opportunity.RecordType.Name != 'Solution Plan'
                  and Opportunity.RecordType.Name != 'Void Merged Opportunity'
                  and Contractual_Pricing_Letter_Opportunity__c != 'Yes'
                  order by Account.name, closedate]; 
        
        /* Manikant Kella -Start US273885 Lightning Mar 2019- SE User Multi Edit */
        // SOQL for SE Users- Fetching details from Oppty and Resource_Request_Assignment__c obj's
        // removed order by in soql to display as selected by user
        // For SE display only Assigned or Direct Assigend status resources - Added by R.Hari Krishna - US328604
        if(isSEMOrSED == false) {
            seOpptys = [SELECT Id, name,Owner.Name, DealID__c, AccountId, stageName, Description, Opportunity_Status__c, Lost_Cancelled_Reason__c,
                        Forecast_Status__c, Start_Date__c, End_Date__c, closedate, Expected_Product__c, Expected_Service__c, currencyisocode, 
                        Account.CSCSiteID__c, Account.CSCID__c, Account.Name, Account.RecordType.Name,Forecast_Discount__c,Competitors__c,Other_Competitor__c,
                        Primary_Partner__c,Primary_Partner__r.Partner_Name__c,Partner_2__c,Partner_3__c,Partner_4__c,Partner_5__c,
                        Partner_Required__c,Win_Loss_Comments__c,Budget_Approved__c,Compelling_Event__c,Cisco_Product_of_Choice__c,SE_Status__c,
                        SE_Count__c,SE_Architecture_Mode__c,Technology_Merge_Field__c,Service_Merge_Field__c,
                        (SELECT id,Name,Service_Category__c,PriceBookEntry.ProductCode,Product2.Business_Entity__c,Mix__c FROM OpportunityLineItems ORDER BY Mix__c DESC),
                        (SELECT id,Name,Opportunity_Name__r.SE_Count__c,Opportunity_Name__c,Resource_Username__c,Resource_Status__c, 
                         //Added by Hari Krishna : US328604 : SE_SAGE_Role__c
                         Resource_Name__r.Name,Resource_Name__r.Alias,Resource_Name__r.UserName,Contribution_Percentage__c, Assignment_Type__c, Assignment_Status__c,SE_SAGE_Role__c  
                         FROM Requests_and_Assignments__r WHERE (Resource_Status__c = 'Assigned' OR Resource_Status__c = 'Direct Assignment'))
                        FROM Opportunity where id IN: OpptyIdsSelectedLst];
            // For SEM or SED display all statuses resources - Added by R.Hari Krishna - US328604
        }else if(isSEMOrSED) {
            seOpptys = [SELECT Id, name,Owner.Name, DealID__c, AccountId, stageName, Description, Opportunity_Status__c, Lost_Cancelled_Reason__c,
                        Forecast_Status__c, Start_Date__c, End_Date__c, closedate, Expected_Product__c, Expected_Service__c, currencyisocode, 
                        Account.CSCSiteID__c, Account.CSCID__c, Account.Name, Account.RecordType.Name,Forecast_Discount__c,Competitors__c,Other_Competitor__c,
                        Primary_Partner__c,Primary_Partner__r.Partner_Name__c,Partner_2__c,Partner_3__c,Partner_4__c,Partner_5__c,
                        Partner_Required__c,Win_Loss_Comments__c,Budget_Approved__c,Compelling_Event__c,Cisco_Product_of_Choice__c,SE_Status__c,
                        SE_Count__c,SE_Architecture_Mode__c,Technology_Merge_Field__c,Service_Merge_Field__c,
                        (SELECT id,Name,Service_Category__c,PriceBookEntry.ProductCode,Product2.Business_Entity__c,Mix__c FROM OpportunityLineItems ORDER BY Mix__c DESC),
                        (SELECT id,Name,Opportunity_Name__r.SE_Count__c,Opportunity_Name__c,Resource_Username__c,Resource_Status__c, 
                         //Added by Hari Krishna : US328604 : SE_SAGE_Role__c
                         Resource_Name__r.Name,Resource_Name__r.Alias,Resource_Name__r.UserName,Contribution_Percentage__c, Assignment_Type__c, Assignment_Status__c,SE_SAGE_Role__c  
                         FROM Requests_and_Assignments__r WHERE Resource_Status__c IN : resStatusesLst)
                        FROM Opportunity where id IN: OpptyIdsSelectedLst];
        }
        
        
        /* Manikant Kella- End US273885 Lightning Mar 2019- SE User Multi Edit */
        
        /*Lei Zhou start Lightning track March 2019*/
        wrapOpportunityList = new List<wrapOpportunity>();
        // for(Opportunity oppty : Opptys)
        
       /* for(Opportunity oppty : seOpptys)
        {   
            
            wrapOpportunity wrapOppty = new wrapOpportunity(oppty);        
            OpportunityTeamMember[] opptyTeamMember = [SELECT TeamMemberRole 
                                                       FROM  OpportunityTeamMember 
                                                       WHERE OpportunityId = :oppty.Id 
                                                       AND UserId = : UserInfo.getUserId()];
            
            if (!opptyTeamMember.isEmpty()){
                wrapOppty.teamRole = opptyTeamMember[0].TeamMemberRole;
            }
            wrapOpportunityList.add(wrapOppty);
        }*/
        
        //modified the above logic by Hari as it s throwing soql exception        
        Map<ID,String> mapOpptyIdWithMembRole = new Map<ID,String>();        
        
        for(Opportunity oppty : seOpptys) {   
            mapOpptyIdWithMembRole.put(oppty.Id,'');
        }
        OpportunityTeamMember[] opptyTeamMembers = [SELECT TeamMemberRole,OpportunityId 
                                                    FROM  OpportunityTeamMember 
                                                    WHERE OpportunityId IN:mapOpptyIdWithMembRole.keySet() 
                                                    AND UserId = : UserInfo.getUserId()];
        for(OpportunityTeamMember oppMem : opptyTeamMembers) {
            if(mapOpptyIdWithMembRole.containsKey(oppMem.OpportunityId)){
                String role = mapOpptyIdWithMembRole.get(oppMem.OpportunityId);
                role = oppMem.TeamMemberRole;
                mapOpptyIdWithMembRole.put(oppMem.OpportunityId,role);
            }else {
                mapOpptyIdWithMembRole.put(oppMem.OpportunityId,oppMem.TeamMemberRole);
            }                
        }
        for(Opportunity oppty : seOpptys) {   
            if(mapOpptyIdWithMembRole.containsKey(oppty.Id)) {
                wrapOpportunity wrapOppty = new wrapOpportunity(oppty); 
                wrapOppty.teamRole = mapOpptyIdWithMembRole.get(oppty.Id);
                wrapOpportunityList.add(wrapOppty);
            }
        }
        
        /* Manikant Kella -Start US273885 Lightning Mar 2019- SE User Multi Edit */
        // initiate wrapper to store list values
        seWrapperList = new List<seOpportunity> ();
        for(Opportunity seOppty : seOpptys)
        {
            /* Start Changes after wrapper    */
            // initiate for indiviual oppty wrapper 
            seOpportunity seWrapper = new seOpportunity();
            List<seTech> techonologyLst = new List<seTech>();
            List<seService> serviceLst = new List<seService>();
            // map for storing mix percent values at BE level
            Map<String, Decimal> seTechMap = new Map<String, Decimal>();
            Map<String, Decimal> seServiceMap = new Map<String, Decimal>();
            // assign OpportunityLineItems nested SOQL results to list
            List <OpportunityLineItem> optyLineItemList = seOppty.OpportunityLineItems;
            // enter if list is not empty
            if(!optyLineItemList.isEmpty()){
                // iterate over each line item in the list
                for(OpportunityLineItem optyLineItem : optyLineItemList){
                    // if line item is technology and BE is not empty, store results in map and values will be mix percent
                    if(optyLineItem.PriceBookEntry.ProductCode == 'Technology' && optyLineItem.Product2.Business_Entity__c != null){
                        
                        //if(optyLineItem.Product2.Business_Entity__c != null){
                        // check initially BE key is present in map, if not put value to that BE key
                        if(!seTechMap.containsKey(optyLineItem.Product2.Business_Entity__c)){
                            
                            seTechMap.put(optyLineItem.Product2.Business_Entity__c, optyLineItem.Mix__c);
                        }
                        // if BE key is present in map, then fetch and update mix percent value iteratively to the key
                        else if(seTechMap.containsKey(optyLineItem.Product2.Business_Entity__c)){
                            Decimal percentValue = seTechMap.get(optyLineItem.Product2.Business_Entity__c);
                            seTechMap.put(optyLineItem.Product2.Business_Entity__c, optyLineItem.Mix__c + percentValue);
                        }
                        //}
                        
                        
                    }
                    // BE is service
                    else if(optyLineItem.PriceBookEntry.ProductCode == 'Service' && optyLineItem.Product2.Business_Entity__c != null){
                        //if(optyLineItem.Product2.Business_Entity__c != null){
                        
                        if(!seServiceMap.containsKey(optyLineItem.Product2.Business_Entity__c)){
                            
                            seServiceMap.put(optyLineItem.Product2.Business_Entity__c, optyLineItem.Mix__c);
                        }
                        else if(seServiceMap.containsKey(optyLineItem.Product2.Business_Entity__c)){
                            Decimal percentValue = seServiceMap.get(optyLineItem.Product2.Business_Entity__c);
                            seServiceMap.put(optyLineItem.Product2.Business_Entity__c, optyLineItem.Mix__c + percentValue);
                        }
                        //}
                        
                    }
                }
            }
            // check tech map is not empty
            if(!seTechMap.isEmpty()){
                for (String techName : seTechMap.keyset() ){
                    // initiate seTech nested wrapper to store BE and aggregated BE mix percent values
                    seTech tech = new seTech();
                    tech.techBE = techName;
                    tech.techMixPercent = seTechMap.get(techName);
                    // add it to list
                    techonologyLst.add(tech);
                    
                }
            }
            // check service map is not empty
            if(!seServiceMap.isEmpty()){
                for (String servName : seServiceMap.keyset() ){
                    seService serv = new seService();
                    serv.serviceBE = servName;
                    serv.serviceMixPercent = seServiceMap.get(servName);
                    serviceLst.add(serv);
                }
            }
            // add respective oppty, tech, service list values to wrapper
            
            
            seWrapper.seOpp =  seOppty;  
            seWrapper.tech =  techonologyLst;
            seWrapper.service =  serviceLst;
            // add to final wrapper list to use in vf page
            seWrapperList.add(seWrapper);
            /* End Changes after wrapper    */
            
            //seOpptyList.add(seOppty);
            
        }
        /* Manikant Kella- End US273885 Lightning Mar 2019- SE User Multi Edit */
    }   
    
    /*Lei Zhou start Lightning track March 2019*/
    public List<wrapOpportunity> getWrapOpptunityList() 
    {
        return wrapOpportunityList;     
    }      
    /*Lei Zhou end Lightning track March 2019*/
    
    /* Manikant Kella -Start US273885 Lightning Mar 2019- SE User Multi Edit */
    // get method to display in vf page
    /*public List<Opportunity> getSEOpptyList() 
{
return seOpptyList;     
}*/
    public List<seOpportunity> getSEWrapperList() 
    {
        return seWrapperList;     
    }
    /* Manikant Kella -End US273885 Lightning Mar 2019- SE User Multi Edit */
    
    public List<Opportunity> getOpptyList() 
    {
        return Opptys;     
    }   
    
    public integer getOpptyCount()
    {
        return Opptys.size();
    }
    
    
    public PageReference ExtensionSave() 
    {
        
        errorMsg = '';
        //this.setGoToUrl('/006?fcf='+listViewId.substring(0,listViewId.length()-3));    // updated by Naresh  to fix SCAVA issue as part August 10 2018  release
        GoToUrl = '/006?fcf='+listViewId.substring(0,listViewId.length()-3);
        PageReference newpage = new PageReference(GoToUrl);     
        newpage.setRedirect(true);            
        
        for(Opportunity validateOppty: Opptys){
            
            
            // updated by Naresh for 08/10/18 Lightning Release  - Start
            
            
            
            if(validateOppty.Partner_Required__c == true && validateOppty.Primary_Partner__c == null && (validateOppty.stageName == Stage3 || validateOppty.stageName == Stage4 || validateOppty.stageName == Stage5)){
                validateOppty.Primary_Partner__c.adderror('You must enter a value');
                
                newpage = null;
            }
            else if(validateOppty.Competitors__c ==  null ){
                validateOppty.Competitors__c.adderror('You must enter a value');
                newpage = null;
            }
            else {  
                
                OpptysToUpdate.add(validateOppty);
            }
            
        } 
        
        
        
        for(Opportunity o : OpptysToUpdate ){
            updateMuliteditMap.put(o.Id,o);
            
            
        } 
        
        // updated by Naresh for 08/10/18 Lightning Release  - End
        
        //Utilities.setSkip(true);//skips certain trigger functionality
        //Utilities.setValidationSkip(true);
        try
        {
            update( updateMuliteditMap.values());
        }
        catch(DmlException e)          
        {
            ApexPages.addMessages(e);
            errorMsg +=  ' [e] ' + e;
            newpage = null;
            
        }
        
        return newpage;
    }
    
    private String errorMsg;
    public String getErrorMsg() { return errorMsg;}
    
    private String GoToUrl;
    public String getGoToUrl() { return GoToUrl; }
    public void setGoToUrl(String GoToUrl) {     
        //this.GoToUrl = GoToUrl
        // updated by Naresh for 08/10/18 Lighnting Release to fix SCAVA Fix
        this.GoToUrl =  EncodingUtil.urlEncode(GoToUrl,'UTF-8');  
    }
    
    List<SelectOption> options = new List<SelectOption>();
    public List<SelectOption> getCompetitorsPicklist() 
    { 
        if( options.size() == 0 )
        {       
            Schema.DescribeFieldResult f = Opportunity.Competitors__c.getDescribe();
            String defValue = '';
            //commented by Kavya as None is removed from picklist
            //options.add( new SelectOption( '', '--None--') );        
            for(Schema.PicklistEntry pe : f.getPicklistValues()) 
            {
                
                
                options.add( new SelectOption( pe.getValue(), pe.getLabel() ));
                
            }
        }           
        return options; 
    }
    
    public void setCompetitorsPicklist(Opportunity o) {}
    
    
    /*Lei Zhou start Lightning track March 2019*/
    List<SelectOption> teamRoleOptions = new List<SelectOption>();
    public List<SelectOption> getTeamRolePicklist() 
    { 
        if( teamRoleOptions.size() == 0 )
        {       
            Schema.DescribeFieldResult f = OpportunityTeamMember.TeamMemberRole.getDescribe();
            String defValue = '';
            teamRoleOptions.add( new SelectOption( '', '--None--') );  
            teamRoleOptions.add( new SelectOption( 'Architecture Specialist', 'Architecture Specialist'));     
            teamRoleOptions.add( new SelectOption( 'Incubation Specialist', 'Incubation Specialist'));   
            teamRoleOptions.add( new SelectOption( 'Virtual Sales Specialist', 'Virtual Sales Specialist'));
            //Added by Sam
            teamRoleOptions.add( new SelectOption( 'Software Specialist', 'Software Specialist'));
            /* for(Schema.PicklistEntry pe : f.getPicklistValues()) 
{
teamRoleOptions.add( new SelectOption( pe.getValue(), pe.getLabel() ));
}*/
        }           
        return teamRoleOptions; 
    }
    
    public PageReference processSelected() {
        
        GoToUrl = '/006?fcf='+listViewId.substring(0,listViewId.length()-3);
        PageReference newpage = new PageReference(GoToUrl);
        newpage.setRedirect(true);  
        opportunityTeamMembers = new List<OpportunityTeamMember>();
        for(wrapOpportunity wrapOpportunityObj : wrapOpportunityList) {
            if(wrapOpportunityObj.selected == true) {  
                if(wrapOpportunityObj.teamRole ==null){
                    
                    //wrapOpportunityObj.teamRole.adderror('You must enter a value');
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Please fill out a Specialist Role for Opportunity: '+ wrapOpportunityObj.opp.Name));
                    newpage = null;
                }
                else{
                    OpportunityTeamMember opptyTeamMember = new OpportunityTeamMember();
                    opptyTeamMember.OpportunityId = wrapOpportunityObj.opp.Id;  
                    opptyTeamMember.UserId = UserInfo.getuserId();
                    opptyTeamMember.TeamMemberRole = wrapOpportunityObj.teamRole;
                    opptyTeamMember.OpportunityAccessLevel = 'Edit';                
                    opportunityTeamMembers.add(opptyTeamMember);
                }
                
            }
        }
        if(opportunityTeamMembers.size() > 0){
            insert opportunityTeamMembers;             
        } 
        /*try{
if(opportunityTeamMembers.size() > 0){
insert opportunityTeamMembers;             
} 
}
catch(DmlException e)          
{
ApexPages.addMessages(e);
errorMsg +=  ' [e] ' + e;
newpage = null;
}  */   
        return newpage;
    }   
    /*Lei Zhou end Lightning track March 2019*/
    
    /* Manikant Kella -Start US273885 Lightning Mar 2019- SE User Multi Edit */
    // method gets executed when se user clicks on save in multi edit page
    public PageReference seUserSave() 
    {
        
        // to display error msg and navigate back to opty list view url
        errorMsg = '';
        GoToUrl = '/006?fcf='+listViewId.substring(0,listViewId.length()-3);
        PageReference newpage = new PageReference(GoToUrl);     
        newpage.setRedirect(true);            
        // validate opptys and displaying error if conditions are not satisfied and add changed opptys to list for updating
        //for(Opportunity validateOppty: seOpptyList){
        // iterate over sewrapper list from vf page
       for(seOpportunity validateOppty: seWrapperList){
            // get and convert competitor values  for multi select picklist 
            String competitor = validateOppty.seOpp.Competitors__c;
            competitor = competitor.remove('[');
            competitor = competitor.remove(']');
            competitor = competitor.replaceAll(',',';');
            validateOppty.seOpp.Competitors__c = competitor;
            seOpptysToUpdate.add(validateOppty.seOpp);
        } 
        // map opty id and opty values  
        for(Opportunity o : seOpptysToUpdate ){
            seUpdateMultiEditMap.put(o.Id,o);
        } 
        // update optys
        try
        {
            update( seUpdateMultiEditMap.values());
        }
        // catch exception if any
        catch(DmlException e)          
        {
            ApexPages.addMessages(e);
            errorMsg +=  ' [e] ' + e;
            newpage = null;
            
        }
        // after successful saving navigate user back to opty list view
        return newpage;
    }
    
    //SE and Specialist Condition Changes Start
    /* mkella Start method to accomodate both SE and PSS/VSS condition */
    
    public PageReference showSE(){
        
        seUserPermission = true;
        specialistPermission = false;
        return null;
    }
    public PageReference showSpecialist(){
        
        specialistPermission = true;
        seUserPermission = false;
        return null;
    }
    
    /* mkella End method to accomodate both SE and PSS/VSS condition */
    //SE and Specialist Condition Changes End
    
    /* Manikant Kella- End US273885 Lightning Mar 2019- SE User Multi Edit */ 
    //added by Kavya for assign myself functionality
    
    //shivisri - variable assignments
    public boolean displayPopup {get; set;}  
    public String getSelected {get; set;}
    public String searchKey {get; set;}
    public List<User> users{get; set;}
    public String commentsSec {get; set;}
    public Id radioHidden {get;set;}
    public Boolean searchBtn = false;
    public String userEmail;
    public List<Id> optyIdsList = new List<Id>();
    public List<Opportunity> selectedOpp = new List<Opportunity>();
    public Id selectedValues;
    //public Id oppId { get; set; }
    
    public void checkBoxAction(){
        selectedOpp.clear();
        optyIdsList.clear();
        for(seOpportunity opp:seWrapperList)
        {
            if(opp.selected== true) {
                selectedOpp.add(opp.seOpp);
            }
        }
        for(Opportunity opp : selectedOpp) {
            optyIdsList.add(opp.Id);
        }
    }
    
    public PageReference seassignMyself()
    {   
        List<Id> failedIds = new List<Id>();
        for(seOpportunity opp:seWrapperList)
        {
            if(opp.selected== true) {
                selectedOpp.add(opp.seOpp);
            }
        }
        for(Opportunity opp : selectedOpp) {
            optyIdsList.add(opp.Id);
        }
        if(optyIdsList.isEmpty())
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Please select an opportunity to assign '));
        }
        else
        {
            List<Resource_Request_Assignment__c> resReqInsList = new List<Resource_Request_Assignment__c>();
            List<Opportunity> opptyListForInsert = new List<Opportunity>();
            Id userId;
            
            //Determining if assign self/someone else
            if(selectedValues!=null){
                userId=selectedValues;
                for(User usr: users){
                    if(usr.Id==selectedValues){
                        userEmail=usr.Email;
                    }
                }
            }
            else{
                userId=UserInfo.getUserId();
                userEmail=UserInfo.getUserEmail();
            }
            
            //when logged in se user resource is assigned to opportunity
            List<Resource_Request_Assignment__c> resReqList = [Select Id,Resource_Status__c,Opportunity_Name__c,Resource_Name__c,Request_Comments__c 
                                                               from Resource_Request_Assignment__c 
                                                               where Resource_Name__c=:userId and Opportunity_Name__c in :optyIdsList and Resource_Status__c!='Assigned' and Resource_Status__c!='Direct Assignment'];
            
            //when se user resource is not assigned to opportunity 
            List<Opportunity> opptyList = [SELECT Id,SE_Status__c,SE_Count__c, 
                                           (SELECT Id,Resource_Name__c FROM Requests_and_Assignments__r where Resource_Name__c=:userId)
                                           from opportunity
                                           WHERE ID IN :optyIdsList];
            if(!opptyList.isEmpty())
            {
                for(Opportunity opty:opptyList)
                {

                    //checking whether SE user is not added as resource
                    if(opty.Requests_and_Assignments__r.isEmpty() && opty.Requests_and_Assignments__r.size()==0)
                    {
                        Resource_Request_Assignment__c resreqIns = new Resource_Request_Assignment__c();
                        if(opty.SE_Count__c == 0){
                            resreqIns.Assignment_Type__c = 'Primary';
                            resreqIns.Contribution_Percentage__c =  100;
                        }
                        if(opty.SE_Count__c > 0)
                        {
                            resreqIns.Assignment_Type__c = 'Secondary';
                            resreqIns.Contribution_Percentage__c =  0;
                        }
                        resReqIns.CreatedById = userId;//UserInfo.getUserId();
                        resReqIns.CurrencyIsoCode ='USD';
                        resReqIns.LastModifiedById = userId;//UserInfo.getUserId();
                        resReqIns.Opportunity_Name__c = opty.Id;
                        resReqIns.Request_Escalated__c = false;
                        resReqIns.Requester_Email_ID__c = userEmail;
                        resReqIns.Resource_Name__c = userId;//UserInfo.getUserId();
                        resReqIns.Resource_Status__c = 'Direct Assignment';
                        resReqIns.SLA_Expired__c = false;
                        resReqIns.CurrencyIsoCode = 'USD';
                        resReqIns.Request_Comments__c=commentsSec;
                        resReqInsList.add(resreqIns);
                    }
                }
            }
            if(!resReqList.isEmpty())
                
            {
                for(Resource_Request_Assignment__c re:resReqList)
                {
                    //if loggedin user is assigned to opportunity and status not assigned
                    if(re.Resource_Status__c == 'Requested')
                    {
                        re.Resource_Status__c = 'Assigned';
                    }
                    if(re.Resource_Status__c.contains('Declined'))
                    {
                        re.Resource_Status__c = 'Direct Assignment';
                    }
                 }
                resReqInsList.addAll(resReqList);
             } 
            
            try{
                if(!resReqInsList.isEmpty()){
                   
                    Database.UpsertResult[] results = Database.upsert(resReqInsList,false);
                    for(Integer index = 0, size = results.size(); index < size; index++) {
                        if(results[index].isSuccess()) {
                            if(results[index].isCreated()) {
                                System.debug(resReqInsList[index].Opportunity_Name__c +' was created');
                            } else {
                                System.debug(resReqInsList[index].Opportunity_Name__c +' was updated');
                            }
                        }
                        if (!results.get(index).isSuccess()){
                            Database.Error err = results.get(index).getErrors().get(0);
                            System.debug('Error - '+err.getMessage() + '\nStatus Code : '+err.getStatusCode()+'\n Fields : '+err.getFields());
                            failedIds.add(resReqInsList[index].Opportunity_Name__c);
                            
                        }

                    }
                    if(!failedIds.isEmpty())
                    {
                       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Assignment failed for few opportunities'));
                    }
                }
            }
            catch(Exception e){
                System.debug('Exception: '+e.getMessage());
                String errorMessage;
                errorMessage = e.getMessage();
            }
            if(SaveNew==false || SaveNew==null){
                selectedOpp.clear();
                optyIdsList.clear();
            }
            loadMultiEdit(OpptysSelected);
            showSE();
        }
        
        return null;
    }
    
    //Shivisri - assignSomeElse functionality
    public PageReference seAssignSomeoneElse(){
        for(seOpportunity opp:seWrapperList)
        {
            if(opp.selected== true) {
                selectedOpp.add(opp.seOpp);
            }
        }
        for(Opportunity opp : selectedOpp) {
            optyIdsList.add(opp.Id);
        }
        if(optyIdsList.isEmpty()){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Please select an opportunity to assign '));
        }
        else{
            displayPopup = true;
        }
        return null;
    }      
    
    public void closePopup() {  
        //Clear all values on closing assignSomeoneelse popup
        if(searchBtn==true){
            users.clear();
        }
        searchKey='';
        commentsSec=null;
        displayError=false;
        displayData=false;
        selectedValues=null;
        SaveNew=false;
        //Setting as Default Value
        getSelected =  'email';
        displayPopup = false;
    }  
    public PageReference saveNClose(){
        //Clear all values on saving and closing assignSomeoneelse popup
        if(selectedValues!=null){
            SaveNew=false;
            seassignMyself();
            displayPopup = false;
            closePopup();
        }
        else{
            displayError=true;
            errorMessage='Select any User to proceed';
        }
        return null;
        
    }
    public void saveNew(){
        //Clear all values except comments on save and new button on the popup
        if(selectedValues!=null){
            for(seOpportunity opp:seWrapperList)
            {
                if(opp.selected== true) {
                    selectedOpp.add(opp.seOpp);
                }
            }
            for(Opportunity opp : selectedOpp) {
                optyIdsList.add(opp.Id);
            }
            if(optyIdsList.isEmpty())
            {
                displayError=true;
                errorMessage='Select any Opportunity';
            }
            
            else{
                SaveNew=true;
                seUserPermission=false;
                seassignMyself();
                if(searchBtn==true){
                    users.clear();
                }
                displayError=false;
                displayData=false;
                searchKey='';
                //radioHidden=null;
                //Setting as Default Value
                getSelected =  'email';
                seUserPermission=true;
            }
        }
        else{
            displayError=true;
            errorMessage='Select any User to proceed';
        }
    }
    
    public String errorMessage {get; set;}
    public String moreDataPresent{get; set;}
    public boolean displayData{get;set;}
    public boolean displayError{get;set;}
    public void search(){
        
        //shivisri - Here goes the search for email/first Name/last Name 
        if(!String.isBlank(searchKey) && searchKey.length()>2){            
            displayError=false;
            String searchKeyword =  '%' + searchKey + '%';
            String selVal = getSelected;
            String sQuery='Select id,firstname,lastname,email,SE_SAGE_Role__c FROM user where isActive=true AND '+selVal+' like:searchKeyword AND Additional_User_Permissions__c includes (\'SE User\') limit 10';
            users= Database.query(sQuery);
            if(users.size()>9){
                displayData=true;
                moreDataPresent='There are more than 10 records with the entered keyword';
            }
            else{
                displayData=false;
            }
            searchBtn=true;
            selectedValues=null;
        }
        //Display error if entered keyword size is less than 3
        else{
            displayError=true;
            displayData=false;
            errorMessage = 'Please enter atleast 3 characters';
        }
                
    }
    //shivisri - dropdown values for searchBy in assignsomeoneelse popup
    public List<SelectOption> getsearchBy() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('email','Email ID'));
        options.add(new SelectOption('firstName','First Name'));
        options.add(new SelectOption('lastName','Last Name'));
        return options;
        
    }
    public void passUserId(){
        selectedValues=Apexpages.currentPage().getParameters().get('myParam');
        //selectedValues=radioHidden;
    }
       
    //Added by Hari krishna : US328604  - to check whether logged in user is SEM or SED            
    public void checkSEMOrSED(String userCECId,Id userId) {
        List<User> reporteesLst =[SELECT id FROM User WHERE Reporting_Manager_Level_1_cec__c=:userCECId.toUpperCase() 
                                  AND Additional_User_Permissions__c includes ('SE User') and isActive=true
                                 ]; 
        if(!reporteesLst.isEmpty()) {
            isSEMOrSED = true;          
        }
        else{
            //Issue Fix - Many SE Managers don't have reportees assigned to them, check Title for them
            List<User> usrMOrD=[Select Title FROM User WHERE Id=:userId AND Additional_User_Permissions__c includes ('SE User') limit 1];
            String SEMOrD;
            if(!usrMOrD.isEmpty()){
                Map<String,Object> m = (Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(usrMOrD[0]));
                if(m.get('Title') != null){
                    SEMOrD = String.valueOf(usrMOrD[0].Title);
                    if(SEMOrD.toUpperCase().contains('MANAGER') || SEMOrD.toUpperCase().contains('DIRECTOR')){
                        isSEMOrSED = true;
                    }else{
                        isSEMOrSED = false;
                    }
                }
                else{
                    isSEMOrSED = false;
                }
            }
            else{
                isSEMOrSED = false;
            }
        }       
    }
}