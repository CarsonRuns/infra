@isTest
private class PartnerSearch_TestClass {

             static testMethod void testPartner_Search() 
            {    
                Test.startTest();
                
                MBO_Program__c mboProgram = new MBO_Program__c(Name='TEST_MBO Program', CurrencyIsoCode='USD',Track__c='US');
                insert mboProgram;
                
                Master_MBO__c bMbo = new Master_MBO__c (Name='Test_BMbo',Status__c='',MBO_Description__c ='Test record', isSchdOnce__c='false',MBO_Program__c = mboProgram.Id ,Sub_Track__c='PRODUCT');
                insert bMbo;
                
                MBO_Partner_Group__c mboPtnrGrp = new  MBO_Partner_Group__c (Name='Test_123',Group_Level__c='5',MBO_Program__c=mboProgram.ID);
                insert mboPtnrGrp;
                
                MBO_Partner_Group__c mboPtnrGrp2 = new  MBO_Partner_Group__c (Name='Test_1234',Group_Level__c='5',MBO_Program__c=mboProgram.ID);
                insert mboPtnrGrp2;
                
                Account partners = new Account(CurrencyIsoCode='AUD', Name='Mukesh');
                insert partners;
                
                Account partners2 = new Account(CurrencyIsoCode='AUD', Name='Siva');
                insert partners2;
                
                MBO_Partner_Group_Map__c mboPntrMap22 = new MBO_Partner_Group_Map__c(Account__c=partners.Id,MBO_Partner_Group__c=mboPtnrGrp.Id); 
                insert mboPntrMap22;
                
                MBO_Partner_Group_Map__c mboPntrMap23 = new MBO_Partner_Group_Map__c(Account__c=partners2.Id,MBO_Partner_Group__c=mboPtnrGrp.Id); 
                insert mboPntrMap23;
                Date myDate = date.newinstance(2012, 3, 7);
                Date myDate1 = date.newinstance(2012, 3, 7);
                 MBO_Partner_Enrollment__c mboPrtEnrol = new MBO_Partner_Enrollment__c(Country__c='india',
                Country_Group__c='XYZ',
                Enrollment_Effective_Date__c=myDate,
                Enrollment_Expiry_Date__c=myDate1,
                Enrollment_Id__c=11,
                Enrollment_Period__c=11,
                Partner__c=partners2.Id,
                Partner_Country_Group__c='sss',
                Partner_Enrollment_Level__c='www',
                Partner_Enrollment_Status__c='APPROVED',
                Partner_Id__c=11,
                Partner_Name__c='TCS',
                Partner_Theater__c='ASIA',
                Program_Id__c=11,
                Program_Name__c='noprogram',
                SubTrack_Id__c=11,
                SubTrack_Name__c='PRODUCT',
                Track_Id__c=10,
                Track_Name__c='US');
                insert mboPrtEnrol;
                
                MBO_Partner_Enrollment__c mboPrtEnrol1 = new MBO_Partner_Enrollment__c(Country__c='india',
                Country_Group__c='XYZ',
                Enrollment_Effective_Date__c=myDate,
                Enrollment_Expiry_Date__c=myDate1,
                Enrollment_Id__c=11,
                Enrollment_Period__c=11,
                Partner__c=partners.Id,
                Partner_Country_Group__c='sss',
                Partner_Enrollment_Level__c='www',
                Partner_Enrollment_Status__c='APPROVED',
                Partner_Id__c=11,
                Partner_Name__c='TCS',
                Partner_Theater__c='ASIA',
                Program_Id__c=11,
                Program_Name__c='noprogram',
                SubTrack_Id__c=11,
                SubTrack_Name__c='PRODUCT',
                Track_Id__c=10,
                Track_Name__c='US');
                insert mboPrtEnrol1;
                
                Apexpages.currentPage().getParameters().put('stringvalue','Test_123');
                Apexpages.currentPage().getParameters().put('stringtype','Partner Group');
                Apexpages.currentPage().getParameters().put('pntrTypeId','Partners');
                //Apexpages.currentPage().getParameters().put('pntrGroupId','');
                //Apexpages.currentPage().getParameters().put('pntrType',);
                Apexpages.currentPage().getParameters().put('pntrGroup',mboPtnrGrp.ID);
                Apexpages.currentPage().getParameters().put('prdSvcDDVal',bMbo.Sub_Track__c);
                Apexpages.currentPage().getParameters().put('mboPgmId',mboProgram.Id);

                //Apexpages.currentPage().getParameters().put('usedPGIds',mboPtnrGrp.Id);
                List<account> accountList = [SELECT Name FROM Account LIMIT 5];
                ApexPages.StandardSetController controller = new ApexPages.StandardSetController(accountList);
                Partner_Search PS = new Partner_Search(controller);
                
                PS.setPageSize(1);
                
                PS.getHasNext();
                PS.getHasPrevious();
                PS.getPageSize();
                PS.getPartnerGroups();
                PS.pageSize = 1 ;
                PS.getPartnerGroups();
                PS.pageSize = 10 ;
                //PS.getPartners();
                //PS.getResultSize();
                
                PS.next();
                PS.previous();
                PS.doSearch() ;
                
                System.debug('PS.getResultSize() Mukesh'+PS.getResultSize());
                
                
                MBO_Program__c mboProgram1 = new MBO_Program__c(Name='TEST_MBO Program', CurrencyIsoCode='USD',Track__c='US');
                insert mboProgram1;
                
                Master_MBO__c bMbo1 = new Master_MBO__c (Name='Test_BMbo',Status__c='',MBO_Description__c='Test record', isSchdOnce__c='false',MBO_Program__c = mboProgram1.Id ,Sub_Track__c='PRODUCT');
                insert bMbo1;
                
                MBO_Partner_Group__c mboPtnrGrp1 = new  MBO_Partner_Group__c (Name='Test_123',Group_Level__c='1',MBO_Program__c=mboProgram1.ID);
                insert mboPtnrGrp1;
                
             
             
             
             
                Account partners201 = new Account(CurrencyIsoCode='AUD', Name='Account1');
                insert partners201;
                
                Account partners202 = new Account(CurrencyIsoCode='AUD', Name='Account2');
                insert partners202;
                
                MBO_Partner_Group_Map__c mboPntrMap202 = new MBO_Partner_Group_Map__c(Account__c=partners201.Id,MBO_Partner_Group__c=mboPtnrGrp1.Id); 
                insert mboPntrMap202;
                
                MBO_Partner_Group_Map__c mboPntrMap203 = new MBO_Partner_Group_Map__c(Account__c=partners202.Id,MBO_Partner_Group__c=mboPtnrGrp1.Id); 
                insert mboPntrMap203;

                 MBO_Partner_Enrollment__c mboPrtEnrol201 = new MBO_Partner_Enrollment__c(Country__c='india',
                Country_Group__c='XYZ',
                Enrollment_Effective_Date__c=myDate,
                Enrollment_Expiry_Date__c=myDate1,
                Enrollment_Id__c=11,
                Enrollment_Period__c=11,
                Partner__c=partners201.Id,
                Partner_Country_Group__c='sss',
                Partner_Enrollment_Level__c='www',
                Partner_Enrollment_Status__c='APPROVED',
                Partner_Id__c=11,
                Partner_Name__c='TCS',
                Partner_Theater__c='ASIA',
                Program_Id__c=11,
                Program_Name__c='TEST_MBO Program',
                SubTrack_Id__c=11,
                SubTrack_Name__c='PRODUCT',
                Track_Id__c=10,
                Track_Name__c='US');
                insert mboPrtEnrol201;
                
                MBO_Partner_Enrollment__c mboPrtEnrol202 = new MBO_Partner_Enrollment__c(Country__c='india',
                Country_Group__c='XYZ',
                Enrollment_Effective_Date__c=myDate,
                Enrollment_Expiry_Date__c=myDate1,
                Enrollment_Id__c=11,
                Enrollment_Period__c=11,
                Partner__c=partners202.Id,
                Partner_Country_Group__c='sss',
                Partner_Enrollment_Level__c='www',
                Partner_Enrollment_Status__c='APPROVED',
                Partner_Id__c=11,
                Partner_Name__c='TCS',
                Partner_Theater__c='ASIA',
                Program_Id__c=11,
                Program_Name__c='TEST_MBO Program',
                SubTrack_Id__c=11,
                SubTrack_Name__c='PRODUCT',
                Track_Id__c=10,
                Track_Name__c='US');
                insert mboPrtEnrol202;
                
                
                Apexpages.currentPage().getParameters().put('stringvalue','Account');
                Apexpages.currentPage().getParameters().put('stringtype','Partners');
                Apexpages.currentPage().getParameters().put('pntrTypeId','Partners');
                //Apexpages.currentPage().getParameters().put('pntrGroupId','');
                //Apexpages.currentPage().getParameters().put('pntrType',);
                Apexpages.currentPage().getParameters().put('pntrGroup',mboPtnrGrp1.ID);
                Apexpages.currentPage().getParameters().put('prdSvcDDVal',bMbo1.Sub_Track__c);
                Apexpages.currentPage().getParameters().put('mboPgmId',mboProgram1.Id);

                //Apexpages.currentPage().getParameters().put('usedPGIds',mboPtnrGrp1.Id);
                List<account> accountList1 = [SELECT Name FROM Account LIMIT 5];
                ApexPages.StandardSetController controller1 = new ApexPages.StandardSetController(accountList1);
                Partner_Search PS1 = new Partner_Search(controller1);
                
                PS1.setPageSize(1);
                PS1.getHasNext();
                PS1.getHasPrevious();
                PS1.getPageSize();
                //PS1.getPartnerGroups();
                PS1.getPartners();
                PS.pageSize = 1 ;
                PS1.getPartners();
                PS.pageSize = 10 ;
                //PS1.getResultSize();
                
                PS1.next();
                PS1.previous();
                PS1.doSearch() ;
                Test.stopTest();
            }
 
}