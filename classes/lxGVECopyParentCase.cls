/*
Author          : Manikant Kella
Release         : May 03rd, 2019
Created         : Manikant Kella
Functionality   : Apex controller to support lxGVECopyParentCase component, creates child case by assigning it to parent case
				  


Modification History:
*------------------------------------------------------------------------------------
Itrack#        Date        Author                             Change  
*------------------------------------------------------------------------------------
US261709    Apr 03,2019   Manikant Kella(mkella)     Create Child Case Functionality similar to Classic for GVE record type
*------------------------------------------------------------------------------------
*/


public class lxGVECopyParentCase {
    @AuraEnabled
    public static String createChildCaseRecord(ID parentCaseId){
        try{
            //assign parent case id to variable
        Id parentRecordId =  parentCaseId;
            // fetch parent case sobject
        DescribeSObjectResult describeResult = parentRecordId.getSObjectType().getDescribe();
		// fetch list of field names of case object
		List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
		// soql for querying the record values
		String query = ' SELECT ' + String.join( fieldNames, ',' ) + ' FROM ' + describeResult.getName() + ' WHERE ' + ' id = :parentRecordId ';
        // query database
        Case parentCaseRecord = Database.query( query );
            //copy all parent case details and assign to child case variable
		Case clonedChildCase = parentCaseRecord.clone(false);
        // assign Parent case look up id value to Child Case Parent Case Number field
        clonedChildCase.ParentId = parentCaseRecord.Id;
        //clonedChildCase.RecordTypeId = String.valueOf(parentCaseRecord.RecordTypeId).substring(0,15);
            //System.debug('Cisco Contact in Child Cloned Case: '+clonedChildCase.Cisco_Contact__c);
        System.debug('Child Case Record: '+clonedChildCase);
        System.debug('Child Case Record type Id: '+String.valueOf(parentCaseRecord.RecordTypeId).substring(0,15));
        
        //insert child case
        insert clonedChildCase;
        Id childCaseId = clonedChildCase.Id;
            // return child case id to js controller
        return childCaseId;
        }catch(Exception e){
            String errorMessage;
            System.debug('Error: ' + e);
            errorMessage = e.getMessage();
            return errorMessage;
        }
    } 

}