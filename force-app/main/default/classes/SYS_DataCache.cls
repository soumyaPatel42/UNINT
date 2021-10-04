public class SYS_DataCache {
	private static Map<Id, sObject> oldObjMap = new Map<Id, sObject>();
    private static Map<Id, sObject> newObjMap = new Map<Id, sObject>();
    //TODO - create a map of child mapping that are under eaach parent mapping
    private static Map<String, List<FieldSetting__mdt>> objectFieldSettingMap;
    private static Map<String, Map<String, List<FieldSetting__mdt>>> childFieldSettingMap;
    private static List<FieldSetting__mdt> mappings;
    
    //TODO - HB -  Fill the objectsettings
    private static ObjectSetting__mdt objectSetting;
    
    //TODO - 'Account' is hardcoded
    private static String context;
    
	
    //TODO - add a method checkAndLoad , called from every getter, single query on grand child and get 
    //all meta data records from 
    //grand-parents, parents and do the maps.
    
    public static List<sObject> sObjList = new List<sObject>();
    public static List<sObject> contextSet{
        set{
            sObjList = value;
            if(sObjList!=NULL && sObjList.size()>0){
                SObjectType objectType = sObjList[0].getSObjectType();
                context = JSON.serialize(objectType.getDescribe().getName()).replace('\"','');
            }
        }
    }
    
    
    public static List<IntegrationSetting__mdt> intMap;
    public static List<IntegrationSetting__mdt> integrationSetting {
        get{
            if(intMap == null){
                intMap = new List<IntegrationSetting__mdt>();
                intMap = [SELECT Id, DeveloperName, Label, UpdateMethod__c, 
                                     AuthenticationType__c, BaseAPIEndPoint__c, 
                                     QualifiedApiName, EscapeCharacter__c FROM IntegrationSetting__mdt 
                                     WHERE developername = : SYS_Constants.INT_TYPE LIMIT 1];
            }
            return intMap;
        }
    }
    public static List<HttpHeaders__mdt> headerMetadata;
    public static List<HttpHeaders__mdt> headerSetting{
        get{
            if(headerMetadata == null){
                headerMetadata = new List<HttpHeaders__mdt>();
                headerMetadata = [SELECT Id, MasterLabel, Label, IntegrationType__c, Value__c 
                                    FROM HttpHeaders__mdt 
                                    WHERE IntegrationType__c =: integrationSetting[0].id];
            }
            return headerMetadata;
        }
    }
    // TODO - add flatkey map in datacache...
    // public static Map<String, Object> flatKey;
    // public static Map<String, Object> flatKeyMap {
    //     get{
    //         if(flatKey == null) {
    //             // SYS_Transformer_IMS.makeJsonIntoKeyValuePairs()
    //         }
    //     }
    // }

    public static List<FieldSetting__mdt> AllFieldSettingMappings{
        get{
            if(mappings == null){
                mappings = new List<FieldSetting__mdt>();
                mappings = [Select Id,masterlabel, ObjectSetting__r.masterlabel , StaticValue__c,IsChild__c, ObjectSetting__r.ObjectApiName__c, ObjectApiName__c, FieldApiName__c , Key__c, RestResource__c, Direction__c, ParentField__c, ChildRootElement__c,
                            ObjectSetting__r.Direction__c,ObjectSetting__r.Trigger_Condition__c,ObjectSetting__r.TriggerEvents__c, ObjectSetting__r.ResourcePath__c , ObjectSetting__r.ApexHandler__c , ObjectSetting__r.Object__r.QualifiedAPIName,  ChildFieldApiName__c
                            from FieldSetting__mdt /*where Is_Active__c=true where FieldApiName__c != null*/
                            WHERE ObjectSetting__r.IntegrationType__r.MasterLabel = : SYS_Constants.INT_TYPE AND Direction__c != 'INBOUND'];
                //TODO - removed where clause because static values were not working.
                //TODO - hardcoded the ADT_A04
                // if(SYS_Constants.INT_TYPE == 'Middleware_hl7') {
                //     for(FieldSetting__mdt metadata : mappings) {
                //         if(metadata.ChildRootElement__c == 'ADT$INSURANCE') {
                //             metadata.ChildRootElement__c = 'ADT_A04$INSURANCE';
                //         } else if(metadata.Key__c == 'EVN.EVN$1') {
                //             metadata.StaticValue__c = 'A04';
                //         } else if(metadata.Key__c  == 'MSH.MSH$9.MSG$2') {
                //             metadata.StaticValue__c = 'A04';
                //         }
                //     }
                // }
            }
            System.debug('inside datacache'+mappings);
            return mappings;
        }
        
    }
    
    // public static Map<String, List<FieldSetting__mdt>> GetChildFieldSettingMap{
    //     get{
    //         if(childFieldSettingMap == null){
    //             childFieldSettingMap = new Map<String, Map<String, List<FieldSetting__mdt>>>();
                
    //             //
    //             for(FieldSetting__mdt fs : SYS_DataCache.AllFieldSettingMappings){
    //                 if(fs.ParentField__c != null) {
    //                     if(childFieldSettingMap.get(fs.ObjectSetting__r.ObjectApiName__c) == null) {
    //                         childFieldSettingMap.put(fs.ObjectSetting__r.ObjectApiName__c, new Map<String, List<FieldSetting__mdt>>()); 
    //                     }
    //                     Map<String, List<FieldSetting__mdt>> childMappingsMap = childFieldSettingMap.get(fs.ObjectSetting__r.ObjectApiName__c);
                        
    //                     if(childMappingsMap.get(fs.ObjectApiName__c) == null) {
    //                         childMappingsMap.put(fs.ObjectApiName__c, new List<FieldSetting__mdt>()); 
    //                     }
    //                     childMappingsMap.get(fs.ObjectApiName__c).add(fs);
                        
    //                 }
    //             }
    //             //
    //         }
    //         return childFieldSettingMap.get(context);
    //     }
    // }
    

    public static List<FieldSetting__mdt> FieldSettingMappings{
        get{
            if(objectFieldSettingMap == null){
                objectFieldSettingMap = new Map<String, List<FieldSetting__mdt>>();
                System.debug('\n\n+++++++++++ objectFieldSettingMap:'+objectFieldSettingMap);
                for(FieldSetting__mdt fs : SYS_DataCache.AllFieldSettingMappings){
                    System.debug('\n\n+++++++++++ fs:'+fs);
                    if(objectFieldSettingMap.containsKey(fs.ObjectSetting__r.ObjectApiName__c)){
                        objectFieldSettingMap.get(fs.ObjectSetting__r.ObjectApiName__c).add(fs);
                    }
                    else{
                        objectFieldSettingMap.put(fs.ObjectSetting__r.ObjectApiName__c,new List<FieldSetting__mdt>{fs});
                    }
                }
            }
            System.debug('\n\n+++++++++++ Map for context:'+context+':'+objectFieldSettingMap);
            System.debug('\n\n+++++++++++ for context:'+context+':'+objectFieldSettingMap.get(context));
            return objectFieldSettingMap.get(context);
        }
    }
    
    // public static void load(String primaryObj,List<sObject> objsList) {
    //         //String primaryObj; //TODO-fix this
    //         if(objectFieldSettingMap == null || objectFieldSettingMap.keySet().size() == 0) {
    //             List<FieldSetting__mdt> mappings = [Select Id,IsChild__c, ObjectApiName__c, FieldApiName__c , Key__c, RestResource__c, Direction__c, ParentField__c, 
    //                                        ObjectSetting__r.Direction__c, ObjectSetting__r.ResourcePath__c , ObjectSetting__r.ApexHandler__c 
    //                                        from FieldSetting__mdt where ObjectSetting__r.ObjectApiName__c = :primaryObj and FieldApiName__c != null];
                
    //         }
    // }

    public static Map<String, String> escCharMap = new Map<String, String>();
    
    public static String ESCAPE_CHAR{
        get{
                if(escCharMap  == null || escCharMap.isEmpty()) {
                    system.debug('esc char loop');
                    List<IntegrationSetting__mdt> listObjSetting = [SELECT EscapeCharacter__c, BaseAPIEndPoint__c, ApexHandler__c, NamedCredential__c, 
                                                    UpdateMethod__c, AuthenticationType__c,
                                                    MasterLabel, DeveloperName, Id, QualifiedApiName 
                                                    FROM IntegrationSetting__mdt LIMIT 100];
                for(IntegrationSetting__mdt val:listObjSetting){
                    escCharMap.put(val.MasterLabel , val.EscapeCharacter__c);
                }
            }
            System.debug('escape char is==' + escCharMap);
            return escCharMap.get(SYS_Constants.INT_TYPE);
        }
    }
    // public static void load(){
    //     List<IntegrationSetting__mdt> listObjSetting = [SELECT EscapeCharacter__c, BaseAPIEndPoint__c, ApexHandler__c, NamedCredential__c, 
    //                                                UpdateMethod__c, AuthenticationType__c,
    //                                                MasterLabel, DeveloperName, Id, QualifiedApiName 
    //                                                FROM IntegrationSetting__mdt LIMIT 100];
    //     for(IntegrationSetting__mdt val:listObjSetting){
    //         escCharMap.put(val.MasterLabel , val.EscapeCharacter__c);
    //     }
    // }
    
    public static String rootKey;

    public static List<IntegrationSetting__mdt> listObjSetting = new List<IntegrationSetting__mdt>();
    public static String privateKey;
    public static String JWT_KEY {
        get {
            if(privateKey == null || listObjSetting.size() == 0) {
                listObjSetting = listObjSetting = [SELECT JWT_privateKey__c, JWT_iss__c, JWT_sub__c, JWT_aud__c, JWT_target_audience__c, JWT_algo__c,JWT_token_url__c
                                                    FROM IntegrationSetting__mdt WHERE DeveloperName = : SYS_Constants.INT_TYPE LIMIT 100];
                privateKey = listObjSetting[0].JWT_privateKey__c;
            }
            return privateKey;
        }
    }
    public static String JWT_ISS {
        get{
            String iss = '';
            if(listObjSetting.size() == 0) {
                listObjSetting = [SELECT JWT_privateKey__c, JWT_iss__c, JWT_sub__c, JWT_aud__c, JWT_target_audience__c, JWT_algo__c,JWT_token_url__c
                                                   FROM IntegrationSetting__mdt WHERE DeveloperName = : SYS_Constants.INT_TYPE LIMIT 100];
            } else {
                iss = listObjSetting[0].JWT_iss__c;
            }
            iss = listObjSetting[0].JWT_iss__c;
            return iss;
        }
    }
    public static String JWT_AUD {
        get{
            String aud = '';
            if(listObjSetting.size() == 0) {
                listObjSetting = [SELECT JWT_privateKey__c, JWT_iss__c, JWT_sub__c, JWT_aud__c, JWT_target_audience__c, JWT_algo__c,JWT_token_url__c
                                                   FROM IntegrationSetting__mdt WHERE DeveloperName = : SYS_Constants.INT_TYPE LIMIT 100];
            } else {
                aud = listObjSetting[0].JWT_aud__c;
            }
            aud = listObjSetting[0].JWT_aud__c;
            return aud;
        }
    }
    public static String JWT_SUB {
        get{
            String sub = '';
            if(listObjSetting.size() == 0) {
                listObjSetting = [SELECT JWT_privateKey__c, JWT_iss__c, JWT_sub__c, JWT_aud__c, JWT_target_audience__c, JWT_algo__c,JWT_token_url__c
                                                   FROM IntegrationSetting__mdt WHERE DeveloperName = : SYS_Constants.INT_TYPE LIMIT 100];
            } else {
                sub = listObjSetting[0].JWT_sub__c;
            }
            sub = listObjSetting[0].JWT_sub__c;
            return sub;
        }
    }
    public static String JWT_TARGET_AUD {
        get{
            String target_aud = '';
            if(listObjSetting.size() == 0) {
                listObjSetting = [SELECT JWT_privateKey__c, JWT_iss__c, JWT_sub__c, JWT_aud__c, JWT_target_audience__c, JWT_algo__c,JWT_token_url__c
                                                   FROM IntegrationSetting__mdt WHERE DeveloperName = : SYS_Constants.INT_TYPE LIMIT 100];
            } else {
                target_aud = listObjSetting[0].JWT_target_audience__c;
            }
            target_aud = listObjSetting[0].JWT_target_audience__c;
            return target_aud;
        }
    }
    public static String JWT_TOKEN_URL {
        get{
            String token = '';
            if(listObjSetting.size() == 0) {
                listObjSetting = [SELECT JWT_privateKey__c, JWT_iss__c, JWT_sub__c, JWT_aud__c, JWT_target_audience__c, JWT_algo__c,JWT_token_url__c
                                                   FROM IntegrationSetting__mdt WHERE DeveloperName = : SYS_Constants.INT_TYPE LIMIT 100];
            } else {
                token = listObjSetting[0].JWT_token_url__c;
            }
            token = listObjSetting[0].JWT_token_url__c;
            return token;
        }
    }
    public static String JWT_ALGO {
        get{
            String algo = '';
            if(listObjSetting.size() == 0) {
                listObjSetting = [SELECT JWT_privateKey__c, JWT_iss__c, JWT_sub__c, JWT_aud__c, JWT_target_audience__c, JWT_algo__c,JWT_token_url__c
                                                   FROM IntegrationSetting__mdt WHERE DeveloperName = : SYS_Constants.INT_TYPE LIMIT 100];
            } else {
                algo = listObjSetting[0].JWT_algo__c;
            }
            algo = listObjSetting[0].JWT_algo__c;
            return algo;
        }
    }
    
}