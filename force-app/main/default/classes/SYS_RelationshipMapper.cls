public class SYS_RelationshipMapper {
	//Runs in before trigger context to get the parent values and fix lookups/MD
    public List<sObject> mapRelationships() {
        return mapRelationships(Trigger.new);
    }
    
    public static List<sObject> mapRelationships(List<sObject> objs) {
        if(objs == null || objs.size() == 0) {
            return null;
        }

        SObjectType objectType = objs[0].getSObjectType();
        System.debug('type=='+objs[0].getSObjectType());
        //now fetch the object and field settings
        Map<Id, String> jsonMap = new Map<Id, String>();
        List<RelationshipSetting__mdt> mappings = [Select Id, ChildObjectNew__c, ChildFieldNew__c, ChildRelationshipFieldNew__c, ChildField__c, ChildField__r.QualifiedApiName , 
                                                    ParentObject__c, ParentObject__r.QualifiedApiName , ChildObject__r.QualifiedApiName, ChildRelationshipField__r.QualifiedApiName
                                                    from RelationshipSetting__mdt where ObjectSetting__r.ObjectApiName__c = :objectType.getDescribe().getName()];
        if((objectType + '') == 'MemberPlan' || (objectType + '') == 'Guarantor__c') {
            mappings = [Select Id, ChildObjectNew__c, ChildFieldNew__c, ChildRelationshipFieldNew__c, ChildField__c, ChildField__r.QualifiedApiName , 
                                                    ParentObject__c, ParentObject__r.QualifiedApiName , ChildObject__r.QualifiedApiName, ChildRelationshipField__r.QualifiedApiName
                                                    from RelationshipSetting__mdt where ChildObjectNew__c = : objectType.getDescribe().getName()]; 
        }
        Map<String, String> parentMap = new Map<String, String>();
        Map<String, String> parentFieldMap = new Map<String, String>();
        Map<String, Map<String, String>> parentFieldKeyIdMap = new Map<String, Map<String, String>>();
        for(RelationshipSetting__mdt mapping : mappings) {
            parentMap.put(mapping.ParentObject__r.QualifiedApiName, mapping.ChildFieldNew__c);
            parentFieldMap.put(mapping.ParentObject__r.QualifiedApiName, mapping.ChildRelationshipFieldNew__c);
            parentFieldKeyIdMap.put(mapping.ParentObject__r.QualifiedApiName, new Map<String, String>());
        }
        System.debug('mapping=='+mappings);
        System.debug('mapping parentMap=='+parentMap);
        System.debug('mapping parentFieldMap=='+parentFieldMap);
        System.debug('mapping parentFieldKeyIdMap=='+parentFieldKeyIdMap);

        for(sObject obj : objs) {
            for(String parentObject : parentFieldKeyIdMap.keySet()) {
                parentFieldKeyIdMap.get(parentObject).put((String)obj.get(parentMap.get(parentObject)), null);
            }
        }
        
        for(String parentObject : parentFieldKeyIdMap.keySet()) {
            //TODO - external If field for IMS id not SYS key...
            List<String> key = new List<String>(parentFieldKeyIdMap.get(parentObject).keySet());
            System.debug('Key=='+key);
            String query = 'Select Id, CS_External_ID__c from ' + parentObject + ' where CS_External_ID__c in : key';/* + parentFieldKeyIdMap.get(parentObject).keySet().toString().replace('{','(').replace('}',')');*/
            System.debug('Query=='+ query);
            List<sObject> parentObjs = Database.query(query);
            for(sObject obj : parentObjs) {
                    String extId = String.valueof(obj.get('CS_External_ID__c'));
                    parentFieldKeyIdMap.get(parentObject).put(extId, (String)obj.get('Id'));
            }
        }
        for(String parentObject : parentFieldKeyIdMap.keySet()) {
        	for(sObject obj : objs) {
            	obj.put(parentFieldMap.get(parentObject), parentFieldKeyIdMap.get((String)parentObject).get((String)obj.get((String)parentMap.get(parentObject))));
                System.debug('obj val--'+parentFieldMap.get(parentObject) + ' ** '+ parentFieldKeyIdMap.get((String)parentObject).get((String)obj.get((String)parentMap.get(parentObject))));
            }
        }
        return objs;
    }

    
    
}