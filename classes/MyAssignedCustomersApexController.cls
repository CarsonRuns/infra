/************************************************************************************************************************************
Name    : MyAssignedCustomersApexController
Author  : C360 Dev team
Purpose : Contains logic to fetch count of current logged in user customers, business units and accounts in MyAssignedCustomers component
Date    : 02/24/2019
Change History : none
*************************************************************************************************************************************/
public class MyAssignedCustomersApexController {
    //fecth count of Customers, Business unit  based on logged in User
    @AuraEnabled
    public static String MyAssignedCustomers(String loggedInUserId){
        Map<String,String> resultMap = new Map<String,String>();
        Map<String,integer> returnMap = new Map<String,integer>();
        Map<string,List<Account>> accList= new Map<string,List<Account>>();
        
        set<Id> CU =new set<Id>();
        List<Account> aclist = new List<Account>();
        //query to fetch Customer, BU's records 
     
        List<Account> custList = new List<Account>([select id from Account where Assigned_CSE__c =: loggedInUserId and RecordType.Name IN ('Customer') ]);
        List<Account> buList = new List<Account>([select id from Account where Assigned_CSE__c =: loggedInUserId and RecordType.Name IN ('Business Unit') ]);
      
             
        returnMap.put('Customers',custList.size());
        returnMap.put('Customer Business Units',buList.size());
        resultMap.put('data',JSON.serialize(returnMap));
        String listMap = MyAssignedCustomersApexController.getCustomSettingRecord(); 
       	resultMap.put('listView',listMap);
        return JSON.serialize(resultMap);
    }
    
    public static string getCustomSettingRecord(){
        C360ListViewIds__c  custVal = C360ListViewIds__c.getInstance('MyAssignCustomersListViews');  
       	Map<String,String> mapCustListViews = new Map<String,String>();
        mapCustListViews.put('Customers',custVal.Customers__c);
        mapCustListViews.put('Customer Business Units',custVal.Customer_Business_Units__c);
        mapCustListViews.put('ViewAll',custVal.AllCustomers__c);
        
        return JSON.serialize(mapCustListViews);
        
    }
}