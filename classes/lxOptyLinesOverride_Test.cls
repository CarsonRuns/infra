@isTest
public class lxOptyLinesOverride_Test {

    static testMethod void TestGetquery(){
        
        lxOptyLinesOverrideCtrl OptyLinesObj = new lxOptyLinesOverrideCtrl();
        lxOptyLinesOverrideCtrl.getQueryString('', '');
        lxOptyLinesOverrideCtrl.getQueryString('', 'Lead');

        
    }
}