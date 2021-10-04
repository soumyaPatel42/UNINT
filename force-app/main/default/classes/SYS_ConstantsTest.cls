@Istest
public class SYS_ConstantsTest {

    @isTest
    static void MAX_DATA_FIELDSTest(){
        integer MAX_DATA;
      MAX_DATA= SYS_Constants.MAX_DATA_FIELDS; 
        system.assertEquals(MAX_DATA,10 );
    } 
    @isTest
    static void TEXT_AREA_MAX_SIZETest(){
        integer TEXT_AREA_MAX;
      TEXT_AREA_MAX= SYS_Constants.TEXT_AREA_MAX_SIZE; 
        system.assertEquals(TEXT_AREA_MAX,131072 );
    }
}