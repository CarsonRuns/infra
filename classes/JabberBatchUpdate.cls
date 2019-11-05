global class JabberBatchUpdate implements Database.Batchable<sObject> 
{
	global final String g_strQuery, g_strObject;
    global JabberBatchUpdate(String strQuery, string strObject)
    {
       g_strQuery = strQuery;
       g_strObject = strObject;
    }      
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
    	return Database.getQueryLocator(g_strQuery);
    }
    global void execute(Database.BatchableContext BC, List<sObject> lstRecords)
    {    
		List<Tx_Log__c> lstLog = new List<Tx_Log__c>();
		Database.SaveResult[] lstJabberSaveResult = Database.update(lstRecords,false);
		
		Integer iRows = 0;
		try
		{
			for(Database.SaveResult dsr: lstJabberSaveResult)
			{
				Tx_Log__c newErrorRecord = new Tx_Log__c(name = lstRecords[iRows].id, originated__c = 'JabberBatchUpdate',type__c = g_strObject,exception__c = true);
				// create log for all failed records
				if(dsr.isSuccess() != true)
				{
	                // get record id from query result and get error message from save result's list
	                if(dsr.getErrors().size() > 0)
	                {
	                	newErrorRecord.message__c = 'STATUS CODE: '+ dsr.getErrors()[0].getStatusCode() +
	                		'\n ERROR: '+ dsr.getErrors()[0].getMessage() +
	                		'\n AFFECTED FIELD: ' + dsr.getErrors()[0].getFields();
	                } 
	                lstLog.add(newErrorRecord);
				}
				iRows ++;
			}
			if(lstLog.size() > 0)
				Database.insert(lstLog,false);
		}
		catch(exception e){}
    }
    global void finish(Database.BatchableContext BC)
    {
    }      
}