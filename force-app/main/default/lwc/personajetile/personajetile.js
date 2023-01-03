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
        return  `background-image:url(${fondos[index]});background-color:#FFFFFF;background-size: cover;background-size: 100% 100%;
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
    irAlMovimiento1(){
        const selectEvent = new CustomEvent('viewmov', {
            detail: this.pers.Slot1__c
        });
        this.dispatchEvent(selectEvent);
    }
    irAlMovimiento2(){
        const selectEvent = new CustomEvent('viewmov', {
            detail: this.pers.Slot2__c
        });
        this.dispatchEvent(selectEvent);
    }
    renderedCallback(){
        let frente=this.template.querySelector('div.front');
        //let atras=this.template.querySelector('div.back');
        function animacion(){
            frente.classList.remove('efectoHover');
            frente.classList.add('vibrador');
            
            setTimeout(()=>{
                frente.classList.add('efectoHover');
                frente.classList.remove('vibrador');
            },2000);
        }
        this.template.querySelector('div.imagen').addEventListener('click',animacion);
    }
    
}