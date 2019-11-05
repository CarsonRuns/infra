/***************************************************************************************************
Name    : NGCC_VDC_DRTLeadsUpdate_Batch_Schedule
Author  : Zakeahmed
Purpose : This class is responsible for scheduling the NGCC_VDC_DRTLeadsUpdate_Batch Apex class
Created Date: 05/20/2019
Go Live: May-31st-2019
****************************************************************************************************/
global class NGCC_VDC_DRTLeadsUpdate_Batch_Schedule implements Schedulable {
    
    global void execute(SchedulableContext ctx) {
        NGCC_VDC_DRTLeadsUpdate_Batch VDCLeads = new NGCC_VDC_DRTLeadsUpdate_Batch ();
        database.executeBatch(VDCLeads);    
    }

    
}