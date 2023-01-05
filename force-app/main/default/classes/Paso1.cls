global class Paso1 implements Database.Batchable<Integer>, Database.Stateful, Database.AllowsCallouts {
    List<Habilidad__c> habilidades=new List<Habilidad__c>();
    global Iterable<Integer> start(Database.BatchableContext bc) {
        List<Integer> iteraciones=new List<Integer>();
        for (Integer i = 1; i <=1; i++) { //hasta 267 Ejecutar este batch con size de 10.
            iteraciones.add(i);
        }
        return iteraciones;
    }
    global void execute(Database.BatchableContext BC , List<Integer> lista){
        for (Integer i : lista) {
            try {
                Habilidad__c nuevaHabilidad=HabilidadController.getHabilidad(i);
                if(nuevaHabilidad!=null){
                    habilidades.add(nuevaHabilidad);
                }
            } catch (Exception e) {
                System.debug('Hugo un error en la habilidad de idExt: '+ i);
            }
            
        }
    }
    global void finish(Database.BatchableContext BC){
        //System.debug(habilidades);
        upsert habilidades Name;
        if(!Test.isRunningTest()){
            Database.executeBatch(new Paso2(),10);
        }
        
    }
}