/**
  @ Author       : Raj
  @ Name         : JabberPhoneUtils
  @ Created Date : 10/3/2013
  @ Description  : This is the utility class for JabberPhoneController pages. 
                   It contains helper methods to search salesforce records
  */

/**
  *---------------Revision------------------
  * Version 1.0  : Pilot Release
  * BY           : Arif,Raj,Mukesh and Simon
  * Version 1.1  : Implemented ANI search 
  * BY           : Raj,Mukesh and Simon
  * Version 1.2  : Handled customer search features
  * BY           : Raj,Mukesh and Simon
  */
global with sharing class JabberPhoneUtils 
{
	/** 
      * create debug log in the customized format 
      * @name : log
      * @param strMsg: specify the message to be captured while debugging
      */
	public static void log(string strMsg)
	{
		system.debug('****' + strMsg);
	}
	/** 
      * search salesforce account and contact by matching search string with either standard name field or phone number
      * @name : searchCustomerInfo
      * @param strName: specify the search string
      * @param strSearchType : specify the search type
      */
	global static string searchCustomerInfo(string strName, string strSearchType)
	{
		JabberPhoneUtils.log('*** Search String: ' + strName + '  || Search Type:'+ strSearchType);
		List<SearchResultWrapper> lstSearchResult = new List<SearchResultWrapper>();
		string strContactQuery = 'select id,Name,Phone,Jabber_Phone_Number__c from Contact where Phone != null and Jabber_Phone_Number__c != null and ';
		string strAccountQuery = 'select id,Name,Phone,Jabber_Phone_Number__c from Account where Phone != null and Jabber_Phone_Number__c != null and ';
		if(strSearchType == 'By Name' && strName.contains(' '))
		{
			strContactQuery += 'Name Like :strName';
			strAccountQuery += 'Name Like :strName';
		}
		else if(strSearchType == 'By Name' && !strName.contains(' '))
		{
			strContactQuery += '(FirstName Like :strName OR LastName Like :strName)';
			strAccountQuery += 'Name Like :strName';
		}
		else if(strSearchType == 'By Phone')
		{
			strContactQuery += 'Jabber_Phone_Number__c Like :strName';
			strAccountQuery += 'Jabber_Phone_Number__c Like :strName';
		}
		strContactQuery += ' Order By LastModifiedDate DESC Limit 5';
		strAccountQuery += ' Order By LastModifiedDate DESC Limit 5';
		
		JabberPhoneUtils.log('*** contact query string: ' + strContactQuery);
		JabberPhoneUtils.log('*** account query string: ' + strAccountQuery);
		for(Contact qryResult : dataBase.query(strContactQuery))
		{
			SearchResultWrapper resultWrapper = new SearchResultWrapper(qryResult.Id, 'Contact', qryResult.Name);
			resultWrapper.strStdPhoneNumber = qryResult.Phone;
			resultWrapper.strJabberPhoneNumber = qryResult.Jabber_Phone_Number__c;
			if(qryResult.Phone.startsWith('+'))
			{
				resultWrapper.strPhoneNumber = '+' + formatPhoneNumber(qryResult.Phone);
			}
			else
			{
				resultWrapper.strPhoneNumber = '+' + qryResult.Jabber_Phone_Number__c;
			}
			lstSearchResult.add(resultWrapper);
		}
		if(lstSearchResult.size() < 5)
		{
			for( Account qryResult : dataBase.query(strAccountQuery))
			{
				SearchResultWrapper resultWrapper = new SearchResultWrapper(qryResult.Id, 'Account', qryResult.Name);
				resultWrapper.strStdPhoneNumber = qryResult.Phone;
				resultWrapper.strJabberPhoneNumber = qryResult.Jabber_Phone_Number__c;
				if(qryResult.Phone.startsWith('+'))
				{
					resultWrapper.strPhoneNumber = '+' + formatPhoneNumber(qryResult.Phone);
				}
				else
				{
					resultWrapper.strPhoneNumber = '+' + qryResult.Jabber_Phone_Number__c;
				}
				lstSearchResult.add(resultWrapper);
				if(lstSearchResult.size() == 5)
				{
					break;
				}
			}
		}
		return JSON.serialize(lstSearchResult);
	}
	/** 
      * remove all special characters and convert the phone number to jabber phone expected format
      * @name : formatPhoneNumber
      * @param ph: existing phone number
      */
	global static string formatPhoneNumber(String ph)
    {
        string farmatedPhoneNumber ='';
        farmatedPhoneNumber = ph.toLowerCase();
           
        integer extIndex= farmatedPhoneNumber.indexOfAny('abcdefghijklmnopqrstuvwxyz');
        if(extIndex > -1)
        {
            farmatedPhoneNumber =  farmatedPhoneNumber.substring(0,extIndex).replaceAll('[^\\d]','');
        }
        else
        {
            farmatedPhoneNumber = farmatedPhoneNumber.replaceAll('[^\\d]','');
        }
        if(farmatedPhoneNumber.startsWith('0'))
        {
            boolean removeZero = true; 
            while (removeZero) 
            {
                if(farmatedPhoneNumber.startsWith('0'))
                {
                    farmatedPhoneNumber = farmatedPhoneNumber.substring(1); 
                }
                else
                {
                    removeZero=false;
                }
            }
        }
        return farmatedPhoneNumber;
    }
    /** 
      * search incoming call's phone number in salesforce account and contacts
      * @name : searchJabberPhoneNumber
      * @param strPhNumber: incoming call number
      * @param strCallerId: incoming call id
      */
	webservice static string searchJabberPhoneNumber(string strPhNumber, string strCallerId)
	{
		String searchString = ''+strPhNumber ;
		List<SObject> lstSearchResult = new List<SObject>();
		string strQuery = 'FIND \''+searchString + '\' IN ALL FIELDS RETURNING Contact (Id, Name limit 6), Account (Id, Name Limit 6)';
		List<List<SObject>> queryResult=search.query(strQuery);
		
		for(List<SObject> lstRecords: queryResult)
		{
			if(lstRecords.size() > 0)
			{
				lstSearchResult.addAll(lstRecords);
			}
		}
		String JSONString = strCallerId + '*#Jp*#' +JSON.serialize(lstSearchResult);
		return JSONString;
	}
	/** 
      * convert search results into json string
      * @name : searchPhoneNumber
      * @param strPhNumber: incoming call number
      * @param strCallerId: incoming call id
      */
	webservice static string searchPhoneNumber(string strPhNumber, string strCallerId)
	{
		strPhNumber = '%'+ strPhNumber;
		//strPhNumber = strPhNumber;
		List<SearchResultWrapper> lstSearchResult = getSearchResult(strPhNumber);
		String JSONString = strCallerId + '*#Jp*#' +JSON.serialize(lstSearchResult);
		return JSONString;
	}
	/** 
      * search incoming call's phone number in salesforce account and contacts
      * @name : getSearchResult
      * @param strPhNumber: incoming call number
      */
	static list<SearchResultWrapper> getSearchResult(string strPhNumber)
	{
		List<SearchResultWrapper> lstSearchResult = new List<SearchResultWrapper>();
		for(Contact qryResult : [select id,Name from Contact where Jabber_Phone_Number__c LIKE: strPhNumber limit 6])
		{
			SearchResultWrapper resultWrapper = new SearchResultWrapper(qryResult.Id, 'Contact', qryResult.Name);
			lstSearchResult.add(resultWrapper);
		}
		if(lstSearchResult.size() < 6)
		{
			for( Account qryResult : [select id,Name from Account where Jabber_Phone_Number__c LIKE: strPhNumber limit 6])
			{
				SearchResultWrapper resultWrapper = new SearchResultWrapper(qryResult.Id, 'Account', qryResult.Name);
				lstSearchResult.add(resultWrapper);
				if(lstSearchResult.size() == 6)
				{
					break;
				}
			}
		}
		return lstSearchResult;
	}
	/**
	  @ Author       : Raj
	  @ Name         : SearchResultWrapper
	  @ Created Date : 10/3/2013
	  @ Description  : Wrapper class to store search results in a custom format
	  */
	public class SearchResultWrapper
	{
		public String strId, strType, strName, strStdPhoneNumber, strJabberPhoneNumber, strPhoneNumber;
		public SearchResultWrapper(String strRecordId, String strRecordType, String strRecordName)
		{
			strId = strRecordId;
			strType = strRecordType;
			strName = strRecordName;
		}
		
	}
}