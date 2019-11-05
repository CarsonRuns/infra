/***************************************************************************************************
Name    : NGCC_fetch_Picklist_Options_Controller
Author  : Ghattamaneni Chaithanya
Purpose : This class is controller for NGCC_Custom_Picklist Component, it is responsible for get the picklist values 
Date	: 19-Feb-2019

Modification History: 

*****************************************************************************************************/

public class NGCC_fetch_Picklist_Options_Controller{
    @AuraEnabled
    public static Map<String, String> getselectOptions(string objName, string fld) {
		sObject obj = Schema.getGlobalDescribe().get(objName).newSObject();
        Map<String, String> options = new Map<String, String>();
        Schema.sObjectType objType = obj.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        list < Schema.PicklistEntry > pList = fieldMap.get(fld).getDescribe().getPickListValues();
        for (Schema.PicklistEntry p: pList) {
            //Put Picklist Value & Label in Map
            options.put(p.getValue(), p.getLabel());
        }
        return options;
    }
}