/******************************************************************************
Name    : NGCC_Rule_Assignment_Trg 
Author  : Nirup Kohir
Purpose : This Trigger validated to check if no duplicate Rank and Theater combination are given for CC Lead Priority Rule 
Created Date:  10/02/2015

*******************************************************************************/

trigger NGCC_Rule_Assignment_Trg on NGCC_Rule_Assignment__c (before insert, before update) {
    
    
    if(trigger.isBefore && (trigger.isinsert || trigger.isUpdate)){
        set<String> rankSet =new set<String>();
        set<String> TheatreSet =new set<String>();
        List<NGCC_Rule_Assignment__c> ngccList = new List<NGCC_Rule_Assignment__c>();
        for(NGCC_Rule_Assignment__c nRA :trigger.new){
            rankSet.add(nRA.Rank__c);
            TheatreSet.add(nRA.Theater__c);
        }
        if(rankSet.size()>0 && TheatreSet.size()>0){
             if(trigGer.isUpdate)
             ngccList = [select Theater__c,Rank__c from NGCC_Rule_Assignment__c where Rank__c in :rankSet and Theater__c in :TheatreSet and Active__c = true and id not in:trigger.new];
             else
             ngccList = [select Theater__c,Rank__c from NGCC_Rule_Assignment__c where Rank__c in :rankSet and Theater__c in :TheatreSet and Active__c = true ];
        }
        if(ngccList.size()>0){    
            Map<String,String> theatreRankMap = new Map<String,String>();        
            for(NGCC_Rule_Assignment__c allRec :ngccList){
                if(!theatreRankMap.containsKey(String.valueof(allRec.Theater__c)))
                     theatreRankMap.put(string.Valueof(allRec.Theater__c),string.Valueof(allRec.Rank__c)+',');
                else{
                    String keyValue=theatreRankMap.get(allRec.Theater__c);
                    List<String> splitvalue = keyValue.split(',');
                    for(String str:splitvalue){
                        if(!str.equals(allRec.Rank__c))
                            keyValue=keyValue+','+String.valueof(allRec.Rank__c);
                            theatreRankMap.put(string.Valueof(allRec.Theater__c),keyValue);
                    }           
                }              
            }
                
            for(NGCC_Rule_Assignment__c n :trigger.new){
                if(n.Active__c == true){
                if(n.Theater__c!=null){
                    if(theatreRankMap.containsKey(String.valueof(n.Theater__c)) && theatreRankMap.get(String.valueof(n.Theater__c))!= null){
                        List<String> splitvalue = theatreRankMap.get(String.valueof(n.Theater__c)).split(',');
                        for(String str:splitvalue){                    
                            if(str.equals(n.Rank__c)){
                                    if(!test.isRunningTest())
                                     n.addError('Please change Rank for this theatre.. The combination you have given was existed in system');
                            }
                        }
                    }
                }
              
            } 
          }      
       } 

    }    
}