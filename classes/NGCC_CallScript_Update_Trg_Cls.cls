/*********************************************************************************************************************************
Name    : NGCC_CallScript_Update_Trg_Cls
Author  : Mukesh Srivastava
Purpose : When the Call Script is activated then process all the Call Script Q&A and identify all unique Category for the Call Script
Created Date:  3/27/2014 
Modification History: 
                      
**********************************************************************************************************************************/
public class NGCC_CallScript_Update_Trg_Cls{
    
    /* @method: Get the list of call script which are getting activated or previewed so that Categories can be identified */
    public static void NGCC_CallScript_Update(List<CC_Call_Script__c > newLstCallScript)
    {
        Set<id> setOfCallScripts = new set<Id>();
        List<CC_Call_Script__c > cSLst= new List<CC_Call_Script__c >();
        for(CC_Call_Script__c cc : newLstCallScript)
        {
            if(cc.Status__c == 'Active' || cc.Status__c =='Previewed')
            {
                if(cc.Total_Questions__c == cc.Number_of_Question_Category__c && cc.Total_Questions__c == cc.Number_of_Question_Type__c){
                    setOfCallScripts.add(cc.Id);
                    cSLst.add(cc);
                }
            }
        }
        
        if(!cSLst.isEmpty())
        {
            NGCC_CallScript_getCategories(cSLst,setOfCallScripts);
        }    
    }
    
    /* @method: Get the aggreation for Call Script Q&A and concatenate the unique Category */
    public static void NGCC_CallScript_getCategories(List<CC_Call_Script__c > callScriptLst,Set<Id> setOfCallScript)
    {
        string queryQA = 'Select Call_script__c,Question_Category__c,count(Id) from CC_Call_Script_Q_A__c where Call_script__c IN: setOfCallScript group by Call_script__c,Question_Category__c Order by Question_Category__c';
            AggregateResult[] groupedResults = Database.query(queryQA );
            
            map<Id,String> mapCScript = new map<Id,String>();
            
            for (AggregateResult ar: groupedResults) {
                    string category=String.valueOf(ar.get('Question_Category__c'));
                    category = category.subString(category.indexOf(':')+1,category.length());
                if(mapCScript.containsKey(String.valueOf(ar.get('Call_Script__c'))))
                {        
                    String strCategory = mapCScript.get(String.valueOf(ar.get('Call_Script__c')))+ ','+category;
                    mapCScript.put(String.valueOf(ar.get('Call_Script__c')),strCategory);
                }else
                {                   
                    mapCScript.put(String.valueOf(ar.get('Call_Script__c')),category );
                }
            }
            
            for(CC_Call_Script__c cc: callScriptLst)
            {
                if(mapCScript.containsKey(cc.Id))
                {
                    cc.Question_Categories__c = mapCScript.get(cc.Id) ;
                }
            }
    }
}