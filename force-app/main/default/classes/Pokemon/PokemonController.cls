public with sharing class PokemonController {
   
    public static Pokemon__c getPokemon(Integer n){
        List<String> hablidadesUrls=new List<String>();
        List<String> movimientosUrls=new List<String>();

        //Verifico que el parametro este entre lo pedido.
        if(n<1 || n>898){
            throw new CalloutException('Fuera de rango');
        }
        
        //LLamado a la Api
        Pokemon__c nuevoPokemon = new  Pokemon__c();
        PokemonJson2Apex pokemon;
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
        //Tratamiento de los Datos
        try {
            pokemon=PokemonJson2Apex.parse(response.getBody());
        } catch (Exception e) {
            System.debug(e.getMessage());
            return null;
        }
        try {
            
            nuevoPokemon.ExtId__c=pokemon.id;
            nuevoPokemon.Name=pokemon.name.capitalize();
            nuevoPokemon.Altura__c=pokemon.height/10.0;
            nuevoPokemon.Peso__c=pokemon.weight/10.0;
            nuevoPokemon.Imagen__c=pokemon.sprites.front_default;
            //Armo el formato valor;valor;valor para la multipicklist
            for(Integer i=0; i<pokemon.types.size();i++){
                if(i==0){
                    nuevoPokemon.Tipos__c=pokemon.types[i].type.name;
                }else{
                    nuevoPokemon.Tipos__c+= ';'+pokemon.types[i].type.name;
                }
            }

            for (Integer i = 0; i < pokemon.stats.size(); i++) {
                switch on pokemon.stats[i].stat.name {
                    when 'hp' {
                        nuevoPokemon.Vida__c=pokemon.stats[i].base_stat;
                    }	
                    when 'attack' {		
                        nuevoPokemon.Ataque__c=pokemon.stats[i].base_stat;
                    }
                    when 'defense' {		
                        nuevoPokemon.Defensa__c=pokemon.stats[i].base_stat;
                    }
                    when 'speed' {		 
                        nuevoPokemon.Velocidad__c=pokemon.stats[i].base_stat;
                    }
                }
            }

            /* Extraigo todas las urls de habilidad y movimiento */
            
            for (Integer i = 0; i < pokemon.abilities.size(); i++) {
                hablidadesUrls.add(pokemon.abilities[i].ability.url);
            }
            for (Integer i = 0; i < pokemon.moves.size(); i++) {
                movimientosUrls.add(pokemon.moves[i].move.url);
            }
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
        /* Guardo un Mapa con los ExtId de las habilidades y movimientos elegidos */
        Map<String,List<Integer>> relacionesId=new Map<String,List<Integer>>();
        List<Integer> habilidades=getHabilidadesExtId(getRandomUrls(1, hablidadesUrls));
        List<Integer> movimientos=getMovimientosExtId(getRandomUrls(4, movimientosUrls));
        relacionesId.put('habilidades', habilidades);
        relacionesId.put('movimientos', movimientos);
        nuevoPokemon.RelacionesId__c=JSON.serialize(relacionesId);
        
        return nuevoPokemon;
    }
    /* Metodo para elegir aleaoriamente urls */
    public static List<String> getRandomUrls(Integer cantidad, List<String> originales){
        if(originales.size()<=cantidad){
            return originales;
        }
        Integer index;
        Integer cantidadOriginal=originales.size()-1;
        Set<String> lista=new Set<String>();
        while(lista.size()<cantidad){
            index = (Math.random() * (cantidadOriginal)).intValue();
            lista.add(originales[index]);
        }
        return new List<String>(lista);
    }

    public static List<Integer> getHabilidadesExtId(List<String> lista){
        
        List<Integer> listaA_Insertar=new List<Integer>();
        for (String url : lista) {
            List<String> cortado=url.split('/');
            Integer n=Integer.valueOf(cortado[cortado.size()-1]);
            listaA_Insertar.add(n);
        }
        //System.debug('Ejecute el return de habilidad');
        return listaA_Insertar;
    }
    public static List<Integer> getMovimientosExtId(List<String> lista){
        List<Integer> listaA_Insertar=new List<Integer>();
        for (String url : lista) {
            List<String> cortado=url.split('/');
            Integer n=Integer.valueOf(cortado[cortado.size()-1]);
            listaA_Insertar.add(n);
        }
        //System.debug('Ejecute el return de Movimiento');
        return listaA_Insertar;
    }

    //CLASES QUE SE USAN DESDE LWC
    /* Este metodo retorna los datos cuando los parametros son vacios */
    @AuraEnabled(cacheable=true scope='global')
    public static Pokemon__c[] getAll() {
        return [
            SELECT
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
            WHERE ExtId__c!=null
            ORDER BY ExtId__c
            LIMIT 50
        ];
    }
    /* Metodo de filtrados de busqueda */
    @AuraEnabled(cacheable=true scope='global')
    public static Pokemon__c[] search(String searchTerm , String valueTipo, String valueGene ,String identificador) {
        searchTerm = searchTerm.trim();
        if (searchTerm == '' && valueTipo == ''  && valueGene == '' && identificador=='') {
            return getAll();
        }
        // Preparo el parametro de busqueda para query
        searchTerm = '%' + searchTerm + '%';
        //Query base
        String query='SELECT Id,Name,Altura__c,Ataque__c,Defensa__c,ExtId__c,Imagen__c,Vida__c,Velocidad__c,Tipos__c,Slot1__r.Name,Slot1__r.ExtId__c,Slot2__r.Name,Slot2__r.ExtId__c FROM Pokemon__c WHERE Name LIKE :searchTerm ';
        if(valueTipo != ''){
            query=query+'AND Tipos__c includes (:valueTipo) ';
        }
        if(valueGene != ''){
            Integer gene=Integer.valueOf(valueGene);
            query=query+'AND Generacion__c=:gene ';
        }
        if(identificador!=''){
            query=query+'AND Id=:identificador ';
        }
        query=query+'AND ExtId__c!=null ORDER BY ExtId__c LIMIT 50';
        //System.debug(query);
        return Database.query(query);

        
    }

}