@isTest
public with sharing class PokemonControllerTest {
    @TestSetup
    static void makeData(){
        List<Pokemon__c> listaInsertada=new List<Pokemon__c>();
        for (Integer i = 0; i < 2; i++) {
            listaInsertada.add(New Pokemon__c(Name='prueba '+i,ExtId__c=i+1, Tipos__c='Fire'));
        }

        for (Integer i = 0; i < 3; i++) {
            listaInsertada.add(New Pokemon__c(Name='prueba '+i,ExtId__c=i+200, Tipos__c='Bug'));
        }
        insert listaInsertada;
    }

    @isTest
    public static void deberiaObtenerDeLaBaseDeDatosTodosLosPokemonsEnLaBusqueda(){
        Test.startTest();
        List<Pokemon__c> lista=PokemonController.search('','','','');
        Test.stopTest();
        System.assertEquals(5, lista.size(),'La cantidad de no es la esperada');
    }

    @isTest
    public static void deberiaObtenerDeLaBaseDeDatosSolo2Pokemons(){
        Test.startTest();
        List<Pokemon__c> lista=PokemonController.search('prueba','Fire','1','');
        Test.stopTest();
        System.assertEquals(2, lista.size(),'La cantidad de no es la esperada');
    }

    @isTest
    public static void deberiaObtenerTodosLosPokemonsRelacionadosAlMovimiento(){
        Movimiento__c movimiento=new Movimiento__c(Name='SuperDuper Move');
        insert movimiento;
        List<Pokemon__c> lista= new List<Pokemon__c>();
        for (Integer i = 0; i < 3; i++) {
            lista.add(new Pokemon__c(Name='prueba '+i,Slot1__c=movimiento.id));
        }
        insert lista;
        Test.startTest();
        List<Pokemon__c> busqueda=PokemonController.GetPokemonsRelacionados(movimiento.id);
        Test.stopTest();
        System.assertEquals(3, busqueda.size(), 'La cantidad no es la esperada');
    }
}