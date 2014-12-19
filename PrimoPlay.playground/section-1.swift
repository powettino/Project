// Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

let veg = "red pepper"

switch veg {
case "prova":
    let vegt="schifio"
case let x where x.hasSuffix("pepper"):
    let vegt2 = "ciao2 \(veg)"
default:
    let vegt = "def"
}

/*i valori devono essere castati allo stesso tipo altrimenti da errore
Volendo potremmo scriverci una funzione + che fa overload e prende due valori eterogenei*/
var three = 3
var digits = 0.123456
var  pi = Double(three) + digits
var pi2 = three + Int(digits)


/* Si possono assegnare tuple a oggetti che definiscono la struttura interna cosi da poter definire nuove variabili direttamente dai singoli elementi */
var miatupla = (10,20)
var (primo, secondo) = miatupla

/* Si possono anche definire tuple in cui si identifica solo uno dei campi interni, si possono assegnare nomi ai singoli elementi della tupla */
var tuplamista = (codice: 404, desc: "errore", nulla:500)
var (coderr, _ , _ ) = tuplamista
var err = tuplamista.1
var var2 = coderr

/* il toint fa il casta  optional che poi si può controllare se è diverso da nil. Questa pratica èp sconsigliata, in realta si dovrebbe fare qualcosa con il let e il costrutto*/
/* i tipi opzionali sostanzialmente rappresentano i tipi "nullable" di c#, cioè elementi base a cui si aggiugne il tipo null (nil) che normalmente non ci sarebbe */
let miacostante = "1"
var mionumeroOpt = miacostante.toInt()
var mionumeroInt = mionumeroOpt!
if mionumeroOpt != nil{
    var secondonumero = mionumeroOpt!
}
/*versione con il costrutto */
let mia2 = "12"
let mionumOpt = mia2.toInt()
if let f = mionumOpt {
    f
}

/* Per gli optional abbiamo i segnatori ? e !. Il ? definisce la variabile come nullable e ti ritorno l'oggetto opzionale (some o none), se si usa ! si definisce
sempre opzionale ma facendo unwrapping forzato al contenuto. Se non si usa nessuno dei due si definisce la variabile non Nullabel*/
//var base = "2"
//base = nil //errore

//var baseSpecifica : String = "2"
//baseSpecifica = nil //errore

var baseOptGenerica : String? = "2"
baseOptGenerica = nil //corretto e opzionale completo

var baseOptUnwrappaing : String! = "2"
baseOptUnwrappaing = nil //corretto ma solo il valore inserito, senza l'oggetto opzionale
//baseOptUnwrappaing! //errata questa chiamata perchè in questo momento la variabile è definita "nil" e non si può usare il ! perchè nil non è un valore


//Si può definire un array esplicito con i valori o solo il tipo
var aresplicito = [ 1, 2]
var artipatovuoto = [String]()
var artipato : [String] = ["1", "2"]
artipato += ["aggiunto"]
// si può usare il range sugli item array sia per leggere sia per cambiarli (come se fossero tanti assegnamenti diversi)
//Questo metodo funziona solo su elementi già definiti, se lo fai con elementi che non esistono (scrivi in posizioni nil) devi fare l'append esplicito
artipato[0...1]
artipato[1...2] = ["nuovo2", "nuovo3"]
artipato
//artipato[2...3] = ["nuovo4"] //errato perchè accedo a posizioni non esistenti dell'array
artipato += ["nuovo4"] //append corretto
//si possono anche stringere array o allargare sempre con il range
artipato[1...2] = ["2espanso" , "3espanso", "4espanso"] //ora ho 5 elementi dentro perchè le posizioni 1 e 2 sono diventate con 3 elementi
artipato
artipato[1...3] = ["contratto2", "contratto3"] //ora siamo tornati a 4 elemento perchè ho rimosso quello che era in posizione 3 (4espanso)
artipato
artipato[0...3] = artipato[1...3] //viene rimosso l'elemento iniziale dell'array
artipato









