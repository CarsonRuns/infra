@RestResource(urlMapping='/p360mobility/AssignPartner/*')
global with sharing class P360_mobility_partner_assign_API{

    @HttpGet
    global static Partner_Assign_Response getPartnerList(){
        /*
        Return all records
        String off = RestContext.request.params.get('offset');
        */
        
        //in .mon sandbox
        String channel_recordTypeId = '0123000000004aVAAQ'; 
        
        String lm = RestContext.request.params.get('limit');
        String leadid = RestContext.request.params.get('id');
        String searchString = RestContext.request.params.get('search');
        String country = RestContext.request.params.get('country');
        
        Integer lim = Integer.valueOf((lm==null?'200':lm));
        String queryCondition = (searchString ==null?' ':'AND Name LIKE \'' +searchString+ '%\'');
        String countryCondition = (country==null?' ':' AND CRCountry__c = \''+country+'\' ');
        
        List<Lead> leads = [SELECT Partner_Lead_Status__c, Funding_Source__c, QAPartner__c, Recommended_Mapped_Partners__c, End_Customer_Account__c, End_Customer_Account__r.Incumbent_Partner_Status__c FROM Lead where id = :leadid];

        if(leads.size() < 1){
            return new Partner_Assign_Response('Error', 'Lead not found for your visibility', 0, null);
        }
        Lead lead = leads.get(0);
        
        if('Deal Created'.equals(lead.Partner_Lead_Status__c)){
            return new Partner_Assign_Response('Success', 'Partner cannot be changed for Leads that in "Deal Created" status', 0, null);
        }

        //if partner funded or joint funded        
        if('PARTNER-FUNDED'.equals(lead.Funding_Source__c)||'JOINT-FUNDED'.equals(lead.Funding_Source__c)){
            return new Partner_Assign_Response('Success', 'Partner cannot be changed for Leads that are not Cisco-Funded', 0, null);
        }
        //cisco funded lead that's with End customer account that's GREEN or YELLOW
        if(lead.End_Customer_Account__c != null ){
            if('GREEN'.equals(lead.End_Customer_Account__r.Incumbent_Partner_Status__c)||'YELLOW'.equals(lead.End_Customer_Account__r.Incumbent_Partner_Status__c)){
                Account end_cust= [SELECT id, Allocated_Partner_1__c, Allocated_Partner_2__c, Allocated_Partner_3__c, Allocated_Partner_4__c FROM Account Where id = :lead.End_Customer_Account__c];                      

                List<Account> recommendedPartners = [SELECT id, Name, Phone, Website, CRAddressLine1__c, CRAddressLine2__c, CRCity__c, CRCountry__c, CRState__c, CRZipPostalCode__c FROM Account WHERE id IN (:end_cust.Allocated_Partner_1__c, :end_cust.Allocated_Partner_2__c, :end_cust.Allocated_Partner_3__c, :end_cust.Allocated_Partner_4__c)];
                
                return new Partner_Assign_Response('Success', 'OK' , recommendedPartners.size(),recommendedPartners);
            }
        }
        //Cisco funded lead with no end-customer account or RED account
        
        String soql = 'SELECT id, Name, Phone, Website, CRAddressLine1__c, CRAddressLine2__c, CRCity__c, CRCountry__c, CRState__c, CRZipPostalCode__c  FROM account WHERE Partner_Assignment_Eligible__c > 0 AND Partner_Account_Status__c = \'Active (Registered)\' AND RecordTypeId = \''+channel_recordTypeId+'\' '+ countryCondition +' '+queryCondition+' LIMIT :lim';
        System.Debug(soql);
        List<Account> recommendedPartners = Database.query(soql);
        return new Partner_Assign_Response('Success', 'OK' , recommendedPartners.size(),recommendedPartners);
    }
    
    global class Partner_Assign_Response{
        global String success;
        global String message;
        global Integer total;
        global List<Account> records;
        
        global Partner_Assign_Response(String success, String message, Integer total, List<Account> records) {
            this.success = success;
            this.message = message;
            this.total = total;
            this.records = records;
        }
    }
    
    @isTest(SeeAllData=true)
    public static void testGetPSRUsers(){
    
        
        RestResponse res = new RestResponse();
        
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/services/apexrest/p360mobility/AssignPartner/';
        RestContext.request.addParameter('offset', '0');
        RestContext.request.addParameter('id', GenericStaticTestData.gettesteLeadRecord().id);
        RestContext.request.addParameter('limit', '200');

        
        Partner_Assign_Response results = P360_mobility_partner_assign_API.getPartnerList();
        
        System.debug('::::results.records is::::'+results.records);
        
        System.assertEquals('Success', results.success);        
    }

}