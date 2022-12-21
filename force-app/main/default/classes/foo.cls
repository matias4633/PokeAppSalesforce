global class foo implements iterable<Integer>{
    global Iterator<Integer> Iterator(){
       return new CustomIterable();
    } // Es necesaria para que el interador implemente la calse iterable.
 }