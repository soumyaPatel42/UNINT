public class SYS_DataCache {
	private static Map<Id, sObject> oldObjMap = new Map<Id, sObject>();
    private static Map<Id, sObject> newObjMap = new Map<Id, sObject>();
    //TODO - create a map of child mapping that are under eaach parent mapping
    private static Map<String, List<FieldSetting__mdt>> objectFieldSettingMap;
    private static Map<String, Map<String, List<FieldSetting__mdt>>> childFieldSettingMap;
    private static List<FieldSetting__mdt> mappings;
    private static List<FieldSetting__mdt> mappingsInbound;
    
    //TODO - HB -  Fill the objectsettings
    private static ObjectSetting__mdt objectSetting;
    
    //TODO - 'Account' is hardcoded
    private static String context;
    
    public static String ObjectContext{
        get{ return context;}
        //set{context = value;}
    }
	
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
    
    public static Map<Id, sObject> oldMap{
        get{ return oldObjMap;}
        set{
            //TODO should mappings be reset?
            oldObjMap = value;
            if(oldObjMap!=NULL && oldObjMap.size()>0){
                SObjectType objectType = oldObjMap.values()[0].getSObjectType();
                context = JSON.serialize(objectType.getDescribe().getName()).replace('\"','');
            }
        }
    }
    
    public static Map<Id, sObject> newMap{
        get{ return newObjMap;}
        set{
            newObjMap = value;
            if(newObjMap!=NULL && newObjMap.size()>0){
                SObjectType objectType = newObjMap.values()[0].getSObjectType();
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
    public static String objectApiName;
    public static List<ObjectSetting__mdt> objMap = new List<ObjectSetting__mdt>();
    public static Map<String, Map<String, String>> externalIdmap = new Map<String, Map<String, String>>();
    public static Map<String, Map<String, String>> getExtId {
        get {
            if(externalIdmap.values().size() == 0) {
                objMap = new List<ObjectSetting__mdt>();
                objMap = [SELECT DeveloperName,ExternalFieldApi__c,Id,IntegrationType__r.developername ,
                                    ObjectApiName__c,Object__c,QualifiedApiName,ResourcePath__c FROM ObjectSetting__mdt LIMIT 10000];
                
                for(ObjectSetting__mdt obj : objMap) {
                    Map<String, String> objToKey = new Map<String, String>();
                    objToKey.put(obj.ObjectApiName__c, obj.ExternalFieldApi__c);
                    externalIdmap.put(obj.IntegrationType__r.developername, objToKey);
                }
                return externalIdmap;
            }
            return externalIdmap;
        }
    }
    // System.debug('map=='+ JSON.serialize(SYS_DataCache.getExtId)); 
    public static string externalId {
        get{
            if(objMap == null){
                objMap = new List<ObjectSetting__mdt>();
                objMap = [SELECT DeveloperName,ExternalFieldApi__c,Id,IntegrationType__r.developername ,
                                    ObjectApiName__c,Object__c,QualifiedApiName,ResourcePath__c FROM ObjectSetting__mdt 
                                     WHERE IntegrationType__r.developername = : SYS_Constants.INT_TYPE AND ObjectApiName__c = :objectApiName LIMIT 1];
            }
            return objMap.size() > 0 ? objMap[0].ExternalFieldApi__c : '';
        }
    }  

    public static List<HttpHeaders__mdt> headerMetadata;
    public static List<HttpHeaders__mdt> headerSetting{
        get{
            if(headerMetadata == null){
                headerMetadata = new List<HttpHeaders__mdt>();
                headerMetadata = [SELECT Id, MasterLabel, Label, IntegrationType__c, Value__c , Key__c
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
                String intType = SYS_Constants.INT_TYPE;
                String query = 'Select Id,masterlabel, ObjectSetting__r.masterlabel , StaticValue__c,IsChild__c, ObjectSetting__r.ObjectApiName__c, ObjectApiName__c, FieldApiName__c , Key__c, RestResource__c, Direction__c, ParentField__c, ChildRootElement__c,' 
                +'ObjectSetting__r.Direction__c,ObjectSetting__r.Trigger_Condition__c,ObjectSetting__r.TriggerEvents__c, ObjectSetting__r.ResourcePath__c , ObjectSetting__r.ApexHandler__c'
                +' from FieldSetting__mdt'
                +' WHERE Direction__c != \'INBOUND\' AND ObjectSetting__r.IntegrationType__r.MasterLabel = :intType ';
                System.debug('int=='+ intType+'allmapping=='+query);
                // mappings = [Select Id,masterlabel, ObjectSetting__r.masterlabel , StaticValue__c,IsChild__c, ObjectSetting__r.ObjectApiName__c, ObjectApiName__c, FieldApiName__c , Key__c, RestResource__c, Direction__c, ParentField__c, ChildRootElement__c,
                //             ObjectSetting__r.Direction__c,ObjectSetting__r.Trigger_Condition__c,ObjectSetting__r.TriggerEvents__c, ObjectSetting__r.ResourcePath__c , ObjectSetting__r.ApexHandler__c 
                //             from FieldSetting__mdt /*where Is_Active__c=true where FieldApiName__c != null*/ 
                //             WHERE Direction__c = 'OUTBOUND' AND ObjectSetting__r.IntegrationType__r.MasterLabel = : SYS_Constants.INT_TYPE];
                mappings = Database.query(query);
                System.debug('allmapping=='+mappings);
                
            }
            return mappings;
        }
        
    }
    public static List<FieldSetting__mdt> AllInboundFieldSetting {
        get{
            if(mappingsInbound == null) {
                mappingsInbound = new List<FieldSetting__mdt>();
                String intType = SYS_Constants.INT_TYPE; 
                String query = 'Select Id,ChildFieldApiName__c, IsChild__c , ChildRootElement__c, FieldApiName__c, ObjectApiName__c,Key__c, RestResource__c, Direction__c,'+
                + ' ObjectSetting__r.Object__r.QualifiedApiName , ObjectSetting__r.Direction__c, ObjectSetting__r.ResourcePath__c , ObjectSetting__r.ApexHandler__c ' +
                + ' from FieldSetting__mdt where ObjectSetting__r.IntegrationType__r.MasterLabel = :intType and Direction__c!=\'OUTBOUND\' ';
                System.debug('int=='+ intType+'allmapping=='+query); 
                mappingsInbound = Database.query(query);
                System.debug('allmapping=='+mappingsInbound);
            }
            return mappingsInbound;  
        }
    }
    
    public static Map<String, List<FieldSetting__mdt>> GetChildFieldSettingMap{
        get{
            if(childFieldSettingMap == null){
                childFieldSettingMap = new Map<String, Map<String, List<FieldSetting__mdt>>>();
                
                //
                for(FieldSetting__mdt fs : SYS_DataCache.AllFieldSettingMappings){
                    if(fs.ParentField__c != null) {
                        if(childFieldSettingMap.get(fs.ObjectSetting__r.ObjectApiName__c) == null) {
                            childFieldSettingMap.put(fs.ObjectSetting__r.ObjectApiName__c, new Map<String, List<FieldSetting__mdt>>()); 
                        }
                        Map<String, List<FieldSetting__mdt>> childMappingsMap = childFieldSettingMap.get(fs.ObjectSetting__r.ObjectApiName__c);
                        
                        if(childMappingsMap.get(fs.ObjectApiName__c) == null) {
                            childMappingsMap.put(fs.ObjectApiName__c, new List<FieldSetting__mdt>()); 
                        }
                        childMappingsMap.get(fs.ObjectApiName__c).add(fs);
                        
                    }
                }
                //
            }
            return childFieldSettingMap.get(context);
        }
    }
    

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
    
    public static void load(String primaryObj,List<sObject> objsList) {
            //String primaryObj; //TODO-fix this
            if(objectFieldSettingMap == null || objectFieldSettingMap.keySet().size() == 0) {
                List<FieldSetting__mdt> mappings = [Select Id,IsChild__c, ObjectApiName__c, FieldApiName__c , Key__c, RestResource__c, Direction__c, ParentField__c, 
                                           ObjectSetting__r.Direction__c, ObjectSetting__r.ResourcePath__c , ObjectSetting__r.ApexHandler__c 
                                           from FieldSetting__mdt where ObjectSetting__r.ObjectApiName__c = :primaryObj and FieldApiName__c != null];
                
            }
    }

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
    public static void load(){
        List<IntegrationSetting__mdt> listObjSetting = [SELECT EscapeCharacter__c, BaseAPIEndPoint__c, ApexHandler__c, NamedCredential__c, 
                                                   UpdateMethod__c, AuthenticationType__c,
                                                   MasterLabel, DeveloperName, Id, QualifiedApiName 
                                                   FROM IntegrationSetting__mdt LIMIT 100];
        for(IntegrationSetting__mdt val:listObjSetting){
            escCharMap.put(val.MasterLabel , val.EscapeCharacter__c);
        }
    }
    
    // public static Map<String, Id> mapProdkeyToPriceBookEntry = new Map<String, Id>();
    // public static Map<String, Id> mapPriceBookEntry {
    //     get {
    //         if(mapProdkeyToPriceBookEntry.isEmpty() || mapProdkeyToPriceBookEntry == null) {
    //             String pricebook = SYS_Constants.PRICEBOOK;
    //             String query = 'SELECT Id,IsActive,Name,Product2.SYS_Key__c FROM PricebookEntry WHERE IsActive = true AND Product2.SYS_Key__c != null AND Pricebook2.name = : pricebook';
    //             List<PricebookEntry> priceList = Database.query(query);
    //             if(priceList.size() > 0) {
    //                 for(PricebookEntry book : priceList) {
    //                     mapProdkeyToPriceBookEntry.put(book.Product2.SYS_Key__c, book.Id);
    //                 }
    //                 return mapProdkeyToPriceBookEntry;
    //             }
    //         }
    //         return mapProdkeyToPriceBookEntry; 
    //     }
    // }
    // System.debug(JSON.serialize(SYS_DataCache.mapPriceBookEntry));

    // String x = SYS_DataCache.priceBookId;
    public static String bookId;
    public static String priceBookId {
        get {
            if(bookId == null) {
                String book = SYS_Constants.PRICEBOOK;
                String query = 'SELECT Id,Name FROM Pricebook2 WHERE Name = : book';
                List<Pricebook2> books = Database.query(query);
                if(books.size() > 0) {
                    bookId = books[0].Id;
                }
                System.debug(bookId); 
                return bookId;
            }
            return bookId;
        }
    }

    public static string sObjectApiName;
 
    public static String token;
    public static String uuidToken {
        get {
            if(token == null) {
                List<IntegrationSetting__mdt> intSetting = [SELECT Id, developername, accessToken__c FROM IntegrationSetting__mdt WHERE accessToken__c != null AND developername = :SYS_Constants.INT_TYPE];
                if(intSetting.size() > 0) {
                    token = intSetting[0].accessToken__c;
                    return token;
                }
                return '';
            }
            return token;
        }
    }
    
}