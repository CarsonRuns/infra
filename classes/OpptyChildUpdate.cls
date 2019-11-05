public class OpptyChildUpdate
{

    private static boolean processOpptyChild = true;

    public static boolean getProcessOpptyChild(){
        return processOpptyChild;
    }

    public static void setProcessOpptyChild(boolean newStatus){
        processOpptyChild = newStatus;
    }
    
//Test Methods 
 
   public static testMethod void updateParentUpdatePhases(){
    RecordType[] opptyRecordType = [select Id,name From RecordType WHERE (Name = 'Parent Opportunity' or Name = 'Phase Opportunity') and SobjectType = 'Opportunity' order by Name limit 2];    
    Opportunity[] opptys = [select Id from Opportunity where RecordTypeId = :opptyRecordType[0].Id limit 100];
    Opportunity[] opptysToUpdate = new Opportunity[]{};  
    
    for (Opportunity o : opptys){
      Opportunity tempOPPTY = new Opportunity(id = o.Id, Big_Bet__c = 'Robots;Cats;Cake;Snow;Twizzler');
      opptysToUpdate.add(tempOPPTY);  
    }      
     System.debug('Retrieve ' + opptysToUpdate.size() + ' objs');  
    try{
      update opptysToUpdate;      
    }
    catch (Exception e){      
      System.debug('***exception updating e:' + e);
    }  
  }  
}