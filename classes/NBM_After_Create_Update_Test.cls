@isTest(seealldata=true)
    /* Test class of code coverage test methods for NBM Project */
    
 private class NBM_After_Create_Update_Test 
 {
 
   private static testMethod void Test_NBM()
   {    
        test.startTest(); 
        
        //NBM_After_Create_Update nac = new NBM_After_Create_Update(); 
             
        User a = [select Id from User where isactive = true limit 1];
        Account acct = new Account(Name='Testing');
        insert acct;
        
        Opportunity oppty = new Opportunity(name='test_oppty',stageName='1 - Prospect',CloseDate=Date.newInstance(2012,11,11),Expected_Product__c = 11,AccountID= acct.ID,Theater__c = 'Americas-US Commercial',Competitors__c = 'Adobe');
        insert oppty; 
  
        Qualification__c b = new Qualification__c (name ='xyz',theater__c='Americas-US Public Sector',Requester_Name__c = a.id,Architecture__c= 'Borderless Networks;Collaboration;Data Center;Service Provider;Smart & Connected Communities',RecordTypeId = Utilities.getNBMQualificationId(),Opportunity__c = oppty.id);
        
        Qualification__c c = new Qualification__c (name ='xyz1',theater__c='APJC-Greater China',Requester_Name__c= UserInfo.getUserId(),Architecture__c= 'Borderless Networks',RecordTypeId = Utilities.getNBMQualificationId());
        
       
        Qualification__c x = new Qualification__c (name ='xyz2',theater__c='EMEAR',Requester_Name__c= UserInfo.getUserId(),Architecture__c= 'Borderless Networks',RecordTypeId = Utilities.getNBMQualificationId());
        
        
         Qualification__c y = new Qualification__c (name ='xyz3',theater__c='Americas-US Commercial',Requester_Name__c= UserInfo.getUserId(),Architecture__c= 'Borderless Networks',RecordTypeId = Utilities.getNBMQualificationId());      
       
        Qualification__c[] e = new Qualification__c[] { b, c, x, y };
        insert e;        
        
        Qualification__c d = new Qualification__c ( Id = c.Id, theater__c='APJC-Greater China',Requester_Name__c = a.id ,RecordTypeId = Utilities.getNBMQualificationId());
        Qualification__c f = new Qualification__c ( Id = b.Id, theater__c='Americas-US Public Sector',Requester_Name__c = UserInfo.getUserId(),RecordTypeId = Utilities.getNBMQualificationId() );
        
        Qualification__c[] g = new Qualification__c[] { d, f };
        update g; 
        
     
        
     
        
        Qualification__c h = new Qualification__c (name ='xyz',RecordTypeId = Utilities.getGSPOrecordtypeId(),Partner__c = 'Microsoft',Opportunity__c = oppty.id);     
        insert h;
        
        test.stopTest();   
   }
}