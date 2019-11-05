public with sharing class   TechnologyProfile_TechnologyHelper
{
    
    public static list<Technology_Profile__c> technologyValidation(List<Technology_Profile__c> lsttech)
    {
        
        List<Technology_Profile__c> lstTechprofile = new List<Technology_Profile__c>();
        Set<Id> AccId = new Set<Id>(); 
        
        for( Technology_Profile__c tech:lsttech) {
            AccId.add(tech.FK_Account__c);
        }
        
        List<Technology_Profile__c> lstTechnologyprofile = [select Id,FK_Account__c from Technology_Profile__c where FK_Account__c =: AccId ];
        
        for(Technology_Profile__c ic:lstTechnologyprofile) {
            lstTechprofile.add(ic);
        }
        
        system.debug('here-->1'+lstTechprofile.size());
        return lstTechprofile;
           
    }
    
     
}