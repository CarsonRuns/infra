/**************************************
Author          : Debesh 
Release         : Mar Release version 1
Created         : Feb 07,2019
Functionality   : test class for lxOpportunityUpdateForPB

Modification History:
Itrack#        Date        		Author              		Change  
****************************************************************************

**********************************************/
@isTest
public class lxOpportunityUpdateForPBTest {
    
    @isTest
    static void testOppForTrueServiceMultiYear()
    {
        Utilities.setIsTestMethod(true);
        Utilities.setValidationSkip(true);
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Cisco_ADMIN' Limit 1];
        User usr = lxTestDataFactory.createSingleUser(p.Id);
        system.runAs(usr){
            lxTestDataFactory.createCustomSettings();
            
            
            Account a = lxTestDataFactory.createChannelAccount(usr.Id);
            insert a;
            Pricebook2 pb2 = lxTestDataFactory.createPriceBook2();
            insert pb2;
            Opportunity optyListTrue = lxTestDataFactory.createSingleOpportunity(a.id, pb2.id, usr.Id);
            insert optyListTrue;
            optyListTrue.Services_All_Multiyear__c=true;
            update optyListTrue;
            Product2 pr2 = lxTestDataFactory.createSingleProduct();
            insert pr2;
            PricebookEntry pbe = lxTestDataFactory.createSinglePricebookEntry(pb2.id,pr2.Id);
            insert pbe;
            OpportunityLineItem oli = lxTestDataFactory.createSingleOpportunityLineItem(pr2.id,optyListTrue.id,pbe.id);
            insert oli;
            
            Account a1 = lxTestDataFactory.createChannelAccount(usr.Id);
            insert a1;
            Pricebook2 pb21 = lxTestDataFactory.createPriceBook2();
            insert pb21;
            Opportunity optyListFalse = lxTestDataFactory.createSingleOpportunity(a1.id, pb21.id, usr.Id);
            insert optyListFalse;
            optyListFalse.Services_All_Multiyear__c=false;
            update optyListFalse;
            Product2 pr21 = lxTestDataFactory.createSingleProduct();
            insert pr21;
            PricebookEntry pbe1 = lxTestDataFactory.createSinglePricebookEntry(pb21.id,pr21.Id);
            insert pbe1;
            OpportunityLineItem oli1 = lxTestDataFactory.createSingleOpportunityLineItem(pr21.id,optyListFalse.id,pbe1.id);
            insert oli1;            
            
            List<Opportunity> optyListTruelst = new List<Opportunity>();
            optyListTruelst.add(optyListTrue);
            List<Opportunity> optyListFalselst = new List<Opportunity>();
            optyListFalselst.add(optyListFalse);
            Map<Id,Opportunity> oldOppMap = new Map<Id,Opportunity>();
            Map<Id,Opportunity> oldOppMap2 = new Map<Id,Opportunity>();
            for(Opportunity opp:optyListFalselst)
            {
                for(Opportunity opp1:optyListTruelst)
                {
                    oldOppMap.put(opp1.Id,opp);
                    oldOppMap2.put(opp.Id,opp1);
                }
                
            }
            Test.startTest();
            lxOpportunityUpdateForPB.updateRecords(optyListTruelst,oldOppMap);
            lxOpportunityUpdateForPB.updateRecords(optyListFalselst,oldOppMap2);
            Test.stopTest();
        }
    } 
}