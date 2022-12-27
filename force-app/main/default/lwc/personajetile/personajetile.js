import { LightningElement, api } from 'lwc';

import roja from '@salesforce/resourceUrl/roja';
import atras from '@salesforce/resourceUrl/trasera';
import verde from '@salesforce/resourceUrl/verde';
import blanca from '@salesforce/resourceUrl/blanca';
import amarilla from '@salesforce/resourceUrl/amarilla';

const fondos=[roja,verde,blanca,amarilla]; //Fondos
export default class PersonajeTile extends LightningElement {
	@api pers;
   
    get background(){
        let index=Math.floor(Math.random()*fondos.length);
        return  `background-image:url(${fondos[index]});background-size: cover;background-size: 100% 100%;
        background-repeat: no-repeat;`;
    }
    get fondoback(){
        return `background-image:url(${atras});background-size: cover;background-size: 100% 100%;
        background-repeat: no-repeat;`;
    }
    
    handleOpenRecordClick() {
        const selectEvent = new CustomEvent('view', {
            detail: this.pers.Id
        });
        this.dispatchEvent(selectEvent);
    }
}