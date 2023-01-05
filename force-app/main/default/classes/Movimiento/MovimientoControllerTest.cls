@isTest
public with sharing class MovimientoControllerTest {
    @isTest
    public static void deberiaObtenerUnObjetoMovimientoCompleto(){
        String respuestaEsperada ='{"accuracy":100,"effect_chance":100,"effect_entries":[{"effect":"Inflicts regular damage.","language":{"name":"en","url":"https://pokeapi.co/api/v2/language/9/"},"short_effect":"Inflicts regular damage with no additional effect."}],"id":1,"name":"pound","power":40,"pp":35,"priority":0,"target":{"name":"selected-pokemon","url":"https://pokeapi.co/api/v2/move-target/10/"},"type":{"name":"normal","url":"https://pokeapi.co/api/v2/type/1/"}}';
        SingleRequestMock mock = new SingleRequestMock(
                                                        200,
                                                        'OK',
                                                        respuestaEsperada,
                                                        null
                                                    );
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
            Movimiento__c movimiento=MovimientoController.getMovimiento(1);
        Test.stopTest();
        System.debug(movimiento);
        System.assertEquals(true,movimiento!=null,'El objeto es nulo');
        System.assertEquals('Pound', movimiento.Name, 'El nombre no es el esperado');
        System.assertEquals('Inflicts regular damage with no additional effect.',
         movimiento.Efecto__c,'El efecto no es el esperado');
        System.assertEquals(40, movimiento.Poder__c, 'El poder no es el esperado');
        System.assertEquals(1, movimiento.ExtId__c,'El id externo no es el esperado');
        System.assertEquals(100, movimiento.Punteria__c, 'La punteria no es la esperada');
        System.assertEquals(100, movimiento.Chance_de_Efecto__c,'La chance no es la esperada');
        System.assertEquals('selected-pokemon', movimiento.Objetivo__c,'El objetivo no es el esperado');
        System.assertEquals(0,movimiento.Prioridad__c,'La prioridad no es la esperada');
        System.assertEquals(35,movimiento.Pp__c, 'Los PP no son los esperados');
        System.assertEquals('normal', movimiento.Tipo__c, 'El tipo no es el esperado');
        
    }

    @isTest
    public static void deberiaObtenerUnErrorPorRespuestaIncorrecta(){
        String respuestaEsperada ='Not found';
        String errorRecibido;
        Movimiento__c movimiento;
                SingleRequestMock mock = new SingleRequestMock(
                                                        404,
                                                        'Error',
                                                        respuestaEsperada,
                                                        null
                                                    );
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
            try {
                movimiento=MovimientoController.getMovimiento(1);
            } catch (Exception e) {
                errorRecibido=e.getMessage();
            }
            
        Test.stopTest();
        System.assertEquals('Codigo incorrecto, codigo: 404', errorRecibido,
        'El error recibido no es el esperado');
        System.assertEquals(false,movimiento!=null,'El objeto NO es nulo');
        
    }
    @isTest
    public static void deberiaObtenerUnErrorPorFueraDeRango(){
        String respuestaEsperada ='Not found';
        Movimiento__c movimiento;
        String errorRecibido;
        SingleRequestMock mock = new SingleRequestMock(
                                                404,
                                                'Error',
                                                respuestaEsperada,
                                                null
                                            );
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
            try {
                movimiento=MovimientoController.getMovimiento(900);
            } catch (Exception e) {
                errorRecibido=e.getMessage();
            }    
        
        Test.stopTest();
        System.assertEquals('Fuera de rango', errorRecibido,
                             'El error no es el esperado');
        System.assertEquals(false,movimiento!=null,'El objeto NO es nulo');
        
    }
    @isTest
    public static void deberiaObtenerUnErrorPorDatosIncorrectos(){
        Movimiento__c movimiento=new movimiento__c();
        String respuestaEsperada ='{"accuracy":"prueba","effect_chance":"prueba","effect_entries":[{"effect":"Inflicts regular damage.","language":{"name":"en","url":"https://pokeapi.co/api/v2/language/9/"},"short_effect":"Inflicts regular damage with no additional effect."}],"id":1,"name":"pound","power":40,"pp":35,"priority":0,"target":{"name":"selected-pokemon","url":"https://pokeapi.co/api/v2/move-target/10/"},"type":{"name":"normal","url":"https://pokeapi.co/api/v2/type/1/"}}';
        SingleRequestMock mock = new SingleRequestMock(
                                                        200,
                                                        'OK',
                                                        respuestaEsperada,
                                                        null
                                                    );
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
            movimiento=MovimientoController.getMovimiento(1);
        Test.stopTest();
        System.assertEquals(false,movimiento!=null,'El objeto NO es nulo');
        
    }
    @isTest
    public static void deberiaObtenerTodosLosPokemonsRelacionadosAlMovimiento(){
        Movimiento__c movimiento=new Movimiento__c(Name='SuperDuper Move');
        insert movimiento;
        List<Pokemon__c> lista= new List<Pokemon__c>();
        for (Integer i = 0; i < 3; i++) {
            lista.add(new Pokemon__c(Name='prueba '+i,Slot1__c=movimiento.id));
        }
        insert lista;

        Test.startTest();
        List<Pokemon__c> busqueda=MovimientoController.GetPokemonsRelacionados(movimiento.id);
        Test.stopTest();

        System.assertEquals(3, busqueda.size(), 'La cantidad no es la esperada');


    }
}