global abstract class SYS_BaseApexHandler {
    global virtual HTTPRequest getHttpRequest() {
        //this should be used to create HTTP request with the right url + authentication
        //add paremeters
        //add body etc
        return null;       
    }
    
    global virtual HTTPRequest modifyHttpRequest(HTTPRequest req) {
        //this should be used to create HTTP request with the right url + authentication
        System.debug('Base class modifyHttpRequest');
        return req;       
    }
    
    global virtual Map<Id, sObject> filterRecords(Map<Id, sObject> oldMap, Map<Id, sObject> newMap) {
        //override filtering of records
        SYS_GetChangedRecords.filterRecords(oldMap,newMap);
        return newMap;
    }
    
    global virtual void outboundMapper(Map<String, Object> flatJsonMap, sObject obj) {
        //use this to fill the json map and override to cover special cases
    }
    
    global virtual void inboundMapper(Map<String, Object> flatJsonMap, sObject obj) {
        //use this to fill the json map and override to cover special cases
    }
}