import { NavigationMixin } from 'lightning/navigation';
import { LightningElement, wire} from 'lwc';
import searchPersonajes from '@salesforce/apex/PokemonController.search';
import getValoresDisponibles from '@salesforce/apex/ValuesPickListController.getValoresDisponibles';
import pikachu from '@salesforce/resourceUrl/pikachu';
export default class PersonajeList extends NavigationMixin(LightningElement) {
	//VARIABLES
	recordId='';
	searchTerm = '';
	valueTipo = '';
	valueGene='';
	mostrar=true;
	contador=0;
	opcionesTipo=[{ label: 'Todos', value: '' }];
	personajes;

	//Metodo reactivo de consulta de BD
	@wire(searchPersonajes, { searchTerm: '$searchTerm' ,valueTipo:'$valueTipo',valueGene:'$valueGene', identificador:'$recordId'})
	loadPersonajes(result) {
		this.personajes = result;
		
	}
	/*$ para indicar que es dinámico y reactivo.
	 Si su valor cambia, la plantilla se vuelve a representar. (proveniente de la documentacion)*/

	//Manejadores 
	handleSearchTermChange(event) {
		window.clearTimeout(this.delayTimeout);// Lo que hace es cancelar el timeout y su accion,antes
		//que se ejecute. Entonces si hay otro cambio antes de los 300 mls, se evita el cambio de la 
		//variable reactiva searchTerm.
		const searchTerm = event.target.value;

		this.delayTimeout = setTimeout(() => {
			this.searchTerm = searchTerm;
		}, 300);
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
	handleChangeTipo(event) {
        this.valueTipo = event.detail.value;
    }
	handleChangeGene(event) {
        this.valueGene = event.detail.value;
    }
	handleCheckBox(event){
		this.mostrar=!this.mostrar;
	}

	//Getters and Setters

	get hasResults() {
		
		return (this.personajes.data.length > 0);
	}
    get  optionsTipo() {
		//alert('pidio el dato');
		return this.opcionesTipo;
    }
	get optionsGene() {
        return [
            { label: 'Todas', value: '' },
            { label: 'Primera', value: '1' },
            { label: 'Segunda', value: '2' },
            { label: 'Tercera', value: '3' },
            { label: 'Cuarta', value: '4' },
            { label: 'Quinta', value: '5' },
            { label: 'Sexta', value: '6' },
            { label: 'Septima', value: '7' },
            { label: 'Octava', value: '8' },
        ];
    }
	get pikachu(){
		return `${pikachu}`;
	}
	// Funciones gatillo.
	renderedCallback(){
		if(this.personajes.data){
			this.contador=Object.keys(this.personajes.data).length;
		}
		
	}
	connectedCallback() {
		//Consulto los valores disponibles en la multipicklist
		getValoresDisponibles({nombreObj: 'Pokemon__c',NombreCampoPickList: 'Tipos__c'})
					.then(result => {
					result.forEach(element => {
						this.opcionesTipo= [...this.opcionesTipo,{ label: element, value: element}];
					});
					
				})
					.catch(error => {
					console.log(error);
				});
		//alert('Proceso el dato');
	}
}