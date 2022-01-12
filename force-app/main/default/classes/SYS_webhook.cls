global class SYS_webhook {
    global static Blob processWebhookResponse(String token, String requestBody) {
        // requestBody = RestContext.request.requestBody.toString();
        Blob responseBody;
        SYS_debug.log('body==' + requestBody);
        SYS_debug.log('url=='+ RestContext.request.requestURI);  
        // String token = RestContext.request.params.get('token') != null ? RestContext.request.params.get('token') : '';
        SYS_debug.log('token=='+RestContext.request.params);
        
        SYS_Constants.INT_TYPE = 'Quickbooks';

        
        SYS_IntegrationLog__c  integrationLog = new SYS_IntegrationLog__c();
        List<SYS_IntegrationLog__c> logList = new List<SYS_IntegrationLog__c>();
        SYS_IntegrationLog__c errorLog = new SYS_IntegrationLog__c();

        QBResponse respObj = (QBResponse)System.JSON.deserialize(requestBody, QBResponse.class);
        cls_eventNotifications evtNotify = respObj.eventNotifications != null ? respObj.eventNotifications[0] : new cls_eventNotifications();
        cls_dataChangeEvent dataChg = evtNotify.dataChangeEvent != null ? evtNotify.dataChangeEvent : null;
        cls_entities[] entityList = dataChg != null ? (dataChg.entities != null ? dataChg.entities : null) : null;
        
        if(entityList != null && SYS_integrationLogHandler.filterWebSericeToken(token)) { 
            for(cls_entities ent : entityList) {
                String evtString = JSON.serialize(ent);
                integrationLog = SYS_integrationLogHandler.getLogsToInsert(evtString); // TODO - Integartionlog handler SYS_integrationLogHandler
                integrationLog.Type__c = 'INBOUND';
                integrationLog.SYS_Operation_Type__c = 'CDC';
                integrationLog.Status__c = 'DONE';
                integrationLog.SYS_IntegrationSettings__c = 'Quickbooks';
                logList.add(integrationLog);
            }
        }
        try{
            insert logList;
            responseBody = SYS_ApiResponse.successResponse(integrationLog.Id);
        } catch ( Exception e ) {
            SYS_ApiResponse.error = e; 
            RestContext.response.statusCode = SYS_ApiResponse.statusCode;
            Blob body = SYS_ApiResponse.failureResponse();
            responseBody = body;
            
            errorLog = SYS_integrationLogHandler.getLogsToInsert( body.toString() );
            errorLog.Type__c = 'INBOUND';
            errorLog.Status__c = 'ERROR';
        }
        if (errorLog != new SYS_IntegrationLog__c()) {
            insert errorLog;
        }
        return responseBody; 
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