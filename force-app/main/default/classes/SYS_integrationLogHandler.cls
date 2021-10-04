public class SYS_integrationLogHandler {


    public static Map<String, String> getRootKey(String body) {
        Object obj = JSON.deserializeUntyped(body);
        Map<String, String> mapRootBody = new Map<String, String>();
        String rootKey = '';
        if(obj instanceof Map<String, Object>) {
            System.debug('inside if!'+ ((Map<String, Object>)obj).containsKey('ADT_A04'));
            if(((Map<String, Object>)obj).containsKey('ADT_A01')) {
                rootkey = 'ADT_A01';
            } else if(((Map<String, Object>)obj).containsKey('ADT_A04')) {
                rootKey = 'ADT_A04';
            } else if(((Map<String, Object>)obj).containsKey('ADT_A08')) {
                rootKey = 'ADT_A08';
            } else if(((Map<String, Object>)obj).containsKey('SIU_S12')) {
                rootKey = 'SIU_S12';
            } else if(((Map<String, Object>)obj).containsKey('SIU_S13')) {
                rootKey = 'SIU_S13';
            } else if(((Map<String, Object>)obj).containsKey('SIU_S14')) {
                rootKey = 'SIU_S14';
            } else if(((Map<String, Object>)obj).containsKey('SIU_S15')) {
                rootKey = 'SIU_S15';
            } 
            String bodyElement = JSON.Serialize(((Map<String, Object>)obj).values()[0]);
            mapRootBody.put('root',rootKey);
            mapRootBody.put('body',bodyElement);
        }
        System.debug('root key=='+rootKey);
        return mapRootBody;
    }

    public static List<Account> addAccountName(List<Account> accList) {
        for(Account acc : accList) {
            String firstName = acc.get('Primary_Contact_First_Name__c') != null ? acc.get('Primary_Contact_First_Name__c') + '' : '';
            String lastName = acc.get('Primary_Contact_Last_Name__c') != null ? acc.get('Primary_Contact_Last_Name__c') + '' : '';

            String name = ( !String.isBlank(firstName + lastName) ? (firstName +' '+ lastName+' ') : 'UNKNOWN' ) /*+ (acc.get('CS_External_ID__c') != null ? acc.get('CS_External_ID__c') + '' : '')*/;
            acc.put('Name', name);
            System.debug('Name added=='+name);
        }
        return accList;
    }

    //System.debug('reurrns=='+SYS_integrationLogHandler.checkSFexternalId('SF@&@HWYERSBTVERT234'));
    public static boolean checkSFexternalId(String sfdcId) {
        if(sfdcId != null) {
            if(sfdcId.startsWith('SF') && (sfdcId.length() == 20 || sfdcId.length() == 17)) {
                return true;
            } else {
                return false;
            }
        } 
        return false;
    }

    public static List<MemberPlan> addInsuranceName(List<MemberPlan> insuranceList) {
        for(MemberPlan plan : insuranceList) {
            // String firstName = plan.get('Insured_First_Name__c') != null ? plan.get('Insured_First_Name__c') + '' : '';
            // String lastName = plan.get('Insured_Last_Name__c') != null ? plan.get('Insured_Last_Name__c') + '' : '';
            String company = plan.get('Insurance_Company_Organization_Name__c') != null ? plan.get('Insurance_Company_Organization_Name__c') + '' : 'Insurance Company Name';

            String name = (!String.isBlank(company) ? ( company ) : '');
            plan.put('Name', name);
            System.debug('Name added=='+name);
        }
        return insuranceList;
    }

    


    // public static void checkDatabaseResults(Database.UpsertResult[] results) {
    //     for(Database.UpsertResult result : results){
    //         if(result.isSuccess()){
    //             System.debug('sObject update success');
    //         } else {
    //             System.debug('Insertion error has occured.');
    //             for(Database.Error err : result.getErrors()) {
    //                 System.debug('The following error has occurred.');                    
    //                 System.debug(err.getStatusCode() + ': ' + err.getMessage());
    //                 System.debug('Fields affected are: ' + err.getFields());
    //             }
    //         }
    //     }
    // }
    

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

    public static string getHashOfRecord(String toHash) {
        String targetString = toHash;
        System.debug('str is==' + toHash);
        Blob targetBlob = Blob.valueOf(targetString);
        // Generate SHA1 digest
        Blob hashSHA1 = Crypto.generateDigest('SHA3-512', targetBlob);
        // For Rackspace Compatiblity encode the binary into BASE 64
        // this will result in 28 chars long string 
        String hashBase64SHA1 = EncodingUtil.base64encode (hashSHA1);
        System.debug(hashBase64SHA1);

        return hashBase64SHA1;
    }

    public static String convertToTimestampFormat(String input) {
        String timestamp = '';
        if(input != null) {
            String str = String.valueOf(input).replace('-','').replace('T','').replace(':','').replace(' ','');
            timestamp = str.length() >= 14 ? str.substring(0,14) : str.substring(0,8);
        }
        System.debug('stamp=='+timestamp);
        return timestamp;
    }

    public static String addMessageControlIdSegment(String body, String name) {
        String modifyBody = body;

        if(modifyBody != null) {
            Object data = JSON.deserializeUntyped(modifyBody);
            if(data instanceof Map<String, Object>) {
                String rootKey = ((Map<String, Object>)data).get('ADT_A04') != null ? 'ADT_A04' : 'ADT_A08';
                Object data1 = ((Map<String, Object>)data).get('ADT_A04') != null ? ((Map<String, Object>)data).get('ADT_A04') : ((Map<String, Object>)data).get('ADT_A08');
                if(data1 instanceof Map<String, Object>) {
                    Object msh = ((Map<String, Object>)data1).get('MSH') != null ? ((Map<String, Object>)data1).get('MSH') : '';
                    if(msh != '') {
                        ((Map<String, Object>)msh).put('MSH.10', name);
                        ((Map<String, Object>)data1).put('MSH', msh);
                        Map<String, Object> newBody = new Map<String, Object>();
                        newBody.put(rootKey,data1);
                        System.debug('New Str=='+JSON.serialize(newBody));
                        modifyBody = JSON.serialize(newBody);
                    }
                }
            }
        }
        return modifyBody;
    }

    //check if a string is SF Id
    // public static Boolean isValidSalesforceId( String sfdcId, System.Type type ){
    //     try {
 
    //         if ( Pattern.compile( '[a-zA-Z0-9]{15}|[a-zA-Z0-9]{18}' ).matcher( sfdcId ).matches() ){
                
    //             Id id = sfdcId;
    //             sObject sObj = (sObject) type.newInstance();
    //             sObj.Id = id;
    //             return true;
    //         }
    //     } catch ( Exception e ){
    //         //TypeException
    //     }
    //     return false;
    // }

    // Datetime.valueof(SYS_integrationLogHandler.convertTimestampToDatetime('202108121300') );
    public static String convertTimestampToDatetime(String input) {
        String timestamp;
        List<integer> sequence = new List<integer>{4, 6, 8, 10, 12, 14};
        if(input != null) {
        //System.debug('length=='+input.length());
            if(input.length() == 4) {
                timestamp = String.valueOf(DateTime.newInstanceGmt(integer.valueOf(input), 1, 1, 0, 0, 0));
            } else if(input.length() == 8) {
                integer yyyy = integer.valueOf(input.substring(0,4));
                integer mm = integer.valueOf(input.substring(4,6));
                integer dd = integer.valueOf(input.substring(6,8));
                timestamp = String.valueOf(DateTime.newInstanceGmt(yyyy, mm, dd, 0, 0, 0));
            } else if(input.length() == 14) {
                integer yyyy = integer.valueOf(input.substring(0,4));
                integer mm = integer.valueOf(input.substring(4,6));
                integer dd = integer.valueOf(input.substring(6,8));
                integer hh = integer.valueOf(input.substring(8,10));
                integer mmm = integer.valueOf(input.substring(10,12));
                integer ss = integer.valueOf(input.substring(12,14));
                timestamp = String.valueOf(DateTime.newInstanceGmt(yyyy, mm, dd, hh, mmm, ss));
            } else if(input.length() == 12) {
                integer yyyy = integer.valueOf(input.substring(0,4));
                integer mm = integer.valueOf(input.substring(4,6));
                integer dd = integer.valueOf(input.substring(6,8));
                integer hh = integer.valueOf(input.substring(8,10));
                integer mmm = integer.valueOf(input.substring(10,12));
                timestamp = String.valueOf(DateTime.newInstanceGmt(yyyy, mm, dd, hh, mmm, 0));
            } else if(input.length() == 0 ) {
                timestamp = String.valueOf(DateTime.newInstanceGmt(1900, 1, 1, 0, 0, 0));
            }
        } else {
            timestamp = String.valueOf(DateTime.newInstanceGmt(1900, 1, 1, 0, 0, 0));
        }
        System.debug('timestamp=='+timestamp);
        return timestamp;
    }

    public static String convertTimestampToDate(String input) {
        String timestamp= '';
        List<integer> sequence = new List<integer>{4, 6, 8};
        System.debug('timeStamp=='+input); 
        if(input != null) {
        //System.debug('length=='+input.length());
            if(input.length() == 4) {
                timestamp = String.valueOf(Date.newInstance(integer.valueOf(input), 1, 1));
            } else if(input.length() == 6) {
                integer yyyy = integer.valueOf(input.substring(0,4));
                integer mm = integer.valueOf(input.substring(4,6));
                timestamp = String.valueOf(Date.newInstance(yyyy, mm, 1));
            } else if(input.length() == 8) {
                integer yyyy = integer.valueOf(input.substring(0,4));
                integer mm = integer.valueOf(input.substring(4,6));
                integer dd = integer.valueOf(input.substring(6,8));
                timestamp = String.valueOf(Date.newInstance(yyyy, mm, dd));
            } else if(input.length() > 8) {
                integer yyyy = integer.valueOf(input.substring(0,4));
                integer mm = integer.valueOf(input.substring(4,6));
                integer dd = integer.valueOf(input.substring(6,8));
                timestamp = String.valueOf(Date.newInstance(yyyy, mm, dd));
            } 
        } else {
            timestamp = String.valueOf(Date.newInstance(1900, 1, 1));
        }
        System.debug('DateStamp=='+timestamp); 
        return timestamp;
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