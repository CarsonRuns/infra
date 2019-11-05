public with sharing class Request_Resource_Edit_CTE {
    public Boolean error {get; protected set;}
    public String errorMsg {get; protected set;}
    public PageReference iframeUrl {get; protected set;}
    private List<String> fieldsToRetrieve = new List<String>{'Id', 'Opportunity_Name__c'};
    /*June 2018 Lightning Release change: end*/  
    /*From summer 2018 SFDC release, in Lightning Experience, override button from related list(Request Resource) 
      is not given master record(opportunity) from salesforce, so this fix is passing opptyId as parameter from URL*/
    String opptyId = ApexPages.currentPage().getParameters().get('opptyId');
    String resourceRequestId = ApexPages.currentPage().getParameters().get('id');
    /*June 2018 Lightning Release change: end*/  

    private void setError(String message) {
        this.error    = true;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, message));
    }

    public Request_Resource_Edit_CTE(ApexPages.StandardController stdController) {
        this.error = false;

        if (!Test.isRunningTest()) {
            stdController.addFields(fieldsToRetrieve);
        }
        /*June 2018 Lightning Release change: start*/
        // Resource_Request_Assignment__c resourceRequestAssignment = (Resource_Request_Assignment__c)stdController.getRecord();
        /*in case 'Create New Quote' is clicked from Opportunity record detail page, opptyId is passed as parameter from URL, create a 
        Resource_Request_Assignment__c object*/
        Resource_Request_Assignment__c  resourceRequestAssignment = null;
        if (opptyId != null && !(String.isBlank(opptyId)) ){                    
            resourceRequestAssignment = new Resource_Request_Assignment__c();       
            resourceRequestAssignment.Opportunity_Name__c = opptyId;
             if (resourceRequestid != null && !(String.isBlank(resourceRequestid)) ){             
                resourceRequestAssignment.id = resourceRequestid; 
            }
        }
        else{
            resourceRequestAssignment = (Resource_Request_Assignment__c)stdController.getRecord();
        }
         /*June 2018 Lightning Release change: end*/
        //check data and generate url
        if (resourceRequestAssignment == null || resourceRequestAssignment.id == null) {
            setError('Missing object Id');
        } else {
            List<Opportunity> opportunities = [SELECT Id, Territory2Id FROM Opportunity WHERE Id =: resourceRequestAssignment.Opportunity_Name__c];
            if (opportunities == null || opportunities.size() == 0) {
                setError('Invalid opportunity Id');
            } else {
                String baseUrl   = Utilities.getConstant_CS('wwwin-tools');
                String hostname  = Url.getSalesforceBaseUrl().toExternalForm();
                User u = [SELECT Salesforce_API_Session__c FROM User WHERE Id =: UserInfo.getUserId()];

                this.iframeUrl                    = new PageReference(baseUrl + 'WWSPS/SECCI/protected/specialization.do');
                Map<String, String> urlParameters = this.iframeUrl.getParameters();
                urlParameters.put('action',       'showEditPage');
                urlParameters.put('sessionId',    u.Salesforce_API_Session__c);
                urlParameters.put('cancelURL',    hostname + '/' + resourceRequestAssignment.Opportunity_Name__c);
                urlParameters.put('apiServerUrl', hostname + '/services/Soap/u/45.0/' + UserInfo.getOrganizationId().substring(0,15));
                urlParameters.put('userId',       UserInfo.getUserId());
                urlParameters.put('userName',     UserInfo.getUserName());
                urlParameters.put('opptyId',      opportunities[0].Id);
                urlParameters.put('territoryId',  opportunities[0].Territory2Id);
                urlParameters.put('reqId',        resourceRequestAssignment.Id);
            }
        }

    }

}