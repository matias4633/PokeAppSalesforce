public with sharing class MovimientoController {
    public static Movimiento__c getMovimiento(Integer n){
        if(n<1 || n>826){
            try {
                throw new CalloutException('Fuera de rango');
            } catch (CalloutException e) {
                return null;
            }
        }

        Movimiento__c nuevoMovimiento = new  Movimiento__c();
        Http http = new Http(); 
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://pokeapi.co/api/v2/move/'+n);
        request.setMethod('GET');
        request.setHeader('Accept', 'application/json');
        HttpResponse response = http.send(request);
        if(response.getStatusCode() != 200){
            System.debug('Respuesta incorrecta '+ response.getStatusCode() );
            try {
                throw new CalloutException('Codigo incorrecto, codigo: '+ response.getStatusCode());
            } catch (CalloutException e) {
                //return null;
            }
        }
        
        MovimientoJson2Apex movimiento=MovimientoJson2Apex.parse(response.getBody());

        try {
            nuevoMovimiento.ExtId__c=movimiento.id;
            nuevoMovimiento.Name=movimiento.name.capitalize();
            nuevoMovimiento.Punteria__c=movimiento.accuracy;
            nuevoMovimiento.Chance_de_Efecto__c=movimiento.effect_chance.toString();
            nuevoMovimiento.Objetivo__c=movimiento.target.name;
            nuevoMovimiento.Prioridad__c=movimiento.priority;
            for(Integer i=0; i<movimiento.effect_entries.size();i++){
                if(movimiento.effect_entries[i].language.name=='en'){
                    nuevoMovimiento.Efecto__c=movimiento.effect_entries[i].short_effect;
                }
            }
            nuevoMovimiento.Poder__c=movimiento.power;
            nuevoMovimiento.Pp__c=movimiento.pp;
        // nuevoMovimiento.Tipo__c.=movimiento.type.name;//formato seria 'A;B;C' en string
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
        
        System.debug(nuevoMovimiento);
    return NuevoMovimiento;
   }
}