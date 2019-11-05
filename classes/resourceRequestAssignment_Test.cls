/***************************************************************************************************
Name    : resourceRequestAssignment_Test
Author  : Naresh Kalahasthi
Purpose : Test class for resourceRequestAssignment apex class  
Created Date: Feb 5 2018

*****************************************************************************************************/

@isTest(SeeAllData=TRUE)
public class resourceRequestAssignment_Test{
    
    static testMethod void resourcerequest(){
        
        Opportunity o = new Opportunity(name='Test',StageName='2 - Qualified',CloseDate=System.today() - 50,Expected_Product__c=10.0,error_description__c='error',DealID__c='1',Opportunity_Status__c='Active',recordtypeId=utilities.getOpptyParentRecordTypeId()); 
        insert o;
        Resource_Request_Assignment__c newrr = new Resource_Request_Assignment__c();
        newrr.Opportunity_Name__c = o.id;
        
        insert newrr;
        List<user> additionalUser = [select id from user where Additional_User_Permissions__c = 'SE User' limit 1];
        System.runAs (additionalUser[0]){  
            
            PageReference testPage = new pagereference('/apex/RAEWorkspace');
            
            Test.setCurrentPage(testPage);
            
            ApexPages.StandardController sc = new ApexPages.StandardController(newrr);
            resourceRequestAssignment a = new resourceRequestAssignment(sc);
            
        }
    }
    
}