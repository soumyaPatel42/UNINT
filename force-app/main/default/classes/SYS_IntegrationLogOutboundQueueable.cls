public class SYS_IntegrationLogOutboundQueueable implements Queueable, Database.AllowsCallouts{ 
   
    private List<Id> sysLogIds = new List<Id>();
    
    public SYS_IntegrationLogOutboundQueueable(List<Id> idList){
        this.sysLogIds = idList;
    }
    public void execute(QueueableContext context){

        List<Id> sysLogResponse = new List<Id>(); //user to trigger the async class to update SyncToken from response.
        List<Id> rerunResponse = new List<Id>();
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
                                              Type__c,WhatId__c,Parent__c,Order__c, Name
                                              FROM SYS_IntegrationLog__c WHERE Id in:sysLogIds];
        //TODO - the below code will cosider parent__c look up as empty and order__c as empty. 
        List<IntegrationSetting__mdt> integrationSetting = SYS_DataCache.integrationSetting;
        String baseEndpoint = integrationSetting[0].BaseAPIEndPoint__c;
        //TODO - field for QB 
        //TODO - class for setting http req.
        //TODO - HTTPBuilder, SYS_IntegrationLogHandler global class(override for integration and prod specific)
        System.debug('inside outbound er');
        req = SYS_HttpBuilder.getJWTrequest();
        if(integrationSetting.size() != 0){
            List<HttpHeaders__mdt> httpHeader = SYS_DataCache.headerSetting;
            req.setMethod(integrationSetting[0].UpdateMethod__c);
            for(HttpHeaders__mdt head:httpHeader){
                System.debug('header is = '+head);
                req.setHeader(String.valueOf(head.MasterLabel), String.valueOf(head.Value__c));
                
            }
            
            for(SYS_IntegrationLog__c log : sysLog) { 
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
                
                body = SYS_integrationLogHandler.addMessageControlIdSegment(body, log.Name);
                Schema.SObjectType objectApiName = Id.valueof(log.WhatId__c).getsobjecttype();
                System.debug('sObject api name ='+objectApiName); 
                // req.setEndpoint(SYS_HttpBuilder.getResourceUrlFromObjectApi( String.valueOf(objectApiName)));
                req.setEndpoint(SYS_DataCache.JWT_TARGET_AUD);
                req.setBody(body);
                
                //##Hit the webservice
                //TODO - Use limit api to avoid gov limit
                //TODO - add a method for response log
                try {
                    HttpResponse resp = http.send(req);
                    if(resp.getStatusCode() != 200){
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
                        logResp.SYS_Operation_Type__c = 'RESPONSE'; 
                        insertResponse.add(logResp);
                    }
                    else{
                        System.debug('#### else resp status: '+resp.getStatus());
                        System.debug('#### else resp code: '+resp.getStatusCode());
                        System.debug('#### resp: '+resp.getBody());
                        List<String> data = SYS_integrationLogHandler.getJSONChunckedValues(resp.getBody());
                        SYS_IntegrationLog__c logResp = new SYS_IntegrationLog__c();
                        integer i = 0;
                        for(String json:data){
                            logResp.put('data'+i+'__c',json);
                            i++;
                        }
                        logResp.Status__c = 'DONE';
                        if(SYS_Constants.INT_TYPE == 'Middleware_hl7')
                            logResp.Status__c = 'DONE';
                        logresp.SYS_Http_Status__c = Integer.valueOf(resp.getStatusCode());
                        logResp.SYS_RequestId__c = log.Id;
                        logResp.WhatId__c = log.WhatId__c;
                        logResp.Type__c = 'INBOUND';
                        logResp.SYS_Operation_Type__c = 'RESPONSE';
                        insertResponse.add(logResp);
                    }
                } catch(CalloutException e) {
                    System.debug('callout exception');
                    rerunResponse.add(log.Id);
                }
                
        	}
            System.debug('##insert list size= '+insertResponse.size());
            if(insertResponse.size() > 0){
                system.debug('##insert all response logs');
                Database.SaveResult[] results = Database.insert(insertResponse, false);
                for(Database.SaveResult result : results){
                    if(result.isSuccess()){
                        sysLogResponse.add(result.getId());
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
            if(rerunResponse.size() > 0) {
                System.enqueueJob(new SYS_IntegrationLogOutboundQueueable(rerunResponse));
            } 
            
        } else {
            
        }
    }
   
    public static List<String> getJSONChunckedValues(String body){
        List<String> data = new List<String>{'','','','','','','','','',''};
        if(body.length() <= SYS_Constants.TEXT_AREA_MAX_SIZE){
			data[0] = body;
            System.debug('json is in single data field');
        }else{
            System.debug('json needs chunking');
            Integer di = 0;
            String jsonSubStrng;
            Integer endIndex = SYS_Constants.TEXT_AREA_MAX_SIZE;
            String outboundJSON = body;
            do{
                jsonSubStrng = outboundJSON.substring(0,endIndex);
                outboundJSON = outboundJSON.substring(endIndex);
                System.debug('substr= '+outboundJSON+' index='+endIndex+' '+jsonSubStrng);
                endIndex = (outboundJSON.length() < SYS_Constants.TEXT_AREA_MAX_SIZE) ? outboundJSON.length() : SYS_Constants.TEXT_AREA_MAX_SIZE;
                data[di] = jsonSubStrng;
                di++;
                if(di == SYS_Constants.MAX_DATA_FIELDS - 1 && body.length() > SYS_Constants.TEXT_AREA_MAX_SIZE){
                    System.debug('JSON too large. Truncated');
                    break;
                }
            }while(outboundJSON.length() > 0);
        }
        return data;
    }
}