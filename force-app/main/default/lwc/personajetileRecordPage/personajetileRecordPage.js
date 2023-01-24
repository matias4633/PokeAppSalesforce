import { LightningElement,api,wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import searchPersonajes from '@salesforce/apex/PokemonController.search';

export default class PersonajetileRecordPage extends NavigationMixin(LightningElement) {
    @api recordId; //Lo pone como un String automaticamente.
    
    searchTerm = '';
    valueTipo = '';
	valueGene='';
    @track personaje;
    mostrar=true;

    @wire(searchPersonajes, { searchTerm: '$searchTerm' ,
							valueTipo:'$valueTipo',
							valueGene:'$valueGene', 
							identificador:'$recordId'})
	loadPersonajes(result) {
		this.personaje = result.data;
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
}