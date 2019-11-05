@isTest(seealldata = true)
private class Vc_CT_Test {

    static testMethod void myUnitTest() {
        Test.startTest();

        Vc_CT v = new Vc_CT();
        v.getHasPermission();
        v.CCO_ID = 'dameyer';
        v.location='Party';
        v.ex=false;
        
        //CCO Search  
        string xmlStr = '<x>      <ResponseExpression actionCode="SUCCESS">CATEGORY_ALL</ResponseExpression>      <Description>DescText</Description>      <PersonProfile>            <GivenName>Gname</GivenName>            <FamilyName>FName</FamilyName>      </PersonProfile>      <Email>dameyer@cisco.com</Email>      <PrimaryFlag>Yes</PrimaryFlag>      <Address type="TELEPHONE">            <TelephoneNumbe>9560019</TelephoneNumber>            <PrimaryFlag>Yes</PrimaryFlag>      </Address>      <Party Active="true" type="Organization">            <ID>251329</ID>            <Country>                  <Name>US</Name>            </Country>      </Party>      <GroupType>BE</GroupType>      <CrossReferenceIds>            <SourceSystem>CHANNELS</SourceSystem>            <ID>1774</ID>            <IdType>ADDRESS_ID</IdType>      </CrossReferenceIds></x>';
        XmlStreamReader xsr = new XmlStreamReader(xmlStr);  
        try{
        v.callCCOSearchService('<x>      <ResponseExpression actionCode="SUCCESS">CATEGORY_ALL</ResponseExpression>      <Description>DescText</Description>      <PersonProfile>            <GivenName>Gname</GivenName>            <FamilyName>FName</FamilyName>      </PersonProfile>      <Email>dameyer@cisco.com</Email>      <PrimaryFlag>Yes</PrimaryFlag>      <Address type="TELEPHONE">            <TelephoneNumber>9560019</TelephoneNumber>            <PrimaryFlag>Yes</PrimaryFlag>      </Address>      <Party Active="true" type="Organization">            <ID>251329</ID>            <Country>                  <Name>US</Name>            </Country>      </Party>      <GroupType>BE</GroupType>      <CrossReferenceIds>            <SourceSystem>CHANNELS</SourceSystem>            <ID>1774</ID>            <IdType>ADDRESS_ID</IdType>      </CrossReferenceIds></x>');} catch(Exception e){System.debug(e);}
        try{v.callCCOSearchService('NotAGreaterThan');} catch(Exception e){System.debug(e);}
        try{v.callCCOSearchService('<x><ResponseExpression actionCode="FAILURE">FAILURE</ResponseExpression></x>');} catch(Exception e){System.debug(e);}
        v.findSFDCPartnerId();              
        //VC Eligible
        try{v.callVcEligibleService();} catch (Exception e) {System.debug(e);}
        //SFDC process
        try{v.processSFDC();}catch (Exception e) {System.debug(e);}
        v.parseToTag(xsr,'x');
        v.getSFDCChannelAccount();
        v.getNoMatchesMsg();
        v.getSBCLink();
        v.getVCEligibleMessage();
        v.search();
        
        Test.stopTest();
    }
    static testMethod void myUnitTest1() {
        Test.startTest();

        Vc_CT v = new Vc_CT();
        v.getHasPermission();
        v.CCO_ID = 'dameyer';
        v.location='search';
        v.ex=false; 
        try{
            v.callCCOSearchService('isTest');
        } catch(Exception e)
        {
            System.debug(e);
        }
        Test.stopTest();
    }
}