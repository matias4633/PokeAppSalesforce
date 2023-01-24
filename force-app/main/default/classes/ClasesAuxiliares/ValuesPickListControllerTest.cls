@isTest
public with sharing class ValuesPickListControllerTest {
    @isTest
    public static void deberiaObtenerTodosLosValoresDisponiblesDeLaPickList(){

        Test.startTest();
        List<String> valores=ValuesPickListController.getValoresDisponibles('Pokemon__c', 'Tipos__c');
        Test.stopTest();
        System.assertEquals(18, valores.size(),'La cantidad no es la esperada');
    }
}