@isTest
public with sharing class HabilidadControllerTest {
    @isTest
    public static void deberiaObtenerUnObjetoHablidadCompleto(){
        String respuestaEsperada ='{"effect_entries":[{"effect":"","language":{"name":"de","url":"https://pokeapi.co/api/v2/language/6/"},"short_effect":""},{"effect":"","language":{"name":"en","url":"https://pokeapi.co/api/v2/language/9/"},"short_effect":"Has a 30% chance of infatuating attacking Pokémon on contact."}],"id":56,"name":"cute-charm"}';
        SingleRequestMock mock = new SingleRequestMock(
                                                        200,
                                                        'OK',
                                                        respuestaEsperada,
                                                        null
                                                    );
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
            Habilidad__c habilidad=HabilidadController.getHabilidad(56);
        Test.stopTest();
        System.debug(habilidad);
        System.assertEquals('cute-charm', habilidad.Name,
         'El valor no es el esperado es:' +habilidad.Name);
         System.assertEquals(56, habilidad.ExtId__c,
         'El valor no es el esperado es:' +habilidad.ExtId__c);
         System.assertEquals('Has a 30% chance of infatuating attacking Pokémon on contact.',
          habilidad.Efecto__c,'El valor no es el esperado es:' +habilidad.Efecto__c);

    }

    @isTest
    public static void deberiaObtenerUnErrorYunObjetoNulo(){
        Habilidad__c habilidad;
        String excepcionRecibida;
        String respuestaEsperada ='Not Found';
        SingleRequestMock mock = new SingleRequestMock(
                                                        404,
                                                        'Error',
                                                        respuestaEsperada,
                                                        null
                                                    );
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
            try {
                habilidad=HabilidadController.getHabilidad(56);
            } catch (Exception e) {
                excepcionRecibida=e.getMessage();
            }
            
        Test.stopTest();
        //System.assertEquals('Codigo incorrecto, codigo: 404', excepcionRecibida, 'La excepcion no es la esperada es: '+excepcionRecibida);
        System.assertEquals(null, habilidad,'El objeto deberia ser nulo');
    }

    @isTest  
    public static void deberiaObtenerUnErrorFueraDeRangoYunObjetoNulo(){
        Habilidad__c habilidad;
        String excepcionRecibida;
        String respuestaEsperada ='Not Found';
        SingleRequestMock mock = new SingleRequestMock(
                                                        404,
                                                        'Error',
                                                        respuestaEsperada,
                                                        null
                                                    );
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
            try {
                habilidad=HabilidadController.getHabilidad(56);
            } catch (CalloutException e) {
                excepcionRecibida=e.getMessage();
            }
        Test.stopTest();
        System.assertEquals(null, habilidad,'El objeto deberia ser nulo');
    }
}