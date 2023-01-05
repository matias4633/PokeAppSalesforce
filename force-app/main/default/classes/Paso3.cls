global class Paso3 implements Database.Batchable<Integer>, Database.Stateful, Database.AllowsCallouts {
    List<Pokemon__c> pokemons=new List<Pokemon__c>();
    global Iterable<Integer> start(Database.BatchableContext bc) {
        List<Integer> iteraciones=new List<Integer>();
        for (Integer i = 1; i <=1; i++) { //hasta 898
            iteraciones.add(i);
        }
        return iteraciones;
    }
    global void execute(Database.BatchableContext BC , List<Integer> lista){
        for (Integer i : lista) {
            try {
                Pokemon__c nuevoPokemon=PokemonController.getPokemon(i);
                
                if(nuevoPokemon!=null){
                    pokemons.add(nuevoPokemon);
                }
                
            } catch (Exception e) {
                System.debug('Hugo un error el Pokemon de idExt: '+ i);
            }
        }
        
    }
    global void finish(Database.BatchableContext BC){
       insert pokemons;
    }
}