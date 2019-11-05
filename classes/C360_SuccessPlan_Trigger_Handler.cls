/************************************************************************************************************************************
Name    : C360_SuccessPlan_Trigger_Handler
Author  : C360 Dev team
Purpose : Handler class for success plan object trigger by implementing handler interface
Date	: 28/06/2019
Change History : None
*************************************************************************************************************************************/
//Class to handle the trigger on Success plan for duplicate Name and Active field 
public class C360_SuccessPlan_Trigger_Handler implements C360_Trigger_Handler {
    public static list<Success_Plan__c> LstNewSuccessPlan = new list<Success_Plan__c>();
    public static map<string, Success_Plan__c> mapActiveWithSP = new map<string, Success_Plan__c>();
    public static map<string, Success_Plan__c> mapCustomerWithSP = new map<string, Success_Plan__c>();
    public static map<string, Success_Plan__c> mapCustomerNameWithSP = new map<string, Success_Plan__c>();
    public static map<string, Success_Plan__c> mapBUNameWithSP = new map<string, Success_Plan__c>();
    public static map<string, Success_Plan__c> mapBUWithSP = new map<string, Success_Plan__c>();
    public static map<string, Success_Plan__c> mapNameWithSP = new map<string, Success_Plan__c>();
    public static Map<id, Success_Plan__c> mapOldSuccessPlan = new Map<id, Success_Plan__c>();
    
    public static void preProcess(){
        set<String> setCustomer = new set<String>();
        set<String> setBU = new set<String>();
        set<string> setSPActive = new set<string>();
        set<string> setName = new set<string>();
        mapOldSuccessPlan = (map<id, Success_Plan__c>)trigger.oldMap;
        LstNewSuccessPlan = (list<Success_Plan__c>)trigger.new;
        for(Success_Plan__c SPlanObj : LstNewSuccessPlan){
            if(SPlanObj.Name != null){
                setName.add(SPlanObj.Name);
            }
            if(SPlanObj.Customer_Name__c != null && SPlanObj.Customer_BU_Name__c == null){
                setCustomer.add(SPlanObj.Customer_Name__c);
            }
            if(SPlanObj.Customer_BU_Name__c != null){
                setBU.add(SPlanObj.Customer_BU_Name__c);
            }
            if(SPlanObj.Active__c != null){
                setSPActive.add(SPlanObj.Active__c);
            }}
        
        List <Success_Plan__c> listSP = [select id,Name,Customer_Name__c,Customer_BU_Name__c, Active__c from Success_Plan__c where Customer_Name__c in :setCustomer or Customer_BU_Name__c in :setBU];
        for(Success_Plan__c SPlanObj : listSP){
            String value = 'No';
            if(string.isNotEmpty(SPlanObj.Name.toLowerCase())){
                mapNameWithSP.put((SPlanObj.Name.toLowerCase()), SPlanObj);
            }
            if((string.isNotEmpty(SPlanObj.Customer_Name__c) && (string.isEmpty(SPlanObj.Customer_BU_Name__c)))){
                mapCustomerNameWithSP.put(SPlanObj.Customer_Name__c, SPlanObj);
            }
            if(string.isNotEmpty(SPlanObj.Customer_BU_Name__c)){
                mapBUNameWithSP.put(SPlanObj.Customer_BU_Name__c, SPlanObj);
            }
            if(string.isNotEmpty(SPlanObj.Customer_Name__c) && string.isNotEmpty(SPlanObj.Active__c) && string.isEmpty(SPlanObj.Customer_BU_Name__c) && SPlanObj.Active__c != value){
                mapCustomerWithSP.put(SPlanObj.Customer_Name__c, SPlanObj);
                mapActiveWithSP.put(SPlanObj.Active__c, SPlanObj);
            }
            if(string.isNotEmpty(SPlanObj.Customer_BU_Name__c) && string.isNotEmpty(SPlanObj.Active__c)  && SPlanObj.Active__c != value){
                mapBUWithSP.put(SPlanObj.Customer_BU_Name__c, SPlanObj);
                mapActiveWithSP.put(SPlanObj.Active__c, SPlanObj);
            }}
    }
    public static void processBeforeInsert(){
        for(Success_Plan__c SPlanObj : LstNewSuccessPlan){
            if(mapCustomerWithSP.containsKey(SPlanObj.Customer_Name__c) && mapBUWithSP.isEmpty() && mapActiveWithSP.containsKey(SPlanObj.Active__c)){
                SPlanObj.Active__c.addError(System.Label.C360_SP_Customer_Active_Error);
            }
            if  (mapCustomerWithSP.containsKey(SPlanObj.Customer_Name__c) && mapActiveWithSP.containsKey(SPlanObj.Active__c)){
                SPlanObj.Active__c.addError(System.Label.C360_SP_Customer_Active_Error);
            }  
            if(mapBUWithSP.containsKey(SPlanObj.Customer_BU_Name__c) && mapActiveWithSP.containsKey(SPlanObj.Active__c)){
                SPlanObj.Active__c.addError(System.Label.C360_SP_BU_Active_Error);
            }
            
            if(mapCustomerNameWithSP.containsKey(SPlanObj.Customer_Name__c) && mapNameWithSP.containsKey(SPlanObj.Name.toLowerCase())){
                SPlanObj.Name.addError(System.Label.C360_PreventDupeSPlan);
            }
            if(mapBUNameWithSP.containsKey(SPlanObj.Customer_BU_Name__c) && mapNameWithSP.containsKey(SPlanObj.Name.toLowerCase())){
                SPlanObj.Name.addError(System.Label.C360_PreventDupeSPlan);
            }
        }
    }
    public static void processBeforeUpdate(){
        for(Success_Plan__c SPlanObj : LstNewSuccessPlan){
            if(mapOldSuccessPlan.get(SPlanObj.Id).Active__c != SPlanObj.Active__c)  
            { 
                if(mapCustomerWithSP.containsKey(SPlanObj.Customer_Name__c) && mapBUWithSP.isEmpty() && mapActiveWithSP.containsKey(SPlanObj.Active__c)){
                    SPlanObj.Active__c.addError(System.Label.C360_SP_Customer_Active_Error);
                }
                if  (mapCustomerWithSP.containsKey(SPlanObj.Customer_Name__c) && mapActiveWithSP.containsKey(SPlanObj.Active__c)){
                    SPlanObj.Active__c.addError(System.Label.C360_SP_Customer_Active_Error);
                }  
                if(mapBUWithSP.containsKey(SPlanObj.Customer_BU_Name__c) && mapActiveWithSP.containsKey(SPlanObj.Active__c)){
                    SPlanObj.Active__c.addError(System.Label.C360_SP_BU_Active_Error);
                }
            }           
            if(mapOldSuccessPlan.get(SPlanObj.Id).Name != SPlanObj.Name){
                if(mapCustomerNameWithSP.containsKey(SPlanObj.Customer_Name__c) && mapNameWithSP.containsKey(SPlanObj.Name.toLowerCase())){
                    SPlanObj.Name.addError(System.Label.C360_PreventDupeSPlan);
                }
                if(mapBUNameWithSP.containsKey(SPlanObj.Customer_BU_Name__c) && mapNameWithSP.containsKey(SPlanObj.Name.toLowerCase())){
                    SPlanObj.Name.addError(System.Label.C360_PreventDupeSPlan);
                }
            }
        }
    }
    public static void processBeforeDelete(){
        
    }
    public static void processAfterInsert(){
        
    }
    public static void processAfterUpdate(){
    }
    public static void processAfterDelete(){
        
    }
    
    public static void processAfterUnDelete(){
        
    } 
    public static void postProcess(){
        
    }
    
}