@isTest
public class NGCC_dependentPicklistController_Test {
@isTest
    public static void getDependentMapTest(){
        string objName = 'CC_Response__c';
        string controllingfieldName = 'Status__c';
        string dependentfieldName = 'Disposition_Sub_Type__c';
        NGCC_dependentPicklistController.getObjType('CC_Response__c');
        Map<String, List<String>> optionsMap = NGCC_dependentPicklistController.getDependentMap(objName,controllingfieldName,dependentfieldName);
        system.assertEquals(true, optionsMap.size()>0);
    }
}