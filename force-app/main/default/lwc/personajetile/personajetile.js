import { LightningElement, api } from 'lwc';
/* import { publish, MessageContext } from 'lightning/messageService';
import CANAL from '@salesforce/messageChannel/Canal__c'; */

export default class PersonajeTile extends LightningElement {
	@api pers;
    /* @wire(MessageContext)
    messageContext; */

   /*  enviarfalse() {
        
        const payload = { mensaje:false , obj:this.pers };
        publish(this.messageContext, CANAL , payload);
        
    } */
    
    handleOpenRecordClick() {
        const selectEvent = new CustomEvent('view', {
            detail: this.pers.Id
        });
        this.dispatchEvent(selectEvent);
    }
    
    handleDeleteRecordClick(){
        const selectEvent = new CustomEvent('delete', {
            detail: this.pers.Id
        });
        this.dispatchEvent(selectEvent);
    }
}