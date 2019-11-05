//Unit test Class for RnewalsATRBEData controller
@isTest
private class RenewalsATRBEDataTest {
    
    	static testMethod void testGetAtrDonutChartData() {
            RenewalsATEBEData obj=new RenewalsATEBEData();
            list<Id>accountIds=new list<Id>();
          	accountIds.add('0013400001Vz64lAAB');
            accountIds.add('00180000016nwUjAAI');
            list<string>businessEntityList=new list<string>();
            businessEntityList.add('Mobility');
            businessEntityList.add('Data Center Networking');
            businessEntityList.add('Collaboration');
            businessEntityList.add('Computing Systems');
            businessEntityList.add('AS-S');
            businessEntityList.add('TS-S');
            String dateValue='This Fiscal Year';
            ObjectRecordTypeIds__c ob=new ObjectRecordTypeIds__c();
            ob.Opportunity_Renewal_RecordTypeId__c='01234000000Boc4 ';
            insert ob;
        	Renewals_Portfolio__c renewalPortfolio = new Renewals_Portfolio__c();
            renewalPortfolio.products__c = 'product1';
            renewalPortfolio.services__c = 'service1';
            renewalPortfolio.Default_Timeline__c = 'default';
            renewalPortfolio.Stages__c = 'stage1';
            renewalPortfolio.Timelines__c = 'timeline';
            insert renewalPortfolio;
            AggregateResult[] queryResult =RenewalsATEBEData.getAtrDonutChartData(accountIds,dateValue,businessEntityList,true);
            AggregateResult[] barQueryResult =RenewalsATEBEData.getAtrByBeGroupings(accountIds,dateValue,true);
            Map<String,Object> funnelQueryResult =RenewalsATEBEData.getAtrFunnelChartData(accountIds,dateValue,businessEntityList,true);
            System.assertEquals(0,queryResult.size());
            System.assertEquals(0,barQueryResult.size());
            System.assertEquals(2,funnelQueryResult.size());
        }

}