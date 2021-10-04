public class SYS_IntegrationLogOutboundQueueable implements Queueable, Database.AllowsCallouts{ 
   
    private List<Id> sysLogIds = new List<Id>();
    
    public SYS_IntegrationLogOutboundQueueable(List<Id> idList){ 
        this.sysLogIds = idList;
    }
    public void execute(QueueableContext context){

        List<Id> sysLogResponse = new List<Id>(); //user to trigger the async class to update SyncToken from response.

        Http http = new Http();
        HttpRequest req = new HttpRequest();
        List<SYS_IntegrationLog__c> insertResponse = new List<SYS_IntegrationLog__c>();
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
                                              Type__c,WhatId__c,Parent__c,Order__c, SYS_IntegrationSettings__c, SYS_Operation_Type__c
                                              FROM SYS_IntegrationLog__c WHERE Id in:sysLogIds];
        //TODO - the below code will cosider parent__c look up as empty and order__c as empty. 
        SYS_Constants.INT_TYPE = sysLog[0].SYS_IntegrationSettings__c; 
        List<IntegrationSetting__mdt> integrationSetting = SYS_DataCache.integrationSetting;
        List<sObject> allRecords = new List<sObject>();
        // String baseEndpoint = integrationSetting[0].BaseAPIEndPoint__c;
        List<Id> caseIds = new List<Id>(); 
        //TODO - field for QB 
        //TODO - class for setting http req.
        //TODO - HTTPBuilder, SYS_IntegrationLogHandler global class(override for integration and prod specific)
        String extId; 
        if(integrationSetting.size() != 0){
            List<HttpHeaders__mdt> httpHeader = SYS_DataCache.headerSetting;
            
            for(HttpHeaders__mdt head:httpHeader){
                System.debug('header is = '+head.Key__c+'=='+head.Value__c);
                req.setHeader(String.valueOf(head.Key__c), String.valueOf(head.Value__c));
                
            } 
            
            for(SYS_IntegrationLog__c log:sysLog) {
                if(log.WhatId__c != null && log.SYS_IntegrationSettings__c == 'JIRA') {
                    if( SYS_integrationLogHandler.isValidSalesforceId(String.valueOf(log.WhatId__c), Case.class) ) {
                        caseIds.add(log.WhatId__c);
                    }
                }
                System.debug('inside for loop'+Id.valueof(log.WhatId__c).getsobjecttype());
                String body = log.data0__c != null ? log.data0__c : '' +
                                log.data1__c != null ? log.data1__c : '' +
                                log.data2__c != null ? log.data2__c : '' +
                                log.data3__c != null ? log.data3__c : '' +
                                log.data4__c != null ? log.data4__c : '' +
                                log.data5__c != null ? log.data5__c : '' +
                                log.data6__c != null ? log.data6__c : '' +
                                log.data7__c != null ? log.data7__c : '' +
                                log.data8__c != null ? log.data8__c : '' +
                                log.data9__c != null ? log.data9__c : '' ; 
                
                //TODO - refactor method 
                String setMethod = integrationSetting[0].UpdateMethod__c;
                if(log.SYS_Operation_Type__c == 'INSERT') {
                    req.setMethod('POST');
                    System.debug('POST method'); 
                } else if(log.SYS_Operation_Type__c == 'UPDATE') {
                    req.setMethod(integrationSetting[0].UpdateMethod__c);
                }
                System.debug('method=='+integrationSetting[0].UpdateMethod__c); 

                Schema.SObjectType objectApiName = Id.valueof(log.WhatId__c).getsobjecttype(); 
                System.debug('sObject api name ='+objectApiName); 
                req.setEndpoint(SYS_HttpBuilder.getResourceUrlFromObjectApi( String.valueOf(objectApiName)));
                System.debug('body=='+body);
                req.setBody(body);
                
                //##Hit the webservice
                //TODO - Use limit api to avoid gov limit
                //TODO - add a method for response log
                HttpResponse resp = http.send(req);
                if(resp.getStatusCode() != 200 && resp.getStatusCode() != 201){
                    System.debug('#### resp status: '+resp.getStatus());
                    System.debug('#### resp code: '+resp.getStatusCode());
                    System.debug('#### resp: '+resp.getBody());
                    List<String> data = SYS_integrationLogHandler.getJSONChunckedValues(resp.getBody());
                    SYS_IntegrationLog__c logResp = new SYS_IntegrationLog__c();
                    System.debug('data value = '+data);

                    integer i = 0;
                    for(String json:data){
                        logResp.put('data' + i + '__c', json);
                        //system.debug('data loop ##'+logResp);
                        i++;
                    }
                    logResp.Status__c = 'ERROR';
                    logresp.SYS_Http_Status__c = integer.valueOf(resp.getStatusCode());
                    logResp.SYS_RequestId__c = log.Id;
                    logResp.WhatId__c = log.WhatId__c;
                    logResp.Type__c = 'INBOUND';
                    logResp.SYS_IntegrationSettings__c = SYS_Constants.INT_TYPE;
                    logResp.SYS_Operation_Type__c = 'RESPONSE';
                    insertResponse.add(logResp);
                }
                else{ 
                    System.debug('respBody=='+resp.getBody());
                    String ObjectName = ((Id)log.WhatId__c).getsobjecttype() + '';
                    sObject record = Schema.getGlobalDescribe().get(ObjectName).newSObject(((Id)log.WhatId__c)); 
                    
                    String extFieldApiName = SYS_integrationLogHandler.getExternalFieldName(ObjectName);
                    if(SYS_Constants.INT_TYPE == 'JIRA') {
                        Map<String, Object> flatKeyMap = SYS_Transformer.makeJsonIntoKeyValuePairs(resp.getBody());
                        
                        String constructKey = 'id';
                        String issueKey = 'key';
                        // String constructToken = SYS_Constants.metaDataMap.get(ObjectName) + '.' + 'SyncToken';
                        String externalId = String.valueof(flatKeyMap.get(constructKey));
                        String keyVal = String.valueOf(flatKeyMap.get(issueKey));
                        extId = externalId;
                        // String syncToken = String.valueof(flatKeyMap.get(constructToken));
                        
                        record.put(extFieldApiName , externalId);
                        record.put('Jira_Key__c', keyVal);
                        // record.put('QB_SyncToken__c', syncToken);
                    } else if(SYS_Constants.INT_TYPE == 'Airtable') {
                        airtableResponse respObj = (airtableResponse)JSON.deserialize(resp.getBody(), airtableResponse.class);
                        if(respObj.records.size() > 0) {
                            System.debug('test=='+respObj.records);
                            cls_records recordRes = (cls_records)respObj.records[0];
                            record.put(extFieldApiName , recordRes.id);
                            System.debug('key2--'+recordRes.id);
                        }
                    }
                    allRecords.add(record); 
                    
                    List<String> data = SYS_integrationLogHandler.getJSONChunckedValues(resp.getBody());
                    SYS_IntegrationLog__c logResp = new SYS_IntegrationLog__c();
                    integer i = 0;
                    for(String json:data){
                        logResp.put('data'+i+'__c',json);
                        i++;
                    }
                    logResp.Status__c = 'DONE';
                    
                    logresp.SYS_Http_Status__c = Integer.valueOf(resp.getStatusCode());
                    logResp.SYS_RequestId__c = log.Id;
                    logResp.WhatId__c = log.WhatId__c;
                    logResp.Type__c = 'INBOUND';
                    logResp.SYS_Operation_Type__c = 'RESPONSE';
                    logResp.SYS_IntegrationSettings__c = SYS_Constants.INT_TYPE;
                    insertResponse.add(logResp);
                    System.debug('responseLog=='+logResp);
                }
        	}
            if(allRecords.size() > 0) {
                try {
                    System.debug('record updated=='+allRecords);
                    Database.upsert(allRecords);
                } catch (Exception e) { 
                    System.debug('Error occured'+e.getMessage());
                }
            }
            
            System.debug('##insert list size= '+insertResponse.size());
            if(insertResponse.size() > 0){
                system.debug('##insert all response logs');
                Database.SaveResult[] results = Database.insert(insertResponse, false);
                for(Database.SaveResult result : results){
                    if(result.isSuccess()){
                        sysLogResponse.add(result.getId()); 
                        System.debug('log insert successful'+result.getId());
                    } else {
                        System.debug('Insertion error has occured.');
                        for(Database.Error err : result.getErrors()) {
                            System.debug('The following error has occurred.');                    
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('Fields affected are: ' + err.getFields());
                        }
                    }
                }
            }
            if(caseIds.size() > 0) {
                //Get all content document from the sent case
                    System.debug('inside attachments');
                    Map<String, String> mapLinkToKey = new Map<String, String>();
                    Map<String, String> mapCaseToKey = new Map<String, String>();
                    Map<String, String> mapVerToKey = new Map<String, String>();
                    for(Case caseItr : [SELECT Id, SYS_Key1__c FROM Case WHERE Id in :caseIds]) {
                        mapCaseToKey.put(caseItr.Id, caseItr.SYS_Key1__c);
                    }
                    List<Id> contentDocId = new List<Id>();
                    String queryDoc = 'SELECT ContentDocumentId, LinkedEntityId  FROM ContentDocumentLink where LinkedEntityId in :caseIds and LinkedEntity.Type =\'Case\' '; 
                    List<ContentDocumentLink> linkList = Database.query(queryDoc);
                    for(ContentDocumentLink link : linkList) {
                        contentDocId.add(link.ContentDocumentId);
                        mapLinkToKey.put(link.ContentDocumentId, mapCaseToKey.get(link.LinkedEntityId));
                    }
                    String queryVersion = 'SELECT Id, ContentDocumentId FROM ContentVersion WHERE ContentDocumentId in :contentDocId AND IsLatest = true';
                    List<ContentVersion> contentDocList = Database.query(queryVersion);
                    System.debug('atatchments found=='+contentDocList.size()); 
                    List<Id> contentVerId = new List<Id>();
                    for(ContentVersion ver : contentDocList) {
                        contentVerId.add(ver.Id);
                        System.debug('verId=='+ver.Id);
                        mapVerToKey.put(ver.Id, mapLinkToKey.get(ver.ContentDocumentId));
                    } 
                //Sending version Ids 
                if(!Test.isRunningTest())
                    System.enqueueJob(new SYS_processAttachments(contentVerId, mapVerToKey));  
            } 
            
        } else {
            
        }
    }

    public class airtableResponse {
        public cls_records[] records;
    }
    class cls_records {
        public String id;	//rechsnZcjMZ2bREya 
        public cls_fields fields;
        public String createdTime;	//2021-09-23T21:18:40.000Z
    }
    class cls_fields {
        public String Name;	//Airtable case
        public String Status;	//In progress
    }
    
   
}