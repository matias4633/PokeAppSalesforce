@isTest
public with sharing class PokemonControllerTest {
    /* public static String respuestaPokemon='{"abilities":[{"ability":{"name":"overgrow","url":"https://pokeapi.co/api/v2/ability/65/"},"is_hidden":false,"slot":1},{"ability":{"name":"chlorophyll","url":"https://pokeapi.co/api/v2/ability/34/"},"is_hidden":true,"slot":3}],"height":7,"id":1,"moves":[{"move":{"name":"razor-wind","url":"https://pokeapi.co/api/v2/move/13/"}},{"move":{"name":"swords-dance","url":"https://pokeapi.co/api/v2/move/14/"}},{"move":{"name":"cut","url":"https://pokeapi.co/api/v2/move/15/"}},{"move":{"name":"bind","url":"https://pokeapi.co/api/v2/move/20/"}}],"name":"bulbasaur","order":1,"sprites":{"front_default":"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png"},"stats":[{"base_stat":45,"effort":0,"stat":{"name":"hp","url":"https://pokeapi.co/api/v2/stat/1/"}},{"base_stat":49,"effort":0,"stat":{"name":"attack","url":"https://pokeapi.co/api/v2/stat/2/"}},{"base_stat":49,"effort":0,"stat":{"name":"defense","url":"https://pokeapi.co/api/v2/stat/3/"}},{"base_stat":65,"effort":1,"stat":{"name":"special-attack","url":"https://pokeapi.co/api/v2/stat/4/"}},{"base_stat":65,"effort":0,"stat":{"name":"special-defense","url":"https://pokeapi.co/api/v2/stat/5/"}},{"base_stat":45,"effort":0,"stat":{"name":"speed","url":"https://pokeapi.co/api/v2/stat/6/"}}],"types":[{"slot":1,"type":{"name":"grass","url":"https://pokeapi.co/api/v2/type/12/"}},{"slot":2,"type":{"name":"poison","url":"https://pokeapi.co/api/v2/type/4/"}}],"weight":69}';
    public static String respuestaHabilidad ='{"effect_entries":[{"effect":"","language":{"name":"de","url":"https://pokeapi.co/api/v2/language/6/"},"short_effect":""},{"effect":"","language":{"name":"en","url":"https://pokeapi.co/api/v2/language/9/"},"short_effect":"Has a 30% chance of infatuating attacking Pokémon on contact."}],"id":"papas","name":"cute-charm"}';
    public static String respuestaMovimiento1 ='{"accuracy":"prueba","effect_chance":100,"effect_entries":[{"effect":"Inflicts regular damage.","language":{"name":"en","url":"https://pokeapi.co/api/v2/language/9/"},"short_effect":"Inflicts regular damage with no additional effect."}],"id":1,"name":"mov1","power":40,"pp":35,"priority":0,"target":{"name":"selected-pokemon","url":"https://pokeapi.co/api/v2/move-target/10/"},"type":{"name":"normal","url":"https://pokeapi.co/api/v2/type/1/"}}';
    public static String respuestaMovimiento2 ='{"accuracy":"prueba","effect_chance":100,"effect_entries":[{"effect":"Inflicts regular damage.","language":{"name":"en","url":"https://pokeapi.co/api/v2/language/9/"},"short_effect":"Inflicts regular damage with no additional effect."}],"id":1,"name":"mov2","power":40,"pp":35,"priority":0,"target":{"name":"selected-pokemon","url":"https://pokeapi.co/api/v2/move-target/10/"},"type":{"name":"normal","url":"https://pokeapi.co/api/v2/type/1/"}}';
    public static String respuestaMovimiento3 ='{"accuracy":"prueba","effect_chance":100,"effect_entries":[{"effect":"Inflicts regular damage.","language":{"name":"en","url":"https://pokeapi.co/api/v2/language/9/"},"short_effect":"Inflicts regular damage with no additional effect."}],"id":1,"name":"mov3","power":40,"pp":35,"priority":0,"target":{"name":"selected-pokemon","url":"https://pokeapi.co/api/v2/move-target/10/"},"type":{"name":"normal","url":"https://pokeapi.co/api/v2/type/1/"}}';
    public static String respuestaMovimiento4 ='{"accuracy":"prueba","effect_chance":100,"effect_entries":[{"effect":"Inflicts regular damage.","language":{"name":"en","url":"https://pokeapi.co/api/v2/language/9/"},"short_effect":"Inflicts regular damage with no additional effect."}],"id":1,"name":"mov4","power":40,"pp":35,"priority":0,"target":{"name":"selected-pokemon","url":"https://pokeapi.co/api/v2/move-target/10/"},"type":{"name":"normal","url":"https://pokeapi.co/api/v2/type/1/"}}';
        */ 
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
}
