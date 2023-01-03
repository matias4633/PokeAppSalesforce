import { LightningElement,api,wire, track } from 'lwc';
import searchPersonajes from '@salesforce/apex/PokemonController.search';

export default class PersonajetileRecordPage extends LightningElement {
    @api recordId; //Lo pone como un String automaticamente.
    
    searchTerm = '';
    valueTipo = '';
	valueGene='';
    @track personaje;
    mostrar=true;

    @wire(searchPersonajes, { searchTerm: '$searchTerm' ,valueTipo:'$valueTipo',valueGene:'$valueGene', identificador:'$recordId'})
	loadPersonajes(result) {
		this.personaje = result.data;
	}
}