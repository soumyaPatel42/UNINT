public class IMSCallout {
    public static String inboundEndpoint = 'https://dev-valleymedical-ims.cs91.force.com/services/apexrest/inbound-request-gcp';//INBOUND
    public static String outboundEndpoint = SYS_HttpBuilder.getResourceUrlFromObjectApi('Account');//OUTBOUND
    
    public static void requestRestCallout(String json,Integer statusCode) {
        Blob reqbody = Blob.valueOf(json);
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestURI = inboundEndpoint;
        request.httpMethod = 'POST';
        request.requestBody = reqbody;
        System.debug('Endpoint: ' + inboundEndpoint);
        RestContext.request = request;
        RestContext.response= response;
        response.statusCode = statusCode;
    }
    /*
    public static HttpResponse getInfoFromGCP() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(outboundEndpoint);
        System.debug('Endpoint: ' + outboundEndpoint);
        req.setMethod('POST');
        Http h = new Http();
        HttpResponse res = h.send(req);
        return res;
    }
	*/

}