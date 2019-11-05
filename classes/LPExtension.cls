public with sharing class LPExtension {
    public static List<Ranking__c> RankList = [select Theatre__c, Attribute_Name__c, Attribute_value__C, Attribute_Ranking__c  
                                               from ranking__c where Attribute_Ranking__c != '0'] ;
    public static List<Lead_Prioritization_model__c> lpmodel = [SELECT Id, Name, Lead_Source_Weight__c, Lead_Category_Weight__c, Timeframe_Weight__c, 
                                                                Main_Product_Weight__c, Inbound_Program_Weight__c, SAVM_Segment_Weight__c, Total_Value_Weight__c, 
                                                                Budget_Weight__c, Offer_Type_Weight__c, Eloqua_Lead_Score_Weight__c, Vertical_Market_Weight__c, 
                                                                Number_of_Employees_Weight__c, Annual_Revenue_Weight__c, Has_Purchased_Cisco_before_Weight__c, 
                                                                Contact_Title_Position_Weight__c, Purchasing_Role_Weight__c, Contact_Engagement_Weight__c, 
                                                                Contact_Department_Weight__c, Eloqua_Lead_Source_Weight__c, Project_Flag_Weight__c, 
                                                                Cisco_Architecture_Weight__c, Medium_Type_Weight__C, lead_Type_Weight__c, Product_Value_Weight__c, 
                                                                Services_Value_Weight__c, Buyer_Stage_Weight__c, Source_System_Name_Weight__c, Theatre__c, 
                                                                Sub_Region__c, Job_Role_Weight__c FROM Lead_Prioritization_Model__c];
    public static List<LPRegionMapping__c> MappingObj = [select region__c, sub_region__c, Country__c  from LPRegionMapping__c];
    
    
    public static String getTheatre(String Country){
        String Theatre;
        
        for (LPRegionMapping__c lm: (List<LPRegionMapping__c> )MappingObj)
        {
            
            if (lm.country__c == Country)
            {
                
                Theatre = lm.region__c;
                
            }
            
        }
        
        return Theatre;
        
        
    }
    
    public static String getSubRegion(String Theatre, String Country){
        String SubRegion;
        
        for (LPRegionMapping__c lm: (List<LPRegionMapping__c> )MappingObj)
        {
            
            if (lm.region__c == Theatre && lm.country__c == Country)
            {
                
                SubRegion = lm.sub_region__c;
                
            }
            
        }
        
        return SubRegion;
        
        
    }
    
    public static Lead_Prioritization_model__c getModel(String Theatre, String SubRegion){
        Lead_Prioritization_model__c mod;
        String RunType = 'ALL';
        
        for (Lead_Prioritization_model__c m: (List<Lead_Prioritization_model__c>) lpmodel )
        {
            
            if (m.theatre__c == Theatre && m.sub_region__c == SubRegion)
            {
                RunType = 'MODEL';
                mod = m;
                
            }
            
        }
        
        if (RunType == 'ALL')
        {
            
            for (Lead_Prioritization_model__c m: (List<Lead_Prioritization_model__c>) lpmodel )
            {
                
                if (m.theatre__C == Theatre && m.sub_region__C == 'ALL')
                {
                    
                    RunType = 'ALL';
                    mod = m;
                    
                }
                
            }
            
        }
        
        
        return mod;
        
    }
    
    
    
    public  Map <String, Integer> Calcscore(List <Lead> leadID){
        Map <String, Integer> retMap = new Map <String, Integer>();
        Integer LeadScore = 0;
        String Thea;
        String SubReg;
        Lead_Prioritization_model__c pmodel;
        String LIDlist ='\'';
        String query1 = 'select ID,Lead_Prioritization_Score__c,customCountry__c,LeadSource,MCP_Field_Marketing_Rating__c,Lead_Category__c,QATimeFrame__c,Main_Technology__c,'
            +'inbound_program__c,SAVM_Segment__c,Total_Value__c,QABudget__c, Offer_Type__c, Industry, QAEmployees__c, Annual_Revenue__c, Has_Purchased_from_Cisco_Before__c, '
            +'Lead_Owner_Title__c, QAPurchasingRole__c, Contact_Engagement_Score__c, Contact_Department__c, MCP_Lead_Source_Most_Recent__c, Project_Flag__c,'
            +'Cisco_Architecture__c, medium_type__C, Lead_Type__c, buyer_stage__c, Source_System__c, Job_Role__c, ProductAmount__c, ServicesAmount__c'
            +' from lead where id in (';
        for (Lead l: leadID)
        {
            
            
            if (l.id != null)
                LIDlist +=   '\',\''+ l.Id;
            
        }
        
        LIDlist += '\')';
        
        query1 +=  LIDlist;
        
        List <Lead> leadobj = Database.query(query1);
        
        try{
            for (Lead l1:(List <Lead>)leadobj )
            {
                LeadScore = 0;
                Thea = getTheatre(l1.customcountry__c);
                SubReg = getSubRegion (Thea, l1.customcountry__c);
                pmodel = getModel(Thea, SubReg);
                
                
                if (l1.leadsource != null && pmodel.Lead_Source_Weight__c > 0)
                {
                    LeadScore = LeadScore + Integer.valueOf(pmodel.Lead_Source_Weight__c * getRank(String.valueOf('LEAD SOURCE'), Thea, String.valueOf(l1.LeadSource)));
                    
                }
                else
                {
                    
                    Leadscore = Leadscore + 0;
                } 
                
                if (l1.MCP_Field_Marketing_Rating__c  != null && pmodel.Eloqua_Lead_Score_weight__c > 0)
                {
                    LeadScore = LeadScore + Integer.valueOf(pmodel.Eloqua_Lead_Score_weight__c * getRank(String.valueOf('ELOQUA LEAD SCORE'), Thea, String.valueOf(l1.MCP_Field_Marketing_Rating__c )));
                } 
                else
                {
                    
                    Leadscore = Leadscore + 0;
                } 
                if (l1.Lead_Category__c != null && pmodel.Lead_Category_Weight__c >0)
                {
                    
                    LeadScore = LeadScore + Integer.valueOf(pmodel.Lead_Category_Weight__c * getRank(String.valueOf('LEAD CATEGORY'), Thea, String.valueOf(l1.Lead_Category__c)));
                    
                }  
                else
                {
                    
                    Leadscore = Leadscore + 0;
                } 
                if (l1.QATimeFrame__c != null && pmodel.Timeframe_Weight__c > 0 )
                {
                    
                    LeadScore = LeadScore + Integer.valueOf(pmodel.Timeframe_Weight__c * getRank(String.valueOf('TIMEFRAME'), Thea, String.valueOf(l1.QATimeFrame__c)));
                    
                } 
                else
                {
                    
                    Leadscore = Leadscore + 0;
                } 
                if (l1.Main_Technology__c != null && pmodel.Main_Product_Weight__c > 0)
                {
                    
                    LeadScore = LeadScore + Integer.valueOf(pmodel.Main_Product_Weight__c * getRank(String.valueOf('MAIN PRODUCT'), Thea, String.valueOf(l1.Main_Technology__c)));
                } 
                else
                {
                    
                    Leadscore = Leadscore + 0;
                } 
                if (l1.inbound_program__c != null && pmodel.Inbound_Program_Weight__c >0 )
                {
                    
                    LeadScore = LeadScore + Integer.valueOf(pmodel.Inbound_Program_Weight__c * getRank(String.valueOf('INBOUND PROGRAM'), Thea, String.valueOf(l1.inbound_program__c)));
                } 
                else
                {
                    
                    Leadscore = Leadscore + 0;
                } 
                if (l1.SAVM_Segment__c != null && pmodel.SAVM_Segment_Weight__c > 0)
                {
                    
                    LeadScore = LeadScore + Integer.valueOf(pmodel.SAVM_Segment_Weight__c * getRank(String.valueOf('SAVM SEGMENT'), Thea, String.valueOf(l1.SAVM_Segment__c)));
                }
                else
                {
                    
                    Leadscore = Leadscore + 0;
                } 
                if (l1.Total_Value__c != null && pmodel.Total_Value_Weight__c >0)
                {
                    
                    LeadScore = LeadScore + Integer.valueOf(pmodel.Total_Value_Weight__c * getRank(String.valueOf('TOTAL VALUE'), Thea, String.valueOf(l1.Total_Value__c )));
                }  
                else
                {
                    
                    Leadscore = Leadscore + 0;
                } 
                if (l1.QABudget__c != null && pmodel.Budget_Weight__c > 0)
                {
                    
                    LeadScore = LeadScore + Integer.valueOf(pmodel.Budget_Weight__c * getRank(String.valueOf('BUDGET'), Thea, String.valueOf(l1.QABudget__c)));
                }  
                else
                {
                    
                    Leadscore = Leadscore + 0;
                } 
                if (l1.Offer_Type__c != null && pmodel.Offer_Type_Weight__c >0)
                {
                    
                    LeadScore = LeadScore + Integer.valueOf(pmodel.Offer_Type_Weight__c * getRank(String.valueOf('OFFER TYPE'), Thea, String.valueOf(l1.Offer_Type__c)));
                }  
                else
                {
                    
                    Leadscore = Leadscore + 0;
                } 
                if (l1.Industry != null && pmodel.Vertical_Market_Weight__c >0)
                {
                    
                    LeadScore = LeadScore + Integer.valueOf(pmodel.Vertical_Market_Weight__c * getRank(String.valueOf('VERTICAL MARKET'), Thea, String.valueOf(l1.Industry)));
                }  
                else
                {
                    
                    Leadscore = Leadscore + 0;
                } 
                if (l1.QAEmployees__c  != null && pmodel.Number_of_Employees_Weight__c >0)
                {
                    
                    LeadScore = LeadScore + Integer.valueOf(pmodel.Number_of_Employees_Weight__c * getRank(String.valueOf('NUMBER OF EMPLOYEES'), Thea, String.valueOf(l1.QAEmployees__c )));
                }
                else
                {
                    
                    Leadscore = Leadscore + 0;
                } 
                if (l1.Annual_Revenue__c != null && pmodel.Annual_Revenue_Weight__c > 0)
                {
                    
                    LeadScore = LeadScore + Integer.valueOf(pmodel.Annual_Revenue_Weight__c * getRank(String.valueOf('ANNUAL REVENUE'), Thea, String.valueOf(l1.Annual_Revenue__c)));
                } 
                else
                {
                    
                    Leadscore = Leadscore + 0;
                } 
                if (l1.Has_Purchased_from_Cisco_Before__c != null && pmodel.Has_Purchased_Cisco_before_Weight__c  > 0)
                {
                    
                    LeadScore = LeadScore + Integer.valueOf(pmodel.Has_Purchased_Cisco_before_Weight__c * getRank(String.valueOf('HAS PURCHASED CISCO BEFORE'), Thea, String.valueOf(l1.Has_Purchased_from_Cisco_Before__c )));
                }
                else
                { 
                    
                    Leadscore = Leadscore + 0;
                } 
                if (l1.Lead_Owner_Title__c != null && pmodel.Contact_Title_Position_Weight__c > 0)
                {
                    
                    LeadScore = LeadScore + Integer.valueOf(pmodel.Contact_Title_Position_Weight__c * getRank(String.valueOf('CONTACT TITLE-POSITION'), Thea, String.valueOf(l1.Lead_Owner_Title__c)));
                }
                else
                {
                    
                    Leadscore = Leadscore + 0;
                } 
                if (l1.QAPurchasingRole__c != null && pmodel.Purchasing_Role_Weight__c  > 0)
                {
                    
                    LeadScore = LeadScore + Integer.valueOf(pmodel.Purchasing_Role_Weight__c * getRank(String.valueOf('PURCHASING ROLE'), Thea, String.valueOf(l1.QAPurchasingRole__c)));
                }
                else
                {
                    
                    Leadscore = Leadscore + 0;
                } 
                if (l1.Contact_Engagement_Score__c != null && pmodel.Contact_Engagement_Weight__c >0)
                {
                    
                    LeadScore = LeadScore + Integer.valueOf(pmodel.Contact_Engagement_Weight__c * getRank(String.valueOf('CONTACT ENGAGEMENT'), Thea, String.valueOf(l1.Contact_Engagement_Score__c )));
                }
                else
                {
                    
                    Leadscore = Leadscore + 0;
                } 
                if (l1.Contact_Department__c != null && pmodel.Contact_Department_Weight__c >0 )
                {
                    
                    LeadScore = LeadScore + Integer.valueOf(pmodel.Contact_Department_Weight__c * getRank(String.valueOf('CONTACT DEPARTMENT'), Thea, String.valueOf(l1.Contact_Department__c)));
                }
                else
                {
                    
                    Leadscore = Leadscore + 0;
                } 
                if (l1.MCP_Lead_Source_Most_Recent__c != null && pmodel.Eloqua_Lead_Source_Weight__c >0	)
                {
                    
                    LeadScore = LeadScore + Integer.valueOf(pmodel.Eloqua_Lead_Source_Weight__c * getRank(String.valueOf('ELOQUA LEAD SOURCE'), Thea, String.valueOf(l1.MCP_Lead_Source_Most_Recent__c)));
                } 
                else
                {
                    
                    Leadscore = Leadscore + 0;
                } 
                if (l1.Project_Flag__c != null && pmodel.Project_Flag_Weight__c >0)
                {
                    
                    LeadScore = LeadScore + Integer.valueOf(pmodel.Project_Flag_Weight__c * getRank(String.valueOf('PROJECT FLAG'), Thea, String.valueOf(l1.Project_Flag__c )));
                }
                else
                {
                    
                    Leadscore = Leadscore + 0;
                } 
                if (l1.Cisco_Architecture__c != null && pmodel.Cisco_Architecture_Weight__c > 0)
                {
                    
                    LeadScore = LeadScore + Integer.valueOf(pmodel.Cisco_Architecture_Weight__c * getRank(String.valueOf('CISCO ARCHITECTURE'), Thea, String.valueOf(l1.Cisco_Architecture__c)));
                }
                else
                {
                    
                    Leadscore = Leadscore + 0;
                } 
                if (l1.Lead_Type__c != null && pmodel.Lead_Type_Weight__c >0)
                {
                    
                    LeadScore = LeadScore + Integer.valueOf(pmodel.Lead_Type_Weight__c * getRank(String.valueOf('LEAD TYPE'), Thea, String.valueOf(l1.Lead_Type__c)));
                }
                else
                {
                    
                    Leadscore = Leadscore + 0;
                } 
                if (l1.ProductAmount__c != null && pmodel.Product_Value_Weight__c >0)
                {
                    
                    LeadScore = LeadScore + Integer.valueOf(pmodel.Product_Value_Weight__c * getRank(String.valueOf('PRODUCT VALUE'), Thea, String.valueOf(l1.ProductAmount__c)));
                }   
                else
                {
                    
                    Leadscore = Leadscore + 0;
                } 
                if (l1.ServicesAmount__c  != null && pmodel.Services_Value_Weight__c >0)
                {	
                    
                    LeadScore = LeadScore + Integer.valueOf(pmodel.Services_Value_Weight__c * getRank(String.valueOf('SERVICES VALUE'), Thea, String.valueOf(l1.ServicesAmount__c)));
                }
                else
                {
                    
                    Leadscore = Leadscore + 0;
                } 
                if (l1.buyer_stage__c != null && pmodel.Buyer_Stage_Weight__c > 0)
                {
                    
                    LeadScore = LeadScore + Integer.valueOf(pmodel.Buyer_Stage_Weight__c * getRank(String.valueOf('BUYER STAGE'), Thea, String.valueOf(l1.buyer_stage__c)));
                }
                else
                {
                    
                    Leadscore = Leadscore + 0;
                } 
                if (l1.Source_System__c != null && pmodel.Source_System_Name_Weight__c >0 )
                {
                    
                    LeadScore = LeadScore + Integer.valueOf(pmodel.Source_System_Name_Weight__c * getRank(String.valueOf('SOURCE SYSTEM NAME'), Thea, String.valueOf(l1.Source_System__c)));
                }
                else
                {
                    
                    Leadscore = Leadscore + 0;
                } 
                if (l1.Job_Role__c != null && pmodel.Job_Role_Weight__c > 0 )
                {
                    
                    LeadScore = LeadScore + Integer.valueOf(pmodel.Job_Role_Weight__c * getRank(String.valueOf('JOB ROLE'), Thea, String.valueOf(l1.Job_Role__c )));
                }  
                else
                {
                    
                    Leadscore = Leadscore + 0;
                }
                if (l1.Medium_Type__c != null && pmodel.Medium_Type_Weight__c > 0 )
                {
                    
                    LeadScore = LeadScore + Integer.valueOf(pmodel.Medium_Type_Weight__c * getRank(String.valueOf('MEDIUM TYPE'), Thea, String.valueOf(l1.Medium_Type__c )));
                }  
                else
                {
                    
                    Leadscore = Leadscore + 0;
                }
                
                retmap.put(String.valueOf(l1.Id),Integer.valueOf(Leadscore));
                
            } 
            
        } 
        catch (Exception e)
        {
            System.debug('Error in Score Calculation: '+ e.getMessage());
            
        }
        system.debug('Return Map'+ retmap);
        return retMap;
        
        
    }
    
    
    @InvocableMethod  
    public static void getLeadScore (List<Lead> lead1)
    { 
        Map<String, Integer> scoremap = new  Map<String, Integer>();
        LPExtension ExtensionObject = new LPExtension();
        List < Lead > lstLeadToUpdate = new List < Lead > (); 
        Set<Id> LeadIds = new Map<Id, Lead>(Lead1).keySet();
        List<Lead> LeadsInput = [SELECT Id, lead_prioritization_score__c, customcountry__c FROM Lead WHERE Id IN :LeadIds];
        
        system.debug('Lead Obj: ' + LeadsInput);
        scoremap = ExtensionObject.Calcscore( LeadsInput);
        for (Lead l: (List < Lead > ) LeadsInput) {  
            if (l.id !=null)
            {
                
                if (scoremap.containsKey(l.Id) == true)
                {
                    
                    l.Lead_Prioritization_Score__c = Double.valueOf(scoremap.get(l.Id)); 
                    system.debug('scoremap.get(l.Id)'+ scoremap.get(l.Id));
                    lstLeadToUpdate.add(l);
                }
                else
                {
                    l.Lead_Prioritization_Score__c = 0;
                    
                    lstLeadToUpdate.add(l);
                    
                }
                
            }
        }
        Database.SaveResult[] SaveResult = Database.update(lstLeadToUpdate, false);
        /*

List <Lead> LeadObj = [select ID,Lead_Prioritization_Score__c,customCountry__c  from lead where id = :lead1[0].ID]; 
if (LeadObj[0].Id != null)
scoremap = obj1.Calcscore(LeadObj);
for (Lead l:  (List <Lead> )LeadObj)
{

l.Lead_Prioritization_Score__c = scoremap.get(l.ID);
lstLeadToUpdate.add(l);
}
Database.SaveResult[] SaveResult = Database.update(lstLeadToUpdate, false);
*/
        
        
    }
    
    
    public  Integer getRank(String AttrName, String Theatre, String AttrVal){
        Integer rankscore = 0;
        try{
            
            
            if (!RankList.isEmpty())
            {
                
                for (Ranking__C r: (List<Ranking__C>) Ranklist)
                {                    
                    if (r.Theatre__c == Theatre && r.Attribute_Name__c == AttrName )
                    {
                        if (r.Theatre__c== 'AMERICAS' && (r.Attribute_Name__c == 'TOTAL VALUE' ||r.Attribute_Name__c == 'PRODUCT VALUE'||r.Attribute_Name__c == 'SERVICE VALUE' ) )                  
                        {
                            
                            
                            if (Integer.valueOf(AttrVal) < 10000 && r.Attribute_Value__c == '<10,000')
                            {
                                
                                rankscore = Integer.valueOf(r.Attribute_Ranking__c);
                                
                            }
                            if (Integer.valueOf(AttrVal) >= 10000 && Integer.valueOf(AttrVal) < 20000 && r.Attribute_Value__c.toUpperCase() == '>10,000 and <20,000'.toUpperCase())
                            {
                                
                                
                                rankscore = Integer.valueOf(r.Attribute_Ranking__c);
                                
                                
                            }
                            if (Integer.valueOf(AttrVal) >= 20000 && Integer.valueOf(AttrVal) < 50000 && r.Attribute_Value__c.toUpperCase() == '>20,000 and <50,000'.toUpperCase())
                            {
                                
                                
                                rankscore = Integer.valueOf(r.Attribute_Ranking__c);
                                
                                
                            }
                            if (Integer.valueOf(AttrVal) >= 50000 && Integer.valueOf(AttrVal) <= 99999 && r.Attribute_Value__c.toUpperCase() == '>50,000 and <99,999'.toUpperCase())
                            {
                                
                                
                                rankscore = Integer.valueOf(r.Attribute_Ranking__c);
                                
                                
                            }
                            if (Integer.valueOf(AttrVal) >= 100000  && r.Attribute_Value__c == '>100,000')
                            {
                                
                                
                                rankscore = Integer.valueOf(r.Attribute_Ranking__c);
                                
                                
                            }
                        }
                        if (r.Theatre__c != 'AMERICAS' && (r.Attribute_Name__c == 'TOTAL VALUE' ||r.Attribute_Name__c == 'PRODUCT VALUE'||r.Attribute_Name__c == 'SERVICE VALUE' ) )                  
                        {
                            
                            
                            if (Integer.valueOf(AttrVal) < 5000 & r.Attribute_Value__c == '< 5,000')
                            {
                                
                                rankscore = Integer.valueOf(r.Attribute_Ranking__c);
                                
                            }
                            
                            if (Integer.valueOf(AttrVal) >= 5000 && Integer.valueOf(AttrVal) < 10000 && r.Attribute_Value__c.toUpperCase() == '>5,000 AND <10,000'.toUpperCase())
                            {
                                
                                rankscore = Integer.valueOf(r.Attribute_Ranking__c);
                                
                            }
                            if (Integer.valueOf(AttrVal) >= 10000 && Integer.valueOf(AttrVal) < 20000 && r.Attribute_Value__c.toUpperCase() == '>10,000 AND < 20,000'.toUpperCase())
                            {
                                
                                
                                rankscore = Integer.valueOf(r.Attribute_Ranking__c);
                                
                                
                            }
                            if (Integer.valueOf(AttrVal) >= 20000 && Integer.valueOf(AttrVal) < 50000 && r.Attribute_Value__c.toUpperCase() == '>20,000 AND < 50,000'.toUpperCase())
                            {
                                
                                
                                rankscore = Integer.valueOf(r.Attribute_Ranking__c);
                                
                                
                            }
                            if (Integer.valueOf(AttrVal) >= 50000 && Integer.valueOf(AttrVal) <= 99999 && r.Attribute_Value__c.toUpperCase() == '>50,000 AND < 100,000'.toUpperCase())
                            {
                                
                                
                                rankscore = Integer.valueOf(r.Attribute_Ranking__c);
                                
                                
                            }
                            if (Integer.valueOf(AttrVal) >= 100000 && r.Attribute_Value__c == '> 100,000')
                            {
                                
                                
                                rankscore = Integer.valueOf(r.Attribute_Ranking__c);
                                
                                
                            } 
                            
                        }
                        if (r.Attribute_Value__c.toUpperCase() == AttrVal.toUpperCase())
                        {
                            
                            rankscore = Integer.valueOf(r.Attribute_Ranking__c);
                            
                        }
                        
                        
                        
                        
                    }
                    
                }  
            }
            
            
            else 
            {
                rankscore = 0;
            }
        } 
        catch (Exception e){
            
            
            
            rankscore = 0;
            
            
        }
        return rankscore;
        
    }
    
    
}