@isTest
private class MBONewBatchJob_TestClass {
	
	static testMethod void testNovRelease() 
    {             
        Test.startTest();
        /////////////////////////////////////////Nov Release changes starts/////////////////////////////////////////////////////////////////////
        
        MBO_Program__c mboProgram = new MBO_Program__c(Name='TEST_MBO Program', CurrencyIsoCode='USD',Track__c='Test_Track',Enrollment_Level__c ='BEC');
        insert mboProgram;
        
        MBO_Program__c mboProgram2 = new MBO_Program__c(Name='TEST_MBO Program2', CurrencyIsoCode='USD',Track__c='Test_Track2',Enrollment_Level__c ='BEC');
        insert mboProgram2;
        
        MBO_Program__c mboProgram3 = new MBO_Program__c(Name='TEST_MBO Program3', CurrencyIsoCode='USD',Track__c='Test_Track3',Enrollment_Level__c ='BEGEO');
        insert mboProgram3;
        
        MBO_GEO_Coverage__c  geoCvrg2 = new MBO_GEO_Coverage__c (MBO_Program__c=mboProgram.ID,GEO_Code__c='INDIACountryGroup', GEO_Type__c = 'Country Group');
        insert geoCvrg2;
        
        MBO_GEO_Coverage__c  geoCvrg3 = new MBO_GEO_Coverage__c (MBO_Program__c=mboProgram.ID,GEO_Code__c='Country1', GEO_Type__c = 'Country');
        insert geoCvrg3;
        
        MBO_GEO_Coverage__c  geoCvrg4 = new MBO_GEO_Coverage__c (MBO_Program__c=mboProgram2.ID,GEO_Code__c='Country1', GEO_Type__c = 'Country');
        insert geoCvrg4;
        
        
        MBO_GEO_Coverage__c  geoCvrg5 = new MBO_GEO_Coverage__c (MBO_Program__c=mboProgram3.ID,GEO_Code__c='Country Group1', GEO_Type__c = 'Country Group');
        insert geoCvrg5;
        
        
       // pgCountryGroupList.add(pg.Country_Country_Group__c)
        MBO_Partner_Group__c mboPtnrGrp3 = new  MBO_Partner_Group__c (Name='Test_12_II_Nov', Geography__c =  geoCvrg2.ID, Group_Level__c='PARTNER',MBO_Program__c=mboProgram.ID);  
        insert mboPtnrGrp3;
            
         //pgCountryList.add(pg.Country_Country_Group__c);
        MBO_Partner_Group__c mboPtnrGrp4 = new  MBO_Partner_Group__c (Name='Test_12_III_Nov', Geography__c =  geoCvrg3.ID, Group_Level__c='PARTNER',MBO_Program__c=mboProgram.ID, Enrollment_Period__c = '12');  
        insert mboPtnrGrp4;
        
        //Geography can not be selected for track level Group
        MBO_Partner_Group__c mboPtnrGrp5 = new  MBO_Partner_Group__c (Name='Test_12_IV_Nov', Geography__c =  geoCvrg3.ID, Group_Level__c='TRACK',MBO_Program__c=mboProgram.ID);  
        
        try{
        insert mboPtnrGrp5;
       }
       catch(Exception e){
       	
       }
         
       MBO_Partner_Group__c mboPtnrGrp6 = new  MBO_Partner_Group__c (Name='Test_12_V_Nov',  Group_Level__c='TRACK',MBO_Program__c=mboProgram.ID);  
        system.debug('***Going to Insert6');
        insert mboPtnrGrp6;  
        
       //Group at Track level already exists mboPtnrGrp6 and mboPtnrGrp7 are similar
       MBO_Partner_Group__c mboPtnrGrp7 = new  MBO_Partner_Group__c (Name='Test_12_VI_Nov',  Group_Level__c='TRACK',MBO_Program__c=mboProgram.ID);  
        system.debug('***Going to Insert7');
        try{
        insert mboPtnrGrp7; 
       }
       catch(Exception e){
       	
       }
        
        
        
        //Incorrect Geography. Please select a Geography based on Program and Track , track of program and geo are different
        MBO_Partner_Group__c mboPtnrGrp8 = new  MBO_Partner_Group__c (Name='Test_12_VII_Nov', Geography__c =  geoCvrg4.ID, Group_Level__c='PARTNER',MBO_Program__c=mboProgram.ID);  
        
        try{
        insert mboPtnrGrp8;
       }
       catch(Exception e){
       	
       }
        
        //This Geography has already been selected in another partner group , refer mboPtnrGrp3
        MBO_Partner_Group__c mboPtnrGrp9 = new  MBO_Partner_Group__c (Name='Test_12_VIII_Nov', Geography__c =  geoCvrg2.ID, Group_Level__c='PARTNER',MBO_Program__c=mboProgram.ID);  
        try{
        insert mboPtnrGrp9;
       }
       catch(Exception e){
       	
       }
       
       Account partnersNov1 = new Account(name='TestAccount1',Partner_Account_Status__c='Active (Registered)',Country__c='Country1',recordTypeId=Utilities.getAccountChannelRecordTypeId());
       insert partnersNov1;
       
       Account partnersNov2 = new Account(name='TestAccount2',Partner_Account_Status__c='Active (Registered)',Country__c='INDIA',recordTypeId=Utilities.getAccountEndUserRecordTypeId());
       insert partnersNov2;
       
       Account partnersNov3 = new Account(name='TestAccount3',Partner_Account_Status__c='Active (Registered)',Country__c='Country3',recordTypeId=Utilities.getAccountChannelRecordTypeId());
       insert partnersNov3;
       
		Account partnersNov4 = new Account(name='TestAccount4',Partner_Account_Status__c='Active (Registered)',BE_GEO_Name_Country_Group__c='Country Group1',recordTypeId=Utilities.getAccountPartnerCompanyRecordTypeId());
       insert partnersNov4;
       
       Account partnersNov5 = new Account(name='TestAccount5',Partner_Account_Status__c='Active (Registered)',BE_GEO_Name_Country_Group__c='Country Group1',recordTypeId=Utilities.getAccountPartnerCompanyRecordTypeId());
       insert partnersNov5;
       
       //Partners cannot be associated to Track Level Group.       
       MBO_Partner_Group_Map__c mboPntrMapNov1 = new MBO_Partner_Group_Map__c(Account__c=partnersNov1.Id,MBO_Partner_Group__c=mboPtnrGrp6.Id); 
        try{
        insert mboPntrMapNov1;
       }
       catch(Exception e){
       	
       } 
       
       //Only Account with Type "Partner Company" or "Channel" can be used for association, current account type is 
       MBO_Partner_Group_Map__c mboPntrMapNov2 = new MBO_Partner_Group_Map__c(Account__c=partnersNov2.Id,MBO_Partner_Group__c=mboPtnrGrp4.Id); 
        try{
        insert mboPntrMapNov2;
       }
       catch(Exception e){
       	
       }  
 
 
		//Country of the selected account is '+acc.Country__c+' which cannot be associated to this Partner Group
		MBO_Partner_Group_Map__c mboPntrMapNov3 = new MBO_Partner_Group_Map__c(Account__c=partnersNov3.Id,MBO_Partner_Group__c=mboPtnrGrp4.Id); 
        try{
        insert mboPntrMapNov3;
       }
       catch(Exception e){
       	
       }   
        
      MBO_Partner_Group__c mboPtnrGrp10 = new  MBO_Partner_Group__c (Name='Test_12_X_Nov', Geography__c =  geoCvrg5.ID,Enrollment_Period__c = '12' ,Group_Level__c='PARTNER',MBO_Program__c=mboProgram3.ID);  
        
       insert mboPtnrGrp10;
              
       //Account with type as "Channel" cannot be associated to this Partner group, as Group has "BEGEO" level Enrollment
       MBO_Partner_Group_Map__c mboPntrMapNov4 = new MBO_Partner_Group_Map__c(Account__c=partnersNov1.Id,MBO_Partner_Group__c=mboPtnrGrp10.Id); 
        try{
        insert mboPntrMapNov4;
       }
       catch(Exception e){
       	
       }  
       
       //Account with type as "Partner Company" cannot be associated to this Partner group, as Group has "BEC" level Enrollment   
       MBO_Partner_Group_Map__c mboPntrMapNov5 = new MBO_Partner_Group_Map__c(Account__c=partnersNov4.Id,MBO_Partner_Group__c=mboPtnrGrp4.Id); 
        try{
        insert mboPntrMapNov5;
       }
       catch(Exception e){
       	
       } 
       
       //Country Group of the selected account is '+acc.BE_GEO_Name_Country_Group__c+' which cannot be associated to this Partner Group
       //For this account Country group is not defined so it can not match with    
       MBO_Partner_Group_Map__c mboPntrMapNov6 = new MBO_Partner_Group_Map__c(Account__c=partnersNov4.Id,MBO_Partner_Group__c=mboPtnrGrp10.Id); 
        try{
        insert mboPntrMapNov6;
       }
       catch(Exception e){
       	
       } 

		MBO_Partner_Group_Map__c mboPntrMapNov7 = new MBO_Partner_Group_Map__c(Account__c=partnersNov5.Id,MBO_Partner_Group__c=mboPtnrGrp10.Id); 
        insert mboPntrMapNov7;
      
		//Current Partner has an existing association with another Partner Group.
		MBO_Partner_Group_Map__c mboPntrMapNov8 = new MBO_Partner_Group_Map__c(Account__c=partnersNov5.Id,MBO_Partner_Group__c=mboPtnrGrp10.Id); 
        try{
        insert mboPntrMapNov8;
       }
       catch(Exception e){
       	
       } 
		
	//Account partners = new Account(CurrencyIsoCode='AUD', Name='Mukesh');
    //            insert partners;
    
    Date testDate1 = date.newinstance(2012, 3, 3);
    Date testDate2 = date.newinstance(2012, 7, 7);	
	
	MBO_Partner_Enrollment__c mboPrtEnrolNov1 = new MBO_Partner_Enrollment__c(Country__c='Country1',
                Country_Group__c='Country Group1',
                Enrollment_Effective_Date__c =testDate1,
                Enrollment_Expiry_Date__c =testDate2,
                Enrollment_Id__c=1,
                Enrollment_Period__c=12,
                Partner__c=partnersNov1.Id,
                Partner_Country_Group__c='Country Group1',
                Partner_Enrollment_Level__c='BEC',
                Partner_Enrollment_Status__c='Approved',
                Partner_Id__c=1,
                Partner_Name__c='partnersNov1',
                Partner_Theater__c='ASIA',
                Program_Id__c=11,
                Program_Name__c='TEST_MBO Program',
                SubTrack_Id__c=21,
                SubTrack_Name__c='PRODUCT',
                Track_Id__c=10,
                Track_Name__c='Test_Track');
                insert mboPrtEnrolNov1;
                
                
      MBO_Partner_Enrollment__c mboPrtEnrolNov2 = new MBO_Partner_Enrollment__c(
                Country_Group__c='Country Group1',
                Enrollment_Effective_Date__c =testDate1,
                Enrollment_Expiry_Date__c =testDate2,
                Enrollment_Id__c=2,
                Enrollment_Period__c=12,
                Partner__c=partnersNov4.Id,
                Partner_Country_Group__c='Country Group1',
                Partner_Enrollment_Level__c='BE_GEO',
                Partner_Enrollment_Status__c='Approved',
                Partner_Id__c=2,
                Partner_Name__c='partnersNov4',
                Partner_Theater__c='ASIA',
                Program_Id__c=11,
                Program_Name__c='TEST_MBO Program3',
                SubTrack_Id__c=11,
                SubTrack_Name__c='PRODUCT',
                Track_Id__c=10,
                Track_Name__c='Test_Track3');
				try{
                insert mboPrtEnrolNov2;
				}
				catch(Exception e){
					
				}          
				
				
				MBO_Partner_Enrollment__c mboPrtEnrolNov3 = new MBO_Partner_Enrollment__c(
                Country_Group__c='Country Group1',
                Enrollment_Effective_Date__c =testDate1,
                Enrollment_Expiry_Date__c =testDate2,
                Enrollment_Id__c=2,
                Enrollment_Period__c=12,
                Partner__c=partnersNov4.Id,
                Partner_Country_Group__c='Country Group1',
                Partner_Enrollment_Level__c='BE_GEO',
                Partner_Enrollment_Status__c='Approved',
                Partner_Id__c=2,
                Partner_Name__c='partnersNov4',
                Partner_Theater__c='ASIA',
                Program_Id__c=11,
                Program_Name__c='TEST_MBO Program3',
                SubTrack_Id__c=11,
                SubTrack_Name__c='PRODUCT',
                Track_Id__c=10,
                Track_Name__c='Test_Track3');
				try{
                insert mboPrtEnrolNov2;
				}
				catch(Exception e){
					
				} 
				
				
		              
        ///////////////////////////////////////////// Nov Release changes done////////////////////////////////////////////////////////
        Test.stopTest();
        
    }
	
	
	
    static testMethod void xtestMBONewbatchJOb() 
            {    
                Test.startTest();
                 MBO_Program__c mboProgram = new MBO_Program__c(Name='TEST_MBO Program', CurrencyIsoCode='USD',Track__c='Test_Track');
                insert mboProgram;
                
                Master_MBO__c bMbo = new Master_MBO__c (Name='Test_BMbo',Status__c='',MBO_Description__c='Test record', isSchdOnce__c='false',MBO_Program__c = mboProgram.Id ,Sub_Track__c='PRODUCT');
                insert bMbo;
                
                MBO_Partner_Group__c mboPtnrGrp = new  MBO_Partner_Group__c (Name='Test_123',Group_Level__c='1',MBO_Program__c=mboProgram.ID);
                insert mboPtnrGrp;
                
                Date myDate = date.newinstance(2012, 3, 7);
                Date myDate1 = date.newinstance(2012, 3, 7);
                Account partners = new Account(CurrencyIsoCode='AUD', Name='Mukesh');
                insert partners;
                
                Account partners2 = new Account(CurrencyIsoCode='AUD', Name='Siva');

                Account partners3 = new Account(CurrencyIsoCode='AUD', Name='Anil');
                insert partners3;
                
                Account partners4 = new Account(CurrencyIsoCode='AUD', Name='Partner4');
                insert partners4;
                
                MBO_Partner_Group__c mboPtnrGrp2 = new  MBO_Partner_Group__c (Name='Test_12_II',Group_Level__c='2',MBO_Program__c=mboProgram.ID);  
                insert mboPtnrGrp2;
                
                MBO_Partner_Group_Map__c mboPntrMap22 = new MBO_Partner_Group_Map__c(Account__c=partners4.Id,MBO_Partner_Group__c=mboPtnrGrp2.Id); 
                insert mboPntrMap22;
                
                
                MBO_Partner_Enrollment__c mboPrtEnrol = new MBO_Partner_Enrollment__c(Country__c='india',
                Country_Group__c='XYZ',
                Enrollment_Effective_Date__c =myDate,
                Enrollment_Expiry_Date__c =myDate1,
                Enrollment_Id__c=11,
                Enrollment_Period__c=11,
                Partner__c=partners.Id,
                Partner_Country_Group__c='sss',
                Partner_Enrollment_Level__c='www',
                Partner_Enrollment_Status__c='Approved',
                Partner_Id__c=11,
                Partner_Name__c='TCS',
                Partner_Theater__c='ASIA',
                Program_Id__c=11,
                Program_Name__c='TEST_MBO Program',
                SubTrack_Id__c=11,
                SubTrack_Name__c='PRODUCT',
                Track_Id__c=10,
                Track_Name__c='Test_Track');
                insert mboPrtEnrol;

                MBO_Partner_Group_Map__c mboPntrMap = new MBO_Partner_Group_Map__c(Account__c=partners.Id,MBO_Partner_Group__c=mboPtnrGrp.Id);
                insert mboPntrMap;
                MBO_Partner_Group_Map__c mboPntrMap2 = new MBO_Partner_Group_Map__c(Account__c=partners2.Id,MBO_Partner_Group__c=mboPtnrGrp.Id);
                insert mboPntrMap2;

                MBO_Item__c item = new MBO_Item__c (
                Segment__c='Test1234',
                Measure_Unit__c='%',
                Objective__c='No Objective',
                Target__c=100.00,
                Q1_Target_Percent__c =20.00,
                Q2_Target_Percent__c =20.00,
                Q3_Target_Percent__c=30.00,
                Q4_Target_Percent__c =30.00,
                Type__c='Partners',
                Partner_Group__c = mboPtnrGrp.Id,
                MBO__c=bMbo.Id);
                insert item;
                
              Partner_MBO__c pmbo = new Partner_MBO__c(FY_Target__c =100.00,
            FY_Target_Percent__c =100.00,
            //Linitm_Id__c=,
            MBO__c=bMbo.Id,
            MBO_Description__c='No Description',
            MBO_Item__c=item.Id,
            MBO_Partner_Enrollment__c=mboPrtEnrol.Id,
            Measure__c='100.00',
            Measure_Unit__c='100.00',
            Objective__c='NA',
            Partner__c=partners.Id,
            Sub_Track__c ='PRODUCT',
            
            Q1_Target__c =50.00,
            Q1_Target_Percent__c =50.00,
            
            Q2_Target__c =10.00,
            Q2_Target_Percent__c =10.00,
            
            Q3_Target__c =25.00,
            Q3_Target_Percent__c =25.00,
            
            Q4_Target__c =15.00,
            Q4_Target_Percent__c =15.00,
            
            Segment__c='No Seg',
            Status__c=null,
            Target__c=100.00); 
                insert pmbo;
                MBO_Item__c itempartn = new MBO_Item__c (
                Segment__c='Test1234',
                Measure_Unit__c='%',
                Objective__c='No Objective',
                Target__c=100.00,
                Q1_Target_Percent__c =20.00,
                Q2_Target_Percent__c =30.00,
                Q3_Target_Percent__c =20.00,
                Q4_Target_Percent__c =30.00,
                Type__c='Partners',
                Partner__c = partners3.Id,
                MBO__c=bMbo.Id);
                insert itempartn;
                
                //############################################################################################
                Account partners5 = new Account(CurrencyIsoCode='AUD', Name='newPtrn');
                insert partners5;
                Partner_MBO__c pmbo4 = new Partner_MBO__c(FY_Target__c=100.00,
            FY_Target_Percent__c=100.00,
            //Linitm_Id__c=,
            MBO__c=bMbo.Id,
            MBO_Description__c='No Description',
            MBO_Item__c=item.Id,
            MBO_Partner_Enrollment__c=mboPrtEnrol.Id,
            Measure__c='100.00',
            Measure_Unit__c='100.00',
            Objective__c='NA',
            Partner__c=partners5.Id,
            Sub_Track__c ='PRODUCT',
            
            Q1_Target__c=20.00,
            Q1_Target_Percent__c=30.00,
            
            Q2_Target__c=10.00,
            Q2_Target_Percent__c=20.00,
            
            Q3_Target__c=30.00,
            Q3_Target_Percent__c=30.00,
            
            Q4_Target__c=30.00,
            Q4_Target_Percent__c=30.00,
            
            Segment__c='No Seg',
            Status__c=null,
            Target__c=100.00); 
                insert pmbo4;
                MBO_Item__c itempartn4 = new MBO_Item__c (
                Segment__c='Test1234',
                Measure_Unit__c='%',
                Objective__c='No Objective',
                Target__c=100.00,
                Q1_Target_Percent__c=20.00,
                Q2_Target_Percent__c=30.00,
                Q3_Target_Percent__c=20.00,
                Q4_Target_Percent__c=30.00,
                Type__c='Partners',
                Partner__c = partners4.Id,
                MBO__c=bMbo.Id);
                insert itempartn4;
                //############################################################################################
                
                String query='select Name, id,MBO_Program__c, Status__c,MBO_Description__c,Sub_Track__c from Master_MBO__c where id=\''+bMbo.id+'\'';
                List<Master_MBO__c> scope = new List<Master_MBO__c>([select Name, id, MBO_Program__c, Status__c,MBO_Description__c,Sub_Track__c from Master_MBO__c where id=:bMbo.id]);
                //MBOUtil.lineItemPntrIds(bMbo);
                MBONewBatchJob mboBJ = new MBONewBatchJob(query); 
                Database.BatchableContext BC;
                mboBJ.start(BC);
                mboBJ.execute(BC, scope);
                mboBJ.finish(BC);
                Test.stopTest();
    }
 
    static testMethod void testupdPMBO() 
            {    
                Test.startTest();
                 MBO_Program__c mboProgram = new MBO_Program__c(Name='TEST_MBO Program', CurrencyIsoCode='USD',Track__c='Test_Track');
                insert mboProgram;
                
                Master_MBO__c bMbo = new Master_MBO__c (Name='Test_BMbo',Status__c='',MBO_Description__c='Test record', isSchdOnce__c='false',MBO_Program__c = mboProgram.Id ,Sub_Track__c='PRODUCT');
                insert bMbo;
                
                MBO_Partner_Group__c mboPtnrGrp = new  MBO_Partner_Group__c (Name='Test_123',Group_Level__c='1',MBO_Program__c=mboProgram.ID);
                insert mboPtnrGrp;
                
                Date myDate = date.newinstance(2012, 3, 7);
                Date myDate1 = date.newinstance(2012, 3, 7);
                Account partners = new Account(CurrencyIsoCode='AUD', Name='Mukesh');
                insert partners;
                
                Account partners2 = new Account(CurrencyIsoCode='AUD', Name='Siva');

                Account partners3 = new Account(CurrencyIsoCode='AUD', Name='Anil');
                insert partners3;
                
                Account partners4 = new Account(CurrencyIsoCode='AUD', Name='Partner4');
                insert partners4;
                
                MBO_Partner_Group__c mboPtnrGrp2 = new  MBO_Partner_Group__c (Name='Test_12_II',Group_Level__c='2',MBO_Program__c=mboProgram.ID);  
                insert mboPtnrGrp2;
                
                MBO_Partner_Group_Map__c mboPntrMap22 = new MBO_Partner_Group_Map__c(Account__c=partners4.Id,MBO_Partner_Group__c=mboPtnrGrp2.Id); 
                insert mboPntrMap22;
                
                
                MBO_Partner_Enrollment__c mboPrtEnrol = new MBO_Partner_Enrollment__c(Country__c='india',
                Country_Group__c='XYZ',
                Enrollment_Effective_Date__c =myDate,
                Enrollment_Expiry_Date__c =myDate1,
                Enrollment_Id__c=11,
                Enrollment_Period__c=11,
                Partner__c=partners.Id,
                Partner_Country_Group__c='sss',
                Partner_Enrollment_Level__c='www',
                Partner_Enrollment_Status__c='Approved',
                Partner_Id__c=11,
                Partner_Name__c='TCS',
                Partner_Theater__c='ASIA',
                Program_Id__c=11,
                Program_Name__c='TEST_MBO Program',
                SubTrack_Id__c=11,
                SubTrack_Name__c='PRODUCT',
                Track_Id__c=10,
                Track_Name__c='Test_Track');
                insert mboPrtEnrol;

                MBO_Partner_Group_Map__c mboPntrMap = new MBO_Partner_Group_Map__c(Account__c=partners.Id,MBO_Partner_Group__c=mboPtnrGrp.Id);
                insert mboPntrMap;
                MBO_Partner_Group_Map__c mboPntrMap2 = new MBO_Partner_Group_Map__c(Account__c=partners2.Id,MBO_Partner_Group__c=mboPtnrGrp.Id);
                insert mboPntrMap2;

                MBO_Item__c item = new MBO_Item__c (
                Segment__c='Test1234',
                Measure_Unit__c='%',
                Objective__c='No Objective',
                Target__c=100.00,
                Q1_Target_Percent__c =20.00,
                Q2_Target_Percent__c =20.00,
                Q3_Target_Percent__c=30.00,
                Q4_Target_Percent__c =30.00,
                Type__c='Partners',
                Partner_Group__c = mboPtnrGrp.Id,
                MBO__c=bMbo.Id);
                insert item;
                
              Partner_MBO__c pmbo = new Partner_MBO__c(FY_Target__c =100.00,
            FY_Target_Percent__c =100.00,
            //Linitm_Id__c=,
            MBO__c=bMbo.Id,
            MBO_Description__c='No Description',
            MBO_Item__c=item.Id,
            MBO_Partner_Enrollment__c=mboPrtEnrol.Id,
            Measure__c='100.00',
            Measure_Unit__c='100.00',
            Objective__c='NA',
            Partner__c=partners.Id,
            Sub_Track__c ='PRODUCT',
            
            Q1_Target__c =50.00,
            Q1_Target_Percent__c =50.00,
            
            Q2_Target__c =10.00,
            Q2_Target_Percent__c =10.00,
            
            Q3_Target__c =25.00,
            Q3_Target_Percent__c =25.00,
            
            Q4_Target__c =15.00,
            Q4_Target_Percent__c =15.00,
            
            Segment__c='No Seg',
            Status__c=null,
            Target__c=100.00); 
                insert pmbo;
                MBO_Item__c itempartn = new MBO_Item__c (
                Segment__c='Test1234',
                Measure_Unit__c='%',
                Objective__c='No Objective',
                Target__c=100.00,
                Q1_Target_Percent__c =20.00,
                Q2_Target_Percent__c =30.00,
                Q3_Target_Percent__c =20.00,
                Q4_Target_Percent__c =30.00,
                Type__c='Partners',
                Partner__c = partners3.Id,
                MBO__c=bMbo.Id);
                insert itempartn;
                
                //############################################################################################
                Account partners5 = new Account(CurrencyIsoCode='AUD', Name='newPtrn');
                insert partners5;
                Partner_MBO__c pmbo4 = new Partner_MBO__c(FY_Target__c=100.00,
            FY_Target_Percent__c=100.00,
            //Linitm_Id__c=,
            MBO__c=bMbo.Id,
            MBO_Description__c='No Description',
            MBO_Item__c=item.Id,
            MBO_Partner_Enrollment__c=mboPrtEnrol.Id,
            Measure__c='100.00',
            Measure_Unit__c='100.00',
            Objective__c='NA',
            Partner__c=partners5.Id,
            Sub_Track__c ='PRODUCT',
            
            Q1_Target__c=20.00,
            Q1_Target_Percent__c=30.00,
            
            Q2_Target__c=10.00,
            Q2_Target_Percent__c=20.00,
            
            Q3_Target__c=30.00,
            Q3_Target_Percent__c=30.00,
            
            Q4_Target__c=30.00,
            Q4_Target_Percent__c=30.00,
            
            Segment__c='No Seg',
            Status__c=null,
            Target__c=100.00); 
                insert pmbo4;
                MBO_Item__c itempartn4 = new MBO_Item__c (
                Segment__c='Test1234',
                Measure_Unit__c='%',
                Objective__c='No Objective',
                Target__c=100.00,
                Q1_Target_Percent__c=20.00,
                Q2_Target_Percent__c=30.00,
                Q3_Target_Percent__c=20.00,
                Q4_Target_Percent__c=30.00,
                Type__c='Partners',
                Partner__c = partners4.Id,
                MBO__c=bMbo.Id);
                insert itempartn4;
                
                itempartn4.Q1_Target_Percent__c=20.00;
                itempartn4.Q2_Target_Percent__c=30.00;
                itempartn4.Q3_Target_Percent__c=20.00;
                itempartn4.Q4_Target_Percent__c=30.00;
                upsert itempartn4;

                //############################################################################################
                
                String query='select Name, id,MBO_Program__c, Status__c,MBO_Description__c,Sub_Track__c from Master_MBO__c where id=\''+bMbo.id+'\'';
                List<Master_MBO__c> scope = new List<Master_MBO__c>([select Name, id, MBO_Program__c, Status__c,MBO_Description__c,Sub_Track__c from Master_MBO__c where id=:bMbo.id]);
                //MBOUtil.lineItemPntrIds(bMbo);
                MBONewBatchJob mboBJ = new MBONewBatchJob(query); 
                Database.BatchableContext BC;
                mboBJ.start(BC);
                mboBJ.execute(BC, scope);
                mboBJ.finish(BC);
                
               
                
                Test.stopTest();
    } 
    
    
    static testMethod void testMBOUtil() 
    {    
         
        Test.startTest();
        MBO_Program__c mboProgram = new MBO_Program__c(Name='TEST_MBO Program', CurrencyIsoCode='USD',Track__c='Test_Track');
        insert mboProgram;
        
        Master_MBO__c bMbo = new Master_MBO__c (Name='Test_BMbo',Status__c='', MBO_Description__c ='Test record', isSchdOnce__c='false',MBO_Program__c = mboProgram.Id , Sub_Track__c='PRODUCT');
        insert bMbo;

        MBO_Partner_Group__c mboPtnrGrp = new  MBO_Partner_Group__c(Name='Test_123',Group_Level__c='TRACK',MBO_Program__c=mboProgram.ID);
        insert mboPtnrGrp;
        
      
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
        Partner_Group__c = mboPtnrGrp.id,
        MBO__c=bMbo.Id);
        insert item;     
        
        MBOUtil.isOveridable(item, null);
        
       MBO_Partner_Group__c mboPtnrGrp2 = new  MBO_Partner_Group__c(Name='Test_123',Group_Level__c='PARTNER',MBO_Program__c=mboProgram.ID);
        try{
        insert mboPtnrGrp2;
        }
        catch(Exception e){
        	
        }
        MBO_Item__c item2 = new MBO_Item__c (
        Segment__c='Test1234',
        Measure_Unit__c='%',
        Objective__c='No Objective',
        Target__c=100.00,
        Q1_Target_Percent__c =20.00,
        Q2_Target_Percent__c =20.00,
        Q3_Target_Percent__c =30.00,
        Q4_Target_Percent__c =30.00,
        Type__c='Partner Group',
        Partner_Group__c = mboPtnrGrp2.id,
        MBO__c=bMbo.Id);
        insert item2;
         MBOUtil.isOveridable(item, item2);
        
         MBO_Item__c item3 = new MBO_Item__c (
        Segment__c='Test1234',
        Measure_Unit__c='%',
        Objective__c='No Objective',
        Target__c=100.00,
        Q1_Target_Percent__c =20.00,
        Q2_Target_Percent__c =20.00,
        Q3_Target_Percent__c =30.00,
        Q4_Target_Percent__c =30.00,
        Type__c='Partners',
        Partner__c = null,
        MBO__c=bMbo.Id);
        insert item3;
         MBOUtil.isOveridable(item, item3);
         
         MBOUtil.isOveridable(item2, item3);
          
         MBOUtil.isOveridable(item3, item2);
         
          Test.stopTest();
    }
    
    static testMethod void testSubTrackEnrllist() 
    {             
        Test.startTest();
          Account partner1= new Account(CurrencyIsoCode='AUD', Name='Test');
        insert partner1;
        
          Date myDate7 = date.newinstance(2012, 3, 7);
            Date myDate8 = date.newinstance(2012, 3, 7);
        MBO_Partner_Enrollment__c mboPrtEnrol1 = new MBO_Partner_Enrollment__c(Country__c='india',
                Country_Group__c='XYZ',
                Enrollment_Effective_Date__c =myDate7,
                Enrollment_Expiry_Date__c =myDate8,
                Enrollment_Id__c=11,
                Enrollment_Period__c=11,
                Partner__c=partner1.Id,
                Partner_Country_Group__c='sss',
                Partner_Enrollment_Level__c='www',
                Partner_Enrollment_Status__c='Approved',
                Partner_Id__c=11,
                Partner_Name__c='TCS',
                Partner_Theater__c='ASIA',
                Program_Id__c=11,
                Program_Name__c='TEST_MBO Program',
                SubTrack_Id__c=11,
                SubTrack_Name__c='PRODUCT',
                Track_Id__c=10,
                Track_Name__c='Test_Track');
                insert mboPrtEnrol1;
       MBOUtil.getSubTrackEnrllist('Test_Track','PRODUCT');
    
        Test.stopTest();
    }
    
    static testMethod void testSubTrackEnrllist1() 
    {             
        Test.startTest();
          MBO_Program__c mboProgram = new MBO_Program__c(Name='TEST_MBO Program', CurrencyIsoCode='USD',Track__c='Test_Track',Enrollment_Level__c ='BEC');
        insert mboProgram;
        
        Master_MBO__c bMbo = new Master_MBO__c (Name='Test_BMbo',Status__c='', MBO_Description__c ='Test record', isSchdOnce__c='false',MBO_Program__c = mboProgram.Id , Sub_Track__c='PRODUCT');
        insert bMbo;

        Date myDate7 = date.newinstance(2012, 3, 7);
        Date myDate8 = date.newinstance(2012, 3, 7);
        
        RecordType recType=new RecordType(Name='Partner Company');
        Account partners3 = new Account(name='TestAccount',Partner_Account_Status__c='Active (Registered)',Country__c='INDIA',recordTypeId=Utilities.getAccountChannelRecordTypeId());
        insert partners3;
        
        MBO_GEO_Coverage__c  geoCvrg=new MBO_GEO_Coverage__c (MBO_Program__c=mboProgram.ID,GEO_Code__c='INDIA');
        insert geoCvrg;
        
        MBO_Partner_Group__c mboPtnrGrp2 = new  MBO_Partner_Group__c (Name='Test_12_II',Geography__c =  geoCvrg.ID, Group_Level__c='PARTNER',MBO_Program__c=mboProgram.ID);  
       try{
        insert mboPtnrGrp2;
       }
       catch(Exception e){
       	
       }
        
        MBO_Partner_Group_Map__c mboPntrMap22 = new MBO_Partner_Group_Map__c(Account__c=partners3.Id,MBO_Partner_Group__c=mboPtnrGrp2.Id); 
        insert mboPntrMap22;
    
        
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
        Partner_Group__c = mboPtnrGrp2.id,
        MBO__c=bMbo.Id);
        insert item;     
                        
        
        MBO_Partner_Enrollment__c mboPrtEnrol = new MBO_Partner_Enrollment__c(Country__c='india',
                Country_Group__c='XYZ',
                Enrollment_Effective_Date__c =myDate7,
                Enrollment_Expiry_Date__c =myDate8,
                Enrollment_Id__c=11,
                Enrollment_Period__c=11,
                Partner__c=partners3.Id,
                Partner_Country_Group__c='sss',
                Partner_Enrollment_Level__c='www',
                Partner_Enrollment_Status__c='Approved',
                Partner_Id__c=11,
                Partner_Name__c='TCS',
                Partner_Theater__c='ASIA',
                Program_Id__c=11,
                Program_Name__c='TEST_MBO Program',
                SubTrack_Id__c=11,
                SubTrack_Name__c='PRODUCT',
                Track_Id__c=10,
                Track_Name__c='Test_Track');
                insert mboPrtEnrol;
   
    
        Test.stopTest();
    }
    
   
    
    
}