/*
    Story - US6281
    Release - November 2014
    Author - Bramha, Accenture
    Functionality -  Presenter -- Profile.
*/

@isTest
private class PresenterControllerTest {

    static testMethod void validatePresenter() {
        //Setup Account
        User admin = CEE_TestUtility.getUser('admin', true);
        
        Topic__c topic = CEE_TestUtility.getTopic('exp', true, false);
        Presenter__c expertise = CEE_TestUtility.getExpertise('exp', true);
        CEE_TestUtility.getOtherTopic();
        
        ApexPages.currentPage().getParameters().put('sfdc.userId', expertise.User__c);
        
        ApexPages.StandardController stdItem = new ApexPages.StandardController(expertise);
        PresenterController presoController = new PresenterController(stdItem);
        PresenterController.flsUpdate(Presenter__c.User__c);
        PresenterController.flsGet(Presenter__c.User__c);
        //Utility methods
        presoController.topics();
        presoController.getTopics();
        presoController.getHeaders();
        presoController.updateTopic();
        
        PageReference doSave = presoController.saveExp();
    }

}