/*
Author : Cisco
Release : June 14, 2019 Release
Functionality : Service class to send opportunity details to CCE

Modification History:
Itrack# Date Author Change
US251274 - CCE Punchout Link
*/

public interface OpportunityInformationService {

    /* method interface to return opportunity information based on the deal id passed */
    void getOpportunityInfoByDealId(RestResponse restResponse, String opportunitydealId);
}