public class InvocableHandler {
    public class MyInvocableVariable {
        @InvocableVariable(label='Id' required=true)
        public Id recId;
    
        @InvocableVariable(label='Old Value' required=true)
        public sObject oldVal;
    
        @InvocableVariable(label='Current Value' required=true)
        public sObject newVal;
    }
    
    @InvocableMethod(label='Old and Current Value' description='Print Old and Current Values')
    public static void printOldAndCurrentValues(List<MyInvocableVariable> myInvocableVariableList) {
    
    }
}