/************************************************************************************************************************************
Name    : ChannelAcctSharing_ScheduleApex  
urpose : Contains logic to execute a batch which is for sharing the channel Account based upon the AccountPartnersharing_GEO sharing setting .
*************************************************************************************************************************************/

global class EcosystemPartnerSharingSchedule implements schedulable {

global void execute(schedulableContext ctx)
 {
    EcosystemPartnerSharingBatch CASCR= new EcosystemPartnerSharingBatch();
    Database.executeBatch(CASCR);
 }
}