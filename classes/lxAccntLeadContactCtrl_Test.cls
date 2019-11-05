@isTest
public class lxAccntLeadContactCtrl_Test {

    static testMethod void TestGetquery(){
    
        lxAccntLeadContactController lxAccntLeadCtrlObj = new lxAccntLeadContactController ();
        lxAccntLeadContactController.getQueryString('','');
        lxAccntLeadContactController.getQueryString('','Account');

        
    }
}