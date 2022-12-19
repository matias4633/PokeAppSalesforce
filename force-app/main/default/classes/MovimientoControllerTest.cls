@isTest
public with sharing class MovimientoControllerTest {
    @isTest
    public static void deberiaObtenerUnObjetoMovimientoCompleto(){
        String respuestaEsperada ='{"accuracy":100,"effect_chance":null,"effect_entries":[{"effect":"Inflicts regular damage.","language":{"name":"en","url":"https://pokeapi.co/api/v2/language/9/"},"short_effect":"Inflicts regular damage with no additional effect."}],"id":1,"name":"pound","power":40,"pp":35,"priority":0,"target":{"name":"selected-pokemon","url":"https://pokeapi.co/api/v2/move-target/10/"},"type":{"name":"normal","url":"https://pokeapi.co/api/v2/type/1/"}}';
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
        /* System.assertEquals('cute-charm', habilidad.Name,
         'El valor no es el esperado es:' +habilidad.Name);
         System.assertEquals(56, habilidad.ExtId__c,
         'El valor no es el esperado es:' +habilidad.ExtId__c);
         System.assertEquals('Has a 30% chance of infatuating attacking Pokémon on contact.',
          habilidad.Efecto__c,'El valor no es el esperado es:' +habilidad.Efecto__c);
 */
    }
}
