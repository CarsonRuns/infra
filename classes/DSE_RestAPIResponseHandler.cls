/*********************************************************************************************************************************
Name    : DSE_RestAPIResponseHandler 
Author  : Mukesh Srivastava
Purpose : REST API response handler 
Created Date:  1/18/2016 
Modification History: 
                      
**********************************************************************************************************************************/
global class DSE_RestAPIResponseHandler {
    
    //List of custom attributes that we want to check the status of the org
    public String status {get; set;}
    public List<sObject> data {get;set;}
    public Integer totalrecords {get;set;}
    public String message {get;set;}
    public boolean success {get; set;}
}