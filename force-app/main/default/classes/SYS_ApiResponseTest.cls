@isTest
public class SYS_ApiResponseTest {
    @IsTest static void statusCode400() {
        SYS_ApiResponse.error = new DmlException();
        integer inte = SYS_ApiResponse.statusCode;
        System.debug('>>>>' + inte);
        System.assertEquals(inte, 400);
    }
    @IsTest static void statusCode500() {
        SYS_ApiResponse.error = new CalloutException();
        integer inte = SYS_ApiResponse.statusCode;
        System.debug('>>>>' + inte);
        System.assertEquals(inte, 500);
    }
    @IsTest static void statusCodenull() {
        SYS_ApiResponse.error = null;
        integer inte = SYS_ApiResponse.statusCode;
        System.debug('>>>>' + inte);
        System.assertEquals(inte, 200);
    }

    @IsTest static void failureDmlException() {
        SYS_ApiResponse.error = new DmlException();
        SYS_ExceptionHandler response = new SYS_ExceptionHandler('', '');
        response.errorCode = 'BAD_REQUEST';
        response.type = 'Dml Error';
        SYS_ApiResponse.failureResponse();
        System.assertEquals(response.errorCode, 'BAD_REQUEST');
    }
    @IsTest static void failureCalloutException() {
        SYS_ApiResponse.error = new CalloutException();
        SYS_ExceptionHandler response = new SYS_ExceptionHandler('', '');
        response.errorCode = 'BAD_REQUEST';
        response.type = 'Dml Error';
        SYS_ApiResponse.failureResponse();
        System.assertEquals(response.errorCode, 'BAD_REQUEST');
    }
    @IsTest static void failureAsyncException() {
        SYS_ApiResponse.error = new AsyncException();
        SYS_ExceptionHandler response = new SYS_ExceptionHandler('', '');
        response.errorCode = 'BAD_REQUEST';
        response.type = 'Dml Error';
        SYS_ApiResponse.failureResponse();
        System.assertEquals(response.errorCode, 'BAD_REQUEST');
    }
    @IsTest static void failureJSONException() {
        SYS_ApiResponse.error = new JSONException();
        SYS_ExceptionHandler response = new SYS_ExceptionHandler('', '');
        response.errorCode = 'BAD_REQUEST';
        response.type = 'Dml Error';
        SYS_ApiResponse.failureResponse();
        System.assertEquals(response.errorCode, 'BAD_REQUEST');
    }
    @IsTest static void failureListException() {
        SYS_ApiResponse.error = new ListException();
        SYS_ExceptionHandler response = new SYS_ExceptionHandler('', '');
        response.errorCode = 'BAD_REQUEST';
        response.type = 'Dml Error';
        SYS_ApiResponse.failureResponse();
        System.assertEquals(response.errorCode, 'BAD_REQUEST');
    }
    @IsTest static void failureNullPointerException() {
        SYS_ApiResponse.error = new NullPointerException();
        SYS_ExceptionHandler response = new SYS_ExceptionHandler('', '');
        response.errorCode = 'BAD_REQUEST';
        response.type = 'Dml Error';
        SYS_ApiResponse.failureResponse();
        System.assertEquals(response.errorCode, 'BAD_REQUEST');
    }
    @IsTest static void failureStringException() {
        SYS_ApiResponse.error = new StringException();
        SYS_ExceptionHandler response = new SYS_ExceptionHandler('', '');
        response.errorCode = 'BAD_REQUEST';
        response.type = 'Dml Error';
        SYS_ApiResponse.failureResponse();
        System.assertEquals(response.errorCode, 'BAD_REQUEST');
    }
    @IsTest static void failureEmailException() {
        SYS_ApiResponse.error = new EmailException();
        SYS_ExceptionHandler response = new SYS_ExceptionHandler('', '');
        response.errorCode = 'BAD_REQUEST';
        response.type = 'Dml Error';
        SYS_ApiResponse.failureResponse();
        System.assertEquals(response.errorCode, 'BAD_REQUEST');
    }
    @IsTest static void successResponseTest() {
        string stg = 'abdTesting';
        SYS_ApiResponse.successResponse(stg);
        System.debug('>>>>>>>>>>' + stg);
        System.assertEquals(stg, 'abdTesting');
    }
}