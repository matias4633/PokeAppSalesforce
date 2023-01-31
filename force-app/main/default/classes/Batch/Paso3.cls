global class Paso3 implements Database.Batchable<Integer>, Database.Stateful, Database.AllowsCallouts {
    Integer cantidad;
    List<Pokemon__c> pokemons=new List<Pokemon__c>();
    public Paso3(){
        if(!Test.isRunningTest()){
            this.cantidad=898;
        }else{
            this.cantidad=1;
        }
    }
    
    global Iterable<Integer> start(Database.BatchableContext bc) {
        List<Integer> iteraciones=new List<Integer>();
        for (Integer i = 1; i <=this.cantidad; i++) { //hasta 898
            iteraciones.add(i);
        }
        return iteraciones;
    }
    global void execute(Database.BatchableContext BC , List<Integer> lista){
        for (Integer i : lista) {
            try {
                Pokemon__c nuevoPokemon=getPokemon(i);
                
                if(nuevoPokemon!=null){
                    pokemons.add(nuevoPokemon);
                }
                
            } catch (CalloutException e) {
                System.debug('Hugo un error el Pokemon de idExt: '+ i);
                throw e;
            }
        }
        
    }
    global void finish(Database.BatchableContext BC){
        try {
            insert pokemons;
        } catch (Exception e) {
            System.debug('Ocurrio un error en Dml: '+e.getMessage());
        }
       
    }

    public Pokemon__c getPokemon(Integer n){
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
            //System.debug('Error en el JSON');
            throw new CalloutException('Error en el JSON');
            //return null;
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
            return null;
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
    public List<Integer> getRandomExtIds(Integer cantidad, List<String> originales){
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
}

/* Pokemon__c poke= PokemonController.getPokemon(521);
System.debug(poke!=null);
System.debug(poke); 
if(poke!=null){
    insert poke;
} */