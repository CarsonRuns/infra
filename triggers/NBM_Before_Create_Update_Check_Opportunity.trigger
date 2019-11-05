trigger NBM_Before_Create_Update_Check_Opportunity on Qualification__c (before insert,before update) 
{
    Qualification__c[] NBM = Trigger.new;    
    FOR (Qualification__c n: NBM )    
    {
        //Checking for NBM Qualification Record and its associated Opportunity
        if(n.RecordTypeId == Utilities.getNBMQualificationId() && n.Opportunity__c != null)
        {
            if((Trigger.isUpdate && Trigger.oldmap.get(n.Id).Opportunity__c!=Trigger.newmap.get(n.Id).Opportunity__c) || 
            Trigger.isinsert )
            {
                //Finding whether the related Opportunity has any other Qualification associated with it
                Integer optcount =  [Select count() from Qualification__c n where n.Opportunity__c =:n.opportunity__c and n.RecordTypeId = '012800000003c7X'];
                //If the Related Opportunity already has a NBM qualification associated with it, then throw an error message
                if(optcount > 0)
                n.addError('The selected Related Opportunity has already been tagged to other NBM Qualification. Please select other opportunity');
            }
         }
     }
}