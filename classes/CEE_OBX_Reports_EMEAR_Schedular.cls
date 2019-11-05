/************************************************************************************************************************************
Name    : CEE_OBX_Reports_EMEAR_Schedular
Author  : Sudi Pitchaiah    
Purpose : Schedulable class for Executing EMEAR reports and send CSV file to DT. 
Created Date: 10/16/2015
Modification History: 

*************************************************************************************************************************************/
global class  CEE_OBX_Reports_EMEAR_Schedular implements Schedulable {
    global void execute(SchedulableContext SC) {
         string selectCluse = 'Select Id,CEE_Attendee__r.name,CEE_Attendee__r.Customer_Engagement_Events__r.Event_Type__c,';
                selectCluse += 'CEE_Attendee__r.Customer_Engagement_Events__r.EBC_CBC_Location__c,CEE_Attendee__r.Customer_Engagement_Events__r.Briefing_Notes__c,';
                selectCluse += 'CEE_Attendee__r.Customer_Engagement_Events__r.Name,CEE_Attendee__r.Customer_Engagement_Events__r.Primary_Account__r.Name,';
                selectCluse += 'CEE_Attendee__r.Customer_Engagement_Events__r.Account_Name_English__c,CEE_Attendee__r.Customer_Engagement_Events__r.Primary_Account__r.CRName__c,';
                selectCluse += 'CEE_Attendee__r.Customer_Engagement_Events__r.Start_Time_Site__c,CEE_Attendee__r.Customer_Engagement_Events__r.End_Time_Site__c,';
                selectCluse += 'CEE_Attendee__r.Customer_Engagement_Events__r.Primary_Site_Theater__c,CEE_Attendee__r.Customer_Engagement_Events__r.Primary_FSO__r.Name,';
                selectCluse += 'CEE_Attendee__r.Customer_Engagement_Events__r.Temp_CES_Locations__c,';
                selectCluse += 'CEE_Attendee__r.Customer_Engagement_Events__r.Meeting_Delivery_Type__c,CEE_Attendee__r.Agenda_Item__r.Delivery_Method__c,';
                selectCluse += 'CEE_Attendee__r.Customer_Engagement_Events__r.Program_Manager__r.Name,CEE_Attendee__r.Customer_Engagement_Events__r.Program_Manager__r.Alias,';
                selectCluse += 'CEE_Attendee__r.Customer_Engagement_Events__r.Engagement_Contact__r.Name,CEE_Attendee__r.Customer_Engagement_Events__r.Engagement_Contact__r.Alias,';
                selectCluse += 'CEE_Attendee__r.Customer_Engagement_Events__r.Number_of_Cisco_Attendees__c,CEE_Attendee__r.Customer_Engagement_Events__r.Number_of_Partner_Attendees__c,';
                selectCluse += 'CEE_Attendee__r.Customer_Engagement_Events__r.Number_of_Customer_Attendees__c,CEE_Attendee__r.Customer_Engagement_Events__r.Number_of_Customer_Executives__c,';
                selectCluse += 'CEE_Attendee__r.Customer_Engagement_Events__r.Total_Num_of_Attendees__c,CEE_Attendee__r.Customer_Engagement_Events__r.Vertical__c,';
                selectCluse += 'CEE_Attendee__r.Customer_Engagement_Events__r.Segment__c,CEE_Attendee__r.Customer_Engagement_Events__r.Opportunity__r.StageName,';
                selectCluse += 'CEE_Attendee__r.Customer_Engagement_Events__r.Request_Status__c,CEE_Attendee__r.Agenda_Item__r.Topic__r.Architecture__c,';
                selectCluse += 'CEE_Attendee__r.Agenda_Item__r.Topic__r.Name,CEE_Attendee__r.Agenda_Item__r.Topic__r.Sub_Architecture__c,';
                selectCluse += 'CEE_Attendee__r.Agenda_Item__r.Name,CEE_Attendee__r.Type__c,CEE_Attendee__r.Email__c,CEE_Attendee__r.Salesforce_User__r.Title,';
                selectCluse += 'CEE_Attendee__r.Salesforce_User__r.Department,CEE_Attendee__r.Agenda_Item__r.Start_Date_Time__c,CEE_Attendee__r.Agenda_Item__r.Start_Time_Site__c,';
                selectCluse += 'CEE_Attendee__r.Customer_Engagement_Events__r.Survey_End_Date__c,CEE_Attendee__r.Agenda_Item__r.End_Date_Time__c,CEE_Attendee__r.Agenda_Item__r.End_Time_Site__c,';
                selectCluse += 'CEE_Attendee__r.Agenda_Item__r.Selected_Rooms_Display__c,CEE_Attendee__r.Customer_Engagement_Events__r.Room_Name__c,CEE_Attendee__r.Customer_Engagement_Events__r.LastModifiedDate ';
                selectCluse += 'from CEE_Invite__c '; 
        date dtNow = date.today() + 1;
        string stDate = dtNow.format();
        string whereCluse = label.CEE_OBX_Reports_Where_EMEAR + ' and CEE_Attendee__r.Agenda_Item__r.Start_Time_Site__c like \'%'+stDate+'%\' order by CEE_Attendee__r.Customer_Engagement_Events__r.Name desc';
        string finalQuery = selectCluse + whereCluse;
        CEE_OBX_Reports_Batchable obxBatch = new CEE_OBX_Reports_Batchable(finalQuery,stDate,'EMEAR');
        Database.executeBatch(obxBatch); 
    }
}