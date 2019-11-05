public with sharing class SCP_Communities_AccountDetail_CT {

    public Account account { get; set; }
    
    public SCP_Communities_AccountDetail_CT(ApexPages.StandardController stdCon) {
        this.account = (Account) stdCon.getRecord();
    }

    /**
     * @description Default action method called for the TP Detail VF page.  Determines the page redirect based on
     *              user profiles.  The redirects apply as follows
     *              Standard TP View: Apply for all 
     *              TP Detail VF Page: Only users with partner profiles and admin
     */
    public PageReference redirect() {
        PageReference viewLeadPage = null;
        Profile p = [select name from Profile where id = 
                :UserInfo.getProfileId()];
        if (!'POC - Partner Community'.equals(p.name) && !'Partner360_Portal_Profile'.equals(p.name)){
            viewLeadPage =  New PageReference('/'+account.Id + '/d?nooverride=1');
            viewLeadPage.setRedirect(true);
        }
        
        return viewLeadPage;
    }

}