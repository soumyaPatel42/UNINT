@RestResource(urlMapping = '/quickbooks/v1/*') //TODO - change mapping name quickbooks/
global class SYS_WebServiceQB {

    public static Boolean objectSettingCheck = false;
    public static Boolean externalIdCheck = false;
    
    @httpPost
    global static void doPostMethod(){
        String requestBody = RestContext.request.requestBody.toString();
        SYS_debug.log('body==' + requestBody);
        SYS_debug.log('url=='+ RestContext.request.requestURI);  
        String token = RestContext.request.params.get('token') != null ? RestContext.request.params.get('token') : '';
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
            RestContext.response.responseBody = SYS_ApiResponse.successResponse(integrationLog.Id);
        } catch ( Exception e ) {
            SYS_ApiResponse.error = e; 
            RestContext.response.statusCode = SYS_ApiResponse.statusCode;
            Blob body = SYS_ApiResponse.failureResponse();
            RestContext.response.responseBody = body;
            
            errorLog = SYS_integrationLogHandler.getLogsToInsert( body.toString() );
            errorLog.Type__c = 'INBOUND';
            errorLog.Status__c = 'ERROR';
        }
        if (errorLog != new SYS_IntegrationLog__c()) {
            insert errorLog;
        }
        
    }

    @httpGet
    global static void getRecord() {
        List<sObject> record = getSObject(RestContext.request.params);
        String responseBody;

        if(record == null) {
            if (!objectSettingCheck) {
                responseBody = SYS_Constants.incorrect_object_error;
            } else if (!externalIdCheck) {
                responseBody = SYS_Constants.record_doesnot_exist_error;
            } else {
                responseBody = SYS_Constants.some_error_occured;
            }
        }
        else {
            String recordId = (String)record[0].get('Id');
            Map<Id, String> resp = SYS_Transformer.getRequestJson(record);
    
            responseBody = resp.get(recordId);
        }
        RestContext.response.responseBody = Blob.valueOf(responseBody);
    }
    
    @HttpDelete
    global static void deleteRecord() {
        List<sObject> record = getSObject(RestContext.request.params);
        String responseBody;

        if(record == null) {
            if (!objectSettingCheck) {
                responseBody = SYS_Constants.incorrect_object_error;
            } else if (!externalIdCheck) {
                responseBody = SYS_Constants.record_doesnot_exist_error;
            } else {
                responseBody = SYS_Constants.some_error_occured;
            }
        } else {
            Database.DeleteResult[] results = Database.delete(record, false);
            for(Database.DeleteResult result : results) {
                if(result.isSuccess()) {
                    responseBody = SYS_Constants.record_deleted_msg;
                } else {
                    for(Database.Error err : result.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('sObject fields that affected this error: ' + err.getFields());
                        responseBody = err.getStatusCode() + ': ' + err.getMessage() + '\n' 
                                    +'sObject fields that affected this error: ' + err.getFields();
                        break;
                    }
                }
                break;
            }
        }
        
        RestContext.response.responseBody = Blob.valueOf(responseBody);
    }

    public static List<sObject> getSObject(Map<String, String> parameters) {

        String objectSetting = parameters.get('object');
        String objectExtId = parameters.get('id');

        if(objectSetting == null || objectExtId == null) {
            return null;
        }
        for(ObjectSetting__mdt obj : SYS_DataCache.objSettings) {
            if(obj.masterlabel.equalsIgnoreCase(objectSetting)) {
                String objectName = obj.ObjectApiName__c;
                SYS_Constants.OBJ_TYPE = obj.masterlabel;
                String query = 'SELECT Id FROM '+objectName+' WHERE '+SYS_DataCache.objExternalField.get(obj.masterlabel) +' = :objectExtId';
                List<sObject> record = Database.query(query);

                objectSettingCheck = true;
                if(record.size() == 0) {
                    return null;
                }
                externalIdCheck = true;
                return record;
            }
        }
        
        return null;
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