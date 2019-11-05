public class TSNFetchCECIdSearchResult{

    Public @future(callout=true) static void doCECIdSearch(Set<Id> CaseId){
        System.debug('hi 2>>>' + CaseId);
        List<Case> TSNCases = [select Id,Web_CCO_ID__c,
                                  CCO_ID_Search_Result_Rich__c,CCO_Search_Result_Updated__c,
                                  Cisco_Contact_Name__c,Cisco_Contact_Title__c,
                                  Cisco_Contact_Organization__c,Cisco_Contact_Work_Phone_Number__c,
                                  Cisco_Contact_Internal_Phone_Number__c,Cisco_Contact_Mobile_Number__c,
                                  Cisco_Country__c,Web_Service_Error_Message__c  
                               from case where Id IN :CaseId]; 
                               
                               
        for(Case c : TSNCases){           
            Case caseval = TSNUserUnifiedDetailsWebService.getCecVal(c.Web_CCO_ID__c);  // make a call to getCecVal Function in TSNUserUnifiedDetailsWebService class        
            system.debug('caseval>>>'+ caseval);
        
            // TSN June Release will not allow web cases to be updated with CEC Id Search, if webservice is down
             
            if(caseval!=null){
                c.Cisco_Contact_Name__c  = caseval.Cisco_Contact_Name__c;
                c.Cisco_Contact_Title__c = caseval.Cisco_Contact_Title__c;
                c.Cisco_Contact_Organization__c = caseval.Cisco_Contact_Organization__c;
                c.Cisco_Contact_Work_Phone_Number__c = caseval.Cisco_Contact_Work_Phone_Number__c;
                c.Cisco_Contact_Internal_Phone_Number__c = caseval.Cisco_Contact_Internal_Phone_Number__c;
                c.Cisco_Contact_Mobile_Number__c = caseval.Cisco_Contact_Mobile_Number__c;
                c.Cisco_Country__c = caseval.Cisco_Country__c;
                c.CCO_ID_Search_Result_Rich__c = caseval.Web_Service_Error_Message__c;
                c.CCO_Search_Result_Updated__c = true;
              }
        }
        
        Utilities.setskipFuture(true); 
        Utilities.setValidationSkip(true);
        
        if(TSNCases.size()>0){   
        try{
             update TSNCases;
           }
         catch(Exception e){}
        }
    }       
}