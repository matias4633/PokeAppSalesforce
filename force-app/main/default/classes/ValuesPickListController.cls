public with sharing class ValuesPickListController {
   @AuraEnabled(cacheable=true)
   public static List<String> getValoresDisponibles(String nombreObj , String NombreCampoPickList){
    List<String> listaValues= new List<String>();
    String strObjectName = nombreObj;
    String strPicklistField = NombreCampoPickList;
    Map<String, String> mapPickListValues = new Map<String, String>();
    Schema.SObjectType objSobjectType = Schema.getGlobalDescribe().get(strObjectName);
    Schema.DescribeSObjectResult objDescribeSobject = objSobjectType.getDescribe();
    Map<String, Schema.SObjectField> mapFields = objDescribeSobject.fields.getMap();
    List<Schema.PicklistEntry> lstPickListValues = mapFields.get(strPicklistField).getDescribe().getPickListValues();
    for (Schema.PicklistEntry objPickList : lstPickListValues) {
        System.debug('Value = ' +objPickList.getValue() +' , Label = ' +objPickList.getLabel());
        listaValues.add(objPickList.getValue());
    }
    return listaValues;
   }
    
}
