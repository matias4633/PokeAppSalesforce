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
        System.assertEquals('Cute-charm', habilidad.Name,
         'El valor no es el esperado es:' +habilidad.Name);
         System.assertEquals(56, habilidad.ExtId__c,
         'El valor no es el esperado es:' +habilidad.ExtId__c);
         System.assertEquals('Has a 30% chance of infatuating attacking Pokémon on contact.',
          habilidad.Efecto__c,'El valor no es el esperado es:' +habilidad.Efecto__c);

    }

    @isTest
    public static void deberiaObtenerUnErrorPorCodigoIncorrecto(){
        Habilidad__c habilidad;
        String errorRecibido;
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
               errorRecibido=e.getMessage();
            }
            
        Test.stopTest();
        System.assertEquals('Codigo incorrecto, codigo: 404', errorRecibido,
         'La excepcion no es la esperada es: '+errorRecibido);
        System.assertEquals(null, habilidad,'El objeto deberia ser nulo');
        
    }

    @isTest  
    public static void deberiaObtenerUnErrorFueraDeRango(){
        Habilidad__c habilidad;
        String errorRecibido;
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
            habilidad=HabilidadController.getHabilidad(900);
        } catch (Exception e) {
            errorRecibido=e.getMessage();
        }
        
        Test.stopTest();
        System.assertEquals('Fuera de rango', errorRecibido, 'El error no es el esperado');
        System.assertEquals(null, habilidad,'El objeto deberia ser nulo');
    }

    @isTest //Pongo el id Como si fuera un String, cuando debe ser un numero
    public static void deberiaObtenerUnErrorPorTiposDeDatosIncorrectos(){
        Habilidad__c habilidad=new habilidad__c();
        String respuestaEsperada ='{"effect_entries":[{"effect":"","language":{"name":"de","url":"https://pokeapi.co/api/v2/language/6/"},"short_effect":""},{"effect":"","language":{"name":"en","url":"https://pokeapi.co/api/v2/language/9/"},"short_effect":"Has a 30% chance of infatuating attacking Pokémon on contact."}],"id":"papas","name":"cute-charm"}';
        SingleRequestMock mock = new SingleRequestMock(
                                                        200,
                                                        'OK',
                                                        respuestaEsperada,
                                                        null
                                                    );
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        try {
            habilidad=HabilidadController.getHabilidad(56);
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
        Test.stopTest();
        System.assertEquals(null, habilidad, 'El objeto no es nulo');
    }
}