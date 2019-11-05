/*********************************************************************************************************************************
Name    : CEE_OBX_Reports_Batchable
Author  : Sudi Pitchaiah
Purpose : The purpose of the batch class to capture CEE-OBX Reporting Metrics  
            1) This process will run OBX records Agenda item Start date time and send email report to DT team.
      
Created Date:  10/14/2015 
Modification History: 
                      
**********************************************************************************************************************************/

global Class CEE_OBX_Reports_Batchable implements Database.Batchable<sObject> {
    
    private final string query;
    private final string Theater;
    private final string DateRun;
    
    
    global CEE_OBX_Reports_Batchable(String query, string DateReportRun, string location)
    {
        try
        {            
            this.query = query;    
            this.DateRun = DateReportRun;
            this.Theater = location;
        }
        Catch(Exception e)
        {
           system.debug(e);
        }
    }        
    global Database.QueryLocator start(Database.BatchableContext BC)
    {                      
       return Database.getQueryLocator(query);               
    }    
    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {   
        try
        {           
            string header = 'Briefing Notes, Request ID, Account: Account Name, Account Name(English),Account: CR Name, CEE Request Start Time (Site),CEE Request End Time (Site),';
            header += 'Primary Site Theater, Primary Site: Location Name, Temp CES Locations,Event Type,Meeting Delivery Type, Delivery Method, Program Manager: Full Name,';
            header += 'Program Manager: Alias,Engagement Contact: Full Name, Engagement Contact: Alias, Number of Cisco Attendees, Number of Partner Attendees,Number of Customer Attendees,';
            header += 'Number of Customer Executives,Total Number of Attendees,Vertical,Segment,Opportunity: Stage,Request Status,Topic: Architecture,Topic: Topic Name,Topic: Sub-Architecture,';
            header += 'Agenda Item Name,Type,Attendee Name, Email, Salesforce User: Title, Salesforce User: Department, Agenda Item Start Date/Time,Start Time (Site),';           
            header += 'Agenda Item End Date/Time, End Time (Site),Survey End Date, Selected Rooms Display, Room Name, Last Modified Date \n';                                      
            blob myBIGblob = blob.valueOf(header);
            for(CEE_Invite__c CV : (List<CEE_Invite__c>)scope){             
                string strValue = removeNulls(CV.CEE_Attendee__r.Customer_Engagement_Events__r.Briefing_Notes__c) +','+ removeNulls(CV.CEE_Attendee__r.Customer_Engagement_Events__r.Name) + ',' ;
                strValue += removeNulls(CV.CEE_Attendee__r.Customer_Engagement_Events__r.Primary_Account__r.Name) + ','+ removeNulls(CV.CEE_Attendee__r.Customer_Engagement_Events__r.Account_Name_English__c) +',';
                strValue += removeNulls(CV.CEE_Attendee__r.Customer_Engagement_Events__r.Primary_Account__r.CRName__c) + ',' + removeNulls(CV.CEE_Attendee__r.Customer_Engagement_Events__r.Start_Time_Site__c) +',';
                strValue += removeNulls(CV.CEE_Attendee__r.Customer_Engagement_Events__r.End_Time_Site__c) + ',' + removeNulls(CV.CEE_Attendee__r.Customer_Engagement_Events__r.Primary_Site_Theater__c) + ',';
                strValue += removeNulls(CV.CEE_Attendee__r.Customer_Engagement_Events__r.Primary_FSO__r.Name) +','+ removeNulls(CV.CEE_Attendee__r.Customer_Engagement_Events__r.Temp_CES_Locations__c) + ',';
                strValue += removeNulls(CV.CEE_Attendee__r.Customer_Engagement_Events__r.Event_Type__c) + ',' + removeNulls(CV.CEE_Attendee__r.Customer_Engagement_Events__r.Meeting_Delivery_Type__c) + ',';
                strValue += removeNulls(CV.CEE_Attendee__r.Agenda_Item__r.Delivery_Method__c) + ',' + removeNulls(CV.CEE_Attendee__r.Customer_Engagement_Events__r.Program_Manager__r.Name) + ',';
                strValue += removeNulls(CV.CEE_Attendee__r.Customer_Engagement_Events__r.Program_Manager__r.Alias) +','+ removeNulls(CV.CEE_Attendee__r.Customer_Engagement_Events__r.Engagement_Contact__r.Name) + ',';
                strValue += removeNulls(CV.CEE_Attendee__r.Customer_Engagement_Events__r.Engagement_Contact__r.Alias) + ','+ removeNulls(CV.CEE_Attendee__r.Customer_Engagement_Events__r.Number_of_Cisco_Attendees__c) + ',';
                strValue += removeNulls(CV.CEE_Attendee__r.Customer_Engagement_Events__r.Number_of_Partner_Attendees__c) + ','+ removeNulls(CV.CEE_Attendee__r.Customer_Engagement_Events__r.Number_of_Customer_Attendees__c) + ',';
                strValue += removeNulls(CV.CEE_Attendee__r.Customer_Engagement_Events__r.Number_of_Customer_Executives__c) + ',' + removeNulls(CV.CEE_Attendee__r.Customer_Engagement_Events__r.Total_Num_of_Attendees__c) + ',';
                strValue += removeNulls(CV.CEE_Attendee__r.Customer_Engagement_Events__r.Vertical__c) + ',' + removeNulls(CV.CEE_Attendee__r.Customer_Engagement_Events__r.Segment__c) + ',';
                strValue += removeNulls(CV.CEE_Attendee__r.Customer_Engagement_Events__r.Opportunity__r.StageName) + ',' + removeNulls(CV.CEE_Attendee__r.Customer_Engagement_Events__r.Request_Status__c) + ',';
                strValue += removeNulls(CV.CEE_Attendee__r.Agenda_Item__r.Topic__r.Architecture__c) + ',' + removeNulls(CV.CEE_Attendee__r.Agenda_Item__r.Topic__r.Name) + ',';
                strValue += removeNulls(CV.CEE_Attendee__r.Agenda_Item__r.Topic__r.Sub_Architecture__c) + ','+ removeNulls(CV.CEE_Attendee__r.Agenda_Item__r.Name) + ',';
                strValue += removeNulls(CV.CEE_Attendee__r.Type__c) + ',' + removeNulls(CV.CEE_Attendee__r.Name) + ',' + removeNulls(CV.CEE_Attendee__r.Email__c) + ',' + removeNulls(CV.CEE_Attendee__r.Salesforce_User__r.Title)+',';
                strValue += removeNulls(CV.CEE_Attendee__r.Salesforce_User__r.Department) +','+ CV.CEE_Attendee__r.Agenda_Item__r.Start_Date_Time__c + ',';
                strValue += removeNulls(CV.CEE_Attendee__r.Agenda_Item__r.Start_Time_Site__c) + ',' + CV.CEE_Attendee__r.Agenda_Item__r.End_Date_Time__c + ',';
                strValue += removeNulls(CV.CEE_Attendee__r.Agenda_Item__r.End_Time_Site__c) + ',' +  + CV.CEE_Attendee__r.Customer_Engagement_Events__r.Survey_End_Date__c + ',' + removeNulls(CV.CEE_Attendee__r.Agenda_Item__r.Selected_Rooms_Display__c) + ',';
                strValue += removeNulls(CV.CEE_Attendee__r.Customer_Engagement_Events__r.Room_Name__c) + ','+ CV.CEE_Attendee__r.Customer_Engagement_Events__r.LastModifiedDate + '\n' ;     
                myBIGblob =  blob.valueOf(myBIGblob.toString() + strValue);                                                                            
            }                                
           	sendEmail(myBIGblob);
        }
        Catch(Exception e)
        {
           system.debug('Exception block ::' + e);
        } 
            
        
    }  
    private string removeNulls(string sValue){
        return (sValue != null) ? sValue.replaceAll(',',';') : '';
    }       
    private string removeNulls(integer sValue){
        return (sValue != null) ? String.valueOf(sValue) : '';
    }   
    private string removeNulls(decimal sValue){
        return  (sValue != null) ? String.valueOf(sValue) : '';
    }
    private void sendEmail(blob bData){
    	EmailTemplate emailTemp = [Select Subject, Name, Id, Description, Body From EmailTemplate e where name='CEE_OBX_Reports_Temp' limit 1];
    	Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
        blob csvBlob = bData;
        string csvname= 'CEE - OBX Report.csv';
        csvAttc.setFileName(csvname);
        csvAttc.setBody(csvBlob);
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        string toemailAddess = Utilities.getConstant_CS('CEE OBX Reports Email');            
        String[] toAddresses = (toemailAddess != null) ? toemailAddess.split(','): new list<string> {};
        String subject = emailTemp.Subject; 
        subject = (subject!=null) ? subject.replace('_THEATRE_',Theater).replace('_DATE_',DateRun) : '';
        email.setSubject(subject);
        email.setToAddresses( toAddresses );
        String body = emailTemp.Body; 
        body = (body != null) ? body.replace('_THEATRE_',Theater).replace('_DATE_',DateRun) : '';            
        email.setPlainTextBody(body );
        email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
    }  
    global void finish(Database.BatchableContext BC)
    {    	
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id = :BC.getJobId()];
        if(a.TotalJobItems == 0){
        	string header = 'Briefing Notes, Request ID, Account: Account Name, Account Name(English),Account: CR Name, CEE Request Start Time (Site),CEE Request End Time (Site),';
            header += 'Primary Site Theater, Primary Site: Location Name, Temp CES Locations,Event Type,Meeting Delivery Type, Delivery Method, Program Manager: Full Name,';
            header += 'Program Manager: Alias,Engagement Contact: Full Name, Engagement Contact: Alias, Number of Cisco Attendees, Number of Partner Attendees,Number of Customer Attendees,';
            header += 'Number of Customer Executives,Total Number of Attendees,Vertical,Segment,Opportunity: Stage,Request Status,Topic: Architecture,Topic: Topic Name,Topic: Sub-Architecture,';
            header += 'Agenda Item Name,Type,Attendee Name, Email, Salesforce User: Title, Salesforce User: Department, Agenda Item Start Date/Time,Start Time (Site),';           
            header += 'Agenda Item End Date/Time, End Time (Site),Survey End Date, Selected Rooms Display, Room Name, Last Modified Date \n';            
                            
            blob myBIGblob = blob.valueOf(header);
        	sendEmail(myBIGblob);
        }        
    }  
    
    
}