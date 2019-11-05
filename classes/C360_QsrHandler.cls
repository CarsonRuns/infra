/************************************************************************************************************************************
Name    : C360_QsrHandler
Author  : C360 Dev team
Purpose : Contains logic for handling the trigger C360_PreventSameFYFQonSuccessPlan on Success Plan object.
Date    : 28/06/2019
Change History : none
*************************************************************************************************************************************/
public class C360_QsrHandler {
	
    set<string> setSP = new set<string>();
    set<string> setFYFQ = new set<string>();
    list<QSR__c> lstQSR = new list<QSR__c>();
    map<string, QSR__c> mapSPWithQSR = new map<string, QSR__c>();
    map<string, QSR__c> mapFYWithQSR = new map<string, QSR__c>();

	//Method to Prevent SameFYFQ onSuccessPlan
    public void DuplicateChecker(List<QSR__c> lstNewQSR){
        for(QSR__c oQSR : lstNewQSR){
            if(oQSR.Success_Plan__c != null){
             setSP.add(oQSR.Success_Plan__c);
            }
            if(oQSR.Cisco_FY_FQ__c != null){
             setFYFQ.add(oQSR.Cisco_FY_FQ__c);
            }
        }
        lstQSR = [select id, Success_Plan__c, Cisco_FY_FQ__c from QSR__c where Success_Plan__c in :setSP and Cisco_FY_FQ__c in :setFYFQ ];
        for(QSR__c oQSR : lstQSR){
            if(string.isNotEmpty(oQSR.Success_Plan__c)){
                mapSPWithQSR.put(oQSR.Success_Plan__c, oQSR);
            }
            if(string.isNotEmpty(oQSR.Cisco_FY_FQ__c)){
                mapFYWithQSR.put(oQSR.Cisco_FY_FQ__c, oQSR);
            }
        }

        for(QSR__c oQSR : lstNewQSR){
            if(mapSPWithQSR.containsKey(oQSR.Success_Plan__c) && mapFYWithQSR.containsKey(oQSR.Cisco_FY_FQ__c)){
                oQSR.Cisco_FY_FQ__c.addError(System.Label.C360_QSR_FY_FQ_Error);
            }
        }

 
    }
    
}