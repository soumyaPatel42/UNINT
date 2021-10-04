public class NileRestMokecallOut {
  public static void requestRestCallout(String json,Integer statusCode) {
        Blob reqbody = Blob.valueOf(json);
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestURI = 'jira-webhook';
        request.httpMethod = 'POST';
        request.requestBody = reqbody;
        RestContext.request = request;
        RestContext.response= response;
        response.statusCode = statusCode;
    }
}