global class DuplicateContactMerge implements Database.Batchable<sObject> {
   String query = '';
   public boolean testRun = false;
    
   global Database.QueryLocator start(Database.BatchableContext BC){
      query = 'SELECT c.LastName, c.Email, c.WinningContact__c, c.AccountId, c.Sequence_Number__c FROM Contact c where c.winningContact__c = True  and c.Sequence_Number__c != null';    
      if (testRun)
      {
        query = query + ' limit 1';
      }
      return Database.getQueryLocator(query);
   }

  global void execute(Database.BatchableContext BC, List<sObject> listObjects){
               
       for (Contact winningContact: (List<Contact>)listObjects)
       {
       
         //get a list of contacts where he last name and email match the winningcontact                                                     
         List<Contact> listDuplicateContacts = [select Id from contact 
                                                     where sequence_number__c = :winningContact.sequence_number__c
                                                     and winningContact__c != true];                                            
         
         
         //merge winningContact listDuplicateContacts;
         for(Contact c : listDuplicateContacts)
         {
             //SCAVA FIX
            if (Contact.sObjectType.getDescribe().isDeletable())
            {
            merge winningContact c;
            }
         }
       }
      
      
   }

   global void finish(Database.BatchableContext BC){

   }
   
   
   public static testMethod void testBatch() {
      
      // get the channel account record type
      String channelAccountRecordTypeId = Utilities.getAccountChannelRecordTypeId();
      
      test.startTest();
      
      // get a partner company account
      Account a = [select Id, Name from Account where RecordTypeId = :channelAccountRecordTypeId limit 1 ];
      
      //create a contact
      Contact c = new Contact();
      c.FirstName = 'Dummy';
      c.lastName = 'Contact 1';
      c.email = 'dummycontact@mail.com';
      c.accountId = a.Id;
      c.Sequence_Number__c = '1';
      c.WinningContact__c = true;
      c.RecordTypeId = Utilities.getContactManualPartnerRecordTypeId();
      
      insert c;
      
      // create second contact
      c = new Contact();
      c.FirstName = 'Funny';
      c.lastName = 'Contact 1';
      c.email = 'dummycontact1@mail.com';
      c.accountId = a.Id;
      c.Sequence_Number__c = '1';
      c.WinningContact__c = false;
      c.RecordTypeId = Utilities.getContactManualPartnerRecordTypeId();
      
      insert c;
      
      DuplicateContactMerge m = new DuplicateContactMerge();
      m.testRun = true;
      Database.executeBatch(m,1);
      
      test.stopTest();
   
   }
          
 }