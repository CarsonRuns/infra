public class EventHandler
    implements ITrigger{
    // Constructor
    public EventHandler()
    {
    }
 
    public void bulkBefore()
    {
    }
 
    public void bulkAfter()
    {
    	if(!Trigger.isDelete) {
        	System.debug('NoteHandler.bulkAfter(): calling prmUtils.processPrmNotes');
        	prmUtils.processPrmEventTask(Trigger.new);
        	System.debug('NoteHandler.bulkAfter(): return from calling prmUtils.processPrmNotes');
    	}
    }
 
    public void beforeInsert(SObject so)
    {
    }
 
    public void beforeUpdate(SObject oldSo, SObject so)
    {
    }
 
    public void beforeDelete(SObject so)
    {
    }
 
    public void afterInsert(SObject so)
    {
    }
 
    public void afterUpdate(SObject oldSo, SObject so)
    {
    }
 
    public void afterDelete(SObject so)
    {
    }
 
    public void andFinally()
    {
    }
}