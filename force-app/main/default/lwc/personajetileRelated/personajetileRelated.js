import { LightningElement,api, wire, track } from 'lwc';
import searchPersonajes from '@salesforce/apex/MovimientoController.GetPokemonsRelacionados';
export default class PersonajetileRelated extends LightningElement {
    @api recordId; //Lo pone como un String automaticamente.

    searchTerm = '';
    valueTipo = '';
    valueGene = '';
    @track personaje;
    mostrar = true;

    @wire(searchPersonajes, { identificador: '$recordId' })
    loadPersonajes(result) {
        this.personaje = result.data;
    }
}