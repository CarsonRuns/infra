@isTest(SeeAllData = true)
public class NGCC_Flow_Create_Callback_Task_Test {
    @isTest
    public static void CreateTaskTest(){
        Lead l;
        Campaign camp;
        List<NGCC_Flow_Create_Callback_Task.TaskFields> TaskInfo = new List<NGCC_Flow_Create_Callback_Task.TaskFields>();
        camp = new Campaign(Name='Testing Campaign',
                            Program_Event_Name__c = 'Program_Event_Name__c',
                            Offer_Description__c = 'Offer_Description__c',
                            Offer_URL__c = 'Offer_URL__c',
                            Primary_Technology__c = 'Primary_Technology__c',
                            Campaign_Code__c = 'Campaign_Code__c',
                            Description = 'Campaign_Description__c',
                            Program_Event_Description__c = 'Program_Event_Description__c',
                            Offer_Name__c = 'Offer_Name__c',
                            Offer_Architecture__c = 'Offer_Architecture__c'
                            
                           );
        insert camp;
        
        ObjectRecordTypeIds__c orgConstant = ObjectRecordTypeIds__c.getInstance(); 
        Id marketingRecId = orgConstant.Marketing_Lead_RecordType__c;
        l= new Lead();
        l.RecordTypeId=marketingRecId;
        l.Status = 'New Prospect';
        l.LastName = 'TestLast';
        l.Company = 'Test Company';
        l.Campaign_Name__c = camp.Id;
        l.CustomCountry__c = 'EGYPT';
        l.Theater__c = 'EMEAR';
        insert l;
        
        NGCC_Flow_Create_Callback_Task.TaskFields taskdetails = new NGCC_Flow_Create_Callback_Task.TaskFields();
        taskdetails.WhoId = l.id;
        taskdetails.LeadFirstname='Test';
        taskdetails.LeadLastname ='TestLast';
        taskdetails.CallbackDateTime=system.now();
        taskdetails.Theater='EMEAR';
        
        TaskInfo.add(taskdetails);
        NGCC_Flow_Create_Callback_Task.CreateTask(TaskInfo);
    }
}