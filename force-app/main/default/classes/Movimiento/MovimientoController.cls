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
   //Metodo usado en LWC de Record Page Movimiento.
   @AuraEnabled(cacheable=true)
   public static List<Pokemon__c> GetPokemonsRelacionados(String identificador){
    return [SELECT
                Id,
                Name,
                Altura__c,
                Ataque__c,
                Defensa__c,
                ExtId__c,
                Imagen__c,
                Vida__c,
                Velocidad__c,
                Tipos__c,
                Slot1__r.Name,
                Slot1__r.ExtId__c,
                Slot2__r.Name,
                Slot2__r.ExtId__c
                FROM Pokemon__c 
                WHERE Slot1__c =:identificador
                OR Slot2__c =:identificador 
                OR Slot3__c =:identificador 
                OR Slot4__c =:identificador
                OR Habilidad__c=:identificador
            ];
   }
}