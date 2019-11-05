@istest
private class testmethod4trig
{
private static testMethod void test()
{
DATE vCloseDate=system.today();
Pricebookentry[] AS_P=[SELECT product2.id FROM Pricebookentry WHERE IsActive=true AND PRODUCTCODE='Service' AND product2.service_type__c='AS' limit 1];
Pricebookentry[] servASPb = [select Id,CurrencyIsoCode from Pricebookentry where IsActive=true AND PRODUCTCODE='Service'  and CurrencyIsoCode='USD' AND product2id=:AS_P[0].product2id limit 3];
Opportunity newOpportunity1 = new Opportunity(dealid__c='A111',name='Test111',StageName='2 - Qualification',CloseDate= vCloseDate.adddays(2),CurrencyIsoCode='USD',expected_product__c=0,expected_service__c=10,forecast_status__c='Commit',Non_Standard_Terms_and_Conditions__c='None', recordtypeid='0123000000003ykAAA');
insert newOpportunity1;
account newaccount=new account(name='abc');
insert newaccount;
Quote__c testquote = new Quote__c(name='test',Opportunity_Name__c=newOpportunity1.id,PartnerAcctId__c=newaccount.id);
insert testquote;

} 
private static testMethod void test1()
{
DATE vCloseDate=system.today();
account newacc=new account(name='abc');
insert newacc;
Opportunity newOppty = new Opportunity(dealid__c='A111',name='Test111',StageName='2 - Qualification',CloseDate= vCloseDate.adddays(2),CurrencyIsoCode='USD',expected_product__c=0,expected_service__c=10,forecast_status__c='Commit',Non_Standard_Terms_and_Conditions__c='None', recordtypeid='0123000000003ykAAA');
insert newOppty;
Partner_Contact__c pc= new Partner_Contact__c(name='pcname',Partner_Name__c=newacc.id);
insert pc;
Partner_Contact_Oppty_Mapping__c pcom= new Partner_Contact_Oppty_Mapping__c(Partner_Contact__c=pc.id,Opportunity__c=newOppty.id);
insert pcom;
Partner_Contact__c pcu= new Partner_Contact__c(name='pcname1',id=pc.id);
update pcu;
 ID[] updatedContacts = new ID[]{};
updatedContacts.add(pc.id);
PartnerContactFutureClass.updateContactMapping(updatedContacts);
}

}