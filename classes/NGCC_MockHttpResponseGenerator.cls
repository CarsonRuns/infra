/************************************************************************************************************************************
Name    : NGCC_MockHttpResponseGenerator
Author  : Ghattamaneni Chaithanya
Purpose : This class is a mock Http callout class for NGCC_SendSMSExtn_Test class.
Created Date: 03 Jan 2018
Modification History: 

*************************************************************************************************************************************/

@isTest
global class NGCC_MockHttpResponseGenerator implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {        
        // Creating a fake response
        if(req.getEndpoint().endsWith('getssosession/non-kerberos.html')){
            HttpResponse res = new HttpResponse();
            res.setHeader('Set-Cookie', 'ObSSOCookie=XwHE%2FVnE4m8E3eoDet9wJnWlS1i9nq%2Fl9vD%2F1ZuPolRozBPt31jKi0FF3BhVKXx3sI8wkqQ9cv0J49dc4D0CRaWRD%2B%2Bs6AUL1dgfBt7BsoRyAoYNAql%2FmJFYovNDOacJAIvSlOq7noqr4VIw2u6cysfpH%2Fba3S2V4dB8uxNcC7efPYXsnPjB75ykr4fwIdH12F7EBvKthdd20cL4XXA58iLFR68JU5eDH2VWZ%2BizQQoy5xyviYZA60TGSxI%2FT9BsKB75BuqnC1yBU3BqzrBgDA5OTq1DHCIO5Uy5llxjDrFN78glUsK8hfAogqVhWwy4RLEq8P0p4JAdjG5Pqwg18AHjz33ayJdJhzQqXM6bTGGlLBYgiaGTtFfMabjU6yuNop1VSKUDRk0aNr2XmCZeRg%3D%3D; path=/; domain=.cisco.com');
            res.setStatusCode(200);
            res.setStatus('OK');
            return res;
        }
        else{
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setStatus('OK');
            return res;
        }
    }
}