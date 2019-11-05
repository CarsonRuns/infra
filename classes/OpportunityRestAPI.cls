/*
Author : Cisco
Release : June 14, 2019 Release
Functionality : this class stores the details of an opportunity for CCE Integration

Modification History:
Itrack# Date Author Change
US251274 - CCE Punchout Link
*/
global class OpportunityRestAPI {

    public class OpportunityContactDetails {
        /* this apex class stores the details of an opportunity based on deal id */
        public String dealId {get;set;}
        public String status {get;set;}
        public String name {get;set;}
        public String owner {get;set;}
        public String createdBy {get;set;}
        public String orgName {get;set;}
        public Decimal annualRevenue {get;set;}
        public Decimal numOfEmployees {get;set;}
        public String industry {get;set;}
        public String addressLine1 {get;set;}
        public String addressLine2 {get;set;}
        public String city {get;set;}
        public String state {get;set;}
        public String country {get;set;}
        public String phone {get;set;}
        public String fax {get;set;}
        public String zipCode {get;set;}
        public BusinessContact businessContact {get;set;}
        public BillingContact billingContact {get;set;}
    }

    public class BillingContact {
        /* this apex class stores the billing contact details of an opportunity */
        public String phone {get;set;}
        public String jobFunction {get;set;}
        public String department {get;set;}
        public String email {get;set;}
        public String lastName {get;set;}
        public String firstName {get;set;}
        public Boolean isPrimary {get;set;}
        
    }

    public class BusinessContact {
        /* this apex class stores the business contact details of an opportunity */
        public String phone {get;set;}
        public String jobFunction {get;set;}
        public String department {get;set;}
        public String email {get;set;}
        public String lastName {get;set;}
        public String firstName {get;set;}
        public Boolean isPrimary {get;set;}
        
    }

      public class Error { 
        /* this apex class stores the errors occuring in the opportunity REST API call */
         public String errorCode {get;set;}
        public String message {get;set;}
    } 

}