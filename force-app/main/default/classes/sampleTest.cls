@isTest
public class sampleTest {
      public class QuickBookCalloutMock implements HttpCalloutMock {
      protected Integer code;
      protected String status;
      protected String body;
      protected Map<String, String> responseHeaders;
      
      public QuickBookCalloutMock(Integer code, String status, String body, Map<String, String> responseHeaders) {
        this.code = code;
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
        res.setStatusCode(this.code);
        res.setStatus(this.status);
          system.debug('res='+res);
        return res;
      }
}
    public class Mock implements HttpCalloutMock {
        public Mock(String str) {
            HttpRequest req = new HttpRequest();
            req.setEndPoint('my_endpoint');
            req.setCompressed(true);
            req.setBody(str);
        }
        
        public HTTPResponse respond(HTTPRequest req) {
            if(req.getBody() == '{"key":"value"}') { 
            HTTPResponse res = new HTTPResponse();
            res.setBody('{"key":23}');
            res.setStatusCode(200);
            return res;
            }
            HTTPResponse res = new HTTPResponse();
            res.setBody('{"key":24}');
            res.setStatusCode(200);
            return res;
        }
    }
    @isTest 
    public static void methodOne() {
        string resJson1 = '{"Customer":{"Id":"106","SyncToken":"0","FamilyName":"AccountTesting","FullyQualifiedName":"AccountTesting","DisplayName":"AccountTesting","PrintOnCheckName":"AccountTesting","Active":true,"Mobile":{"FreeFormNumber":"+19999999999"},"PrimaryEmailAddr":{"Address":"js@gmail.com"},"Taxable":true,"BillAddr":{"Id":"322","Line1":"Delaware","City":"Corolla","Country":"United States","CountrySubDivisionCode":"NC","PostalCode":"27927"},"ShipAddr":{"Id":"323","Line1":"Delaware","City":"Corolla","Country":"United States","CountrySubDivisionCode":"NC","PostalCode":"27927"},"Job":false,"BillWithParent":false,"Balance":0,"BalanceWithJobs":0,"CurrencyRef":{"value":"USD","name":"United States Dollar"},"PreferredDeliveryMethod":"Print","IsProject":false,"domain":"QBO","sparse":false,"MetaData":{"CreateTime":"2021-10-21T14:15:17-07:00","LastUpdatedTime":"2021-10-21T14:15:17-07:00"},"DefaultTaxCodeRef":{"value":"2"}},"time":"2021-10-21T14:16:17.286-07:00"}';
		string resJson2 = '{"Customer":{"Id":"107","SyncToken":"0","FamilyName":"AccountTesting1","FullyQualifiedName":"AccountTesting1","DisplayName":"AccountTesting1","PrintOnCheckName":"AccountTesting1","Active":true,"Mobile":{"FreeFormNumber":"+19999999999"},"PrimaryEmailAddr":{"Address":"js@gmail.com"},"Taxable":true,"BillAddr":{"Id":"322","Line1":"Delaware","City":"Corolla","Country":"United States","CountrySubDivisionCode":"NC","PostalCode":"27927"},"ShipAddr":{"Id":"323","Line1":"Delaware","City":"Corolla","Country":"United States","CountrySubDivisionCode":"NC","PostalCode":"27927"},"Job":false,"BillWithParent":false,"Balance":0,"BalanceWithJobs":0,"CurrencyRef":{"value":"USD","name":"United States Dollar"},"PreferredDeliveryMethod":"Print","IsProject":false,"domain":"QBO","sparse":false,"MetaData":{"CreateTime":"2021-10-21T14:15:17-07:00","LastUpdatedTime":"2021-10-21T14:15:17-07:00"},"DefaultTaxCodeRef":{"value":"2"}},"time":"2021-10-21T14:16:17.286-07:00"}';
        
        String str = '{"key":"value"}';
        Test.setMock(HttpCalloutMock.class, new Mock(str));
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://example.com/example/test');
        req.setMethod('POST');
        req.setBody('{"key":"value"}');
        Http h = new Http();
        Test.startTest();
        HttpResponse res = h.send(req);
        Test.stopTest();
        System.debug('resp=='+res.getBody());
    }
}