public class SYS_Transformer_MS {
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
    public static Map<Id, String> getRequestJson(List<sObject> objsList) {
        //This will take list of object and generate outbound JSON body
        /*
        List<Id> objIds = new List<Id>();
        for(sObject o:objsList){
            objIds.add(o.id);
        }
		*/
        
        
        if(objsList == null || objsList.size() == 0) {
            return null;
        }
        SObjectType objectType = objsList[0].getSObjectType();
        String primaryObj = JSON.serialize(objectType.getDescribe().getName()).replace('\"','');
        System.debug('hbdebug objectType.getDescribe().getName() '+ primaryObj);
        
        //now fetch the object and field settings
        Map<Id, String> jsonMap = new Map<Id, String>();
        List<FieldSetting__mdt> mappings = [Select Id,IsChild__c, ObjectApiName__c, FieldApiName__c , Key__c, RestResource__c, Direction__c, ParentField__c, 
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
        Map<String, List<String>> primaryObjFieldsMap = new Map<String, List<String>>();
        Map<String, String> parentObjectFieldMap = new Map<String, String>();
        for(FieldSetting__mdt mapping : mappings) {
            
            System.debug('\n\n -------------- \n Object check:'+mapping.ObjectApiName__c +' vs. '+primaryObj+'\n -------------- \n\n');
            if(mapping.ObjectApiName__c == primaryObj){
                System.debug('\n\n -------------- \n Object check:'+mapping.ObjectApiName__c +' vs. '+primaryObj+'\n -------------- \n\n');
                    if(primaryObjFieldsMap.get(mapping.ObjectApiName__c) == null) {
                    primaryObjFieldsMap.put(mapping.ObjectApiName__c, new List<String>()); 
                }
				primaryObjFieldsMap.get(mapping.ObjectApiName__c).add(mapping.FieldApiName__c);
            }
            
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
        System.debug('hbdebug primaryObjFieldsMap '+ JSON.serialize(primaryObjFieldsMap));
        //TODO put this behind if condition
        //now query child objects
        List<String> parentIds = new List<String>();
        for(sObject obj : objsList) {
        	parentIds.add((String)obj.get('Id'));
        }
        
        //Dynamically fetch all metadata fields for the primary object
        String qry = 'Select Id, '+ 
                     String.join(primaryObjFieldsMap.get(primaryObj), ',') +
                     ' from ' + 
                     primaryObj + 
                     ' where Id in :parentIds';
        System.debug('\n\n -------------- \n Primary Query:'+qry+'\n -------------- \n\n');
        List<sObject> objs = Database.query(qry);
         
        
        for(String objectName : childFieldsMap.keySet()) {
            //String query = 'Select Id, '+ String.join(childFieldsMap.get(objectName), ',').removeEnd(',') +' from ' + objectName + ' where '+ childMappingsMap.get(objectName)[0].ParentField__c +' in :parentIds';
           	List<sObject> childObjects = Database.query('Select Id, '+ String.join(childFieldsMap.get(objectName), ',') + ',' +childMappingsMap.get(objectName)[0].ParentField__c +' from ' + objectName + ' where '+ childMappingsMap.get(objectName)[0].ParentField__c +' in :parentIds');
           	System.debug('\n\n-----------------\n childObjects :'+childObjects+'\n-----------------\n\n');
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
            Map<String, Object> jsonMapObject = getRequestJsonSingle(false,obj, mappings);
            //System.debug('\n\n***************\n jsonMapObject :'+jsonMapObject.remove('Line')+'\n***************\n\n');
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
                        
                       ((List<Map<String, Object>>)jsonMapObject.get((String)childMappingsMap.get(childObjectName)[0].RestResource__c)).add(getRequestJsonSingle(true,childObj, childMappingsMap.get(childObjectName))); 
                    }
                }
            }
            
            jsonMap.put(objId, JSON.serialize(jsonMapObject));
            System.debug('\n\n***************\n jsonMapObject :'+jsonMapObject+'\n***************\n\n');
        }
        return jsonMap;
    }
    
    public static Map<String, Object> getRequestJsonSingle(Boolean considerChild,sObject obj, List<FieldSetting__mdt> mappings) {
        Map<String, Object> jsonMapObject = new Map<String, Object>();
        System.debug('hbdebug getRequestJsonSingle obj'+ JSON.serialize(obj));
        System.debug('hbdebug getRequestJsonSingle mapping'+ JSON.serialize(mappings));
                
        for(FieldSetting__mdt mapping : mappings) {
            if(mapping.IsChild__c == considerChild){
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
                    jsonMapObject = constructNestedObject(0,obj, mapping, nodeList, jsonMapObject);
                }
            }
        }
        return jsonMapObject;
    }
    
    public static Map<String, Object> constructNestedObject(integer depth,sObject obj, FieldSetting__mdt mapping, List<String> nodeList, Map<String, Object> jsonObj) {
        
        System.debug('hbdebug constructNestedObject obj'+ JSON.serialize(obj));
        System.debug('hbdebug constructNestedObject mapping'+ JSON.serialize(mapping));
        System.debug('hbdebug constructNestedObject nodeList'+ JSON.serialize(nodeList));
        System.debug('hbdebug constructNestedObject jsonObj'+ JSON.serialize(jsonObj));
        System.debug('depth:'+depth);
        
		
        if(nodeList.size() == 2) {
            System.debug('\n\n------------------\n\njsonObj in if:'+jsonObj);
            if(jsonObj.get(nodeList[0]) == null) {
                jsonObj.put(nodeList[0], new Map<String, Object>()); 
            }
            ((Map<String, Object>)jsonObj.get(nodeList[0])).put(nodeList[1], getFieldValues(obj, mapping.FieldApiName__c));
            System.debug('\n\n------------------\n\njsonObj in exit:'+jsonObj);
            return jsonObj;
        }
        else if(nodeList.size() > 0) {
            if(jsonObj.get(nodeList[0]) == null) {
                
                System.debug('\n\n------------------\n\njsonObj in else if:'+jsonObj);
                System.debug('\n------------------\n\nnodeList:'+nodeList);
                List<String> nodeSubList = subList(nodeList, 1);
                Map<String, Object> intermediateJsonObj = new Map<String, Object>();
                intermediateJsonObj = constructNestedObject(++depth,obj, mapping, nodeSubList, new Map<String, Object>());
                jsonObj.put(nodeList[0], intermediateJsonObj);
                
            } else {
                /*
                System.debug('\n\n------------------\n\njsonObj in else:'+jsonObj);
                Map<String, Object> intermediateJsonObj = new Map<String, Object>();
                intermediateJsonObj = constructNestedObject(++depth,obj, mapping, subList(nodeList, 1), (Map<String, Object>)jsonObj.get(nodeList[0]));
                System.debug('\n\n------------------\n\nintermediateJsonObj:'+intermediateJsonObj);
                Map<String, Object> tempJsonObj = (Map<String, Object>)jsonObj.get(nodeList[0]);
                Map<String, Object> tempValueJsonObj = (Map<String, Object>)tempJsonObj.get(nodeList[1]);
                tempValueJsonObj.put(nodeList[1], intermediateJsonObj);
				*/
                
                Map<String, Object> intermediateJsonObj = new Map<String, Object>();
                Map<String, Object> intermediateTwoJsonObj = new Map<String, Object>();
                intermediateTwoJsonObj = (Map<String, Object>)jsonObj.get(nodeList[0]);
                intermediateJsonObj = constructNestedObject(++depth,obj, mapping, subList(nodeList, 1), intermediateTwoJsonObj);
                
     			System.debug('\n\n------------------\n\n *** nodeList[1]:'+nodeList[1]);
                System.debug('\n\n------------------\n\n *** nodeList[0]:'+nodeList[0]);
                System.debug('\n\n------------------\n\n *** intermediateJsonObj:'+intermediateJsonObj);

                
                ((Map<String, Object>)jsonObj.get(nodeList[0])).put(nodeList[1], intermediateJsonObj.get(nodeList[1]));
            
            }
            System.debug('\n\n------------------\n\njsonObj in exit 2 :'+jsonObj);
            return jsonObj;  
        }
        else {
            System.debug('\n\n------------------\n\njsonObj in exit 3:'+jsonObj);
            return jsonObj; 
        }
		
        //return jsonObj;
    }
    
    //The router calls this method and it will have all relevant information
    //Router makes sure that if the json is List, it breaks it down and passes to this method
    //Also, each resource gets broken down - TODO see if we can enhance this.
    public static List<sObject> getSObjectsToUpsert(List<String> jsonList, String resource, String direction,String sObjectApiName) {
        List<sObject> objectsToUpsert = new List<sObject>();
        //TODO filters based on INBOUND, OUTBOUND etc
        List<FieldSetting__mdt> mappings = [Select Id, FieldApiName__c, ObjectApiName__c,Key__c, RestResource__c, Direction__c,
                                           ObjectSetting__r.Object__r.QualifiedApiName , ObjectSetting__r.Direction__c, ObjectSetting__r.ResourcePath__c , ObjectSetting__r.ApexHandler__c 
                                           from FieldSetting__mdt where RestResource__c = :resource and Direction__c=:direction];
        
        Map<String, FieldSetting__mdt> mapOfPaths = new Map<String, FieldSetting__mdt>();
        //--M String sObjectApiName = null;
        for(FieldSetting__mdt mapping : mappings) {
            mapOfPaths.put(mapping.Key__c, mapping);
            //-- M sObjectApiName = mapping.ObjectSetting__r.Object__r.QualifiedAPIName;
        }
        
        for(String jsonObj : jsonList) {
            objectsToUpsert.add(parseJsonToObject(jsonObj, sObjectApiName, mapOfPaths));
        }
         
        System.debug('\n\n ########### \n objectsToUpsert:'+objectsToUpsert+'\n ########### \n\n');
        return objectsToUpsert;
    }
    
    //
    public static sObject parseJsonToObject(String jsonObj, String sObjectApiName, Map<String, FieldSetting__mdt> mapOfPaths) {
        Map<String, Object> flatKeyMap = makeJsonIntoKeyValuePairs(jsonObj);
        System.debug('\n\n -------------- \n flatKeyMap:'+flatKeyMap+'\n -------------- \n\n');
        System.debug('\n\n -------------- \n mapOfPaths:'+mapOfPaths+'\n -------------- \n\n');
        
        //We are processing array so identify obj name from flatkeymao
        if(sObjectApiName ==''){
            
        }
        
        sObject sObj = Schema.getGlobalDescribe().get(sObjectApiName).newSObject();
        
        for(String key : mapOfPaths.keySet()) {
            
            FieldSetting__mdt mapping = mapOfPaths.get(key);
            String fieldObj = mapping.ObjectApiName__c;
            //sObj.put('SYS_Key__c', '001');
            System.debug('\n\nRunning for '+mapping.FieldApiName__c+' on:'+sObjectApiName);
            
            if(mapping.FieldApiName__c==null){continue;}
   
            if(fieldObj == sObjectApiName){
                SObjectType r = ((SObject)(Type.forName('Schema.'+sObjectApiName).newInstance())).getSObjectType();
                DescribeSObjectResult d = r.getDescribe();
                String fieldType = d.fields
                        .getMap()
                        .get(mapping.FieldApiName__c)
                        .getDescribe()
                        .getType()+'';
                System.debug('\n\nField Type for '+mapping.FieldApiName__c+' :'+fieldType);
                //TODO add other field types
                if(fieldType=='DATE'){
                    try{
                    	sObj.put(mapping.FieldApiName__c, date.valueOf((String)flatKeyMap.get(mapping.Key__c)));
                    }catch(Exception e){
                        
                    }
                }
                else{
                    sObj.put(mapping.FieldApiName__c, flatKeyMap.get(mapping.Key__c));
                }
            }
            
            
            //TODO - make sure that external id is filled - Done with a new fieldsetting metada record
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
                
                System.debug('\n\n -------------- \n currentObj type:'+currentObj+'\n -------------- \n\n');
                
            } else {
                
                String parentKey = '';
                if(parents != null && parents.size() > 0) {
                    parentKey = String.join(parents, '.');
                } 
                if (currentObj instanceof Decimal) {
                //Add
                	result.put(parentKey +'.'+ key, (Decimal) currentObj);
                } else if (currentObj instanceof Integer) {
                //Add
                    result.put(parentKey +'.'+ key, (Integer) currentObj);
                }
                else if (currentObj instanceof String) {
                    //Add
                    result.put(parentKey +'.'+ key,  currentObj);
                } else if (currentObj instanceof Boolean) {
                    //Add
                    result.put(parentKey +'.'+ key, (Boolean) currentObj);
                } 
                else if (currentObj == null) {
                    //TODO - Verify accuracy on what needs to be done
                    result.put(parentKey +'.'+ key, null);
                }
                else{
                    // Its an array
                    for(Object obj:(List<Object>)currentObj){
                        List<String> childRecList = new List<String>();
                        String objString = JSON.serialize(obj);
                        childRecList.add(objString);
                        getSObjectsToUpsert_F(childRecList,key);
                    }
                }
            }
            
        }
        return;
        
    }
    
    @future
    public static void getSObjectsToUpsert_F(List<String> childRecList, String key){
        getSObjectsToUpsert(childRecList,key, 'INBOUND','OpportunityLineItem');
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