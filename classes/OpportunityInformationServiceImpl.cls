/*
Author : Cisco
Release : June 14, 2019 Release
Functionality : Service implementation class to send opportunity details to CCE

Modification History:
Itrack# Date Author Change
US251274 - CCE Punchout Link
*/

public class OpportunityInformationServiceImpl implements OpportunityInformationService {

    /* method to return opportunity information based on the deal id passed */
    public void getOpportunityInfoByDealId (RestResponse restResponse, String opportunityDealId) {
        String contentType = null;
        List<OpportunityRestAPI.OpportunityContactDetails> opportunityContactDetailsList = null;
        List<Opportunity> opportunities = null;
        List<OpportunityContactRole> billingContactList = null;
        List<OpportunityContactRole> businessContactList = null;
        OpportunityRestAPI.OpportunityContactDetails opportunityContactDetails = null;
        OpportunityRestAPI.BillingContact billingContact = null;
        OpportunityRestAPI.BusinessContact businessContact = null;
        OpportunityRestAPI.Error error = new OpportunityRestAPI.Error();
        List<OpportunityRestAPI.Error> invalidDealErrorList = new List<OpportunityRestAPI.Error>();

        Opportunity_Rest_API_Properties__c contentTypeProp = Opportunity_Rest_API_Properties__c.getInstance('Content-Type');
        if(contentTypeProp != null) {
            contentType = String.valueOf(contentTypeProp.Value__c);
        }

        Opportunity_Rest_API_Properties__c errorCodeInvalidDealIdProp = Opportunity_Rest_API_Properties__c.getInstance('Error Code - Invalid Deal Id');
        if(errorCodeInvalidDealIdProp != null) {
            error.errorCode = String.valueOf(errorCodeInvalidDealIdProp.Value__c);
        }

        Opportunity_Rest_API_Properties__c errorMessageInvalidDealIdProp = Opportunity_Rest_API_Properties__c.getInstance('Error Message - Invalid Deal Id');
        if(errorMessageInvalidDealIdProp != null) {
            error.message = String.valueOf(errorMessageInvalidDealIdProp.Value__c);
        }

        restResponse.addHeader('Content-Type', contentType);
        opportunityContactDetailsList = new List<OpportunityRestAPI.OpportunityContactDetails>();
        try {
            System.debug(LoggingLevel.INFO, 'Retrieving opportunity details for deal id : ' + opportunityDealId);

            /* getting opportunities using deal id */
            opportunities = [SELECT Id , Name, Owner.Name, CreatedBy.Name, Website__c,  Account.Number_Of_Employees__c, Revenue__c, Account.Name, Address_Line_2__c, Account.Country__c, City__c, Account.Fax, Account.Phone, Account.Source_Account_ID__c, Account.Industry, Account.AnnualRevenue , Account.AddressLine1__c, Account.AddressLine2__c, Account.State__c, Account.City__c, Account.ZipPostalCode__c, StageName FROM Opportunity WHERE DealID__c = :opportunityDealId];

            /* if there are no opportunities */
            if (opportunities.isEmpty()) {
                System.debug(LoggingLevel.INFO, 'No opportunity details exist for deal id : ' + opportunityDealId);
                invalidDealErrorList.add(error);
                restResponse.responseBody = Blob.valueOf(JSON.serialize(invalidDealErrorList));

                Opportunity_Rest_API_Properties__c httpStatusCodeBadRequestProp = Opportunity_Rest_API_Properties__c.getInstance('HTTP Status Code - Bad Request');
                if(httpStatusCodeBadRequestProp != null) {
                    restResponse.statusCode = Integer.valueOf(httpStatusCodeBadRequestProp.Value__c);
                }
                return ;
            }else{
            System.debug(LoggingLevel.INFO, 'Opportunity details for deal id : ' + opportunityDealId + ' retrieved.');
            opportunityContactDetails = new OpportunityRestAPI.OpportunityContactDetails();

            opportunityContactDetails.dealId = opportunityDealId;
            opportunityContactDetails.name = opportunities[0].Name;
            opportunityContactDetails.owner = opportunities[0].Owner.Name;
            opportunityContactDetails.createdBy = opportunities[0].CreatedBy.Name;
            opportunityContactDetails.orgName = opportunities[0].Account.Name;
            opportunityContactDetails.annualRevenue = opportunities[0].Account.AnnualRevenue;
            opportunityContactDetails.numOfEmployees = opportunities[0].Account.Number_Of_Employees__c;
            opportunityContactDetails.industry = opportunities[0].Account.Industry;
            opportunityContactDetails.addressLine1 = opportunities[0].Account.AddressLine1__c;
            opportunityContactDetails.addressLine2 = opportunities[0].Account.AddressLine2__c;
            opportunityContactDetails.city = opportunities[0].Account.City__c;
            opportunityContactDetails.state = opportunities[0].Account.State__c;
            opportunityContactDetails.phone = opportunities[0].Account.Phone;
            opportunityContactDetails.fax = opportunities[0].Account.Fax;
            opportunityContactDetails.zipCode = opportunities[0].Account.ZipPostalCode__c;
            opportunityContactDetails.status =  (opportunities[0].StageName).subString(4);
            
            if((opportunities[0].Account.Country__c).length() > 2) {
                Country_Names__c  countryNameValue = Country_Names__c.getInstance((opportunities[0].Account.Country__c).toUpperCase());
                opportunityContactDetails.country = countryNameValue.Value__c;
            } else {
                opportunityContactDetails.country = opportunities[0].Account.Country__c;
            }
            }
            System.debug(LoggingLevel.INFO, 'Retrieving billing and business contact details for the opportunity...');
            businessContactList = [SELECT Contact.Id, Contact.Firstname, contact.Lastname, Contact.JobFunction__c, Contact.Email, Contact.Department, Contact.Fax, Contact.Phone, Contact.MobilePhone, Role, isPrimary FROM OpportunityContactRole WHERE Opportunityid =  :opportunities[0].Id];
            System.debug(LoggingLevel.INFO, 'businessContactList size() '+businessContactList.size());
            if(businessContactList!= null && businessContactList.size() > 1){
                for(OpportunityContactRole businessContactDetails : businessContactList){
                    if(businessContactDetails.IsPrimary == true){
                        businessContact = new OpportunityRestAPI.BusinessContact();
                        businessContact.phone = businessContactDetails.Contact.Phone;
                        businessContact.jobFunction = businessContactDetails.Contact.JobFunction__c;
                        businessContact.department = businessContactDetails.Contact.Department;
                        businessContact.email = businessContactDetails.Contact.Email;
                        businessContact.lastName = businessContactDetails.Contact.Lastname;
                        businessContact.firstName = businessContactDetails.Contact.Firstname;
                        businessContact.isPrimary = businessContactDetails.IsPrimary;
                    }
                }
            }
            
            if(businessContactList != null && !businessContactList.isEmpty() && businessContact == null) {
                System.debug(LoggingLevel.INFO, 'Business contact details retireved for the opportunity.');
                businessContact = new OpportunityRestAPI.BusinessContact();
                businessContact.phone = businessContactList[0].Contact.Phone;
                businessContact.jobFunction = businessContactList[0].Contact.JobFunction__c;
                businessContact.department = businessContactList[0].Contact.Department;
                businessContact.email = businessContactList[0].Contact.Email;
                businessContact.lastName = businessContactList[0].Contact.Lastname;
                businessContact.firstName = businessContactList[0].Contact.Firstname;
                businessContact.isPrimary = businessContactList[0].IsPrimary;
                
            }

            opportunityContactDetails.billingContact = billingContact;
            opportunityContactDetails.businessContact = businessContact;
            opportunityContactDetailsList.add(opportunityContactDetails);
            restResponse.responseBody = Blob.valueOf(JSON.serialize(opportunityContactDetailsList));
            restResponse.addHeader('Content-Type', contentType);

            Opportunity_Rest_API_Properties__c httpStatusCodeOKProp = Opportunity_Rest_API_Properties__c.getInstance('HTTP Status Code - OK');
            if(httpStatusCodeOKProp != null) { 
                restResponse.statuscode = Integer.valueOf(httpStatusCodeOKProp.Value__c);
            }

            System.debug(LoggingLevel.INFO, 'Opportunity information retrieved.');
        } catch (Exception e) {
            error.errorCode = e.getTypeName();
            error.message = e.getMessage();
            System.debug(LoggingLevel.ERROR, 'Error code : ' + error.errorCode);
            System.debug(LoggingLevel.ERROR, 'Error message : ' + error.message);
            System.debug(LoggingLevel.ERROR, 'Error stack trace : ' + e.getStackTraceString());
            invalidDealErrorList.add(error);
            restResponse.responseBody = Blob.valueOf(JSON.serialize(invalidDealErrorList));

            Opportunity_Rest_API_Properties__c httpStatusCodeServerErrorProp = Opportunity_Rest_API_Properties__c.getInstance('HTTP Status Code - Server Error');
            if(httpStatusCodeServerErrorProp != null) {
                restResponse.statuscode = Integer.valueOf(httpStatusCodeServerErrorProp.Value__c);
            }
        }
    }
}