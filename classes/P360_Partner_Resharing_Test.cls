@isTest
public class P360_Partner_Resharing_Test {
public static void loadCustData(){
    ObjectRecordTypeIds__c o = new ObjectRecordTypeIds__c();
    o.Manual_Lead_RecordTypeId__c = '0123000000004aS';
    o.eLeadsRecordTypeId__c = '0123000000004aR';
    o.Partner_Generated_Lead_RecordTypeId__c = '012300000000lFW';
    o.AccountChannelRecordTypeId__c = '0123000000004aV';
    insert o; 
    List<Org_Constant_CS__c> lstpOrg = new List<Org_Constant_CS__c>();
    Org_Constant_CS__c org = new Org_Constant_CS__c();
    org.name='P360 Marketing Play Name';
    org.Production_Value__c='Customer Intelligence';
    org.Non_Production_Value__c='Customer Intelligence';
    lstpOrg.add(org);
    Org_Constant_CS__c org1 = new Org_Constant_CS__c();
    org1.name='P360 Target Architecture';
    org1.Production_Value__c='Any/All Technologies';
    org1.Non_Production_Value__c='Any/All Technologies';
    lstpOrg.add(org1); 
    Org_Constant_CS__c org2 = new Org_Constant_CS__c();
    org2.name='P360 Target Prospects Source';
    org2.Production_Value__c='Cisco';
    org2.Non_Production_Value__c='Cisco';
    lstpOrg.add(org2);
    Org_Constant_CS__c org3 = new Org_Constant_CS__c();
    org3.name='P360_UnknownTxM_UserId';
    org3.Production_Value__c='005800000047uXWAAY';
    org3.Non_Production_Value__c='005800000047uXWAAY';
    lstpOrg.add(org3); 
    insert lstpOrg;
     
}

public static testMethod void testEndUserAccountOwnerChange()
{
    loadCustData();
    lead l = GenericStaticTestData.gettesteLeadRecord();
    Assigned_Partner__c TP = GenericStaticTestData.gettestTargetProspectRecord(); 
    Account a = GenericStaticTestData.gettestEndUserAccountRecordRed();
    
    test.starttest();
    if(l.channel_partner__c != null || l.end_customer_account__c != a.id)
    {       
        l.channel_partner__c = GenericStaticTestData.gettestChannelAccountRecord1().id;
        l.end_customer_account__c = a.id;
        update l;
    }
    
    if(TP.customer_account__c != a.id || !TP.ASSIGNMENT_ACTIVATED__C)
    {
        TP.ASSIGNMENT_ACTIVATED__C = true;
        TP.customer_account__c = a.id;
    }
    update TP;   
    

    //if(a.ownerid != GenericStaticTestData.gettestPAUserRecord().id)
    //a.ownerid = GenericStaticTestData.gettestPAUserRecord().id;
    //else
   // a.ownerid =userinfo.getuserid();
    //update a;
    Set<Id> aIds = new Set<Id>();
    aIds.add(a.id);
    P360_Partner_Resharing.Partner_Resharing_On_OwnerChange(aIds );
    test.stoptest();

}

}