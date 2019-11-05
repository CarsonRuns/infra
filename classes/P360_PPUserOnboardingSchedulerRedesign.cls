//** This is the scheduler class for the Partner Portal User onboarding class.**/
//** Author:     Mukesh JSC Team
//** Date:       01/07/2013

/*
* This is the scheduler class for the Partner Portal User onboarding class.
*/
global class P360_PPUserOnboardingSchedulerRedesign implements Schedulable {
     global void execute(SchedulableContext SC) {
        // execute the Partner Portal user onboarding batch process.
        Database.executeBatch(new P360_PartnerPortalUserOnboardingRedesign(),50);        
    }
       
}