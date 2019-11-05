/************************************************************************************************************************************
Name    : JiffleInviteeManagement_cls
Author  : Mukesh Srivastava
Purpose : This Class is to handle all Jiffle Releated processing required scoped by Trigger
Created Date: 4/15/2015
Modification History: 

*************************************************************************************************************************************/
public class JiffleNowInviteeManagement_CLS {
    //@ Method: To Accept all newly created Attendee and process as per needed
    public void JiffleInviteeManagement(List < Jiffle_Attendee_Invitee__c > lstJAI) {
        List < Jiffle_Attendee_Invitee__c > lstAttCon = new List < Jiffle_Attendee_Invitee__c > ();
        List < Jiffle_Attendee_Invitee__c > lstReqMgr = new List < Jiffle_Attendee_Invitee__c > ();
        Set < String > setEmail = new Set < String > ();
        Map < String, Jiffle_Attendee_Invitee__c > mapofAtt = new Map < String, Jiffle_Attendee_Invitee__c > ();

        for (Jiffle_Attendee_Invitee__c jAIObj: lstJAI) {
            if (jAIObj.Contact_Sync__c == True && jAIObj.Primary_Account__c != NULL) {
                lstAttCon.add(jAIObj);
            }
            jAIObj.UniqueCombination__c = jAIObj.Customer_Engagements_Events__c + '' + jAIObj.Jiffle_Session_Meeting__c;
            mapofAtt.put(jAIObj.Customer_Engagements_Events__c + '' + jAIObj.Jiffle_Session_Meeting__c, jAIObj);
        }
        // Validate if the List of JiffleInvitee is not empty else stop the processing
        if (!lstAttCon.isEmpty()) {
            JiffleInviteeContactSync(lstAttCon);
        }

        if (!mapofAtt.isEmpty()) {
            JiffleInviteeUniqueFlag(mapofAtt);
        }
    }

    //@ Method: To create the contact which need to be synced to SFDC
    public void JiffleInviteeContactSync(List < Jiffle_Attendee_Invitee__c > lstAttNewCon) {
        List < Contact > lstCon = new List < Contact > ();
        Map < String, Jiffle_Attendee_Invitee__c > mapjAIContact = new Map < String, Jiffle_Attendee_Invitee__c > ();
        Id idEndCusConRec = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('End Customer Contact').getRecordTypeId();
        Id idManualPartnerConRec = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Manual Partner Contact').getRecordTypeId();

        for (Jiffle_Attendee_Invitee__c jObj: lstAttNewCon) {
            Contact cObj = new Contact();
            mapjAIContact.put(jObj.Attendee_Email__c, jObj);
            cObj.FirstName = jObj.Attendee_First_Name__c;
            cObj.LastName = jObj.Attendee_Last_Name__c;
            cObj.Email = jObj.Attendee_Email__c;
            cObj.AccountId = jObj.Primary_Account__c;
            cObj.Title = jObj.Title__c;
            cObj.MailingCountry = jObj.Country__c;
            cObj.MobilePhone = jObj.Mobile__c;
            cObj.RecordTypeId = idEndCusConRec;
            if (jObj.Contact_Type__c == 'Partner') {
                cObj.RecordTypeId = idManualPartnerConRec;
            }
            lstCon.add(cObj);
        }
        // if list of new contacts is not empty then create all the contacts
        if (!lstCon.isEmpty()) {
            Database.SaveResult[] dbInsertResult = Database.insert(lstCon, false);
            Set < Id > setConId = new Set < Id > ();
            for (Database.SaveResult sr: dbInsertResult) {
                if (sr.isSuccess() == true) {
                    setConId.add(sr.getId());
                }
            }
            JiffleInviteeContactUpdate(setConId, lstAttNewCon);
        }
    }

    //@Method: Once the contact is created update the Contact Info on attendee
    public void JiffleInviteeContactUpdate(Set < Id > setNewConId, List < Jiffle_Attendee_Invitee__c > lstNewContact) {
        Map < String, Id > mapConIdEmail = new Map < String, Id > ();
        // Query all the contacts created in the transaction
        for (Contact cObj: [Select Id, Email from Contact WHERE Id IN: setNewConId]) {
            mapConIdEmail.put(cObj.Email, cObj.Id);
        }
        // Verify and populate contactId accordingly.
        for (Jiffle_Attendee_Invitee__c jaObj: lstNewContact) {
            if (mapConIdEmail.containsKey(jaObj.Attendee_Email__c)) {
                jaObj.Contact__c = mapConIdEmail.get(jaObj.Attendee_Email__c);
            }
        }
    }

    //@Method: To Update first attendee
    public void JiffleInviteeUniqueFlag(Map < String, Jiffle_Attendee_Invitee__c > mapUnique) {
        for (Jiffle_Attendee_Invitee__c jnAtt: [Select UniqueCombination__c from Jiffle_Attendee_Invitee__c
                Where UniqueCombination__c IN: mapUnique.keySet()
            ]) {
            mapUnique.remove(jnAtt.UniqueCombination__c);
        }

        for (Jiffle_Attendee_Invitee__c jaObj: mapUnique.values()) {
            jaObj.FirstAttendeeFlag__c = true;
        }
    }
}