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
    private static String context = 'Account';
    
    public static String ObjectContext{
        get{ return context;}
        //set{context = value;}
    }
	
    //TODO - add a method checkAndLoad , called from every getter, single query on grand child and get 
    //all meta data records from 
    //grand-parents, parents and do the maps.
    
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
    
    public static List<FieldSetting__mdt> AllFieldSettingMappings{
        get{
            if(mappings == null){
                mappings = new List<FieldSetting__mdt>();
                mappings = [Select Id,StaticValue__c,IsChild__c, ObjectSetting__r.ObjectApiName__c, ObjectApiName__c, FieldApiName__c , Key__c, RestResource__c, Direction__c, ParentField__c, 
                            ObjectSetting__r.Direction__c,ObjectSetting__r.Trigger_Condition__c,ObjectSetting__r.TriggerEvents__c, ObjectSetting__r.ResourcePath__c , ObjectSetting__r.ApexHandler__c 
                            from FieldSetting__mdt /*where Is_Active__c=true where FieldApiName__c != null*/];
            }
            return mappings;
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
        
}