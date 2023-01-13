import { LightningElement } from 'lwc';
import musica from '@salesforce/resourceUrl/musica';
import pikachu from '@salesforce/resourceUrl/pikachu';


export default class Reproductor extends LightningElement {
    play=false;
    
    get musica(){
		return `${musica}`;
	}
    get pikachu(){
		return `${pikachu}`;
	}
    renderedCallback(){
        var track = this.template.querySelector('.track');

        var controlBtn = this.template.querySelector('.boton');

        function playPause() {
            if (track.paused) {
                track.play();
                //controlBtn.textContent = "Pause";
                this.play=true;
                controlBtn.classList.remove('play');
                controlBtn.classList.add('pause');
                //controlBtn.className = "pause";
            } else { 
                track.pause();
                this.play=false;
                //controlBtn.textContent = "Play";
                controlBtn.classList.remove('pause');
                controlBtn.classList.add('play');
                //controlBtn.className = "play";
            }
        }

        controlBtn.addEventListener("click", playPause);
        track.addEventListener("ended", function() { 
            controlBtn.classList.remove('pause');
            controlBtn.classList.add('play');
        });
    }
    

}