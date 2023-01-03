public with sharing class HabilidadController {
   public static Habilidad__c getHabilidad(String url){
    List<String> cortado=url.split('/');
    Integer n=Integer.valueOf(cortado[cortado.size()-1]);
    if(n<1 || n>267){
            try {
                throw new CalloutException('Fuera de rango');
            } catch (CalloutException e) {
                System.debug(e.getMessage());
                return null;
            }
        }

        Habilidad__c NuevaHabilidad=new Habilidad__c();
        Http http = new Http(); 
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod('GET');
        request.setHeader('Accept', 'application/json');
        HttpResponse response = http.send(request);
        if(response.getStatusCode() != 200){
            System.debug('Respuesta incorrecta '+ response.getStatusCode() );
            try {
                throw new CalloutException('Codigo incorrecto, codigo: '+ response.getStatusCode());
            } catch (CalloutException e) {
                System.debug(e.getMessage());
                return null;
            }
            
        }
        
       
        try {
            HabilidadJson2Apex habilidad=HabilidadJson2Apex.parse(response.getBody());
            NuevaHabilidad.Name=habilidad.name.capitalize();
            NuevaHabilidad.ExtId__c=habilidad.id;
            for(Integer i=0; i<habilidad.effect_entries.size();i++){
                if(habilidad.effect_entries[i].language.name=='en'){
                    NuevaHabilidad.Efecto__c=habilidad.effect_entries[i].short_effect;
                }
            }
        } catch (Exception e) {
            System.debug(e.getMessage());
            return null;
        }
    return NuevaHabilidad;
   }
}
                  