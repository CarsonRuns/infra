@isTest
private class RelatedUpcomingRenewalsOppty_Test {

    static testMethod void testgetNewAndRenewalpportunities(){
        RelatedUpcomingRenewalsOppty obj=new RelatedUpcomingRenewalsOppty();
         User admin = CEE_TestUtility.getUser('admin', true);
           system.Runas(admin) {
            String currencyIsoCode = 'USD';
            String service = 'Service';
            String technology = 'Technology'; 
            Product2[] p2 = new Product2[]{};
                
            ProfileID__c pf = new ProfileID__c();
            pf.Cisco_Renewals__c = '00ec0000000QmlF';
            pf.Cisco_PSS__c = '00e30000000rrZw';       
            insert pf;
               
                 Renewals_Portfolio__c renewalPortfoloi = new Renewals_Portfolio__c();
            renewalPortfoloi.products__c = 'product1';
            renewalPortfoloi.services__c = 'service1';
            renewalPortfoloi.Default_Timeline__c = 'default';
            renewalPortfoloi.Stages__c = 'stage1';
            renewalPortfoloi.Timelines__c = 'timeline';
            insert renewalPortfoloi;
            
            //Create new product2                                 
            Product2 p2Tmp = new Product2(ProductCode=Technology,
                                                Name = 'TechName',
                                                Product_Family_1__c='pf1',
                                                Product_Family_2__c='pf2',
                                                Product_Family_3__c='pf3', 
                                                Product_Family_4__c='pf4',
                                                isactive=true);
            p2.add(p2Tmp);      
            insert p2;    
            //Create default pricebook    
            Pricebook2 createDefaultPB = new Pricebook2(name='Standard Price Book', isActive=true);
            insert createDefaultPB;
            
            //Create pricebook entry
            PricebookEntry pbeTech = new PricebookEntry();
            pbeTech.Pricebook2Id = createDefaultPB.id;
            pbeTech.Product2Id = p2[0].id;
            pbeTech.IsActive = true;
            pbeTech.UnitPrice = 100;
            insert pbeTech;  
            
            //Create Org constant required for opportunity creation
            Org_Constants__c  orgC = new Org_Constants__c();
            orgC.Key__c = 'Oppty: ProfileIds to skip Triggers';
            orgC.prod_value__c = 'For testing';
            orgC.Type__c = 'URL';
            insert orgC;
            
            //Fetch Opportunity record type id
            Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
            Map<String,Schema.RecordTypeInfo> OppRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();     
            Id rtId = OppRecordTypeInfo.get('Global Deal/Opportunity').getRecordTypeId();
                
            //Insert record in Object Record type custom setting for Account creation
            ObjectRecordTypeIds__c objR = new ObjectRecordTypeIds__c();
            objR.Opportunity_Parent_Mobile_RecordTypeId__c = '01234000000GGKw';
            insert objR;
            
            //Insert records in Org Constants custom setting for Account creation
            List<Org_Constant_CS__c> OrgCSlist = new List<Org_Constant_CS__c>();
            
            Org_Constant_CS__c orgCS = new Org_Constant_CS__c();
            orgCS.Name = 'P360 Marketing Play Name';
            orgCS.Production_Value__c = 'Customer Intelligence';
            orgCS.Non_Production_Value__c = 'Customer Intelligence';
            
            Org_Constant_CS__c orgCS1 = new Org_Constant_CS__c();
            orgCS1.Name = 'P360 Target Architecture';
            orgCS1.Production_Value__c = 'Any/All Technologies';
            orgCS1.Non_Production_Value__c = 'Any/All Technologies';
            
            Org_Constant_CS__c orgCS2 = new Org_Constant_CS__c();
            orgCS2.Name = 'P360 Target Prospects Source';
            orgCS2.Production_Value__c = 'Cisco';
            orgCS2.Non_Production_Value__c = 'Cisco';
            
            Org_Constant_CS__c orgCS3 = new Org_Constant_CS__c();
            orgCS3.Name = 'OpptyACVFeedbackUrl';
            orgCS3.Production_Value__c = 'Dummy';
            orgCS3.Non_Production_Value__c = 'Dummy';
            
            OrgCSlist.add(orgCS);
            orgCSlist.add(orgCS1);
            orgCSlist.add(orgCS2);
            orgCSlist.add(orgCS3);
            insert orgCSlist;
            
            //Insert records in Apex Batch Job custom setting for Opportunity creation           
            Apex_Batch_Job__c job = new Apex_Batch_Job__c();
            job.Name = 'closedate';
            job.Date_TimeStamp__c = Date.newInstance(2017, 7, 30);
            insert job;
            
            //Create new Accounts
            Account acc = GenericStaticTestData.getTestEndUserAccountRecordRed();
            Account acc1 = GenericStaticTestData.gettestChannelAccountRecord1();
            
            //Create new opportunity
            Opportunity oppty = new Opportunity(name='Test', accountId = acc.id, StageName='2 - Qualified', CloseDate=System.today() + 50, Expected_Product__c=10.0,
                                                error_description__c='error', DealID__c='1', Opportunity_Status__c='Active', recordtypeId=rtId, Opportunity_Owner_AM__c =userinfo.getUserId(),
                                                Primary_Partner__c = acc1.id, Competitors__c = 'A10 Networks', Is_Product_Quote_Integrated__c = 'Yes', Is_Service_Quote_Integrated__c = 'No' ); 
            insert oppty; 
            List<Opportunity> newOppty=RelatedUpcomingRenewalsOppty.getNewOpportunities(oppty.Id); 
            List<Opportunity> renewalsOppty=RelatedUpcomingRenewalsOppty.getRenewalOpportunities(oppty.Id); 
            System.assertEquals(0,newOppty.size());
            System.assertEquals(0,renewalsOppty.size());
        }
    }
}