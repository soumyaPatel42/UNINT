global class SYS_InvocableHandler {
    
    public static FINAL Integer TEXT_AREA_MAX_SIZE = 131072;
    public static FINAL Integer MAX_DATA_FIELDS = 10;
	
    global class MyInvocableVariable {
        @InvocableVariable(label='Id' required=true)
        public Id recId;
    
        @InvocableVariable(label='Old Value' required=true)
        public sObject oldVal;
    
        @InvocableVariable(label='Current Value' required=true)
        public sObject newVal;

        @InvocableVariable(label= 'Integration Setting' required = false)
        public String integrationSetting;
    }
    
    //TODO - remove descriptio
    @InvocableMethod(label='Transform sObject') 
    global static void printOldAndCurrentValues(List<MyInvocableVariable> myInvocableVariableList) { 
    	List<sObject> newList = new List<sObject>();
        List<sObject> oldList = new List<sObject>();
        Map<String, String> mapOperationType = new Map<String, String>();
        SYS_Constants.INT_TYPE = myInvocableVariableList[0].integrationSetting.trim();  
         
        System.debug('intType=='+SYS_Constants.INT_TYPE+'--');
        for(MyInvocableVariable itr:myInvocableVariableList){
            SYS_DataCache.objectApiName = ((Id)itr.recId).getsobjecttype() + ''; 
            newList.add(itr.newVal);
            oldList.add(itr.oldVal);
            System.debug('externalId=='+SYS_integrationLogHandler.getExternalFieldName(SYS_DataCache.objectApiName));
            String optType = (itr.newVal.get(SYS_integrationLogHandler.getExternalFieldName(SYS_DataCache.objectApiName)) != null) ? 'UPDATE' : 'INSERT';
            mapOperationType.put(String.valueOf(itr.newVal.get('Id')), optType);
            //System.debug('values='+itr.newVal+'old='+itr.oldVal);
        }
        // Map<Id, String> oldjson = SYS_Transformer.getRequestJson(oldList);
        //SYS_Constants.INT_TYPE = integrationSetting;
        Map<Id, String> newjson = SYS_Transformer.getRequestJson(newList);
        System.debug('flow-1');
        List<SYS_IntegrationLog__c> insertSysLog = new List<SYS_IntegrationLog__c>();
       // TODO - Bulkify the method
        
        // String outboundJSON = null;
        // if(keys.size() > 0){
        //     outboundJSON = newjson.get(keys[0]);
        // }
        //TODO - verify the return value..
        if(newjson != null){
            for(Id iter:newjson.keyset()){
                //TODO - address does not accept /n char
                String addrChange;
                if(SYS_Constants.INT_TYPE == 'Airtable'){ 
                    Map<String, List<Object>> record = new Map<String, List<Object>>();
                    Object obj = JSON.deserializeUntyped(newjson.get(iter));
                    if(obj instanceof Map<String, Object>) {
                        if(((Map<String, Object>)obj).get('id') == '' || ((Map<String, Object>)obj).get('id') == null) {
                            ((Map<String, Object>)obj).remove('id');
                        } 
                    }
                    List<Object> objList = new List<Object>{obj};
                    record.put('records', objList);
                    addrChange = JSON.serialize(record);
                } else {
                	addrChange = newjson.get(iter).replace('\n',' ');
                }
                SYS_IntegrationLog__c  newSysLog = SYS_integrationLogHandler.getLogsToInsert(addrChange);
                newSysLog.Status__c = 'NEW';
                newSysLog.Type__c = 'OUTBOUND';
                newSysLog.SYS_IntegrationSettings__c = SYS_Constants.INT_TYPE;
                newSysLog.SYS_Operation_Type__c = mapOperationType.get(String.valueOf(iter));
                newSysLog.whatid__c = iter;
                insertSysLog.add(newSysLog); 
                
            }
            if(insertSysLog.size() > 0){
                System.debug('inside insert'+insertSysLog.size());
                insert insertSysLog;
            }
            
        }
    }
}