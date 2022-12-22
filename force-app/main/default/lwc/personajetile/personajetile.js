import { LightningElement, api } from 'lwc';
import fondo from '@salesforce/resourceUrl/roja';
// Example :- import TRAILHEAD_LOGO from '@salesforce/resourceUrl/trailhead_logo';'
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

    get background(){
        return  `background-image:url(${fondo});background-size: cover;background-size: 100% 100%;
        background-repeat: no-repeat;`;
    }
    
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
    connectedCallback(){
        
    }
}