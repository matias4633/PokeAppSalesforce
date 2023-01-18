public with sharing class ParseoNativo {
    public static Pokemon__c getPokemon(Integer n){
        List<String> hablidadesUrls=new List<String>();
        List<String> movimientosUrls=new List<String>();

        //Verifico que el parametro este entre lo pedido.
        if(n<1 || n>898){
            throw new CalloutException('Fuera de rango');
        }
       
        //LLamado a la Api
        Pokemon__c nuevoPokemon = new  Pokemon__c();
        Http http = new Http(); 
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://pokeapi.co/api/v2/pokemon/'+n);
        request.setMethod('GET');
        request.setHeader('Accept', 'application/json');
        HttpResponse response = http.send(request);
        if(response.getStatusCode() != 200){
            System.debug('Respuesta incorrecta '+ response.getStatusCode() );
            throw new CalloutException('Codigo incorrecto, codigo: '+ response.getStatusCode());
        }

        Map<String,Object> pokemon;
        try {
           pokemon=(Map<String,Object>)JSON.deserializeUntyped(response.getBody());
        } catch (Exception e) {
            System.debug('Error en el JSON');
            return null;
        }

        try {
            
            nuevoPokemon.ExtId__c=(Integer)pokemon.get('id');
            nuevoPokemon.Name=((String)pokemon.get('name')).capitalize();
            nuevoPokemon.Altura__c=((Integer)pokemon.get('height'))/10.0;
            nuevoPokemon.Peso__c=((Integer)pokemon.get('weight'))/10.0;

            Map<String,Object> sprites=(Map<String,Object>)pokemon.get('sprites');
            Map<String,Object> other=((Map<String,Object>)sprites.get('other'));
            Map<String,Object> dreamWorld=((Map<String,Object>)other.get('dream_world'));

            if((String)dreamWorld.get('front_default')!=null){
                nuevoPokemon.Imagen__c=(String)dreamWorld.get('front_default');
            }else{
                nuevoPokemon.Imagen__c=(String)sprites.get('front_default');
            }

            List<Object> types=(List<Object>)pokemon.get('types');
            for(Integer i=0; i<types.size();i++){
                Map<String,Object> elemento=(Map<String,Object>)types[i];
                Map<String,Object> tipo=(Map<String,Object>)elemento.get('type');
                String valor=(String)tipo.get('name');
                if(i==0){
                    nuevoPokemon.Tipos__c=valor;
                }else{
                    nuevoPokemon.Tipos__c+= ';'+valor;
                }
            }
            List<Object> stats=(List<Object>)pokemon.get('stats');
            for (Integer i = 0; i < stats.size(); i++) {
                
                Map<String,Object> elemento=(Map<String,Object>)stats[i];
                Map<String,Object> stat=(Map<String,Object>)elemento.get('stat');
                String nombre=(String)stat.get('name');
                Integer valor=(Integer)elemento.get('base_stat');
                switch on nombre {
                    when 'hp' {
                        nuevoPokemon.Vida__c=valor;
                    }	
                    when 'attack' {		
                        nuevoPokemon.Ataque__c=valor;
                    }
                    when 'defense' {		
                        nuevoPokemon.Defensa__c=valor;
                    }
                    when 'speed' {		 
                        nuevoPokemon.Velocidad__c=valor;
                    }
                }
            }

            List<Object> abilities=(List<Object>)pokemon.get('abilities');
            List<Object> moves=(List<Object>)pokemon.get('moves');
           /* Extraigo todas las url de habilidades y movimientos */
            for (Integer i = 0; i < abilities.size(); i++) {
                Map<String,Object> elemento=(Map<String,Object>)abilities[i];
                Map<String,Object> ability=(Map<String,Object>)elemento.get('ability');
                hablidadesUrls.add((String)ability.get('url'));
            }
            for (Integer i = 0; i < moves.size(); i++) {
                Map<String,Object> elemento=(Map<String,Object>)moves[i];
                Map<String,Object> move=(Map<String,Object>)elemento.get('move');
                movimientosUrls.add((String)move.get('url'));
            }
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
        Map<String,List<Integer>> relacionesId=new Map<String,List<Integer>>();
        List<Integer> habilidades=getRandomExtIds(1, hablidadesUrls);
        List<Integer> movimientos=getRandomExtIds(4, movimientosUrls);
        relacionesId.put('habilidades', habilidades);
        relacionesId.put('movimientos', movimientos);
        nuevoPokemon.RelacionesId__c=JSON.serialize(relacionesId);

        System.debug(nuevoPokemon);
       return nuevoPokemon;
    }
    /* Metodo que recibe las urls y devuelve de forma aleatoria los external id */
    public static List<Integer> getRandomExtIds(Integer cantidad, List<String> originales){
        Integer index;
        Integer cantidadOriginal=originales.size()-1;
        List<Integer> listaExtIds=new List<Integer>();
        Set<String> lista;

        if(originales.size()>cantidad){
            lista=new Set<String>();
            while(lista.size()<cantidad){
                index = (Math.random() * (cantidadOriginal)).intValue();
                lista.add(originales[index]);
            }
        }else {
            lista=new Set<String>(originales);
        }

        for (String url : lista) {
            List<String> cortado=url.split('/');
            Integer n=Integer.valueOf(cortado[cortado.size()-1]);
            listaExtIds.add(n);
        }
        
        return listaExtIds;
    }

    public static Movimiento__c getMovimiento(Integer n){
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
        }
    System.debug(nuevoMovimiento);
    return NuevoMovimiento;
    }

    public static Habilidad__c getHabilidad(Integer n){
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
        }
    System.debug(NuevaHabilidad);
    return NuevaHabilidad;
    }
}

/* ParseoNativo.getPokemon(521);
ParseoNativo.getMovimiento(1); 
ParseoNativo.getHabilidad(1); 
*/