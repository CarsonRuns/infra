/************************************************************************************************************************************
Name    : C360_ATX
Author  : C360 Dev team
Purpose : Contains logic to execute on fetching ATX records on ATX Component
Date    : 28/06/2019
Change History : none
*************************************************************************************************************************************/
public class C360_ATX {
    @AuraEnabled
    public static List<ATX__c> fetchParentATX(){
        List<ATX__c> atxList = [select Session_Name__c,Region__c,Date__c from ATX__c limit 10];
        return atxList;
    }
    @AuraEnabled
    public Static List<ATX__c> fetchChildATX(Integer Limits){ 
        List<ATX__c> atxList = [select Session_Name__c,Region__c,Date__c,Time__c,Session_Description__c from ATX__c limit : Limits];
        System.debug('atxListChild'+atxList);
        return atxList;
    }
     @AuraEnabled
    public static Integer TotalATX(){
       AggregateResult results = Database.query('SELECT Count(Id) TotalATX'+' FROM ATX__c ');
        Integer totalATX = (Integer)results.get('TotalATX');
        System.debug('totalATX'+totalATX);
        return totalATX;
    } 
}