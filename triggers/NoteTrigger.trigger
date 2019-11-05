trigger NoteTrigger on Note (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
    TriggerFactory.createAndExecuteHandler(NoteHandler.class);
}