\// Playground - noun: a place where people can play

import UIKit

//Funzione che prende un array a ritorna una tupla
//Possiamo anche usare un optional mettendo il ? come ritorno
func findMixAndMax(array:[Int]) -> (min: Int, max: Int)?{
    if array.isEmpty{
        return nil
    }
    var minInt = array[0];
    var maxInt = array[0];
    for value in array{
        if value < minInt {
            minInt = value;
        }
        if value > maxInt {
            maxInt = value;
        }
    }
    return (minInt, maxInt)
}

//Per spacchettarlo andrebbe usato il ! altrimenti da errore
let bounds = findMixAndMax([0,1,2,3])

//Proviamo a mettere due nomi ai parametri della funzione
//il primo nome è esterno, mentre il secondo è interno alla funzione. Quando si usano gli stessi nomi, si può usare il #
//Si possono usare valori di default inserendolo nella dichiarazione della funziona con il simbolo "="
//Definendo il nome delle variabili si ingresso si definisce un nome divero per la funzione quindi due funzioni con la stessa firma standard
//ma con nomi di parametri diversi in realtà per il runtime avranno firme intere diverse e quindi non è un overload
func doppionome(parametroFuffa interno: [Int], #stessoConDefault: Int = 20) -> Int{
    //qua si usa il nome "interno"
    return 300
}
//qua si usa il nome "esterno"
//in questo modo possiamo sapere dal nome della funzione i parametri cosa fanno, è solo un modo per avere informazioni maggiori sulle
//proprietà delle funzioni. Se non viene passato un parametro he ha il valore di default viene utilizzato quello.
let nomeEsterno = doppionome(parametroFuffa: [0], stessoConDefault: 2)

let senzasecondovalore = doppionome(parametroFuffa: [0])

//Si possono passare insiemi di valori alle funzioni che vengono interpretati come array
//Se non viene passato niente alla funzione chiamata, l'array interno viene interpretato come esistente ma vuoto
func media (numeri: Double...) ->Double{
    var somma = 0.0
    for numero in numeri{
        somma += numero
    }
    return somma/Double(numeri.count)
}
//non torna niente perchè è come se ottenessi 0/0
let m = media();
//si passa una lista arbitraria
let m2 = media(1,2,3,4.8,5,6.2)


//Si può definire i parametri delle funzioni come modificabili, perchè di default sono costanti all'interno della funzione
//Bisogna ricordarsi che i parametri vengono passati per valore nel caso di "primitivi" o struct o enum, mentre per le classi e gli altri 
//oggetti il passaggio avviene per reference type (questo vuol dire che possono essere modificati)
func paramVar(var param: Int)->Void
{
    param=2
}


//Per forzare il passaggio con reference type si usa il &. Questo non è il puntatore come in C è solo uno shorcut.
//Bisogna fare caso che la keyword inout serve obbligatoriamente per poter passare il valore modificato al chiamante e che esplicita la variabile come var
//inoltre anche la variabile passata nella chiamata della funzione deve essere var poichè sarà modificata
func foo2(inout bar: Int){
    bar = 2
}
//questa chiamata non funziona perchè "NO" è una let
//let NO = 0;
//foo2(&NO)
var b = 0;
foo2(&b)


//Si può definire una funziona come una variabile e assegnarli una funzione particolare. In questo modo si può cambiare la semantica della funzione
func add(a:Int, b:Int)->Int{
    return a+b
}
func mult(a:Int, b:Int)->Int{
    return a*b
}
var math: (Int, Int) -> Int = add
math(2,3)
math = mult
math(2,3)


//Si possono passare anche le funzioni come parametri di altri funzioni
func base(fuffa: (Int) -> Int, a: Int){
    println("Applico fuffa ad a dentro: \(fuffa(a))")
}
func standard(v:Int)->Int{
    return 0
}
var res: () = base(standard, 1)


//Si possono anche annidare funzioni e definire e ottenere come ritorno
func avanti(f: Int) -> Int{
    return f+1
}
func indietro(f:Int) -> Int{
    return f-1
}
//questa funzione sceglie la funzione risultante in base ad un valore di ingresso
func scegli(boh: Bool)->(Int)->Int{
    return boh ? avanti : indietro
}
//il tipo di "scelto" è una funzione che viene chiamata in base alla condizione x > y
var scelto = scegli(1 > 0)
scelto(1)


//Si può definire la cosa precedente ma direttamente annidata all'interno della funzione preservarndo lo scope
func scegli2(scelta: Bool) -> (Int) -> Int{
    func avanti(f:Int)->Int{return f+1}
    func indietro(f:Int)->Int{return f-1}
    return scelta ? avanti : indietro
}
var scelta2 = scegli2(true);
scelta2(1)


//versione compressa del passaggio di funzioni, fare riferimento al manuale a pagina 350 circa
var rev = sorted(["a", "b"],  { $0 > $1 } )


//Proviamo a vedere le chiusure
func incrementor(value: Int)-> () -> Int {
    var counter=0
    //in questo momento viene chiuso il reference type (clonando la variabile) al momento della creazione
    func incr() -> Int {
        counter += value
        return counter
    }
    return incr
}
//Sostanzialmente viene mantenuto lo stato interno di counter che però è solo locale alla funzione definita
var inc1 = incrementor(10)
inc1()
inc1()
var inc2 = incrementor(4)
inc2()
inc2()



//Le enumerazioni sono insieme di valori che poerò possono avere proprietà diverse tra di loro
enum ProvaEnum{
    case primo(Int, Int, Int)
    case secondo(String)
}
var mah = ProvaEnum.primo(1, 1, 1)
mah = .secondo("ciao")
mah = .primo(2, 2, 2)
//Si può utilizzare per estrarre informazioni (si possono passare e salvare anche funzioni)
switch mah {
case let .primo(p, s, t):
    println("V \(p, s, t)")
case let .secondo(uff):
    println("f \(uff)")
}













