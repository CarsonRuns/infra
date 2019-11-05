public class UserRecordTypeAvailable_CT{
    public String objectName {get; set;}

    public String getUserDefaultOpportunityRecordType(){
        Id defaultRecordTypeId;
        String[] types = new String[]{objectName};
        // Make the describe call
        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);

        System.debug('Got describe information for ' + results.size() + ' sObjects.');

        // For each returned result, get some info
        for(Schema.DescribeSobjectResult res : results) {
            //check each one
            for (Schema.RecordTypeInfo info : res.getRecordTypeInfos()) {
                if (info.DefaultRecordTypeMapping) {
                    defaultRecordTypeId = info.RecordTypeId;
                }
            }
        }

        return defaultRecordTypeId;
    }

    public String getObjectEnt(){
        String objectEnt = objectName;
        if(objectName.contains('__c')){
            sObject s = Database.query('select ' + objectName + ' from Custom_Object_ID__c limit 1');
            objectEnt = (String)s.get(objectName);
        }

        return objectEnt;
    }
}