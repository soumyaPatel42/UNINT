public class SYS_Constants {
	public static Integer TEXT_AREA_MAX_SIZE {
        get {
            return 131072;
        }
    }
    public static Integer MAX_DATA_FIELDS {
        get{
            return 10;
        }
    }
    public static FINAL String OUTBOUND = 'OUTBOUND';
    public static FINAL String INBOUND = 'OUTBOUND';
    public static FINAL String SYSMERGE = 'MERGE';
    public static FINAL String RESOURCE = 'entityName/entityId?minorversion=59';
    public static String INT_TYPE = 'Middleware_hl7'; //  Middleware_hl7 IMS_SIU
    
    
    public static Map<String, String> escCharMap = new Map<String, String>();
    public static String RESOURCE_PATH = 'blank';
    public static String ROOT_KEY = 'ADT';
    public static String ESCAPE_CHAR{
        get{
            return ESCAPE_CHAR;
        } set{
            ESCAPE_CHAR = escCharMap.get(value) != null ? escCharMap.get(value) : '';
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
    public static String getKeyReplacement(String rootKey){
        return rootKey.contains('ADT') ? 'ADT' : 'SIU' ;
    }
}