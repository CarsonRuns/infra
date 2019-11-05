@isTest
public class MBOBaseController_TestClass {
   public static testMethod void testMBOBase() 
    {    
                 MBO_Program__c mboProgram = new MBO_Program__c(Name='TEST_MBO Program', CurrencyIsoCode='USD',Track__c='Test_Track');
                insert mboProgram;
                
                Master_MBO__c bMbo = new Master_MBO__c (Name='Test_BMbo',Status__c='', MBO_Description__c ='Test record', isSchdOnce__c='false',MBO_Program__c = mboProgram.Id , Sub_Track__c='PRODUCT');
                insert bMbo;

                MBO_Partner_Group__c mboPtnrGrp = new  MBO_Partner_Group__c(Name='Test_123',Group_Level__c='PARTNER2',MBO_Program__c=mboProgram.ID);
                insert mboPtnrGrp;
                
               Account partner1= new Account(CurrencyIsoCode='AUD', Name='IBM India');
                insert partner1;
                
                MBO_Item__c item = new MBO_Item__c (
                Segment__c='Test1234',
                Measure_Unit__c='%',
                Objective__c='No Objective',
                Target__c=100.00,
                Q1_Target_Percent__c =20.00,
                Q2_Target_Percent__c =20.00,
                Q3_Target_Percent__c =30.00,
                Q4_Target_Percent__c =30.00,
                Type__c='Partner Group',
                Partner_Group__c = mboPtnrGrp.Id,
                MBO__c=bMbo.Id);
                insert item;
                
                Test.startTest();
                
                //ID is not null and Constructer with argument
                Apexpages.currentPage().getParameters().put('id',bMbo.ID);
                ApexPages.StandardController sc = new ApexPages.standardController(bMbo);
                MBOBaseController obj = new MBOBaseController(sc);  
                obj.newBMBOItem();
                obj.getBMBOList();
                obj.valAndSave();                
                obj.save();
                obj.getPgmList();
                obj.getBMBO();
                obj.getBMBOItem();
                obj.getMBOList();
                obj.getheaders();
                obj.getBMBOItems();
                obj.getSelected();


                Apexpages.currentPage().getParameters().put('id',null);
                MBOBaseController obj1 = new MBOBaseController(sc);  
                obj1.getBMBO();
              
                Apexpages.currentPage().getParameters().put('id',null);                
                MBOBaseController obj2 = new MBOBaseController();


                //Second scenario
                Master_MBO__c bMbo2 = new Master_MBO__c (Name='Test_BMbo_2',Status__c='', MBO_Description__c ='Test record 2', isSchdOnce__c='false',MBO_Program__c = mboProgram.Id , Sub_Track__c='PRODUCT');
                insert bMbo2;

               Account partner2= new Account(CurrencyIsoCode='AUD', Name='IBM US');
                insert partner2;
                
                MBO_Item__c item1 = new MBO_Item__c (
                Segment__c='Test1234',
                Measure_Unit__c='%',
                Objective__c='No Objective',
                Target__c=100.00,
                Q1_Target_Percent__c =20.00,
                Q2_Target_Percent__c =20.00,
                Q3_Target_Percent__c =30.00,
                Q4_Target_Percent__c =30.00,
                Type__c='Partners',
                Partner__c = partner2.Id,
                MBO__c=bMbo2.Id);
                insert item1;
                Apexpages.currentPage().getParameters().put('id',bMbo2.ID);                
                MBOBaseController obj3 = new MBOBaseController();
                
                MBO_Item__c item2 = new MBO_Item__c (
                Segment__c='Test12r',
                Measure_Unit__c='%',
                Objective__c='No Objective',
                Target__c=100.00,
                Q1_Target_Percent__c =-20.00,
                Q2_Target_Percent__c =20.00,
                Q3_Target_Percent__c =30.00,
                Q4_Target_Percent__c =30.00,
                Type__c='Partners',
                Partner__c = partner2.Id,
                MBO__c=bMbo2.Id);
                insert item2;
                
                Apexpages.currentPage().getParameters().put('id',bMbo2.ID);                
                obj3 = new MBOBaseController();
                
                MBO_Item__c item3 = new MBO_Item__c (
                Segment__c='Test12r',
                Measure_Unit__c='%',
                Objective__c='No Objective',
                Target__c=0.00,
                Q1_Target_Percent__c =0.00,
                Q2_Target_Percent__c =20.00,
                Q3_Target_Percent__c =30.00,
                Q4_Target_Percent__c =30.00,
                Type__c='Partners',
                Partner__c = partner2.Id,
                MBO__c=bMbo2.Id);
                insert item3;
                
                Apexpages.currentPage().getParameters().put('id',bMbo2.ID);                
                obj3 = new MBOBaseController();
                
                MBO_Item__c item4 = new MBO_Item__c (
                Segment__c='Test12r',
                Measure_Unit__c='%',
                Objective__c='No Objective',
                Target__c=0,
                Q1_Target_Percent__c =80.00,
                Q2_Target_Percent__c =20.00,
                Q3_Target_Percent__c =30.00,
                Q4_Target_Percent__c =30.00,
                Type__c='Partners',
                Partner__c = partner2.Id,
                MBO__c=bMbo2.Id);
                insert item4;
                
                Apexpages.currentPage().getParameters().put('id',bMbo2.ID);                
               MBOBaseController  obj4 = new MBOBaseController();
                obj4.save();
                
                
                List<MBOBaseController.LineItemWrapper> lineItemWrp = obj3.getLineItemWrp();
                MBOBaseController.LineItemWrapper lineItemobj =lineItemWrp.get(0);
                lineItemobj.setSelected(true);
                obj3.valAndSave();
                obj3.deleteBMBOItem();
                lineItemobj.getSelected();
                lineItemobj.getMBOItem();
                lineItemobj.getPgsMap();
                lineItemobj.getSelected();
                lineItemobj.getErrMsg();
                lineItemobj.getAnyPMBOUndrCalc();
                
                MBO_Program__c mboProgram2 = new MBO_Program__c(Name='TEST_MBO Program', CurrencyIsoCode='USD',Track__c='Test_Track');
                insert mboProgram2;
                
                Master_MBO__c bMbo7 = new Master_MBO__c (Name='Test_BMbo',Status__c='', MBO_Description__c ='Test record', isSchdOnce__c='false',MBO_Program__c = mboProgram2.Id , Sub_Track__c='PRODUCT');
                insert bMbo7;

                MBO_Partner_Group__c mboPtnrGrp2 = new  MBO_Partner_Group__c(Name='Test_123',Group_Level__c='PARTNER2',MBO_Program__c=mboProgram2.ID);
                insert mboPtnrGrp2;
                
                Account partner7= new Account(CurrencyIsoCode='AUD', Name='IBM India');
                insert partner7;
                
                MBO_Item__c item7 = new MBO_Item__c (
                Segment__c='Test1234',
                Measure_Unit__c='%',
                Objective__c='No Objective',
                Target__c=100.00,
                Q1_Target_Percent__c =20.00,
                Q2_Target_Percent__c =20.00,
                Q3_Target_Percent__c =30.00,
                Q4_Target_Percent__c =30.00,
                Type__c='Partners',
                Partner__c = partner7.Id,
                MBO__c=bMbo7.Id);
                insert item7;
                

                
                //ID is not null and Constructer with argument
                Apexpages.currentPage().getParameters().put('id',bMbo7.ID);
                ApexPages.StandardController sc2 = new ApexPages.standardController(bMbo7);
                MBOBaseController obj5 = new MBOBaseController(sc2);  
                obj5.getBMBOList();
                obj5.valAndSave();                
                obj5.save();
                obj5.scheduleAssignments();


                
               Test.stopTest();
       }
    
}