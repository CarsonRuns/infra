/*
Modification History: 
  1. History:
  Date:- Dec-8-2017
  Author:- Zakeer Ahmed
  Purpose:- CMC-Iron release sprint 19&20.
  Changes: 
  1. Line#: from suppressorTestingExisLeadNotHR() to suppressorTestingApprovalPending(): 106-454

*/

@isTest(SeeAllData = true)
public class NGCC_Lead_Deduper_Test {
   
    private static Lead leadDataPrep(){
        Lead newLead = new Lead();
        newLead.LastName = 'Lead';
        newLead.RecordTypeId = Schema.Sobjecttype.Lead.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        newLead.Company = '123';
        newLead.Status = 'Pre-Prospect';
        newLead.DedupeRecord__c = 'Dedupe';
        newLead.CustomCountry__c = 'UNITED STATES';
        return newLead;
    }

    @isTest
    public static void createDuplicateResponseTest(){
        Lead newLead = leadDataPrep();
        insert newLead; 
        Test.startTest(); 
        NGCC_Lead_Deduper.createDuplicateResponse(newLead);
        Test.stopTest();
        List<CC_Response__c> returned = [select ID from CC_response__c where Lead__c = :newLead.Id];
        System.assert(returned.size()>0);
    }

    
     /*@isTest
    public static void suppressionRuleSuppressRule(){
        Lead newlead = leadDataPrep();
        newLead.Status = 'New Prospect';
        newLead.Call_Status__c = 'Nurture';
        insert newLead;
        Test.startTest();
        Boolean result = NGCC_Lead_Deduper.suppressionRule(newLead);
        Test.stopTest();
        
        System.assert(result == true);
    }*/
    
    @isTest
    public static void suppressionRuleNonSuppressRule(){
        Lead newlead = leadDataPrep();
        newLead.Partner_Lead_Status__c = 'Closed-Order Through Disti';
        Test.startTest();
        Boolean result = NGCC_Lead_Deduper.suppressionRule(newLead);
        Test.stopTest();
        System.assert(result == false);
    }
    
    @isTest
    public static void newLeadProcessing(){
        Lead newlead = leadDataPrep();
        Test.startTest();
        insert newLead;
        NGCC_Lead_Deduper.newLeadProcessing(newLead);
        Test.stopTest();
        System.assert(newLead.Status == 'New Prospect');
    }
    
        
    @isTest
    public static void suppressorTestingOpenLead(){
        Lead newlead = leadDataPrep();
        Lead existingLead = leadDataPrep();
        existingLead.Status = 'New Prospect';
        existingLead.Call_Status__c = 'Open';
        insert newLead;      
        Test.startTest();
        NGCC_Lead_Deduper.suppressor(existingLead,newLead);
        Test.stopTest();
        System.Debug('Line82' +existingLead.Status+ 'existing & newLead status' +newLead.Status );
        System.assert(existingLead.Status == 'Inactive');
        System.assert(newLead.Status == 'New Prospect');
        
    }
    //Zak:adding Tests for LeadCategory ='Hand Raiser'
    @isTest
    public static void suppressorTestingExisLeadNotHR(){
        Lead newlead = leadDataPrep();
        Lead existingLead = leadDataPrep();
        existingLead.Status = 'New Prospect';
        existingLead.Call_Status__c = 'Open';
        existingLead.Lead_Category__c = 'BANT';
        existingLead.email = 'HR1@test.com';
        insert newLead;
        Test.startTest();
        NGCC_Lead_Deduper.suppressor(existingLead,newLead);
        Test.stopTest();
        System.assert(existingLead.Status == 'Inactive');
        System.assert(newLead.Status == 'New Prospect');
        
    }
    @isTest
    public static void suppressorTestingExisLeadHR_NewNotHR(){
        Lead newlead = leadDataPrep();
        Lead existingLead = leadDataPrep();
        existingLead.Status = 'New Prospect';
        existingLead.Call_Status__c = 'Open';
        existingLead.email = 'HR1@test.com';
        existingLead.Lead_Category__c = 'HAND RAISER';
        newLead.Lead_Category__c = 'BANT';
        newLead.email = 'HR1@test.com';
        insert newLead;
        Test.startTest();
        NGCC_Lead_Deduper.suppressor(existingLead,newLead);
        Test.stopTest();
        System.Debug('Line136' +existingLead.Status+ 'existing & newLead status' +newLead.Status );
        System.assert(newLead.Status == 'New Prospect');
        System.assert(existingLead.Status == 'Inactive');
        
    }
    @isTest
    public static void suppressorTestingExisLeadNotHR_NewHR(){
        Lead newlead = leadDataPrep();
        Lead existingLead = leadDataPrep();
        existingLead.Status = 'New Prospect';
        existingLead.Call_Status__c = 'Open';
        existingLead.email = 'HR1@test.com';
        existingLead.Lead_Category__c = 'BANT';
        newLead.Lead_Category__c = 'HAND RAISER';
        newLead.email = 'HR1@test.com';
        insert newLead;
        Test.startTest();
        NGCC_Lead_Deduper.suppressor(existingLead,newLead);
        Test.stopTest();
        System.Debug('Line155' +existingLead.Status+ 'existing & newLead status' +newLead.Status );
        System.assert(existingLead.Status == 'Inactive');
        System.assert(newLead.Status == 'New Prospect');
       
    }
    @isTest
    public static void suppressorTestingNewLeadHR(){
        Lead newlead = leadDataPrep();
        Lead existingLead = leadDataPrep();
        //newLead.Call_Status__c = 'Open';
        newLead.Lead_Category__c = 'HAND RAISER';
        newLead.email = 'HR2@test.com';
        existingLead.email = 'HR2@test.com';
        existingLead.Status='New Prospect';
                insert existingLead;
        Test.startTest();
                insert newLead;
        NGCC_Lead_Deduper.suppressor(existingLead,newLead);
        Test.stopTest();
        System.Debug('Line174' +existingLead.Status+ 'existing & newLead status' +newLead.Status );
        System.assert(existingLead.Status == 'New Prospect');
        System.assert(newLead.Status == 'New Prospect');
        
    }
    @isTest
    public static void suppressorTestingNewLeadNotHR(){
        Lead newlead = leadDataPrep();
        Lead existingLead = leadDataPrep();
        newLead.Call_Status__c = 'Open';
        newLead.email = 'HR4@test.com';
        existingLead.email = 'HR4@test.com';
        existingLead.Status='New Prospect';
        insert existingLead;
        Test.startTest();
        insert newLead;
        NGCC_Lead_Deduper.suppressor(existingLead,newLead);
        Test.stopTest();
        System.Debug('Line192' +existingLead.Status+ 'existing & newLead status' +newLead.Status );
        System.assert(existingLead.Status == 'New Prospect');
        System.assert(newLead.Status == 'New Prospect');
        
    }
    @isTest
    public static void suppressorTestingNewLeadNotHR_ExisHR(){
        Lead newlead = leadDataPrep();
        Lead existingLead = leadDataPrep();
        //newLead.Status = 'New Prospect';
        newLead.Call_Status__c = 'Open';
        newLead.Lead_Category__c = 'BANT';
        newLead.Source_Event_Number__c='EQ32376';
        existingLead.Lead_Category__c = 'HAND RAISER';
        newLead.email = 'HR2@test.com';
        existingLead.email = 'HR2@test.com';
        existingLead.Status='New Prospect';
        insert existingLead;
        Test.startTest();
        insert newLead;
        NGCC_Lead_Deduper.suppressor(existingLead,newLead);
        Test.stopTest();
        System.Debug('Line213' +existingLead.Status+ 'existing & newLead status' +newLead.Status );
        System.assert(existingLead.Status == 'New Prospect');
        System.assert(newLead.Status == 'New Prospect');
        
    }
    @isTest
    public static void suppressorTestingNewLeadHR_ExisNotHR(){
        Lead newlead = leadDataPrep();
        Lead existingLead = leadDataPrep();
        newLead.Status = 'New Prospect';
        newLead.Call_Status__c = 'Open';
        newLead.Lead_Category__c = 'HAND RAISER';
        existingLead.Lead_Category__c = 'BANT';
        existingLead.Status='New Prospect';
        insert existingLead;
        Test.startTest();
                insert newLead;
        NGCC_Lead_Deduper.suppressor(existingLead,newLead);
        Test.stopTest();
        System.Debug('Line232' +existingLead.Status+ 'existing & newLead status' +newLead.Status );
        System.assert(existingLead.Status == 'New Prospect');
        System.assert(newLead.Status == 'New Prospect');
        
    }
    //Zak: new TCs
    @isTest
    public static void suppressorTestingNewLeadHRx(){
        Lead newlead = leadDataPrep();
        Lead existingLead = leadDataPrep();
        //newLead.Call_Status__c = 'Open';
        newLead.Lead_Category__c = 'HAND RAISER';
        newLead.email = 'HR11@test.com';
        newLead.Source_Event_Number__c = 'EQ32376';
        existingLead.email = 'HR11@test.com';
        existingLead.Status='New Prospect';
        existingLead.Call_Status__c = 'Call Back Later';
        existingLead.Outcome__c='Call Back';
        existingLead.Source_Event_Number__c = 'EQ32376';
        existingLead.Call_Back_Date_Time__c=Datetime.now();
        insert existingLead;
        
        Test.startTest();
        insert newLead;
        NGCC_Lead_Deduper.suppressor(existingLead,newLead);
        Test.stopTest();
        System.Debug('Line255' +existingLead.Status+ 'existing & newLead status' +newLead.Status );
        System.assert(existingLead.Status == 'Inactive');
        System.assert(newLead.Status == 'New Prospect');
        
    }
    @isTest
    public static void suppressorTestingExisLeadHRx(){
        Lead newlead = leadDataPrep();
        Lead existingLead = leadDataPrep();
        newLead.Lead_Category__c = 'BANT';
        newLead.email = 'HR12@test.com';
        existingLead.Lead_Category__c = 'HAND RAISER';
        existingLead.email = 'HR12@test.com';
        existingLead.Status='New Prospect';
        existingLead.Call_Status__c = 'Call Back Later';
        existingLead.Outcome__c='Call Back';
        existingLead.Call_Back_Date_Time__c=Datetime.now()+29;
        insert existingLead;
        
        Test.startTest();
        insert newLead;
        NGCC_Lead_Deduper.suppressor(existingLead,newLead);
        Test.stopTest();
        System.Debug('Line278' +existingLead.Status+ 'existing & newLead status' +newLead.Status );
        System.assert(newLead.Status == 'Inactive');
        System.assert(existingLead.Status == 'New Prospect');
        
    }
    @isTest
    public static void suppressorTestingExisLeadNewLeadHRx(){
        Lead newlead = leadDataPrep();
        Lead existingLead = leadDataPrep();
        newLead.Lead_Category__c = 'HAND RAISER';
        newLead.email = 'HR13@test.com';
        newLead.Source_Event_Number__c = 'EQ32376';
        existingLead.Lead_Category__c = 'HAND RAISER';
        existingLead.email = 'HR13@test.com';
        existingLead.Status='New Prospect';
        existingLead.Call_Status__c = 'Call Back Later';
        existingLead.Outcome__c='Call Back';
        existingLead.Source_Event_Number__c = 'EQ32376';
        existingLead.Call_Back_Date_Time__c=Datetime.now()+15;
        insert existingLead;
        Test.startTest();
        insert newLead;
        NGCC_Lead_Deduper.suppressor(existingLead,newLead);
        Test.stopTest();
        System.Debug('Line300' +existingLead.Status+ 'existing & newLead status' +newLead.Status );
        System.assert(existingLead.Status == 'Inactive');
        System.assert(newLead.Status == 'New Prospect');
        
    }
    @isTest
    public static void suppressorTestingExisLeadNewLeadNotHRx(){
        Lead newlead = leadDataPrep();
        Lead existingLead = leadDataPrep();
        newLead.Lead_Category__c = 'BANT';
        newLead.email = 'HR13@test.com';
        existingLead.Lead_Category__c = 'BANT';
        existingLead.email = 'HR13@test.com';
        existingLead.Status='New Prospect';
        existingLead.Call_Status__c = 'Call Back Later';
        existingLead.Outcome__c='Call Back';
        existingLead.Call_Back_Date_Time__c=Datetime.now()+1;
        
        insert existingLead;
        Test.startTest();
        insert newLead;
        NGCC_Lead_Deduper.suppressor(existingLead,newLead);
        Test.stopTest();
        System.Debug('Line323' +existingLead.Status+ 'existing & newLead status' +newLead.Status );
        System.assert(existingLead.Status == 'New Prospect');
        System.assert(newLead.Status == 'Inactive');
        
    }
    @isTest
    public static void suppressorTestingPriorToYestBantLead(){
        Lead newlead = leadDataPrep();
        Lead existingLead = leadDataPrep();
        newLead.Lead_Category__c = 'BANT';
        newLead.email = 'bant01@test.com';
        newLead.Source_Event_Number__c = 'EQ32376';
        existingLead.Lead_Category__c = 'BANT';
        existingLead.email = 'bant01@test.com';
        existingLead.Status='New Prospect';
        existingLead.Call_Status__c = 'Call Back Later';
        existingLead.Outcome__c='Call Back';
        existingLead.Source_Event_Number__c = 'EQ32376';
        existingLead.Call_Back_Date_Time__c=Datetime.now()-1;
        
        insert existingLead;
        Test.startTest();
        insert newLead;
        NGCC_Lead_Deduper.suppressor(existingLead,newLead);
        Test.stopTest();
        System.Debug('Line323' +existingLead.Status+ 'existing & newLead status' +newLead.Status );
        System.assert(existingLead.Status == 'Inactive');
        System.assert(newLead.Status == 'New Prospect');
        
    }
    @isTest
    public static void suppressorTestingPriorToYestHRLead(){
        Lead newlead = leadDataPrep();
        Lead existingLead = leadDataPrep();
        newLead.Lead_Category__c = 'Hand Raiser';
        newLead.email = 'HR001@test.com';
        newLead.Source_Event_Number__c = 'EQ32376';
        existingLead.Lead_Category__c = 'Hand Raiser';
        existingLead.email = 'HR001@test.com';
        existingLead.Status='New Prospect';
        existingLead.Call_Status__c = 'Call Back Later';
        existingLead.Outcome__c='Call Back';
        existingLead.Source_Event_Number__c = 'EQ32376';
        existingLead.Call_Back_Date_Time__c=Datetime.now()-2;
        
        insert existingLead;
        Test.startTest();
        insert newLead;
        NGCC_Lead_Deduper.suppressor(existingLead,newLead);
        Test.stopTest();
        System.Debug('Line323' +existingLead.Status+ 'existing & newLead status' +newLead.Status );
        System.assert(existingLead.Status == 'Inactive');
        System.assert(newLead.Status == 'New Prospect');
        
    }
    @isTest
    public static void suppressorTestingMoreThan31DaysHRLead(){
        Lead newlead = leadDataPrep();
        Lead existingLead = leadDataPrep();
        newLead.Lead_Category__c = 'Hand Raiser';
        newLead.email = 'HR002@test.com';
        existingLead.Lead_Category__c = 'Hand Raiser';
        existingLead.email = 'HR002@test.com';
        existingLead.Status='New Prospect';
        existingLead.Call_Status__c = 'Call Back Later';
        existingLead.Outcome__c='Call Back';
        existingLead.Source_Event_Number__c = 'EQ32376';
        existingLead.Call_Back_Date_Time__c=Datetime.now()+31;
        
        insert existingLead;
        Test.startTest();
        insert newLead;
        NGCC_Lead_Deduper.suppressor(existingLead,newLead);
        Test.stopTest();
        System.Debug('Line323' +existingLead.Status+ 'existing & newLead status' +newLead.Status );
        System.assert(existingLead.Status == 'New Prospect');
        System.assert(newLead.Status == 'New Prospect');
        
    }
    @isTest
    public static void suppressorTestingMoreThan31DaysBantLead(){
        Lead newlead = leadDataPrep();
        Lead existingLead = leadDataPrep();
        newLead.Lead_Category__c = 'BANT';
        newLead.email = 'HR002@test.com';
        existingLead.Lead_Category__c = 'BANT';
        existingLead.email = 'HR002@test.com';
        existingLead.Status='New Prospect';
        existingLead.Call_Status__c = 'Call Back Later';
        existingLead.Outcome__c='Call Back';
        existingLead.Source_Event_Number__c = 'EQ32376';
        existingLead.Call_Back_Date_Time__c=Datetime.now()+31;
        
        insert existingLead;
        Test.startTest();
        insert newLead;
        NGCC_Lead_Deduper.suppressor(existingLead,newLead);
        Test.stopTest();
        System.Debug('Line323' +existingLead.Status+ 'existing & newLead status' +newLead.Status );
        System.assert(existingLead.Status == 'New Prospect');
        System.assert(newLead.Status == 'New Prospect');
        
    }
    @isTest
    public static void suppressorTestingMQL(){
        Lead newlead = leadDataPrep();
        Lead existingLead = leadDataPrep();
        newLead.email = 'HR14@test.com';
        newLead.Lead_Category__c = 'BANT';
        
        existingLead.Lead_Category__c = 'Hand Raiser';
        existingLead.email = 'HR14@test.com';
        existingLead.Status='Marketing Qualified';
        existingLead.Source_Event_Number__c = 'EQ32376';
        existingLead.MQL_Created_Date__c = DateTime.now();
        existingLead.DeduperProcessing__c = true;
        
        insert existingLead;
        Test.startTest();
        insert newLead;
        NGCC_Lead_Deduper.suppressor(existingLead,newLead);
        Test.stopTest();
        System.Debug('Line346' +existingLead.Status+ 'existing & newLead status' +newLead.Status );
        System.assert(existingLead.Status == 'Marketing Qualified');
        System.assert(newLead.Status == 'Inactive');
    }
    @isTest
    public static void suppressorTestingMQLHR(){
        Lead newlead = leadDataPrep();
        Lead existingLead = leadDataPrep();
        newLead.email = 'HR15@test.com';
        newLead.Lead_Category__c = 'HAND RAISER';
        
        existingLead.Lead_Category__c = 'HAND RAISER';
        existingLead.email = 'HR15@test.com';
        existingLead.Status='Marketing Qualified';
        existingLead.Source_Event_Number__c = 'EQ32376';
        existingLead.MQL_Created_Date__c = DateTime.now()+2;
        existingLead.DeduperProcessing__c = true;
        
        insert existingLead;
        Test.startTest();
        insert newLead;
        NGCC_Lead_Deduper.suppressor(existingLead,newLead);
        Test.stopTest();
        System.Debug('Line368' +existingLead.Status+ 'existing & newLead status' +newLead.Status );
        System.assert(existingLead.Status == 'Marketing Qualified');
        System.assert(newLead.Status == 'Inactive');
    }
    @isTest
    public static void suppressorTestingRejected(){
        Lead newlead = leadDataPrep();
        Lead existingLead = leadDataPrep();
        newLead.email = 'HR16@test.com';
        //newLead.Lead_Category__c = 'HAND RAISER';
        //existingLead.Lead_Category__c = 'HAND RAISER';
        existingLead.email = 'HR16@test.com';
        existingLead.Status='Rejected';
        existingLead.CreatedDate = Datetime.now().addDays(-4);
        existingLead.LastModifiedDate = Datetime.now();
        existingLead.DeduperProcessing__c = true;
        
        insert existingLead;
        Test.startTest();
        insert newLead;
        NGCC_Lead_Deduper.suppressor(existingLead,newLead);
        Test.stopTest();
        System.Debug('Line390' +existingLead.Status+ 'existing & newLead status' +newLead.Status );
        System.assert(existingLead.Status == 'Rejected');
        System.assert(newLead.Status == 'Inactive');
    }
    @isTest
    public static void suppressorTestingSendtoSales(){
        Lead newlead = leadDataPrep();
        Lead existingLead = leadDataPrep();
        newLead.email = 'HR16@test.com';
        newLead.Lead_Category__c = 'HAND RAISER';
        
        existingLead.Lead_Category__c = 'HAND RAISER';
        existingLead.email = 'HR16@test.com';
        existingLead.Status='Send to Sales';
                existingLead.CreatedDate = Datetime.now().addDays(-4);
        existingLead.Lead_Qualified_Date__c = Date.Today();
        existingLead.DeduperProcessing__c = true;
        
        insert existingLead;
        Test.startTest();
        insert newLead;
        NGCC_Lead_Deduper.suppressor(existingLead,newLead);
        Test.stopTest();
        System.Debug('Line413' +existingLead.Status+ 'existing & newLead status' +newLead.Status );
        System.assert(existingLead.Status == 'Send to Sales');
        System.assert(newLead.Status == 'Inactive');
    }
    @isTest
    public static void suppressorTestingRouting(){
        Lead newlead = leadDataPrep();
        Lead existingLead = leadDataPrep();
        newLead.email = 'HR16@test.com';
        newLead.Lead_Category__c = 'HAND RAISER';
        
        existingLead.Lead_Category__c = 'HAND RAISER';
        existingLead.email = 'HR16@test.com';
        existingLead.Status='Picked for Routing';
                        existingLead.CreatedDate = Datetime.now().addDays(-4);
        existingLead.MQL_Created_Date__c = Date.Today();
        existingLead.DeduperProcessing__c = true;
        
        insert existingLead;
        Test.startTest();
        insert newLead;
        NGCC_Lead_Deduper.suppressor(existingLead,newLead);
        Test.stopTest();
        System.Debug('Line436' +existingLead.Status+ 'existing & newLead status' +newLead.Status );
        System.assert(existingLead.Status == 'Picked for Routing');
        System.assert(newLead.Status == 'Inactive');
    }
    @isTest
    public static void suppressorTestingApprovalPending(){
        Lead newlead = leadDataPrep();
        Lead existingLead = leadDataPrep();
        newLead.email = 'HR16@test.com';
        newLead.Lead_Category__c = 'HAND RAISER';
        
        existingLead.Lead_Category__c = 'HAND RAISER';
        existingLead.email = 'HR16@test.com';
        existingLead.Status='Approval Pending';
        existingLead.MQL_Created_Date__c = Date.Today().addDays(3);
        existingLead.DeduperProcessing__c = true;
        
        insert existingLead;
        Test.startTest();
        insert newLead;
        NGCC_Lead_Deduper.suppressor(existingLead,newLead);
        Test.stopTest();
        System.Debug('Line458' +existingLead.Status+ 'existing & newLead status' +newLead.Status );
        System.assert(existingLead.Status == 'Approval Pending');
        System.assert(newLead.Status == 'Inactive');
    }
 /***Zak: LeadCategory test end***/   
    @isTest
    public static void suppressorTestingClosedLead(){
        Lead newlead = leadDataPrep();
        Lead existingLead = leadDataPrep();
        existingLead.Partner_Lead_Status__c = 'Closed-Order Through Disti';
        existingLead.Status = '2 Accepted-Mine/Channel';
        insert newLead;      
        Test.startTest();
        NGCC_Lead_Deduper.suppressor(existingLead,newLead);
        Test.stopTest();
        System.assert(newLead.Status == 'New Prospect');
        System.assert(existingLead.Status == '2 Accepted-Mine/Channel');
    }
    
    
     @isTest
    public static void suppressCopyNote(){
        List <Lead> Leads = new List<Lead>();
        Lead newlead = leadDataPrep();
        newLead.Status = 'New Prospect';
        newLead.Description = 'ASDF';
        newLead.Medium_Type__c = 'Inbound Call';
        Leads.add(newlead);
        Lead newlead1 = leadDataPrep();
        newLead1.Status = 'New Prospect';
        newLead1.Description = 'ASDF';
        Leads.add(newlead1);
        Test.startTest();
        Lead existinglead = leadDataPrep();
        existingLead.Status = 'Approval Pending';
               existingLead.DeduperProcessing__c = true;
        insert existingLead;
        insert Leads;
        NGCC_Lead_Deduper.suppressLead(newLead, 'Invalid', existingLead);
        for(Lead l : Leads){
         NGCC_Lead_Deduper.copyNotes(l, existingLead);
        }
        Test.stopTest();
        System.assert(existingLead.Status == 'Approval Pending');
    }
    
    @isTest
    public static void inactiveQueueMapping(){
        List<Lead> updatedLeads = new List<Lead>();
        Lead newlead = leadDataPrep();
        newLead.Status ='Inactive';
        newLead.CustomCountry__c = 'UNITED STATES';
        Test.startTest();
        insert newLead;
        updatedLeads.add(newLead);
        NGCC_Lead_Deduper.inactiveQueueMapping(updatedLeads);
        Test.stopTest();
        System.assert(newLead.Status == 'Inactive');
    }
    
     @isTest
    
    public static void SupressLeadDuper(){
        
        Campaign cm = new Campaign();
        cm.name = 'Tst Campaign ';
        insert cm;
        List<Lead> updatedLeads = new List<Lead>();
        Lead firstLead = leadDataPrep();
        firstLead.Status ='New Prospect';
        firstLead.Email ='Test@test123.com';
        firstLead.Campaign_Name__c = cm.id;
        firstLead.Call_Status__c ='Open';
        
        Lead secondLead = leadDataPrep();
        secondLead.Email ='Test@test123.com';
        secondLead.Campaign_Name__c = cm.id;
        
         Lead Lead3 = leadDataPrep();
        Lead3.Status ='New Prospect';
        Lead3.Email ='Test@test123.com';
        Lead3.Campaign_Name__c = cm.id;
        Lead3.Call_Status__c ='Open';
        Lead3.DedupeRecord__c = null;
        
        insert firstLead;
        insert Lead3;
        insert secondLead;
        
        updatedLeads.add(firstLead);
        String ids = secondLead.id;
        String query = 'Select Id, Status,Description, CreatedDate, CustomCountry__c, Theater__c,RecordTypeId,Campaign_Name__c,Source_Event_Number__c,MODS_Contact__c,ProgramEvent__c,Partner_Owned_Contact_Flag__c FROM Lead WHERE ID in ('+ ids +')';
        system.debug('>><<<>><<'+Lead3);
        Test.startTest();
        ID batchID = Database.executeBatch(new NGCC_Lead_Deduper(query));
        System.abortJob(batchID);
        NGCC_Lead_Deduper.leadDeduper(updatedLeads);
        Test.stopTest();
        System.assert(secondLead.Status == 'Pre-Prospect');
        System.assert(firstLead.Status == 'New Prospect');
        System.assert(ids != '');
        
    }
 
}