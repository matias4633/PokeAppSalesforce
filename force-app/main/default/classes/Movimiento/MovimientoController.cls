public with sharing class MovimientoController {
    public static Movimiento__c getMovimiento(Integer n){
        if(n<1 || n>826){
            throw new CalloutException('Fuera de rango');
        }
        //Llamado a la api
        Movimiento__c nuevoMovimiento = new  Movimiento__c();
        MovimientoJson2Apex movimiento;
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
        try {
            movimiento=MovimientoJson2Apex.parse(response.getBody());
        } catch (Exception e) {
            System.debug('Datos Incorrectos');
            return null;
        }
        try {
            
            nuevoMovimiento.ExtId__c=movimiento.id;
            nuevoMovimiento.Name=movimiento.name.capitalize();
            nuevoMovimiento.Punteria__c=movimiento.accuracy;
            nuevoMovimiento.Chance_de_Efecto__c=movimiento.effect_chance;
            nuevoMovimiento.Objetivo__c=movimiento.target.name;
            nuevoMovimiento.Prioridad__c=movimiento.priority;
            //Primero verifico que el idioma sea el pedidio, luego tomo el short effect
            for(Integer i=0; i<movimiento.effect_entries.size();i++){
                if(movimiento.effect_entries[i].language.name=='en'){
                    nuevoMovimiento.Efecto__c=movimiento.effect_entries[i].short_effect;
                }
            }
            nuevoMovimiento.Poder__c=movimiento.power;
            nuevoMovimiento.Pp__c=movimiento.pp;
            nuevoMovimiento.Tipo__c=movimiento.type.name;
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
    return NuevoMovimiento;
   }
   
}