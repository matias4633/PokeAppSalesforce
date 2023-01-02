import { LightningElement,api, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import searchPersonajes from '@salesforce/apex/MovimientoController.GetPokemonsRelacionados';
export default class PersonajetileRelated extends NavigationMixin(LightningElement) {
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
    handleView(event) {

		const personajeId = event.detail;

		this[NavigationMixin.Navigate]({
			type: 'standard__recordPage',
			attributes: {
				recordId: personajeId,
				objectApiName: 'Pokemon__c',
				actionName: 'view',
			},
		});
	}
}