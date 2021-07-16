public class SYS_IntegrationLogOutboundQueueable implements Queueable, Database.AllowsCallouts{ 
    public static FINAL Integer TEXT_AREA_MAX_SIZE = 131072;
    //public static FINAL Integer TEXT_AREA_MAX_SIZE = 2; 
    public static FINAL Integer MAX_DATA_FIELDS = 10;
    private static string ENDPOINT_SUBSTRING = 'callout:QuickBooks/v3/company/4620816365172373180/';
    
    
    //TODO - remove endpoint val and commented
    private List<Id> sysLogIds = new List<Id>();
    //TODO - generate endpoint dynamically
    
    public SYS_IntegrationLogOutboundQueueable(List<Id> idList){
        this.sysLogIds = idList;
    }
    public void execute(QueueableContext context){
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
                                              Type__c,WhatId__c,Parent__c,Order__c
                                              FROM SYS_IntegrationLog__c WHERE Id in:sysLogIds];
        //TODO - the below code will cosider parent__c look up as empty and order__c as empty. 
        List<IntegrationSetting__mdt> integrationSetting = [SELECT Id, DeveloperName, Label, UpdateMethod__c, 
                                     AuthenticationType__c, BaseAPIEndPoint__c, 
                                     QualifiedApiName FROM IntegrationSetting__mdt 
                                     WHERE developername = 'Quickbooks'];
        //TODO - field for QB 
        //TODO - class for setting http req.
        //TODO - HTTPBuilder, SYS_IntegrationLogHandler global class(override for integration and prod specific)
        if(integrationSetting.size() != 0){
            List<HttpHeaders__mdt> httpHeader = [SELECT Id, MasterLabel, Label, IntegrationType__c, Value__c 
                                                 FROM HttpHeaders__mdt 
                                                 WHERE IntegrationType__c =: integrationSetting[0].id];
            req.setMethod(integrationSetting[0].UpdateMethod__c);
            for(HttpHeaders__mdt head:httpHeader){
                System.debug('header is = '+head);
                req.setHeader(String.valueOf(head.MasterLabel), String.valueOf(head.Value__c));
                
            } 
            
            for(SYS_IntegrationLog__c log:sysLog){
                System.debug('inside for loop'+Id.valueof(log.WhatId__c).getsobjecttype());
                String body = log.data0__c+log.data1__c+log.data2__c+log.data3__c+
                    log.data4__c+log.data5__c+log.data6__c+log.data7__c+
                    log.data8__c+log.data9__c;
                Schema.SObjectType objectApiName = Id.valueof(log.WhatId__c).getsobjecttype();
                System.debug('sObject api name ='+objectApiName);
                req.setEndpoint(getResourceUrlFromObjectApi(String.valueOf(objectApiName)));
                req.setBody(body);
                
                //##Hit the webservice
                //TODO - Use limit api to avoid gov limit
                //TODO - add a method for response log
                HttpResponse resp = http.send(req);
                if(resp.getStatusCode() != 200){
                    System.debug('#### resp status: '+resp.getStatus());
                    System.debug('#### resp code: '+resp.getStatusCode());
                    System.debug('#### resp: '+resp.getBody());
                    List<String> data = getJSONChunckedValues(resp.getBody());
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
                    logResp.Type__c = 'RESPONSE';
                    insertResponse.add(logResp);
                }
                else{
                    List<String> data = getJSONChunckedValues(resp.getBody());
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
                    logResp.Type__c = 'RESPONSE';
                    insertResponse.add(logResp);
                }
        	}
            System.debug('##insert list size= '+insertResponse.size());
            if(insertResponse.size() > 0){
                system.debug('##insert all response logs');
                insert insertResponse;
            }   
            
        }else{
            
        }
    }
    //TODO - use SYS_Datacache
    public static String getResourceUrlFromObjectApi(String objApi){
        String resourceUrl = ENDPOINT_SUBSTRING;
        if(objApi != null || objApi != ''){
            List<ObjectSetting__mdt> objSetting = [SELECT Id, ResourcePath__c, DeveloperName 
                                                   FROM ObjectSetting__mdt WHERE DeveloperName = : objApi];
            System.debug('resource url='+objSetting[0].ResourcePath__c);
            if(objSetting.size() != 0){
                resourceUrl += objSetting[0].ResourcePath__c;
            }
        }
        return resourceUrl;
    }
    public static List<String> getJSONChunckedValues(String body){
        List<String> data = new List<String>{'','','','','','','','','',''};
        if(body.length() <= TEXT_AREA_MAX_SIZE){
			data[0] = body;
            System.debug('json is in single data field');
        }else{
            System.debug('json needs chunking');
            Integer di = 0;
            String jsonSubStrng;
            Integer endIndex = TEXT_AREA_MAX_SIZE;
            String outboundJSON = body;
            do{
                jsonSubStrng = outboundJSON.substring(0,endIndex);
                outboundJSON = outboundJSON.substring(endIndex);
                System.debug('substr= '+outboundJSON+' index='+endIndex+' '+jsonSubStrng);
                endIndex = (outboundJSON.length() < TEXT_AREA_MAX_SIZE) ? outboundJSON.length() : TEXT_AREA_MAX_SIZE;
                data[di] = jsonSubStrng;
                di++;
                if(di == MAX_DATA_FIELDS-1 && body.length() > TEXT_AREA_MAX_SIZE){
                    System.debug('JSON too large. Truncated');
                    break;
                }
            }while(outboundJSON.length() > 0);
        }
        return data;
    }
}