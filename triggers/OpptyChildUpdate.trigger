trigger OpptyChildUpdate on Opportunity (after update)
{

    if (OpptyChildUpdate.getProcessOpptyChild())
    {
        try 
        {                    
           OpptyChildUpdate.setProcessOpptyChild(false);
           Opportunity[] childOpptys = new Opportunity[]{};
           Map<ID, Opportunity> OpptyValMap = new Map<ID, Opportunity>();           
            
           for(Integer x=0;x<Trigger.new.size();x++)
           {      
                if(Trigger.new[x].RecordTypeId == Utilities.getOpptyParentRecordTypeId() || 
                    Trigger.new[x].RecordTypeId == Utilities.getOpptyPartnerParentRecordTypeId()){               
                        Opportunity toO = new Opportunity( id =  Trigger.new[x].Id, 
                        OwnerId = Trigger.new[x].OwnerId,
                        Position__c = Trigger.new[x].Position__c,              
                        Territory2Id = Trigger.new[x].Territory2Id,    
                        Contract_Number__c=Trigger.new[x].Contract_Number__c,
                        DD_Status__c = Trigger.new[x].DD_Status__c ,
                        DealID__c = Trigger.new[x].DealID__c ,
                        Theater__c = Trigger.new[x].Theater__c,                        
                        skipValidations__c = true);
                        OpptyValMap.put(Trigger.new[x].Id, toO);
                        System.debug('*** Parent=>' + Trigger.new[x].Name + ':' + Trigger.new[x].Id + ':new ' + Trigger.new[x].OwnerId + ':old ' + Trigger.old[x].OwnerId);
                }
            }
        
            Opportunity[] children = [select Id, Parent_ID__c 
                                         From Opportunity 
                                         WHERE 
                                         RecordTypeId in (:Utilities.getOpptyPhaseRecordTypeId(),:Utilities.getOpptyPartnerPhaseRecordTypeId()) 
                                         and Parent_ID__c in :OpptyValMap.keySet()]; 
                                                     
            for(Opportunity o : children)
            {               
                    Opportunity tempOPPTY = new Opportunity(
                        Id = o.Id, 
                        OwnerId = OpptyValMap.get(o.Parent_ID__c).OwnerId ,                                  
                        Position__c = OpptyValMap.get(o.Parent_ID__c).Position__c,
                        Territory2Id = OpptyValMap.get(o.Parent_ID__c).Territory2Id,                         
                        Contract_Number__c = OpptyValMap.get(o.Parent_ID__c).Contract_Number__c ,
                        DD_Status__c = OpptyValMap.get(o.Parent_ID__c).DD_Status__c ,
                        DealID__c = OpptyValMap.get(o.Parent_ID__c).DealID__c ,
                        Theater__c = OpptyValMap.get(o.Parent_ID__c).Theater__c,
                        skipValidations__c = true 
                    );                                
                    childOpptys.add(tempOPPTY);
                    system.debug('entering>>>'+childOpptys);
            }
            if(childOpptys.size() > 0)
            {
                System.debug('**Child Opptys updating** ' + childOpptys.size());
                Database.SaveResult[] opptyRslts = Database.Update(childOpptys,false);
                System.debug('**Child Opptys updating** ' + childOpptys.size());
            }
        }
        catch(Exception e)
        {
            System.debug('Error \n' + e);
        }
    }
}