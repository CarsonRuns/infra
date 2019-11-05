/************************************************************************************************************************************
Name    : shareProductToS1
Author  : Bramha
Purpose : Contains logic to execute a batch which is for sharing the "Products" to service one
*************************************************************************************************************************************/
global class shareProductToS1 implements Schedulable {
    global void execute(SchedulableContext ctx){
        productShareInBatch pShare= new productShareInBatch();
        Database.executeBatch(pShare);
    }

}