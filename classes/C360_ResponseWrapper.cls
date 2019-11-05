/************************************************************************************************************************************
Name    : C360_ResponseWrapper
Author  : C360 Dev team
Purpose : This is the wrapper class for storing the response from HTTPResponse with connectionStatus
Date    : 28/06/2019
Change History : none
*************************************************************************************************************************************/

public class C360_ResponseWrapper {
    public boolean isConnectionOK;
    public String connectionMessage ;
    public Exception responseException;
    public HttpResponse response ;
    
    //contructor 
    public C360_ResponseWrapper (boolean isError,String errorMsg,HttpResponse response){
        this.isConnectionOK  = isError;
        this.connectionMessage = errorMsg;
        this.response = response;
    }
    // construtor for exception from response
    public C360_ResponseWrapper (Exception e, HttpResponse response){
        this.isConnectionOK  = true;
        this.responseException = e;
        if(e != null) this.connectionMessage = e.getMessage();
        this.response = response;
    }
    
    
}