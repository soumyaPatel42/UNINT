public class SYS_processInboundCDC_QB implements Queueable, Database.AllowsCallouts {
    List<Id> sysLogIds = new List<Id>();

    public SYS_processInboundCDC_QB(List<Id> idList) {
        this.sysLogIds = idList;
    }

    public void execute(QueueableContext context) {
        List<SYS_IntegrationLog__c> sysLog = [SELECT id,
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
                                              Type__c,WhatId__c,Parent__c,Order__c, SYS_Operation_Type__c
                                              FROM SYS_IntegrationLog__c WHERE Id in:sysLogIds];
        Http http = new Http();
        // List<Account> upsertItemAcc = new List<Account>();
        // List<Opportunity> upsertItemOpp = new List<Opportunity>();
        // List<Product2> upsertItemProd = new List<Product2>();

        HttpRequest req = SYS_HttpBuilder.getHttpRequestGET();
        List<SYS_IntegrationLog__c> insertResponse = new List<SYS_IntegrationLog__c>();
        List<Id> sysLogResponse = new List<Id>();
        for(SYS_IntegrationLog__c log:sysLog){
                String body = log.data0__c+log.data1__c+log.data2__c+log.data3__c+
                log.data4__c+log.data5__c+log.data6__c+log.data7__c+
                log.data8__c+log.data9__c;
                String entityName;
                String entityId;
                cls_entities respObj = (cls_entities)System.JSON.deserialize(body, cls_entities.class);
                
                
                entityName = respObj.name;
                entityId = respObj.id;
                req.setEndpoint(SYS_HttpBuilder.getResourceReadUrl(entityName , entityId) );
                
                //##Hit the webservice
                //TODO - Use limit api to avoid gov limit
                //TODO - add a method for response log
                HttpResponse resp = http.send(req);
                if(resp.getStatusCode() != 200){
                    SYS_debug.log('#### resp status: '+resp.getStatus());
                    SYS_debug.log('#### resp code: '+resp.getStatusCode());
                    SYS_debug.log('#### resp: '+resp.getBody());
                    SYS_IntegrationLog__c logResp = SYS_integrationLogHandler.getLogsToInsert(resp.getBody());
                    if (Schema.sObjectType.SYS_IntegrationLog__c.fields.Status__c.isCreateable()) {
                    logResp.Status__c = 'ERROR';
                    }
                    if (Schema.sObjectType.SYS_IntegrationLog__c.fields.SYS_Http_Status__c.isCreateable()) {
                    logresp.SYS_Http_Status__c = integer.valueOf(resp.getStatusCode());
                    }
                    if (Schema.sObjectType.SYS_IntegrationLog__c.fields.SYS_RequestId__c.isCreateable()) {
                    logResp.SYS_RequestId__c = log.Id;
                    }
                    if (Schema.sObjectType.SYS_IntegrationLog__c.fields.WhatId__c.isCreateable()) {
                    logResp.WhatId__c = log.WhatId__c;
                    }
                    if (Schema.sObjectType.SYS_IntegrationLog__c.fields.QB_Entity__c.isCreateable()) {
                    logResp.QB_Entity__c = SYS_Constants.entityNameToObjapiName.get(entityName);
                    }
                    if (Schema.sObjectType.SYS_IntegrationLog__c.fields.Type__c.isCreateable()) {
                    logResp.Type__c = 'INBOUND';
                    }
                    if (Schema.sObjectType.SYS_IntegrationLog__c.fields.SYS_Operation_Type__c.isCreateable()) {
                    logResp.SYS_Operation_Type__c = 'RESPONSE'; 
                    }
                    insertResponse.add(logResp);
                }
                else{
                    SYS_debug.log('tranfform@@');
                    
                    SYS_IntegrationLog__c logResp = SYS_integrationLogHandler.getLogsToInsert(resp.getBody());
                    if (Schema.sObjectType.SYS_IntegrationLog__c.fields.Status__c.isCreateable()) {
                    logResp.Status__c = 'NEW';
                    }
                    if (Schema.sObjectType.SYS_IntegrationLog__c.fields.SYS_Http_Status__c.isCreateable()) {
                    logresp.SYS_Http_Status__c = Integer.valueOf(resp.getStatusCode());
                    }
                    if (Schema.sObjectType.SYS_IntegrationLog__c.fields.SYS_RequestId__c.isCreateable()) {
                    logResp.SYS_RequestId__c = log.Id;
                    }
                    if (Schema.sObjectType.SYS_IntegrationLog__c.fields.WhatId__c.isCreateable()) {
                    logResp.WhatId__c = log.WhatId__c;
                    }
                    if (Schema.sObjectType.SYS_IntegrationLog__c.fields.QB_Entity__c.isCreateable()) {
                    logResp.QB_Entity__c = SYS_Constants.entityNameToObjapiName.get(entityName);
                    }
                    if (Schema.sObjectType.SYS_IntegrationLog__c.fields.Type__c.isCreateable()) {
                    logResp.Type__c = 'INBOUND';
                    }
                    if (Schema.sObjectType.SYS_IntegrationLog__c.fields.SYS_IntegrationSettings__c.isCreateable()) {
                    logResp.SYS_IntegrationSettings__c = 'Quickbooks';
                    }
                    if (Schema.sObjectType.SYS_IntegrationLog__c.fields.SYS_Operation_Type__c.isCreateable()) {
                    logResp.SYS_Operation_Type__c = 'RESPONSE';
                    }
                    insertResponse.add(logResp);
                }
            
            
        }
        SYS_debug.log('##insert list size= '+insertResponse.size());
        if(insertResponse.size() > 0) {
            SYS_debug.log('##insert all response logs');
            Database.SaveResult[] results = Database.insert(insertResponse, false);
            for(Database.SaveResult result : results){
                if(result.isSuccess()){
                    SYS_debug.log('Records are inserted correctly!!');
                    sysLogResponse.add(result.getId());
                } else {
                    SYS_debug.log('Insertion error has occured.');
                    for(Database.Error err : result.getErrors()) {
                        SYS_debug.log('The following error has occurred.');                    
                        SYS_debug.log(err.getStatusCode() + ': ' + err.getMessage());
                        SYS_debug.log('Fields affected are: ' + err.getFields());
                    }
                }
            }
        }

    }

    class QBResponse{
        public cls_eventNotifications[] eventNotifications;
    }
    class cls_eventNotifications {
        public String realmId;	//4620816365172373180
        public cls_dataChangeEvent dataChangeEvent;
    }
    class cls_dataChangeEvent {
        public cls_entities[] entities;
    }
    class cls_entities {
        public String name;	//Item
        public String id;	//21
        public String operation;	//Update
        public String lastUpdated;	//2021-08-02T07:54:33.000Z
    }
}