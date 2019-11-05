public class NGCC_RequalificationLeadsReport_Cls1{
     //@Navigation variables declaration
    public String searchCallCenter { get; set; }
    public Lead leads {get;set;} 
    public Set<Id> setIDS;
    Public static List<string> customLabelCountries {get;set;}
    Public static List<string> customLabelUserList {get;set;}
    public List<leadhistory> leadHistoryList {get;set;}
    
    //@Constructor to hide or show onloading a page
    public NGCC_RequalificationLeadsReport_Cls1(){
        leads = new Lead();
    }
    //@Static Block: Gettting list of user names and Countries from custom labels 
    static{
        customLabelCountries = label.NGCC_Requalification_Countries.split(';');
        customLabelUserList  = label.NGCC_Requalification_UserList.split(';');
    }
    //@Method : Getting Marketing Contact Center filed values dynamically from user object.
    public List<SelectOption> getOptions(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = User.Marketing_Call_Center__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple){       
          options.add(new SelectOption(f.getLabel(), f.getValue()));
        } 
        return  options ;   
    }
     //@Method: This is responsible for fetching list of records and display it in Visualforce PageBlock table.
    public void cmdQueryResult(){
        try{ 
        String startDate = DateTime.newInstance(leads.SDR_Assignment_Date__c.year(),leads.SDR_Assignment_Date__c.month(),leads.SDR_Assignment_Date__c.day()).format('YYYY-MM-dd');
        startDate += 'T00:00:00Z';
        String endDate = DateTime.newInstance(leads.Submitted_to_Sales_Date__c.year(),leads.Submitted_to_Sales_Date__c.month(),leads.Submitted_to_Sales_Date__c.day()).format('YYYY-MM-dd');
        endDate += 'T00:00:00Z';        
        if(startDate<endDate){
            List<LeadHistory> requalificationLeads = [SELECT  Id,LeadId,NewValue, OldValue FROM LeadHistory where (field='Call_Status__c') and
            lead.CustomCountry__c in :customLabelCountries and Lead.leadsource='NGCC' and  (lead.Call_Center_Vendor__c=:searchCallCenter or  lead.Lead_Qualifier_Call_Center__c= :searchCallCenter) and 
            (lead.createddate >= :date.valueOf(startDate) and lead.status not in ('Cancel','3.2 Rejected-Already oppty','3.2 Rejected-Already oppty','3.11 Rejected-Duplicate','3.6 Rejected-Lost to Competition','2 Accepted-Mine/Channel','3.8 Rejected-No Cisco Response(Admin Onl')and 
            lead.createddate <= :date.valueOf(endDate)) order by leadid ASC NULLS LAST limit 49999];
            setIDS = new Set<Id>();
            if(!requalificationLeads.isEmpty()){
                for(LeadHistory lh : requalificationLeads ){
                    if(lh.NewValue == 'Requalification Required' || lh.OldValue == 'Requalification Required'){
                        setIDS.add(lh.id);                       
                    }
                }
                getPieData();
                cmdRequalification_Report();
            }else{
                leadHistoryList.clear();
            }
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm,'End Date always greater than start date'));
                leadHistoryList.clear();
            }
            }catch(exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm,e.getMessage()));
            }
    }    
    public void cmdRequalification_Report(){ 
        try{
        if(!setIDS.isEmpty()){
             leadHistoryList = [SELECT  LeadId,lead.name,LEAD.STATUS,lead.SDR_Lead_Owner_Name__c,lead.CustomCountry__c, NewValue, OldValue,createdby.name, CreatedDate,Lead.leadsource,
            lead.Call_Center_Vendor__c  from leadhistory where ID IN :setIDS order by lead.firstname asc NULLS Last limit 49999];           
        }
        }catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm,e.getMessage()));
        }        
    }
    //@Method : This is responsible for dowloading the current report.
  
    //@Method: Display list of records in dashboard based on user name.
    public List<PieWedgeData> getPieData(){
        try{
        List<PieWedgeData> data = new List<PieWedgeData>();
        for(AggregateResult ar : [SELECT createdby.name name,Count(id) total from leadhistory where ID IN :setIDS and createdby.name in :customLabelUserList GROUP BY createdby.name]){
            data.add(new PieWedgeData((String)ar.get('name'),(Integer)ar.get('total')));
        }
        return data;
        }catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm,e.getMessage()));
        }
        return null;
    }
      //@Inner class for display holding User Name and Record Count in Dashboard.   
    public class PieWedgeData {
        public String name { get; set; }
        public Integer data{ get; set; }
        public PieWedgeData(String name, Integer data) {
            this.name = name;
            this.data= data;
        }
    }
}