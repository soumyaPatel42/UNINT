public class QB_restmokecallout {
    public static void requestRestCallout(String json,Integer statusCode) {
        Blob reqbody = Blob.valueOf(json);
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestURI = '/services/apexrest/quickbooks/v1?token=26a56265-89ed-432a-bdb9-eeedc384f4a8';
        request.httpMethod = 'POST';
        request.requestBody = reqbody;
        RestContext.request = request;
        RestContext.response= response;
        response.statusCode = statusCode;
    }
}