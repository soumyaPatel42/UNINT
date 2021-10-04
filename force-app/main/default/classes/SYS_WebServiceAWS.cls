@RestResource(urlMapping='/aws-webhook/*') 
global class SYS_WebServiceAWS{  

    public static boolean isTrue;
    public static boolean isTest = false;
    
    @httpPost
    global static void doPostMethod(){ 
        
        String requestBody = RestContext.request.requestBody.toString();
        String requestUrl = RestContext.request.requestURI;
        System.debug('request endpoint=='+requestUrl);

        SYS_Constants.INT_TYPE = 'JIRA';
        // isTrue = SYS_integrationLogHandler.filterWebSericeToken(requestUrl,'/jira-webhook/');
        // if(Test.isRunningTest())
        //     isTrue = true;
        
        system.debug('requestbidy==>' + requestBody); 
        
        SYS_IntegrationLog__c  newSysInte = new SYS_IntegrationLog__c(); 
        SYS_IntegrationLog__c errorLog = new SYS_IntegrationLog__c();

        // Map<String, Object> flatKey = SYS_Transformer.makeJsonIntoKeyValuePairs(requestBody);
        // Boolean isCorrectProject = true;
        // if(flatKey.get(SYS_Constants.project_key) != null) {
        //     isCorrectProject = String.valueOf(flatKey.get(SYS_Constants.project_key)) == SYS_Constants.JIRA_PROJECT;
        // }
        
        try{  
            newSysInte = SYS_integrationLogHandler.getLogsToInsert(requestBody);
        
            NewSysInte.Type__c = 'INBOUND';
            // NewSysInte.SYS_IntegrationSettings__c = 'JIRA';
            NewSysInte.SYS_Operation_Type__c = 'RESPONSE';    
            NewSysInte.Status__c = 'NEW';
            insert newSysInte;
            RestContext.response.responseBody = SYS_ApiResponse.successResponse(newSysInte.Id);
             
            if(Test.isRunningTest() && isTest)
                throw new DmlException();
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