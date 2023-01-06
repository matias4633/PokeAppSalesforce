import { NavigationMixin } from 'lightning/navigation';
import { LightningElement, track, wire} from 'lwc';
import searchPersonajes from '@salesforce/apex/PokemonController.search';
import getValoresDisponibles from '@salesforce/apex/ValuesPickListController.getValoresDisponibles';
import pikachu from '@salesforce/resourceUrl/pikachu';
export default class PersonajeList extends NavigationMixin(LightningElement) {
	//VARIABLES
	LONGITUD_PEDAZOS = 14;
	personajesPage=[];
	pagina=1;
	paginaMaxima;
	personajesMostrar;
	recordId='';
	searchTerm = '';
	valueTipo = '';
	valueGene='';
	mostrar=false;
	contador=0;
	opcionesTipo=[{ label: 'Todos', value: '' }];
	personajes;

	//Metodo reactivo de consulta de BD
	@wire(searchPersonajes, { searchTerm: '$searchTerm' ,valueTipo:'$valueTipo',valueGene:'$valueGene', identificador:'$recordId'})
	loadPersonajes(result) {
		this.personajes = result;
		this.pagina=1;
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
	handleChangeTipo(event) {
        this.valueTipo = event.detail.value;
    }
	handleChangeGene(event) {
        this.valueGene = event.detail.value;
    }
	handleCheckBox(event){
		this.mostrar=!this.mostrar;
	}
	prev(){
		if(this.pagina>1){
			this.pagina-=1;
		}
		//alert(this.pagina);
	}
	next(){
		if(this.pagina<this.paginaMaxima){
			this.pagina+=1;
		}
		//alert(this.pagina);
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
			
			let aux=[];
			for(let i=0;i<this.personajes.data.length;i+=this.LONGITUD_PEDAZOS){
				let pedazo=this.personajes.data.slice(i, i+this.LONGITUD_PEDAZOS);
				aux.push(pedazo);
			}
			
			if(JSON.stringify(aux)!==JSON.stringify(this.personajesPage)){
				this.personajesPage=aux;
			}
			
			this.paginaMaxima=this.personajesPage.length;
			//console.log(JSON.stringify(this.personajesPage[this.pagina]));
			this.personajesMostrar=this.personajesPage[this.pagina-1];
			//alert(JSON.stringify(this.personajesMostrar));
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