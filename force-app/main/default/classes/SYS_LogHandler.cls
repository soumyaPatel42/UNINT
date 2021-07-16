public class SYS_LogHandler {
    public static FINAL Integer TEXT_AREA_MAX_SIZE = 131072;
    public static FINAL Integer MAX_DATA_FIELDS = 10;
    public static final Integer MAX_SPLITS = 5; //There is a 6 million character limit on String in Apex
    public static final Integer MAX_PER_RECORD = TEXT_AREA_MAX_SIZE * MAX_DATA_FIELDS;
    public static final String DATA_FIELD = 'data';
    
    public Map<ObjectSetting__mdt , List<String>> getOutboundLogs() {
        //Map split by object setting
        return null;
    }
    //TODO - fix this later to use SYS_Datacache
    public void insertOutboundLogs(Map<Id, String> jsonList, String objectSettingId) {
        
    }
    
    private List<SYS_IntegrationLog__c> generateLogs(String jsonStr, String direction, String objectSettingId) {
        //first split by record max and then split into columns
        List<SYS_IntegrationLog__c> logList = new List<SYS_IntegrationLog__c>();
        if(jsonStr.length() > MAX_PER_RECORD) {
            //split and call generateLog
            Integer startIndex = 0;
            //TODO - check if the index -1 is correct.
            while((startIndex + MAX_PER_RECORD - 1) < jsonStr.length()) {
                logList.add(generateLog(jsonStr.substring(startIndex, startIndex + MAX_PER_RECORD), direction, objectSettingId));
                startIndex = startIndex + MAX_PER_RECORD;
            }
            //There could be one last portion of string
            if(startIndex + 1 < jsonStr.length()) {
                logList.add(generateLog(jsonStr.substring(startIndex), direction, objectSettingId));
            }
            
        } else {
            logList.add(generateLog(jsonStr, direction, objectSettingId));
        }
        return logList;
    }
    
    private SYS_IntegrationLog__c generateLog(String jsonStr, String direction, String objectSettingId) {
        //TODO - copy code from SYS_OutboundBatchHandler
        return null;
    }
}