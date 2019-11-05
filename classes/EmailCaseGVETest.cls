/****************************************************************************************************
 * Description - Test Class for EmailCaseGVE 
 * Author - Naresh Kalahasthi
 ****************************************************************************************************/

@IsTest
private class EmailCaseGVETest {


    static testMethod void testCreateCaseSalesforceUser() {
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env    = new Messaging.InboundEnvelope();
        Messaging.InboundEmail.BinaryAttachment inAtt = new Messaging.InboundEmail.BinaryAttachment();
        Messaging.InboundEmail.Header head = new Messaging.InboundEmail.Header();
        email.headers=new Messaging.InboundEmail.Header[1];         

        head.name='To'; 
        head.value='tsn-request-german@cisco.com'; 
        email.headers[0]=head ;  
        email.subject = 'Create Contact';
        email.plainTextBody = 'FromEmail';
        email.fromAddress = 'amesingh@cisco.com';
        env.fromAddress = 'amesingh@cisco.com';
        env.toaddress = 'tsn-request-german@cisco.com';
        inAtt.body = blob.valueOf('test');
        inAtt.fileName = 'my attachment name';
        inAtt.mimeTypeSubType = 'plain/txt';
 
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] {inAtt };

 
        EmailCaseGVE creatCa = new EmailCaseGVE();
        creatCa.handleInboundEmail(email, env );
        
        //System.assert (result.success, 'InboundEmailResult returned a failure message');
        
    }
     static testMethod void testCreateCaseNOTSalesforceUser() {
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env    = new Messaging.InboundEnvelope();
        Messaging.InboundEmail.Header head = new Messaging.InboundEmail.Header();
        email.headers=new Messaging.InboundEmail.Header[1];         

        head.name='To'; 
        head.value='tsn-request-korean@cisco.com'; 
        email.headers[0]=head ; 
        email.subject = 'Create Contact';
        email.plainTextBody = 'FromEmail';
        email.fromAddress = 'pchokkal@cisco.com';
        env.fromAddress =  'pchokkal@cisco.com';
        env.toaddress = 'tsn-request-korean@cisco.com';
 
        EmailCaseGVE creatCa = new EmailCaseGVE();
        creatCa.handleInboundEmail(email, env );
        
        //System.assert (result.success, 'InboundEmailResult returned a failure message');
        
    }
    static testMethod void testCreateCaseFrmEmail_forExternal() {
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env    = new Messaging.InboundEnvelope();
        Messaging.InboundEmail.Header head = new Messaging.InboundEmail.Header();
        email.headers=new Messaging.InboundEmail.Header[1];         

        head.name='To'; 
        head.value='tsn-request-italain@cisco.com'; 
        email.headers[0]=head ; 
        email.subject = 'Create Contact';
        email.plainTextBody = 'FromEmail';
        email.fromAddress = 'nareshkalahasthi@gmail.com';
        env.fromAddress = 'nareshkalahasthi@gmail.com';
        env.toaddress = 'tsn-request-italain@cisco.com';
 
        EmailCaseGVE creatCa = new EmailCaseGVE();
        creatCa.handleInboundEmail(email, env );
        
        //System.assert (result.success, 'InboundEmailResult returned a failure message');
        
    }
    static testMethod void testCreateCaseAttachemnetFail() {
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env    = new Messaging.InboundEnvelope();
        Messaging.InboundEmail.BinaryAttachment inAtt = new Messaging.InboundEmail.BinaryAttachment();
        Messaging.InboundEmail.Header head = new Messaging.InboundEmail.Header();
        email.headers=new Messaging.InboundEmail.Header[1];         

        head.name='To'; 
        head.value='tsn-request-german@cisco.com'; 
        email.headers[0]=head ;  
        email.subject = 'Create Contact';
        email.plainTextBody = 'FromEmail';
        email.fromAddress = 'sfdc-integration-apex-exceptions=external.cisco.com@example.com';
        env.fromAddress = 'sfdc-integration-apex-exceptions=external.cisco.com@example.com';
        env.toaddress = 'tsn-request-german@cisco.com';
        inAtt.body = blob.valueOf('');
        inAtt.fileName = '';
        inAtt.mimeTypeSubType = '';
 
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] {inAtt };

 
        EmailCaseGVE creatCa = new EmailCaseGVE();
        creatCa.handleInboundEmail(email, env );
        
        //System.assert (result.success, 'InboundEmailResult returned a failure message');
        
    }
    
        static testMethod void testCreateCaseJapaneseL() {
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env    = new Messaging.InboundEnvelope();
        Messaging.InboundEmail.Header head = new Messaging.InboundEmail.Header();
        email.headers=new Messaging.InboundEmail.Header[1];         

        head.name='To'; 
        head.value='tsn-request-japanese@cisco.com'; 
        email.headers[0]=head ; 
        email.subject = 'Create Contact';
        email.plainTextBody = 'FromEmail';
        email.fromAddress = 'pchokkal@cisco.com';
        env.fromAddress =  'pchokkal@cisco.com';
        env.toaddress = 'tsn-request-japanese@cisco.com';
 
        EmailCaseGVE creatCa = new EmailCaseGVE();
        creatCa.handleInboundEmail(email, env );
        
        //System.assert (result.success, 'InboundEmailResult returned a failure message');
        
    }      
         
}