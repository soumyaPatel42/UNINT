@RestResource(urlMapping='/inbound-request-gcp/*')

global with sharing class SYS_WebServiceIMS {
    public static boolean testVal = false;
    
    @httpPost
    global static void doPostMethod(){
        String requestBody = RestContext.request.requestBody.toString();

        system.debug('requestbody==>' + requestBody);
        
        SYS_IntegrationLog__c  newSysLog = new SYS_IntegrationLog__c();
        SYS_IntegrationLog__c errorLog = new SYS_IntegrationLog__c();

        newSysLog = SYS_integrationLogHandler.getLogsToInsert(requestBody);
        newSysLog.Type__c = 'INBOUND';
        newSysLog.Status__c = 'NEW';
        newSysLog.SYS_Operation_Type__c = 'RESPONSE';
        try{
            insert newSysLog;
            RestContext.response.responseBody = SYS_ApiResponse.successResponse(newSysLog.Id);
            system.debug('**** '+ RestContext.response.responseBody);
            if(Test.isRunningTest() && testVal)
                throw new DmlException();
            
        } catch(Exception e) {
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
/*
    //Standard msg from SF
    public class SalesforceError {
        public String errorCode;
        public String message;
        public String recordId;
        public SalesforceError(String errorCode, string message){
            this.errorCode = errorCode;
            this.message = message;
        }
    } */
}