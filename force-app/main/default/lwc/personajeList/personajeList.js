import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { LightningElement, wire } from 'lwc';
import searchPersonajes from '@salesforce/apex/PokemonController.search';
import getValoresDisponibles from '@salesforce/apex/ValuesPickListController.getValoresDisponibles';

export default class PersonajeList extends NavigationMixin(LightningElement) {
	//VARIABLES
	reconocimiento;
	reproducir=false;
	LONGITUD_PEDAZOS = 16;
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
	playSound;
	
	//Metodo reactivo de consulta de BD
	@wire(searchPersonajes, { searchTerm: '$searchTerm' ,valueTipo:'$valueTipo',valueGene:'$valueGene' , identificador:'$recordId'})
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
		sessionStorage.setItem('mostrar',this.mostrar);
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

	handleKeys(event){
		//alert(event.keyCode );
		if(event.keyCode==37){
			this.prev();
		}
		if(event.keyCode==39){
			this.next();
		}
		//Control + S
		if(event.keyCode==83 && event.ctrlKey){
			this.reconocimiento.start();
		}
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
	
	
	// Funciones gatillo.
	renderedCallback(){
		
		if(this.personajes.data){
			//Recuerda el marcado del checkbox
			if(this.mostrar){
				this.template.querySelector('.checkbox').checked=true;
			}
			//Actualiza la cantidad en la busqueda
			this.contador=Object.keys(this.personajes.data).length;
			
			//Particionado de los resultados en paginas.
			let aux=[];
			for(let i=0;i<this.personajes.data.length;i+=this.LONGITUD_PEDAZOS){
				let pedazo=this.personajes.data.slice(i, i+this.LONGITUD_PEDAZOS);
				aux.push(pedazo);
			}
			if(JSON.stringify(aux)!==JSON.stringify(this.personajesPage)){
				this.personajesPage=aux;
			}
			
			this.paginaMaxima=this.personajesPage.length;
			this.personajesMostrar=this.personajesPage[this.pagina-1];
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
		//Consulto si se guardo un estado del checkbox, para recordarlo.
		if(sessionStorage.getItem('mostrar')){
			this.mostrar=JSON.parse(sessionStorage.getItem('mostrar'));
		}

		
		//Reconocimiento de voz
		this.reconocimiento=new webkitSpeechRecognition();
		this.reconocimiento.lang='es-ES';
		this.reconocimiento.continuous=false;
		this.reconocimiento.onresult = event => {
			let ok;
			for (const result of event.results) {
			  console.log(result[0].transcript);
			  ok=result[0].transcript.includes("reproducir")
			}
			if(ok){
				this.reproducir=true;
				const event = new ShowToastEvent({
					title: 'Success!',
					message: 'reproducción Activada!',
					variant:'success'
				});
				this.dispatchEvent(event);
			}else{
				const event = new ShowToastEvent({
					title: 'Error!',
					message: 'Comando de voz no encontrado.',
					variant:'error'
				});
				this.dispatchEvent(event);
			}
			
			setTimeout(()=>{
				this.reproducir=false;
			},1000);
		  }
		
	}
}