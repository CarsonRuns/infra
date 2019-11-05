/**
 * Filter Feed Items for blacklisted words
 * Author: Quinton Wall - qwall@salesforce.com
 Modification History:  
    Sudi 01 June 2016 : Added new code for CPOC application, all CPOC request 
                        Chatter comments adding account name as a prefix 
 */
trigger BlacklistWordFilterOnPost on FeedItem (before insert) 
{

    new BlacklistFilterDelegate().filterFeedItems(trigger.new);
    // Sudi 01 June 2016 : added this method for all CPOC chatter post we are adding Account name as a prefix
    new BlacklistFilterDelegate().addAccountNamePrefixCPOCRequests(trigger.new);
}