global class MovimientoBatch implements Database.Batchable<Integer>, Database.Stateful, Database.AllowsCallouts {
    List<Movimiento__c> movimientos=new List<Movimiento__c>();
    global Iterable<Integer> start(Database.BatchableContext bc) {
        List<Integer> iteraciones=new List<Integer>();
        for (Integer i = 1; i <=826; i++) { //hasta 826 Ejecutar este batch con size de 10.
            iteraciones.add(i);
        }
        return iteraciones;
    }
    global void execute(Database.BatchableContext BC , List<Integer> lista){
        for (Integer i : lista) {
            try {
                Movimiento__c nuevoMovimiento=MovimientoController.getMovimiento(i);
                if(nuevoMovimiento!=null){
                    movimientos.add(nuevoMovimiento);
                }
            } catch (Exception e) {
                System.debug('Hugo un error en el movimiento de idExt: '+ i);
            }
            
        }
    }
    global void finish(Database.BatchableContext BC){
        //System.debug(movimientos);
        upsert movimientos Name;
        Database.executeBatch(new PokemonBatch(),10);
    }
}