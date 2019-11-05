/*******************************************************************************************************************
Author          : Shivi Srivastava
Created         : Feb 4,2019
Functionality   : For creating JSON for request payload(Customer Win, LearningMaps and Sales Hub)
-----------------------------------------------------------------------------
Modification History:
-----------------------------------------------------------------------------
Date                Author                      Change  
Mar 28,2019         Lei Zhou                    Added logic for Customer Stories
*******************************************************************************************************************/
public class CustomerWinJSON {
  //Creating wrapper  
    public class reqPay{
        public should[] should=new should[]{};
    }
    public class should{
     public childOptyLine2 match;
    }
    public class childOptyLine2{
        public String bizent;
    }
    //Passing value for BE/SubBE/Competitor dynamically for each optyLineItem
    public static Map<String,String> getJsonString(List<OpportunityLineItem>listOfBE) {
        List<String> preJSON=new List<String>();
        String finalJSON;
        for(OpportunityLineItem BE:listOfBE){
            if(BE.PriceBookEntry.Product2.Business_Entity__c!=null){
            childOptyLine2 cL2=new childOptyLine2();
            cL2.bizent=string.valueOf(BE.PriceBookEntry.Product2.Business_Entity__c);
            should sh1=new should();
            sh1.match=cL2;
            
        String req=JSON.serialize(sh1);
            preJSON.add(req);
            }
         }
        finalJSON=String.join(preJSON,',');
        map<String,String>mapOfJSONs=new map<String,string>();
        mapOfJSONs.put('Others',finalJSON);
        string SalesPresentation=getSalesPresentationJson(listOfBE);
        mapOfJSONs.put('salesPresentation',SalesPresentation);
        String json2=getJsonString2(listOfBE);
        String json3=getJsonString3(listOfBE);
        String json4=getJsonString4(listOfBE);
        String json5=getJsonString5(listOfBE);
        String json6=getJsonString6(listOfBE);
        String json7=getJsonString7(listOfBE);
        String json8=getJsonString8(listOfBE);
        
        List<String>listOfJsons=new List<String>();
        if(json4!=''){
        listOfJsons.add(json4);
        }
        if(json2!=''){
        listOfJsons.add(json2);
        }
        if(json3!=''){
        listOfJsons.add(json3);
        }
        if(json5!=''){
        listOfJsons.add(json5);
        }
        if(json6!=''){
        listOfJsons.add(json6);
        }
        if(json7!=''){
        listOfJsons.add(json7);
        }
        if(json8!=''){
        listOfJsons.add(json8);
        }
        //CustomerWinJSON will have all BE/SubBE and Competitor
        String CustomerWINJson=String.join(listOfJsons,',');
        System.debug('After JSOn Creation-->'+listOfJsons);
        mapOfJSONs.put('CustomerWin',CustomerWINJson);
        return mapOfJSONs;
    }
    
//For CustomerWin Json 
   public class reqPay4{
        public should4[] should=new should4[]{};
    }
    public class should4{
     public childOptyLine1 match;
    }
    public class childOptyLine1{
        public bizEntity bizent;
    }
    public class bizEntity{
        public String query;
        public String boost;
    }
       public static String getJsonString4(List<OpportunityLineItem>listOfBE) {
        List<String> preJSON=new List<String>();
        String finalJSON;
        for(OpportunityLineItem BE:listOfBE){
            if(BE.PriceBookEntry.Product2.Business_Entity__c!=null){
            childOptyLine1 cL4=new childOptyLine1();
            bizEntity BEnt=new bizEntity();
            BEnt.query=string.valueOf(BE.PriceBookEntry.Product2.Business_Entity__c);
            BEnt.boost='7';
            cL4.bizent=BEnt;
            should4 sh1=new should4();
            sh1.match=cL4;
            
        String req=JSON.serialize(sh1);
            preJSON.add(req);
            }
         }
        finalJSON=String.join(preJSON,',');
        return finalJSON;
    }
    public class Parentwrapper{
        public SalesPresentationwrapper[] lstvalue=new SalesPresentationwrapper[]{};
    }
    public class SalesPresentationwrapper{
        public string pfValue;
    }

    public static string getSalesPresentationJson(List<OpportunityLineItem>listOppline){
        List<String> preJSON=new List<String>();
        string finalJson;
        system.debug('Opptyline Item List Value'+listOppline);
        for(OpportunityLineItem BE:listOppline){
            string beSubPf;
            if(BE.PriceBookEntry.Product2.Sub_Business_Entity__c!=null && BE.PriceBookEntry.Product2.Business_Entity__c!=null && BE.Product_Family_Ref__r.name!=null){
            beSubPf=BE.PriceBookEntry.Product2.Business_Entity__c+'/'+ BE.PriceBookEntry.Product2.Sub_Business_Entity__c+'/'+ string.valueof(BE.Product_Family_Ref__r.name);
                system.debug('beSubPf Value'+beSubPf);
            }
            if(beSubPf!=null){
            preJSON.add(beSubPf);
            }
        }
        system.debug('preJSON Value'+preJSON);
        String req=JSON.serialize(preJSON);
        req = req.replace('\\"', '');
        system.debug('Final return value'+finalJson);
        return req;
    }
     public class reqPay2{
        public should2[] should=new should2[]{};
    }
    public class should2{
     public childOptyLine4 match;
    }
    public class childOptyLine4{
        public subBE subbizent;
    }
    public class subBE{
        public String query;
        public String boost;
    }
      public static String getJsonString2(List<OpportunityLineItem>listOfBE) {
        List<String> preJSON=new List<String>();
        String finalJSON;
        for(OpportunityLineItem BE:listOfBE){
            if(BE.PriceBookEntry.Product2.Sub_Business_Entity__c!=null){
            childOptyLine4 cL2=new childOptyLine4();
            subBE sBE=new subBE();
            sBE.query=String.valueOf(BE.PriceBookEntry.Product2.Sub_Business_Entity__c);
            sBE.boost='6';
            cL2.subbizent=sBE;
            should2 sh1=new should2();
            sh1.match=cL2;
            
        String req=JSON.serialize(sh1);
            preJSON.add(req);
            }
         }
        finalJSON=String.join(preJSON,',');
        return finalJSON;
    }
    
      public class reqPay3{
        public should3[] should=new should3[]{};
    }
    public class should3{
     public childOptyLine3 match;
    }
    public class childOptyLine3{
        public competitor cwcompetitors;
    }
    public class competitor{
        public String query;
        public String boost;
    }
       public static String getJsonString3(List<OpportunityLineItem>listOfBE) {
        List<String> preJSON=new List<String>();
        String finalJSON;
        if(!listOfBE.isEmpty()){
            if(listOfBE[0].opportunity.Competitors__c!=null){
            childOptyLine3 cL2=new childOptyLine3();
            competitor comp=new competitor();
            comp.query=String.valueOf(listOfBE[0].opportunity.Competitors__c);
            comp.boost='4';
            cL2.cwcompetitors=comp;
            should3 sh1=new should3();
            sh1.match=cL2;
            
        String req=JSON.serialize(sh1);
            preJSON.add(req);
            }
         }
        finalJSON=String.join(preJSON,',');
        return finalJSON;
    }
    
    public class reqPay5{
        public should5[] should=new should5[]{};
    }
    public class should5{
     public childOptyLine5 match;
    }
    public class childOptyLine5{
        public vertical cwvertical;
    }
    public class vertical{
        public String query;
        public String boost;
    }
       public static String getJsonString5(List<OpportunityLineItem>listOfBE) {
        List<String> preJSON=new List<String>();
        String finalJSON;
        if(!listOfBE.isEmpty()){
            if(listOfBE[0].opportunity.Account.VMTOP__c!=null){
            childOptyLine5 cL4=new childOptyLine5();
            vertical vert=new vertical();
            vert.query=String.valueOf(listOfBE[0].opportunity.Account.VMTOP__c);              
            vert.boost='3';
            cL4.cwvertical=vert;
            should5 sh1=new should5();
            sh1.match=cL4;
            
        String req=JSON.serialize(sh1);
            preJSON.add(req);
            }
         }
        finalJSON=String.join(preJSON,',');
        return finalJSON;
    }
    
    public class reqPay6{
        public should6[] should=new should6[]{};
    }
    public class should6{
     public childOptyLine6 match;
    }
    public class childOptyLine6{
        public segments cwsegments;
    }
    public class segments{
        public String query;
        public String boost;
    }
       public static String getJsonString6(List<OpportunityLineItem>listOfBE) {
        List<String> preJSON=new List<String>();
        String finalJSON;
        if(!listOfBE.isEmpty()){
            if(listOfBE[0].opportunity.Account.LineofBusiness__c!=null){
            childOptyLine6 cL4=new childOptyLine6();
            segments seg=new segments();
            seg.query=String.valueOf(listOfBE[0].opportunity.Account.LineofBusiness__c);
            seg.boost='5';
            cL4.cwsegments=seg;
            should6 sh1=new should6();
            sh1.match=cL4;
            
        String req=JSON.serialize(sh1);
            preJSON.add(req);
            }
         }
        finalJSON=String.join(preJSON,',');
        return finalJSON;
    }

    //7
    public class reqPay7{
        public should7[] should=new should7[]{};
    }
    public class should7{
     public childOptyLine7 match;
    }
    public class childOptyLine7{
        public String cwtheater;
    }
    
    //8
    public class reqPay8{
        public should8[] should=new should8[]{};
    }
    public class should8{
     public childOptyLine8 match;
    }
    public class childOptyLine8{
        public String cwregion;
    }
    
       public static String getJsonString7(List<OpportunityLineItem>listOfBE) {
        List<String> preJSON=new List<String>();
        String finalJSON;
        if(!listOfBE.isEmpty()){
            if(listOfBE[0].opportunity.Account.Theatre__c!=null){
            childOptyLine7 cL4=new childOptyLine7();
            //theater1 thr=new theater1();
            //thr.query=String.valueOf(BE.opportunity.Account.Theatre__c);
            cL4.cwtheater=String.valueOf(listOfBE[0].opportunity.Account.Theatre__c);
            should7 sh1=new should7();
            sh1.match=cL4;
            
        String req=JSON.serialize(sh1);
            preJSON.add(req);
            }
         }
        finalJSON=String.join(preJSON,',');
        return finalJSON;
    }
    
     public static String getJsonString8(List<OpportunityLineItem>listOfBE) {
        List<String> preJSON=new List<String>();
        String finalJSON;
        if(!listOfBE.isEmpty()){
            if(listOfBE[0].opportunity.Account.Theatre__c!=null){
            childOptyLine8 cL4=new childOptyLine8();
            //theater1 thr=new theater1();
            //thr.query=String.valueOf(BE.opportunity.Account.Theatre__c);
            cL4.cwregion=String.valueOf(listOfBE[0].opportunity.Account.Theatre__c);
            should8 sh1=new should8();
            sh1.match=cL4;
            
        String req=JSON.serialize(sh1);
            preJSON.add(req);
            }
         }
        finalJSON=String.join(preJSON,',');
        return finalJSON;
    }
}