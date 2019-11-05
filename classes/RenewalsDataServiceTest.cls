@isTest
private class RenewalsDataServiceTest {
    static testMethod void RenewalsDataServiceMethodTest(){
        RenewalsDataService RenewalsDataServiceOb=new RenewalsDataService();
        list<string>products=new list<string>();
       
        products.add('test');
        list<string>Services=new list<string>();
        Services.add('testservice');
        String TimeLine='This Fiscal Month';
        list<string>Account=new list<string>();
        Account.add('testaccount');
        list<string>lstprodserv=new list<string>();
        lstprodserv.add('test');
        ObjectRecordTypeIds__c ob=new ObjectRecordTypeIds__c();
        ob.Opportunity_Renewal_RecordTypeId__c='01234000000Boc4 ';
        insert ob;
        Renewals_Portfolio__c renewalPortfoloi = new Renewals_Portfolio__c();
            renewalPortfoloi.products__c = 'product1';
            renewalPortfoloi.services__c = 'service1';
            renewalPortfoloi.Default_Timeline__c = 'default';
            renewalPortfoloi.Stages__c = 'stage1';
            renewalPortfoloi.Timelines__c = 'timeline';
            insert renewalPortfoloi;
        /*Account a1 = new Account(name='Test Partner Company Account123',RECORDTYPEID='01280000000G6tsAAC',Country__c='UNITED STATES',ownerid ='00530000000fb2q');
        insert a1;
        //SELECT Id, Name, convertCurrency(Expected_Product__c),convertCurrency(Expected_Service__c),convertCurrency(Total_Prior_ATR__c),Account.Name,StageName,CloseDate  FROM Opportunity
    
        Opportunity   oppty = new Opportunity(name='TestQuoteOverview',StageName='1 - Prospect',CloseDate=System.today(),Expected_Product__c=10.0,Expected_Service__c=20.0,Competitors__c = 'A10 Networks',accountId = a1.id); 
        insert oppty;*/
        RenewalsDataService.getUpcomingRenewalsOppty(products,Services,TimeLine,Account,true);
        RenewalsDataService.getLostRenewalsOppty(products,Services,TimeLine,Account,true);
        RenewalsDataService.getTopAttrition(products,Services,TimeLine,Account,true);
        RenewalsDataService.getUpsellCrossSell(products,Services,TimeLine,Account,true);
        RenewalsDataService.getDateWhereClauseOpty(TimeLine,'Opportunity');
        RenewalsDataService.getAccountWhereClauseOpty(Account,'Opportunity');
        RenewalsDataService.getBusinessEntityWhereClause(lstprodserv);
        RenewalsDataService.addProductServiceBE(products,Services);
        RenewalsDataService.getListViews('testlistview');
        RenewalsDataService.getOverDueRenewalsOppty(products,Services,TimeLine,Account,true);    
        
    }
    static testMethod void RenewalsDataServiceTest(){
        RenewalsDataService RenewalsDataServiceOb=new RenewalsDataService();
        list<string>products=new list<string>();
       
       
        list<string>Services=new list<string>();
        
        String TimeLine='This Fiscal Month';
        list<string>Account=new list<string>();
        Account.add('testaccount');
        list<string>lstprodserv=new list<string>();
        lstprodserv.add('test');
        ObjectRecordTypeIds__c ob=new ObjectRecordTypeIds__c();
        ob.Opportunity_Renewal_RecordTypeId__c='01234000000Boc4 ';
        insert ob;
        Renewals_Portfolio__c renewalPortfoloi = new Renewals_Portfolio__c();
            renewalPortfoloi.products__c = 'product1';
            renewalPortfoloi.services__c = 'service1';
            renewalPortfoloi.Default_Timeline__c = 'default';
            renewalPortfoloi.Stages__c = 'stage1';
            renewalPortfoloi.Timelines__c = 'timeline';
            insert renewalPortfoloi;
        RenewalsDataService.getUpcomingRenewalsOppty(products,Services,TimeLine,Account,true);
        RenewalsDataService.getLostRenewalsOppty(products,Services,TimeLine,Account,true);
        RenewalsDataService.getTopAttrition(products,Services,TimeLine,Account,true);
        RenewalsDataService.getUpsellCrossSell(products,Services,TimeLine,Account,true);
        RenewalsDataService.getAccountWhereClauseOpty(Account,'Opportunity');
        RenewalsDataService.getBusinessEntityWhereClause(lstprodserv);
        RenewalsDataService.addProductServiceBE(products,Services);
        
        RenewalsDataService.getOverDueRenewalsOppty(products,Services,TimeLine,Account,true);    
    }   
}