/*********************************************************************************************************************************
Name    : DSE_APIOAuthTokenParser
Author  : Mukesh Srivastava
Purpose : JSON Parser for Mule Ping API response 
Created Date:  1/18/2016 
Modification History: 
                      
**********************************************************************************************************************************/
public class DSE_APIOAuthTokenParser{

    public String access_token;
    public String token_type;
    public Integer expires_in;
    
    public static DSE_APIOAuthTokenParser parse(String json) {
        return (DSE_APIOAuthTokenParser) System.JSON.deserialize(json, DSE_APIOAuthTokenParser.class);
    }
}