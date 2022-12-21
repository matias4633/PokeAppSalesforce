import { NavigationMixin } from 'lightning/navigation';
import { deleteRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//import { MessageContext } from 'lightning/messageService';
import { LightningElement, wire } from 'lwc';
import searchPersonajes from '@salesforce/apex/PokemonController.search';
export default class PersonajeList extends NavigationMixin(LightningElement) {
	searchTerm = '';
	personajes;
	//@wire(MessageContext) messageContext;

	@wire(searchPersonajes, { searchTerm: '$searchTerm' })
	loadPersonajes(result) {
		this.personajes = result;
		console.log(this.personajes);
		console.log(result);
		debugger;
	}



	handleSearchTermChange(event) {
		window.clearTimeout(this.delayTimeout);
		const searchTerm = event.target.value;

		this.delayTimeout = setTimeout(() => {
			this.searchTerm = searchTerm;
		}, 300);
	}
	get hasResults() {
		return (this.personajes.data.length > 0);
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

	handleDelete(event) {
		
		deleteRecord(event.detail).then(() => {

				this.dispatchEvent(
					new ShowToastEvent({
						title: 'Success',
						message: 'Record deleted',
						variant: 'success'
					})
				);
				
				return refreshApex(this.personajes);

			}).catch(error => {
				this.dispatchEvent(
					new ShowToastEvent({
						title: 'Error deleting record',
						message: error.body.message,
						variant: 'error'
					})
				);
			});


	}
}