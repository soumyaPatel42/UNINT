public class SYS_InboundIntegrationWebhook{
    
    public string respBody='';
    public SYS_InboundIntegrationWebhook() {
        
        
        String requestEndPoint='';
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndPoint(requestEndPoint);
        request.setHeader('Content-type', 'application/json');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        if(response.getStatusCode()==200){
            
            this.respBody = response.getBody();
            
        }
        
        system.debug('JSON String ===>' + respBody);
        
        List<SYS_IntegrationLog__c> AllSysInte = new List<SYS_IntegrationLog__c>();
        List<SYS_IntegrationLog__c> SYSintegration = (List<SYS_IntegrationLog__c>)JSON.deserialize(respBody,List<SYS_IntegrationLog__c>.class);           
        
        for( SYS_IntegrationLog__c  SYSInte: SYSintegration){
            
            SYS_IntegrationLog__c  NewSysInte = new SYS_IntegrationLog__c ();
            
            NewSysInte.id = SYSInte.id;
            NewSysInte.Status__c= SYSInte.Status__c;
            NewSysInte.Type__c = SYSInte.Type__c;
            //NewSysInte.data0__c = SYSInte.Body;
            AllSysInte.add(NewSysInte);  
        }
        Database.insert(AllSysInte);
    }
}