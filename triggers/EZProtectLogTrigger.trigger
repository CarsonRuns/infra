trigger EZProtectLogTrigger on EZProtectLog__c (after insert, after update) {
    //EZProtectPrivilegedUtilities.deleteFiles( trigger.new );
    EZProtectPrivilegedUtilities.scanHandler( trigger.new );
}