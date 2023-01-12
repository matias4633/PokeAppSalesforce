import { LightningElement, api } from 'lwc';
import trivia from '@salesforce/resourceUrl/trivia';

import roja from '@salesforce/resourceUrl/roja';
import verde from '@salesforce/resourceUrl/verde';
import blanca from '@salesforce/resourceUrl/blanca';
import amarilla from '@salesforce/resourceUrl/amarilla';
import azul from '@salesforce/resourceUrl/azul';
import verdefluor from '@salesforce/resourceUrl/verdefluor';
import negro from '@salesforce/resourceUrl/negro';
import cobre from '@salesforce/resourceUrl/cobre';
import rosa from '@salesforce/resourceUrl/rosa';
import naranja from '@salesforce/resourceUrl/naranja';
import violeta from '@salesforce/resourceUrl/violeta';
import grisoscuro from '@salesforce/resourceUrl/grisoscuro';

const fondos=[roja,verde,blanca,blanca,amarilla,azul,azul,verdefluor,negro,cobre,cobre,cobre,rosa,naranja,violeta,violeta,violeta,grisoscuro];
const fondosString=["Fire",'Grass','Normal','Flying','Electric','Water','Ice','Bug','Dark','Rock','Dragon','Ground','Fairy','Fighting','Poison','Psychic','Ghost','Steel'];

export default class PersonajeTilehidden extends LightningElement {
	@api pers;
    @api mostrar;
    

    get background(){
        let index=this.getIndexbyType(this.pers.Tipos__c.split(';').pop());
        return  `background-image:url(${fondos[index]});background-color:#FFFFFF;background-size: cover;background-size: 100% 100%;
        background-repeat: no-repeat;`;
    }
    get fondoback(){
        return `background-image:url(${trivia});background-size: cover;background-size: 100% 100%;
        background-repeat: no-repeat;`;
    }
    getIndexbyType(tipo){
        return fondosString.indexOf(tipo);
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
        let frente=this.template.querySelector('div.cara1');
        let atras=this.template.querySelector('div.cara2');
        let imgTrivia=this.template.querySelector('img.trivia');
        
        if(this.mostrar){
            frente.classList.remove('front2');
            atras.classList.remove('back2');
            frente.classList.add('front1');
            atras.classList.add('back1');
        }else{
            frente.classList.remove('front1');
            atras.classList.remove('back1');
            frente.classList.add('front2');
            atras.classList.add('back2');
        }
        function animacion(){
            frente.classList.remove('efectoHover');
            frente.classList.add('vibrador');
            
            setTimeout(()=>{
                frente.classList.add('efectoHover');
                frente.classList.remove('vibrador');
            },2000);
        }
        function revelarTrivia(){
            if(!this.mostrar){
                imgTrivia.classList.remove('trivia');
                imgTrivia.classList.add('trivia-show');
            }
            setTimeout(()=>{
                frente.classList.remove('front2');
                atras.classList.remove('back2');
                frente.classList.add('front1');
                atras.classList.add('back1');
            },1500);
            setTimeout(()=>{
                imgTrivia.classList.add('trivia');
                imgTrivia.classList.remove('trivia-show');
            },2000);
            
        }
        this.template.querySelector('div.imagen').addEventListener('click',animacion);
        imgTrivia.addEventListener('click',revelarTrivia);
    }
}