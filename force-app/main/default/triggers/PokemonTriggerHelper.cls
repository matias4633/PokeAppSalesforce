public with sharing class PokemonTriggerHelper {
    /* Creo mapas de habilidades y movimientos para poder usarlo para todos
    los pokemons que ingresen en un dml de manera masiva, esto me evita tener que crear los mismos mapas
    o consultas SOQL por cada pokemon si hiciera el proceso en mi clase PokemonController. */

    public static void asignarRelacion(List<Pokemon__c> lista){
        Map<Decimal,String> mapaHabilidades=new Map<Decimal,String>();
        Map<Decimal,String> mapaMovimientos=new Map<Decimal,String>();
    
        for(Habilidad__c habilidad: [SELECT ExtId__c,Id FROM Habilidad__c]){
            mapaHabilidades.put(habilidad.ExtId__c,habilidad.Id);
        }
        for(Movimiento__c movimiento: [SELECT ExtId__c,Id FROM Movimiento__c]){
            mapaMovimientos.put(movimiento.ExtId__c,movimiento.Id);
        }


        for (Pokemon__c pokemon : lista) {
            Map<String,Object> relacion=(Map<String,Object>)JSON.deserializeUntyped(pokemon.RelacionesId__c);
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
                System.debug('Hubo menos que 4 movimientos');
            }
        }
    }
}