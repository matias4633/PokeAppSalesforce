public with sharing class ValuesPickListController {
   @AuraEnabled(cacheable=true)
   public static List<String> getValoresDisponibles(String nombreObj , String NombreCampoPickList){
    List<String> listaValues= new List<String>();
    String strObjectName = nombreObj; //Tipo de Objeto
    String strPicklistField = NombreCampoPickList; //Nombre del campo Picklist

    /*getGlobalDescribe trae toda la metadata de la org, retorna un MAP. 
    .get pido el valor con clave Nombre del objeto */
    Schema.SObjectType objSobjectType = Schema.getGlobalDescribe().get(strObjectName);
    //Pido la metadata del objeto que quiero.
    Schema.DescribeSObjectResult objDescribeSobject = objSobjectType.getDescribe();
    //Pido los campos en forma de MAP
    Map<String, Schema.SObjectField> mapFields = objDescribeSobject.fields.getMap();
    
    List<Schema.PicklistEntry> lstPickListValues = mapFields.get(strPicklistField).getDescribe().getPickListValues();
    for (Schema.PicklistEntry objPickList : lstPickListValues) {
        listaValues.add(objPickList.getValue());
    }
    return listaValues;
   }
    
}
