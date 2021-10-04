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
    }
    
    //TODO - remove descriptio
    @InvocableMethod(label='Old and Current Value' description='Print Old and Current Values')
    global static void printOldAndCurrentValues(List<MyInvocableVariable> myInvocableVariableList) {
    	List<sObject> newList = new List<sObject>();
        List<sObject> oldList = new List<sObject>();
        System.debug('invocable class');
        Map<String, String> mapIdToRoot = new Map<String, String>();
        for(MyInvocableVariable itr:myInvocableVariableList){
            if( itr.newVal.get('RecordTypeId') ==  SYS_integrationLogHandler.getObjectRecordTypeId('Account' ,'Patient') ) {
                newList.add(itr.newVal);
            }
            oldList.add(itr.oldVal);
            //System.debug('values='+itr.newVal+'old='+itr.oldVal);
            if(((Id)itr.newVal.get('Id')).getSObjectType().getDescribe().getName() == 'Account') {
                mapIdToRoot.put(String.valueOf(itr.newVal.get('Id')) , String.valueOf(itr.newVal.get('Last_Event__c')));
            }
        }
        SYS_Constants.INT_TYPE = 'Middleware_hl7';
        SYS_DataCache.rootKey = (SYS_DataCache.rootKey == null) ? 'ADT_A04' : SYS_DataCache.rootKey;
        
        //Map<Id, String> oldjson = SYS_ApexHandler_IMS.convertSobjectToJSON(oldList);
        Map<Id, String> newjson = SYS_ApexHandler_IMS.convertSobjectToJSON(newList);
        //List<Id> keys = newjson.keyset();
        List<SYS_IntegrationLog__c> insertSysLog = new List<SYS_IntegrationLog__c>();
       
        if(newjson.values().size() > 0){
            for(Id iter:newjson.keyset()){
                //TODO - address does not accept /n char
                String addrChange;
                if(SYS_Constants.INT_TYPE == 'Middleware_hl7'){
                    addrChange = newjson.get(iter).replace('\n',' ').replace('$','.').replace('\\\\','\\');
                    SYS_DataCache.rootKey = mapIdToRoot.get(String.valueOf(iter));
                    SYS_DataCache.rootKey = (SYS_DataCache.rootKey == null) ? 'ADT_A04' : SYS_DataCache.rootKey;
                    addrChange = SYS_ApexHandler_IMS.addRootElement(SYS_DataCache.rootKey, addrChange);
                } else {
                	addrChange = newjson.get(iter).replace('\n',' ');
                }
                SYS_IntegrationLog__c  newSysLog = SYS_integrationLogHandler.getLogsToInsert(addrChange);
                newSysLog.Status__c = 'NEW';
                newSysLog.Type__c = 'OUTBOUND';
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