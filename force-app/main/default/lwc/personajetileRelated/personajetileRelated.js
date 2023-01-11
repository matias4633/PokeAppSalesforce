import { LightningElement,api, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import searchPersonajes from '@salesforce/apex/PokemonController.GetPokemonsRelacionados';
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
		setTimeout(()=>{
			const personajeId = event.detail;

			this[NavigationMixin.Navigate]({
				type: 'standard__recordPage',
				attributes: {
					recordId: personajeId,
					objectApiName: 'Pokemon__c',
					actionName: 'view',
				},
			});
		},1500);
		
	}
	handleViewMov(event){
		const movimientoId = event.detail;

			this[NavigationMixin.Navigate]({
				type: 'standard__recordPage',
				attributes: {
					recordId: movimientoId,
					objectApiName: 'Movimiento__c',
					actionName: 'view',
				},
			});
	}
	get hayResultados(){
		return(this.personaje.length > 0);
	}

}