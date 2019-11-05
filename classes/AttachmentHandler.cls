public class AttachmentHandler  
    implements ITrigger{
    // Constructor
    public AttachmentHandler()
    {
    }
 
    public void bulkBefore()
    {
    }
 
    public void bulkAfter()
    {
    	if(!Trigger.isDelete) {
        	System.debug('AttachmentHandler.bulkAfter(): calling prmUtils.processPrmNoteAttachments');
        	prmUtils.processPrmNoteAttachments(Trigger.new);
        	System.debug('AttachHandler.bulkAfter(): return from calling prmUtils.processPrmNoteAttachments');
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