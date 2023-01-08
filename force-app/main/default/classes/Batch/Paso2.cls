global class Paso2 implements Database.Batchable<Integer>, Database.Stateful, Database.AllowsCallouts {
    Integer cantidad;
    List<Movimiento__c> movimientos=new List<Movimiento__c>();
    public Paso2(){
        if(!Test.isRunningTest()){
            this.cantidad=826;
        }else{
            this.cantidad=1;
        }
    }
    global Iterable<Integer> start(Database.BatchableContext bc) {
        List<Integer> iteraciones=new List<Integer>();
        for (Integer i = 1; i <=this.cantidad; i++) { //hasta 826 Ejecutar este batch con size de 10.
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
        try {
            upsert movimientos Name;
        } catch (Exception e) {
            System.debug('Ocurrio un error en Dml: '+e.getMessage());
        }
        
        if(!Test.isRunningTest()){
            Database.executeBatch(new Paso3(),10);
        }
        
    }
}