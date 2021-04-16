public class SYS_RelationshipMapper {
	//Runs in before trigger context to get the parent values and fix lookups/MD
    public List<sObject> mapRelationships() {
        return mapRelationships(Trigger.new);
    }
    
    public List<sObject> mapRelationships(List<sObject> objs) {
        if(objs == null || objs.size() == 0) {
            return null;
        }

        SObjectType objectType = objs[0].getSObjectType();
        //now fetch the object and field settings
        Map<Id, String> jsonMap = new Map<Id, String>();
        List<RelationshipSetting__mdt> mappings = [Select Id, ChildField__c , ParentObject__c , ChildObject__c, ChildRelationshipField__c 
                                                   from RelationshipSetting__mdt where ObjectSetting__r.Object__c = :objectType.getDescribe().getName()];
        Map<String, String> parentMap = new Map<String, String>();
        Map<String, String> parentFieldMap = new Map<String, String>();
        Map<String, Map<String, String>> parentFieldKeyIdMap = new Map<String, Map<String, String>>();
        for(RelationshipSetting__mdt mapping : mappings) {
            parentMap.put(mapping.ParentObject__c, mapping.ChildField__c);
            parentFieldMap.put(mapping.ParentObject__c, mapping.ChildRelationshipField__c);
            parentFieldKeyIdMap.put(mapping.ParentObject__c, new Map<String, String>());
        }
        
        for(sObject obj : objs) {
            for(String parentObject : parentFieldKeyIdMap.keySet()) {
                parentFieldKeyIdMap.get(parentObject).put((String)obj.get(parentMap.get(parentObject)), null);
            }
        }
        
        for(String parentObject : parentFieldKeyIdMap.keySet()) {
           String query = 'Select Id, SYS_Key__c from ' + parentObject + ' where SYS_Key__c in :' +parentFieldKeyIdMap.get(parentObject).keySet();
           List<sObject> parentObjs = Database.query(query);
           for(sObject obj : parentObjs) {
               parentFieldKeyIdMap.get(parentObject).put((String)obj.get('SYS_Key__c'), (String)obj.get('Id'));
           }
        }
        for(String parentObject : parentFieldKeyIdMap.keySet()) {
        	for(sObject obj : objs) {
            	obj.put(parentFieldMap.get(parentObject), parentFieldKeyIdMap.get((String)parentObject).get((String)obj.get((String)parentMap.get(parentObject))));
            }
        }
        return objs;
    }
    
    
}