/*
Author : Cisco
Release : June 14, 2019 Release
Functionality : Controller class to send opportunity details to CCE

Modification History:
Itrack# Date Author Change
US251274 - CCE Punchout Link
*/

@RestResource(urlMapping='/opportunity/*')
global with sharing class RESTOpportunityUsingDealIdController {

    /* Method to return opportunity information based on the deal id passed. */
    @HttpGet
    global static void doGet() {
        System.debug(LoggingLevel.INFO, 'Processing opportunity information...');
        RestRequest restRequest = new RestRequest();
        RestResponse restResponse = RestContext.response;
        String opportunityDealId = null;
        restRequest = RestContext.request;

        opportunityDealId = restRequest.requestURI.substring(restRequest.requestURI.lastIndexOf('/') + 1);
        System.debug(LoggingLevel.INFO, 'Deal ID of the opportunity : ' + opportunityDealId);

        OpportunityInformationService opportunityInformationService = new OpportunityInformationServiceImpl();
        opportunityInformationService.getOpportunityInfoByDealId(restResponse, opportunityDealId); 
    }
}