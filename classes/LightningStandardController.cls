/**
  * @author:        Paul Battisson (@pbattisson)
  * @description:   This controller provides a standard set of functionality for use in Lightning Components similar to the 
  *                 Standard Controller provided for Visualforce.
  */
public with sharing class LightningStandardController {
    
    //String used to help in casting our input from a generic SObject
    private static String listStringTemplate = 'List<{0}>';

    /**
      * @description: Saves a single record of a specified type.
      * @param objectType The API name of the object we are saving, for example Account or Invoice__c.
      * @param record The SObject record we wish to save.
      * @return The Id of the saved record.
      */
    @AuraEnabled
    public static Id save(String objectType, SObject record) {
        return saveMany(objectType, new List<SObject>{ record })[0];
    }

    /**
      * @description: Saves a list of record of a specified type.
      * @param objectType The API name of the object we are saving, for example Account or Invoice__c.
      * @param records The SObject records we wish to save.
      * @return The list of Ids of the saved records.
      */
    @AuraEnabled
    public static List<Id> saveMany(String objectType, List<SObject> records) {
        Type listType = Type.forName(String.format(listStringTemplate, new List<String>{ objectType }));
        List<SObject> items = (List<SObject>)listType.newInstance();
        items.addAll(records);
        upsert items;

        List<Id> returnIds = new List<Id>();

        for(SObject item : items) {
            returnIds.add((Id)item.get('Id'));
        }

        return returnIds;
    }

    /**
      * @description Retrieves a list of records given a valid query string.
      * @param query The query string to execute.
      * @return The list of retrieved records.
      * UserInfo.getUsername();
      */
    @AuraEnabled
    public static List<SObject> runQuery(String query) {
        return Database.query(query);
    }

    /**
      * @description Retrieves a list of records from the specified object with the requested fields
      * @param objectType The API name of the object we are saving, for example Account or Invoice__c.
      * @param fields A list of strings which are the API field names for the fields we wish to retrieve.
      * @param filters A map of field names to filter values.
      * @return The list of retrieved records.
      */
    @AuraEnabled
    public static List<SObject> query(String objectType, List<String> fields, Map<String, Object> and_filters, Map<String, Object> or_filters, Map<String, Object> in_filters) {
        
        and_filters = and_filters == null ? new Map<String, Object>() : (Map<String, Object>)and_filters;
        or_filters = or_filters == null ? new Map<String, Object>() : (Map<String, Object>)or_filters;
        in_filters = in_filters == null ? new Map<String, Object>() : (Map<String, Object>)in_filters;

        String query = buildFieldQuery(objectType, fields);

        if(and_filters == null && or_filters == null && in_filters == null) {
            return runQuery(query);
        }

        if(!and_filters.isEmpty() || !or_filters.isEmpty() || !in_filters.isEmpty()) {
            query += ' WHERE ';
        }

        if(!and_filters.isEmpty()) {
            for(String key : and_filters.keySet()) {
                query += buildFilterString(key, and_filters.get(key)) + ' AND ';
            }
            query = query.substring(0, query.length() - 4);
        }

        if(!or_filters.isEmpty()) {
            query += and_filters.isEmpty() ? '' : ' AND '; 
            query += '(';
            for(String key : or_filters.keySet()) {
                query += buildFilterString(key, or_filters.get(key)) + ' OR ';
            }
            query = query.substring(0, query.length() - 4) + ')';
        }

        if(!in_filters.isEmpty()) {
            query += and_filters.isEmpty() && or_filters.isEmpty() ? '' : ' AND ';
            for(String key : in_filters.keySet()) {
                query += buildInFilterString(key, (List<String>)in_filters.get(key)) + ' AND ';
            }
            query = query.substring(0, query.length() - 4);
        }
        
        if(objectType == 'User'){
            query = query + ' WHERE Id=\''+UserInfo.getuserId()+'\'';
        }
        return runQuery(query);
    }

    /**
      * @description Retrieves a list of records from the specified object with the requested fields
      * @param objectType The API name of the object we are saving, for example Account or Invoice__c.
      * @param fields A list of strings which are the API field names for the fields we wish to retrieve.
      * @return The list of retrieved records.
      */
    private static String buildFieldQuery(String objectType, List<String> fields) {
        if(fields == null || fields.size() == 0) {
           // throw new LightningStandardControllerException(Label.Empty_Field_List_For_Query);
        }

        String query = 'SELECT ';

        for(String field : fields) {
            query += field + ',';
        }

        query = query.substring(0, query.length() - 1) + ' FROM ' + objectType;

        return query;
    }

    /**
      * @description This method takes a field name and value and creates a filter string to use.
      * @param fieldName This name of the field we are filtering on.
      * @param value The value we are trying to equate to.
      * @return A correctly formatted string for use in the query string.
      */
    private static String buildFilterString(String fieldName, Object value) {
        String filter = fieldName + ' = ';

        if(value instanceof Boolean || value instanceof Blob || value instanceof Integer || value instanceof Long || value instanceof Decimal)
        {
            filter += value;
        } else if(value instanceof Id || value instanceof String) {
            filter += '\'' + value + '\'';
        } else if (value instanceof Date || value instanceof Datetime) { 
            filter += ((Datetime)value).format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        } else {
            //throw new LightningStandardControllerException(Label.Invalid_Filter_Type);
        }
        
        return filter;
    }

    /**
      * @description This method takes a field name and value and creates a filter string to use.
      * @param fieldName This name of the field we are filtering on.
      * @param values The list value we are trying to find our value in.
      * @return A correctly formatted string for use in the query string.
      */
    private static String buildInFilterString(String fieldName, List<String> values) {
        String filter = fieldName + ' in ' + '(';
            
        for(String value : values) {
            filter += '\'' + value + '\',';
        }

        filter = filter.substring(0, filter.length() - 1) + ')';

        return filter;
    }
    
     @AuraEnabled
    public static Boolean wrapperCCE(String recordId) {
        List<String> fields = new List<String>();
        List<SObject> obj = new List<SObject>();
        String field = 'additional_user_permissions__c';
        fields.add(field);
        String permissions = '';
        
        Boolean cce = false;
        
      //  String query1 = buildFieldQuery('Opportunity', fields);
      //  query1 = query1 + ' WHERE Id=\''+recordId+'\'';
        
        String query2 = buildFieldQuery('User', fields);
        query2 = query2 + ' WHERE Id=\''+UserInfo.getuserId()+'\'';
        obj = runQuery(query2);
        if(!obj.isEmpty()){
        permissions = (String) obj.get(0).get('additional_user_permissions__c');
        }
        if(String.isNotEmpty(permissions) && permissions.contains('CCE Enabled')){
            cce=true;
        }
       return cce;
    }
    

      @AuraEnabled
    public static Map<String, List<String>> validateCCE(String recordId) {
        List<String> validateFields = new List<String>();
        List<SObject> validateObj = new List<SObject>();
        List<String> validateEmailFields = new List<String>();
        List<SObject> validateEmailObj = new List<SObject>();
        List<String> errorFields = new List<String>();
        List<String> successFields = new List<String>();
       // List<List<String>> results = new List<List<String>>();
        Map<String, List<String>> results = new Map<String, List<String>>();
       // String field = 'additional_user_permissions__c';
        validateFields.add('DealID__c');
        validateFields.add('account.ZipPostalCode__c');
        validateFields.add('StageName');
        validateFields.add('account.State__c');
        validateFields.add('account.Phone');
        validateFields.add('Owner.Name');
        validateFields.add('account.Name');
        validateFields.add('Name');
        validateFields.add('CreatedBy.Name');
        validateFields.add('account.Country__c');
        validateFields.add('account.City__c');
       // validateFields.add('account.AddressLine2__c');
        String dealId ;
        String stageName;
         String validateQuery = buildFieldQuery('Opportunity', validateFields);
        validateQuery = validateQuery + ' WHERE id=\''+recordId+'\'';
        validateObj = runQuery(validateQuery);
        if(!validateObj.isEmpty()){
                     // System.debug(JSON.serializePretty(validateObj));
                     dealID = (String) validateObj.get(0).get('DealID__c');
            System.debug(LoggingLevel.INFO, 'DealID__c : '+(String) validateObj.get(0).get('DealID__c'));
            System.debug(LoggingLevel.INFO, 'account.ZipPostalCode__c : '+(String) validateObj.get(0).getSobject ('account').get('ZipPostalCode__c'));
            System.debug(LoggingLevel.INFO, 'StageName : '+(String) validateObj.get(0).get('StageName'));
            System.debug(LoggingLevel.INFO, 'account.State__c : '+(String) validateObj.get(0).getSobject('account').get('State__c'));
            System.debug(LoggingLevel.INFO, 'account.Phone : '+(String) validateObj.get(0).getSobject('account').get('Phone'));
            System.debug(LoggingLevel.INFO, 'Owner.Name : '+(String) validateObj.get(0).getSobject('Owner').get('Name'));
            System.debug(LoggingLevel.INFO, 'account.Name : '+(String) validateObj.get(0).getSobject('account').get('Name'));
            System.debug(LoggingLevel.INFO, 'Name : '+(String) validateObj.get(0).get('Name'));
            System.debug(LoggingLevel.INFO, 'CreatedBy.Name : '+(String) validateObj.get(0).getSobject('CreatedBy').get('Name'));
            System.debug(LoggingLevel.INFO, 'account.Country__c : '+(String) validateObj.get(0).getSobject('account').get('Country__c'));
            System.debug(LoggingLevel.INFO, 'account.City__c : '+(String) validateObj.get(0).getSobject('account').get('City__c'));
          //  System.debug(LoggingLevel.INFO, 'account.AddressLine2__c : '+(String) validateObj.get(0).getSobject('account').get('AddressLine2__c'));
          //  System.debug(LoggingLevel.INFO, 'DealID__c : '+(String) validateObj.get(0).get('DealID__c'));
            stageName = (String) validateObj.get(0).get('StageName');
            if((String) validateObj.get(0).get('DealID__c') == null){
                errorFields.add(' DealID');
            }
            if((String) validateObj.get(0).getSobject ('account').get('ZipPostalCode__c') == null){
                errorFields.add(' Account.Zip/Postal Code');
            }
            if(stageName == null){
                 errorFields.add('Stage'); 
            }
            if(stageName == '5 - Closed Cancelled' || stageName == '5 - Closed Lost'){
                 errorFields.add(' Opportunity must be Active or Booked');
            }
            if((String) validateObj.get(0).getSobject('account').get('State__c') == null){
                errorFields.add(' Account.State/Province');
			}
            if((String) validateObj.get(0).getSobject('account').get('Phone') == null){
                errorFields.add(' Account.Phone');
            }
            if((String) validateObj.get(0).getSobject('Owner').get('Name') == null){
                 errorFields.add(' Opportunity Owner');
            }
            if((String) validateObj.get(0).getSobject('account').get('Name') == null){
                errorFields.add(' Account.Account Name');
            }
            if((String) validateObj.get(0).get('Name') == null){
                errorFields.add(' Opportunity Name');
            }
            if((String) validateObj.get(0).getSobject('CreatedBy').get('Name') == null){
                errorFields.add(' Created By');
            }
            if((String) validateObj.get(0).getSobject('account').get('Country__c') == null){
                 errorFields.add(' Account.Country');
            }
            if((String) validateObj.get(0).getSobject('account').get('City__c') == null){
                errorFields.add(' Account.City');
            }
          /*  if((String) validateObj.get(0).getSobject('account').get('AddressLine2__c') == null){
                errorFields.add('account.AddressLine2__c');
            } */
           
      
        }
        validateEmailFields.add('Contact.Id');
         validateEmailFields.add('Contact.Email');
          String validateContactQuery = buildFieldQuery('OpportunityContactRole', validateEmailFields);
        validateContactQuery = validateContactQuery + ' WHERE Opportunityid=\''+recordId+'\'';
        validateEmailObj = runQuery(validateContactQuery);
        if(!validateEmailObj.isEmpty()){
         if((String) validateEmailObj.get(0).getSobject('Contact').get('Email') == null){
                errorFields.add(' Contact Email');
            }
        }
         if(errorFields == null || errorFields.size() == 0) {
             successFields.add(dealID);
             results.put('success', successFields);
            // return successFields;
         }else {
             //return errorFields;
             /* if(errorFields.indexOf('Stagename') != -1){
             errorFields.remove(errorFields.indexOf('Stagename'));
             } */
             results.put('error',errorFields);
         }
   return results;
    }

    /**
      * @description Custom exception class for the Lightning Standard Controller system.
      */
    public class LightningStandardControllerException extends Exception {

    }    
 
}