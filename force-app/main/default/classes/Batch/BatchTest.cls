@isTest
public with sharing class BatchTest {
    @isTest
    public static void deberiaObtenerUnPokemon(){
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('respuestaPokemon');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
            Database.executeBatch(new Paso3(),1);
        Test.stopTest();
        
        Integer cantPokemon=[SELECT Id FROM Pokemon__c].size();

        System.assertEquals(1, cantPokemon, 'La cantidad de pokemon no es la esperada');
    }
    @isTest
    public static void deberiaObtenerUnaHabilidad(){
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('respuestaHabilidad');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
            Database.executeBatch(new Paso1(),10);
        Test.stopTest();
        Integer cantHabilidad=[SELECT Id FROM Habilidad__c].size();
        System.assertEquals(1, cantHabilidad, 'La cantidad de habilidades no es la esperada');
    }

    @isTest
    public static void deberiaObtenerUnMovimiento(){
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('respuestaMovimiento1');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
            Database.executeBatch(new Paso2(),10);
        Test.stopTest();
        Integer cantMovimientos=[SELECT Id FROM Movimiento__c].size();
        System.assertEquals(1, cantMovimientos, 'La cantidad de Movimientos no es la esperada');
    }

    @isTest
    public static void deberiaObtenerUnErrorPorRespuestaIncorrectaPokemon(){
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('error');
        mock.setStatusCode(404);
        mock.setHeader('Content-Type', 'application/json');
        
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
             Database.executeBatch(new Paso3(),1);
        Test.stopTest();
        Integer cantPokemon=[SELECT Id FROM Pokemon__c].size();

        System.assertEquals(0, cantPokemon, 'La cantidad de pokemon no es la esperada');
    }
    @isTest
    public static void deberiaObtenerUnErrorPorRespuestaIncorrectaHabilidad(){
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('error');
        mock.setStatusCode(404);
        mock.setHeader('Content-Type', 'application/json');
        
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
             Database.executeBatch(new Paso1(),10);
        Test.stopTest();
        Integer cant=[SELECT Id FROM Habilidad__c].size();

        System.assertEquals(0, cant, 'La cantidad de habilidades no es la esperada');
    }
    @isTest
    public static void deberiaObtenerUnErrorPorRespuestaIncorrectaMovimiento(){
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('error');
        mock.setStatusCode(404);
        mock.setHeader('Content-Type', 'application/json');
        
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
             Database.executeBatch(new Paso2(),10);
        Test.stopTest();
        Integer cant=[SELECT Id FROM Movimiento__c].size();

        System.assertEquals(0, cant, 'La cantidad de movimientos no es la esperada');
    }
}