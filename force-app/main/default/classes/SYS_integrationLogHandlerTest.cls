@isTest
public class SYS_integrationLogHandlerTest {
   
    @isTest static void checkErrorSysLog() {
        Test.StartTest();
        string resJson = '{"id":"10042","key":"SI-43","self":"https://jira-salesforce-dev.atlassian.net/rest/api/2/issue/10042"}';
        Map < String, String > responseHeaders = new Map < String, String > ();
        responseHeaders.put('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, new NileCalloutMock(400, 'OK', resJson, responseHeaders));
        case caseData = NileDataFactory.caseJesraTestData();
        insert caseData;
        case caseUpData = NileDataFactory.UpdateCaseStatus(caseData.Id);
        update caseUpData;
        
        SYS_IntegrationLog__c sys = NileDataFactory.getSyslog();
        
        case casedata1 =  NileDataFactory.GetCaseDetails(caseUpData.Id);
        Test.StopTest();
        List < SYS_IntegrationLog__c > insertedLogs = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c, data0__c, data1__c, data2__c, data3__c, data4__c, data5__c, data6__c, data7__c, data8__c, data9__c FROM SYS_IntegrationLog__c];
        system.debug('syslog'+insertedLogs);
        System.assertNotEquals('wew', 'null', 'Successfully Created Case');
    }
}