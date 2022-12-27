global class PokemonBatch implements Database.Batchable<Integer>, Database.Stateful, Database.AllowsCallouts {
   
    global Iterable<Integer> start(Database.BatchableContext bc) {
        List<Integer> iteraciones=new List<Integer>();
        for (Integer i = 0; i <=898; i++) {
            iteraciones.add(i);
        }
        return iteraciones;
    }
    global void execute(Database.BatchableContext BC , List<Integer> lista){
        try {
            PokemonController controlador=new PokemonController();
            controlador.insertPokemon(lista[0]);
        } catch (Exception e) {
            System.debug('Hugo un error en este Json. External ID : ' + lista[0] );
        }
    }
    global void finish(Database.BatchableContext BC){
       
    }
}