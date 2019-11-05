public with sharing class SCP_Communities_PSREdit extends SCP_Communities_PageControllerBase
{
    
    // SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdate(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }
    
    
    public SCP_Communities_PSREdit() {
        initlize();
    }
    public string psr1Id {get;set;}
    public string psr2Id {get;set;}
    public string psr3Id {get;set;}
    public string psr1Name {get;set;}
    public string psr2Name {get;set;}
    public string psr3Name {get;set;}
    public Map<String, SCP_Communities_ComponentControllerBase> componentControllerMap { get; set; }
    public override Map<String, SCP_Communities_ComponentControllerBase> getComponentControllerMap(){       
        if(this.componentControllerMap == null ) {
            this.componentControllerMap = new Map<String, SCP_Communities_ComponentControllerBase>();
        }
        return this.componentControllerMap;
    }
    //new method for putting value in the hashmap
    public override void setComponentControllerMap(String key, SCP_Communities_ComponentControllerBase compController){     
        if(this.componentControllerMap == null) {
            this.componentControllerMap = new Map<String, SCP_Communities_ComponentControllerBase>();
        }
        this.componentControllerMap.put(key,compController);        
    } 

    public override SCP_Communities_PageControllerBase getThis() {
        System.debug(System.LoggingLevel.INFO, '*** INSIDE getThis OF TP');
        return (SCP_Communities_PSREdit)this;
    } 
    
    public void initlize() {
        string recordId = System.currentPageReference().getParameters().get('Id');
         psr= getPsr();
         if(recordId.startsWith('a')){
            /*
            Assigned_Partner__c ASP = [SELECT Id,Assigned_Partner_Sales_Rep__c,
                                            Assigned_Partner_Sales_Rep__r.Name,
                                            Assigned_Partner_Sales_Rep_2__c,Assigned_Partner_Sales_Rep_2__r.Name,
                                            Assigned_Partner_Sales_Rep_3__c,Assigned_Partner_Sales_Rep_3__r.Name
                                       FROM Assigned_Partner__c 
                                       WHERE Id=:recordId];
            psr1Id = ASP.Assigned_Partner_Sales_Rep__c;
            psr1Name = ASP.Assigned_Partner_Sales_Rep__r.Name;
            psr2Id = ASP.Assigned_Partner_Sales_Rep_2__c;
            psr2Name = ASP.Assigned_Partner_Sales_Rep_2__r.Name;
            psr3Id = ASP.Assigned_Partner_Sales_Rep_3__c;
            psr3Name = ASP.Assigned_Partner_Sales_Rep_3__r.Name;
            */
         }
         else{
            Lead ld = [select Id,PSR_1__c,PSR_1__r.Name,PSR_2__c,PSR_2__r.Name,PSR_3__c,PSR_3__r.Name from Lead where Id =: recordId];
            psr1Id = ld.PSR_1__c;
            psr1Name = ld.PSR_1__r.Name;
            psr2Id = ld.PSR_2__c;
            psr2Name = ld.PSR_2__r.Name;
            psr3Id = ld.PSR_3__c;
            psr3Name = ld.PSR_3__r.Name;
         }       
    }
    public String psrKey { 
        get{
            psrKey = 'psr';
            return psrKey;
        }
        set;
    }
    public Pagereference savePSR(){
        string psr1_Id, psr2_Id, psr3_Id;
        psr= getPsr();
        string recordId = System.currentPageReference().getParameters().get('Id');      
        psr1_Id = psr.psr1_Id;
        psr2_Id = psr.psr2_Id;
        psr3_Id = psr.psr3_Id;      
        if((psr1_Id == null || psr1_Id == '') && (psr2_Id == null || psr2_Id == '') && (psr3_Id == null || psr3_Id == '')) {
            ApexPages.addMessage(new ApexPages.Message(Apexpages.Severity.ERROR,'PSR\'s cannot be blank!'));                    
            return null;
        }
        if(recordId.startsWith('a')){           
            /*
            Assigned_Partner__c updatePSR = new Assigned_Partner__c(Id=recordId);
            if(psr1_Id != '')           
                updatePSR.Assigned_Partner_Sales_Rep__c=psr1_Id;
            if(psr2_Id != '')
                updatePSR.Assigned_Partner_Sales_Rep_2__c=psr2_Id;
            if(psr3_Id != '')
                updatePSR.Assigned_Partner_Sales_Rep_3__c=psr3_Id;
                
            update updatePSR;
            */
        }
        else{
            Lead updateLead = new Lead(Id=recordId);
            if(psr1_Id != '')
                //SCAVA FIX
                if(flsUpdate(Lead.PSR_1__c))
                {
                updateLead.PSR_1__c = psr1_Id;
                }
            if(psr2_Id != '')
            if(flsUpdate(Lead.PSR_2__c))
                {    
                    updateLead.PSR_2__c = psr2_Id;
                }
            if(psr3_Id != '')
            if(flsUpdate(Lead.PSR_3__c))
                {    
                    updateLead.PSR_3__c = psr3_Id; 
                }
                
            update updateLead;
        }
        
         return new PageReference ('/' + recordId);
    }
    public Pagereference Cancel(){
         string recordId = System.currentPageReference().getParameters().get('Id'); 
         return new PageReference ('/' + recordId);
    }
    public SCP_Communities_PSRBulk_CT psr { get; set; }

    public SCP_Communities_PSRBulk_CT getPsr() {

        if(getComponentControllerMap() != null && getComponentControllerMap().get(psrKey) != null) {
            psr = (SCP_Communities_PSRBulk_CT) getComponentControllerMap().get(psrKey);
            return psr;
        }
        return (new SCP_Communities_PSRBulk_CT());
    }
    public String getSearchPageUrl() {
        String baseUrl = Site.getBaseUrl();     
        if(baseUrl == null || baseUrl == '') {
            baseUrl =  '/';
        }
        else {
            List<String> listBase = baseUrl.split('/');
            if(listBase.size() > 1) {
                baseUrl = '/'+ listBase[(listBase.size()-1)] + '/';
            }
        }               
        String pageUrl = baseUrl + 'apex/SCP_Communities_psrSearch';                
        return pageUrl;
        
    }
}