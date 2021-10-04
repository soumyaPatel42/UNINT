public class SYS_integrationLogHandler { 


    public static void transformJIRArequest(String response) {
        List<sObject> upsertCase = SYS_ApexHandler.getSingleSobjectsToUpsert_QB(response, 'issue');
        
        String objectApiName = SYS_DataCache.sObjectApiName;
        String externalField = SYS_integrationLogHandler.getExternalFieldName(objectApiName);  
        if(upsertCase.size() > 0) {
            Database.UpsertResult[] results = Database.upsert(upsertCase, Schema.getGlobalDescribe().get(objectApiName).getDescribe().fields.getMap().get(externalField), false);
            for(Database.UpsertResult result : results){
                if(result.isSuccess()){
                    System.debug('sObject update success'); 
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
    }  
    /*
    SYS_Constants.INT_TYPE = 'JIRA';
    System.debug('extid=='+SYS_integrationLogHandler.getExternalFieldName('Case'));
    */
    public static String getExternalFieldName(String objectApiName) {
        if(SYS_DataCache.getExtId.values().size() > 0) {
            return SYS_DataCache.getExtId.get(SYS_Constants.INT_TYPE).values().size() > 0 ? SYS_DataCache.getExtId.get(SYS_Constants.INT_TYPE).get(objectApiName) : '';
        }
        return ''; 
    }

    public static boolean filterWebSericeToken(String endpoint, String resourceUrl) {
        String token = endpoint.replace(resourceUrl, '');
        String tokenMeta = SYS_DataCache.uuidToken;
        System.debug('token is=='+tokenMeta+'--url--'+token);

        return (token == tokenMeta);
    }

    

    public static SYS_IntegrationLog__c getLogsToInsert(String requestBody) {
        SYS_IntegrationLog__c integrationLog = new SYS_IntegrationLog__c();
        List<String> data = getJSONChunckedValues(requestBody);
        integer i = 0;
        for(String json:data){
            integrationLog.put('data'+i+'__c',json);
            i++;
        }
        return integrationLog;
    }

    public static List<String> getJSONChunckedValues(String body){
        List<String> data = new List<String>{'','','','','','','','','',''};
        if (body.length() <= SYS_Constants.TEXT_AREA_MAX_SIZE){
			data[0] = body;
            System.debug('json is in single data field');
        } else {
            System.debug('json needs chunking');
            Integer di = 0;
            String jsonSubStrng;
            Integer endIndex = SYS_Constants.TEXT_AREA_MAX_SIZE;
            String outboundJSON = body;
            do {
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
            } while (outboundJSON.length() > 0);
        }
        return data;
    }

    //check if a string is SF Id

    // System.debug(SYS_integrationLogHandler.isValidSalesforceId(null, Case.class)); 
    public static Boolean isValidSalesforceId( String sfdcId, System.Type type ){
        try {
 
            if ( Pattern.compile( '[a-zA-Z0-9]{15}|[a-zA-Z0-9]{18}' ).matcher( sfdcId ).matches() ){
                
                Id id = sfdcId;
                sObject sObj = (sObject) type.newInstance();
                sObj.Id = id;
                return true;
            }
        } catch ( Exception e ){
            //TypeException
        }
        return false;
    }

    // SYS_integrationLogHandler.submit();

    public static void submitAttachment(ContentVersion contentRecord, String extId) {  
        
        // ContentVersion contentRecord = [SELECT VersionData, ContentDocument.title FROM ContentVersion WHERE ContentDocumentId = '0698G00000005wIQAQ' AND IsLatest = true];
        Blob file_body = contentRecord.VersionData;
        String file_name = contentRecord.ContentDocument.title;
        String boundary = '----------------------------741e90d31eff';
        String header = '--' + boundary + '\n' +
            'Content-Disposition: form-data; name="file"; filename="' + file_name + '";\n' +
            'Content-Type: application/octet-stream';
        String footer = '--' + boundary + '--';
        String headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header + '\r\n\r\n'));
        
        while(headerEncoded.endsWith('=')) {
            header += ' ';
            headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));
        }
        
        String bodyEncoded = EncodingUtil.base64Encode(file_body);
        Blob bodyBlob = null;
        String last4Bytes = bodyEncoded.substring(bodyEncoded.length()-4,bodyEncoded.length());
        if (last4Bytes.endsWith('==')) {
            last4Bytes = last4Bytes.substring(0, 2) + '0K';
            bodyEncoded = bodyEncoded.substring(0, bodyEncoded.length() - 4) + last4Bytes;   
            String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
            bodyBlob = EncodingUtil.base64Decode(headerEncoded + bodyEncoded + footerEncoded);
        } else if (last4Bytes.endsWith('=')) {
            last4Bytes = last4Bytes.substring(0, 3) + 'N';
            bodyEncoded = bodyEncoded.substring(0, bodyEncoded.length()-4) + last4Bytes;
            footer = '\n' + footer;
            String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
            bodyBlob = EncodingUtil.base64Decode(headerEncoded + bodyEncoded + footerEncoded);              
        } else {
            footer = '\r\n' + footer;
            String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
            bodyBlob = EncodingUtil.base64Decode(headerEncoded + bodyEncoded + footerEncoded);  
        }
        
        String issue = extId; 
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Jira/rest/api/3/issue/' + issue + '/attachments');
        req.setHeader('Content-Type', 'multipart/form-data; boundary=' + boundary);
        req.setHeader('X-Atlassian-Token', 'nocheck');
        req.setMethod('POST');
        req.setBodyAsBlob(bodyBlob);
        req.setTimeout(120000);
        system.debug('endPoint=='+req.getEndPoint());
        Http h = new Http();
        HTTPResponse resp = h.send(req); 
        
        System.debug('#### resp status: '+resp.getStatus());
        System.debug('#### resp code: '+resp.getStatusCode());
        System.debug('#### resp: '+resp.getBody());

        if(resp.getStatusCode() == 200 || resp.getStatusCode() == 201) {
            contentRecord.JIRA_Upload_Status__c = 'Uploaded to JIRA';
        } else {
            contentRecord.JIRA_Upload_Status__c = 'Failed to Upload';
        }
        // update contentRecord;
    }

    public static Map<String,Schema.RecordTypeInfo> recordTypeInfoMap = new Map<String,Schema.RecordTypeInfo>();  
    public static Id getObjectRecordTypeId(String sObjectName, String recordTypeName) {  
        sObject obj;  
        Schema.SObjectType sObjectType = Schema.getGlobalDescribe().get(sObjectName);  
        if(sObjectType != null) {  
        obj = sObjectType.newsObject();  
        Schema.DescribeSObjectResult sObjDesc = obj.getSObjectType().getDescribe();  
        if(sObjDesc != null) {  
            recordTypeInfoMap = sObjDesc.getRecordTypeInfosByName();  
        }  
        if(!recordTypeInfoMap.containsKey(recordTypeName)) {  
            throw new RecordTypeException('Record type "'+ recordTypeName +'" does not exist.');  
        } else {  
            return recordTypeInfoMap.get(recordTypeName).getRecordTypeId();  
        }  
        }  
        return null;  
    }  
    public class RecordTypeException extends Exception{}
}