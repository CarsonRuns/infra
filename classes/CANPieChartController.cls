public class CANPieChartController {
    
    public Lead_Prioritization_Model__c  pmodel {get; set;}
    public Decimal  Annual_Revenue_Weight;
    public Decimal  Budget_Weight;
    public Decimal  Buyer_Stage_Weight;
    public Decimal  Cisco_Architecture_Weight;
    public Decimal  Contact_Department_Weight;
    public Decimal  Contact_Engagement_Weight;
    public Decimal  Contact_Title_Position_Weight;
    public Decimal  Eloqua_Lead_Score_Weight;
    public Decimal  Eloqua_Lead_Source_Weight;
    public Decimal  Has_Purchased_Cisco_before_Weight;
    public Decimal  Inbound_Program_Weight;
    public Decimal  Lead_Category_Weight;
    public Decimal  Lead_Source_Weight;
    public Decimal  Lead_Type_Weight;
    public Decimal  Main_Product_Weight;
    public Decimal  Number_of_Employees_Weight;
    public Decimal  Offer_Type_Weight;
    public Decimal  Product_Value_Weight;
    public Decimal  Project_Flag_Weight;
    public Decimal  Purchasing_Role_Weight;
    public Decimal  SAVM_Segment_Weight;
    public Decimal  Services_Value_Weight;
    public Decimal  Source_System_Name_Weight;
    public Decimal  Timeframe_Weight;
    public Decimal  Total_Value_Weight;
    public Decimal  Vertical_Market_Weight;
    public Decimal  Job_Role_Weight;
    public Decimal 	Medium_Type_Weight;
        
    public List<PieWedgeData> getPieData() {
        
        try{
            List <Lead_Prioritization_Model__c> pmodelList   =  [select Annual_Revenue_Weight__c, Budget_Weight__c, 
                                                                 Buyer_Stage_Weight__c, Cisco_Architecture_Weight__c, 
                                                                 Contact_Department_Weight__c, Contact_Engagement_Weight__c, 
                                                                 Contact_Title_Position_Weight__c, Eloqua_Lead_Score_Weight__c, 
                                                                 Eloqua_Lead_Source_Weight__c, Has_Purchased_Cisco_before_Weight__c, 
                                                                 Inbound_Program_Weight__c, Lead_Category_Weight__c, Lead_Source_Weight__c, 
                                                                 Lead_Type_Weight__c, Main_Product_Weight__c, Number_of_Employees_Weight__c, 
                                                                 Offer_Type_Weight__c, Product_Value_Weight__c, Project_Flag_Weight__c, 
                                                                 Purchasing_Role_Weight__c, SAVM_Segment_Weight__c, Services_Value_Weight__c, 
                                                                 Source_System_Name_Weight__c, Timeframe_Weight__c, Total_Value_Weight__c, 
                                                                 Vertical_Market_Weight__c, Medium_Type_Weight__c,Job_Role_Weight__c from LEAD_PRIORITIZATION_MODEL__C 
                                                                 where Theatre__C  =  'AMERICAS' AND SUB_REGION__C  =  'CANADA'];
            
            
            if (pmodelList.size()== 0)  
            {
                pmodel  =  [select Annual_Revenue_Weight__c, Budget_Weight__c, 
                            Buyer_Stage_Weight__c, Cisco_Architecture_Weight__c, 
                            Contact_Department_Weight__c, Contact_Engagement_Weight__c, 
                            Contact_Title_Position_Weight__c, Eloqua_Lead_Score_Weight__c, 
                            Eloqua_Lead_Source_Weight__c, Has_Purchased_Cisco_before_Weight__c, 
                            Inbound_Program_Weight__c, Lead_Category_Weight__c, Lead_Source_Weight__c, 
                            Lead_Type_Weight__c, Main_Product_Weight__c, Number_of_Employees_Weight__c, 
                            Offer_Type_Weight__c, Product_Value_Weight__c, Project_Flag_Weight__c, 
                            Purchasing_Role_Weight__c, SAVM_Segment_Weight__c, Services_Value_Weight__c, 
                            Source_System_Name_Weight__c, Timeframe_Weight__c, Total_Value_Weight__c, 
                            Vertical_Market_Weight__c, Medium_Type_Weight__c,Job_Role_Weight__c from LEAD_PRIORITIZATION_MODEL__C 
                            where Theatre__C  =  'AMERICAS' AND SUB_REGION__C  =  'ALL'];
            }
            else {
                pmodel = pmodelList[0];
                
                
            }
            
            Annual_Revenue_Weight = pmodel.Annual_Revenue_Weight__c;
            Budget_Weight = pmodel.Budget_Weight__c;
            Buyer_Stage_Weight = pmodel.Buyer_Stage_Weight__c;
            Cisco_Architecture_Weight = pmodel.Cisco_Architecture_Weight__c;
            Contact_Department_Weight = pmodel.Contact_Department_Weight__c;
            Contact_Engagement_Weight = pmodel.Contact_Engagement_Weight__c;
            Contact_Title_Position_Weight = pmodel.Contact_Title_Position_Weight__c;
            Eloqua_Lead_Score_Weight = pmodel.Eloqua_Lead_Score_Weight__c;
            Eloqua_Lead_Source_Weight = pmodel.Eloqua_Lead_Source_Weight__c;
            Has_Purchased_Cisco_before_Weight = pmodel.Has_Purchased_Cisco_before_Weight__c;
            Inbound_Program_Weight = pmodel.Inbound_Program_Weight__c;
            Lead_Category_Weight = pmodel.Lead_Category_Weight__c;
            Lead_Source_Weight = pmodel.Lead_Source_Weight__c;
            Lead_Type_Weight = pmodel.Lead_Type_Weight__c;
            Main_Product_Weight = pmodel.Main_Product_Weight__c;
            Number_of_Employees_Weight = pmodel.Number_of_Employees_Weight__c;
            Offer_Type_Weight = pmodel.Offer_Type_Weight__c;
            Product_Value_Weight = pmodel.Product_Value_Weight__c;
            Project_Flag_Weight = pmodel.Project_Flag_Weight__c;
            Purchasing_Role_Weight = pmodel.Purchasing_Role_Weight__c;
            SAVM_Segment_Weight = pmodel.SAVM_Segment_Weight__c;
            Services_Value_Weight = pmodel.Services_Value_Weight__c;
            Source_System_Name_Weight = pmodel.Source_System_Name_Weight__c;
            Timeframe_Weight = pmodel.Timeframe_Weight__c;
            Total_Value_Weight  =  pmodel.Total_Value_Weight__c;
            Vertical_Market_Weight  =  pmodel.Vertical_Market_Weight__c;        
            Job_Role_Weight = pmodel.Job_Role_Weight__c; 
             Medium_Type_Weight = pmodel.Medium_Type_Weight__c; 
        }
        
        catch(SObjectException e) 
        {System.debug('SObjectException caught: ' + e.getMessage());   }
        catch(Exception e) {
            System.debug('Exception caught: ' + e.getMessage());   
        }
        
        List<PieWedgeData> data   =   new List<PieWedgeData>();
        if (Annual_Revenue_Weight > 0) 
            data.add(new PieWedgeData('Annual Revenue',Annual_Revenue_Weight));
        if (Budget_Weight > 0) 
            data.add(new PieWedgeData('Budget',Budget_Weight));
        if (Buyer_Stage_Weight > 0) 
            data.add(new PieWedgeData('Buyer Stage',Buyer_Stage_Weight));
        if (Cisco_Architecture_Weight > 0) 
            data.add(new PieWedgeData('Cisco Architecture',Cisco_Architecture_Weight));
        if (Contact_Department_Weight > 0)  
            data.add(new PieWedgeData('Contact Dept',Contact_Department_Weight));
        if (Contact_Engagement_Weight > 0)  
            data.add(new PieWedgeData('Contact Engagement',Contact_Engagement_Weight));
        if (Contact_Title_Position_Weight > 0) 
            data.add(new PieWedgeData('Contact Title',Contact_Title_Position_Weight));
        if (Eloqua_Lead_Score_Weight > 0) 
            data.add(new PieWedgeData('Eloqua Lead Score',Eloqua_Lead_Score_Weight));
        if (Eloqua_Lead_Source_Weight > 0) 
            data.add(new PieWedgeData('Eloqua Lead Source',Eloqua_Lead_Source_Weight));
        if (Has_Purchased_Cisco_before_Weight > 0) 
            data.add(new PieWedgeData('Purchased Cisco before',Has_Purchased_Cisco_before_Weight));
        if (Inbound_Program_Weight > 0) 
            data.add(new PieWedgeData('Inbound Program',Inbound_Program_Weight));
        if (Lead_Category_Weight > 0) 
            data.add(new PieWedgeData('Lead Category',Lead_Category_Weight));
        if (Lead_Source_Weight > 0) 
            data.add(new PieWedgeData('Lead Source',Lead_Source_Weight));
        if (Lead_Type_Weight > 0) 
            data.add(new PieWedgeData('Lead Type',Lead_Type_Weight));
        if (Main_Product_Weight > 0) 
            data.add(new PieWedgeData('Main Product',Main_Product_Weight));
        if (Number_of_Employees_Weight > 0) 
            data.add(new PieWedgeData('No of Employees',Number_of_Employees_Weight));
        if (Offer_Type_Weight > 0) 
            data.add(new PieWedgeData('Offer Type',Offer_Type_Weight));
        if (Product_Value_Weight > 0) 
            data.add(new PieWedgeData('Product Value',Product_Value_Weight));
        if (Project_Flag_Weight > 0) 
            data.add(new PieWedgeData('Project Flag',Project_Flag_Weight));
        if (Purchasing_Role_Weight > 0) 
            data.add(new PieWedgeData('Purchasing Role',Purchasing_Role_Weight));
        if (SAVM_Segment_Weight > 0)
            data.add(new PieWedgeData('SAVM Segment',SAVM_Segment_Weight));
        if (Services_Value_Weight > 0)
            data.add(new PieWedgeData('Services Value',Services_Value_Weight));
        if (Source_System_Name_Weight > 0)
            data.add(new PieWedgeData('Source System',Source_System_Name_Weight));
        if (Timeframe_Weight > 0)
            data.add(new PieWedgeData('Timeframe',Timeframe_Weight));
        if (Total_Value_Weight > 0) 
            data.add(new PieWedgeData('Total Value',Total_Value_Weight));
        if (Vertical_Market_Weight > 0)
            data.add(new PieWedgeData('Vertical Market',Vertical_Market_Weight));
        if (Job_Role_Weight > 0)
            data.add(new PieWedgeData('Job_Role', Job_Role_Weight));
            if (Medium_type_weight > 0)
            data.add(new PieWedgeData('Medium Type ', Medium_Type_Weight));         
        if (data.size() > 0)
            return data;
        else
        {
            data.add(new PieWedgeData('No Prioritization Model Exists',0));
            return data;
        }
    }
    
    
    // Wrapper class
    public class PieWedgeData {
        
        public String name { get; set; }
        public Decimal data { get; set; }
        
        public PieWedgeData(String name, Decimal data) {
            this.name   =   name;
            this.data  =  data;
        }
    }
}