/*
Class Name: OpptyCloudDemandProjectedValue
Description: Holds the logic for calculating IaaS Large Demand Proxy Projected Value
*/

public class OpptyCloudDemandProjectedValue{

    Cloud_Demand_Large_Deal_Proxy__c cdCommitedlDP = Cloud_Demand_Large_Deal_Proxy__c.getValues('CommittedLargeDealProxy');
    Cloud_Demand_Large_Deal_Proxy__c cdMonthlylDP = Cloud_Demand_Large_Deal_Proxy__c.getValues('MonthlyLargeDealProxy');
    Cloud_Demand_Large_Deal_Proxy__c cdMinRange = Cloud_Demand_Large_Deal_Proxy__c.getValues('MinValueRange');
    Cloud_Demand_Large_Deal_Proxy__c cdMaxRange = Cloud_Demand_Large_Deal_Proxy__c.getValues('MaxValueRange');
    
    //Method calculates the Cloud Demand Projected Value for IaaS Large Proxy  
    public void updateCloudProjectedValue(List<Opportunity> oppty){ 
        for(Opportunity op : oppty) {
               
        if((op.Cloud_Demand_Model__c != null && op.Cloud_Demand_Term_Months__c != null) && (op.Cloud_Demand_Model__c == 'IaaS' && op.Cloud_Demand_Term_Months__c >= 12)){
                
            if(op.Cloud_Demand_Units__c == 'CPU' && op.Cloud_Number_of_Units__c > cdMinRange.CPU__c  && op.Cloud_Number_of_Units__c <= cdMaxRange.CPU__C){
                op.Cloud_Demand_Projected_Value_000_s__c = ((Double.valueOf(op.Cloud_Demand_Proxy__c) * 36 * cdMinRange.CPU__c) + (cdCommitedlDP.CPU__c * (Double.valueOf(op.Cloud_Number_of_Units__c)-cdMinRange.CPU__c)))/1000;
            } 
          
           else if(op.Cloud_Demand_Units__c == 'VPU' && op.Cloud_Number_of_Units__c > cdMinRange.VPU__c && op.Cloud_Number_of_Units__c <= cdMaxRange.VPU__c){
                op.Cloud_Demand_Projected_Value_000_s__c = ((Double.valueOf(op.Cloud_Demand_Proxy__c) * 36 * cdMinRange.VPU__c) + (cdCommitedlDP.VPU__c * (Double.valueOf(op.Cloud_Number_of_Units__c)-cdMinRange.VPU__c)))/1000;         
            } 
           
            else if(op.Cloud_Demand_Units__c == 'GHz' && op.Cloud_Number_of_Units__c > cdMinRange.GHz__c && op.Cloud_Number_of_Units__c <= cdMaxRange.GHz__c){
                op.Cloud_Demand_Projected_Value_000_s__c = ((Double.valueOf(op.Cloud_Demand_Proxy__c) * 36 * cdMinRange.GHz__c) + (cdCommitedlDP.GHz__c * (Double.valueOf(op.Cloud_Number_of_Units__c)-cdMinRange.GHz__c)))/1000;
            } 
                    
            else if(op.Cloud_Demand_Units__c == 'GB RAM' && op.Cloud_Number_of_Units__c > cdMinRange.GB_RAM__c && op.Cloud_Number_of_Units__c <= cdMaxRange.GB_RAM__c){
               op.Cloud_Demand_Projected_Value_000_s__c = ((Double.valueOf(op.Cloud_Demand_Proxy__c) * 36 * cdMinRange.GB_RAM__c) + (cdCommitedlDP.GB_RAM__c * (Double.valueOf(op.Cloud_Number_of_Units__c)-cdMinRange.GB_RAM__c)))/1000;
            } 

            else if (op.Cloud_Demand_Proxy__c !=null && op.Cloud_Number_of_Units__c !=null && op.Cloud_Demand_Term_Months__c !=null ){
                op.Cloud_Demand_Projected_Value_000_s__c = Double.valueOf(op.Cloud_Demand_Proxy__c) * Double.valueOf(op.Cloud_Number_of_Units__c) * 36/1000;
            }
          } 
          
        else if((op.Cloud_Demand_Model__c != null && op.Cloud_Demand_Term_Months__c != null) && (op.Cloud_Demand_Model__c == 'IaaS' && op.Cloud_Demand_Term_Months__c < 12)){
        
            if(op.Cloud_Demand_Units__c == 'CPU' && op.Cloud_Number_of_Units__c > cdMinRange.CPU__c && op.Cloud_Number_of_Units__c <= cdMaxRange.CPU__c){
                op.Cloud_Demand_Projected_Value_000_s__c = ((Double.valueOf(op.Cloud_Demand_Proxy__c) * cdMinRange.CPU__c) + (cdMonthlylDP.CPU__c * (Double.valueOf(op.Cloud_Number_of_Units__c)-cdMinRange.CPU__c))) * op.Cloud_Demand_Term_Months__c/1000;
            } 
            
            else if(op.Cloud_Demand_Units__c == 'VPU' && op.Cloud_Number_of_Units__c > cdMinRange.VPU__c && op.Cloud_Number_of_Units__c <= cdMaxRange.VPU__c){
                op.Cloud_Demand_Projected_Value_000_s__c = ((Double.valueOf(op.Cloud_Demand_Proxy__c) * cdMinRange.VPU__c) + (cdMonthlylDP.VPU__c * (Double.valueOf(op.Cloud_Number_of_Units__c)-cdMinRange.VPU__c))) * op.Cloud_Demand_Term_Months__c/1000;
            } 
            
            else if(op.Cloud_Demand_Units__c == 'GHz' && op.Cloud_Number_of_Units__c > cdMinRange.GHz__c && op.Cloud_Number_of_Units__c <= cdMaxRange.GHz__c){
               op.Cloud_Demand_Projected_Value_000_s__c = ((Double.valueOf(op.Cloud_Demand_Proxy__c) * cdMinRange.GHz__c) + (cdMonthlylDP.GHz__c * (Double.valueOf(op.Cloud_Number_of_Units__c)-cdMinRange.GHz__c))) * op.Cloud_Demand_Term_Months__c /1000;
            } 
                    
            else if(op.Cloud_Demand_Units__c == 'GB RAM' && op.Cloud_Number_of_Units__c > cdMinRange.GB_RAM__c && op.Cloud_Number_of_Units__c <= cdMaxRange.GB_RAM__c){
                op.Cloud_Demand_Projected_Value_000_s__c = ((Double.valueOf(op.Cloud_Demand_Proxy__c) * cdMinRange.GB_RAM__c) + (cdMonthlylDP.GB_RAM__c * (Double.valueOf(op.Cloud_Number_of_Units__c)-cdMinRange.GB_RAM__c))) * op.Cloud_Demand_Term_Months__c /1000;
            } 
            else if (op.Cloud_Demand_Proxy__c !=null && op.Cloud_Number_of_Units__c !=null && op.Cloud_Demand_Term_Months__c !=null){
                op.Cloud_Demand_Projected_Value_000_s__c = Double.valueOf(op.Cloud_Demand_Proxy__c) * Double.valueOf(op.Cloud_Number_of_Units__c) * op.Cloud_Demand_Term_Months__c/1000;
            }
          } 
         
         else if (op.Cloud_Demand_Proxy__c !=null && op.Cloud_Number_of_Units__c !=null && op.Cloud_Demand_Term_Months__c !=null ){
                op.Cloud_Demand_Projected_Value_000_s__c = Double.valueOf(op.Cloud_Demand_Proxy__c) * Double.valueOf(op.Cloud_Number_of_Units__c) * op.Cloud_Demand_Term_Months__c/1000;
            }
        }
   }
}