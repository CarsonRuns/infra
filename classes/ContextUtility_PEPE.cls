/* This class has been deveoped by PEPE Dev team for May 2014 Release.
   This class contains the method and context variables which have been used to stop recurring 
   behaviour of Trigger.

   This class is updated by Meghna for Oct 2015 release.
   The changes include are commented with "added by Meghna 21-Sep-2015"

*/

public class ContextUtility_PEPE {
    
    public static final String LEARNING_PARTNER_BEING_CONTACTED = 'Learning Partner being contacted';
    public static final String REQUESTED = 'Requested';
    public static final String ADDED_INTO_CART = 'Added into cart'; 
    public static final String QUOTE_ACCEPTED = 'Quote Accepted';
    public static final String LOGISTICS_CONFIRMED = 'Logistics Confirmed';
    public static final String DELIVERED = 'Delivered';
    public static final String CLOSED = 'Closed';
    public static final String EVENT_APPROVED = 'Event Approved';
    public static final String LP_BEING_CONTACTED = 'LP being contacted';           
    public static final String AWAITING_REQUESTORS_CONFIRMATION = 'Awaiting Requestor\'s confirmation';
    public static final String INSTRUCTOR_BEING_CONTACTED = 'Instructor being contacted';
    public static final String EVENT_CANCELLED_BUT_PAID = 'Event Cancelled but Paid';
    public static final String EVENT_CANCELLED = 'Event Cancelled';
    //added by Meghna 30-JUL-2015
    public static final String EXPIRED = 'Expired';
    
    public static final String PLATFORM_PARTNER_PLUS = 'Partner Plus';
    public static final String PLATFORM_ARCHITECTURE = 'Architectures';
    public static final String PLATFORM_PARTNER_PLUS_LOUNGE = 'Partner Plus Lounge';
     public static final String REQUEST_REJECTED = 'REQUEST REJECTED';
     
      
    
    //Difing static context variable
    private static boolean firstRun = true;

    //difining method to get the context variable 
    public static boolean isFirstRun() {
        return firstRun;
    }
    
    //difining method to set the context variable False
    public static void setFirstRunFalse(){
        firstRun = false;
    }
    
    //difining method to set the context variable true
    public static void setFirstRunTrue(){
        firstRun = true;
    }
    
    //defining Constructor
    public ContextUtility_PEPE (){      
    }
     
    //This Method will update the parent TR fields from child LP records 
    public void updateQuoteFields (PEPE_Training_Request__c trRec,PEPE_Learning_Partner__c l1) {
            trRec.Status__c =  AWAITING_REQUESTORS_CONFIRMATION;
            trRec.Learning_Partner_Name__c = l1.Learning_Partner_Name__c;
            trRec.Local_Learning_Partner_Name__c = l1.Local_Learning_Partner_Name__c;
            trRec.Delivered_by_Local_Learning_Partner__c = l1.Delivered_by_Local_Learning_Partner__c;
            trRec.Instructor_Names__c = l1.Instructor_Name__c;
            trRec.Learning_Partner_Country__c = l1.Learning_Partner_Country__c;
            trRec.Instructors_Contact_Details__c = l1.Instructor_Contact_Details__c;
            trRec.Instructor_Email__c = l1.Instructor_Email__c; //added by Meghna on 6-Aug , new field data capture
            trRec.Actual_Start_Date__c = l1.Suggested_Date__c;
            trRec.Status_Comments__c = l1.Alternative_Suggested_Date__c;
            trRec.Alternate_Language__c = l1.Alternate_Language__c;
            trRec.Delivery_in_Preferred_Language__c = l1.Delivery_in_Preferred_Language__c;
            trRec.Learning_Partner_Cost__c = l1.Learning_Partner_Cost__c;
            trRec.Catering_Vendor_Agency_Cost__c = l1.Catering_and_Vendor_Cost__c;
            trRec.VAT__c = l1.VAT__c;
            trRec.DW_Cost__c = l1.DW_Cost__c; //added by Meghna on 21-Sep-15, new field DW_Cost__c data capture
    }
    
    //This method will nullify all the quote fields from parent TR when Quote has been revised on child
    public void emptyQuoteFields (PEPE_Training_Request__c trRec) {
            if(trRec.Training_Offering_Id__r.Platform__c == PLATFORM_PARTNER_PLUS ){
                trRec.Status__c = LEARNING_PARTNER_BEING_CONTACTED;
            }
            else{
                trRec.Status__c = INSTRUCTOR_BEING_CONTACTED;
            }
            
            trRec.Learning_Partner_Name__c = '';
            trRec.Local_Learning_Partner_Name__c = '';
            trRec.Delivered_by_Local_Learning_Partner__c = 'No';
            trRec.Instructor_Names__c = '';
            trRec.Learning_Partner_Country__c = '';
            trRec.Instructors_Contact_Details__c = '';
            trRec.Actual_Start_Date__c = null;
            trRec.Status_Comments__c = '';
            trRec.Alternate_Language__c = '';
            trRec.Delivery_in_Preferred_Language__c = 'Yes'; 
            trRec.Learning_Partner_Cost__c = null;
            trRec.Catering_Vendor_Agency_Cost__c = null;
            trRec.VAT__c = null;
            //added by Meghna 21-Sep-2015
            trRec.Instructor_Email__c = null;
            trRec.DW_Cost__c = null;
    }
    
    //This method is used for catching org the prod or non-prod
    
    final static String Prod_Id = '00D300000000QUuEAM';
    private static Integer org_flag = 0;
    
    public static Integer getOrgValue(){
        if(UserInfo.getOrganizationId()!= Prod_Id){
            org_flag = 1;
        }
        return org_flag;
    }
    
    //This method is to pull the email alias for the learning partner
    public static String getEmailAlias(String lpName){
        String lpEmail='';
        List<PEPE_LP_Emails__c> lps = PEPE_LP_Emails__c.getall().values();
        for(PEPE_LP_Emails__c l:lps){
            if(l.Name == lpName){
                if(getOrgValue()==0){
                    lpEmail = l.Prod_Email_Alias__c;
                }
                else{
                    lpEmail = l.Non_Prod_Email_Alias__c;
                }
            }
        }
        return lpEmail;
    }
    
    //This method used for creating the Learning Partner Records based on TE PLP values
    public static PEPE_Learning_Partner__c createLearningPartner(PEPE_Training_Request__c tr, String lpName, String lpbc, Decimal cost){
        
        if(lpName!=null ){
            system.debug('@@@ Inside ContextUtility Lp Creation'+ lpName);
            PEPE_Learning_Partner__c lp = new PEPE_Learning_Partner__c();
            lp.Learning_Partner_Name__c = lpName;
            lp.Training_Request_Id__c = tr.id;
            lp.Estimated_Cost__c = cost;
            lp.Status__c = lpbc;
            lp.PLP_Email_Alias__c = getEmailAlias(lp.Learning_Partner_Name__c);
            return lp;
        }
        else{
            return null;
        }
    }

    public static void OnTRBeforeUpdate(List<PEPE_Training_Request__c> trs, Map<Id,PEPE_Training_Request__c> newMap)
    {
        
        for(PEPE_Training_Request__c t: trs){
            if(t.Training_Offering_Id__r.Platform__c == PLATFORM_PARTNER_PLUS  || t.Training_Offering_Id__r.Platform__c == PLATFORM_ARCHITECTURE ){
                system.debug('@@@ FIRST t.Status__c'+ t.Status__c +'t.Training_Offering_Id__c : '+t.Training_Offering_Id__c );    
                if((t.Status__c == LEARNING_PARTNER_BEING_CONTACTED || t.Status__c == REQUESTED || t.Status__c == INSTRUCTOR_BEING_CONTACTED) && t.Training_Offering_Id__c != null){
                    system.debug('@@@ SECOND t.Status__c'+ t.Status__c +'t.Training_Offering_Id__c : '+t.Training_Offering_Id__c );    
                    system.debug('@@@ SECOND t.PLP_Email_Field_01__c'+ t.PLP_Email_Field_01__c +' t.Training_Offering_Id__r.Potential_Learning_Partner_01__c : '+ t.Training_Offering_Id__r.Potential_Learning_Partner_01__c);    
                    if(t.PLP_Email_Field_01__c == null && t.Training_Offering_Id__r.Potential_Learning_Partner_01__c!='' ){
                        t.PLP_Email_Field_01__c = getEmailAlias(t.Training_Offering_Id__r.Potential_Learning_Partner_01__c);
                        newMap.get(t.ID).PLP_Email_Field_01__c =  t.PLP_Email_Field_01__c;
                    }
                    if(t.PLP_Email_Field_02__c == null && t.Training_Offering_Id__r.Potential_Learning_Partner_02__c!=''){
                        t.PLP_Email_Field_02__c = getEmailAlias(t.Training_Offering_Id__r.Potential_Learning_Partner_02__c);
                        newMap.get(t.ID).PLP_Email_Field_02__c =  t.PLP_Email_Field_02__c;
                    }
                    if(t.PLP_Email_Field_03__c == null && t.Training_Offering_Id__r.Potential_Learning_Partner_03__c!=''){
                        t.PLP_Email_Field_03__c = getEmailAlias(t.Training_Offering_Id__r.Potential_Learning_Partner_03__c);
                        newMap.get(t.ID).PLP_Email_Field_03__c =  t.PLP_Email_Field_03__c;
                    }
                }
            }
        }
        
    }  
   
    public static PEPE_Learning_Partner__c setLPS(PEPE_Learning_Partner__c l, PEPE_Training_Request__c t){
        
   
    // Added by Meghna on 30-JUL-2015       
     if(l.Training_Request_Id__c == t.id && l.QUOTE_ACCEPTED_FLAG__c == 'Y' && 
     ((t.Status__c == EVENT_APPROVED) || (t.Status__c == LOGISTICS_CONFIRMED) || (t.Status__c == DELIVERED) || 
     (t.Status__c == CLOSED) || (t.Status__c == EVENT_CANCELLED_BUT_PAID) || (t.Status__c == EVENT_CANCELLED)|| (t.Status__c == EXPIRED))){
            l.Status__c = t.Status__c;
        }
        
        return l;
    }
    
   
    
}