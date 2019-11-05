@isTest
public class AttritionReasonCodeTest {
    static testMethod void testMethodAttritionCode(){
       
        ApexPages.standardController cn = new ApexPages.standardController(new Opportunity());
        AttritionReasonCode arc = new AttritionReasonCode(cn);
    }
}