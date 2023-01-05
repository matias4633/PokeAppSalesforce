@isTest
public with sharing class PokemonControllerTest {
    
    @isTest
    public static void deberiaObtenerUnObjetoPokemonCompleto(){
        String respuesta='{"abilities":[{"ability":{"name":"overgrow","url":"https://pokeapi.co/api/v2/ability/65/"},"is_hidden":false,"slot":1},{"ability":{"name":"chlorophyll","url":"https://pokeapi.co/api/v2/ability/34/"},"is_hidden":true,"slot":3}],"height":7,"id":1,"moves":[{"move":{"name":"razor-wind","url":"https://pokeapi.co/api/v2/move/13/"}},{"move":{"name":"swords-dance","url":"https://pokeapi.co/api/v2/move/14/"}},{"move":{"name":"cut","url":"https://pokeapi.co/api/v2/move/15/"}},{"move":{"name":"bind","url":"https://pokeapi.co/api/v2/move/20/"}}],"name":"bulbasaur","order":1,"sprites":{"front_default":"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png"},"stats":[{"base_stat":45,"effort":0,"stat":{"name":"hp","url":"https://pokeapi.co/api/v2/stat/1/"}},{"base_stat":49,"effort":0,"stat":{"name":"attack","url":"https://pokeapi.co/api/v2/stat/2/"}},{"base_stat":49,"effort":0,"stat":{"name":"defense","url":"https://pokeapi.co/api/v2/stat/3/"}},{"base_stat":65,"effort":1,"stat":{"name":"special-attack","url":"https://pokeapi.co/api/v2/stat/4/"}},{"base_stat":65,"effort":0,"stat":{"name":"special-defense","url":"https://pokeapi.co/api/v2/stat/5/"}},{"base_stat":45,"effort":0,"stat":{"name":"speed","url":"https://pokeapi.co/api/v2/stat/6/"}}],"types":[{"slot":1,"type":{"name":"grass","url":"https://pokeapi.co/api/v2/type/12/"}},{"slot":2,"type":{"name":"poison","url":"https://pokeapi.co/api/v2/type/4/"}}],"weight":69}';
        SingleRequestMock mock = new SingleRequestMock(
                                                        200,
                                                        'OK',
                                                        respuesta,
                                                        null
                                                    );
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
            Pokemon__c pokemon=PokemonController.getPokemon(1);
        Test.stopTest();
        System.assertEquals(1, pokemon.ExtId__c,'El valor no es el esperado');
        System.assertEquals('Bulbasaur', pokemon.Name,'El valor no es el esperado');
        System.assertEquals(0.7, pokemon.Altura__c,'El valor no es el esperado');
        System.assertEquals(6.9, pokemon.Peso__c,'El valor no es el esperado');
        System.assertEquals('grass;poison', pokemon.Tipos__c,'El valor no es el esperado');
        System.assertEquals(45, pokemon.Vida__c,'El valor no es el esperado');
        System.assertEquals(49, pokemon.Ataque__c,'El valor no es el esperado');
        System.assertEquals(49, pokemon.Defensa__c,'El valor no es el esperado');
        System.assertEquals(45, pokemon.Velocidad__c,'El valor no es el esperado');
        
    }

    @isTest  
    public static void deberiaObtenerUnErrorFueraDeRangoYunObjetoNulo(){
        Pokemon__c pokemon=new Pokemon__c();
        String respuestaEsperada ='Not Found';
        SingleRequestMock mock = new SingleRequestMock(
                                                        404,
                                                        'Error',
                                                        respuestaEsperada,
                                                        null
                                                    );
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        pokemon=PokemonController.getPokemon(900);
        Test.stopTest();
        System.assertEquals(null, pokemon,'El objeto deberia ser nulo');
    }
    @isTest
    public static void deberiaObtenerDeLaBaseDeDatosTodosLosPokemonsEnLaBusqueda(){
        List<Pokemon__c> listaInsertada=new List<Pokemon__c>();
        for (Integer i = 0; i < 5; i++) {
            listaInsertada.add(New Pokemon__c(Name='prueba '+i,ExtId__c=i));
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