public class noteExtension {
    private final Lead led;
    
    public noteExtension(ApexPages.StandardController controller) {
    led = [select id, QAPartner__c from Lead where id=:ApexPages.currentPage().getParameters().get('id')];
    }
    
    public String getGreeting() {
        if(led.QAPartner__c == 'NA' || led.QAPartner__c == '' || led.QAPartner__c == 'Not Applicable' || led.QAPartner__c == '-' || led.QAPartner__c == NULL){
            return null;
        }
        else{
            return 'Please note the prefered partner is: ' + led.QAPartner__c;
        }
    } 
    
}