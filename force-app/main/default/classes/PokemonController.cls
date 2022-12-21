public with sharing class PokemonController {
    public static void insertPokemon(Integer n){
        if(n<1 || n>898){
            try {
                throw new CalloutException('Fuera de rango');
            } catch (CalloutException e) {
                System.debug(e.getMessage());
            }
        }
        List<String> hablidadesUrls=new List<String>();
        List<String> movimientosUrls=new List<String>();

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
            }
        }
        
        PokemonJson2Apex pokemon=PokemonJson2Apex.parse(response.getBody());

        try {
            nuevoPokemon.ExtId__c=pokemon.id;
            nuevoPokemon.Name=pokemon.name.capitalize();
            nuevoPokemon.Altura__c=pokemon.height/10.0;
            nuevoPokemon.Peso__c=pokemon.weight/10.0;
            nuevoPokemon.Imagen__c=pokemon.sprites.back_default;
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
                hablidadesUrls.add(pokemon.abilities[i].ability.url);
            }
            for (Integer i = 0; i < pokemon.moves.size(); i++) {
                movimientosUrls.add(pokemon.moves[i].move.url);
            }

            insert nuevoPokemon;

            insertarHabilidades(getRandomUrls(1, hablidadesUrls),nuevoPokemon.Id);
            insertarMovimientos(getRandomUrls(3, movimientosUrls),nuevoPokemon.Id);


            
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
       
    }
    public static List<String> getRandomUrls(Integer cantidad, List<String> originales){
        if(cantidad==originales.size()){
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

    public static void insertarHabilidades(List<String> lista,Id identificador){
        List<Habilidad__c> listaA_Insertar=new List<Habilidad__c>();
        for (String url : lista) {
            Habilidad__c habilidad=HabilidadController.getHabilidad(url);
            habilidad.Pokemon__c=identificador;
            listaA_Insertar.add(habilidad);
        }
        insert listaA_Insertar;
    }
    public static void insertarMovimientos(List<String> lista,Id identificador){
        List<Movimiento__c> listaA_Insertar=new List<Movimiento__c>();
        for (String url : lista) {
            Movimiento__c movimiento=MovimientoController.getMovimiento(url);
            movimiento.Pokemon__c=identificador;
            listaA_Insertar.add(movimiento);
        }
        insert listaA_Insertar;
    }
}
