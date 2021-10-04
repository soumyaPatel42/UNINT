public class SYS_HttpBuilder {

    public static HttpRequest getJWTrequest() { 
        
        JWT jwt = new JWT(SYS_DataCache.JWT_ALGO);

        jwt.validFor = 600;
        jwt.iss = SYS_DataCache.JWT_ISS;
        jwt.sub = SYS_DataCache.JWT_SUB;
        jwt.aud = SYS_DataCache.JWT_AUD;
        Map<String,String> claims = new  Map<String,String>();
        claims.put('target_audience', SYS_DataCache.JWT_TARGET_AUD);
        jwt.claims = claims;
        String access_token = JWTBearerFlow.getAccessToken(SYS_DataCache.JWT_TOKEN_URL , jwt);

        System.debug('access_token= '+access_token);

        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization', 'Bearer '+access_token);
        return req;

    }

    public static String getResourceUrlFromObjectApi(String objApi){
        String resourceUrl = SYS_DataCache.integrationSetting[0].BaseAPIEndPoint__c;
        if(objApi != null || objApi != ''){
            List<ObjectSetting__mdt> objSetting = [SELECT Id, ResourcePath__c, masterlabel, ObjectApiName__c
                                                   FROM ObjectSetting__mdt WHERE ObjectApiName__c = : objApi 
                                                   and IntegrationType__r.DeveloperName = : SYS_DataCache.integrationSetting[0].developername];
            System.debug('resource url='+objSetting[0].ResourcePath__c);
            if(objSetting.size() != 0){
                resourceUrl += objSetting[0].ResourcePath__c;
            }
        }
        System.debug('resource url='+resourceUrl);
        return resourceUrl;
    }

}