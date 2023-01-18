/* Este es el Primer Paso, Se ejecuta con un tamaño de 10. 
Este se encarga de insertar todas las habilidades */

/* Comando de ejecucion

        Database.executeBatch(new Paso1(),10);
*/
global class Paso1 implements Database.Batchable<Integer>, Database.Stateful, Database.AllowsCallouts {
    Integer cantidad;
    List<Habilidad__c> habilidades=new List<Habilidad__c>();
    public Paso1(){
        if(!Test.isRunningTest()){
            this.cantidad=267;
        }else{
            this.cantidad=1;
        }
    }
    global Iterable<Integer> start(Database.BatchableContext bc) {
        List<Integer> iteraciones=new List<Integer>();
        for (Integer i = 1; i <=this.cantidad; i++) { //hasta 267 Ejecutar este batch con size de 10.
            iteraciones.add(i);
        }
        return iteraciones;
    }
    global void execute(Database.BatchableContext BC , List<Integer> lista){
        for (Integer i : lista) {
            try {
                Habilidad__c nuevaHabilidad=getHabilidad(i);
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
        try {
            upsert habilidades Name;
        } catch (Exception e) {
            System.debug('Ocurrio un error en Dml: '+e.getMessage());
        }
        
        if(!Test.isRunningTest()){
            Database.executeBatch(new Paso2(),10);
        }
        
    }
    public Habilidad__c getHabilidad(Integer n){
        if(n<1 || n>267){
            throw new CalloutException('Fuera de rango');
        }
        //Llamado a la api
        Habilidad__c NuevaHabilidad=new Habilidad__c();
        Http http = new Http(); 
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://pokeapi.co/api/v2/ability/'+n);
        request.setMethod('GET');
        request.setHeader('Accept', 'application/json');
        HttpResponse response = http.send(request);
        if(response.getStatusCode() != 200){
            System.debug('Respuesta incorrecta '+ response.getStatusCode() );
            throw new CalloutException('Codigo incorrecto, codigo: '+ response.getStatusCode());
        }

        //Tratamiento de los datos
        Map<String,Object> habilidad;
        try {
            habilidad=(Map<String,Object>)JSON.deserializeUntyped(response.getBody());
        } catch (Exception e) {
            System.debug('Hugo un error en el JSON');
            return null;
        }
        try {
            
            NuevaHabilidad.Name=((String)habilidad.get('name')).capitalize();
            NuevaHabilidad.ExtId__c=(Integer)habilidad.get('id');
            
            List<Object> effect_entries=(List<Object>)habilidad.get('effect_entries');

            for(Integer i=0; i<effect_entries.size();i++){
                Map<String,Object> elemento=(Map<String,Object>)effect_entries[i];
                Map<String,Object> language=(Map<String,Object>)elemento.get('language');
                if((String)language.get('name')=='en'){
                    NuevaHabilidad.Efecto__c=(String)elemento.get('short_effect');
                }
            }
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new CalloutException('Datos Incorrectos');
        }
    System.debug(NuevaHabilidad);
    return NuevaHabilidad;
    }
}

/*  List<Pokemon__c> poke=[SELECT Id FROM Pokemon__c];
    List<Habilidad__c> habi=[SELECT Id FROM Habilidad__c];
    List<Movimiento__c> mov=[SELECT Id FROM Movimiento__c];
    delete poke;
    delete habi;
    delete mov;   */

    /* Another DML governor limit is the total number of rows that can be processed by DML operations in a single transaction, 
    which is 10,000. 
    All rows processed by all DML calls in the same transaction count incrementally toward this limit. 
    For example, if you insert 100 contacts and update 50 contacts in the same transaction, 
    your total DML processed rows are 150. You still have 9,850 rows left (10,000 - 150). 
    https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/langCon_apex_dml_examples.htm */

    /* Description	                    Synchronous Limit	Asynchronous Limit
    Total number of SOQL queries issued1	100	                    200 */
/* 
    Database.executeBatch(new Paso3(),10); */