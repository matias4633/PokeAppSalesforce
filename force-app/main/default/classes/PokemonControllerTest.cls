@isTest
public with sharing class PokemonControllerTest {
    
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
             PokemonController control=new PokemonController();
             control.insertPokemon(1);
        Test.stopTest();
        Integer cantPokemon=[SELECT Id FROM Pokemon__c].size();
        Integer cantHabilidad=[SELECT Id FROM Habilidad__c].size();
        Integer cantMovimientos=[SELECT Id FROM Movimiento__c].size();

        System.assertEquals(1, cantPokemon, 'La cantidad de pokemon no es la esperada');
        System.assertEquals(1, cantHabilidad, 'La cantidad de habilidades no es la esperada');
        System.assertEquals(4, cantMovimientos, 'La cantidad de movimientos no es la esperada');
    }

    @isTest
    public static void deberiaObtenerDeLaBaseDeDatosTodosLosPokemonsEnLaBusqueda(){
        List<Pokemon__c> listaInsertada=new List<Pokemon__c>();
        for (Integer i = 0; i < 5; i++) {
            listaInsertada.add(New Pokemon__c(Name='prueba '+i));
        }
        insert listaInsertada;

        Test.startTest();
        List<Pokemon__c> lista=PokemonController.search('','','','');
        Test.stopTest();

        System.assertEquals(5, lista.size(),'La cantidad de no es la esperada');
    }

    @isTest
    public static void deberiaObtenerDeLaBaseDeDatosSolo2Pokemons(){
        List<Pokemon__c> listaInsertada=new List<Pokemon__c>();
        for (Integer i = 0; i < 2; i++) {
            listaInsertada.add(New Pokemon__c(Name='prueba '+i,ExtId__c=i+1, Tipos__c='Fire'));
        }

        for (Integer i = 0; i < 3; i++) {
            listaInsertada.add(New Pokemon__c(Name='prueba '+i,ExtId__c=i+200, Tipos__c='Bug'));
        }
        insert listaInsertada;

        Test.startTest();
        List<Pokemon__c> lista=PokemonController.search('prueba','Fire','1','');
        Test.stopTest();

        System.assertEquals(2, lista.size(),'La cantidad de no es la esperada');
    }

}
