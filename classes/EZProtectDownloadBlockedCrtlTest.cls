@isTest
private class EZProtectDownloadBlockedCrtlTest {
    static testMethod void prepareNoLinksWhenNoIntegrationUser() {
        ApexPages.currentPage().getParameters().put('type', 'Dirty');
        EZProtectDownloadBlockedCrtl ctrl = new EZProtectDownloadBlockedCrtl();
        
        ApexPages.currentPage().getParameters().put('type', 'Pending');
        
        ctrl = new EZProtectDownloadBlockedCrtl();
 		
        Map<String, String> message = EZProtectDownloadBlockedCrtl.getBlockMessage('Pending');
        
        message = EZProtectDownloadBlockedCrtl.getBlockMessage('Dirty');
        
        System.assertEquals(2, message.keySet().size());
    }
}