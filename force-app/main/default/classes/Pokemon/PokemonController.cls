public with sharing class PokemonController {
    public List<String> hablidadesUrls=new List<String>();
    public List<String> movimientosUrls=new List<String>();
    
    public void insertPokemon(Integer n){
        if(n<1 || n>898){
            try {
                throw new CalloutException('Fuera de rango');
            } catch (CalloutException e) {
                System.debug(e.getMessage());
            }
        }
        Pokemon__c nuevoPokemon=getPokemon(n);
        List<Habilidad__c> habilidades=getHabilidades(getRandomUrls(1, this.hablidadesUrls));
        List<Movimiento__c> movimientos=getMovimientos(getRandomUrls(4, this.movimientosUrls));
        upsert habilidades Name;
        upsert movimientos Name;
        
        for (Habilidad__c habilidad : habilidades) {
            nuevoPokemon.Habilidad__c=habilidad.Id;
        }
        try {
            nuevoPokemon.Slot1__c=movimientos[0].Id;
            nuevoPokemon.Slot2__c=movimientos[1].Id;
            nuevoPokemon.Slot3__c=movimientos[2].Id;
            nuevoPokemon.Slot4__c=movimientos[3].Id;
        } catch (Exception e) {
            System.debug('Hubo menos que 4 movimientos desde la api.');
        }
        if(nuevoPokemon!=null){
            insert nuevoPokemon;
        }
    }
    public Pokemon__c getPokemon(Integer n){
        Pokemon__c nuevoPokemon = new  Pokemon__c();
        Http http = new Http(); 
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://pokeapi.co/api/v2/pokemon/'+n);
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
            PokemonJson2Apex pokemon=PokemonJson2Apex.parse(response.getBody());
            nuevoPokemon.ExtId__c=pokemon.id;
            nuevoPokemon.Name=pokemon.name.capitalize();
            nuevoPokemon.Altura__c=pokemon.height/10.0;
            nuevoPokemon.Peso__c=pokemon.weight/10.0;
            nuevoPokemon.Imagen__c=pokemon.sprites.front_default;
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
            for (Integer i = 0; i < pokemon.abilities.size(); i++) {
                this.hablidadesUrls.add(pokemon.abilities[i].ability.url);
            }
            for (Integer i = 0; i < pokemon.moves.size(); i++) {
                this.movimientosUrls.add(pokemon.moves[i].move.url);
            }
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
        return nuevoPokemon;
    }
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

    public static List<Habilidad__c> getHabilidades(List<String> lista){
        List<Habilidad__c> listaA_Insertar=new List<Habilidad__c>();
        for (String url : lista) {
            Habilidad__c habilidad=HabilidadController.getHabilidad(url);
            listaA_Insertar.add(habilidad);
        }
        System.debug('Ejecute el return de habilidad');
        return listaA_Insertar;
        
    }
    public static List<Movimiento__c> getMovimientos(List<String> lista){
        List<Movimiento__c> listaA_Insertar=new List<Movimiento__c>();
        for (String url : lista) {
            Movimiento__c movimiento=MovimientoController.getMovimiento(url);
            listaA_Insertar.add(movimiento);
        }
        System.debug('Ejecute el return de Movimiento');
        return listaA_Insertar;
        
    }

    //CLASES QUE SE USAN DESDE LWC

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
            ORDER BY ExtId__c
            LIMIT 50
        ];
    }

    @AuraEnabled(cacheable=true scope='global')
    public static Pokemon__c[] search(String searchTerm , String valueTipo, String valueGene ,String identificador) {
        searchTerm = searchTerm.trim();
        if (searchTerm == '' && valueTipo == ''  && valueGene == '' && identificador=='') {
            return getAll();
        }
        // Prepare query paramters
        searchTerm = '%' + searchTerm + '%';
        // Execute search query

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
        query=query+'ORDER BY ExtId__c LIMIT 50';
        //System.debug(query);
        return Database.query(query);

        
    }

}