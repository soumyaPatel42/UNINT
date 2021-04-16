public class SYS_Transformer_BKUP {
	/*
    public IntegrationData {
        sObject obj
        Map<String, Object> jsonTree;
        Map<String, Object> jsonFlatOuboundTree;
        Map<String, Object> jsonFlatInboundTree;
        Boolean shouldProcess; //if false don't process further
        IntegrationData(sObject obj) {
        
        }
        set(String key, Object value) {
        
        }
    }
    */
    public static Map<Id, String> getRequestJson(List<sObject> objs) {
        //This will take list of object and generate outbound JSON body
        
        if(objs == null || objs.size() == 0) {
            return null;
        }
        SObjectType objectType = objs[0].getSObjectType();
        System.debug('hbdebug objectType.getDescribe().getName() '+ JSON.serialize(objectType.getDescribe().getName()));
        //now fetch the object and field settings
        Map<Id, String> jsonMap = new Map<Id, String>();
        List<FieldSetting__mdt> mappings = [Select Id, ObjectApiName__c, FieldApiName__c , Key__c, RestResource__c, Direction__c, ParentField__c, 
                                           ObjectSetting__r.Direction__c, ObjectSetting__r.ResourcePath__c , ObjectSetting__r.ApexHandler__c 
                                           from FieldSetting__mdt where ObjectSetting__r.ObjectApiName__c = :objectType.getDescribe().getName()
                                           and FieldApiName__c != null];
        System.debug('hbdebug mappings '+ JSON.serialize(mappings));
        //TODO - fix query above to remove filter on FieldApiName__c + add code for statis
        //check if there are children, query records
        Map<Id, Map<String, List<sObject>>> parentChildObjMap = new Map<Id, Map<String, List<sObject>>>();
        Map<String, List<FieldSetting__mdt>> childMappingsMap = new Map<String, List<FieldSetting__mdt>>();
        List<FieldSetting__mdt> parentMappings = new List<FieldSetting__mdt>();
        Map<String, List<String>> childFieldsMap = new Map<String, List<String>>();
        Map<String, String> parentObjectFieldMap = new Map<String, String>();
        for(FieldSetting__mdt mapping : mappings) {
            if(mapping.ParentField__c != null) {
                if(childMappingsMap.get(mapping.ObjectApiName__c) == null) {
                    childMappingsMap.put(mapping.ObjectApiName__c, new List<FieldSetting__mdt>()); 
                }
                childMappingsMap.get(mapping.ObjectApiName__c).add(mapping);
                
                if(childFieldsMap.get(mapping.ObjectApiName__c) == null) {
                    childFieldsMap.put(mapping.ObjectApiName__c, new List<String>()); 
                }
				childFieldsMap.get(mapping.ObjectApiName__c).add(mapping.FieldApiName__c);
            } else {
                parentMappings.add(mapping);
            }
        }
        System.debug('hbdebug parentMappings '+ JSON.serialize(parentMappings));
        System.debug('hbdebug childMappingsMap '+ JSON.serialize(childMappingsMap));
        System.debug('hbdebug childFieldsMap '+ JSON.serialize(childFieldsMap));
        //TODO put this behind if condition
        //now query child objects
        List<String> parentIds = new List<String>();
        for(sObject obj : objs) {
        	parentIds.add((String)obj.get('Id'));
        }
        
        for(String objectName : childFieldsMap.keySet()) {
            //String query = 'Select Id, '+ String.join(childFieldsMap.get(objectName), ',').removeEnd(',') +' from ' + objectName + ' where '+ childMappingsMap.get(objectName)[0].ParentField__c +' in :parentIds';
           	List<sObject> childObjects = Database.query('Select Id, '+ String.join(childFieldsMap.get(objectName), ',') + ',' +childMappingsMap.get(objectName)[0].ParentField__c +' from ' + objectName + ' where '+ childMappingsMap.get(objectName)[0].ParentField__c +' in :parentIds');
           	for(sObject obj : childObjects) {
                if(parentChildObjMap.get((String)obj.get(childMappingsMap.get(objectName)[0].ParentField__c)) == null) {
                    parentChildObjMap.put((String)obj.get(childMappingsMap.get(objectName)[0].ParentField__c), new Map<String, List<sObject>>());
                }
                if(parentChildObjMap.get((String)obj.get((String)childMappingsMap.get(objectName)[0].ParentField__c)).get(objectName) == null) {
                	parentChildObjMap.get((String)obj.get((String)childMappingsMap.get(objectName)[0].ParentField__c)).put(objectName, new List<sObject>());	       
                }
            	parentChildObjMap.get((String)obj.get((String)childMappingsMap.get(objectName)[0].ParentField__c)).get(objectName).add(obj);
            }
        }
        System.debug('hbdebug parentChildObjMap '+ JSON.serialize(parentChildObjMap));
        for(sObject obj : objs) {
            Map<String, Object> jsonMapObject = getRequestJsonSingle(obj, mappings);
            String objId = (String)obj.get('Id');
            //now fill children - childMappingsMap.get(objectName)[0].
            //Map<Id, Map<String, List<sObject>>> parentChildObjMap
            if(parentChildObjMap.get(objId) != null) {
                 for(String childObjectName : parentChildObjMap.get(objId).keySet()) {
                    if(jsonMapObject.get(childMappingsMap.get(childObjectName)[0].RestResource__c) == null) {
                       jsonMapObject.put(childMappingsMap.get(childObjectName)[0].RestResource__c, new List<Map<String, Object>>()); 
                    }
                    System.debug('hbdebug getRequestJsonSingle child - '+ childObjectName);
                    for(sObject childObj : parentChildObjMap.get(objId).get(childObjectName)) {
                        
                       ((List<Map<String, Object>>)jsonMapObject.get((String)childMappingsMap.get(childObjectName)[0].RestResource__c)).add(getRequestJsonSingle(childObj, childMappingsMap.get(childObjectName))); 
                    }
                }
            }
            
            jsonMap.put(objId, JSON.serialize(jsonMapObject));
        }
        return jsonMap;
    }
    
    public static Map<String, Object> getRequestJsonSingle(sObject obj, List<FieldSetting__mdt> mappings) {
        Map<String, Object> jsonMapObject = new Map<String, Object>();
        System.debug('hbdebug getRequestJsonSingle obj'+ JSON.serialize(obj));
        System.debug('hbdebug getRequestJsonSingle mapping'+ JSON.serialize(mappings));
        for(FieldSetting__mdt mapping : mappings) {
            //TODO handle .'s and nested
            System.debug('hbdebug getRequestJsonSingle mapping.Key__c'+ JSON.serialize(mapping.Key__c));
            List<String> nodeList = mapping.Key__c.split('\\.');
            System.debug('hbdebug getRequestJsonSingle nodeList'+ JSON.serialize(nodeList));
            if(nodeList.size() < 2) {
                System.debug('hbdebug getRequestJsonSingle nodeList[0]'+ JSON.serialize(nodeList[0]));
                System.debug('hbdebug getRequestJsonSingle mapping.FieldApiName__c'+ JSON.serialize(mapping.FieldApiName__c));
                //TODO mapping.FieldApiName__c can be parent queries on standard/custom
                jsonMapObject.put(nodeList[0], obj.get(mapping.FieldApiName__c));
            }
            else {
                System.debug('hbdebug getRequestJsonSingle else'+ JSON.serialize(nodeList[0]));
                jsonMapObject = constructNestedObject(obj, mapping, nodeList, jsonMapObject);
            }            
        }
        return jsonMapObject;
    }
    
    public static Map<String, Object> constructNestedObject(sObject obj, FieldSetting__mdt mapping, List<String> nodeList, Map<String, Object> jsonObj) {
        System.debug('hbdebug constructNestedObject obj'+ JSON.serialize(obj));
        System.debug('hbdebug constructNestedObject mapping'+ JSON.serialize(mapping));
        System.debug('hbdebug constructNestedObject nodeList'+ JSON.serialize(nodeList));
        System.debug('hbdebug constructNestedObject jsonObj'+ JSON.serialize(jsonObj));
        
        if(nodeList.size() == 2) {
            if(jsonObj.get(nodeList[0]) == null) {
                jsonObj.put(nodeList[0], new Map<String, Object>()); 
            }
            ((Map<String, Object>)jsonObj.get(nodeList[0])).put(nodeList[1], getFieldValues(obj, mapping.FieldApiName__c));
            return jsonObj;
        }
        else if(nodeList.size() > 0) {
            if(jsonObj.get(nodeList[0]) == null) {
                jsonObj.put(nodeList[0], constructNestedObject(obj, mapping, subList(nodeList, 1), new Map<String, Object>()));
            } else {
                ((Map<String, Object>)jsonObj.get(nodeList[0])).put(nodeList[1], constructNestedObject(obj, mapping, subList(nodeList, 1), (Map<String, Object>)jsonObj.get(nodeList[0])));
            }
            return jsonObj;  
        } 
        else {
            return jsonObj; 
        }
    }
    
    //The router calls this method and it will have all relevant information
    //Router makes sure that if the json is List, it breaks it down and passes to this method
    //Also, each resource gets broken down - TODO see if we can enhance this.
    public static List<sObject> getSObjectsToUpsert(List<String> jsonList, String resource, String direction) {
        List<sObject> objectsToUpsert = new List<sObject>();
        //TODO filters based on INBOUND, OUTBOUND etc
        List<FieldSetting__mdt> mappings = [Select Id, FieldApiName__c, Key__c, RestResource__c, Direction__c,
                                           ObjectSetting__r.Object__r.QualifiedApiName , ObjectSetting__r.Direction__c, ObjectSetting__r.ResourcePath__c , ObjectSetting__r.ApexHandler__c 
                                           from FieldSetting__mdt where RestResource__c = :resource];
        
        Map<String, FieldSetting__mdt> mapOfPaths = new Map<String, FieldSetting__mdt>();
        String sObjectApiName = null;
        for(FieldSetting__mdt mapping : mappings) {
            mapOfPaths.put(mapping.Key__c, mapping);
            sObjectApiName = mapping.ObjectSetting__r.Object__r.QualifiedAPIName;
        }
        for(String jsonObj : jsonList) {
            objectsToUpsert.add(parseJsonToObject(jsonObj, sObjectApiName, mapOfPaths));
        }
        return objectsToUpsert;
    }
    
    //
    public static sObject parseJsonToObject(String jsonObj, String sObjectApiName, Map<String, FieldSetting__mdt> mapOfPaths) {
        Map<String, Object> flatKeyMap = makeJsonIntoKeyValuePairs(jsonObj);
        sObject sObj = Schema.getGlobalDescribe().get(sObjectApiName).newSObject();
        for(String key : mapOfPaths.keySet()) {
            FieldSetting__mdt mapping = mapOfPaths.get(key);
            sObj.put(mapping.FieldApiName__c, flatKeyMap.get(mapping.Key__c));
            //TODO - make sure that external id is filled
        }
        return sObj;
    }
    
    public static Map<String, Object> makeJsonIntoKeyValuePairs(String jsonObj) {
        Object result = JSON.deserializeUntyped(jsonObj);
        Map<String, Object> flatKeyMap = new Map<String, Object>();
        if (result instanceof Map<String, Object>) {
            recursiveJsonParser((Map<String, Object>)result, new List<String>(), flatKeyMap);
        }
        return flatKeyMap;
    }
    
    private static void recursiveJsonParser(Map<String, Object> jsonObject, List<String> parents, Map<String, Object> result) {
        //Handle arrays later
        for(String key : jsonObject.keySet()) {
            Object currentObj = jsonObject.get(key);
            if (currentObj instanceof Map<String, Object>) {
                Map<String, Object> child = (Map<String, Object>)currentObj;
                parents.add(key);
                recursiveJsonParser(child, parents, result);
                parents.remove(parents.size() - 1);
            } else {
                String parentKey = '';
                if(parents != null && parents.size() > 0) {
                    parentKey = String.join(parents, '.');
                } 
                if (currentObj instanceof Decimal) {
                //Add
                	result.put(parentKey + key, (Decimal) currentObj);
                } else if (currentObj instanceof Integer) {
                //Add
                	result.put(parentKey + key, (Integer) currentObj);
                }
                else if (currentObj instanceof String) {
                    //Add
                    result.put(parentKey + key,  currentObj);
                } else if (currentObj instanceof Boolean) {
                    //Add
                    result.put(parentKey + key, (Boolean) currentObj);
                } 
                else if (currentObj == null) {
                    //TODO - Verify accuracy on what needs to be done
                    result.put(parentKey + key, null);
                }  
            }
        }
        return;
        
    }
    
    public static Object getFieldValues(sObject obj, String fieldAPIName){
        //TODO - handle case - Account."CreatedBy".Name, where CreatedBy is not an sobject
        String fvalue='';
        if(fieldAPIName.contains('.')){
            List<String> splitedFields = fieldAPIName.split('\\.');
            try{
                for(Integer i = 0; i < splitedFields.size() - 1; i++){
                    obj = obj.getSobject(splitedFields[i]);   
                }
                return obj.get(splitedFields[splitedFields.size()-1]);
            }catch(exception ex){
               system.debug('******exception while fetching fieldValues as relationship '+fieldAPIName+'  value is blank.'+ex.getmessage()); 
               return null;
            }
            
        }else if(obj.get(fieldAPIName)!=null){
            return obj.get(fieldAPIName);
        }
        return fvalue;
    }
    public static List<String> subList(List<String> master, Integer index) {
        List<String> sList = new List<String>();
        for(Integer i = index; i < master.size(); i ++) {
            sList.add(master[i]);
        }
        return sList;
    }

}