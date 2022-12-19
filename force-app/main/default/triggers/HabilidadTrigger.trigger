trigger HabilidadTrigger on Habilidad__c (after insert) {
    if(Trigger.isBefore){
        if(Trigger.isInsert){

        }
        if(Trigger.isUpdate){

        }
    }
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            for (Habilidad__c objeto : Trigger.new) {
                //HabilidadTriggerHelper.relacionarObjeto(objeto.ExtId__c);
            }
        }
        if(Trigger.isUpdate){
            
        }
    }
}