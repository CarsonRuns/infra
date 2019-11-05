/************************************************************************************************************************************
Name    : C360_Util
Author  : C360 Dev team
Purpose : This class has re-usable methods which can be called from other classes.
Date    : 28/06/2019
Change History : none
*************************************************************************************************************************************/

public class C360_Util{
    public static final string Prod_Org_Id = '00DA0000000H3hnMAC';
    
    // Fetch the API custom setting for passed set_name 
    public static C360_API_Settings__c getConstant(String set_name){
        String data_set_name ='';
        C360_API_Settings__c oc = null;
        
        if((Userinfo.getOrganizationId() == C360_Util.Prod_Org_Id)){
            data_set_name = 'Production'+set_name;
        }
        else{
            data_set_name= 'NonProduction'+set_name;
        }
        try {
            oc = C360_API_Settings__c.getInstance(data_set_name);
        }
        catch(Exception e){
            System.debug(e);
        }                     
        return oc;
    }
    //Convert the List of strings to single string value having two single quotes as prefix and suffix for every string with comma delimiter
    public static String convertListToString(List<String> listString){
        String liStr = '';
        if(listString != null && listString.size() > 0){
            for(String sr :listString){
                liStr+= '\'\''+sr+'\'\''+',';
            }
            if(liStr.trim().endsWith(',')) {
                liStr = liStr.trim().removeEndIgnoreCase(',');
            }           
        }
        return liStr;
    }
    // encoding the string value to replace the characters while doing callout
    public static String encodeString(string strValue){
        String encodedValue ='';
        if(strValue != null && strValue!=''){
            encodedValue= EncodingUtil.urlEncode(strValue, 'UTF-8');
            encodedValue = encodedValue.replace('+','%20');       
        }
        return encodedValue;
    }
}