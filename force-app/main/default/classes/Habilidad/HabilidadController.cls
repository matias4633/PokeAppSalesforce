public with sharing class HabilidadController {
   public static Habilidad__c getHabilidad(Integer n){
        if(n<1 || n>267){
            throw new CalloutException('Fuera de rango');
        }
        //Llamado a la api
        Habilidad__c NuevaHabilidad=new Habilidad__c();
        HabilidadJson2Apex habilidad;
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
        try {
            habilidad=HabilidadJson2Apex.parse(response.getBody());
        } catch (Exception e) {
            System.debug('Datos Incorrectos');
            return null;
        }
        try {
            
            NuevaHabilidad.Name=habilidad.name.capitalize();
            NuevaHabilidad.ExtId__c=habilidad.id;
            for(Integer i=0; i<habilidad.effect_entries.size();i++){
                if(habilidad.effect_entries[i].language.name=='en'){
                    NuevaHabilidad.Efecto__c=habilidad.effect_entries[i].short_effect;
                }
            }
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
    return NuevaHabilidad;
   }
}