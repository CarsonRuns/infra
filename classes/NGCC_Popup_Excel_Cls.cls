public class NGCC_Popup_Excel_Cls{
    
    //@Variables declaration here
    public string  endDateFixed{get;set;}
    public string  searchCallCenter{get;set;}
    public string  startDateFixed{get;set;}
    public Transient  List<LeadHistory> requalificationLeads{get;set;}
    Public static List<string> customLabelCountries {get;set;}
    Public static List<string> customLabelUserList {get;set;}
    public Transient  List<RequalificationRecordsTempHolder> tempHistory {get;set;}
    
    //@Constructor: Getting parameters from URL.
    public NGCC_Popup_Excel_Cls(){
        endDateFixed = apexpages.currentpage().getparameters().get('endDateFixed');
        searchCallCenter = apexpages.currentpage().getparameters().get('searchCallCenter');
        startDateFixed = ApexPages.CurrentPage().getParameters().get('startDateFixed');
    }
    
    //@Static:Gettting list of user names and Countries from custom labels
    static{
        customLabelCountries = label.NGCC_Requalification_Countries.split(';');
        customLabelUserList  = label.NGCC_Requalification_UserList.split(';');
    }
    
    //@Method : On page load downloading report
    public void cmdExportToExcel(){
        if(searchCallCenter !=NULL && searchCallCenter != '' && searchCallCenter != '--None--'){
            requalificationLeads = [SELECT  LeadId,lead.Name,lead.lastname,lead.firstname,LEAD.STATUS,lead.SDR_Lead_Owner_Name__c,lead.CustomCountry__c, NewValue, OldValue,createdby.name, CreatedDate,Lead.leadsource,
            lead.recordtypeid,lead.Call_Center_Vendor__c,lead.Lead_Qualifier_Call_Center__c FROM LeadHistory 
            where (field='Call_Status__c') and
            lead.CustomCountry__c in :customLabelCountries  and
            Lead.leadsource='NGCC' and 
            (lead.Call_Center_Vendor__c=:searchCallCenter or 
            lead.Lead_Qualifier_Call_Center__c= :searchCallCenter) and 
            (lead.createddate >= :date.valueOf(startDateFixed) and lead.status not in ('Cancel','3.2 Rejected-Already oppty','3.2 Rejected-Already oppty','3.11 Rejected-Duplicate','3.6 Rejected-Lost to Competition','2 Accepted-Mine/Channel','3.8 Rejected-No Cisco Response(Admin Onl')and 
            lead.createddate <= :date.valueOf(endDateFixed)) order by createdby.name asc];
            if(!requalificationLeads.isEmpty()){
                tempHistory = new List<RequalificationRecordsTempHolder>();
                for(LeadHistory lh : requalificationLeads ){
                    if(lh.NewValue == 'Requalification Required' || lh.OldValue == 'Requalification Required'){
                        tempHistory.add(new RequalificationRecordsTempHolder(lh));                        
                    }
                }
            }else{
            }
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Please Select Marketing Contact Center'));
        }
    }
    
    //@Inner class for holding lead history & lead records
    public class RequalificationRecordsTempHolder{
        public Transient  LeadHistory historyLeads {get;set;}
        public RequalificationRecordsTempHolder(LeadHistory historyLeads ){
            this.historyLeads = historyLeads; 
        }
    }
}