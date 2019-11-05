/***************************************************************************************************
Name    : CEE_Utility 
Author  : Eric Pesch
Purpose : CEE Utility classes 
Created Date: Dec 1 2014
Modification History: 
Eric Pesch - Jan 5 2015: Added Comments, cleanup
Sudi - Dec 17 2015 : Added new method to get the Cisco contact details based on CEC id.                     
*****************************************************************************************************/

public with sharing class CEE_Utility {
    //Debug variables
    private final static String TAG = 'CEE_Utility';
    
    //Time output formats
    public final static String TIME_FORMAT_EBC = 'M/d/yyyy h:mm a z Z';
    public final static String TIME_FORMAT_ITCE = 'M/d/yyyy h:mm a';
    
    //URL variables
    public final static String ROOT_URL_REDIRECT = '/SalesIT/wwce/CanvasRedirect.jsp';
    public final static String ROOT_URL_LOGIN = '/SalesIT/wwce/SFDCCEELogin.do';
    public static string HRMSUrl = Utilities.getConstant_CS('HRMS AD Url');
    public static string HRMSUserName = Utilities.getConstant_CS('HRMS AD User Name');
    public static string HRMSPassowrd = Utilities.getConstant_CS('HRMS AD Password');
    
    //Timezone mapping
    private final static Map<String, String> utcMap = new Map<String, String>{
        'UTC-11:00' => 'Pacific/Midway',
        'UTC-10:00' => 'America/Adak',
        'UTC-09:30' => 'Pacific/Marquesas',
        'UTC-09:00' => 'America/Anchorage',
        'UTC-08:00' => 'America/Dawson',
        'UTC-07:00' => 'America/Boise',
        'UTC-06:00' => 'America/Bahia_Banderas',
        'UTC-05:00' => 'America/Atikokan',
        'UTC-04:30' => 'America/Caracas',
        'UTC-04:00' => 'America/Anguilla',
        'UTC-03:30' => 'America/St_Johns',
        'UTC-03:00' => 'America/Araguaina',
        'UTC-02:00' => 'America/Noronha',
        'UTC-01:00' => 'America/Scoresbysund',
        'UTC+14:00' => 'Pacific/Kiritimati',
        'UTC+13:00' => 'Pacific/Apia',
        'UTC+12:45' => 'NZ-CHAT',
        'UTC+12:00' => 'Antarctica/McMurdo',
        'UTC+11:30' => 'Pacific/Norfolk',
        'UTC+11:00' => 'Antarctica/Casey',
        'UTC+10:30' => 'Australia/LHI',
        'UTC+10:00' => 'Antarctica/DumontDUrville',
        'UTC+09:30' => 'Australia/Adelaide',
        'UTC+09:00' => 'Asia/Dili',
        'UTC+08:45' => 'Australia/Eucla',
        'UTC+08:00' => 'Asia/Brunei',
        'UTC+07:00' => 'Asia/Bangkok',
        'UTC+06:30' => 'Asia/Rangoon',
        'UTC+06:00' => 'Antarctica/Vostok',
        'UTC+05:45' => 'Asia/Kathmandu',
        'UTC+05:30' => 'Asia/Calcutta',
        'UTC+05:00' => 'Antarctica/Davis',
        'UTC+04:30' => 'Asia/Kabul',
        'UTC+04:00' => 'Asia/Baku',
        'UTC+03:30' => 'Asia/Tehran',
        'UTC+03:00' => 'Africa/Addis_Ababa',
        'UTC+02:00' => 'Africa/Blantyre',
        'UTC+01:00' => 'Africa/Algiers',
        'UTC+00:00' => 'Africa/Abidjan'};

    /*@method: Get days in a month*/
    public static String[] getMonthDays(Integer year, Integer month){
        //System.debug(TAG + 'getMonthDays shell start');
        return getMonthDays(DateTime.newInstance(year, month, 1));
    }
    
    /*@method: Get days in a month (by date time)*/
    public static String[] getMonthDays(DateTime inDate){
        //System.debug(TAG + 'getMonthDays start');
        String[] days = new List<String>();
        Date monthDate = inDate.date().toStartOfMonth();
        DateTime currDateTime = DateTime.newInstance(monthDate.year(), monthDate.month(), 1);
        
        for(Integer i = 0; i < Date.daysInMonth(monthDate.year(), monthDate.month()); i++){
            String currDay = currDateTime.format('E').subString(0,2);
            days.add(currDay);
            
            monthDate = monthDate.addDays(1);
            currDateTime = DateTime.newInstance(monthDate.year(), monthDate.month(), monthDate.day());
        }
        
        return days;
    }
    
    /*@method: Convert UTC values to Timezone code*/
    public static String convertUTCtoTZ(String utcValue){
        String utcMapValue = utcValue.substring(1, 10);
        System.debug(TAG + utcMapValue);
        
        return utcMap.get(utcMapValue);
    }
    
    /*@method: Convert User times based on input Date Time (w/Timezone)*/
    public static DateTime convertUserTimeToUTC(DateTime inDate, TimeZone userZone, TimeZone convertZone){
        //System.debug(TAG + 'convertUserTimeToUTC TZ start');
        if(convertZone == null || inDate == null){
            return null;
        } 
        
        //Calculate time offset of User
        Integer offsetMillisec = convertZone.getOffset(inDate);
        
        //Return corrected date time
        DateTime newDate = inDate.addSeconds(-offsetMillisec/1000);
        //System.debug(newDate.format());
        
        return convertUserTimeToUTC(inDate, userZone, offsetMillisec);
    }
    
    /*@method: Convert User times based on input Date Time (w/String utc name)*/
    public static DateTime convertUserTimeToUTC(DateTime inDate, TimeZone userZone, String utcName){
        //System.debug(TAG + 'convertUserTimeToUTC UTC start');
        if(String.isEmpty(utcName) || inDate == null){
            return null;
        } 
        
        //Calculate time offset from UTC
        Integer offsetFlag = 1;
        if(utcName.subString(4,5).equals('-')){
            //System.debug(TAG + 'Negative offset');
            offsetFlag = -1;
        }
        Integer offsetHour = Integer.valueOf(utcName.subString(5, 7));
        Integer offsetMin = Integer.valueOf(utcName.subString(8, 10));
        Integer offsetMillisec = offsetFlag * (offsetHour * 60 * 60 * 1000 + offsetMin * 60 * 1000);
        
        System.debug(TAG + 'offsets - ' + offsetHour + ' - ' + offsetMin + ' - ' + offsetMillisec);
        
        return convertUserTimeToUTC(inDate, userZone, offsetMillisec);
    }
    
    /*@method: Convert User times based on input Date Time (with Integer offset value)*/
    public static DateTime convertUserTimeToUTC(DateTime inDate, TimeZone userZone, Integer offsetMillisec){
        System.debug(TAG + 'convertUserTimeToUTC root start');
        
        //Calculate time offset of User
        Integer userOffsetMillisec = userZone.getOffset(inDate) - offsetMillisec;
        
        //Return corrected date time
        DateTime newDate = inDate.addSeconds(-userOffsetMillisec/1000);
        System.debug(newDate.format());
        
        return newDate;
    }
    
    /*@method: Calculate real timezone times for chosen date-time field*/
    public static String calcSiteTime(CEE__c briefing, Datetime input){
        TimeZone userZone = UserInfo.getTimeZone();
        TimeZone siteZone = null;
        String siteStartTime = null;
        
        //Grab primary site timezone
        if(briefing.Primary_FSO__c != null){
            siteZone = TimeZone.getTimeZone(briefing.Primary_FSO__r.Site_Time_Zone__c);
        }
        //Cover ITCE use case - selectable timezone
        if(briefing.Timezone__c != null){
            siteStartTime = CEE_Utility.convertUserTimeToUTC(input, userZone, 
                briefing.Timezone__c).format(CEE_Utility.TIME_FORMAT_EBC);
        //Cover EBC use case - primary site timezone
        } else {
            siteStartTime = CEE_Utility.convertUserTimeToUTC(input, userZone, 
                siteZone).format(CEE_Utility.TIME_FORMAT_EBC);
        }    
        
        return siteStartTime;
    }
    // This Future method to get the Cisco corporate directory to name , title.
    @future(callout=true)
    public static void updateTitleName(list<Id> attendeeIds){
        list<CEE_Attendee__c> lstAttendess = [select Name,Title__c,Email__c from CEE_Attendee__c  where id =: attendeeIds and Salesforce_User__c = null];
        list<CEE_Attendee__c> lstUpdateData = new list<CEE_Attendee__c>();
        try{
	        for(CEE_Attendee__c cAtt : lstAttendess){
	            string Cecid = cAtt.Email__c;
	            if( cAtt.Email__c != null && (Cecid.contains('@cisco.com') == true ||Cecid.contains('@CISCO.COM') == true ))
	            {               
	                String cec = Cecid.substring(0,Cecid.indexOf('@')).trim().toLowerCase();
	                if((Cecid.substring(Cecid.indexOf('@'))=='@CISCO.COM'||Cecid.substring(Cecid.indexOf('@'))=='@cisco.com')
	                    && Cecid.substring(Cecid.indexOf('@')).length()== 10 && !Cecid.substring(0,Cecid.indexOf('@')).contains(' ')
	                    && cec != null && cec!= '')
	                {
	                    Map<string,string> mpCiscoContat = CEE_Utility.getCisoContactdetails(cec);
	                    cAtt.name = mpCiscoContat.get('CiscoContactName');
	                    cAtt.Title__c = mpCiscoContat.get('CiscoContactTitle');
	                    lstUpdateData.add(cAtt);
	                }
	            }
	        }
	        if(!lstUpdateData.isEmpty()){
	            update lstUpdateData;
	        }
        }
	    catch(exception ex){
	       system.debug('Error on load data'+ex.getStackTraceString());
	    }
        
    }
    /*@method:This code is used to get cisco contact details from ciscoi directory based on CEC id, return map*/
    public Static map<string,string> getCisoContactdetails(String fromCecVal) {

        String fromCecId = fromCecVal;
        Double trnId = Math.random();
        String sMethod = 'userUnifiedDetails';
        String responseBody;
        String url = HRMSUrl + sMethod; 
        system.debug('--->'+HRMSPassowrd);
        Blob credentials = Blob.valueOf(HRMSUserName +':'+ HRMSPassowrd);
        
        String auth = 'Basic '+EncodingUtil.base64Encode(credentials);
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setHeader('content-type', 'text/xml; charset=utf-8'); 
        req.setHeader('SOAPAction', sMethod);
        req.setHeader('Authorization',auth );
        
        String reqBody =  '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.service.presence.uc.cisco.com">   <soapenv:Header/>   <soapenv:Body>      <ws:userList>     <ws:appId>DFT</ws:appId>    <ws:appKey>dummy</ws:appKey>          <ws:trnId>'+trnId+'</ws:trnId>          <ws:clientAppTimeinGMT>2 May 2011 09:41:41 GMT</ws:clientAppTimeinGMT>          <ws:user>             <ws:cecId>'+fromCecId+'</ws:cecId>             <ws:fromCecId>'+fromCecId+'</ws:fromCecId>             <ws:pStatus/>             <ws:pStatusImgUrl/>          </ws:user>       </ws:userList>    </soapenv:Body> </soapenv:Envelope>';
        
        req.setBody(reqBody);
        
        HttpResponse res;
        
        // TSN June Release will provide exception handling , if webservice is down. 
        // The following changes will return null, if webservice is down. 
        
        try{        	
             	res = h.send(req);
        }
        catch (Exception e){
            System.debug('>>>>' +e);
            return null;
        }
        responseBody = res.getBody().trim();
        Integer statusCode=res.getStatusCode();                
        
        if(statusCode == 200){
        
        Dom.Document doc = res.getBodyDocument();
        Dom.XMLNode address = doc.getRootElement();
        Dom.XMLNode Body = address.getChildElements()[0];
        
        List<String> user_createResult = new List<String>();
        
        Case c1 = new Case();
        map<string,string> mpData = new map<string,string>();
        
        for(Dom.XMLNode child : Body.getChildElements()) {
            for(Dom.XMLNode subchild : child.getChildElements()) {
                for(Dom.XMLNode subchild1 : subchild.getChildElements()){
                    
                    if(subchild1.getName() == 'name' ||subchild1.getName() == 'title'||subchild1.getName() == 'flexField7')
                    user_createResult.add(subchild1.getText());
                    
                    if(subchild1.getName() == 'name' && (subchild1.getText()!= '' && subchild1.getText()!= null))
                    {
                        mpdata.put('CiscoContactName',subchild1.getText());
                       
                    }
                    else if(subchild1.getName() == 'title' && (subchild1.getText()!= '' && subchild1.getText()!= null))
                    {
                        mpdata.put('CiscoContactTitle',subchild1.getText());                                                
                    }
                                      
                }     
            }
        }
           return mpdata;
        }
        return null;
        }
}