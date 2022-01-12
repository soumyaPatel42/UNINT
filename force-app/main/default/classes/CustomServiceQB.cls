@RestResource(urlMapping = '/quickbooks/v2/*') //TODO - change mapping name quickbooks/
global class CustomServiceQB {
    
    @httpPost
    global static void doPostMethod(){
        String requestBody = RestContext.request.requestBody.toString();
        System.debug('body==' + requestBody);
        System.debug('url=='+ RestContext.request.requestURI);  
        String token = RestContext.request.params.get('token') != null ? RestContext.request.params.get('token') : '';
        System.debug('token=='+RestContext.request.params);
        
        RestContext.response.responseBody = adiqb.SYS_webhook.processWebhookResponse(token, requestBody);
        //Account acc = new Account(lastname = 'Slimshaddy');
        //insert acc;
    }

}