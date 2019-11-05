public with sharing class CS_Lead_Accept_Button_Controller {
    
    private ApexPages.StandardSetController standardController;
    public List<Lead> selectedLeads;
    public Boolean displayTable{get;set;}
    public string errorMessage{get;set;}
    public String uiTheme;      
    
    public CS_Lead_Accept_Button_Controller(ApexPages.StandardSetController standardController){
        displayTable = true;
        errorMessage = '';
        this.standardController = standardController;
        selectedLeads =  new List<Lead>();
        if(!test.isRunningTest()){
            List<Org_Constants__c> orgConsList= [Select prod_value__c From Org_Constants__c where Key__c = 'Lead:Accepted Page Message' limit 1];
            system.debug('*****'+orgConsList);
        }
    }
    
    public PageReference getSelectedLeads(){       
        // Get the selected records (optional, you can use getSelected to obtain ID's and do your own SOQL)
        selectedLeads = (List<Lead>) standardController.getSelected();
        string constVal=null;
        List<Org_Constants__c> conList= [Select prod_value__c From Org_Constants__c where Key__c = 'Lead:Warning Error' limit 1];
        system.debug('*****'+conList);
        if(selectedLeads.size() == 0){
            displayTable = false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,conList[0].prod_value__c));
        }
        return null;        
    }
    
    public  PageReference updateLeadStatus(){
        PageReference pgRef = null;
        List<Org_Constants__c> conList= [Select prod_value__c From Org_Constants__c where Key__c = 'Lead:Status' limit 1];
        system.debug('*****'+conList);
        
        if(selectedLeads.size() > 0){
            for(Lead selectedLead : selectedLeads){
                //selectedLead.Status = '2 Accepted-Mine/Channel';
                if(!test.isRunningTest()){
                    selectedLead.Status = conList[0].prod_value__c;
                }
                selectedLead.OwnerID = userinfo.getUserId();
            }       
            // Call StandardSetController 'save' method to update (optional, you can use your own DML)
            standardController.save(); 			
        }
        return pgRef;
        
    }
    
    public pageReference cancelUpdateStatus(){
        pageReference  pgRef = new PageReference('/00Q/o');
        return pgRef;
    }
}