@RestResource(urlMapping = '/municorn/v1/*')
global class SYS_WebService {
    public static Boolean objectSettingCheck = false;
    public static Boolean externalIdCheck = false;
    
    @httpPost
    global static void doPostMethod() {
        
    }

    @httpPut
    global static void updateRecord() {
        List<sObject> record = getSObject(RestContext.request.params);
        String responseBody;
        String requestBody = RestContext.request.requestBody.toString();
        SYS_IntegrationLog__c errorLog = new SYS_IntegrationLog__c();

        if(record == null) {
            if (!objectSettingCheck) {
                responseBody = SYS_Constants.incorrect_object_error;
            } else if (!externalIdCheck) {
                responseBody = SYS_Constants.record_doesnot_exist_error;
            } else {
                responseBody = SYS_Constants.some_error_occured;
            }
        } else {
            SYS_IntegrationLog__c log = SYS_integrationLogHandler.getLogsToInsert(requestBody);
            log.Type__c = 'INBOUND';
            log.SYS_Operation_Type__c = 'RESPONSE';
            log.Status__c = 'NEW';

            try{
                insert log;
                String recordId = (String)record[0].get('Id');
                Map<Id, String> resp = SYS_Transformer.getRequestJson(record);

                RestContext.response.responseBody = Blob.valueOf(resp.get(recordId));
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
    }

    @httpGet
    global static void getRecord() {
        List<sObject> record = getSObject(RestContext.request.params);
        Blob responseBody = Blob.valueOf('');
        Integer statusCode; 

        if(record == null) {
            statusCode = 400;
        } else {
            try {
                String recordId = (String)record[0].get('Id');
                Map<Id, String> resp = SYS_Transformer.getRequestJson(record);
        
                responseBody = Blob.valueOf(resp.get(recordId));
                statusCode = 200;
            } catch(Exception e) {
                SYS_ApiResponse.error = e; 
                statusCode = SYS_ApiResponse.statusCode;
                responseBody = SYS_ApiResponse.failureResponse();
            }
        }
        

        RestContext.response.responseBody = responseBody;
        RestContext.response.statusCode = statusCode;
    }
    
    @HttpDelete
    global static void deleteRecord() {
        List<sObject> record = getSObject(RestContext.request.params);
        Blob responseBody = Blob.valueOf('');
        Integer statusCode; 

        try {
            delete record;
            responseBody = SYS_ApiResponse.successResponse((String)record[0].get('Id'));
            statusCode = SYS_ApiResponse.statusCode;
        } catch(Exception e) {
            SYS_ApiResponse.error = e; 
            statusCode = SYS_ApiResponse.statusCode;
            responseBody = SYS_ApiResponse.failureResponse();
        }

        RestContext.response.responseBody = responseBody;
        RestContext.response.statusCode = statusCode;
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


}
