/**
 * Class NoteHandler
 *
 * Trigger Handler for the Note SObject. This class implements the ITrigger
 * interface to help ensure the trigger code is bulkified and all in one place.
 */
public with sharing class NoteHandler 
    implements ITrigger{
    // Constructor
    public NoteHandler()
    {
    }
 
    public void bulkBefore()
    {
    }
 
    public void bulkAfter()
    {
    	if(!Trigger.isDelete) {
        	System.debug('NoteHandler.bulkAfter(): calling prmUtils.processPrmNotes');
        	prmUtils.processPrmNoteAttachments(Trigger.new);
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