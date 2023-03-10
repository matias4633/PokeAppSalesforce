import { LightningElement,api } from 'lwc';
import musica from '@salesforce/resourceUrl/musica';
import pikachu from '@salesforce/resourceUrl/pikachu';
import pikachustop from '@salesforce/resourceUrl/pikachustop';


export default class Reproductor extends LightningElement {
    @api reproducir;
    get musica(){
		return `${musica}`;
	}
    get pikachu(){
		return `${pikachu}`;
	}
    get pikachustop(){
		return `${pikachustop}`;
	}

    renderedCallback(){
        let track = this.template.querySelector('.track');
        let controlBtn = this.template.querySelector('.boton');
        let opacidad=this.template.querySelector('.pikachustop');
        
        if(this.reproducir){
            track.play();
            opacidad.style.opacity='0';
            controlBtn.classList.remove('play');
            controlBtn.classList.add('pause');
        }

        function playPause() {
            if (track.paused) {
                track.play();
                opacidad.style.opacity='0';
                controlBtn.classList.remove('play');
                controlBtn.classList.add('pause');
            } else { 
                track.pause();
                opacidad.style.opacity='1';
                controlBtn.classList.remove('pause');
                controlBtn.classList.add('play');
            }
        }

        controlBtn.addEventListener("click", playPause);
        track.addEventListener("ended", function() { 
            opacidad.style.opacity='1';
            controlBtn.classList.remove('pause');
            controlBtn.classList.add('play');
        });
    }
    

}