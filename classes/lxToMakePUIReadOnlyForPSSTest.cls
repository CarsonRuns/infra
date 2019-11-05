/**************************************
Author          : Kavya 
Release         : Mar Release version 1
Created         : Feb 21,2019
Functionality   : PSS - Edit Oppty fields except $, Book Date and Stage, Technology/Service line items

Modification History:
Itrack#        Date             Author                      Change  
****************************************************************************
US250307     Feb 21 ,2019  Kavya                            Initial draft
**********************************************/
@isTest(SeeAllData=true)
public class lxToMakePUIReadOnlyForPSSTest {
    @isTest(SeeAllData=true)
    static void testMethod1()
    {
        Opportunity oppty = [SELECT id FROM Opportunity LIMIT 1];
        ApexPages.currentPage().getParameters().put('id', oppty.id);         
        ApexPages.StandardController sc = new ApexPages.StandardController(oppty);
        lxToMakePUIReadOnlyForPSS testPssTechService= new lxToMakePUIReadOnlyForPSS(sc); 
    }
    @isTest(SeeAllData=true)
    static void testMethod2()
    {
        OpportunityLineItem opptyli = [SELECT OpportunityId FROM OpportunityLineItem LIMIT 1];
        ApexPages.currentPage().getParameters().put('id', opptyli.id);         
        ApexPages.StandardController sc2 = new ApexPages.StandardController(opptyli);
        lxToMakePUIReadOnlyForPSS testPssTechService2= new lxToMakePUIReadOnlyForPSS(sc2);
    }
}