@isTest 
public class NileCalloutMock implements HttpCalloutMock {
  protected Integer statusCode;
  protected String status;
  protected String body;
  protected Map<String, String> responseHeaders;
  public NileCalloutMock(Integer statusCode, String status, String body, Map<String, String> responseHeaders) {
    this.statusCode = statusCode;
    this.status = status;
    this.body = body;
    this.responseHeaders = responseHeaders;
  }
  public HTTPResponse respond(HTTPRequest req) {
    HttpResponse res = new HttpResponse();
    for (String key : this.responseHeaders.keySet()) {
      res.setHeader(key, this.responseHeaders.get(key));
    }
    res.setBody(this.body);
    res.setStatusCode(this.statusCode);
    res.setStatus(this.status);
    return res;
  }
    
}