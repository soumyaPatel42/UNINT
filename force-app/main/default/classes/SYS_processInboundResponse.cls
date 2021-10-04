public class SYS_processInboundResponse implements Queueable {
    public List<Id> sysLogResponseIds = new List<Id>();

    public SYS_processInboundResponse(List<Id> idList) {
        this.sysLogResponseIds = idList;
    }

    public void execute(QueueableContext context) {
    // public void updateSyncToken(){
        String jsonBody;
        List<SYS_IntegrationLog__c> respLogs = [SELECT id,
                                                data0__c,
                                                data1__c,
                                                data2__c,
                                                data3__c,
                                                data4__c,
                                                data5__c,
                                                data6__c,
                                                data7__c,
                                                data8__c,
                                                data9__c,
                                                Type__c,WhatId__c,Parent__c,Order__c, Status__c, SYS_IntegrationSettings__c
                                                FROM SYS_IntegrationLog__c WHERE Id in : sysLogResponseIds AND SYS_Operation_Type__c = 'RESPONSE'];
        // List<Id> allWhatIds = new List<Id>();
        Map<String, sObject> mapIdtoObject = new Map<String, sObject>();
        List<sObject> updateObjects = new List<sObject>();
        // String objectName = '';
        // if(respLogs.size() > 0)
        //     objectName = ((Id)respLogs[0].WhatId__c).getSObjectType() + '';
        System.debug('Here size==' + respLogs.size() + ' daat=='+respLogs +'obj name==');
            
        for(SYS_IntegrationLog__c log : respLogs) {
            jsonBody =  log.data0__c != null ? log.data0__c : '' +
                        log.data1__c != null ? log.data1__c : '' +
                        log.data2__c != null ? log.data2__c : '' +
                        log.data3__c != null ? log.data3__c : '' +
                        log.data4__c != null ? log.data4__c : '' +
                        log.data5__c != null ? log.data5__c : '' + 
                        log.data6__c != null ? log.data6__c : '' +
                        log.data7__c != null ? log.data7__c : '' +
                        log.data8__c != null ? log.data8__c : '' +
                        log.data9__c != null ? log.data9__c : '' ;
            SYS_DataCache.sObjectApiName = 'Case';
            SYS_Constants.INT_TYPE = log.SYS_IntegrationSettings__c; 
            if(log.SYS_IntegrationSettings__c == 'Quickbooks') {
                // SYS_integrationLogHandler.transformGETResponseAndUpsertQB( jsonBody , log.WhatId__c);
            } else if (log.SYS_IntegrationSettings__c == 'JIRA') {
                SYS_integrationLogHandler.transformJIRArequest( jsonBody );
            } 
            
        }   
    }
}