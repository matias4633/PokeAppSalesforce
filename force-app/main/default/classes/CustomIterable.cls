global class CustomIterable implements Iterator<Integer>{ 
    //Defino el comportamiento del iterador.
    List<Integer> lista {get; set;} 
    Integer i {get; set;} 
 
    public CustomIterable(){ 
        List<Integer> cantidad=new List<Integer>();
        for (Integer i = 1; i <= 898; i++) { //Aca defino la cantidad de pokemon que quiero meter. 898
            cantidad.add(i);
        }
        lista=cantidad;

        i = 0; 
    }   
 
    global boolean hasNext(){ 
        if(i >= lista.size()) {
            return false; 
        } else {
            return true; 
        }
    }    
 
    global Integer next(){ 
        i++; 
        return lista[i-1]; 
    } 
 }