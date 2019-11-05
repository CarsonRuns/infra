@isTest(SeeAllData=true)
public class PUI_Test{

public static testMethod void test_PUI_CT() {

        String currencyIsoCode = 'USD';
        String Service = 'Service';
        String Technology = 'Technology';
        
        PricebookEntry pbeTech = [select id, PriceBook2.Id from pricebookentry 
                                    where ProductCode = :Technology and 
                                        isactive = true and 
                                        currencyisocode = :currencyIsoCode and 
                                        pricebook2.Name = 'Standard Price Book'                                     
                                         limit 1];
        PricebookEntry pbeSvc = [select id, PriceBook2.Id from pricebookentry
                                    where ProductCode = :Service and 
                                        isactive = true and 
                                        currencyisocode = :currencyIsoCode and 
                                        pricebook2.Name = 'Standard Price Book'                                     
                                         limit 1];
                                         
        Product2[] p2 = new Product2[]{};
                                         
        Product2 p2Tmp = new Product2(ProductCode=Technology,
                                            Name = 'TechName',
                                            Product_Family_1__c='pf1',
                                            Product_Family_2__c='pf2',
                                            Product_Family_3__c='pf3', 
                                            Product_Family_4__c='pf4',
                                            isactive=true);
        p2.add(p2Tmp);
        p2Tmp = new Product2(ProductCode=Technology,
                                            Name = 'TechName2',
                                            //Product_Family_1__c='pf1',
                                            Product_Family_2__c='pf2',
                                            Product_Family_3__c='pf3', 
                                            Product_Family_4__c='pf4',
                                            isactive=true);
        p2.add(p2Tmp);                              
        p2Tmp = new Product2(ProductCode=Technology,
                                            Name = 'TechName3',
                                            //Product_Family_1__c='pf1',
                                            //Product_Family_2__c='pf2',
                                            Product_Family_3__c='pf3', 
                                            Product_Family_4__c='pf4',
                                            isactive=true);
        p2.add(p2Tmp);                  
        p2Tmp = new Product2(ProductCode=Technology,
                                            Name = 'TechName4',
                                            //Product_Family_1__c='pf1',
                                            //Product_Family_2__c='pf2',
                                            //Product_Family_3__c='pf3', 
                                            Product_Family_4__c='pf4',
                                            isactive=true);
        p2.add(p2Tmp);                                                              
        
        p2Tmp = new Product2(ProductCode=Service,
                                            Name = 'SvcName1',
                                            Service_Level_1__c='s1',
                                            Service_Level_2__c='s2',
                                            Service_Level_3__c='s3', 
                                            Service_Level_4__c='s4',
                                            isactive=true);
        p2.add(p2Tmp);

        p2Tmp = new Product2(ProductCode=Service,
                                            Name = 'SvcName2',
                                            //Service_Level_1__c='s1',
                                            Service_Level_2__c='s2',
                                            Service_Level_3__c='s3', 
                                            Service_Level_4__c='s4',
                                            isactive=true);
        p2.add(p2Tmp);

        p2Tmp = new Product2(ProductCode=Service,
                                            Name = 'SvcName3',
                                            //Service_Level_1__c='s1',
                                            //Service_Level_2__c='s2',
                                            Service_Level_3__c='s3', 
                                            Service_Level_4__c='s4',
                                            isactive=true);
        p2.add(p2Tmp);
                                                                                                        
        p2Tmp = new Product2(ProductCode=Service,
                                            Name = 'SvcName4',
                                            //Service_Level_1__c='s1',
                                            //Service_Level_2__c='s2',
                                            //Service_Level_3__c='s3', 
                                            Service_Level_4__c='s4',
                                            isactive=true);
        p2.add(p2Tmp);                                                                                                      
                                                
        insert(p2);                                                 
        
        Opportunity o = new Opportunity(name='test',CurrencyIsoCode=currencyIsoCode, 
                                        pricebook2id=pbeTech.PriceBook2.Id ,stageName='Open',
                                        CloseDate=Date.newInstance(2006,10,10));
        insert o;
        
        OpportunityLineItem[] olis = new OpportunityLineItem[]{};
        
        OpportunityLineItem tmp = new OpportunityLineItem(opportunityid=o.id,pricebookentryid=pbeTech.id,
                        Product_Family_US__c=';Val1;;Val2;Val3;', 
                        Quantity=1,
                        TotalPrice=0,
                        Mix__c=0);
        olis.add(tmp);                      
                                

        tmp = new OpportunityLineItem(opportunityid=o.id,pricebookentryid=pbeSvc.id, 
                        Quantity=1,
                        TotalPrice=0,
                        Mix__c=0);
        olis.add(tmp);      
                    
        
        tmp = new OpportunityLineItem(opportunityid=o.id,pricebookentryid=pbeSvc.id, 
                        Quantity=1,
                        TotalPrice=0,
                        Mix__c=0);
        olis.add(tmp);
                                                                    
        insert olis;                        
        
        
        Test.setCurrentPageReference(new PageReference('PUI'));
        // Add parameters to page URL
        System.currentPageReference().getParameters().put('id', o.id);
        //del li from del link
        System.currentPageReference().getParameters().put('delId', olis[1].Id );
                
        PUI_CT controller = new PUI_CT();
        
        controller.getOpportunity();
        
        controller.getPbePickList();
        controller.getProduct2PL(); 
                
        controller.getLineItemsTechnology();
        controller.getLineItemsService();
        controller.getAccountName();
        
        controller.setPbeId_Tech(pbeTech.id);
        controller.addTech();
        controller.getPbeId_Tech();

        controller.setPbeId_Svc(pbeSvc.id);
        controller.addSvc();
        controller.getPbeId_Svc();
        
        controller.setTechRowNum('1');
        controller.delTech();       
        controller.getTechRowNum();
        
        controller.setTechRowNum('0');
        controller.delTech();       

        controller.setSvcRowNum('0');
        
        controller.delSvc();
        controller.getSvcRowNum();  
        
        controller.save();

        controller.getError_msg();
        List<String> x = new List<String>();
        x.add('xx');
        controller.setidk(x);           
        controller.getidk();
        
       }
 
}