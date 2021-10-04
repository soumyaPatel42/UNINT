@isTest
public class NileOutboundTest {
    @isTest static void JIRAcaseoutboundtest(){
       
        string resJson ='{"id":"10042","key":"SI-43","self":"https://jira-salesforce-dev.atlassian.net/rest/api/2/issue/10042"}';
        Map<String, String> responseHeaders = new Map<String,String>();
        responseHeaders.put('Content-Type', 'application/json');
        
        Test.setMock(HttpCalloutMock.class, new NileCalloutMock(200,'OK',resJson,responseHeaders));
        case caseData1 = NileDataFactory.caseJesraTestData();
        test.startTest();
        insert caseData1;
        case caseUpData = NileDataFactory.UpdateCaseStatus(caseData1.Id);
        SYS_InvocableHandler.MyInvocableVariable invokeVar = new SYS_InvocableHandler.MyInvocableVariable();
        List<SYS_InvocableHandler.MyInvocableVariable> invokeList = new List<SYS_InvocableHandler.MyInvocableVariable>();
        invokeVar.integrationSetting = 'JIRA';
        invokeVar.newVal = caseData1;
        invokeVar.recId = caseData1.Id;
        invokeList.add(invokeVar);
        //update caseUpData;
        SYS_InvocableHandler.printOldAndCurrentValues(invokeList);
        test.stopTest();
        
        SYS_IntegrationLog__c sys = NileDataFactory.getSyslog();
        case casedata =  NileDataFactory.GetCaseDetails(caseData1.Id);
        List < SYS_IntegrationLog__c > insertedLogs = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c, data0__c, data1__c, data2__c, data3__c, data4__c, data5__c, data6__c, data7__c, data8__c, data9__c FROM SYS_IntegrationLog__c];
        system.debug('syslog'+insertedLogs.size());
        system.assertEquals('10042', casedata.SYS_Key1__c);
        system.assertEquals('SI-43', casedata.Jira_Key__c);
        
        
    }   
    @isTest static  void AIRTABLEcaseoutboundtest(){
        String resJson = '{"records":[{"id":"recxMcBbv44HELSLl","fields":{"Name":"Partner Portal Update","Notes":"The ticket is of high priority","Status":"In progress"},"createdTime":"2021-09-24T23:15:40.000Z"}]}';
        Map<String, String> responseHeaders = new Map<String,String>();
        responseHeaders.put('Content-Type', 'application/json');
       
        Test.setMock(HttpCalloutMock.class, new NileCalloutMock(200,'OK',resJson,responseHeaders));
         test.startTest();
        case caseData1 = NileDataFactory.caseAidtableTestData();
        
        insert caseData1;
        SYS_InvocableHandler.MyInvocableVariable invokeVar = new SYS_InvocableHandler.MyInvocableVariable();
        List<SYS_InvocableHandler.MyInvocableVariable> invokeList = new List<SYS_InvocableHandler.MyInvocableVariable>();
        invokeVar.integrationSetting = 'Airtable';
        invokeVar.newVal = caseData1;
        invokeVar.recId = caseData1.Id;
        invokeList.add(invokeVar);
        //update caseUpData;
        SYS_InvocableHandler.printOldAndCurrentValues(invokeList);
        test.stopTest();
        
        
        case casedata =  NileDataFactory.GetCaseDetails(caseData1.Id);
        SYS_IntegrationLog__c sys = NileDataFactory.getSyslog();
        system.debug('linesys'+sys);
        system.debug('line38'+casedata);
        list<SYS_IntegrationLog__c> syslog = [select Id,data0__c,SYS_RequestId__c,SYS_Operation_Type__c, WhatId__c from SYS_IntegrationLog__c];
        system.debug('line42  sys'+syslog);
        case casedatas = NileDataFactory.GetCaseDetails(caseData1.Id);
        System.debug('line casedatas: ' + casedatas);
        
        List < SYS_IntegrationLog__c > insertedLogs = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c, data0__c, data1__c, data2__c, data3__c, data4__c, data5__c, data6__c, data7__c, data8__c, data9__c FROM SYS_IntegrationLog__c];
        system.debug('syslog'+insertedLogs.size());
        system.assertEquals('NEW', sys.Status__c);
        System.assertEquals('recxMcBbv44HELSLl', casedata.SYS_Key2__c);
    } 
    
    
}