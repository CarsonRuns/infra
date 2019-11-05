public with sharing class OpportunityNewOverride_CT{
    public String recordType {get;set;}
    public List<RecordType>   rts{get; set;}
    public set<SelectOption> rtOptions{get; set;}
    public List<SelectOption> rtOptionsLst{get; set;}
    public Map<String,String> pageParams {get;set;}
    public Set<Id> setId {get;set;}
    public boolean isSf1 {get; set;}
    public string defaultRTName {get; set;}  //GDM use for Parent Opportunity default recordtype
    public Id defaultrtId {get; set;}
    public Id accId {get; set;}          // Added By Naresh (nkalahas@cisco.com)

    public OpportunityNewOverride_CT(ApexPages.StandardController ctrlr){
        isSf1 = isSF1();
        this.rtOptions = new set<SelectOption>();  
        this.rtOptionsLst = new List<SelectOption>();   

        
        //Use Schema to determine records types available to the running user
         accId = ApexPages.currentPage().getParameters().get('accid');       // Added By Naresh (nkalahas@cisco.com)

        Schema.DescribeSObjectResult R = Opportunity.SObjectType.getDescribe();
        List<Schema.RecordTypeInfo> rtInfos = R.getRecordTypeInfos();
        setId = new Set<Id>();
        for( Schema.RecordTypeInfo recordType : rtInfos ){
            if(recordType.isAvailable()){
                if(recordType.Name!='Master' && !recordType.Name.endsWith('Mobile')){
                    setId.add(recordType.getRecordTypeId());
                }
            }
            if (recordType.DefaultRecordTypeMapping){ //GDM Change for defaulting Parent recordtype
                    defaultRTName = recordType.Name;
                    defaultrtId = recordType.RecordTypeId;
            }
        }

        //Query RecordType object to get description of record types.
        if(!setId.isEmpty())
        this.rts = [SELECT Id, Name, Description FROM RecordType WHERE SObjectType = 'Opportunity' and id in: setId and IsActive= true];
        for(RecordType rt : rts){
                if(defaultRTName != ''){ //GDM Change for defaulting Parent recordtype
                    if(defaultRTName == 'Parent Opportunity'){
                        this.rtOptions.add(new SelectOption(defaultrtId,'New (Parent) Opportunity'));
                    }else{
                        this.rtOptions.add(new SelectOption(defaultrtId,defaultRTName));
                    }
                }
                if(rt.Name != defaultRTName){ //GDM Change for defaulting Parent recordtype
                    if(rt.Name == 'Parent Opportunity'){
                        this.rtOptions.add(new SelectOption((String)rt.Id, 'New (Parent) Opportunity'));
                    }else{
                        this.rtOptions.add(new SelectOption((String)rt.Id, rt.Name));
                    }
                }
        }
        
                  /* **********************************************************
           Added By Naresh (nkalahas@cisco.com) on 09/02/2018 
       ************************************************************  */   
        for(SelectOption so: rtOptions)
            {
              rtOptionsLst.add(so);
            }
            
            
            /* ******************************************** */
        
        this.pageParams = ApexPages.currentPage().getParameters();
    }
    
    public static Boolean isSF1(){
    
       String retUrl = ApexPages.currentPage().getParameters().get('retURL');
    
       return String.isNotBlank(ApexPages.currentPage().getParameters().get('sfdcIFrameHost')) ||
       String.isNotBlank(ApexPages.currentPage().getParameters().get('sfdcIFrameOrigin')) ||
       ApexPages.currentPage().getParameters().get('isdtp') == 'p1' ||
       (String.isNotBlank(retUrl) && retURL.contains('projectone'));
    
    }
    
    public String getUserDefaultOpportunityRecordType(){
        //find all Opportunity record types
        List<Schema.RecordTypeInfo> infos = Schema.SObjectType.Opportunity.RecordTypeInfos;
        Id defaultRecordTypeId;

        //check each one
        for (Schema.RecordTypeInfo info : infos) {
            if (info.DefaultRecordTypeMapping) {
                defaultRecordTypeId = info .RecordTypeId;
            }
        }
        
        return defaultRecordTypeId;
    }
    
          /* **********************************************************
           Added By Naresh (nkalahas@cisco.com) on 31/01/2018  to redirect to previous page on cancel
       ************************************************************  */          

       public PageReference doCancel() {


        PageReference pageRef = new PageReference('/' + accId );
        pageRef.setRedirect(true);
        return pageRef;
        }  
}