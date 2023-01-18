public with sharing class PokemonController {
    /* insert(PokemonController.getPokemon(1)); 
        List<Pokemon__c> poke=[SELECT Id FROM Pokemon__c];
        delete poke;   
         Database.executeBatch(new Paso3(),10); */
    
    
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
        query=query+'AND ExtId__c!=null ORDER BY ExtId__c';
        //System.debug(query);
        return Database.query(query);

        
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