trigger PokemonTrigger on Pokemon__c (before insert) {
    Map<Decimal,String> mapaHabilidades=new Map<Decimal,String>();
    Map<Decimal,String> mapaMovimientos=new Map<Decimal,String>();

    for(Habilidad__c habilidad: [SELECT ExtId__c,Id FROM Habilidad__c]){
        this.mapaHabilidades.put(habilidad.ExtId__c,habilidad.Id);
    }
    System.debug(mapaHabilidades);

    for(Movimiento__c movimiento: [SELECT ExtId__c,Id FROM Movimiento__c]){
        this.mapaMovimientos.put(movimiento.ExtId__c,movimiento.Id);
    }
    System.debug(mapaMovimientos);
    
    if(Trigger.isInsert){
        if(Trigger.isBefore){
            for (Pokemon__c pokemon : Trigger.new) {
                if(!String.isEmpty(pokemon.RelacionesId__c)){
                    Map<String,Object> relacion=(Map<String,Object>)JSON.deserializeUntyped(pokemon.RelacionesId__c);
                    System.debug('Imprimo ralcion desde el trigger : '+relacion);
                    for (Object ExtId : (List<Object>)relacion.get('habilidades')) {
                        if(String.isEmpty(pokemon.Habilidad__c)){
                            pokemon.Habilidad__c=mapaHabilidades.get((Integer)ExtId);
                        }
                    
                     }
                    try {
                        List<Object> movimientos=(List<Object>)relacion.get('movimientos');
                        pokemon.Slot1__c=mapaMovimientos.get((Integer)movimientos[0]);
                        pokemon.Slot2__c=mapaMovimientos.get((Integer)movimientos[1]);
                        pokemon.Slot3__c=mapaMovimientos.get((Integer)movimientos[2]);
                        pokemon.Slot4__c=mapaMovimientos.get((Integer)movimientos[3]);
                    } catch (Exception e) {
                        System.debug('Hubo menos que 4 movimientos desde la api.');
                    }
                }
                
            }
        }
    }
}

/* insert (PokemonController.getPokemon(1)); */