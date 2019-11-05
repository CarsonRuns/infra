public with sharing class SCP_Communities_viewSetting_CT{

    // SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdateGet(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }
    // SCAVA Helper Method to validate Create Access at field level
     public static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }
    
    public ID view {get;set;}
    public SelectOption [] selectedOptions { get; set; }
    public String viewSettingMsg {get;set;}
    public String viewName { get; private set; }
    public Boolean saveForAllViews { get; set; }

    public SelectOption [] availableOptions { get; set; }
    public SelectOption [] availableSortOptions { get; set; }
    
    public SelectOption [] sortOrder { get; set; }
    
    public list<sortFields> sortfieldsUI{get;set;}
    public Map<String, String> optionsMap { get; set; }
    public string UserPrefId{get;set;}
    public Boolean isDisti {
    get{      
            return (prmFilterUtility.loggedInUserIsDisti =='Distributor')?true:false;
       }
    }    
    public SCP_Communities_viewSetting_CT() {
        Map<String, Schema.SobjectField> allfieldsmap = Schema.SObjectType.User_Preference__c.fields.getMap();
        Schema.DescribeFieldResult describedField = allfieldsmap.get('Lead_Available_Fields__c').getDescribe();
        
        //update running user preferred view setting if passed in view param
       view = ApexPages.currentpage().getParameters().get('view');
       viewSettingMsg = System.label.SCP_communities_viewSettingMsg;
       ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, viewSettingMsg);
       ApexPages.addMessage(msg);
       viewName =  prmFilterUtility.scpListViewsMapById.get(view).Custom_Label__c;
       saveForAllViews = false;      

        Schema.DescribeFieldResult leadCategory  = User_Preference__c.Lead_Available_Fields__c.getDescribe();        
        string availFields = (prmFilterUtility.viewPreferenceMap != NULL && prmFilterUtility.viewPreferenceMap.get(view) != null && prmFilterUtility.viewPreferenceMap.get(view).Selected_column_order__c != null) ? prmFilterUtility.viewPreferenceMap.get(view).Selected_column_order__c : '';
        string sortFields = (prmFilterUtility.viewPreferenceMap != null && prmFilterUtility.viewPreferenceMap.get(view) != null && prmFilterUtility.viewPreferenceMap.get(view).Columns_Sort_Order__c != null) ? prmFilterUtility.viewPreferenceMap.get(view).Columns_Sort_Order__c: '';
        availableOptions = new List<SelectOption>();
        selectedOptions = new List<SelectOption>();
        UserPrefId = (prmFilterUtility.viewPreferenceMap != NULL && prmFilterUtility.viewPreferenceMap.get(view) != null) ? prmFilterUtility.viewPreferenceMap.get(view).Id : null;
                
        optionsMap = new Map<String, String>();
        availableSortOptions = new list<selectOption>();
        availableSortOptions.add(new selectOption('','--'+Label.PRM_Select+'--'));
        availableSortOptions.add(new selectOption('Customer Name',Label.PRM_Customer_Name));
        for(Schema.Picklistentry sp : leadCategory.getPicklistValues()) {
          if((availFields != '' || availFields != null) && !availFields.contains(sp.value)){            
            if(sp.value != 'Lead From Distributor' && sp.value != 'Partner Name'){               
                availableOptions.add(new SelectOption(sp.value,getPickListLabels(sp.value)));                
            }
            else{
                if(!isDisti && sp.value == 'Lead From Distributor'){
                    availableOptions.add(new SelectOption(sp.value,sp.label));
                }
                 // Modified By: Sudi 19 Aug 2015 
                  // Release : Aug Sprint 4
                  // User Story : US8845
                  // Below code is commented for Disti users partner name is always display in lead views
                /*if(isDisti && sp.value == 'Partner Name'){
                    availableOptions.add(new SelectOption(sp.value,sp.label));
                }*/
            }
          }          
          if(sp.value != 'Lead From Distributor' && sp.value != 'Partner Name'){                                  
                availableSortOptions.add(new SelectOption(sp.value,getPickListLabels(sp.value)));             
          }
          else{
            if(!isDisti && sp.value == 'Lead From Distributor'){
                    availableSortOptions.add(new SelectOption(sp.value,sp.label));
                }
                if(isDisti && sp.value == 'Partner Name'){
                    availableSortOptions.add(new SelectOption(sp.value,sp.label));
                }
            
          }
          optionsMap.put(sp.label,sp.value);
        }
                
        if(availFields != null && availFields != ''){
            for(string s : availFields.split(';')){
                selectedOptions.add(new SelectOption(s,getPickListLabels(s)));
            }
        }   
                
        sortOrder = new list<SelectOption>();
        sortOrder.add(new selectOption('asc','ASC'));
        sortOrder.add(new selectOption('desc','DESC'));   
        sortfieldsUI = new list<sortFields>();  
        if(sortFields != ''){                       
            for(string s : sortFields.split(';')){
                if(s != ''){                    
                    sortFields sf= new sortFields();
                    string [] arrStr = s.split('~~');
                    sf.sortOrder = arrStr[1];
                    sf.sortfield = arrStr[0];
                    sortfieldsUI.add(sf);   
                }           
            }           
            if(sortfieldsUI.size() != 5 && sortfieldsUI.size() < 5){                
                for(integer i=sortfieldsUI.size(); i<5; i++)    {
                    sortFields sf= new sortFields();            
                    sortfieldsUI.add(sf);
                }
            }
        }
        else{
            for(integer i=0; i<5; i++)  {
                sortFields sf= new sortFields();            
                sortfieldsUI.add(sf);
            }   
        }
    }
    public string getPickListLabels(string Value){
        string strReturn = '';
         Schema.DescribeFieldResult leadCategory  = User_Preference__c.Lead_Available_Fields__c.getDescribe();
          for(Schema.Picklistentry sp : leadCategory.getPicklistValues()) {
            if(sp.Value == Value){
                if(sp.value == 'Lead Source'){
                    strReturn = Lead.LeadSource.getDescribe().getLabel();
                }
                else if(sp.value == 'Industry'){
                    strReturn = Lead.Industry.getDescribe().getLabel(); 
                }
                else{
                    strReturn = sp.Label;
                }
                break; 
            }
          }
          return strReturn;
    }
    public class sortFields{
        public sortFields(){
            this.sortOrder = 'asc';
        }
        public string sortOrder { get; set; }
        public string sortfield{get;set;}
                  
    }   
    public pageReference SavePreference(){      
        string SelectedField = '';
        string sortData ='';        
        for(SelectOption so : selectedOptions){             
            if(so.getvalue() != 'None'){
                SelectedField += so.getvalue() +';';
            }
        }
        for(sortFields sf : sortfieldsUI){
            if(sf.sortfield != null){
                sortData += sf.sortfield + '~~' + sf.sortOrder +';';
            }
        }       
        if(SelectedField != '')
        {
            SelectedField = SelectedField.removeEnd(';');
        }       
        if(sortData != ''){
            sortData = sortData.removeEnd(';');
        }       
        
        if(saveForAllViews){
            list<User_Preference__c> lstUpdate = new list<User_Preference__c>();
            map<string,User_Preference__c> mpUserPre = PrmFilterUtility.viewPreferenceMap;                                      
            for(Id viewId : PrmFilterUtility.scpListViewsMapById.keyset()){                         
                if(PrmFilterUtility.scpListViewsMapById.get(viewId).ObjectType__c == 'Lead') {                  
                    User_Preference__c up = new User_Preference__c();                       
                    up.Id = (mpUserPre != null && mpUserPre.get(viewId) != null) ? mpUserPre.get(viewId).Id : null;
                    up.Name = userinfo.getName();
                    if(flsUpdateGet(User_Preference__c.Selected_column_order__c )||flsGet(User_Preference__c.Selected_column_order__c )) //SCAVA FIX
                    {
                    up.Selected_column_order__c = SelectedField;
                    }
                    if(flsUpdateGet(User_Preference__c.Columns_Sort_Order__c)||flsGet(User_Preference__c.Columns_Sort_Order__c)) //SCAVA FIX
                    {
                    up.Columns_Sort_Order__c = sortData;
                    }
                    if(flsUpdateGet(User_Preference__c.User__c)||flsGet(User_Preference__c.User__c)) //SCAVA FIX
                    {
                    up.User__c=  userinfo.getUserId();
                    }
                    if(flsUpdateGet(User_Preference__c.View_Id__c)||flsGet(User_Preference__c.View_Id__c)) //SCAVA FIX
                    {
                    up.View_Id__c = viewId;
                    }
                    lstUpdate.add(up);
                }
            }
            if(!lstUpdate.isEmpty())
                upsert lstUpdate;                       
        }
        else{
                User_Preference__c insertLeadPreference = new User_Preference__c();
                insertLeadPreference.id = UserPrefId;
                if(flsUpdateGet(User_Preference__c.Name)||flsGet(User_Preference__c.Name)) //SCAVA FIX
                {
                insertLeadPreference.Name = userinfo.getName();
                }
                insertLeadPreference.Selected_column_order__c = SelectedField;
                insertLeadPreference.Columns_Sort_Order__c = sortData;
                insertLeadPreference.User__c=  userinfo.getUserId();
                insertLeadPreference.View_Id__c = view;
                upsert insertLeadPreference;          
        }
        return null;
    }
    
}