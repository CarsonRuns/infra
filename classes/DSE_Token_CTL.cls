/*********************************************************************************************************************************
Name    : DSE_Token_CTL 
Author  : Mukesh Srivastava
Purpose : Rest API for getting the Mule Token from Ping
Created Date:  1/18/2016 
Modification History: 
                      
**********************************************************************************************************************************/
@RestResource(urlMapping='/dsetoken/')
global without sharing class DSE_Token_CTL {

  @HttpGet
  global static void getAuthToken() {
     DSE_Utilities.tokenHttpcallout();
  }
}