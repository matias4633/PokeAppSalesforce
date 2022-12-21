global class PokemonBatch implements Database.Batchable<Integer>, Database.Stateful, Database.AllowsCallouts {
    Integer i;
    public PokemonBatch(){
        this.i=1;
    }
    global Iterable<Integer> start(Database.BatchableContext bc) {
        
        return new foo();
    }
    global void execute(Database.BatchableContext BC , List<Integer> lista){
        
        PokemonController controlador=new PokemonController();
        controlador.insertPokemon(i);
        i++;
    }
    global void finish(Database.BatchableContext BC){
       
    }
}