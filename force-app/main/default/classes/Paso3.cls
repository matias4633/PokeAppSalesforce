global class Paso3 implements Database.Batchable<Integer>, Database.Stateful, Database.AllowsCallouts {
    Integer cantidad;
    List<Pokemon__c> pokemons=new List<Pokemon__c>();
    public Paso3(){
        if(!Test.isRunningTest()){
            this.cantidad=898;
        }else{
            this.cantidad=1;
        }
    }
    
    global Iterable<Integer> start(Database.BatchableContext bc) {
        List<Integer> iteraciones=new List<Integer>();
        for (Integer i = 1; i <=this.cantidad; i++) { //hasta 898
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
        try {
            insert pokemons;
        } catch (Exception e) {
            System.debug('Ocurrio un error en Dml: '+e.getMessage());
        }
       
    }
}

/* Pokemon__c poke= PokemonController.getPokemon(521);
System.debug(poke!=null);
System.debug(poke); 
if(poke!=null){
    insert poke;
} */
