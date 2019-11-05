@isTest
public class NGCC_fetch_Picklist_Options_Cntrl_Test {
@isTest
    public static void getselectOptionsTest(){
        Map<String, String> options = NGCC_fetch_Picklist_Options_Controller.getselectOptions('Lead','Customcountry__c');
        system.assertEquals(true, options.size()>0);
    }
        
}