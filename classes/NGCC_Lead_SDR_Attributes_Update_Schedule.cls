global class NGCC_Lead_SDR_Attributes_Update_Schedule implements Schedulable {
    global void execute(SchedulableContext ctx) {
        NGCC_Lead_SDR_Attributes_Update_Batch SDRbatch = new NGCC_Lead_SDR_Attributes_Update_Batch();
        database.executeBatch(SDRbatch);   
    }
}