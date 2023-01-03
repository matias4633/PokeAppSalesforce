@isTest
public with sharing class PokemonBatchTest {
    @isTest
    public static void deberiaObtenerUnPokemonJuntoAsusHabilidadesYMovimientos(){
        
        MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
        multimock.setStaticResource(
            'https://pokeapi.co/api/v2/pokemon/1', 'respuestaPokemon');
        multimock.setStaticResource(
            'https://pokeapi.co/api/v2/ability/65/', 'respuestaHabilidad');
        multimock.setStaticResource(
            'https://pokeapi.co/api/v2/move/13/', 'respuestaMovimiento1');
        multimock.setStaticResource(
            'https://pokeapi.co/api/v2/move/14/', 'respuestaMovimiento2');
        multimock.setStaticResource(
            'https://pokeapi.co/api/v2/move/15/', 'respuestaMovimiento3');
        multimock.setStaticResource(
            'https://pokeapi.co/api/v2/move/20/', 'respuestaMovimiento4');
        
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
        
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, multimock);
        Test.startTest();
             Database.executeBatch(new PokemonBatch(),1);
        Test.stopTest();
        Integer cantPokemon=[SELECT Id FROM Pokemon__c].size();
        Integer cantHabilidad=[SELECT Id FROM Habilidad__c].size();
        Integer cantMovimientos=[SELECT Id FROM Movimiento__c].size();

        System.assertEquals(1, cantPokemon, 'La cantidad de pokemon no es la esperada');
        System.assertEquals(1, cantHabilidad, 'La cantidad de habilidades no es la esperada');
        System.assertEquals(4, cantMovimientos, 'La cantidad de movimientos no es la esperada');
    }

    @isTest
    public static void deberiaObtenerUnErrorPorRespuestaIncorrecta(){
        
        MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
        multimock.setStaticResource(
            'https://pokeapi.co/api/v2/pokemon/1', 'error');
       
        multimock.setStatusCode(404);
        multimock.setHeader('Content-Type', 'application/json');
        
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, multimock);
        Test.startTest();
             Database.executeBatch(new PokemonBatch(),1);
        Test.stopTest();
        Integer cantPokemon=[SELECT Id FROM Pokemon__c].size();
        Integer cantHabilidad=[SELECT Id FROM Habilidad__c].size();
        Integer cantMovimientos=[SELECT Id FROM Movimiento__c].size();

        System.assertEquals(0, cantPokemon, 'La cantidad de pokemon no es la esperada');
        System.assertEquals(0, cantHabilidad, 'La cantidad de habilidades no es la esperada');
        System.assertEquals(0, cantMovimientos, 'La cantidad de movimientos no es la esperada');
    }
}
