@istest(SeeAllData=true)
public class NGCC_LeadList_Test
{  
    
    public static testmethod void testm()
    {        
		// Getting record type id for the record type name Prospect.
		RecordType r = new RecordType();
		r=[select Id,Name from RecordType where Name='Prospect' limit 1];  
		SourceFireInsertFieldsandNotifications.isSFire = true;
        // Create the leads
        list<Lead> Leads = new list<Lead>();
        Lead l = new Lead();
        l.RecordtypeId=r.Id;// recordtype
        l.Status = 'Marketing Qualified';
        l.LastName='Test1';
        l.company='csc';
        l.CustomCountry__c = 'United States';
        l.Theater__c = 'Americas';// lead theater
        l.Originating_Marketing_Pipeline__c = 4000;
        Leads.add(l);
        Lead bLead = new Lead();
        bLead.RecordtypeId=r.Id;
        bLead.LastName='Test1';
        bLead.company='csc';
        Leads.add(bLead);		
        insert Leads;
        
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setObjectId(Leads[0].id);
        Approval.ProcessResult result = Approval.process(req1);
        System.assert(result.isSuccess());
		system.debug('testttt'+result);
        
		ApexPages.StandardSetController StandardsObjectController = new ApexPages.StandardSetController([select Id,LastName from lead LIMIT 1]);
        StandardsObjectController.setSelected(Leads);
        NGCC_LeadList t = new NGCC_LeadList(StandardsObjectController);
        t.save1();  
        
    }
    
    public static testmethod void testm1()
    {
        
		// Getting record type id for the record type name Prospect.
		RecordType r = new RecordType();
		r=[select Id,Name from RecordType where Name='Prospect' limit 1];    
		SourceFireInsertFieldsandNotifications.isSFire = true;
        // Create the leads
        list<Lead> Leads = new list<Lead>();
        Lead l = new Lead();
        l.RecordtypeId=r.Id;// recordtype
        l.Status = 'Rejected';
        l.Rejected_Reason_Details__c  ='Reject reason';
        l.Lead_Cancel_Reason__c  = 'Project Cancelled';
        l.LastName='Test1';
        l.company='csc';
        l.CustomCountry__c = 'United States';
        l.Theater__c = 'Americas';// lead theater
        l.Originating_Marketing_Pipeline__c = 4000;
        Leads.add(l);
        Lead bLead = new Lead();
        bLead.RecordtypeId=r.Id;
        bLead.LastName='Test1';
        bLead.company='csc';
        Leads.add(bLead);
        insert Leads;
        
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setObjectId(Leads[0].id);
        
        Approval.ProcessResult result = Approval.process(req1);
        System.assert(result.isSuccess());
		//Id workItemId = getWorkItemId(Leads.id);
        
        ApexPages.StandardSetController StandardsObjectController = new ApexPages.StandardSetController([select Id,LastName from lead LIMIT 1]);
        StandardsObjectController.setSelected(Leads);
        
        NGCC_LeadList t = new NGCC_LeadList(StandardsObjectController);
        t.listwrap[0].status = 'Rejected';
        t.save1();
        t.getWorkItemId(Leads[0].Id);
    }

    public static testmethod void testm2()
    {
        
		// Getting record type id for the record type name Prospect.
		RecordType r = new RecordType();
		r=[select Id,Name from RecordType where Name='Prospect' limit 1];  
		SourceFireInsertFieldsandNotifications.isSFire = true;
        // Create the leads
        list<Lead> Leads = new list<Lead>();
        Lead l = new Lead();
        l.RecordtypeId=r.Id;// recordtype
        l.Status = 'Rejected';
        l.Rejected_Reason_Details__c  ='Reject reason';
        l.Lead_Cancel_Reason__c  = 'Project Cancelled';
        l.LastName='Test1';
        l.company='csc';
        l.CustomCountry__c = 'United States';
        l.Theater__c = 'Americas';// lead theater
        l.Originating_Marketing_Pipeline__c = 4000;
        Leads.add(l);
        Lead bLead = new Lead();
        bLead.RecordtypeId=r.Id;
        bLead.LastName='Test1';
        bLead.company='csc';
        Leads.add(bLead);
        insert Leads;
        
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setObjectId(Leads[0].id);
        
        Approval.ProcessResult result = Approval.process(req1);
        System.assert(result.isSuccess());

        
        ApexPages.StandardSetController StandardsObjectController = new ApexPages.StandardSetController([select Id,LastName from lead LIMIT 1]);
        StandardsObjectController.setSelected(Leads);
        
        NGCC_LeadList t = new NGCC_LeadList(StandardsObjectController);
        
        t.listwrap[0].status ='Cancel';
        t.save1();
        t.getWorkItemId(Leads[0].Id);
    }
	
    public static testmethod void testm3()
    {        
		// Getting record type id for the record type name Prospect.
		RecordType r = new RecordType();
		r=[select Id,Name from RecordType where Name='Prospect' limit 1]; 
		SourceFireInsertFieldsandNotifications.isSFire = true;
        // Create the leads
        list<Lead> Leads = new list<Lead>();
        Lead l = new Lead();
        l.RecordtypeId=r.Id;// recordtype
        l.Status = 'Marketing Qualified';
        l.Rejected_Reason_Details__c  ='Reject reason';
        l.Lead_Cancel_Reason__c  = 'Project Cancelled';
        l.LastName='Test1';
        l.company='csc';
        l.CustomCountry__c = 'United States';
        l.Theater__c = 'Americas';// lead theater
        l.Originating_Marketing_Pipeline__c = 4000;
        Leads.add(l);
        Lead bLead = new Lead();
        bLead.RecordtypeId=r.Id;
        bLead.LastName='Test1';
        bLead.company='csc';
        Leads.add(bLead);
        insert Leads;
        
        //Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        //req1.setObjectId(Leads[0].id);
        
        //Approval.ProcessResult result = Approval.process(req1);
        //System.assert(result.isSuccess());

        
        ApexPages.StandardSetController StandardsObjectController = new ApexPages.StandardSetController([select Id,LastName from lead LIMIT 1]);
        StandardsObjectController.setSelected(Leads);
        
        NGCC_LeadList t = new NGCC_LeadList(StandardsObjectController);
        
        t.listwrap[0].status = 'Send to Sales';
        t.save1();
        t.getWorkItemId(Leads[0].Id);        
    }
}