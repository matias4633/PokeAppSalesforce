import { NavigationMixin } from 'lightning/navigation';
import { LightningElement, track, wire} from 'lwc';
import searchPersonajes from '@salesforce/apex/PokemonController.search';
export default class PersonajeList extends NavigationMixin(LightningElement) {
	searchTerm = '';
	valueTipo = '';
	valueGene = 0;
	mostrar=true;
	@track contador=0;
	personajes;

	@wire(searchPersonajes, { searchTerm: '$searchTerm' ,valueTipo:'$valueTipo',valueGene:'$valueGene'})
	loadPersonajes(result) {
		this.personajes = result;
		
	}
	/*$ para indicar que es dinámico y reactivo.
	 Si su valor cambia, la plantilla se vuelve a representar. (proveniente de la documentacion)*/

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

	
	
    get optionsTipo() {
        return [
            { label: 'Todos', value: '' },
            { label: 'Normal', value: 'Normal' },
            { label: 'Fighting', value: 'Fighting' },
            { label: 'Flying', value: 'Flying' },
            { label: 'Poison', value: 'Poison' },
            { label: 'Ground', value: 'Ground' },
            { label: 'Rock', value: 'Rock' },
            { label: 'Bug', value: 'Bug' },
            { label: 'Ghost', value: 'Ghost' },
            { label: 'Steel', value: 'Steel' },
            { label: 'Fire', value: 'Fire' },
            { label: 'Water', value: 'Water' },
            { label: 'Grass', value: 'Grass' },
            { label: 'Electric', value: 'Electric' },
            { label: 'Psychic', value: 'Psychic' },
            { label: 'Ice', value: 'Ice' },
            { label: 'Dragon', value: 'Dragon' },
            { label: 'Dark', value: 'Dark' },
            { label: 'Fairy', value: 'Fairy' },
        ];
    }
    handleChangeTipo(event) {
        this.valueTipo = event.detail.value;
    }

	get optionsGene() {
        return [
            { label: 'Todas', value: 0 },
            { label: 'Primera', value: 1 },
            { label: 'Segunda', value: 2 },
            { label: 'Tercera', value: 3 },
        ];
    }

    handleChangeGene(event) {
        this.valueGene = event.detail.value;
    }

	handleCheckBox(event){
		this.mostrar=!this.mostrar;
		console.log(this.mostrar);
	}

	renderedCallback(){
		if(this.personajes.data){
			this.contador=Object.keys(this.personajes.data).length;
		}
		
	}
}