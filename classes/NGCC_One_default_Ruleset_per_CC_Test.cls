@istest
public class NGCC_One_default_Ruleset_per_CC_Test 
{
    public static testmethod void testmeth()
    {
        // create a record in CC_Assignment_Ruleset__c with the field isDefault__c == true ,Contact_Center__r.name,Contact_Center__c 
    //CC_Assignment_Ruleset__c c1 = new CC_Assignment_Ruleset__c();
    //c1 =[select id,Contact_Center__c from CC_Assignment_Ruleset__c where Contact_Center__c!=NULL ];
    CC_Call_Center_Country_Assignment__c c= new CC_Call_Center_Country_Assignment__c();
    c.name = 'Concentrix-Latam';
    c.Country__c = 'UNITED STATES';
    insert c;
    
    //call center 2 insert
    CC_Call_Center_Country_Assignment__c c1= new CC_Call_Center_Country_Assignment__c();
    c.name = 'Concentrix-Latamsf';
    c.Country__c = 'UNITED STATES';
    insert c1;
   
    CC_Assignment_Ruleset__c cc = new CC_Assignment_Ruleset__c ();
    cc.name ='Concentrix-Latam';
    cc.Contact_Center__c = c.Id;
    cc.isDefault__c  = true;
    
    insert cc;
    cc.isDefault__c  = true;
    update cc;
    
    CC_Assignment_Ruleset__c cc1 = new CC_Assignment_Ruleset__c ();
    cc1.name ='Concentrix-Latam';
    cc1.Contact_Center__c = c.Id;
    cc1.isDefault__c  = false;
    
    insert cc1;
    cc1.isDefault__c  = false;
    update cc1;
        
    }
}