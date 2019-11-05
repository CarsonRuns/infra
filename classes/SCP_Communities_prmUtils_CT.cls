public with sharing class SCP_Communities_prmUtils_CT {
    public String languageLocaleKey{
        get{
        	if( languageLocaleKey == null ) {
        		languageLocaleKey = prmFilterUtility.loggedInUserGadgetLanguage;
        	}
        	System.debug('*** languageLocaleKey: ' + languageLocaleKey);
        	return languageLocaleKey;
        }
        set;
    }
    
    public SCP_Communities_prmUtils_CT(ApexPages.StandardController acon) { }
}