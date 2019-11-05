/*********************************************************************************************************************************************************************

Name    : SO_BatchUtilityClass
Author  : Apex User
Purpose : Contains logic to get partnerNetworkRecordConnection Records and querying shared partnerNetworkRecordConnection Records to batch
Created Date:  2/02/2018

*********************************************************************************************************************************************************************/

public class SO_BatchUtilityClass{
   
    // Method to fetch all shared PartnerNetwordRecordConnection Data
    Public static List<PartnerNetworkRecordConnection> updateQuery( Set<Id> IdList){
    List<PartnerNetworkRecordConnection> EligibleRecords = [SELECT Status, LocalRecordId, ConnectionId 
                                                          FROM PartnerNetworkRecordConnection
                                                          WHERE LocalRecordId IN :IdList];
    return EligibleRecords;
    
    } 
    
    
    // Method To add PartnerNetwordRecordConnection record to InsertRecord List To share Records
    Public static PartnerNetworkRecordConnection getNetworkRecord(String networkId, Id localRecordid, Id parentRecordId, String relatedList){            
           PartnerNetworkRecordConnection networkConnRecord =new PartnerNetworkRecordConnection();
           If(Case.SObjectType.getDescribe().isCreateable()){
                //validating Create & Update conditions for ConnectionId from PartnerNetworkRecordConnection
                if(flsCreateGet(PartnerNetworkRecordConnection.ConnectionId)|| flsUpdateGet(PartnerNetworkRecordConnection.ConnectionId))
                {   
                networkConnRecord.ConnectionId = NetWorkId;                      //Scava Issue
                }
                //validating Create & Update conditions for LocalRecordId from PartnerNetworkRecordConnection
                if(flsCreateGet(PartnerNetworkRecordConnection.LocalRecordId)|| flsUpdateGet(PartnerNetworkRecordConnection.LocalRecordId))
                {   
                networkConnRecord.LocalRecordId = localRecordid;                       //Scava Issue
                }
                    
                if(!String.isBlank(parentRecordId)){
                if(flsCreateGet(PartnerNetworkRecordConnection.ParentRecordId)|| flsUpdateGet(PartnerNetworkRecordConnection.ParentRecordId))
                {
                networkConnRecord.ParentRecordId = parentRecordId;                      //Scava Issue
                }
                }
                if(!String.isBlank(relatedList)){
                if(flsCreateGet(PartnerNetworkRecordConnection.RelatedRecords)|| flsUpdateGet(PartnerNetworkRecordConnection.RelatedRecords))
                {
                networkConnRecord.RelatedRecords =relatedList;                                  //Scava Issue
                }
                } 
            }
          //  insertRecordList.add(networkConnRecord);
            return networkConnRecord;   
            

   }
    // SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdateGet(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;              
    }
    public static Boolean flsCreateGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }
   
}