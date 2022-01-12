global class SYS_InvocableHandler {
	
    global class MyInvocableVariable {
        @InvocableVariable(label='Id' required=true)  
        global Id recId;
    
        @InvocableVariable(label='Old Value' required=true)  
        global sObject oldVal;
    
        @InvocableVariable(label='Current Value' required=true)
        global sObject newVal;

        @InvocableVariable(label= 'Integration Setting' required = true)
        global String integrationSetting; 

        @InvocableVariable(label= 'Operation Type' required = true)
        global String operationType;

        @InvocableVariable(label= 'Object Setting' required = true)
        global String objectSetting;
    }
    
    //TODO - remove descriptio
    @InvocableMethod(label='Old and Current Value' description='Print Old and Current Values')
    global static void printOldAndCurrentValues(List<MyInvocableVariable> myInvocableVariableList) {
    	List<sObject> newList = new List<sObject>();
        List<sObject> oldList = new List<sObject>();
        // Map<String, String> mapOperationType = new Map<String, String>();
        Map<String, Object> discountMap = new Map<String, Object>();
        String objectApiName = '';
        String operationType = myInvocableVariableList.size() > 0 ? myInvocableVariableList[0].operationType.toUppercase() : 'INSERT';
        for(MyInvocableVariable itr:myInvocableVariableList){
            objectApiName = ((Id)itr.recId).getSobjectType() + '';
            newList.add(itr.newVal);   
            oldList.add(itr.oldVal);
            SYS_Constants.INT_TYPE = itr.integrationSetting;
            SYS_Constants.OBJ_TYPE = itr.objectSetting;
        } 
        Map<Id, String> newjson = SYS_Transformer.getRequestJson(newList);
        List<SYS_IntegrationLog__c> insertSysLog = new List<SYS_IntegrationLog__c>();
       
        if(newjson.values().size() > 0){
            for(Id iter:newjson.keyset()){ 
                String addrChange;
                
                addrChange = newjson.get(iter).replace('\n',' ');
                //TODO - QB specific change for bundle product  
                
                if(objectApiName == 'SBQQ__Quote__c') {
                    Decimal totalDiscount = ((Decimal)discountMap.get(iter));
                    Object convert = JSON.deserializeUntyped(addrChange);
                    if(convert instanceof Map<String, Object> && ((Map<String, Object>)convert).get('Line') != null) {
                        Object line = ((Map<String, Object>)convert).get('Line');
                        if(line instanceof List<Object>) {
                            List<Object> updatedLine = new List<Object>();
                            for(Object ln : ((List<Object>)line)) {
                                if(ln instanceof Map<String, Object> && ((Boolean)((Map<String, Object>)ln).get('Bundle')) == false ) {
                                    ((Map<String, Object>)ln).remove('Bundle');
                                    updatedLine.add(ln);
                                }    
                            }
                            //updatedLine.add(discount);
                            ((Map<String, Object>)convert).put('Line', updatedLine); 
                            addrChange = JSON.serialize(convert); 
                        }
                    }
                } else if (objectApiName == 'Product2') {
                    productWrapper prod = (productWrapper)JSON.deserialize(addrChange, productWrapper.class);
                    Object prodObj = JSON.deserializeUntyped(addrChange);
                    if('Inventory'.equalsIgnoreCase(prod.Type)) {
                        ((Map<String, Object>)prodObj).put('TrackQtyOnHand', true);
                        addrChange = JSON.serialize(prodObj);
                    }
                    
                }
                
                SYS_IntegrationLog__c  newSysLog = SYS_integrationLogHandler.getLogsToInsert(addrChange);
                newSysLog.Status__c = 'NEW';
                newSysLog.Type__c = 'OUTBOUND';
                newSysLog.SYS_IntegrationSettings__c = SYS_Constants.INT_TYPE;
                newSysLog.SYS_Operation_Type__c = operationType;
                newSysLog.whatid__c = iter;
                insertSysLog.add(newSysLog);   
            }
            if(!insertSysLog.isEmpty() && SYS_DataCache.enableCheck.get(SYS_Constants.INT_TYPE.toUpperCase())){ 
                SYS_debug.log('inside insert'+insertSysLog.size());
                insert insertSysLog;
            }
            
        }
    }

    // SYS_debug.log(JSON.serialize(new discountWrapper));

   

    public class productWrapper {
        public String Type;
    }
}