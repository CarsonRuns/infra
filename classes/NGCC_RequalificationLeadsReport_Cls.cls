/*
*
*
************************************************************************************************************************************
@Name    : NGCC_RequalificationLeadsReport_Cls
@Author  : Fazurulla Ganganapalli
@Purpose : This class is responsible for requalification reports.
@Created Date: 07/28/2017
@Modification History: 

************************************************************************************************************************************
*
*
*/

public class NGCC_RequalificationLeadsReport_Cls{
     //@Navigation variables declaration
    public Transient  String searchCallCenter { get; set; }
    public Transient  String searchLeadsource { get; set; }
    public Transient  String searchCountryNames { get; set; }
    public Transient  String searchCountryName { get; set; }
    public Lead leads {get;set;}
    public Integer counter = 0;
    public Integer limitSize = 50;
    public Integer totalSize =0;
    public List<LeadHistory> leadsToShow{get;set;}
    public Transient  boolean showDateFields {get;set;}
    public Transient  String soql {get;set;}
    public Transient  date startDateNameDemo {get;set;}    
    public Transient  date endDateNameDemo {get;set;}
    public Transient  string startDateName {get;set;}
    public Transient  string endDateName {get;set;}    
    public Transient  String condition {get;set;}
    public Transient  List<LeadHistory> requalificationLeads{get;set;}   
    public Transient  boolean errorMessageShow {get;set;}
    public Transient  boolean showSpaces{get;set;}
    public Set<Id>   setIDS;
    public Set<Id> dupSet = new Set<Id>();
    Public Transient  static List<string> customLabelCountries {get;set;}
    Public Transient  static List<string> customLabelUserList {get;set;}
    public Transient  boolean disableRun{get;set;}
    public Transient  boolean disableRunMain{get;set;}
    public List<leadhistory> leadHistoryList {get;set;}
    
    //@Constructor to hide or show onloading a page
    public NGCC_RequalificationLeadsReport_Cls(){
        leads = new Lead();
        showDateFields = false;
        errorMessageShow = false;
        showSpaces = true;
        disableRunMain = true;
        disableRun = true;
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
        showSpaces = false; 
        String startDate = DateTime.newInstance(leads.SDR_Assignment_Date__c.year(),leads.SDR_Assignment_Date__c.month(),leads.SDR_Assignment_Date__c.day()).format('YYYY-MM-dd');
        startDate += 'T00:00:00Z';
        String endDate = DateTime.newInstance(leads.Submitted_to_Sales_Date__c.year(),leads.Submitted_to_Sales_Date__c.month(),leads.Submitted_to_Sales_Date__c.day()).format('YYYY-MM-dd');
        endDate += 'T00:00:00Z';
        if(searchCallCenter !=NULL && searchCallCenter != '' && searchCallCenter != '--None--'){
            requalificationLeads = [SELECT  Id,LeadId,lead.lastname,lead.firstname,LEAD.STATUS,lead.SDR_Lead_Owner_Name__c,lead.CustomCountry__c, NewValue, OldValue,createdby.name, CreatedDate,Lead.leadsource,
            lead.recordtypeid,lead.Call_Center_Vendor__c,lead.Lead_Qualifier_Call_Center__c FROM LeadHistory 
            where (field='Call_Status__c') and
            lead.CustomCountry__c in :customLabelCountries and
            Lead.leadsource='NGCC' and 
            (lead.Call_Center_Vendor__c=:searchCallCenter or 
            lead.Lead_Qualifier_Call_Center__c= :searchCallCenter) and 
            (lead.createddate >= :date.valueOf(startDate) and lead.status not in ('Cancel','3.2 Rejected-Already oppty','3.2 Rejected-Already oppty','3.11 Rejected-Duplicate','3.6 Rejected-Lost to Competition','2 Accepted-Mine/Channel','3.8 Rejected-No Cisco Response(Admin Onl')and 
            lead.createddate <= :date.valueOf(endDate)) order by lead.firstname,lead.lastname,createdby.name desc];
            setIDS = new Set<Id>();
            if(!requalificationLeads.isEmpty()){
                errorMessageShow = false;
                for(LeadHistory lh : requalificationLeads ){
                    if(lh.NewValue == 'Requalification Required' || lh.OldValue == 'Requalification Required'){
                        setIDS.add(lh.id);                       
                    }
                }
                getPieData();
                cmdRequalification_Report();
                getResults();
            }else{
                errorMessageShow = true;
            }
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Please Select Marketing Contact Center'));
        }
    }
    
    public void cmdRequalification_Report(){ 
        leadsToShow = new List<LeadHistory>();
        if(!setIDS.isEmpty()){
             leadHistoryList = [SELECT  LeadId,lead.lastname,lead.firstname,LEAD.STATUS,lead.SDR_Lead_Owner_Name__c,lead.CustomCountry__c, NewValue, OldValue,createdby.name, CreatedDate,Lead.leadsource,
            lead.Call_Center_Vendor__c  from leadhistory where ID IN :setIDS order by lead.firstname ASC];
            //Store the total size
            totalSize = leadHistoryList.size();
            //Intial adding of contacts to leadsToShow
            //check the total records are more than limitSize and assign the records
            if((counter+limitSize) <= totalSize){
                for(Integer i=0;i<limitSize;i++){
                    leadsToShow.add(leadHistoryList.get(i));
                }
            }else{
                for(Integer i=0;i<totalSize;i++){
                    leadsToShow.add(leadHistoryList.get(i));
                }
            }
        }        
    }
    public void beginning(){   
        leadsToShow.clear();
        counter=0;
        if((counter + limitSize) <= totalSize){
            for(Integer i=0;i<limitSize;i++){
                leadsToShow.add(leadHistoryList.get(i));
            } 
        }else{
            for(Integer i=0;i<totalSize;i++){
                leadsToShow.add(leadHistoryList.get(i));
            } 
        }
    }
    public void next(){
        leadsToShow.clear();
        counter=counter+limitSize;
        if((counter+limitSize) <= totalSize){
            for(Integer i=counter-1;i<(counter+limitSize);i++){
                leadsToShow.add(leadHistoryList.get(i));
            }
        }else{
            for(Integer i=counter;i<totalSize;i++){
                leadsToShow.add(leadHistoryList.get(i));
            }
        }
    }
    public void previous(){
        leadsToShow.clear();
        counter=counter-limitSize; 
        for(Integer i=counter;i<(counter+limitSize); i++){
            leadsToShow.add(leadHistoryList.get(i));
        }
    }
    public void last (){
        leadsToShow.clear();
        if(math.mod(totalSize , limitSize) == 0){
            counter = limitSize * ((totalSize/limitSize)-1);
        }else if (math.mod(totalSize , limitSize) != 0){
            counter = limitSize * ((totalSize/limitSize));
        }
        for(Integer i=counter-1;i<totalSize-1;i++){
                leadsToShow.add(leadHistoryList.get(i));
        }
    }
    public Boolean getDisableNext(){
        if((counter + limitSize) >= totalSize )
            return true ;
        else
            return false ;
    }
    public Boolean getDisablePrevious(){
        if(counter == 0)
            return true ;
        else
            return false ;
    } 
    //@Method : This is responsible for dowloading the current report.
    public pagereference cmdDownloadReport(){ 
        String startDate = DateTime.newInstance(leads.SDR_Assignment_Date__c.year(),leads.SDR_Assignment_Date__c.month(),leads.SDR_Assignment_Date__c.day()).format('YYYY-MM-dd');
        startDate += 'T00:00:00Z';
        String endDate = DateTime.newInstance(leads.Submitted_to_Sales_Date__c.year(),leads.Submitted_to_Sales_Date__c.month(),leads.Submitted_to_Sales_Date__c.day()).format('YYYY-MM-dd');
        endDate += 'T00:00:00Z';
        Pagereference ref = new Pagereference('/apex/NGCC_Popup_Excel_Pge');
        ref.getParameters().put('searchCallCenter',searchCallCenter);
        ref.getParameters().put('startDateFixed',startDate);
        ref.getParameters().put('endDateFixed',endDate);
        return ref;    
    }
      //@Method : Hide or show buttons based on user input
    public void cmdHideorShow(){
        if(searchCallCenter == '--None--'){
            disableRunMain = true;
            disableRun = true;
        }else{
            disableRunMain = false;
            disableRun = false;
        }
    }
    //@Method: Display list of records in dashboard based on user name.
    public List<PieWedgeData> getPieData(){
        List<PieWedgeData> data = new List<PieWedgeData>();
        for(AggregateResult ar : [SELECT createdby.name name,Count(id) total from leadhistory where ID IN :setIDS and createdby.name in :customLabelUserList GROUP BY createdby.name]){
            data.add(new PieWedgeData((String)ar.get('name'),(Integer)ar.get('total')));
        }
        return data;
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
    public AggregateResult[] getResults(){
        return [SELECT createdby.name name,Count(id) total from leadhistory where ID IN :setIDS and createdby.name in :customLabelUserList GROUP BY createdby.name];
     
    }
}