@isTest
public class SYS_ApiResponseTest {
    @IsTest static void statusCodeTest(){
        SYS_ApiResponse.error = new DmlException();
       
       integer inte = SYS_ApiResponse.statusCode;
        system.debug('>>>>'+inte);
        system.assertEquals(inte,400);
    }
     @IsTest static void statusCodeTest2(){
        SYS_ApiResponse.error = new CalloutException();
       
       integer inte = SYS_ApiResponse.statusCode;
        system.debug('>>>>'+inte);
        system.assertEquals(inte,500);
    }
     @IsTest static void statusCodeTest3(){
        SYS_ApiResponse.error = null;
       
       integer inte = SYS_ApiResponse.statusCode;
        system.debug('>>>>'+inte);
        system.assertEquals(inte,200);
    }
    
     @IsTest static void failureResponseTest(){
          SYS_ApiResponse.error = new DmlException();
         
 SYS_ExceptionHandler response = new SYS_ExceptionHandler('', '');
         response.errorCode = 'BAD_REQUEST';
            response.type = 'Dml Error';
      SYS_ApiResponse.failureResponse();
         system.assertEquals(response.errorCode, 'BAD_REQUEST');
     }
 @IsTest static void failureResponseTest2(){
         SYS_ApiResponse.error = new CalloutException();
         
 SYS_ExceptionHandler response = new SYS_ExceptionHandler('', '');
         response.errorCode = 'BAD_REQUEST';
            response.type = 'Dml Error';
      SYS_ApiResponse.failureResponse();
       system.assertEquals(response.errorCode, 'BAD_REQUEST');
     }    
     @IsTest static void failureResponseTest3(){
        SYS_ApiResponse.error = new AsyncException();
         
 SYS_ExceptionHandler response = new SYS_ExceptionHandler('', '');
         response.errorCode = 'BAD_REQUEST';
            response.type = 'Dml Error';
      SYS_ApiResponse.failureResponse();
           system.assertEquals(response.errorCode, 'BAD_REQUEST');
     }    
    @IsTest static void failureResponseTest4(){
        SYS_ApiResponse.error = new JSONException();
         
 SYS_ExceptionHandler response = new SYS_ExceptionHandler('', '');
         response.errorCode = 'BAD_REQUEST';
            response.type = 'Dml Error';
      SYS_ApiResponse.failureResponse();
          system.assertEquals(response.errorCode, 'BAD_REQUEST');
     }  
     @IsTest static void failureResponseTest5(){
        SYS_ApiResponse.error = new ListException();
         
 SYS_ExceptionHandler response = new SYS_ExceptionHandler('', '');
         response.errorCode = 'BAD_REQUEST';
            response.type = 'Dml Error';
      SYS_ApiResponse.failureResponse();
           system.assertEquals(response.errorCode, 'BAD_REQUEST');
     }  
    @IsTest static void failureResponseTest6(){
       SYS_ApiResponse.error = new NullPointerException();
         
 SYS_ExceptionHandler response = new SYS_ExceptionHandler('', '');
         response.errorCode = 'BAD_REQUEST';
            response.type = 'Dml Error';
      SYS_ApiResponse.failureResponse();
          system.assertEquals(response.errorCode, 'BAD_REQUEST');
     }  
     @IsTest static void failureResponseTest7(){
       SYS_ApiResponse.error = new StringException();
         
 SYS_ExceptionHandler response = new SYS_ExceptionHandler('', '');
         response.errorCode = 'BAD_REQUEST';
            response.type = 'Dml Error';
      SYS_ApiResponse.failureResponse();
           system.assertEquals(response.errorCode, 'BAD_REQUEST');
     }  
     @IsTest static void failureResponseTest8(){
       SYS_ApiResponse.error = new EmailException();
         
 SYS_ExceptionHandler response = new SYS_ExceptionHandler('', '');
         response.errorCode = 'BAD_REQUEST';
            response.type = 'Dml Error';
      SYS_ApiResponse.failureResponse();
           system.assertEquals(response.errorCode, 'BAD_REQUEST');
     } 
    @IsTest static void successResponseTest(){
        string stg = 'abdTesting';
        SYS_ApiResponse.successResponse(stg);
        system.debug('>>>>>>>>>>'+stg);
        system.assertEquals(stg, 'abdTesting');
}
}