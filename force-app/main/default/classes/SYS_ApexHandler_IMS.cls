public class SYS_ApexHandler_IMS extends SYS_ApexHandler{
    public static List<sObject> convertJSONtoSobject(List<String> jsonList, String resource) {
        return getSobjectsToUpsert(jsonList , resource);
    }

    public static Map<Id, String> convertSobjectToJSON(List<sObject> objsList) {
        Map<Id, String> mapIdToJSON = new Map<Id, String>();
        
        for(sObject iter : objsList) {
            System.debug('right method!!');
            Map<Id, String> newMap = SYS_Transformer_IMS.getRequestJson(new List<sObject>{iter});
            mapIdToJSON.putAll(newMap);
        }
        return mapIdToJSON;
    }

    public static List<sObject> convertJSONToParentSobject(List<String> jsonList, String resource) {
        List<sObject> objectsToUpsert = new List<sObject>();
        //TODO filters based on INBOUND, OUTBOUND etc
        List<FieldSetting__mdt> mappings = [Select Id, ParentFieldApiName__c, ChildFieldApiName__c, ObjectSetting__r.ObjectApiName__c , FieldApiName__c, ObjectApiName__c,Key__c, RestResource__c, Direction__c,
                                           ObjectSetting__r.Object__r.QualifiedApiName , ObjectSetting__r.Direction__c, ObjectSetting__r.ResourcePath__c , ObjectSetting__r.ApexHandler__c 
                                           from FieldSetting__mdt where RestResource__c = :resource and Direction__c!='OUTBOUND'];
        
        Map<String, FieldSetting__mdt> mapOfPaths = new Map<String, FieldSetting__mdt>();
        
        //If the current processing is not for child records the primary object is the Object setting value
        String sObjectApiName = null;
        
        //--M String sObjectApiName = null;
        SYS_Constants.load();
        //TODO - To automate selection of integration setting
        String integrationSetting = '';  //IMS_SIU Middleware_hl7
        SYS_Transformer_IMS.isChild = false;
        
        //TODO - refactor the below code
        String rootKey;
        for(String jsonObj : jsonList) {
            if(jsonObj != null || jsonObj != ''){
                Map<String, Object> mapDeserialized = (Map<String, Object>)JSON.deserializeUntyped(jsonObj);
            	rootKey = new List<String>(mapDeserialized.keySet())[0];
                break;
            }
        }
        if(rootKey.contains('SIU')){
            integrationSetting = 'IMS_SIU';
        } else {
            integrationSetting = 'Middleware_hl7';
        }
        //To be automated in integrationLogHandler and store value in DataCache.
        // rootKey = 'SIU_S14';
        rootKey = SYS_DataCache.rootKey;
        System.debug('rootkey@=='+rootkey);

        for(FieldSetting__mdt mapping : mappings) {
            if(mapping.ParentFieldApiName__c != null) {
                String newKey = mapping.Key__c.replace( SYS_Constants.escCharMap.get(integrationSetting), '.').replace('S~I~U', rootKey );
                sObjectApiName = mapping.ObjectApiName__c;
                mapOfPaths.put(newKey, mapping);
                System.debug('mapofPath@== '+newKey + ' value==' + mapping+'@@objapi'+sObjectApiName);
            }
            
            //-- M sObjectApiName = mapping.ObjectSetting__r.Object__r.QualifiedAPIName;
        }
        for(String jsonObj : jsonList) {
            Map<String, Object> mapDeserialized = (Map<String, Object>)JSON.deserializeUntyped(jsonObj);
            rootKey = new List<String>(mapDeserialized.keySet())[0];
            objectsToUpsert.add(parseJsonToObject(jsonObj, sObjectApiName, mapOfPaths));
        }
        
        
       	System.debug('\n\n ########### \n Child objects to upsert:'+objectsToUpsert+'\n ########### \n\n');
        return objectsToUpsert;
    }

    public static sObject parseJsonToObject(String jsonObj, String sObjectApiName, Map<String, FieldSetting__mdt> mapOfPaths) {
        Map<String, Object> flatKeyMap = makeJsonIntoKeyValuePairs(jsonObj);
        if(SYS_Transformer_IMS.isChild){
        	System.debug('\n\n++++++++++++ flatKeyMap: '+flatKeyMap);
            System.debug('\n\n++++++++++++ mapOfPaths: '+mapOfPaths);
 	   }
        // System.debug('\n\n++++++++++++ mapOfPaths: '+mapOfPaths);
        System.debug('\n\n++++++++++++ flatKeyMap: '+JSON.serialize(flatKeyMap));
        
		System.debug('\n\n++++++++++++ B4 sObjectApiName new: '+sObjectApiName+' when child process is: '+SYS_Transformer_IMS.isChild);
        //We are processing array so identify obj name from flatkeymao
        if(sObjectApiName ==null && flatKeyMap.size()>0) {
            //mapOfPaths map doesn't contain outbound fieldsetting. Therefore the key to get the objectname should be a NON outbound key
            
            for(String s:flatKeyMap.keySet()){
                if(mapOfPaths.get(s)!=null){
                    if(mapOfPaths.get(s).Direction__c!='OUTBOUND'){
                        sObjectApiName =  mapOfPaths.get(s).ObjectApiName__c;            
                    }
                }
            }
            /*
            FieldSetting__mdt fieldMapping = mapOfPaths.get((new List<String>(flatKeyMap.keySet()))[0]);
            if(fieldMapping!=null)
            	sObjectApiName = fieldMapping.ObjectApiName__c;
			*/
        }
        System.debug('\n\n++++++++++++ After sObjectApiName: '+sObjectApiName);
        
        //sObjectApiName is still empty means there are no outbound fields for the object as part of array processing
        if(sObjectApiName=='' || sObjectApiName==null) return null;
        
        sObject sObj = Schema.getGlobalDescribe().get(sObjectApiName).newSObject();

        for(String key : mapOfPaths.keySet()) {
            
            FieldSetting__mdt mapping = mapOfPaths.get(key);
            String fieldObj = mapping.ObjectApiName__c;
            //sObj.put('SYS_Key__c', '001');
            System.debug('\n\nRunning for '+mapping.ParentFieldApiName__c+' on:'+sObjectApiName+' and key=='+key);
            
            if(mapping.ParentFieldApiName__c==null){
                
                continue;
            }
   
            if(fieldObj == sObjectApiName && !SYS_Transformer_IMS.isChild && !mapping.ParentFieldApiName__c.contains('__r')){
                SObjectType r = ((SObject)(Type.forName('Schema.'+sObjectApiName).newInstance())).getSObjectType();
                DescribeSObjectResult d = r.getDescribe();
                System.debug('\n\nField Type for if '+mapping.ParentFieldApiName__c);
                String fieldType = d.fields
                        .getMap()
                        .get(mapping.ParentFieldApiName__c)
                        .getDescribe()
                        .getType()+'';
                System.debug('\n\nField Type for '+mapping.ParentFieldApiName__c+' :'+fieldType);
                System.debug('\n flatmap key=='+key);
                System.debug('\n flatmap obj value=='+flatKeyMap.get(key));
                //TODO add other field types
                /*if(fieldType=='DATE'){
                    try{
                    	sObj.put(mapping.ParentFieldApiName__c, date.valueOf((String)flatKeyMap.get(key)));
                    }catch(Exception e){
                        
                    }
                } else */if(mapping.ParentFieldApiName__c == 'BillingPostalCode'){
                    sObj.put(mapping.ParentFieldApiName__c, String.valueof(flatKeyMap.get(key)));
                } else if(mapping.ParentFieldApiName__c == 'Date_Time_Of_Message__c'  && flatKeyMap.get(key) != null) {
                    Datetime t = Datetime.valueof( SYS_integrationLogHandler.convertTimestampToDatetime(String.valueof(flatKeyMap.get(key))) );
                    try{
                        sObj.put(mapping.ParentFieldApiName__c, t);
                    } catch(Exception e) {
                        System.debug('datetime error'+e.getMessage());
                    }
                } else if(mapping.ParentFieldApiName__c == 'Recorded_Date_Time__c'  && flatKeyMap.get(key) != null) {
                    Datetime t = Datetime.valueof( SYS_integrationLogHandler.convertTimestampToDatetime(String.valueof(flatKeyMap.get(key))) );
                    try{
                        sObj.put(mapping.ParentFieldApiName__c, t);
                    } catch(Exception e) {
                        System.debug('datetime error'+e.getMessage());
                    } 
                } else if(mapping.ParentFieldApiName__c == 'Patient_Date_of_Birth__c' && flatKeyMap.get(key) != null) {
                    Date t = Date.valueof( SYS_integrationLogHandler.convertTimestampToDate(String.valueof(flatKeyMap.get(key))) );
                    try{
                        sObj.put(mapping.ParentFieldApiName__c, t);
                    } catch(Exception e) {
                        System.debug('datetime error'+e.getMessage());
                    }
                }
                else if ( (fieldType == 'STRING' || fieldType == 'PICKLIST') && flatKeyMap.get(key) != null) {
                    sObj.put(mapping.ParentFieldApiName__c, String.valueof(flatKeyMap.get(key)));
                }
                else{
                    sObj.put(mapping.ParentFieldApiName__c, flatKeyMap.get(key));
                }
            } 
            
            
            //TODO - make sure that external id is filled - Done with a new fieldsetting metada record
        }
        return sObj;
    }

    public static String addRootElement(String rootKey, String body) {
        // String adtRequest = body.replace('ADT', rootKey).replace('A~D~T', rootKey.split('_')[0]);
        Map<String, Object> outboundAdt = new Map<String, Object>();
        System.debug('addRoot=='+rootKey+' body='+body);
        Object obj = JSON.deserializeUntyped(body);
        outboundAdt.put(rootKey , obj);
        String bodyNew = JSON.serialize(outboundAdt);
        return bodyNew;
    }

    public static List<sObject> convertJSONToChildSObjects(List<String> jsonList, String resource, String childRoot) {
        List<sObject> objectsToUpsert = new List<sObject>();
        //TODO filters based on INBOUND, OUTBOUND etc
        System.debug('add metadata');
        List<FieldSetting__mdt> mappings = new List<FieldSetting__mdt>();
        // SYS_DataCache.rootKey = (SYS_DataCache.rootKey == null) ? 'ADT_A04' : SYS_DataCache.rootKey;
        for(FieldSetting__mdt metadata : SYS_DataCache.AllFieldSettingMappings) {
            if(metadata.RestResource__c == resource && metadata.Direction__c != 'OUTBOUND' && metadata.IsChild__c == true) {
                if(metadata.ChildRootElement__c == 'A~D~T$INSURANCE') {
                    metadata.ChildRootElement__c =  SYS_DataCache.rootKey + '.INSURANCE';
                    System.debug('rootElemrnt=='+metadata.ChildRootElement__c);
                } else if(metadata.Key__c == 'EVN.EVN$1') {
                    metadata.StaticValue__c = SYS_DataCache.rootKey != '' ? SYS_DataCache.rootKey.split('_')[1] : '';
                } else if(metadata.Key__c  == 'MSH.MSH$9.MSG$2') {
                    metadata.StaticValue__c = SYS_DataCache.rootKey != '' ? SYS_DataCache.rootKey.split('_')[1] : '';
                }
                metadata.key__c = metadata.key__c.replace(SYS_DataCache.ESCAPE_CHAR, '.');
                mappings.add(metadata);
                System.debug('add metadata');
            }
        }
        Map<String, FieldSetting__mdt> mapOfPaths = new Map<String, FieldSetting__mdt>();
        
        //If the current processing is not for child records the primary object is the Object setting value
        String sObjectApiName = null;
        //--M String sObjectApiName = null;
        SYS_Constants.load();
        
        //TODO - refactor the below code
        String rootKey;
        for(String jsonObj : jsonList) {
            if(jsonObj != null || jsonObj != ''){
                Map<String, Object> mapDeserialized = (Map<String, Object>)JSON.deserializeUntyped(jsonObj);
            	rootKey = new List<String>(mapDeserialized.keySet())[0];
                break;
            }
        }
        sObjectApiName = 'MemberPlan';
        for(FieldSetting__mdt mapping : mappings) {
            String newKey = mapping.Key__c;
            if(mapping.ChildRootElement__c != null)
                SYS_Transformer_IMS.childRootElement = mapping.ChildRootElement__c.replace('$','.');
            mapOfPaths.put(newKey, mapping);
            System.debug('key==='+ mapping.Key__c + ' value===' + mapping);
            sObjectApiName = mapping.ObjectSetting__r.ObjectApiName__c;
        }
        sObjectApiName = childRoot == 'GT1' ? 'Guarantor__c' : 'MemberPlan';
        System.debug('rootelement=='+SYS_Transformer_IMS.childRootElement);
        SYS_Transformer_IMS.childRootElement = childRoot == 'GT1' ? 'GT1' : SYS_Transformer_IMS.childRootElement ;
        
        SYS_Transformer_IMS.isChild = true;
        System.debug('Mychanges23');
        for(String jsonObj : jsonList) {
            Map<String, Object> mapDeserialized = (Map<String, Object>)JSON.deserializeUntyped(jsonObj);
            rootKey = new List<String>(mapDeserialized.keySet())[0];
            objectsToUpsert.addAll(parseJsonToChildObject(jsonObj, sObjectApiName, mapOfPaths));
        }
        
        
       	System.debug('\n\n ########### \n Child objects to upsert:'+objectsToUpsert+'\n ########### \n\n');
        return objectsToUpsert;
    }

    public static Map<Id, String> getRequestJson(List<sObject> objsList) {
        SYS_DataCache.contextSet = objsList; // sets the context variable in datacache 
        if(objsList == null || objsList.size() == 0) {
            return null;
        }
        SObjectType objectType = objsList[0].getSObjectType();
        String primaryObj = JSON.serialize(objectType.getDescribe().getName()).replace('\"','');
        System.debug('hbdebug objectType.getDescribe().getName() '+ primaryObj);
        
        //now fetch the object and field settings
        Map<Id, String> jsonMap = new Map<Id, String>();
        
        System.debug('hbdebug mappings '+ JSON.serialize(SYS_DataCache.FieldSettingMappings));
        if(SYS_Constants.INT_TYPE == 'Middleware_hl7') {
            for(FieldSetting__mdt metadata : SYS_DataCache.FieldSettingMappings) {
                if(metadata.ChildRootElement__c == 'ADT$INSURANCE') {
                    metadata.ChildRootElement__c = 'ADT_A04.INSURANCE';
                } else if(metadata.Key__c == 'EVN.EVN$1') {
                    metadata.StaticValue__c = 'A04';
                } else if(metadata.Key__c  == 'MSH.MSH$9.MSG$2') {
                    metadata.StaticValue__c = 'A04';
                }
            }
        }
        

        //TODO - fix query above to remove filter on FieldApiName__c + add code for statis
        //check if there are children, query records
        Map<Id, Map<String, List<sObject>>> parentChildObjMap = new Map<Id, Map<String, List<sObject>>>();
        Map<String, List<FieldSetting__mdt>> childMappingsMap = new Map<String, List<FieldSetting__mdt>>();
        List<FieldSetting__mdt> parentMappings = new List<FieldSetting__mdt>();
        Map<String, List<String>> childFieldsMap = new Map<String, List<String>>();
        Map<String, List<String>> primaryObjFieldsMap = new Map<String, List<String>>();
        Map<String, String> parentObjectFieldMap = new Map<String, String>();//NOT USED anywhere
		
        
        
        for(FieldSetting__mdt mapping : SYS_DataCache.FieldSettingMappings) {
            if(mapping.FieldApiName__c == NULL) {
                if(mapping.ParentField__c != null){
                    if(childMappingsMap.get(mapping.ObjectApiName__c) == null) {
                        childMappingsMap.put(mapping.ObjectApiName__c, new List<FieldSetting__mdt>()); 
                    }
                    childMappingsMap.get(mapping.ObjectApiName__c).add(mapping);
                    System.debug(mapping.StaticValue__c+' static json##key==' + mapping.ObjectApiName__c + ' value==' +mapping);
                }
                continue;
            }
            
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
                System.debug(mapping.StaticValue__c+' static json##key==' + mapping.ObjectApiName__c + ' value==' +mapping);
                
                if(childFieldsMap.get(mapping.ObjectApiName__c) == null) {
                    childFieldsMap.put(mapping.ObjectApiName__c, new List<String>()); 
                }
				childFieldsMap.get(mapping.ObjectApiName__c).add(mapping.FieldApiName__c);
                System.debug('static jsonsecond##key==' + mapping.ObjectApiName__c + ' value==' +mapping.FieldApiName__c);
      
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
        List<sObject> objs = new List<sObject>();
        if(primaryObjFieldsMap.size()>0){
            String qry = 'Select Id, '+ 
                     String.join(primaryObjFieldsMap.get(primaryObj), ',') +
                     ' from ' + 
                     primaryObj + 
                     ' where Id in :parentIds';
                    
            System.debug('query res@@=='+qry);
       
        	objs = Database.query(qry);
        }
        // System.debug('query res@@=='+objs[0].getSObject('Account').get('SYS_Key__c'));
         
        
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
        for(sObject obj : objs) {  //looping through quoteline
            Map<String, Object> jsonMapObject = SYS_Transformer_IMS.getRequestJsonSingle(false,obj,SYS_DataCache.FieldSettingMappings, parentChildObjMap);
           System.debug('received data==' + jsonMapObject);
            String objId = (String)obj.get('Id');
            //now fill children - childMappingsMap.get(objectName)[0].
            //Map<Id, Map<String, List<sObject>>> parentChildObjMap
            if(parentChildObjMap.get(objId) != null ) {
                 for(String childObjectName : parentChildObjMap.get(objId).keySet()) { //each quoteLine from map
                    if(childMappingsMap.get(childObjectName)[0].ChildRootElement__c != null){
                        if(jsonMapObject.get(childMappingsMap.get(childObjectName)[0].ChildRootElement__c) == null) {
                        jsonMapObject.put(childMappingsMap.get(childObjectName)[0].ChildRootElement__c, new List<Map<String, Object>>()); 
                        } 
                        System.debug('hbdebug getRequestJsonSingle child - '+ childObjectName);
                    
                        for(sObject childObj : parentChildObjMap.get(objId).get(childObjectName)) {
                            System.debug('Obj added==' + SYS_Transformer_IMS.getRequestJsonSingle(true,childObj, childMappingsMap.get(childObjectName) , parentChildObjMap));
                            System.debug('Obj jsonMapObject==' + jsonMapObject + ' objectKey==' + (String)childMappingsMap.get(childObjectName)[0].ChildRootElement__c);
                           ((List<Map<String, Object>>)jsonMapObject.get((String)childMappingsMap.get(childObjectName)[0].ChildRootElement__c)).add(SYS_Transformer_IMS.getRequestJsonSingle(true,childObj, childMappingsMap.get(childObjectName), parentChildObjMap)); 
                            //Need to debug as line should be an array.
                        }
                    }
                }
            }
            System.debug('Obj jsonMapObject==' + jsonMapObject);

            jsonMap.put(objId, JSON.serialize(jsonMapObject));
            
        }
        return jsonMap;

    }

}