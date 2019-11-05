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
public class Alekhya_OpptyMultiEdit_CTE
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
    public Alekhya_OpptyMultiEdit_CTE(ApexPages.StandardSetController controller) 
    {
        listViewId = controller.getFilterId();
        OpptysSelected = (List<Opportunity>)controller.getSelected();
        checkUserAccess();
        loadSeData((List<Opportunity>)controller.getSelected());
        loadSpecialist((List<Opportunity>)controller.getSelected());
        loadMultiEdit((List<Opportunity>)controller.getSelected());
               
    }
    /**Added by Alekhya for user access check**/
    Public void  checkUserAccess(){
        existingMultiEditUser = false;
        seUserPermission = false;
        specialistPermission = false;
        isSEMOrSED = false;
		string additionalUserPermissions = [SELECT Additional_User_Permissions__c 
                       FROM User 
                       WHERE Id = :UserInfo.getUserId() and (Additional_User_Permissions__c != null or Additional_User_Permissions__c !='NA')
					   limit 1].Additional_User_Permissions__c;
	
		if(String.isNotBlank(additionalUserPermissions)){
			if(additionalUserPermissions.contains('SE User')){
				seUserPermission = true;
				isSEMOrSED = true;//for testing isSEMOrSED defined as true
				//integer reporteesCount= database.countQuery('SELECT count() FROM User WHERE Reporting_Manager_Level_1_cec__c=:userCECId.toUpperCase() AND Additional_User_Permissions_c includes (/'+'SE User'+'/) and isActive=true');
				
				string userCECId = (userInfo.getUserName()).substringBefore('@').toUpperCase();
				integer reporteesCount = [SELECT count() FROM User WHERE ((Reporting_Manager_Level_1_cec__c=:userCECId AND 
										  Additional_User_Permissions__c includes ('SE User')) or 
										 (Id=:UserInfo.getUserId() AND Additional_User_Permissions__c includes ('SE User') and 
													 Title in ('MANAGER','DIRECTOR'))) and isActive=true];

				if(reporteesCount > 0){
					isSEMOrSED = true;
				}
			}
			if(additionalUserPermissions.contains('Enable_ePSS') || additionalUserPermissions.contains('Enable_VSS')){
				specialistPermission = true;
			}
		}
        if(!specialistPermission && !seUserPermission){
			existingMultiEditUser = true;
		}
		system.debug('isSEMOrSED-->'+isSEMOrSED+' specialistPermission-->'+specialistPermission+' seUserPermission--->'+seUserPermission+' existingMultiEditUser-->'+existingMultiEditUser);
		if(seUserPermission && specialistPermission){
			specialistSEPermission = true;
		}
		
		
	}    
    
    public void loadMultiEdit(List<Opportunity> OpptysSelected)
    {	
		Opptys = new list<Opportunity>();
        //Changed SOQL to remove unnecessary fields -- Alekhya
        if(existingMultiEditUser){
            Opptys = [select id,DealID__c,Account.Name, name, stageName,closeDate,Expected_Product__c,Expected_Service__c,
								Description,Competitors__c,Other_Competitor__c,Primary_Partner__c,Win_Loss_Comments__c, RecordType.Name,
								Lost_Cancelled_Reason__c,Partner_Required__c from Opportunity where id in :OpptysSelected and
                                Opportunity.RecordType.Name != 'Solution Plan'
                                and Opportunity.RecordType.Name != 'Void Merged Opportunity'
                                and Contractual_Pricing_Letter_Opportunity__c != 'Yes'
                                order by Account.name, closedate];
		}
       
        
        
    }
    
    public void loadSpecialist(List<Opportunity> OpptysSelected){
        wrapOpportunityList = new List<wrapOpportunity>();
        if(specialistPermission){
            list<Opportunity> tempOppList = [select id, name, DealID__c, Account.Name,  stageName,closeDate,Expected_Product__c,Expected_Service__c,
								             Description,Competitors__c,Primary_Partner__c,Win_Loss_Comments__c, SE_Count__c,
								             Lost_Cancelled_Reason__c,Partner_Required__c,
								            (SELECT id,Service_Category__c,PriceBookEntry.ProductCode,
								             Product2.Business_Entity__c,Mix__c FROM OpportunityLineItems ORDER BY Mix__c DESC)
								             from Opportunity where id in :OpptysSelected];
		
			OpportunityTeamMember[] opptyTeamMembers = [SELECT TeamMemberRole,OpportunityId 
                                                    FROM  OpportunityTeamMember 
                                                    WHERE OpportunityId IN:OpptysSelected
                                                    AND UserId = : UserInfo.getUserId()];
            Map<string, string> mapOpTMRole = new map<string, string>();
            if(opptyTeamMembers.size()>0){
                for (OpportunityTeamMember opTM: opptyTeamMembers){
                    
                    mapOpTMRole.put(opTM.OpportunityId, opTM.TeamMemberRole);
                    
                }
            }
		
		
            if(tempOppList.size()>0){
                for (Opportunity O:tempOppList){
                    
                    wrapOpportunity tempWrapOpp = new wrapOpportunity(O);
                    //tempWrapOpp.opp = O;
                    tempWrapOpp.teamRole = mapOpTMRole.get(O.id);
                    
                    wrapOpportunityList.add(tempWrapOpp);
                    
                }
            }
        }
        
    }
    
    
    
    Public  void loadSeData(list<Opportunity> SelectedOpp){
	seWrapperList = new list<seOpportunity>();
		
        if(seUserPermission){
            list<Opportunity> tempOppList = new list<Opportunity>();
            if(isSEMOrSED){
				string strResurcStatuses = Org_Constant_CS__c.getValues('Resource Assignement Statuses').Production_Value__c;
				List<String> resStatusesLst = new List<String>();
                if(String.isNotBlank(strResurcStatuses)) {
                    resStatusesLst = strResurcStatuses.split(',');
                }
			
				tempOppList = [select id, name, DealID__c, Account.Name,Owner.Name,  stageName,closeDate,Expected_Product__c,Expected_Service__c,
								SE_Status__c,SE_Count__c, Description,Competitors__c, Other_Competitor__c,
								(SELECT id, name, Opportunity_Name__r.id,Resource_Status__c, Resource_Name__r.Name,Resource_Name__r.Alias,Resource_Name__r.UserName,  Assignment_Status__c
                                 ,SE_SAGE_Role__c  
								FROM Requests_and_Assignments__r WHERE Resource_Status__c in :resStatusesLst)
								from Opportunity where id in : SelectedOpp];
			
            }else {
                	tempOppList = [select id, name, DealID__c, Account.Name,Owner.Name,  stageName,closeDate,Expected_Product__c,Expected_Service__c,
                                    SE_Status__c,SE_Count__c, Description,Competitors__c, Other_Competitor__c,
                                    (SELECT id, name,Opportunity_Name__r.id, Resource_Status__c, Resource_Name__r.Name,Resource_Name__r.Alias,Resource_Name__r.UserName,  Assignment_Status__c
                                     ,SE_SAGE_Role__c  
                                    FROM Requests_and_Assignments__r WHERE (Resource_Status__c = 'Assigned' OR Resource_Status__c = 'Direct Assignment'))
                                    from Opportunity where id in : SelectedOpp];
                
            }
            
            List<AggregateResult> tempTechService = [SELECT OpportunityId, PriceBookEntry.ProductCode ProductCode,Product2.Business_Entity__c Business_Entity__c,Sum(Mix__c) Mix__c FROM OpportunityLineItem
                                                    where OpportunityId in: SelectedOpp and Product2.Business_Entity__c != null group by 
                                                    PriceBookEntry.ProductCode,Product2.Business_Entity__c, OpportunityId];
            map<id,list<seTech>> mapTech = new map<id,list<seTech>>();
            map<id,list<seService>> mapService = new map<id,list<seService>>();
            
            for (AggregateResult ts: tempTechService){
                if((string)ts.get('ProductCode') == 'Technology'){
                    if(mapTech.containsKey((id)ts.get('OpportunityId'))){
                        list<seTech> TempT = mapTech.get((id)ts.get('OpportunityId'));
                        seTech temp_a = new seTech();
                        temp_a.techBE = (string)ts.get('Business_Entity__c');
                        temp_a.techMixPercent = (Decimal)ts.get('Mix__c');
                        TempT.add(temp_a);
                        //TempT.add(new seTech((string)ts.get('Business_Entity__c'),(Decimal)ts.get('Mix__c')));
                        mapTech.put((id)ts.get('OpportunityId'),TempT);
                    } else{
                        list<seTech> TempT =  new list<seTech>();
                        seTech temp_a = new seTech();
                        temp_a.techBE = (string)ts.get('Business_Entity__c');
                        temp_a.techMixPercent = (Decimal)ts.get('Mix__c');
                        TempT.add(temp_a);
                        //tempTS.add( new seService((string)ts.get('Business_Entity__c'),(Decimal)ts.get('Mix_c')));
                        mapTech.put((id)ts.get('OpportunityId'),TempT);
                    }
                }else {
                    if(mapService.containsKey((id)ts.get('OpportunityId'))){
                        list<seService> TempT = mapService.get((id)ts.get('OpportunityId'));
                        seService temp_a = new seService();
                        temp_a.serviceBE = (string)ts.get('Business_Entity__c');
                        temp_a.serviceMixPercent = (Decimal)ts.get('Mix__c');
                        TempT.add(temp_a);
                        //TempT.add(new seServiceTech((string)ts.get('Business_Entity__c'),(Decimal)ts.get('Mix__c')));
                        mapService.put((id)ts.get('OpportunityId'),TempT);
                    } else{
                        list<seService> tempTS =  new list<seService>(); 
                        seService temp_a = new seService();
                        temp_a.serviceBE = (string)ts.get('Business_Entity__c');
                        temp_a.serviceMixPercent = (Decimal)ts.get('Mix__c');
                        tempTS.add(temp_a);
                        //tempTS.add(new seServiceTech((string)ts.get('Business_Entity__c'),(Decimal)ts.get('Mix__c')));
                        mapService.put((id)ts.get('OpportunityId'),tempTS);
                    }
                }
                
                
            }
		
            for (Opportunity O: tempOppList){
                seOpportunity seWrapper = new seOpportunity();  
                seWrapper.seOpp = O;
                seWrapper.tech =  mapTech.get(O.id);
                seWrapper.service =   mapService.get(O.id);
                // add to final wrapper list to use in vf page
                seWrapperList.add(seWrapper);
            }
        }
		



		
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
    
        /*for(Opportunity o : OpptysToUpdate ){
            updateMuliteditMap.put(o.Id,o);
           
        } */       
        try
        {
            //update( updateMuliteditMap.values());
			update(OpptysToUpdate);
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
            options.add( new SelectOption( '', '--None--') );        
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
        /*for(Opportunity o : seOpptysToUpdate ){
            seUpdateMultiEditMap.put(o.Id,o);
        } *///Alekhya
        // update optys
        try
        {
			update(seOpptysToUpdate);
            //update( seUpdateMultiEditMap.values());
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
        System.debug('selectedOpp>> '+selectedOpp);
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
            System.debug('optyIdsList>> '+optyIdsList);
            System.debug('seWrapperList>> '+seWrapperList);
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
        System.debug('>>>>> '+selectedValues);
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
            String searchKeyword = '%' + String.escapeSingleQuotes(searchKey) + '%';//for security against SOQL injection
            String selectedVal = getSelected;
            system.debug('searchKeyword-->'+searchKeyword);
            //changed to add for escapeSingleQuotes security against SOQL injection--Alekhya
            String sQuery='Select id,firstname,lastname,email,SE_SAGE_Role__c FROM user where isActive=true AND '+selectedVal+' like : searchKeyword  AND Additional_User_Permissions__c includes (\'SE User\') limit 10';
            system.debug('sQuery-->'+sQuery);
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
            System.debug('>>>'+errorMessage);
        }
        System.debug('SearchKey '+searchKey);
        System.debug('Users>> '+users);
       
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
        System.debug('>>>>> '+selectedValues);
    }

}