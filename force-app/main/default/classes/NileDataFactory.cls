public class NileDataFactory {
    public static case caseJesraTestData() {
        case caseJesra = new
        case ();
        caseJesra.Priority = 'medium';
        caseJesra.RecordTypeId =  SYS_integrationLogHandler.getObjectRecordTypeId('Case', 'Complaint'); //'0128G000000ChJXQA0';
        caseJesra.Origin = 'phone';
        caseJesra.Status = 'new';
        caseJesra.Description = 'new ticket';
        caseJesra.Subject = 'JIRA ticket-2 changed';
        return caseJesra;
    }
    public static case UpdateCaseStatus(string caseId) {
        case casedata = [select SYS_Key1__c, SYS_Key2__c, Priority, Origin, Status, Reason, Description, Subject from
            case where Id =: caseId
        ];
        casedata.Status = 'Escalated';

        return casedata;
    }
    public static case GetCaseDetails(string caseId) {
        case casedata = [select Priority, Origin, Status, Reason, Description, Subject, SYS_Key1__c, SYS_Key2__c,Jira_Key__c, JIRA_Status__c  from Case where Id =: caseId];
		System.debug('casedata: ' + casedata);
        return casedata;
    }
    public static case caseAidtableTestData() { 
        case caseAidtable = new
        case ();
        caseAidtable.Priority = 'Heigh';
        caseAidtable.RecordTypeId = SYS_integrationLogHandler.getObjectRecordTypeId('Case', 'Enhancement Request');
        caseAidtable.Status = 'on Hold';
        caseAidtable.Reason = 'complex functionality';
        caseAidtable.Description = 'new ticket';
        caseAidtable.Subject = 'Aidtable ticket';
        return caseAidtable;
        }
  
    public static SYS_IntegrationLog__c getSyslog() {
        List < SYS_IntegrationLog__c > insertedLogs = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c, data0__c, data1__c, data2__c, data3__c, data4__c, data5__c, data6__c, data7__c, data8__c, data9__c FROM SYS_IntegrationLog__c];
        system.debug('syslog'+insertedLogs);
        // SYS_IntegrationLog__c insertedlog = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c, data0__c, data1__c, data2__c, data3__c, data4__c, data5__c, data6__c, data7__c, data8__c, data9__c FROM SYS_IntegrationLog__c WHERE Id =: insertedLogs[0].id];
        // insertedlog.data0__c = (insertedlog.data0__c != null) ? insertedlog.data0__c : '';
        // system.debug(' line16' + insertedlog);
        // if ((insertedlog.data1__c == null)) {
        //     insertedlog.data1__c = '';
        // }
        // if ((insertedlog.data2__c == null)) {
        //     insertedlog.data2__c = '';
        // }
        // if ((insertedlog.data3__c == null)) {
        //     insertedlog.data3__c = '';
        // }
        // if ((insertedlog.data4__c == null)) {
        //     insertedlog.data4__c = '';
        // }
        // if ((insertedlog.data5__c == null)) {
        //     insertedlog.data5__c = '';
        // }
        // if ((insertedlog.data6__c == null)) {
        //     insertedlog.data6__c = '';
        // }
        // if ((insertedlog.data7__c == null)) {
        //     insertedlog.data7__c = '';
        // }
        // if ((insertedlog.data8__c == null)) {
        //     insertedlog.data8__c = '';
        // }
        // if ((insertedlog.data9__c == null)) {
        //     insertedlog.data9__c = '';
        // }
        return insertedLogs.size() > 0 ? insertedLogs[0] : new SYS_IntegrationLog__c();
    }
}