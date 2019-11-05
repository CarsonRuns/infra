/*
 * Modification History:
 * Itrack#        Date        Author              Change 
US327769       7/31/2019    Kavya M          Competitor Field Updates
 * */
trigger OpptyMandatoryCompetitor on Opportunity (before insert, before update)
{    
    //enforce Competitors being mandatory for specfic recordTypes, profiles, and conditions in validation rule.
    Opportunity[] opptys = Trigger.new;
    boolean tempHasComp = false;
    //added by Kavya to get the competitor available list
    Set<String> pickListValuesList= new Set<String>();
    Schema.DescribeFieldResult F = Opportunity.Competitors__c.getDescribe();
    List<Schema.PicklistEntry> p = F.getPicklistValues();
    for( Schema.PicklistEntry pickListVal : p){
        if(pickListVal.isActive()==true)
            pickListValuesList.add(pickListVal.getLabel().toLowerCase());
    }
    System.debug('pickListValuesList'+pickListValuesList);
    //ends here
//    String recordTypeIds = Utilities.OpptyMandatoryCompetitorRecordTypes();

   if(Utilities.skipUser())
    {
        tempHasComp = true;
    }
    
    for (Opportunity o : opptys)
    {
        //added by Kavya to check value of other competitor field is present in competitor multiselect
        
        if(String.isNotBlank(o.Other_Competitor__c) && pickListValuesList.contains(o.Other_Competitor__c.toLowerCase()) )
        {
            o.addError(o.Other_Competitor__c+ ' is already in the list of competitors. Pick from the list or enter a new competitor.');
        }
        //ends here
        if ( o.Competitors__c != null )
        {
            o.Competitors__c = o.Competitors__c.replace( ';Competitors;' , ';').replace( 'Competitors;' , '' ).replace( ';Competitors' , '');
            
        }                   
        if( ( o.Competitors__c == null || o.Competitors__c == 'Competitors' ) && 
  /*          recordTypeIds.contains(o.RecordTypeId) &&*/ 
            (Trigger.isInsert || ( Trigger.isUpdate && o.OwnerId == Trigger.oldmap.get(o.Id).OwnerId )  )  )
        {
            o.Has_Competitors__c = tempHasComp;
        }
        else
        {
            o.Has_Competitors__c = true;
        }               
    }   
}