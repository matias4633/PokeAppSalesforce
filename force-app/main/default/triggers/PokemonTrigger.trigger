trigger PokemonTrigger on Pokemon__c (before insert) {

    if(Trigger.isBefore){
        if(Trigger.isInsert){
            List<Pokemon__c> lista=new List<Pokemon__c>();
            for (Pokemon__c pokemon : Trigger.new) {
                if(!String.isEmpty(pokemon.RelacionesId__c)){
                    lista.add(pokemon);
                }
                
            }
            PokemonTriggerHelper.asignarRelacion(lista);
        }
    }
}

/* insert (PokemonController.getPokemon(1)); */