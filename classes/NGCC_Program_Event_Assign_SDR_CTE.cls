/********************************************************************************************************************************
Name    : NGCC_Program_Event_Assign_SDR_CTE 
Author  : Mukesh Srivastava
Purpose : This is the controller extension class to all show all lead assocaite to program event
Allow Contact center manager to bulk assign SDR for unassigned leads
Created Date:  2/7/2014
Modification History: 
1. 	Author  : Ghattamaneni Chaithanya
	Purpose : Scava Fixes
	Changes : 
		1. Added SCAVA Fixes in getSelected() method
	date    : Oct 16,2018
***********************************************************************************************************************************/

public with sharing class NGCC_Program_Event_Assign_SDR_CTE {
    
    public String txtOwnersName {get;set;}
    public Integer noOfRecords {get;set;}
    public Integer size {get;set;}
    public String filterListView {get;set;}
    public String oldFilterListView {get;set;}
    public ApexPages.StandardSetController setCon {get;set;}
    Public Boolean refreshPage {get; set;}
    public Lead ld {get; set;}
    public list<selectOption> leadPriority {get; set;}
    
    public boolean intialLoad; 
    public string selectedPriority{get; set;}
    public boolean query {get; set;}
    
    //Ensure the wrapper class is available during Test class 
    @TestVisible List < LeadWrapperCls > leadList = new List < LeadWrapperCls > ();
    List < Lead > selectedLeads = new List < Lead > ();
    private final Campaign mCampaign;

    public NGCC_Program_Event_Assign_SDR_CTE(ApexPages.StandardController controller) {
        selectedPriority = '';
        leadPriority = new list<selectOption>();
        this.mCampaign = (Campaign) controller.getRecord();
        filterListView = 'All';  
        oldFilterListView = '';
        refreshPage = false;
        intialLoad = true;
        query = true;
        ld = new lead();
        ld.CC_Call_Priority__c = '';
    }
    
    /* @method: Validating user role and show Assign SDR functionality
	// @return: false if user is SDR else true */
    public boolean getValidateUser() {
        refreshData();
        try {
            UserRole usrRole = [Select name from UserRole where Id = : UserInfo.getUserRoleId() LIMIT 1];
            if (usrRole.Name.contains('SDR')) {        // If SDR User then donot show Assign SDR                
                return false;                  
            } else {                
                return true;                
            }            
        } catch (Exception e) {
            return null;
        }
    }

    /* @method: Get the Data associated to campaign with filters */
    public void refreshData() {
        size = 5;
        system.debug('ld.CC_Call_Priority__c>>>'+ld.CC_Call_Priority__c);
        system.debug('query>>>'+query);
        
        if (oldFilterListView != filterListView || query == true) {            
            string strLike = '%';
            // Filter the controller with only unassigned record by default and whenever user selects Unassigned filter
            if (filterListView == 'Unassigned' && query == true) {                
                query = false;
                string queryString = 'SELECT ';
                for (Schema.FieldSetMember f: SObjectType.Lead.FieldSets.NGCCLeadSDRAssignment.getFields()) {
                    queryString += f.getFieldPath() + ', ';
                }
                queryString += 'Id FROM Lead Where Campaign_Name__c =\'' + mCampaign.Id + '\' AND Owner.Name Like \''+strLike+'Unassigned'+strLike+'\'' ;                
                system.debug('ld.CC_Call_Priority__c1>>>'+ld.CC_Call_Priority__c);
                system.debug('query1>>>'+query);
                if(ld.CC_Call_Priority__c != null && ld.CC_Call_Priority__c != ''){
                    queryString = queryString + ' ' + 'and CC_Call_Priority__c='+'\''+ld.CC_Call_Priority__c+'\'';
                }
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
                setCon.setPageSize(size);
                noOfRecords = setCon.getResultSize();             
                if(intialLoad == true){
                    intialLoad = false;
                    set<string> optionTmp = new set<string>();
                    list<lead> tmpLead = new list<lead>();
                    tmpLead = database.query(queryString);
                    for(Lead Ltmp : tmpLead){                        
                        if(Ltmp.CC_Call_Priority__c != null){
                            optionTmp.add(Ltmp.CC_Call_Priority__c);
                        }
                    }
                    for(string sTmp :optionTmp){
                        leadPriority.add(new selectOption(sTmp,sTmp));
                    }
                } 
            } else if(query == true){
                query = false;
                string queryString = 'SELECT ';
                for (Schema.FieldSetMember f: SObjectType.Lead.FieldSets.NGCCLeadSDRAssignment.getFields()) {
                    queryString += f.getFieldPath() + ', ';
                }
                queryString += 'Id FROM Lead Where Campaign_Name__C =\'' + mCampaign.Id + '\'';
                
                system.debug('ld.CC_Call_Priority__c>>>'+ld.CC_Call_Priority__c);
                system.debug('query>>>'+query);
                if(ld.CC_Call_Priority__c != null && ld.CC_Call_Priority__c != ''){
                    queryString = queryString + ' ' + 'and CC_Call_Priority__c='+'\''+ld.CC_Call_Priority__c+'\'';
                }
                system.debug('queryString>>>'+queryString);
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
                setCon.setPageSize(size);
                noOfRecords = setCon.getResultSize();
                if(intialLoad == true){
                    intialLoad = false;
                    set<string> optionTmp = new set<string>();
                    list<lead> tmpLead = new list<lead>();
                    tmpLead = database.query(queryString);
                    for(Lead Ltmp : tmpLead){
                        if(Ltmp.CC_Call_Priority__c != null){
                            optionTmp.add(Ltmp.CC_Call_Priority__c);
                        }                        
                    }                    
                    for(string sTmp :optionTmp){
                        leadPriority.add(new selectOption(sTmp,sTmp));
                    }
                }
            }
        } else {
            setCon = setCon;
        }
        oldFilterListView = filterListView;
    }
    
    /* @Return the list of Leads associated to Campaign*/
    public List < LeadWrapperCls > getLeads() {        
        leadList.clear();
        for (Lead l: (List < Lead > ) setCon.getRecords())
            leadList.add(new LeadWrapperCls(l));
        return leadList;
    }
    
    /* @method: Process the selected lead for assigning SDR */
    public void getSelected() {
        try{
            if (txtOwnersName != '000000000000000') {
                for (LeadWrapperCls lwrapper: leadList)
                    if (lwrapper.selected == true) {
                         //SCAVA FIX
                        if(flsUpdateGet(lead.OwnerId)){
                            lwrapper.lead.OwnerId = txtOwnersName;
                        }//SCAVA
                        selectedLeads.add(lwrapper.lead);
                    }               
                if(!selectedLeads.isEmpty()){
                    Database.SaveResult[] updateResult = Database.update(selectedLeads, false);
                    refreshPage = true;
                }else{
                    ApexPages.Message myMsglist = new ApexPages.Message(ApexPages.severity.ERROR, 'You havent selected any Lead record for Assignment.');
                    ApexPages.addMessage(myMsglist);
                    refreshPage = false;
                }
            } else {
                ApexPages.Message myMsglist = new ApexPages.Message(ApexPages.severity.ERROR, 'You havent selected any Owner or Owner is invalid.');
                ApexPages.addMessage(myMsglist);
                refreshPage = false;
            }
        }catch (Exception e){
            ApexPages.Message myMsglist = new ApexPages.Message(ApexPages.severity.ERROR, 'Sorry.Selected SDR is not valid.Please use Lookup to find the correct SDR');
            ApexPages.addMessage(myMsglist);
        }
    }
    
    /* @Wrapper Class to hold selectable list */
    @TestVisible public class LeadWrapperCls {
        public Lead lead {
            get;
            set;
        }
        public Boolean selected {
            get;
            set;
        }
        public LeadWrapperCls(Lead l) {
            lead = l;
            selected = false;
        }
    }
   
    // SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdateGet(SObjectField field) {
        return field.getDescribe().isUpdateable() ? true : false;
    }
}