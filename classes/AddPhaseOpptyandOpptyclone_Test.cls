@isTest(seealldata=true)
    private class AddPhaseOpptyandOpptyclone_Test{
        static testMethod void opptyInsertTestBulk(){
            AddPhaseOppty.setProcessLineItems(true);
            Date vCloseDate = System.today();
            //Get users default currency
            User currentUser = [select defaultCurrencyIsoCode from User where Id = :UserInfo.getUserId()];
            //Query for Pricebook2
            String defaultPricebookId;
            Pricebook2[] pricebook2 = [select id from Pricebook2];
            if(pricebook2 == null || pricebook2.size() == 0){
                Pricebook2 createDefaultPB = new Pricebook2(name='default pricebook', isActive=true);
                insert createDefaultPB;
                defaultPricebookId = createDefaultPB.Id;
            }
            else{
                defaultPricebookId = pricebook2[0].Id;

            }
            Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('End-User').getRecordTypeId();
            Account acct1 = [select id from account where RecordTypeId=:devRecordTypeId limit 1];
            // insert acct1;
            //Build a few new Opportunity objects
            Opportunity oppty1 = new Opportunity(name='Test1',Accountid=acct1.id, StageName='1 - Identify',CloseDate= vCloseDate,Competitors__c = 'A10 Networks',Expected_Product__c=2,Pricebook2Id=defaultPricebookId,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode);
            Opportunity oppty2 = new Opportunity(Accountid=acct1.id,name='Test2MakeingTheNameOverEightyEightCharactersSoWeCanTest1234567890123456789012345678901234567890',StageName='1 - Identify',Competitors__c = 'A10 Networks',CloseDate= vCloseDate,Expected_Product__c=2,Pricebook2Id=defaultPricebookId,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode);
            Opportunity oppty3 = new Opportunity(name='Test1',Accountid=acct1.id,StageName='1 - Identify',CloseDate= vCloseDate,Competitors__c = 'A10 Networks',Expected_Product__c=0,Pricebook2Id=defaultPricebookId,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode);
            Opportunity oppty4 = new Opportunity(name='Test4',Accountid=acct1.id,StageName='1 - Identify',CloseDate= vCloseDate,Competitors__c = 'A10 Networks',Expected_Product__c=0,Pricebook2Id=defaultPricebookId,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode);

            Opportunity[] opptyArray = new Opportunity[]{oppty1,oppty2,oppty3,oppty4};

            insert opptyArray;
            //Now update the Opportunity
            opptyArray[0].Expected_Service__c = 0;
            opptyArray[0].Expected_Product__c = 0;
            opptyArray[1].Expected_Service__c = 75;
            opptyArray[1].Expected_Product__c = 75;
            opptyArray[2].Expected_Service__c = 75;
            opptyArray[3].Expected_Service__c = 100;
            opptyArray[3].Expected_Product__c = 100;
            update opptyArray;
            
            String partnerParentRT = Utilities.getRecordTypeId('Opportunity', 'Partner Parent Opportunity');

            // create a partner to add to a partner parent opportunity
            
            opptyArray[1].Primary_Partner__c = acct1.Id;
            opptyArray[1].Primary_Partner_Role__c = 'Other';
            
            String strResult='';
            strResult=AddPhaseOppty.AddPhase(opptyArray[1].Id, partnerParentRT); // testing for Partner Oppty
            strResult=AddPhaseOppty.AddPhase(opptyArray[0].Id, 'Parent');// testing for Parent Oppty
           // strResult=AddPhaseOppty.AddPhase(strResult, 'Parent');// testing for phase oppty by passing the returned Phase Oppty Id
            //strResult=AddPhaseOppty.AddPhase(opptyArray[2].Id, 'Parent');// testing same name
           
        }

        static testMethod void opptyLineItemUpdateTestBulk(){
            AddPhaseOppty.setProcessLineItems(true);
            OpportunityLineItem[] oliArray = [select o.Id,o.Mix__c from OpportunityLineItem o Where o.PricebookEntry.ProductCode ='Service' LIMIT 25];
            update oliArray;

            oliArray = [select o.Id,o.Mix__c from OpportunityLineItem o Where o.PricebookEntry.ProductCode ='Technology' LIMIT 25];
            update oliArray;
        }

        static testMethod void AddPhaseTestMethod(){
            String strResult='';
            strResult=AddPhaseOppty.AddPhase('dfadf', 'parent');// invalid parent oppty      
            
        }
         static testMethod void opptyCloneTestMethod(){
            Date vCloseDate = System.today();
            //Get users default currency
            User currentUser = [select defaultCurrencyIsoCode from User where Id = :UserInfo.getUserId()];
            
            //Query for Pricebook2
            String defaultPricebookId;
            Pricebook2[] pricebook2 = [select id, Name from Pricebook2];
            if(pricebook2 == null || pricebook2.size() == 0){
            Pricebook2 createDefaultPB = new Pricebook2(name='default pricebook', isActive=true);
            insert createDefaultPB;
            defaultPricebookId = createDefaultPB.Id;
            }
            else{
                for(Pricebook2 pb :pricebook2){
                    if(pb.Name == 'Standard Price Book'){
                        defaultPricebookId = pb.Id;
                    }
                }
            }
            // create a partner to add to a partner parent opportunity
            Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('End-User').getRecordTypeId();
            Account acct1 = [select id from account where RecordTypeId=:devRecordTypeId limit 1];
            //insert acct1;
            //Build a few new Opportunity objects
            Opportunity oppty1 = new Opportunity(name='Test1',AccountId= acct1.id, StageName='1 - Identify',Competitors__c='A10 Networks', CloseDate= vCloseDate,Expected_Product__c=2,Pricebook2Id=defaultPricebookId,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode);
            Opportunity oppty2 = new Opportunity(AccountId= acct1.id,name='Test2MakeingTheNameOverEightyEightCharactersSoWeCanTest1234567890123456789012345678901234567890',StageName='1 - Identify',Competitors__c = 'A10 Networks',CloseDate= vCloseDate,Expected_Product__c=2,Pricebook2Id=defaultPricebookId,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode);
            Opportunity oppty3 = new Opportunity(name='Test1',AccountId= acct1.id,StageName='1 - Identify',Competitors__c = 'A10 Networks',CloseDate= vCloseDate,Expected_Product__c=0,Pricebook2Id=defaultPricebookId,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode);
            Opportunity oppty4 = new Opportunity(name='Test4',AccountId= acct1.id,StageName='1 - Identify',Competitors__c = 'A10 Networks',CloseDate= vCloseDate,Expected_Product__c=0,Pricebook2Id=defaultPricebookId,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode);
            Opportunity[] opptyArray = new Opportunity[]{oppty1,oppty2,oppty3,oppty4};
            insert opptyArray;
            //Now update the Opportunity
            opptyArray[0].Expected_Service__c = 0;
            opptyArray[0].Expected_Product__c = 0;
            opptyArray[1].Expected_Service__c = 75;
            opptyArray[1].Expected_Product__c = 75;
            opptyArray[2].Expected_Service__c = 75;
            opptyArray[3].Expected_Service__c = 100;
            opptyArray[3].Expected_Product__c = 100;
            update opptyArray;
            
           
            opptyArray[1].Primary_Partner__c = acct1.Id;
            opptyArray[1].Primary_Partner_Role__c = 'Other';
            
            Id pricebookId = Test.getStandardPricebookId();
            PricebookEntry pbEntry = [Select ID from PricebookEntry where ProductCode = 'Technology' and isActive = true and CurrencyIsoCode = 'USD' limit 1];
            OpportunityLineItem oli1 = new OpportunityLineItem();
                oli1.Mix__c= 100;
                oli1.Business_Entity__c = 'COMPUTING SYSTEMS';
                oli1.OpportunityId=opptyArray[1].Id;
                oli1.PricebookEntryId=pbEntry.id;
                oli1.Quantity=1;              
                insert oli1;    
                
            String ParentRT = Utilities.getRecordTypeId('Opportunity', 'Parent Opportunity');
            List<String> strResult= new List<String>();
            strResult=OpptyClone.clone(opptyArray[1].Id, ParentRT.substring(0,15)); // testing for Partner Oppty
            strResult=OpptyClone.clone(opptyArray[0].Id, ParentRT.substring(0,15));// testing for Parent Oppty
            /*strResult=OpptyClone.clone(strResult, ParentRT.substring(0,15));// testing for parent oppty by passing the returned Parent Oppty Id
            ''OpportunityLineItem testItem = [SELECT CurrencyIsoCode, Description, ListPrice, Mix__c, Opportunity_Line_Value__c, 
                                            OpportunityId, PricebookEntryId,Product_Family_US__c, Quantity, Service_Level__c,
                                            Service_Category__c, SortOrder, TotalPrice from OpportunityLineItem limit 1]; */                              
            
           
            //strResult=OpptyClone.clone(opptyArray[2].Id, ParentRT.substring(0,15));// testing same name        
     
         }
         static testMethod void cloneTestMethod(){
            List<String> strResult= new List<String>();
            strResult=OpptyClone.clone('Test Clone', Utilities.getRecordTypeId('Opportunity', 'Parent Opportunity'));// invalid parent oppty
          }
    }