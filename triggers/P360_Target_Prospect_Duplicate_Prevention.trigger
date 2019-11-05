trigger P360_Target_Prospect_Duplicate_Prevention on Assigned_Partner__c (before insert, before update) 
{
    //Initialize variables
    Map<ID, Assigned_Partner__c> TPMap = new Map<ID, Assigned_Partner__c>();
    Map<String, Assigned_Partner__c> TPConcatMap = new Map<String, Assigned_Partner__c>();
    Map<String, Assigned_Partner__c> TPConcatOldMap = new Map<String, Assigned_Partner__c>();    
    Set<String> TPAPSet = new Set<String>();
    Set<String> TPCASet = new Set<String>();
    Set<String> TPMPASet = new Set<String>();
    Set<String> TPTASet = new Set<String>();  
    
    String strNewConcat,strOldConcat;
    
    //Iterate TP records
    for (Assigned_Partner__c tp : System.Trigger.new) 
    {
    
     
     strNewConcat = tp.Assigned_Partner__c +'-'+tp.Customer_Account__c+'-'+tp.Marketing_Play_Name__c+'-'+tp.Target_Architecture__c;
     
     //Check trigger is on update event
     if(System.Trigger.isUpdate)
         strOldConcat = System.Trigger.oldMap.get(tp.Id).Assigned_Partner__c +'-'+System.Trigger.oldMap.get(tp.Id).Customer_Account__c+'-'+System.Trigger.oldMap.get(tp.Id).Marketing_Play_Name__c+'-'+System.Trigger.oldMap.get(tp.Id).Target_Architecture__c;
     
     //Check the fields are not null
      if(tp.Assigned_Partner__c != null && tp.Customer_Account__c != null && tp.Marketing_Play_Name__c != null && tp.Target_Architecture__c != null && strNewConcat != strOldConcat ) 
         {
      
            // Make sure another new Target Prospects isn't also a duplicate 
            if (TPMap.containsKey(tp.Id)) {
                system.debug('Testing  '+tp.Id);         
                tp.Duplicate_Prevention__c.addError('Another new Target Prospects has a Duplicate');
            } else {
                if(tp.Id != null){
                TPMap.put(tp.Id, tp);
                system.debug('strOldConcat  '+'  '+strOldConcat);                
                TPConcatOldMap.put(strOldConcat,tp);
                }
                TPConcatMap.put(strNewConcat,tp);
                TPAPSet.add(tp.Assigned_Partner__c);
                TPCASet.add(tp.Customer_Account__c);
                TPMPASet.add(tp.Marketing_Play_Name__c);
                TPTASet.add(tp.Target_Architecture__c); 
                
                
                
         }
        }
      }
      
    //Fetch list of Assigned Partner filter by Assigned Partner,Customer account,Marketing Play, Target architecture.
    for (Assigned_Partner__c TPro : [SELECT Assigned_Partner__c,Customer_Account__c,Marketing_Play_Name__c,Target_Architecture__c FROM Assigned_Partner__c  WHERE Assigned_Partner__c IN :TPAPSet  and Customer_Account__c IN : TPCASet and Marketing_Play_Name__c IN : TPMPASet and Target_Architecture__c IN : TPTASet])
    {
    
        strNewConcat = TPro.Assigned_Partner__c +'-'+TPro.Customer_Account__c+'-'+TPro.Marketing_Play_Name__c+'-'+TPro.Target_Architecture__c;            
        system.debug('strNewConcat '+strNewConcat );

        Assigned_Partner__c TPAP = new Assigned_Partner__c(); 
              
        //Check the key exist in the list
        if(TPConcatOldMap.containsKey(strNewConcat) || TPConcatMap.containsKey(strNewConcat))
        {        
            if(System.Trigger.isUpdate)
            {//Check for the duplicates
                TPAP = TPConcatOldMap.get(strNewConcat);      
            }
            else{//Check for the duplicates
                TPAP = TPConcatMap.get(strNewConcat);
            }
             system.debug('TPAP  '+TPAP);
             if(TPAP != null)           
                 TPAP.Duplicate_Prevention__c.addError('Target Prospects is already exists.');
                
        }   
    }
}