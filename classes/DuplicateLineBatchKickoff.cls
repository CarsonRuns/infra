global class DuplicateLineBatchKickoff implements Schedulable {

    global void execute(SchedulableContext SC) {
        DuplicateLineBatch recalculate = new DuplicateLineBatch();
        recalculate.query='SELECT OpptyEx__c from DuplicateLine__c where Status__c = \'ToUpdate\' limit 100000';
        recalculate.email='sfdc-integration-apex-exceptions@external.cisco.com';
        ID batchprocessid = Database.executeBatch(recalculate,100);
        System.debug(batchprocessid);
    }
}