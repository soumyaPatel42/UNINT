@isTest
private class ADTInboundTest {
    public static String combinedjsonBody='';
    public static String accExtId = '';
    public static String accId;
    public static SYS_IntegrationLog__c insertedlog;
    public static Map<String, String> responseHeaders = new Map<String,String>();
    //ADT_A04
    @isTest static void CheckADTA04InboundRequest() {
        String adtJson = IMSTestDataFactory.ADTA04JSONStatic(1);
        responseHeaders.put('Content-Type', 'application/json');
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new IMSCalloutMock(200,'OK',adtJson,responseHeaders)); 
        //INBOUND Mock Rest Callout
        IMSCallout.requestRestCallout(adtJson,200);
        Test.StartTest();
        SYS_WebServiceIMS.doPostMethod();
        //Get Inserted SysLog Record
        insertedlog = IMSTestDataFactory.getSyslog();
        Test.StopTest();
        System.debug('SYS_IntegrationLog After Insert ' + insertedlog);
        System.assertEquals('INBOUND',insertedlog.Type__c,'Inbound Request Received Successfully');
    }
    @isTest static void CheckADTA04InsertSysIntegrationLog() {
        String adtJson = IMSTestDataFactory.ADTA04JSONStatic(1);
        responseHeaders.put('Content-Type', 'application/json');
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new IMSCalloutMock(200,'OK',adtJson,responseHeaders)); 
        //INBOUND Mock Rest Callout
        IMSCallout.requestRestCallout(adtJson,200);
        Test.StartTest();
        SYS_WebServiceIMS.doPostMethod();
        //Get Inserted SysLog Record
        insertedlog = IMSTestDataFactory.getSyslog();
        Test.StopTest();
        combinedjsonBody =  insertedlog.data0__c+insertedlog.data1__c+insertedlog.data2__c+insertedlog.data3__c+
                        insertedlog.data4__c+insertedlog.data5__c+insertedlog.data6__c+insertedlog.data7__c+
                        insertedlog.data8__c+insertedlog.data9__c;
        System.debug('Actual: '+ adtJson);
        System.debug('Received : '+ combinedjsonBody);
        System.assertEquals('INBOUND',insertedlog.Type__c, 'Successfully Inserted SysLog Type');
        System.assertEquals('RESPONSE',insertedlog.SYS_Operation_Type__c, 'Successfully Inserted SysLog Operation Type');
        System.assertEquals(adtJson,combinedjsonBody, 'Successfully Inserted SysLog JSON');
    }
    
    @isTest static void CheckADTA04AccountWithoutExternalIdCreated() {
        String adtJson = IMSTestDataFactory.ADTA04JSONStatic(-1);
        responseHeaders.put('Content-Type', 'application/json');
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new IMSCalloutMock(200,'OK',adtJson,responseHeaders)); 
        //INBOUND Mock Rest Callout
        IMSCallout.requestRestCallout(adtJson,200);
        Test.StartTest();
        SYS_WebServiceIMS.doPostMethod();
        //Get Inserted SysLog Record
        insertedlog = IMSTestDataFactory.getSyslog();
         Account a = new Account(Name = 'JOHN-DOE-DUMMY-ACC1', RecordTypeId = SYS_integrationLogHandler.getObjectRecordTypeId('Account','Patient'));
            insert a;
        Test.StopTest();
        Account acc = IMSTestDataFactory.getAccountDetails(); 
        
        System.debug('Account Data : '+ acc);
        System.assertNotEquals(acc.CS_External_ID__c,'null', 'Successfully Created Account');
        //System.assertEquals('ADT_A04',acc.Last_Event__c, 'Successfully Created Account Event Type');
    }
    @isTest static void CheckADTA04AccountFailStatusCreated() {
        String adtJson = IMSTestDataFactory.ADTA04JSONStatic(-1);
        responseHeaders.put('Content-Type', 'application/json');
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new IMSCalloutMock(400,'OK',adtJson,responseHeaders)); 
        //INBOUND Mock Rest Callout
        IMSCallout.requestRestCallout(adtJson,400);
        Test.StartTest();
        SYS_WebServiceIMS.doPostMethod();
        //Get Inserted SysLog Record
        insertedlog = IMSTestDataFactory.getSyslog();
         Account a = new Account(Name = 'JOHN-DOE-DUMMY-ACC1', RecordTypeId = SYS_integrationLogHandler.getObjectRecordTypeId('Account','Patient'));
            insert a;
        Test.StopTest();
        Account acc = IMSTestDataFactory.getAccountDetails(); 
        
        System.debug('Account Data : '+ acc);
        System.assertNotEquals(acc.CS_External_ID__c,'null', 'Successfully Created Account');
        //System.assertEquals('ADT_A04',acc.Last_Event__c, 'Successfully Created Account Event Type');
    }
    
    @isTest static void CheckADTA04AccountCreated() {
        String adtJson = IMSTestDataFactory.ADTA04JSONStatic(1);
        responseHeaders.put('Content-Type', 'application/json');
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new IMSCalloutMock(200,'OK',adtJson,responseHeaders)); 
        //INBOUND Mock Rest Callout
        IMSCallout.requestRestCallout(adtJson,200);
        Test.StartTest();
        SYS_WebServiceIMS.doPostMethod();
        //Get Inserted SysLog Record
        insertedlog = IMSTestDataFactory.getSyslog();
        Test.StopTest();
        Account acc = IMSTestDataFactory.getAccountDetails();                
        System.debug('Account Data : '+ acc);
        System.assertEquals('75412',acc.CS_External_ID__c, 'Successfully Created Account');
        System.assertEquals('ADT_A04',acc.Last_Event__c, 'Successfully Created Account Event Type');
    }

    @isTest static void CheckADTA04SingleInsuranceCreated() {
        String adtJson = IMSTestDataFactory.ADTA04JSONStatic(1);
        responseHeaders.put('Content-Type', 'application/json');
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new IMSCalloutMock(200,'OK',adtJson,responseHeaders)); 
        //INBOUND Mock Rest Callout
        IMSCallout.requestRestCallout(adtJson,200);
        Test.StartTest();
        SYS_WebServiceIMS.doPostMethod();
        //Get Inserted SysLog Record
        insertedlog = IMSTestDataFactory.getSyslog();
        Test.StopTest();
        Account acc = IMSTestDataFactory.getAccountDetails();                
        List< MemberPlan > insurances = IMSTestDataFactory.getInsuranceDetails(acc.CS_External_ID__c);                
        System.debug('Account Data : '+ acc);
        System.assertNotEquals(insurances.size(),0, 'Successfully Created Insurance');

        for(MemberPlan insur:insurances){
            System.assertEquals('ANTHEM BLUE CROSS BLUE SHIELD',insur.Insurance_Company_Organization_Name__c, 'Successfully Created Insurance Plan');
            System.assertEquals('75412',insur.SYS_Parent__c, 'Insurance Successfully Linked to Account');
            System.debug('Insurance Data : '+ insur);
        }
    }
    @isTest static void CheckADTA04MultiInsuranceCreated() {
        String adtJson = IMSTestDataFactory.ADTA04JSONStatic(2);
        responseHeaders.put('Content-Type', 'application/json');
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new IMSCalloutMock(200,'OK',adtJson,responseHeaders)); 
        //INBOUND Mock Rest Callout
        IMSCallout.requestRestCallout(adtJson,200);
        Test.StartTest();
        SYS_WebServiceIMS.doPostMethod();
        //Get Inserted SysLog Record
        insertedlog = IMSTestDataFactory.getSyslog();
        Test.StopTest();
        Account acc = IMSTestDataFactory.getAccountDetails();                
        List< MemberPlan > insurances = IMSTestDataFactory.getInsuranceDetails(acc.CS_External_ID__c);                
        System.debug('Account Data : '+ acc);
        System.assertNotEquals(insurances.size(),0, 'Successfully Created Insurance');

        for(MemberPlan insur:insurances){
            System.assertEquals('ANTHEM BLUE CROSS BLUE SHIELD',insur.Insurance_Company_Organization_Name__c, 'Successfully Created Insurance Plan');
            System.assertEquals('75412',insur.SYS_Parent__c, 'Insurance Successfully Linked to Account');
            System.debug('Insurance Data : '+ insur);
        }
    }
    @isTest static void CheckADTA04NoInsuranceCreated() {
        String adtJson = IMSTestDataFactory.ADTA04JSONStatic(0);
        responseHeaders.put('Content-Type', 'application/json');
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new IMSCalloutMock(200,'OK',adtJson,responseHeaders)); 
        //INBOUND Mock Rest Callout
        IMSCallout.requestRestCallout(adtJson,200);
        Test.StartTest();
        SYS_WebServiceIMS.doPostMethod();
        //Get Inserted SysLog Record
        insertedlog = IMSTestDataFactory.getSyslog();
        Test.StopTest();
        Account acc = IMSTestDataFactory.getAccountDetails();                
        List< MemberPlan > insurances = IMSTestDataFactory.getInsuranceDetails(acc.CS_External_ID__c);                
        System.debug('Account Data : '+ acc);
        System.assertEquals(0,insurances.size(), 'Successfully Created Insurance');
    }
    //ADT_A08
    @isTest static void CheckADTA08InboundRequest() {
        String adtJson = IMSTestDataFactory.ADTA08JSONStatic(1);
        responseHeaders.put('Content-Type', 'application/json');
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new IMSCalloutMock(200,'OK',adtJson,responseHeaders)); 
        //INBOUND Mock Rest Callout
        IMSCallout.requestRestCallout(adtJson,200);
        Test.StartTest();
        SYS_WebServiceIMS.doPostMethod();
        //Get Inserted SysLog Record
        insertedlog = IMSTestDataFactory.getSyslog();
        Test.StopTest();
        System.debug('SYS_IntegrationLog After Insert ' + insertedlog);
        System.assertEquals('INBOUND',insertedlog.Type__c,'Inbound Request Received Successfully');
    }
    @isTest static void CheckADTA08InsertSysIntegrationLog() {
        String adtJson = IMSTestDataFactory.ADTA08JSONStatic(1);
        responseHeaders.put('Content-Type', 'application/json');
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new IMSCalloutMock(200,'OK',adtJson,responseHeaders)); 
        //INBOUND Mock Rest Callout
        IMSCallout.requestRestCallout(adtJson,200);
        Test.StartTest();
        SYS_WebServiceIMS.doPostMethod();
        //Get Inserted SysLog Record
        List<SYS_IntegrationLog__c> insertedLogs = [SELECT Name,Status__c,SYS_Http_Status__c,SYS_Operation_Type__c,SYS_RequestId__c,Type__c,WhatId__c,data0__c,data1__c,data2__c,data3__c,data4__c,data5__c,data6__c,data7__c,data8__c,data9__c FROM SYS_IntegrationLog__c];
        insertedlog = IMSTestDataFactory.getSyslog();
        Test.StopTest();
        combinedjsonBody =  insertedlog.data0__c+insertedlog.data1__c+insertedlog.data2__c+insertedlog.data3__c+
                        insertedlog.data4__c+insertedlog.data5__c+insertedlog.data6__c+insertedlog.data7__c+
                        insertedlog.data8__c+insertedlog.data9__c;
        System.debug('Actual: '+ adtJson);
        System.debug('Received : '+ combinedjsonBody);
        System.assertEquals('INBOUND',insertedlog.Type__c, 'Successfully Inserted SysLog Type');
        System.assertEquals('RESPONSE',insertedlog.SYS_Operation_Type__c, 'Successfully Inserted SysLog Operation Type');
        System.assertEquals(adtJson,combinedjsonBody, 'Successfully Inserted SysLog JSON');
    }
        
    @isTest static void CheckADTA08AccountCreated() {
        String adtJson = IMSTestDataFactory.ADTA08JSONStatic(1);
        responseHeaders.put('Content-Type', 'application/json');
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new IMSCalloutMock(200,'OK',adtJson,responseHeaders)); 
        //INBOUND Mock Rest Callout
        IMSCallout.requestRestCallout(adtJson,200);
        Test.StartTest();
        SYS_WebServiceIMS.doPostMethod();
        //Get Inserted SysLog Record
        insertedlog = IMSTestDataFactory.getSyslog();
        Test.StopTest();
        Account acc = IMSTestDataFactory.getAccountDetails();                
        System.debug('Account Data : '+ acc);
        System.assertEquals('A80525',acc.CS_External_ID__c, 'Successfully Created Account');
        System.assertEquals('ADT_A08',acc.Last_Event__c, 'Successfully Created Account Event Type');
    }

    @isTest static void CheckADTA08NoInsuranceCreated() {
        String adtJson = IMSTestDataFactory.ADTA08JSONStatic(0);
      	System.debug('TD adtJson' + adtJson);
        responseHeaders.put('Content-Type', 'application/json');
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new IMSCalloutMock(200,'OK',adtjson,responseHeaders)); 
        //INBOUND Mock Rest Callout
        IMSCallout.requestRestCallout(adtJson,200);
        Test.StartTest();
        SYS_WebServiceIMS.doPostMethod();
        //Get Inserted SysLog Record
        insertedlog = IMSTestDataFactory.getSyslog();
        Test.StopTest();
        Account acc = IMSTestDataFactory.getAccountDetails();                
        List< MemberPlan > insurances = IMSTestDataFactory.getInsuranceDetails(acc.CS_External_ID__c);                
        System.debug('Account Data : '+ acc);
        System.debug('Insurance Data : '+ insurances);
        System.assertEquals(0,insurances.size(), 'Successfully Found No Insurance');

    }
    @isTest static void CheckADTA08SingleInsuranceCreated() {
        String adtJson = IMSTestDataFactory.ADTA08JSONStatic(1);
      	System.debug('TD adtJson' + adtJson);
        responseHeaders.put('Content-Type', 'application/json');
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new IMSCalloutMock(200,'OK',adtjson,responseHeaders)); 
        //INBOUND Mock Rest Callout
        IMSCallout.requestRestCallout(adtJson,200);
        Test.StartTest();
        SYS_WebServiceIMS.doPostMethod();
        //Get Inserted SysLog Record
        insertedlog = IMSTestDataFactory.getSyslog();
        Test.StopTest();
        Account acc = IMSTestDataFactory.getAccountDetails();                
        List< MemberPlan > insurances = IMSTestDataFactory.getInsuranceDetails(acc.CS_External_ID__c);                
        System.debug('Account Data : '+ acc);
        System.debug('Insurance Data : '+ insurances);
        System.assertNotEquals(insurances.size(),0, 'Successfully Created Insurance');

        for(MemberPlan insur:insurances){
            System.assertEquals('UCARE OF MINNESOTA - MWE',insur.Insurance_Company_Organization_Name__c, 'Successfully Created Insurance Plan');
            System.assertEquals('A80525',insur.SYS_Parent__c, 'Insurance Successfully Linked to Account');
            System.debug('Insurance Data : '+ insur);
        }
    }
    @isTest static void CheckADTA08MultiInsuranceCreated() {
        String adtJson = IMSTestDataFactory.ADTA08JSONStatic(2);
      	System.debug('TD adtJson' + adtJson);
        responseHeaders.put('Content-Type', 'application/json');
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new IMSCalloutMock(200,'OK',adtjson,responseHeaders)); 
        //INBOUND Mock Rest Callout
        IMSCallout.requestRestCallout(adtJson,200);
        Test.StartTest();
        SYS_WebServiceIMS.testVal = true;
        SYS_WebServiceIMS.doPostMethod();
        //Get Inserted SysLog Record
        insertedlog = IMSTestDataFactory.getSyslog();
        Test.StopTest();
        Account acc = IMSTestDataFactory.getAccountDetails();                
        List< MemberPlan > insurances = IMSTestDataFactory.getInsuranceDetails(acc.CS_External_ID__c);                
        System.debug('Account Data : '+ acc);
        System.debug('Insurance Data : '+ insurances);
        System.assertNotEquals(insurances.size(),0, 'Successfully Created Insurance');

        for(MemberPlan insur:insurances){
            System.assertEquals('UCARE OF MINNESOTA - MWE',insur.Insurance_Company_Organization_Name__c, 'Successfully Created Insurance Plan');
            System.assertEquals('A80525',insur.SYS_Parent__c, 'Insurance Successfully Linked to Account');
            System.debug('Insurance Data : '+ insur);
        }
    }

}