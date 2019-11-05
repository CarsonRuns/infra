public class CRMDBContactTriggerHandler {
    public static void ParentFieldUpdate(List <CRMDB_Contact__c> contactList ){
        
        system.debug('ContactList-->' +contactList);
        List<CRMDB_Contact__c>listToInsert=new List<CRMDB_Contact__c>();
        if(!contactList.isEmpty()){
            DescribeSObjectResult describeResult = contactList[0].getSObjectType().getDescribe();
            List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
            String query = 'SELECT '+ String.join( fieldNames, ',' ) +',Key_Contacts__r.Master_Customer_Name__c FROM CRMDB_Contact__c WHERE id IN:contactList';
            List<CRMDB_Contact__c> parentRecord = Database.query( query );
            SYstem.debug('query'+ query);
            for(CRMDB_Contact__c cloneRec :parentRecord){
                if(cloneRec.Key_Contacts__r.Master_Customer_Name__c!=null && cloneRec.Key_Contacts__c!=null){
                    CRMDB_Contact__c clonedRec= new CRMDB_Contact__c();
                    clonedRec= cloneRec.clone(false);
                    clonedRec.Key_Contacts__c = cloneRec.Key_Contacts__r.Master_Customer_Name__c;
                    clonedRec.Crisis_Management_Contacts__c =null;
                    listToInsert.add(clonedRec);
                }
            }
        }
        System.debug('listToInsert'+ listToInsert);
        if(!listToInsert.isEmpty()){
            try{
                database.insert(listToInsert,false);
                
            }
            catch(Exception e) {
                contactList[0].addError('Something went wrong');
                System.debug('Exception e '+e.getLineNumber());
                System.debug(e);
            }
        }
    }
    public static void updateContacts(List <CRMDB_Contact__c> newContactList,List<CRMDB_Contact__c>oldContactList){
        System.debug('newContact '+newContactList);
        System.debug('old '+oldContactList);
        List<CRMDB_Contact__c>updateList=new List<CRMDB_Contact__c>();
        List<CRMDB_Contact__c>finalList=new List<CRMDB_Contact__c>();
        List<CRMDB__c>getMaster=new LIst<CRMDB__c>();
        Map<Id,Id>map1=new Map<Id,Id>();
        Map<Id, CRMDB_Contact__c>map2=new Map<Id,CRMDB_Contact__c>();
        List<Id>getMasterContact=new List<Id>();
        List<Id>parentList= new List<Id>();
        
        
        for(CRMDB_Contact__c newCon : newContactList){
            for(CRMDB_Contact__c oldCon : oldContactList){
                if(newCon.Key_Contacts__c!=null && newCon.Key_Contacts__c==oldCon.Key_Contacts__c){
                    parentList.add(newCon.Key_Contacts__c);//add the child id
                    System.debug('Fire!! '+newCon.Key_Contacts__c);
                }
            }
        }
        System.debug('parentList>> '+parentList);
        if(!parentList.isEmpty()){
            //set
            getMaster=[Select id,Master_Customer_Name__c from CRMDB__c where id IN:parentList];
            if(!getMaster.isEmpty()){
            for(CRMDB__c getMasterCon:getMaster){
                for(CRMDB_Contact__c newCon : newContactList){
                    if(newCon.Key_Contacts__c==getMasterCon.Id){
                            getMasterContact.add(getMasterCon.Master_Customer_Name__c);//get parent Id
                            map1.put(newCon.Key_Contacts__c,getMasterCon.Master_Customer_Name__c);//map of (child Id,parent Id)
                        }
                }
            }
            }
            System.debug('getMasterContact> '+getMaster);
            //get contact records of parent Id
            updateList=[Select id, Key_Contacts__c,Cell_Phone__c,CMS_Relationship_Alignment_Name__c,
                        Email__c,Last_Contact_Date__c,Name,Notes__c,Title__c,Work_Phone__c from CRMDB_Contact__c where
                        Key_Contacts__c IN:getMasterContact];
            for(CRMDB_Contact__c c:updateList){
                for(Id i:map1.keyset()){
                    //if parent id in map and updateList are same 
                    if(map1.get(i)==c.Key_Contacts__c){
                        map2.put(i,c);// create map of (child id,parent's contact record) 
                    }
                }
            }
            System.debug('newContactList>> '+map2);
            for(Id con:map2.keySet()){
                for(CRMDB_contact__c newCon:newContactList){
                    System.debug('?? '+con);
                    if(newCon.Key_Contacts__c==con){
                        map2.get(con).Cell_Phone__c=newCon.Cell_Phone__c;
                        map2.get(con).CMS_Relationship_Alignment_Name__c=newCon.CMS_Relationship_Alignment_Name__c;
                        map2.get(con).Email__c=newCon.Email__c;
                        map2.get(con).Last_Contact_Date__c=newCon.Last_Contact_Date__c;
                        map2.get(con).Name=newCon.Name;
                        map2.get(con).Notes__c=newCon.Notes__c;
                        map2.get(con).Title__c= newCon.Title__c;
                        map2.get(con).Work_Phone__c=newCon.Work_Phone__c;
                        finalList.add(map2.get(con));
                    }
                    
                }
            }
        }
         System.debug('finalList>> '+finalList);
        if(!finalList.isEmpty()){
            try{
            update finalList;
            }
            catch(Exception e){
                newContactList[0].addError('Something went wrong');
                System.debug('Exception e '+e.getLineNumber());
                System.debug(e);
            }
        }
    }
}