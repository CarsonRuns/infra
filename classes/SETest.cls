@isTest
    /** Test class of code coverage test methods  
    for SE Integration classes 
    Update_Opty_Engagement_type, Add_Resource_As_OptyTeam,Add_CaseOwner_As_OptyTeam  
    Created for SE Integration Q1FY10 */

    private class SETest {
    //Test code for SE
    private static testMethod void Test_Upd_Opty_Eng_Type(){
     DATE vCloseDate=system.today();
     Pricebookentry[] AS_P=[SELECT product2.id FROM Pricebookentry WHERE IsActive=true AND PRODUCTCODE='Service' AND product2.service_type__c='AS' limit 1];
     Pricebookentry[] servASPb = [select Id,CurrencyIsoCode from Pricebookentry where IsActive=true AND PRODUCTCODE='Service'  and CurrencyIsoCode='USD' AND product2id=:AS_P[0].product2id limit 3];

     System.debug( '\n start \n*getQueries ' + Limits.getQueries() +'\n\tgetLimitQueries ' + Limits.getLimitQueries()  +'\n*getQueryRows ' + Limits.getQueryRows()  +'\n\tgetLimitQueryRows ' + Limits.getLimitQueryRows()  +'\n*getScriptStatements ' + Limits.getScriptStatements() +'\n\tgetLimitScriptStatements ' + Limits.getLimitScriptStatements() );  
     Opportunity newOpportunity1 = new Opportunity(dealid__c='A111',name='Test111',StageName='2 - Qualification',CloseDate= vCloseDate.adddays(2),CurrencyIsoCode='USD',expected_product__c=0,expected_service__c=10,forecast_status__c='Commit',Non_Standard_Terms_and_Conditions__c='None', recordtypeid='0123000000003ykAAA');
     Opportunity newOpportunity2 = new Opportunity(dealid__c='A112',name='Test112',StageName='3 - Proposal',CloseDate= vCloseDate.adddays(3),CurrencyIsoCode='USD',expected_product__c=0,expected_service__c=20,forecast_status__c='Commit',Non_Standard_Terms_and_Conditions__c='None', recordtypeid='0123000000003ykAAA' );
     Opportunity newOpportunity3 = new Opportunity(dealid__c='A113',name='Test113',StageName='3 - Proposal',CloseDate= vCloseDate.adddays(3),CurrencyIsoCode='USD',expected_product__c=0,expected_service__c=0,forecast_status__c='Commit',Non_Standard_Terms_and_Conditions__c='None' , recordtypeid='0123000000003ykAAA');

     Opportunity[] opptyArray = new Opportunity[]{newOpportunity1,newOpportunity2,newOpportunity3};
     insert opptyArray;
/*
      OpportunityLineItem ol1 = new OpportunityLineItem( OpportunityId = newOpportunity1.Id, Mix__c =100, Quantity =1,PricebookEntryId=servASPb[0].ID);
      OpportunityLineItem ol2 = new OpportunityLineItem( OpportunityId = newOpportunity2.Id, Mix__c =100, Quantity =1,PricebookEntryId=servASPb[0].ID);
      OpportunityLineItem[] ol = new OpportunityLineItem[]{ol1,ol2};
      insert ol;
*/
        user[] user1=[select id from user where isactive=true limit 1];
    //    user rn=new user(id=user1.id);
        Resource_Request_Assignment__c r1=new Resource_Request_Assignment__c(Opportunity_Name__c=newOpportunity1.Id,Resource_Name__c =user1[0].id,Assignment_Type__c='Partner Secondary');
        Resource_Request_Assignment__c r2=new Resource_Request_Assignment__c(Opportunity_Name__c=newOpportunity1.Id,Resource_Name__c =user1[0].id,Assignment_Type__c='Secondary');
        Resource_Request_Assignment__c r3=new Resource_Request_Assignment__c(Opportunity_Name__c=newOpportunity1.Id,Resource_Name__c =user1[0].id,Assignment_Type__c='Partner Primary');
        Resource_Request_Assignment__c r4=new Resource_Request_Assignment__c(Opportunity_Name__c=newOpportunity1.Id,Resource_Name__c =user1[0].id,Assignment_Type__c='Secondary');
        Resource_Request_Assignment__c r5=new Resource_Request_Assignment__c(Opportunity_Name__c=newOpportunity1.Id,Resource_Name__c =user1[0].id,Assignment_Type__c='Partner Secondary');
        Resource_Request_Assignment__c r6=new Resource_Request_Assignment__c(Opportunity_Name__c=newOpportunity1.Id,Resource_Name__c =user1[0].id,Assignment_Type__c='Secondary');
        Resource_Request_Assignment__c r7=new Resource_Request_Assignment__c(Opportunity_Name__c=newOpportunity1.Id,Resource_Name__c =user1[0].id,Assignment_Type__c='Partner Secondary');
        Resource_Request_Assignment__c r8=new Resource_Request_Assignment__c(Opportunity_Name__c=newOpportunity1.Id,Resource_Name__c =user1[0].id,Assignment_Type__c='Secondary');
        Resource_Request_Assignment__c r9=new Resource_Request_Assignment__c(Opportunity_Name__c=newOpportunity2.Id,Resource_Name__c =user1[0].id,Assignment_Type__c='Partner Secondary');
        Resource_Request_Assignment__c r10=new Resource_Request_Assignment__c(Opportunity_Name__c=newOpportunity2.Id,Resource_Name__c =user1[0].id,Assignment_Type__c='Secondary');
        Resource_Request_Assignment__c r11=new Resource_Request_Assignment__c(Opportunity_Name__c=newOpportunity2.Id,Resource_Name__c =user1[0].id,Assignment_Type__c='Partner Primary');
        Resource_Request_Assignment__c r12=new Resource_Request_Assignment__c(Opportunity_Name__c=newOpportunity2.Id,Resource_Name__c =user1[0].id,Assignment_Type__c='Secondary');
        Resource_Request_Assignment__c r13=new Resource_Request_Assignment__c(Opportunity_Name__c=newOpportunity2.Id,Resource_Name__c =user1[0].id,Assignment_Type__c='Partner Secondary');
        Resource_Request_Assignment__c r14=new Resource_Request_Assignment__c(Opportunity_Name__c=newOpportunity2.Id,Resource_Name__c =user1[0].id,Assignment_Type__c='Secondary');
        Resource_Request_Assignment__c r16=new Resource_Request_Assignment__c(Opportunity_Name__c=newOpportunity2.Id,Resource_Name__c =user1[0].id,Assignment_Type__c='Secondary');
        Resource_Request_Assignment__c r15=new Resource_Request_Assignment__c(Opportunity_Name__c=newOpportunity2.Id,Resource_Name__c =user1[0].id,Assignment_Type__c='Partner Secondary');
    
        Resource_Request_Assignment__c[] rarray=new Resource_Request_Assignment__c[]{r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r16,r15};
    //    test.startTest();
           insert rarray;
    //       test.stopTest();
    
        Resource_Request_Assignment__c r17=new Resource_Request_Assignment__c(id=r1.id,Opportunity_Name__c=newOpportunity1.Id,Resource_Name__c =user1[0].id,Assignment_Type__c='Partner Primary');
        Resource_Request_Assignment__c r18=new Resource_Request_Assignment__c(id=r2.id,Opportunity_Name__c=newOpportunity2.Id,Resource_Name__c =user1[0].id,Assignment_Type__c='Partner Primary');
     //   Resource_Request_Assignment__c r23=new Resource_Request_Assignment__c(id=r3.id,Opportunity_Name__c=newOpportunity3.Id,Resource_Name__c =user1[0].id,Assignment_Type__c='Partner Primary');
    
        Resource_Request_Assignment__c[] rarray1=new Resource_Request_Assignment__c[]{r17,r18};
        update rarray1;
        
        Resource_Request_Assignment__c r19=new Resource_Request_Assignment__c(id=r1.id,Opportunity_Name__c=newOpportunity1.Id,Resource_Name__c =user1[0].id,Assignment_Type__c='Primary');
        Resource_Request_Assignment__c r20=new Resource_Request_Assignment__c(id=r2.id,Opportunity_Name__c=newOpportunity2.Id,Resource_Name__c =user1[0].id,Assignment_Type__c='Primary');
    //    Resource_Request_Assignment__c r24=new Resource_Request_Assignment__c(id=r3.id,Opportunity_Name__c=newOpportunity3.Id,Resource_Name__c =user1[0].id,Assignment_Type__c='Primary');
    
        Resource_Request_Assignment__c[] rarray2=new Resource_Request_Assignment__c[]{r19,r20};
        update rarray2;
        
        Resource_Request_Assignment__c r21=new Resource_Request_Assignment__c(id=r1.id,Opportunity_Name__c=newOpportunity1.Id,Resource_Name__c =user1[0].id,Assignment_Type__c='Secondary');
        Resource_Request_Assignment__c r22=new Resource_Request_Assignment__c(id=r2.id,Opportunity_Name__c=newOpportunity2.Id,Resource_Name__c =user1[0].id,Assignment_Type__c='Secondary');
    //    Resource_Request_Assignment__c r25=new Resource_Request_Assignment__c(id=r3.id,Opportunity_Name__c=newOpportunity3.Id,Resource_Name__c =user1[0].id,Assignment_Type__c='Secondary');
    
        Resource_Request_Assignment__c[] rarray3=new Resource_Request_Assignment__c[]{r21,r22};
        update rarray3;
    //        test.stopTest();

     }
     
     /* FEB-2015 Story: US7301
     Removed the test method - Test_Add_CaseOwner_OptyTeam to cleanup Resource_Case__c object */

    private static testMethod void Test_Add_Resource_OptyTeam()
    {
         DATE vCloseDate=system.today();
         Pricebookentry[] AS_P=[SELECT product2.id FROM Pricebookentry WHERE IsActive=true AND PRODUCTCODE='Service' AND product2.service_type__c='AS' limit 1];
         Pricebookentry[] servASPb = [select Id,CurrencyIsoCode from Pricebookentry where IsActive=true AND PRODUCTCODE='Service'  and CurrencyIsoCode='USD' AND product2id=:AS_P[0].product2id limit 3];
    
         System.debug( '\n start \n*getQueries ' + Limits.getQueries() +'\n\tgetLimitQueries ' + Limits.getLimitQueries()  +'\n*getQueryRows ' + Limits.getQueryRows()  +'\n\tgetLimitQueryRows ' + Limits.getLimitQueryRows()  +'\n*getScriptStatements ' + Limits.getScriptStatements() +'\n\tgetLimitScriptStatements ' + Limits.getLimitScriptStatements() );  
        Opportunity newOpportunity1 = new Opportunity(dealid__c='A111',name='Test111',StageName='2 - Qualification',CloseDate= vCloseDate.adddays(2),CurrencyIsoCode='USD',expected_product__c=0,expected_service__c=10,forecast_status__c='Commit',Non_Standard_Terms_and_Conditions__c='None', recordtypeid='0123000000003ykAAA');
        Opportunity newOpportunity2 = new Opportunity(dealid__c='A112',name='Test112',StageName='3 - Proposal',CloseDate= vCloseDate.adddays(3),CurrencyIsoCode='USD',expected_product__c=0,expected_service__c=20,forecast_status__c='Commit',Non_Standard_Terms_and_Conditions__c='None', recordtypeid='0123000000003ykAAA' );
        Opportunity newOpportunity3 = new Opportunity(dealid__c='A113',name='Test113',StageName='3 - Proposal',CloseDate= vCloseDate.adddays(3),CurrencyIsoCode='USD',expected_product__c=0,expected_service__c=0,forecast_status__c='Commit',Non_Standard_Terms_and_Conditions__c='None' , recordtypeid='0123000000003ykAAA');
    
        Opportunity[] opptyArray = new Opportunity[]{newOpportunity1,newOpportunity2,newOpportunity3};
        insert opptyArray;
        user[] user1=[select id from user where isactive=true limit 1];
    //    user rn=new user(id=user1.id);
        Resource_Request_Assignment__c r1=new Resource_Request_Assignment__c(Opportunity_Name__c=newOpportunity1.Id,Resource_Name__c =user1[0].id,Assignment_Type__c='Partner Secondary',Resource_Status__c = 'Direct Assignment' );
        Resource_Request_Assignment__c r2=new Resource_Request_Assignment__c(Opportunity_Name__c=newOpportunity2.Id,Resource_Name__c =user1[0].id,Assignment_Type__c='Secondary',Resource_Status__c = 'Direct Assignment' );
        Resource_Request_Assignment__c[] rarray=new Resource_Request_Assignment__c[]{r1,r2};
        
        test.startTest();
        insert rarray;
        test.stopTest();
 
    }
     
    }