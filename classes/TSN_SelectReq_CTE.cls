/***************************************************************************************************************************
Modification History

Shivi Srivastava    DE244302     Added optyid null check, redirection to PDI case     12-Apr-2019
****************************************************************************************************************************/

public class TSN_SelectReq_CTE {
 
    // 11/12 - Removed Case Record type reference and updated logic for Default record type assignment. Line# 149       
    // 06/01 - Added PXS Recordtype Id to skip the contact validation VF page and to navigate to the PXS Case Creation page directly
 
    private ApexPages.StandardController controller1;
    public String retURL {get; set;}
    public String saveNewURL {get; set;}
    public String rType {get; set;}
    public String cancelURL {get; set;}
    public String ent {get; set;}
    public String confirmationToken {get; set;}
    public Boolean flag =true;
    public String note = '';
    public String Cecid {get; set;}
    public String Contacttype {get; set;}
    public String Name {get; set;}
    public String Title {get; set;}
    Public String Org {get; set;}
    Public String wpn {get; set;}
    Public String ipn {get; set;}
    Public String mn {get; set;}
    Public String country {get; set;}
    public String cecval {get; set;}
    public String ciscoid {get; set;}
    public String optyid {get; set;}
    public String optyname {get; set;}
    public String userThemeUI {get; set;}
    public String id = '';
    String parentid = '';
    String accoid ='';
    String contactid = '';
    String cr = '';
 
    public PageReference setThemeFromSession(){
        userThemeUI = Apexpages.currentPage().getParameters().get('userTheme');
        return null;
    }
 
    public String getContextUserUiThemeDisplayed() {
        if (userThemeUI == null)
        return UserInfo.getUiThemeDisplayed();
        else
                return userThemeUI;
    }
 
    public String getId()
    {
 
        return id;
    }
    public void setId(String id){
        this.id = id;
    }
 
    Case caseval = new Case();
 
    public Case getCaseval()
    {
        return caseval;
    }
    public void setCaseval(Case c)
    {
        caseval = c;
    }
    public String AccId = '';
 
    public String contactName{get; set;}
    public Id accountId{get; set;}
    public List<Contact> contacts {get;set;}
 
    public String query {get; set;}
    public List<Contact> contacts1{get; set;}
 
    Boolean count = false;
 
    public Boolean getCount(){
        if(contype == 'Partner' || caseval == null)
            count = true;
        else
                count = false;
        return count;
    }
 
    public void setCount(Boolean count)
    {
        this.count = count;
    }
 
    public String conname = '';
 
    public String getConname()
    {
        return conname;
    }
    public void setConname(String conname){
        this.conname = conname;
    }
 
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
    ////////////////////////////////////////////////////////////////////////Constructor//////////////////////////////////////////////////////////////////
 
    public TSN_SelectReq_CTE(ApexPages.StandardController controller) {
 
        controller1 = controller;
 
        //caseval = new Case();
        String ciscoid = '';
        String cid = '';
        retURL = ApexPages.currentPage().getParameters().get('retURL');
        rType = ApexPages.currentPage().getParameters().get('RecordType');
        if (rType == null) {
            rType = ApexPages.currentPage().getParameters().get('recordTypeId');
 
        }
        cancelURL = ApexPages.currentPage().getParameters().get('cancelURL');
        ent = ApexPages.currentPage().getParameters().get('ent');
        confirmationToken = ApexPages.currentPage().getParameters().get('_CONFIRMATIONTOKEN');
        saveNewURL = ApexPages.currentPage().getParameters().get('save_new_url');
        note =  ApexPages.currentPage().getParameters().get('note');
        parentid = ApexPages.currentPage().getParameters().get('def_parent_id');
        accoid = ApexPages.currentPage().getParameters().get('def_account_id');
        contactid = ApexPages.currentPage().getParameters().get('def_contact_id');
        string isLx = ApexPages.currentPage().getParameters().get('userTheme');
        system.debug('===isLx==>'+isLx);
 
 
        if(ApexPages.currentPage().getParameters().get('00N80000004S02p') != null && ApexPages.currentPage().getParameters().get('00N80000004S02p').contains('@cisco.com') == false)
            cid = ApexPages.currentPage().getParameters().get('00N80000004S02p')+'@cisco.com';
        else
                cid = ApexPages.currentPage().getParameters().get('00N80000004S02p');
 
        ciscoid= ApexPages.currentPage().getParameters().get('Cecid');
        optyid = ApexPages.currentPage().getParameters().get('CF00N80000004w7Ao_lkid');
        optyname = ApexPages.currentPage().getParameters().get('CF00N80000004w7Ao');
        id = ApexPages.currentPage().getParameters().get('id');
        if(id == null)
            id = ApexPages.currentPage().getParameters().get('cr');
 
 
        if(cid != null && cid != '')
            Cecid = cid;
        if(ciscoid != null && ciscoid != '')
            Cecid = ciscoid;
 
 
 
    }
 
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
    /////////////////////////////////////////////////Redirection Logic method which gets invoked from the VF page//////////////////////////////////////////
    public PageReference redirect(){
 
    system.debug('Inside Redirect');
        PageReference returnURL;
        if(note != 'true')
        {
 
            Boolean prof = false;
            // Code change for PSTS RecordType
            if(Utilities.getRecordTypeDefault().contains(Utilities.getCaseTSNRecordTypeId()) || Utilities.getRecordTypeDefault().contains(Utilities.getCasePSTSRecordTypeId())){
                prof = true;
                if(rType == null){
                    system.debug('rtype is null');
                    system.debug(ApexPages.currentPage().getParameters());
                    rType = Utilities.getCaseTSNRecordTypeId();
                } else {
                    if(rType.contains(Utilities.getCaseTSNRecordTypeId()))
                        rType = Utilities.getCaseTSNRecordTypeId();
                    else if(rType.contains(Utilities.getCasePSTSRecordTypeId()))
                        rType = Utilities.getCasePSTSRecordTypeId();
                }
            }
            system.debug('===rType===========================================>'+rType);
            Boolean redirlogic = false;
            if((accoid != null || contactid != null) && UserInfo.getProfileId() == Utilities.getTSNProfileId())
                redirlogic = true;
 
            //Skipping Contact validation page for Case recordtypes of PartnerAdvisor, PartnerHelpLine, CustomerExcellence, ProposalExpertServices,Planning design & Implementation and EngageServices
            //Allowing Contact Validation page for TechnologySolutionNetworkPartnerHelpline and PostSaleTechnicalSupport record types
            system.debug('===Before if===========================================>');
            IF(rType != Utilities.getCasePARecordTypeId()
                    && rType != Utilities.getCasePHRecordTypeId()
                    && rType != Utilities.getConstant_CS('CX Record Type ID')
                    && rType != Utilities.getRequestPXSRecordTypeId()
                    && rType != Utilities.getCasePDIRecordTypeId()
                    && rType != Utilities.getEngageServicesResourcesRecordTypeID()
                    && rType != Utilities.getCustSuccessRecordTypeID()
                    && rType != null
                    && redirlogic == false){
                IF((rType !=null && (rType == Utilities.getCaseTSNRecordTypeId()) || rType == Utilities.getCasePSTSRecordTypeId())){
 
                    ent = 'Case';
                    // Code change for PSTS Record type
                    if(rType == Utilities.getCaseTSNRecordTypeId()){
                        rType = Utilities.getCaseTSNRecordTypeId();
                    }else if (rType  == Utilities.getCasePSTSRecordTypeId()){
                        rType = Utilities.getCasePSTSRecordTypeId();
                    } else rType = Utilities.getCaseTSNRecordTypeId();
                    system.debug('===rType===========================================>'+rType);
                    retURL = '%2F500%2Fo';
 
                    if(Cecid == null)
                        Cecid = '';
                    if(optyname == null)
                        optyname = '';
                    if(optyid == null)
                        optyid = '';
                    if(id == null)
                        id = '';
                    if(parentid == null)
                        parentid = '';
                    if(accoid == null)
                        accoid = '';
                    if(contactid == null)
                        contactid = '';
                    if(id != null)
                        cr = id;
 
                    System.debug('He-Man:'+Utilities.getSuperProfile(UserInfo.getProfileId()));
                    System.debug('Prfo:'+UserInfo.getProfileId());
                    if(UserInfo.getProfileId() != Utilities.getTSNProfileId() && !Utilities.getSuperProfile(UserInfo.getProfileId()))
                        Cecid = UserInfo.getUserName();
 
 
 
                    optyname = EncodingUtil.urlEncode(optyname,'UTF-8');
 
                    returnURL = new PageReference('/apex/SelectReq?ent='+ent+'&nooverride=1&RecordType='+rType+'&retURL='+retURL+'&'+'note=true'+'&Cecid='+Cecid+'&CF00N80000004w7Ao='+optyname+'&CF00N80000004w7Ao_lkid='+optyid+'&def_parent_id='+parentid+'&cr='+cr+'&def_account_id='+accoid+'&def_contact_id='+contactid);
                    returnURL.setRedirect(true);
                }
                return returnURL;
            }else{
                system.debug('inside else block');
                //Redirection to the Opportunity page from which the case has been created when, Engage Resource Record type is clicked from the New Case page(From SAVE & NEW)
 
                ObjectRecordTypeIds__c objRecordTypeSetting = ObjectRecordTypeIds__c.getOrgDefaults();
                String engageCaseRecordTypeId = objRecordTypeSetting.Engage_Services_Resources__c ;
                System.debug('optyid :: '+optyid+ ' '+ engageCaseRecordTypeId);
                list<case> caselist = [select id from case where Opportunity__c =:optyid and RecordTypeid =:engageCaseRecordTypeId limit 1];
                //Shivi-->Added optyid null check for DE244302, redirection to PDI case
                if(caselist.size() >0 && optyid!=null) {
                    //ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Not all items verified');
                    //ApexPages.addMessage(errorMsg);
 
                    returnURL = new PageReference('/'+optyid);
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'TEST====>' ));
                    // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, error ));
                    returnURL.getParameters().put('issavenew','true');
                    returnURL.setRedirect(false);
                    new opportunity().addError('Already created');
                    return returnURL;
                }
 
                if(accoid != null && contactid != null){
                    if(getContextUserUiThemeDisplayed() == 'Theme4d' || getContextUserUiThemeDisplayed() == 'Theme4u'){
                        system.debug('==31==>'+getContextUserUiThemeDisplayed());
                        returnURL = new PageReference('/apex/TSN_SelectReq_Lightning?ent='+ent+'&RecordType='+rType+'&retURL='+retURL+'&def_contact_id='+contactid+'&def_account_id='+accoid+'&nooverride=1&cntTypePtnr=PARTNER');
                        
                    }else{
                        returnURL = new PageReference('/500/e?ent='+ent+'&nooverride=1&RecordType='+rType+'&retURL='+retURL+'&def_contact_id='+contactid+'&def_account_id='+accoid+'&00N80000004S02v=PARTNER');
                    }
                    system.debug('===returnURL1===========================================>'+returnURL);
                }else if(contactid == null && accoid != null){
                    if(getContextUserUiThemeDisplayed() == 'Theme4d' || getContextUserUiThemeDisplayed() == 'Theme4u'){
                        system.debug('==32==>'+getContextUserUiThemeDisplayed());
                        returnURL = new PageReference('/apex/TSN_SelectReq_Lightning?ent='+ent+'&RecordType='+rType+'&retURL='+retURL+'&def_account_id='+accoid+'&nooverride=1&cntTypePtnr=PARTNER');
                    }else{
                        returnURL = new PageReference('/500/e?ent='+ent+'&nooverride=1&RecordType='+rType+'&retURL='+retURL+'&def_account_id='+accoid+'&00N80000004S02v=PARTNER');
                    }
                    system.debug('===returnURL2===========================================>'+returnURL);
                }else if(accoid == null && contactid != null){
                    if(getContextUserUiThemeDisplayed() == 'Theme4d' || getContextUserUiThemeDisplayed() == 'Theme4u'){
                        system.debug('==33==>'+getContextUserUiThemeDisplayed());
                        returnURL = new PageReference('/apex/TSN_SelectReq_Lightning?ent='+ent+'&RecordType='+rType+'&retURL='+retURL+'&def_contact_id='+contactid+'&nooverride=1&cntTypePtnr=PARTNER');
                    }else{
                        returnURL = new PageReference('/500/e?ent='+ent+'&nooverride=1&RecordType='+rType+'&retURL='+retURL+'&def_contact_id='+contactid+'&00N80000004S02v=PARTNER');
                    }
                    system.debug('===returnURL3===========================================>'+returnURL);
                }else{
                    system.debug('inside 2nd else');
                    if(getContextUserUiThemeDisplayed() == 'Theme4d' || getContextUserUiThemeDisplayed() == 'Theme4u'){
                        system.debug('==34==>'+getContextUserUiThemeDisplayed());
                        returnURL = new PageReference('/apex/TSN_SelectReq_Lightning?ent='+ent+'&RecordType='+rType+'&retURL='+retURL+'&nooverride=1');
                        //returnURL  = new PageReference('/lightning/o/'+ent+'/new?RecordType='+rType+'&retURL='+retURL+'&ciscoCntName='+ctName+'&Title='+Title+'&org='+Org+'&wpn='+wpn+'&ipn='+ipn+'&mn='+mn+'&contype='+contype+'&def_contact_id='+def_contact_id+'&Cecid='+Cecid+'&optyname='+optyname+'&optyid='+optyid+'&def_parent_id='+def_parent_id+'&country='+country+'&def_account_id='+def_account_id+'&nooverride=1');
                        
                        system.debug('===returnURL4===========================================>'+returnURL);
                    }else{
                        system.debug('inside 3rd else');
                        returnURL = new PageReference('/500/e?ent='+ent+'&nooverride=1&RecordType='+rType+'&retURL='+retURL+''+'&CF00N80000004w7Ao='+optyname);
                        system.debug('===returnURL5===========================================>'+returnURL);
                    }
                }
 
            }
            system.debug('===returnURL6===========================================>'+returnURL);
            returnURL.getParameters().put('retURL', retURL);
            returnURL.getParameters().put('RecordType', rType);
            returnURL.getParameters().put('cancelURL', cancelURL);
            returnURL.getParameters().put('ent', ent);
            returnURL.getParameters().put('_CONFIRMATIONTOKEN', confirmationToken);
            returnURL.getParameters().put('save_new_url', saveNewURL);
            returnURL.getParameters().put('nooverride', '1');
            if (optyid != null)
                returnURL.getParameters().put('optyid',optyid);
 
 
        }
        system.debug('===returnURL6===========================================>'+returnURL);
        return returnURL;
 
    }
 
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
 
    //////////////////////////////////////////Save method which gets invoked when the "Next" button is clicked///////////////////////////////////////////
 
 
 
    Public PageReference Save(){
        System.debug('Theme from VF:::::::' + userThemeUI);
 
        PageReference page ;
        if(Cecid != null && Cecid != '' &&((Cecid != null && Cecid != ''&& Cecid != cecval) ||Cecid.substring(Cecid.indexOf('@')).length()!= 10)&& contype != 'PARTNER' ||(contype == 'PARTNER' && Cecid != cecval && Cecid != null && Cecid != ''))
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please Validate the Cisco Contact before moving away from this page'));
            return null;
        }
        if((Cecid == null || Cecid == '') && contype == 'CISCO')
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please enter a valid Cisco Contact'));
            return null;
        }
        else if(contype == 'PARTNER'||((Cecid.contains('@cisco.com')||Cecid.contains('@CISCO.COM'))&& Cecid.substring(Cecid.indexOf('@')).length()== 10)||(Cecid != null && Cecid != '' && contype== 'CISCO' &&  count == false)||count)
        {
            if(count)
                caseval = new Case();
            System.debug('count val:'+count);
            System.debug('My God'+caseval);
            String Name = caseval.Cisco_Contact_Name__c;
            String Title = caseval.Cisco_Contact_Title__c;
            String Org = caseval.Cisco_Contact_Organization__c;
            String wpn = caseval.Cisco_Contact_Work_Phone_Number__c;
            String ipn = caseval.Cisco_Contact_Internal_Phone_Number__c;
            String mn = caseval.Cisco_Contact_Mobile_Number__c;
            String country = caseval.Cisco_Country__c;
 
            if(Name == null)
                Name = '';
            if(Title == null)
                Title = '';
            if(Org == null)
                Org = '';
            if(wpn == null)
                wpn = '';
            if(mn == null)
                mn = '';
            if(ipn == null)
                ipn = '';
            if(optyid == null)
                optyid = '';
            if(optyname == null)
                optyname = '';
            if(id == null)
                id = '';
            if(country == null)
                country = '';
 
 
            ent = 'Case';
 
            ObjectRecordTypeIds__c objRecordTypeSettings = ObjectRecordTypeIds__c.getOrgDefaults();
            
 
            // Code change for PSTS Record type
            if(rType == Utilities.getCaseTSNRecordTypeId()){
                rType = Utilities.getCaseTSNRecordTypeId();
            }else if(rType == Utilities.getCasePSTSRecordTypeId()){
                rType = Utilities.getCasePSTSRecordTypeId();
            }else if(rType == Utilities.getCaseWarRoomRecordTypeId()){          
                rType = ApexPages.currentPage().getParameters().get('RecordType');
                System.debug('RecordType 123::::'+rType);
            }else {
                rType = Utilities.getCaseTSNRecordTypeId();
            }
 
 
            retURL = '%2F500%2Fo';
            Title = EncodingUtil.urlEncode(Title,'UTF-8');
            Org = EncodingUtil.urlEncode(Org,'UTF-8');
            optyname = EncodingUtil.urlEncode(optyname,'UTF-8');
 
 
            if(Name == '')
                Cecid = '';
            if(parentid == null)
                parentid = '';
            if(contactid == null)
                contactid = '';
            if(accoid == null)
                accoid = '';
            if(contype == null || contype == '')
                contype = 'CISCO';
 
 
            if(id == null || id == '')
            {
                if(getContextUserUiThemeDisplayed() == 'Theme4d' || getContextUserUiThemeDisplayed() == 'Theme4u'){
                    system.debug('==3==>'+getContextUserUiThemeDisplayed());
                    page = new PageReference('/apex/TSN_SelectReq_Lightning?ent='+ent+'&RecordType='+rType+'&retURL='+retURL+'&ciscoCntName='+Name+'&Title='+Title+'&org='+Org+'&wpn='+wpn+'&ipn='+ipn+'&mn='+mn+'&contype='+contype+'&def_contact_id='+contactid+'&Cecid='+Cecid+'&optyname='+optyname+'&optyid='+optyid+'&def_parent_id='+parentid+'&country='+country+'&def_account_id='+accoid+'&nooverride=1');
                }else{
                    system.debug('==4==>'+getContextUserUiThemeDisplayed());
                    page = new PageReference('/500/e?ent='+ent+'&nooverride=1&RecordType='+rType+'&retURL='+retURL+'&00N80000004w7Ah='+Name+'&00N80000004w7Aj='+Title+'&00N80000004w7Ai='+Org+'&00N80000004w7Ak='+wpn+'&00N80000004w7Af='+ipn+'&00N80000004w7Ag='+mn+'&00N80000004S02v='+contype+'&def_contact_id='+contactid+'&00N80000004S02p='+Cecid+'&CF00N80000004w7Ao='+optyname+'&CF00N80000004w7Ao_lkid='+optyid+'&00N80000004w7Al='+country+'&def_account_id='+accoid);
                }
                if((parentid != null && parentid != '')||(optyid != null || optyid != '')||(accoid != null || accoid != '')||(contactid != null || contactid != ''))
                {
                    if(parentid != null && parentid != '')
                        retURL = '%2F'+parentid;
                    else if(optyid != null && optyid != '')
                        retURL = '%2F'+optyid;
                    else if(accoid != null || accoid != '')
                        retURL = '%2F'+accoid;
                    else if(contactid != null || contactid != '')
                        retURL = '%2F'+contactid;
                    if(retURL ==  '%2F' || retURL == '')
                        retURL = '%2F500%2Fo';
                    if(getContextUserUiThemeDisplayed() == 'Theme4d' || getContextUserUiThemeDisplayed() == 'Theme4u'){
                        system.debug('==1==>'+getContextUserUiThemeDisplayed());
                        page = new PageReference('/apex/TSN_SelectReq_Lightning?ent='+ent+'&RecordType='+rType+'&retURL='+retURL+'&ciscoCntName='+Name+'&Title='+Title+'&org='+Org+'&wpn='+wpn+'&ipn='+ipn+'&mn='+mn+'&contype='+contype+'&def_contact_id='+contactid+'&Cecid='+Cecid+'&optyname='+optyname+'&optyid='+optyid+'&def_parent_id='+parentid+'&country='+country+'&def_account_id='+accoid+'&nooverride=1');
                    }else{
                        system.debug('==2==>'+getContextUserUiThemeDisplayed());
                        page = new PageReference('/500/e?ent='+ent+'&nooverride=1&RecordType='+rType+'&retURL='+retURL+'&00N80000004w7Ah='+Name+'&00N80000004w7Aj='+Title+'&00N80000004w7Ai='+Org+'&00N80000004w7Ak='+wpn+'&00N80000004w7Af='+ipn+'&00N80000004w7Ag='+mn+'&00N80000004S02v='+contype+'&def_contact_id='+contactid+'&00N80000004S02p='+Cecid+'&CF00N80000004w7Ao='+optyname+'&CF00N80000004w7Ao_lkid='+optyid+'&def_parent_id='+parentid+'&00N80000004w7Al='+country+'&def_account_id='+accoid);
                    }
                }
            }
            else
            {
                Title = EncodingUtil.urlDecode(Title,'UTF-8');
                Org = EncodingUtil.urlDecode(Org,'UTF-8');
 
                Title = Title.replace('&','and');
                Org = Org.replace('&','and');
                retURL = '%2F'+id;
 
                if(getContextUserUiThemeDisplayed() == 'Theme4d' || getContextUserUiThemeDisplayed() == 'Theme4u'){
                    page = new PageReference('/apex/TSN_SelectReq_Lightning?ent='+ent+'&RecordType='+rType+'&retURL='+retURL+'&ciscoCntName='+Name+'&Title='+Title+'&org='+Org+'&wpn='+wpn+'&ipn='+ipn+'&mn='+mn+'&contype='+contype+'&def_contact_id='+contactid+'&Cecid='+Cecid+'&optyname='+optyname+'&optyid='+optyid+'&def_parent_id='+parentid+'&country='+country+'&def_account_id='+accoid+'&nooverride=1');
                }else{
                    page = new PageReference('/'+id+'/e?ent='+ent+'&nooverride=1&RecordType='+rType+'&retURL='+retURL+'&00N80000004w7Ah='+Name+'&00N80000004w7Aj='+Title+'&00N80000004w7Ai='+Org+'&00N80000004w7Ak='+wpn+'&00N80000004w7Af='+ipn+'&00N80000004w7Ag='+mn+'&00N80000004S02v='+contype+'&def_contact_id='+contactid+'&00N80000004S02p='+Cecid+'&CF00N80000004w7Ao='+optyname+'&CF00N80000004w7Ao_lkid='+optyid+'&00N80000004w7Al='+country+'&def_account_id='+accoid);
                }
            }
            page.setRedirect(true);
        }
        return page;
    }
 
 
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
 
    ////////////////////////////////////////////////////Cancel Method//////////////////////////////////////////////////////////////////////////////////////
    public PageReference cancel(){
 
        PageReference pagecancel;
 
        System.debug('Hello World:'+ApexPages.currentPage().getParameters().get('def_account_id'));
 
        if((optyid == '' || optyid == null)&& (id == null || id == '')&& (ApexPages.currentPage().getParameters().get('def_account_id') == null ||ApexPages.currentPage().getParameters().get('def_account_id') == '' ) && (ApexPages.currentPage().getParameters().get('def_contact_id') == null ||ApexPages.currentPage().getParameters().get('def_contact_id') == '' )&&(ApexPages.currentPage().getParameters().get('def_parent_id') == null ||ApexPages.currentPage().getParameters().get('def_parent_id') == '' ))
        {
            pagecancel= new PageReference('/500/o');
 
        }
        else if(ApexPages.currentPage().getParameters().get('def_parent_id') != null && ApexPages.currentPage().getParameters().get('def_parent_id') != '')
            pagecancel = new PageReference('/'+ApexPages.currentPage().getParameters().get('def_parent_id'));
        else if(ApexPages.currentPage().getParameters().get('def_account_id') != null ||ApexPages.currentPage().getParameters().get('def_account_id') != '' )
            pagecancel = new PageReference('/'+ApexPages.currentPage().getParameters().get('def_account_id'));
        else if(ApexPages.currentPage().getParameters().get('def_contact_id') != null ||ApexPages.currentPage().getParameters().get('def_contact_id') != '' )
            pagecancel = new PageReference('/'+ApexPages.currentPage().getParameters().get('def_contact_id'));
        else if(id != null && id != '')
            pagecancel = new PageReference('/'+id);
 
        if(ApexPages.currentPage().getParameters().get('cr')!= null && ApexPages.currentPage().getParameters().get('cr')!= ''){
            pagecancel = new PageReference('/'+ApexPages.currentPage().getParameters().get('cr'));
        }
        if(optyid != null && optyid != '')
            pagecancel = new PageReference('/'+optyid);
 
        pagecancel.setredirect(true);
 
        return pagecancel;
    }
 
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
 
    //////////////////////////////////////////Method gets invoked when "Validate Cisco Contact" button is clicked////////////////////////////////////////////
 
    public void getCecval(){
        caseval = (Case)controller1.getRecord();
        String weberr = '';
        System.debug('Theme from VF' + userThemeUI);
        if(Cecid.contains('@cisco.com') == true ||Cecid.contains('@CISCO.COM') == true )
        {
            cecval = Cecid;
            String cec = Cecid.substring(0,Cecid.indexOf('@')).trim().toLowerCase();
            if((Cecid.substring(Cecid.indexOf('@'))=='@CISCO.COM'||Cecid.substring(Cecid.indexOf('@'))=='@cisco.com')&& Cecid.substring(Cecid.indexOf('@')).length()== 10 && !Cecid.substring(0,Cecid.indexOf('@')).contains(' ')&& cec != null && cec!= '')
            {
                caseval = TSNUserUnifiedDetailsWebService.getCecVal(cec);
 
                if(caseval != null){
                    Name = caseval.Cisco_Contact_Name__c;
                    Title = caseval.Cisco_Contact_Title__c;
                    Org = caseval.Cisco_Contact_Organization__c;
                    wpn =  caseval.Cisco_Contact_Work_Phone_Number__c;
                    ipn = caseval.Cisco_Contact_Internal_Phone_Number__c;
                    mn = caseval.Cisco_Contact_Mobile_Number__c;
                }
                else{
                    System.debug('Havahava:'+count);
                    count = true;
                    System.debug('havahava1:'+count);
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Currently the validation service is down. Click on next and manually enter the Case Requester Email Id in the Cisco Contact field on the case creation page.'));
                }
            }
            else
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please enter a valid Cisco Contact'));
            if(cec == null || cec == '' || cec == ' '||Cecid.substring(Cecid.indexOf('@'))!='@cisco.com'||Cecid.substring(Cecid.indexOf('@'))!='@CISCO.COM'||Cecid.substring(Cecid.indexOf('@')).length()!= 10 ||Cecid.substring(0,Cecid.indexOf('@')).contains(' '))
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please enter a valid Cisco Contact'));
        }
        else
        {
            caseVal.Cisco_Contact_Name__c ='';
            caseval.Web_Service_Error_Message__c = '';
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please enter a valid Cisco Contact'));
        }
 
        if(caseval != null && caseval.Web_Service_Error_Message__c != null && caseval.Web_Service_Error_Message__c != '')
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please enter a valid Cisco Contact'));
    }
 
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
    ///////////////////////////////////////////Method to populate Contact Type picklist values////////////////////////////////////////////////////////////
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('CISCO','Cisco'));
        options.add(new SelectOption('PARTNER','Partner'));
        return options;
    }
 
    String contype = '';
    public String getContype() {
        return contype;
    }
    public void setContype(String contype) {
        this.contype = contype;
    }
 
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
}