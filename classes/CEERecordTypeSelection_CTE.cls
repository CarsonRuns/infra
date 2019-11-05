/**
* @author       Santosh Duuvri
* @version      Intial version (1.0)
* @since        2015-05-01 (YYYY-MM-DD)
**/
public with sharing class CEERecordTypeSelection_CTE {
    /**
    * Variable used to display CEE record type on page
    **/
    public CEE__c ceeRec { get; set; }
    
    /**
    * Variable used to call redirectToPage() method of RediectExtension class
    **/
    private CEERedirectExtension redirectExt {get; set; }
    
    /**
    * Jiffle Now record type Id
    **/
    transient static string jiffleRecTypeId = '01280000000GEyYAAW';
    /**
    * Master record type name
    **/
    transient static final string masterRecTypeName = 'Master';
    public String objectName = 'CEE__c';
    
    /**
    * Empty Default constructor
    **/
    public CEERecordTypeSelection_CTE() {
        
    }    
    /**
    * Extension contstructor
    * @param        Standard controller
    **/
    public CEERecordTypeSelection_CTE(ApexPages.StandardController controller) {
        this.ceeRec = (CEE__c)controller.getRecord();
        redirectExt = new CEERedirectExtension(controller);
         String objectEnt = objectName;
        if(objectName.contains('__c')){
            sObject s = Database.query('select ' + objectName + ' from Custom_Object_ID__c limit 1');
            objectEnt = (String)s.get(objectName);
        }
    }
    
    
   
    public String getUserDefaultOpportunityRecordType(){
        Id defaultRecordTypeId;
        String[] types = new String[]{objectName};
        // Make the describe call
        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);

        System.debug('Got describe information for ' + results.size() + ' sObjects.');

        // For each returned result, get some info
        for(Schema.DescribeSobjectResult res : results) {
            //check each one
            for (Schema.RecordTypeInfo info : res.getRecordTypeInfos()) {
                if (info.DefaultRecordTypeMapping) {
                    defaultRecordTypeId = info.RecordTypeId;
                }
            }
        }

        return defaultRecordTypeId;
    }
    
    /**
    * Function to check if page is loaded in Salesforce1 App or Not
    * @return       Boolean value true if loaded from SF1 app else false
    **/
    public boolean isSF1{
        get {
            String retUrl = ApexPages.currentPage().getParameters().get('retURL');
            return (
                String.isNotBlank(ApexPages.currentPage().getParameters().get('sfdcIFrameHost')) || 
                String.isNotBlank(ApexPages.currentPage().getParameters().get('sfdcIFrameOrigin')) || 
                ApexPages.currentPage().getParameters().get('isdtp') == 'p1' || 
                (String.isNotBlank(retUrl) && retURL.contains('projectone'))
            );
        }
    }
    /**
    * <p> 
    * Function to set RecordType parameters to the page and call redirectToPage method
    * This function will get called when user clicks on continue after selecting
    * record type on desktop
    * <p>
    * @return       Pagereference to which user will be redirected
    **/
    /*public Pagereference setRecordType() {
        String recTypeId = ceeRec.RecordTypeId;
        recTypeId = recTypeId.substring(0,15);
        //Check if recordtype paramter is set, if not set the paramter
        if(!ApexPages.currentPage().getParameters().containsKey('RecordType') && 
           (ApexPages.currentPage().getParameters().get('RecordType') == null ||
            ApexPages.currentPage().getParameters().get('RecordType') == '')) {
                ApexPages.currentPage().getParameters().put('RecordType',recTypeId);
            }
        
        //Call redirectmethod to get pagereference url
        Pagereference pg = redirectExt.redirectToPage();
        System.debug(System.LoggingLevel.INFO, '----- pg: '+pg);
        if(pg != null) {
            pg.setRedirect(true);
        }
        return pg;
    }*/
    
    
    public Pagereference setRecordType() {
        String recTypeId = ceeRec.RecordTypeId;     
        recTypeId = recTypeId.substring(0,15);    
        system.debug('recTypeId====>'+recTypeId);   
        //Check if recordtype paramter is set, if not set the paramter
        if(!ApexPages.currentPage().getParameters().containsKey('RecordType') && 
           (ApexPages.currentPage().getParameters().get('RecordType') == null ||
            ApexPages.currentPage().getParameters().get('RecordType') == '')) {
                system.debug('recTypeId1====>'+recTypeId);  
                ApexPages.currentPage().getParameters().put('RecordType',recTypeId);
            }
        
        //Call redirectmethod to get pagereference url      
        if(recTypeId == objectRecordTypeIds__c.getOrgDefaults().CEE_OBX_Record_Type_ID__c.substring(0,15)){  
            system.debug('recTypeId2====>'+recTypeId);  
            string strUline = redirectExt.redirectToPage().getURL();      
            String strRetURL = ApexPages.currentPage().getParameters().get('retURL');                                                                                                   
            strUline = strUline.replace('CEENewRecordTypeRedirect','CEEIntermediatePage');                                  
            PageReference pg= new PageReference(strUline+'&retURL='+strRetURL);                 
            pg.setRedirect(true);  
            return pg;
        }
        else{                       
            return redirectExt.redirectToPage();             
        }
        //System.debug(System.LoggingLevel.INFO, '----- pg: '+pg);
        /*if(pg != null) {
            pg.setRedirect(true);
        } */       
    }
    
    
    /**
    * <p>
    * Function to get JSON string of RecTypeWrapper List 
    * excuding Jiffle Now record type.
    * <p>
    * This function will get called on the page load in SF1 mobile app
    * using VF remoting
    * <p>
    * @return       JSON string with a list of RecTypeWrapper's
    **/
    @RemoteAction
    public static string fetchRecordTypeList() {
        
        String orgCon = ObjectRecordTypeIds__c.getOrgDefaults().CEE_Jiffle_Now_Record_Type_Id__c ;
        
        jiffleRecTypeId = (orgCon != '' && orgCon != null) ? orgCon : jiffleRecTypeId;
        
        List<RecTypeWrapper> recTypeList = new List<RecTypeWrapper>();
        
        Schema.DescribeSObjectResult cee = CEE__c.SObjectType.getDescribe();
        Map<Id, Schema.RecordTypeInfo> recTypeInfoMap = cee.getRecordTypeInfosById();
        
        for(RecordType recType : [Select Id, Description, Name
                                  From RecordType 
                                  Where sObjectType = 'CEE__c' and IsActive = true]) 
        {
            Schema.RecordTypeInfo rt = recTypeInfoMap.get(recType.Id);
            if(rt.isAvailable() && 
               !rt.getName().equalsIgnoreCase(masterRecTypeName) &&
               (rt.getRecordTypeId() != jiffleRecTypeId &&
                rt.getRecordTypeId() != jiffleRecTypeId.substring(0,15))) {
                    recTypeList.add(new RecTypeWrapper(rt.getRecordTypeId(),rt.getName(),recType.Description ,rt.isDefaultRecordTypeMapping()));
                }
        }
        return JSON.serialize(recTypeList);
    }
    /**
    * Wrapper class used to form JSON with RecordType Name and Id
    **/
    private class RecTypeWrapper {
        public string recordTypeId { get; protected set; }
        public string recordTypeName { get; protected set; }
        public string recordTypeDescription { get; protected set;}
        public boolean isDefault { get; protected set; }
        
        public RecTypeWrapper(string id, string name, boolean isDefault) {
            this.recordTypeId = id;
            this.recordTypeName = name;
            this.recordTypeDescription = '';
            this.isDefault = isDefault;
        }    
        public RecTypeWrapper(string id, string name, string des,boolean isDefault) {
            this.recordTypeId = id;
            this.recordTypeName = name;
            this.recordTypeDescription = des;
            this.isDefault = isDefault;
        }
    }
    /**
    * RecTypeWrapper List used display record type info on Desktop
    **/
    public List<RecTypeWrapper> recTypeInfoList ;
    
    /**
    * Getter method to populate avalable record type info
    * @return       List of RecTypeWrapper with record type details
    **/
    public List<RecTypeWrapper> getRecTypeInfoList() {
        if(recTypeInfoList == null) {
            recTypeInfoList = new List<RecTypeWrapper>();
            Schema.DescribeSObjectResult cee = CEE__c.SObjectType.getDescribe();
            Map<Id, Schema.RecordTypeInfo> recTypeInfoMap = cee.getRecordTypeInfosById();
            
            for(RecordType recType : [Select Id, Description, Name
                                      From RecordType 
                                      Where sObjectType = 'CEE__c' and IsActive = true]) 
            {
                Schema.RecordTypeInfo rt = recTypeInfoMap.get(recType.Id);
                if(rt.isAvailable() && 
                   !rt.getName().equalsIgnoreCase(masterRecTypeName)) {
                        recTypeInfoList.add(new RecTypeWrapper(rt.getRecordTypeId(),rt.getName(),recType.Description ,rt.isDefaultRecordTypeMapping()));
                    }
            }
            
        }
        return recTypeInfoList;
    }
    /**
    * Setter method for RecTypeInfoList
    * @param        RecTypeWrapperList
    **/
    private void setRecTypeInfoList(List<RecTypeWrapper> value) {
        this.recTypeInfoList = value;
    }
    
    /**
    * Variable used contains comma seperated value of CEE record type id available for SF1
    **/
    public String GetSf1CeeRecTypeIdsCsv() {
        String sf1CeeRecTypeIdsCsv = '';
        List<RecTypeWrapper> ceeRtwList = getRecTypeInfoList();
        if(ceeRtwList != null){
            for(integer i=0; i<ceeRtwList.size(); i++){
                Id jiffleRecodrTypeId = jiffleRecTypeId;
                Id ceeRecordTypeId = ceeRtwList[i].recordTypeId;
                if( ceeRecordTypeId != jiffleRecodrTypeId ){
                    sf1CeeRecTypeIdsCsv += ceeRecordTypeId + '.';
                }
            }
        }
        
        return sf1CeeRecTypeIdsCsv;
    }
}