public class SYS_OutBoundBatchHandler {
    
    public static FINAL Integer TEXT_AREA_MAX_SIZE = 131072;
    public static FINAL Integer MAX_DATA_FIELDS = 10;
    
	public static void processInsert(List<sObject> objs) {
     	//chunk the batch into pieces
     	SYS_Transformer.getRequestJson(objs);
    }
    
    public static void processUpdate(Map<Id, sObject> oldMap, Map<Id, sObject> newMap) {
     	//chunk the batch into pieces
     	
        SYS_DataCache.oldMap = oldMap;
        SYS_DataCache.newMap = newMap;
        //TODO get apexhandler from metadata for the Object
        String apexHandler = 'SYS_BaseApexHandler_Ext';
        if(SYS_DataCache.FieldSettingMappings[0].ObjectSetting__r.ApexHandler__c!=NULL && 
          SYS_DataCache.FieldSettingMappings[0].ObjectSetting__r.ApexHandler__c!=''){
              
            apexHandler = SYS_DataCache.FieldSettingMappings[0].ObjectSetting__r.ApexHandler__c;
        }
     	SYS_BaseApexHandler baseExt = (SYS_BaseApexHandler)Type.forName(apexHandler).newInstance();
		
        Map<Id, String> json = SYS_Transformer.getRequestJson(baseExt.filterRecords(oldMap,newMap).values());
        List<Id> keys = new List<Id>(json.keySet());
       
        String outboundJSON = null;
        if(keys.size()>0){
            outboundJSON = json.get(keys[0]);
        }
        //String outboundJSON = JSON.serialize(SYS_Transformer.getRequestJson(baseExt.filterRecords(oldMap,newMap).values()));
        
        if(outboundJSON == 'null' || outboundJSON == null){
            System.debug('No JSON to generate Log: '+outboundJSON);
            return;
        }
        else if(outboundJSON.length() <= TEXT_AREA_MAX_SIZE){
            System.debug('JSON can accomodate in single data field: '+outboundJSON);
            SYS_IntegrationLog__c log = new SYS_IntegrationLog__c(Status__c='NEW',Type__c = 'OUTBOUND',whatid__c=keys[0]);
            log.put('data0__c',outboundJSON);
            insert log;
        }
        else{
            System.debug('JSON needs chunking into multiple data fields: '+outboundJSON);
            SYS_IntegrationLog__c log = new SYS_IntegrationLog__c(Status__c='NEW',Type__c = 'OUTBOUND',whatid__c=keys[0]);
            Integer di = 0;
            String jsonSubStrng;
            Integer endIndex = TEXT_AREA_MAX_SIZE;
            do{
                jsonSubStrng = outboundJSON.substring(0,endIndex);
                log.put('data'+di+'__c',jsonSubStrng);
                outboundJSON = outboundJSON.substring(endIndex);
                endIndex = (outboundJSON.length() < TEXT_AREA_MAX_SIZE)?outboundJSON.length():TEXT_AREA_MAX_SIZE;
                di++;
                if(di == MAX_DATA_FIELDS-1 && outboundJSON.length() > TEXT_AREA_MAX_SIZE){
                    log.put('data'+di+'__c','JSON too large. Truncated');
                    break;
                }
            }while(outboundJSON.length()>0);
            insert log;
        }
    }
    
    public static void processDelete(List<sObject> objs) {
     	//chunk the batch into pieces  
    }
    
    public static void processUndelete(List<sObject> objs) {
     	//chunk the batch into pieces  
    }

}