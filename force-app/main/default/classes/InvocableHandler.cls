global class InvocableHandler {
    
    public static FINAL Integer TEXT_AREA_MAX_SIZE = 131072;
    public static FINAL Integer MAX_DATA_FIELDS = 10;
	
    public class MyInvocableVariable {
        @InvocableVariable(label='Id' required=true)
        public Id recId;
    
        @InvocableVariable(label='Old Value' required=true)
        public sObject oldVal;
    
        @InvocableVariable(label='Current Value' required=true)
        public sObject newVal;
    }
    
    //TODO - remove descriptio
    @InvocableMethod(label='Old and Current Value' description='Print Old and Current Values')
    public static void printOldAndCurrentValues(List<MyInvocableVariable> myInvocableVariableList) {
    	List<sObject> newList = new List<sObject>();
        List<sObject> oldList = new List<sObject>();
        for(MyInvocableVariable itr:myInvocableVariableList){
            newList.add(itr.newVal);
            oldList.add(itr.oldVal);
            //System.debug('values='+itr.newVal+'old='+itr.oldVal);
        } 
        Map<Id, String> oldjson = SYS_Transformer.getRequestJson(oldList);
        Map<Id, String> newjson = SYS_Transformer.getRequestJson(newList);
        //List<Id> keys = newjson.keyset();
        List<SYS_IntegrationLog__c> insertSysLog = new List<SYS_IntegrationLog__c>();
       // TODO - Bulkify the method
        
        // String outboundJSON = null;
        // if(keys.size() > 0){
        //     outboundJSON = newjson.get(keys[0]);
        // }
        if(newjson.values().size() > 0){
            for(Id iter:newjson.keyset()){
                //TODO - address does not accept /n char
                String addrChange = newjson.get(iter).replace('\n',' ');
                if(newjson.get(iter).length() <= TEXT_AREA_MAX_SIZE){
                    System.debug('JSON can accomodate in single data field: '+addrChange);
                    SYS_IntegrationLog__c log = new SYS_IntegrationLog__c(Status__c='NEW',Type__c = 'OUTBOUND',whatid__c=iter);
                    log.put('data0__c',addrChange);
                    insertSysLog.add(log);
                }
                //TODO - logic for 6M 
                //TODO - need to figure out how to Bulkify.
                else{
                    System.debug('JSON needs chunking into multiple data fields: '+addrChange);
                    SYS_IntegrationLog__c log = new SYS_IntegrationLog__c(Status__c='NEW',Type__c = 'OUTBOUND',whatid__c=iter);
                    Integer di = 0;
                    String jsonSubStrng;
                    Integer endIndex = TEXT_AREA_MAX_SIZE;
                    String outboundJSON = addrChange;
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
                    insertSysLog.add(log);
                }
            }
            if(insertSysLog.size() > 0){
                System.debug('inside insert');
                insert insertSysLog;
            }
            
        }
    }
}