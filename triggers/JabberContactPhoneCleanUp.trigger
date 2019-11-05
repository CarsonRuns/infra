trigger JabberContactPhoneCleanUp on Contact (before update,before insert) {

    List<Contact> newContactInsert=Trigger.new;
    List<Contact> newContactUpdate=new List<Contact>();
    Boolean accContactsUpdate=false;
    JabberPhoneCleanUpcls jPhoneClean= new JabberPhoneCleanUpcls();
   
    if(Trigger.isUpdate)
    {
        for (Contact con: Trigger.new) 
        {
            Contact oldCon = Trigger.oldMap.get(con.ID);
            if (con.Phone != oldCon.Phone ||
                con.Jabber_Phone_Number__c == null || con.Jabber_Phone_Number__c == '') {
                newContactUpdate.add(con);       
            }   
        }
        
        jPhoneClean.JabberContactPhoneClean(newContactUpdate,accContactsUpdate);
        
    }
    
    if(Trigger.isInsert){
        jPhoneClean.JabberContactPhoneClean(newContactInsert,accContactsUpdate);
    }
    
}