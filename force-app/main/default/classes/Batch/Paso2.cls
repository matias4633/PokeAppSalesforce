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
                Movimiento__c nuevoMovimiento=getMovimiento(i);
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

    public Movimiento__c getMovimiento(Integer n){
        if(n<1 || n>826){
            throw new CalloutException('Fuera de rango');
        }
        //Llamado a la api
        Movimiento__c nuevoMovimiento = new  Movimiento__c();
        Http http = new Http(); 
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://pokeapi.co/api/v2/move/'+n);
        request.setMethod('GET');
        request.setHeader('Accept', 'application/json');
        HttpResponse response = http.send(request);
        if(response.getStatusCode() != 200){
            System.debug('Respuesta incorrecta '+ response.getStatusCode() );
            throw new CalloutException('Codigo incorrecto, codigo: '+ response.getStatusCode());
        }
        //Tratamiento de los datos
        Map<String,Object> movimiento;
        try {
            movimiento=(Map<String,Object>)JSON.deserializeUntyped(response.getBody());
        } catch (Exception e) {
            System.debug('Error en el JSON');
            return null;
        }
        try {
            
            nuevoMovimiento.ExtId__c=(Integer)movimiento.get('id');
            nuevoMovimiento.Name=((String)movimiento.get('name')).capitalize();
            nuevoMovimiento.Punteria__c=(Integer)movimiento.get('accuracy');
            nuevoMovimiento.Chance_de_Efecto__c=(Integer)movimiento.get('effect_chance');
            nuevoMovimiento.Objetivo__c=(String)((Map<String,Object>)movimiento.get('target')).get('name');
            nuevoMovimiento.Prioridad__c=(Integer)movimiento.get('priority');
            //Primero verifico que el idioma sea el pedidio, luego tomo el short effect
            List<Object> effect_entries=(List<Object>)movimiento.get('effect_entries');

            for(Integer i=0; i<effect_entries.size();i++){
                Map<String,Object> elemento=(Map<String,Object>)effect_entries[i];
                Map<String,Object> language=(Map<String,Object>)elemento.get('language');

                if((String)language.get('name')=='en'){
                    nuevoMovimiento.Efecto__c=(String)elemento.get('short_effect');
                }
            }
            nuevoMovimiento.Poder__c=(Integer)movimiento.get('power');
            nuevoMovimiento.Pp__c=(Integer)movimiento.get('pp');
            nuevoMovimiento.Tipo__c=(String)((Map<String,Object>)movimiento.get('type')).get('name');
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new CalloutException('Datos Incorrectos');
        }
    System.debug(nuevoMovimiento);
    return NuevoMovimiento;
    }
}