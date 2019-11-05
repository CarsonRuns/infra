trigger EloquaUpdateCampaignMemberStatus on Campaign (after insert) {
    EloquaCampaignAdvanceSetupTrg_Cls.CampaignAdvanceSetup(Trigger.New);
}