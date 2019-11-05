@isTest
public class OpportunityRMNotification_Test {
    static testMethod void sjmethod1(){ 	
        id testidd= Renewals_TestUtility.getOptyrenewals('pss','');    
        OpportunityRMNotification Notify = new OpportunityRMNotification();
        String sc = '0 0 23 * * ?';
        System.schedule('Test Check', sc, Notify );       
    }
}