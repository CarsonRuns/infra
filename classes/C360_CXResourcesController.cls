/************************************************************************************************************************************
Name    : C360_CXResourcesController
Author  : C360 Dev team
Purpose : Logic to display CX Resources in the components 1. C360_CXResources.cmp 2. C360_CXResourcesViewAll.cmp
Date    : 28/06/2019
Change History : none
*************************************************************************************************************************************/
public class C360_CXResourcesController {
    //Initial data Load into Parent Component - C360_CXResources.cmp
    @AuraEnabled 
    public static List<C360_CXResources__mdt> getCXResourcesIL(){
        return [select MasterLabel, CX_Resource_URL__c from C360_CXResources__mdt ORDER BY MasterLabel limit 10];
    }
    //Get total Count of CX Resources
    @AuraEnabled
    public static Integer CountCXResources(){
        List<C360_CXResources__mdt> lstForCount = [select MasterLabel, CX_Resource_URL__c from C360_CXResources__mdt ];
        return lstForCount.size();
    }
    //Lazy load of CX Resources
    @AuraEnabled 
    public static List<C360_CXResources__mdt> getCXResources(Integer Limits){
        return [select MasterLabel, CX_Resource_URL__c from C360_CXResources__mdt ORDER BY MasterLabel Limit:Limits ];
    }
}